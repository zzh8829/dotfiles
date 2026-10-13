#!/usr/bin/env bash
set -Eeuo pipefail
DF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DF_OS=$(uname -s)
DF_DRY_RUN=0
DF_BACKUP=0
DF_FINGERPRINT=''
export DF_ROOT DF_OS DF_DRY_RUN DF_BACKUP DF_FINGERPRINT
# shellcheck source=scripts/lib/common.sh
source "$DF_ROOT/scripts/lib/common.sh"
df_prepare_path

TASKS=(tools apps signing-tools shell link asdf node go python vim sublime defaults signing linux conda nix)
LABELS=(
  'Command-line tools (Brewfile)'
  'Applications and Speedtest (Brewfile.apps)'
  'GPG tools (Brewfile.signing)'
  'Zsh and tmux plugin repositories'
  'Link dotfiles into your home directory'
  'asdf plugins (keeps runtime pins unchanged)'
  'Node command-line utilities'
  'Go language server'
  'Python data environment'
  'Vim and Neovim plugins'
  'Sublime Text configuration'
  'macOS preferences, including menu bar spacing'
  'Enable signing with an existing GPG key'
  'Legacy Linux bootstrap (x86_64 only)'
  'Optional Miniconda environment'
  'Optional Nix environment'
)
SELECTED=()
usage() {
  cat <<'HELP'
Dotfiles setup

  ./setup.sh                         Interactive menu (help when not in a terminal)
  ./setup.sh menu                    Choose tasks, preview, then confirm
  ./setup.sh list                    List available tasks
  ./setup.sh plan --all              Preview the full Mac setup without changes
  ./setup.sh install --all           Install the full Mac setup
  ./setup.sh install tools shell link vim
  ./setup.sh install --only tools,shell,link --backup
  ./setup.sh install signing --fingerprint FULL_GPG_FINGERPRINT
  ./setup.sh check                     Check all Brewfiles without installing
  ./setup.sh doctor                  Check basic prerequisites without changes

Options:
  --dry-run          Print commands without running them (also: plan)
  --backup           Back up conflicting dotfiles before linking; default: stop
  --all              Mac tasks 1–12; excludes key configuration, Linux, Conda, Nix
  --only TASKS       Comma-separated selection (task names also work as arguments)
  --fingerprint KEY  Existing GPG signing key; never creates or exports private keys

Tasks run in dependency order, with duplicate selections removed. A failure stops
execution and reports the task to retry. Existing configurations and repositories
are preserved. No arguments or menu cancellation perform any installation.
HELP
}
list_tasks() {
  local i
  for ((i=0; i<${#TASKS[@]}; i++)); do
    printf '  %2d  %-14s %s\n' "$((i+1))" "${TASKS[$i]}" "${LABELS[$i]}"
  done
}
add_task() {
  local requested="$1" known
  for known in "${TASKS[@]}"; do
    if [[ "$known" == "$requested" ]]; then SELECTED+=("$requested"); return; fi
  done
  df_die "Unknown task: $requested. Run ./setup.sh list."
}
add_all() {
  df_macos
  local i
  for ((i=0; i<12; i++)); do add_task "${TASKS[$i]}"; done
}
add_csv() {
  local item
  local items=()
  IFS=',' read -r -a items <<< "$1"
  for item in "${items[@]}"; do add_task "$item"; done
}
order_tasks() {
  local task selected
  local ordered=()
  for task in "${TASKS[@]}"; do
    for selected in "${SELECTED[@]}"; do
      if [[ "$task" == "$selected" ]]; then ordered+=("$task"); break; fi
    done
  done
  SELECTED=("${ordered[@]}")
}
preview() {
  df_log "Selected: ${SELECTED[*]}"
  if [[ "$DF_BACKUP" == 1 ]]; then
    df_log 'Link conflicts: move to a timestamped backup with a JSON restore map.'
  else
    df_log 'Link conflicts: stop without deleting or overwriting files.'
  fi
}
menu() {
  [[ -t 0 ]] || df_die 'The menu requires a terminal. Use plan or install with task names.'
  list_tasks
  printf '\nSelect numbers separated by spaces or commas, or "all" (blank cancels): '
  local answer token index confirm backup
  local choices=()
  IFS= read -r answer || return 0
  [[ -n "$answer" ]] || return 0
  if [[ "$answer" == all ]]; then
    add_all
  else
    answer=${answer//,/ }
    read -r -a choices <<< "$answer"
    for token in "${choices[@]}"; do
      [[ "$token" =~ ^[0-9]+$ ]] || df_die "Invalid selection: $token"
      [[ ${#token} -le 2 ]] || df_die "Invalid selection: $token"
      index=$((10#$token))
      [[ "$index" -ge 1 && "$index" -le "${#TASKS[@]}" ]] || df_die "Invalid selection: $token"
      add_task "${TASKS[$((index-1))]}"
    done
  fi
  order_tasks
  for token in "${SELECTED[@]}"; do
    if [[ "$token" == signing ]]; then
      printf 'Existing full GPG fingerprint: '
      IFS= read -r DF_FINGERPRINT || return 0
    fi
    if [[ "$token" == link ]]; then
      printf 'Back up conflicting files before linking? [y/N]: '
      IFS= read -r backup || return 0
      case "$backup" in y|Y|yes|YES) DF_BACKUP=1 ;; esac
    fi
  done
  preview
  printf 'Install this selection? [y/N]: '
  IFS= read -r confirm || return 0
  case "$confirm" in y|Y|yes|YES) execute ;; *) df_log 'Cancelled; no changes made.' ;; esac
}
execute() {
  local task count=0 status
  # Validate inputs that would otherwise fail after unrelated tasks have run.
  for task in "${SELECTED[@]}"; do
    case "$task" in
      signing) [[ "$DF_FINGERPRINT" =~ ^[[:xdigit:]]{40}$ ]] || df_die 'Signing requires --fingerprint with 40 hexadecimal characters.' ;;
      tools|apps|signing-tools|defaults|sublime) df_macos ;;
      linux) [[ "$DF_OS" == Linux ]] || df_die 'The linux task requires Linux.' ;;
    esac
  done
  export DF_DRY_RUN DF_BACKUP DF_FINGERPRINT
  for task in "${SELECTED[@]}"; do
    count=$((count+1))
    printf '\n[%d/%d] %s\n' "$count" "${#SELECTED[@]}" "$task"
    if bash "$DF_ROOT/scripts/run-task.sh" "$task"; then
      df_log "  OK: $task"
    else
      status=$?
      printf '\nStopped at %s (exit %d). Earlier completed tasks are safe to rerun.\n' "$task" "$status" >&2
      printf 'Retry: %q install %q' "$DF_ROOT/setup.sh" "$task" >&2
      [[ "$DF_BACKUP" != 1 ]] || printf ' --backup' >&2
      [[ -z "$DF_FINGERPRINT" ]] || printf ' --fingerprint %q' "$DF_FINGERPRINT" >&2
      printf '\n' >&2
      exit "$status"
    fi
  done
  if [[ "$DF_DRY_RUN" == 1 ]]; then
    df_log ''; df_log 'Preview complete; no install commands were run.'
  else
    df_log ''; df_log 'Selected tasks completed.'
    df_log 'Manual follow-up as needed: new terminal/login, app permissions, gh auth login, gcloud init.'
  fi
}
doctor() {
  local command failed=0
  df_log "Platform: $DF_OS / $(uname -m)"
  for command in bash git curl stow python3; do
    if command -v "$command" >/dev/null 2>&1; then
      printf '  OK       %s\n' "$command"
    else
      printf '  MISSING  %s\n' "$command"; failed=1
    fi
  done
  if [[ "$DF_OS" == Darwin ]]; then
    if command -v brew >/dev/null 2>&1; then
      df_log '  OK       brew'
    else
      df_log '  MISSING  Homebrew (https://brew.sh)'; failed=1
    fi
  fi
  return "$failed"
}
command=${1:-}
if [[ -z "$command" ]]; then
  if [[ -t 0 ]]; then menu; else usage; fi
  exit 0
fi
shift
case "$command" in
  help|--help|-h) usage; exit 0 ;;
  list) list_tasks; exit 0 ;;
  check) [[ $# == 0 ]] || df_die 'check takes no arguments.'; bash "$DF_ROOT/scripts/run-task.sh" check; exit $? ;;
  doctor) doctor; exit $? ;;
  menu) [[ $# == 0 ]] || df_die 'menu takes no arguments.'; menu; exit 0 ;;
  plan) DF_DRY_RUN=1 ;;
  install|run) ;;
  *) df_die "Unknown command: $command. Run ./setup.sh --help." ;;
esac
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DF_DRY_RUN=1 ;;
    --backup) DF_BACKUP=1 ;;
    --all) add_all ;;
    --only) [[ $# -ge 2 && -n "$2" ]] || df_die '--only needs task names.'; add_csv "$2"; shift ;;
    --fingerprint) [[ $# -ge 2 ]] || df_die '--fingerprint needs a key.'; DF_FINGERPRINT="$2"; shift ;;
    --help|-h) usage; exit 0 ;;
    --*) df_die "Unknown option: $1" ;;
    *) add_task "$1" ;;
  esac
  shift
done
[[ ${#SELECTED[@]} -gt 0 ]] || df_die 'Select tasks or use --all. Run ./setup.sh menu for a guided install.'
order_tasks
preview
execute
