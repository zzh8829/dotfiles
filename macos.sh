#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ $# -gt 0 ]] || exec bash "$ROOT/setup.sh"
step=$1
shift
case "$step" in
  help|--help|-h) exec bash "$ROOT/setup.sh" --help ;;
  dotfiles) step='link' ;;
  nodejs) step=node ;;
  homebrew) exec bash "$ROOT/homebrew.sh" "$@" ;;
  signing) exec bash "$ROOT/signing.sh" "$@" ;;
esac
exec bash "$ROOT/setup.sh" install "$step" "$@"
