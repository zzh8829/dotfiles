#!/usr/bin/env bash

task_asdf() {
  df_require asdf
  local name url installed=''
  if command -v asdf >/dev/null 2>&1; then installed=$(asdf plugin list); fi
  while IFS='|' read -r name url; do
    if printf '%s\n' "$installed" | grep -qx "$name"; then
      df_log "  Keeping asdf plugin: $name"
    else
      df_run asdf plugin add "$name" "$url"
    fi
  done < <(df_manifest "$DF_ROOT/manifests/asdf.txt")
  df_log '  Historical runtime pins are unchanged; installing them remains opt-in.'
}
task_node() {
  df_require npm 'Run the tools task first.'
  local package
  local packages=()
  while IFS= read -r package; do packages+=("$package"); done < <(df_manifest "$DF_ROOT/manifests/npm.txt")
  df_run npm install --global "${packages[@]}"
}
task_go() {
  if ! command -v go >/dev/null 2>&1; then
    df_macos
    df_require brew
    df_run brew install go
  fi
  df_run go install golang.org/x/tools/gopls@latest
}
task_python() {
  local python="${DOTFILES_PYTHON:-python3}"
  df_venv "$python" "$HOME/.venv/py3"
  df_run "$HOME/.venv/py3/bin/python" -m pip install -r "$DF_ROOT/requirements-data.txt"
  df_log '  Activate with: source ~/.venv/py3/bin/activate'
}
task_vim() {
  local python="${DOTFILES_PYTHON:-python3}"
  df_require npm 'Run the tools task first.'
  [[ "$DF_DRY_RUN" == 1 || -f "$HOME/.vimrc" ]] || df_die 'Run the link task before vim.'
  if [[ "$DF_DRY_RUN" != 1 ]] && ! command -v nvim >/dev/null 2>&1 && ! command -v vim >/dev/null 2>&1; then
    df_die 'Install Vim or Neovim first.'
  fi
  df_run mkdir -p "$HOME/.vim/undo" "$HOME/.vim/backups" "$HOME/.vim/swaps"
  df_venv "$python" "$HOME/.vim/venv"
  df_run "$HOME/.vim/venv/bin/python" -m pip install pynvim flake8
  if command -v nvim >/dev/null 2>&1 || [[ "$DF_DRY_RUN" == 1 ]]; then
    df_run nvim --headless '+PlugInstall --sync' '+UpdateRemotePlugins' '+qall'
  fi
  if command -v vim >/dev/null 2>&1 || [[ "$DF_DRY_RUN" == 1 ]]; then
    df_run vim -N -u "$HOME/.vimrc" -es '+PlugInstall --sync' '+qall'
  fi
}
