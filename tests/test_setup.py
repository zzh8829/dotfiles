"""Installer integration tests. All writes are confined to temporary fixtures."""
import json
import os
from pathlib import Path
import pty
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='dotfiles-test-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.repo = self.base / 'repo with spaces'
        self.repo.mkdir()
        for directory in ('scripts', 'manifests'):
            shutil.copytree(ROOT / directory, self.repo / directory)
        shutil.copy(ROOT / 'setup.sh', self.repo)
        self.home = self.base / 'home with spaces'
        self.home.mkdir()
        self.env = dict(os.environ, HOME=str(self.home), DOTFILES_TARGET=str(self.home))
        self.env.pop('BASH_ENV', None)
        self.log = self.base / 'tasks.log'
        self.env['TEST_LOG'] = str(self.log)

    def cli(self, *args):
        return subprocess.run(['/bin/bash', str(self.repo / 'setup.sh'), *args],
                              env=self.env, text=True, capture_output=True, timeout=20)

    def stub_runner(self):
        (self.repo / 'scripts/run-task.sh').write_text('''#!/bin/bash
printf '%s\\n' "$1" >> "$TEST_LOG"
if [[ "$1" == "${TEST_FAIL:-}" ]]; then exit 17; fi
''')

    def link_fixture(self):
        (self.repo / 'manifests/stow.txt').write_text('example\n')
        package = self.repo / 'example'
        (package / '.config').mkdir(parents=True)
        (package / '.config/settings').write_text('desired\n')
        ((package / '.example').resolve()).write_text('desired\n')
        return package

    def test_help_and_invalid_input_do_not_execute(self):
        self.stub_runner()
        self.assertEqual(self.cli().returncode, 0)
        for args in [('install',), ('install', 'node', 'bad'), ('install', '--bad'),
                     ('install', 'node', 'signing', '--fingerprint', 'bad')]:
            self.assertNotEqual(self.cli(*args).returncode, 0)
        self.assertFalse(self.log.exists())

    def test_selection_order_and_deduplication(self):
        self.stub_runner()
        result = self.cli('install', '--only', 'vim,node,link,node')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.log.read_text().splitlines(), ['link', 'node', 'vim'])

    def test_failure_stops_and_reports_retry_options(self):
        self.stub_runner()
        self.env['TEST_FAIL'] = 'link'
        result = self.cli('install', 'link', 'node', '--backup')
        self.assertEqual(result.returncode, 17)
        self.assertEqual(self.log.read_text().splitlines(), ['link'])
        self.assertIn('--backup', result.stderr)
        self.assertIn('Retry:', result.stderr)

    def test_plan_does_not_create_files(self):
        self.link_fixture()
        args = ['plan', 'shell', 'link', 'node', 'python', 'vim', '--backup']
        result = self.cli(*args)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(list(self.home.iterdir()), [])
        self.assertIn('no install commands were run', result.stdout)

    def test_menu_cancel(self):
        self.stub_runner()
        master, slave = pty.openpty()
        try:
            child = subprocess.Popen(['/bin/bash', str(self.repo / 'setup.sh'), 'menu'],
                                     stdin=slave, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                     env=self.env, text=True)
            os.write(master, b'7\nn\n')
            stdout, stderr = child.communicate(timeout=10)
            self.assertEqual(child.returncode, 0, stderr)
            self.assertIn('Cancelled', stdout)
            self.assertFalse(self.log.exists())
        finally:
            os.close(master)
            os.close(slave)

    def test_menu_selection(self):
        self.stub_runner()
        master, slave = pty.openpty()
        try:
            child = subprocess.Popen(['/bin/bash', str(self.repo / 'setup.sh'), 'menu'],
                                     stdin=slave, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                     env=self.env, text=True)
            os.write(master, b'8,7,7\ny\n')
            _, stderr = child.communicate(timeout=10)
            self.assertEqual(child.returncode, 0, stderr)
            self.assertEqual(self.log.read_text().splitlines(), ['node', 'go'])
        finally:
            os.close(master)
            os.close(slave)

    @unittest.skipUnless(shutil.which('stow') or Path('/opt/homebrew/bin/stow').exists(), 'GNU Stow required')
    def test_link_conflicts_backups_and_reruns(self):
        package = self.link_fixture()
        conflict = self.home / '.example'
        conflict.write_text('keep me\n')
        result = self.cli('install', 'link')
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(conflict.read_text(), 'keep me\n')
        self.assertFalse((self.home / '.config').exists())
        result = self.cli('install', 'link', '--backup')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(conflict.resolve(), (package / '.example').resolve())
        maps = list(self.home.glob('.dotfiles-backups/*/restore.json'))
        self.assertEqual(len(maps), 1)
        records = json.loads(maps[0].read_text())
        self.assertEqual(Path(records[0]['backup']).read_text(), 'keep me\n')
        result = self.cli('install', 'link', '--backup')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(list(self.home.glob('.dotfiles-backups/*/restore.json'))), 1)

    @unittest.skipUnless(shutil.which('stow') or Path('/opt/homebrew/bin/stow').exists(), 'GNU Stow required')
    def test_backup_does_not_follow_parent_symlinks(self):
        self.link_fixture()
        outside = self.base / 'outside'
        outside.mkdir()
        (outside / 'settings').write_text('untouched')
        (self.home / '.config').symlink_to(outside, target_is_directory=True)
        result = self.cli('install', 'link', '--backup')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((outside / 'settings').read_text(), 'untouched')
        records = json.loads(next(self.home.glob('.dotfiles-backups/*/restore.json')).read_text())
        self.assertTrue(Path(records[0]['backup']).is_symlink())

    def test_clone_refuses_unrelated_directory(self):
        (self.home / '.oh-my-zsh').mkdir()
        sentinel = self.home / '.oh-my-zsh/keep'
        sentinel.write_text('untouched')
        result = self.cli('install', 'shell')
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(sentinel.read_text(), 'untouched')
        self.assertIn('preserved', result.stderr)

    def test_task_error_not_masked_by_later_commands(self):
        mocks = self.base / 'bin'
        mocks.mkdir()
        npm = mocks / 'npm'
        npm.write_text('#!/bin/bash\nexit 23\n')
        npm.chmod(0o755)
        env = dict(self.env, DF_ROOT=str(self.repo), DF_OS='Darwin', DF_DRY_RUN='0',
                   DF_BACKUP='0', PATH=str(mocks) + ':' + os.environ['PATH'])
        result = subprocess.run(['/bin/bash', str(self.repo / 'scripts/run-task.sh'), 'node'],
                                env=env, capture_output=True, text=True, timeout=10)
        self.assertEqual(result.returncode, 23)
        self.assertIn('failed', result.stderr)


if __name__ == '__main__':
    unittest.main()
