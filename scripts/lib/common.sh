#!/usr/bin/env bash
# Shared by the CLI and task modules. Compatible with macOS Bash 3.2.

df_log() { printf '%s\n' "$*"; }
df_die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
df_require() {
  command -v "$1" >/dev/null 2>&1 && return 0
  if [[ "$DF_DRY_RUN" == 1 ]]; then
    df_log "  Prerequisite: $1 (not currently installed)"
  else
    df_die "Missing $1. ${2:-Install it before running this task.}"
  fi
}
df_macos() { [[ "$DF_OS" == Darwin ]] || df_die 'This task requires macOS.'; }
df_run() {
  printf '  +'
  printf ' %q' "$@"
  printf '\n'
  [[ "$DF_DRY_RUN" == 1 ]] || "$@"
}
df_prepare_path() {
  # No package manager invocation or shell configuration is needed to start.
  local prefix
  for prefix in /opt/homebrew /usr/local; do
    if [[ -x "$prefix/bin/brew" ]]; then
      export PATH="$prefix/bin:$prefix/sbin:$PATH"
      break
    fi
  done
}
df_clone() {
  local url="$1" destination="$2" actual
  if [[ -e "$destination" || -L "$destination" ]]; then
    [[ -d "$destination/.git" || -f "$destination/.git" ]] || df_die "Not a Git checkout: $destination (preserved)."
    actual=$(git -C "$destination" remote get-url origin)
    [[ "$actual" == "$url" || "${actual%.git}" == "${url%.git}" ]] || df_die "Unexpected origin at $destination: $actual (preserved)."
    df_log "  Keeping checkout: $destination"
  else
    df_run mkdir -p "$(dirname "$destination")"
    df_run git clone --depth 1 "$url" "$destination"
  fi
}
df_manifest() {
  # One item per line; ignore blank lines and comments. No eval or shell expansion.
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] || printf '%s\n' "$line"
  done < "$1"
}
df_venv() {
  local python="$1" destination="$2"
  df_require "$python"
  if [[ -e "$destination" && ! -x "$destination/bin/python" ]]; then
    df_die "Incomplete or non-virtualenv directory: $destination (preserved)."
  fi
  if [[ ! -x "$destination/bin/python" ]]; then
    df_run "$python" -m venv "$destination"
  fi
}
df_download_installer() {
  local url="$1" shell="$2"
  shift 2
  df_require curl
  if [[ "$DF_DRY_RUN" == 1 ]]; then
    df_log "  Download $url to a temporary file, then run $shell with: $*"
    return
  fi
  (
    local temporary
    temporary=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-installer.XXXXXX")
    trap 'rm -rf -- "$temporary"' EXIT
    curl --fail --show-error --location --retry 3 "$url" -o "$temporary/install.sh"
    "$shell" "$temporary/install.sh" "$@"
  )
}
