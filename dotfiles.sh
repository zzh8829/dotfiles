#!/usr/bin/env bash
# Compatibility entry point; implementation lives in the setup CLI.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$ROOT/setup.sh" install link "$@"
