#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
step=${1:-help}
[[ $# == 0 ]] || shift
case "$step" in
  tools|apps) exec bash "$ROOT/setup.sh" install "$step" "$@" ;;
  signing) exec bash "$ROOT/setup.sh" install signing-tools "$@" ;;
  check) exec bash "$ROOT/setup.sh" check "$@" ;;
  help|--help|-h) exec bash "$ROOT/setup.sh" --help ;;
  *) printf 'Unknown Homebrew step: %s\n' "$step" >&2; exit 2 ;;
esac
