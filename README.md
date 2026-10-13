# Zihao’s dotfiles

One entry point for setup:

```sh
cd ~/Repos/dotfiles
./setup.sh
```

Choose task numbers separated by spaces or commas, review the selection, then
confirm. Choose `all` for the full Mac setup. Blank input or declining confirmation
cancels. When input is not a terminal, running without arguments prints help.
The menu uses Bash, with no extra UI dependency.

```text
   1  tools          Command-line tools (Brewfile)
   2  apps           Applications and Speedtest (Brewfile.apps)
   3  signing-tools  GPG tools (Brewfile.signing)
   4  shell          Zsh and tmux plugin repositories
   5  link           Link dotfiles into your home directory
   6  asdf           asdf plugins (keeps runtime pins unchanged)
   7  node           Node command-line utilities
   8  go             Go language server
   9  python         Python data environment
  10  vim            Vim and Neovim plugins
  11  sublime        Sublime Text configuration
  12  defaults       macOS preferences, including menu bar spacing
  13  signing        Enable signing with an existing GPG key
  14  linux          Legacy Linux bootstrap (x86_64 only)
  15  conda          Optional Miniconda environment
  16  nix            Optional Nix environment
```

## Preview or install directly

```sh
./setup.sh plan --all                       # print commands without installing
./setup.sh install --all                    # full Mac setup, tasks 1–12
./setup.sh install tools shell link vim     # selected tasks
./setup.sh install --only tools,apps,node   # equivalent comma-separated form
./setup.sh install link --backup            # preserve conflicts before linking
./setup.sh doctor                           # basic prerequisite check
./setup.sh check                            # check all three Brewfiles
```

Explicit `install` commands run immediately. Selections are deduplicated and run
in the displayed order. Prerequisites are not silently added to a subset: choose
`tools` before language tooling, and `shell` and `link` before editor setup on a
fresh machine. Tasks stop at the first failure and print a retry command. Earlier
completed tasks remain installed; there is no automatic rollback. Rerunning uses
existing repositories and virtual environments. Package/plugin commands may
fetch newer versions according to their existing manifests; this is not a locked
or offline build.

`plan` and `--dry-run` print intended commands and may inspect existing Git/asdf
state. They do not execute installation commands or fully validate downloads,
Stow conflicts, permissions, or network availability.

## First machine prerequisites

Install Apple’s Command Line Tools (`xcode-select --install`) and Homebrew from
https://brew.sh. These installers may require administrator interaction. Then
clone this repository, or run the standalone `install.sh` checkout helper:

```sh
git clone https://github.com/zzh8829/dotfiles.git ~/Repos/dotfiles
cd ~/Repos/dotfiles
./setup.sh
```

`install.sh` respects `DOTFILES_DIR`, preserves an existing checkout, and checks
its origin. It does not pull updates or install packages. Keep this repository
at its final location after linking: your home dotfiles point into it.

## Package and configuration sources

The framework does not change your existing package selections or dotfile contents.

| Source | Purpose |
| --- | --- |
| `Brewfile` | CLI tools and runtimes |
| `Brewfile.apps` | Desktop apps and Ookla Speedtest |
| `Brewfile.signing` | GnuPG and macOS pinentry |
| `requirements-data.txt` | Python data packages |
| `manifests/npm.txt` | Node global packages |
| `manifests/asdf.txt` | asdf plugins and repository URLs |
| `manifests/shell.txt` | Zsh/tmux plugins and destinations |
| `manifests/stow.txt` | Configuration packages to link |
| `macos-defaults.sh` | macOS preferences, including menu bar spacing |

Homebrew tasks use `brew bundle --no-upgrade`. Existing shell/plugin checkouts
are checked for the expected origin and kept without resets, deletion, or pulls.
The historical versions in `asdf/.tool-versions` remain unchanged and are not
installed automatically. Activate the Python environment using
`source ~/.venv/py3/bin/activate`; `DOTFILES_PYTHON` selects the Python executable
used to create it and the editor environment.

## Linking and backups

By default, GNU Stow simulates the entire selection and stops on conflicts before
creating links. With `--backup` (also offered in the menu), conflicting paths are
moved into a private directory under `~/.dotfiles-backups/setup-*`. Each run writes
`restore.json` with original and backup paths before moving anything. Unrelated
files are retained. A conflicting directory symlink is moved as a link; its target
is not traversed or modified.

To recover a file, inspect the restore map, verify the current original path,
remove only its replacement symlink if present, and move the corresponding saved
path back. A partially completed backup may have map entries whose moves have not
yet happened; inspect both paths first. Backups are never removed automatically.
Sublime uses rsync with adjacent timestamped backups of overwritten files.

`DOTFILES_TARGET` changes only the Stow destination (including its backup directory)
and must name an existing directory. Other tasks still use your home directory.

## Signing and manual follow-up

The full Mac profile installs signing tools but does not create or select keys.
To select an existing GPG key:

```sh
./setup.sh install signing --fingerprint FULL_GPG_FINGERPRINT
```

This verifies that a secret key is available and writes machine-specific signing
settings to `~/.gitconfig.local`, included by the shared Git configuration.
Private keys remain outside this repository. SSH/GPG key creation, registering
public keys with GitHub, `gh auth login`, `gcloud init`, app sign-ins and permissions,
and Docker’s first launch remain manual. Open a new terminal after setup and log
out/in if macOS preferences need refreshing. Administrator prompts can still occur
inside package installers and cannot be deferred by this CLI.

## Layout and compatibility

`setup.sh` owns selection, preview, validation, ordering, and progress. It executes
each task in a separate Bash process through `scripts/run-task.sh`, so command
failures stop reliably. `scripts/lib/common.sh` holds shared command, prerequisite,
clone, download, and virtualenv helpers; `scripts/tasks/` groups implementations.
The framework supports the macOS system Bash 3.2.

Previous root scripts delegate to the same implementation. For example,
`bash macos.sh tools`, `bash homebrew.sh apps`, `bash dotfiles.sh`, `bash tools.sh`
(asdf), and `bash signing.sh FINGERPRINT` still work. `bash macos.sh` now opens the
menu when used interactively. Direct wrappers accept `--dry-run`.

Linux, Miniconda, and Nix are explicit alternatives, excluded from `--all`. Linux
retains its historical x86_64 package versions and repository choices, whose
availability depends on the distribution. These optional tasks have not been
live-tested on another OS. Miniconda chooses the host architecture; Nix may require
a new terminal followed by rerunning its task. `data/osx.sh` remains a historical
reference and is never run by this CLI.

## Verify changes to the framework

```sh
bash tests/run.sh
```

Tests use temporary homes/checkouts, mocked task execution, and real GNU Stow when
available. They cover the menu, validation, ordering, error propagation, dry runs,
conflicts, backups, symlink handling, and reruns without installing software.
The runner also checks Bash syntax and runs ShellCheck when available.
