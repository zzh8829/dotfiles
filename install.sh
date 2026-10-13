#!/usr/bin/env bash
# Standalone checkout bootstrap. All installation is handled by setup.sh.
set -euo pipefail
DEST="${DOTFILES_DIR:-$HOME/Repos/dotfiles}"
command -v git >/dev/null || { echo 'Install Git first (macOS: xcode-select --install).' >&2; exit 1; }
if [[ -e "$DEST" || -L "$DEST" ]]; then
  [[ -d "$DEST/.git" || -f "$DEST/.git" ]] || { echo "Not a Git checkout: $DEST (preserved)." >&2; exit 1; }
  origin=$(git -C "$DEST" remote get-url origin)
  case "$origin" in
    https://github.com/zzh8829/dotfiles.git|https://github.com/zzh8829/dotfiles|git@github.com:zzh8829/dotfiles.git) ;;
    *) echo "Unexpected origin: $origin (checkout preserved)." >&2; exit 1 ;;
  esac
  echo "Keeping existing checkout: $DEST"
else
  mkdir -p "$(dirname "$DEST")"
  git clone https://github.com/zzh8829/dotfiles.git "$DEST"
fi
printf 'Next: cd %q && ./setup.sh\n' "$DEST"
