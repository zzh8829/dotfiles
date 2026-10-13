#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ $# -gt 0 ]] || { printf 'Usage: bash signing.sh FULL_GPG_FINGERPRINT [--dry-run]\n'; exit 1; }
fingerprint=$1
shift
exec bash "$ROOT/setup.sh" install signing --fingerprint "$fingerprint" "$@"
