#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
for script in ./*.sh scripts/*.sh scripts/lib/*.sh scripts/tasks/*.sh tests/*.sh; do
  /bin/bash -n "$script"
done
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_*.py' -v
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -x setup.sh scripts/run-task.sh scripts/lib/*.sh scripts/tasks/*.sh tests/run.sh \
    install.sh macos.sh homebrew.sh signing.sh dotfiles.sh shell.sh tools.sh nodejs.sh \
    go.sh python.sh vim.sh sublime.sh linux.sh conda.sh nix.sh
else
  printf 'ShellCheck unavailable; syntax and integration checks completed.\n'
fi
