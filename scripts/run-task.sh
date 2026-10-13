#!/usr/bin/env bash
set -Eeuo pipefail
# Tasks run in a fresh process: a failed command cannot be masked by the parent
# CLI's conditional execution or leak shell state into another task.
: "${DF_ROOT:?Run setup.sh instead.}" "${DF_OS:?}" "${DF_DRY_RUN:?}" "${DF_BACKUP:?}"
TASK=${1:?Missing task}
trap 'printf "Task %s failed at %s:%s.\n" "$TASK" "${BASH_SOURCE[0]}" "$LINENO" >&2' ERR
# shellcheck source=scripts/lib/common.sh
source "$DF_ROOT/scripts/lib/common.sh"
# shellcheck source=scripts/tasks/packages.sh
source "$DF_ROOT/scripts/tasks/packages.sh"
# shellcheck source=scripts/tasks/configuration.sh
source "$DF_ROOT/scripts/tasks/configuration.sh"
# shellcheck source=scripts/tasks/development.sh
source "$DF_ROOT/scripts/tasks/development.sh"
# shellcheck source=scripts/tasks/optional.sh
source "$DF_ROOT/scripts/tasks/optional.sh"
case "$TASK" in
  tools|apps|shell|link|asdf|node|go|python|vim|sublime|defaults|signing|linux|conda|nix|check) "task_$TASK" ;;
  signing-tools) task_signing_tools ;;
  *) df_die "Unknown task: $TASK" ;;
esac
