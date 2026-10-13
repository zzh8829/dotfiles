#!/usr/bin/env bash

df_packages() {
  df_macos
  df_require brew 'Install Homebrew from https://brew.sh first.'
  df_run brew bundle --file="$DF_ROOT/$1" --no-upgrade
}
task_tools() { df_packages Brewfile; }
task_apps() { df_packages Brewfile.apps; }
task_signing_tools() { df_packages Brewfile.signing; }
task_check() {
  df_macos
  df_require brew
  local manifest failed=0
  for manifest in Brewfile Brewfile.apps Brewfile.signing; do
    df_run env HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --file="$DF_ROOT/$manifest" || failed=1
  done
  return "$failed"
}
