#!/usr/bin/env bash

task_shell() {
  df_require git
  local url relative
  while IFS='|' read -r url relative; do
    df_clone "$url" "$HOME/$relative"
  done < <(df_manifest "$DF_ROOT/manifests/shell.txt")
  df_run mkdir -p "$HOME/bin"
}
task_link() {
  df_require stow 'Run the tools task first.'
  local target="${DOTFILES_TARGET:-$HOME}" package
  local packages=()
  [[ -d "$target" ]] || df_die "Link target must already be a directory: $target"
  while IFS= read -r package; do packages+=("$package"); done < <(df_manifest "$DF_ROOT/manifests/stow.txt")
  if [[ "$DF_BACKUP" == 1 ]]; then
    df_require python3 'Python is required only for --backup.'
    df_run python3 "$DF_ROOT/scripts/lib/backup.py" "$DF_ROOT" "$target" "${packages[@]}"
  fi
  df_run stow --dir="$DF_ROOT" --target="$target" --no-folding --simulate --verbose "${packages[@]}"
  df_run stow --dir="$DF_ROOT" --target="$target" --no-folding --verbose "${packages[@]}"
}
task_defaults() {
  df_macos
  df_run bash "$DF_ROOT/macos-defaults.sh"
}
task_sublime() {
  df_macos
  df_require rsync
  local destination="$HOME/Library/Application Support/Sublime Text/Packages/User"
  if [[ ! -d "$HOME/Library/Application Support/Sublime Text" && -d "$HOME/Library/Application Support/Sublime Text 3" ]]; then
    destination="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
  fi
  df_run mkdir -p "$destination"
  df_run rsync -av --backup --suffix=".backup-$(date +%Y%m%d-%H%M%S)-$$" "$DF_ROOT/data/sublime/" "$destination/"
}
task_signing() {
  local fingerprint="${DF_FINGERPRINT:-}" gpg
  [[ "$fingerprint" =~ ^[[:xdigit:]]{40}$ ]] || df_die 'Signing needs --fingerprint FULL_GPG_FINGERPRINT.'
  df_require gpg 'Run the signing-tools task first.'
  df_require git
  gpg=$(command -v gpg || printf gpg)
  df_run "$gpg" --list-secret-keys "$fingerprint"
  df_run git config --file "$HOME/.gitconfig.local" user.signingkey "$fingerprint"
  df_run git config --file "$HOME/.gitconfig.local" gpg.format openpgp
  df_run git config --file "$HOME/.gitconfig.local" gpg.program "$gpg"
  df_run git config --file "$HOME/.gitconfig.local" commit.gpgsign true
  df_run git config --file "$HOME/.gitconfig.local" tag.gpgsign true
  df_log '  Shared Git configuration must be linked to load ~/.gitconfig.local.'
}
