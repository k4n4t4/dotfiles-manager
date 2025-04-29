#!/usr/bin/env dash
set -eu


if ! command -v -- "realpath" > /dev/null 2>&1; then
  echo '"realpath" is not exist.' >&2
  exit 1
fi

FILE_PATH="$(realpath "$0")"
WORK_PATH="${FILE_PATH%"/"*}"
case "$WORK_PATH" in ( "" )
  WORK_PATH="/"
esac

SHELL_PATH="$(realpath "/proc/$$/exe")"
SHELL_NAME="${SHELL_PATH##*"/"}"
case "$SHELL_NAME" in
  ( bash )
    # shellcheck disable=SC3044
    shopt -s expand_aliases
    ;;
  ( zsh )
    emulate -R sh
    ;;
  ( yash | dash | ksh93 | busybox ) : ;;
  ( * )
    echo "\"$SHELL_PATH\" is not supported." >&2
    exit 1
    ;;
esac

KERNEL_NAME="$(uname -s)"
case "$KERNEL_NAME" in
  ( Linux* ) : ;;
  ( * )
    echo "\"$KERNEL_NAME\" is not supported." >&2
    exit 1
    ;;
esac


. "$WORK_PATH/libs/utils/func.sh"

. "$WORK_PATH/libs/commands/usage.sh"
. "$WORK_PATH/libs/commands/dot.sh"


SUBCOMMAND=""

main() {
  [ $# -eq 0 ] && set -- help

  case "$1" in
    ( help | h | usage | '-?' | '-h' | '--help' )
      SUBCOMMAND="help"
      commands_usage
      ;;
    ( install | i )
      SUBCOMMAND="install"
      shift
      commands_run "$@"
      ;;
    ( uninstall | u )
      SUBCOMMAND="uninstall"
      shift
      commands_run "$@"
      ;;
    ( check | c )
      SUBCOMMAND="check"
      shift
      commands_run "$@"
      ;;
    ( debug | d )
      SUBCOMMAND="debug"
      msg_info "Information"
      msg_log "        HOME = \"$HOME\""
      msg_log "         PWD = \"$PWD\""
      msg_log "   FILE_PATH = \"$FILE_PATH\""
      msg_log "   WORK_PATH = \"$WORK_PATH\""
      msg_log "  SHELL_PATH = \"$SHELL_PATH\""
      msg_log "  SHELL_NAME = \"$SHELL_NAME\""
      msg_log " KERNEL_NAME = \"$KERNEL_NAME\""
      msg_log "  SUBCOMMAND = \"$SUBCOMMAND\""
      ;;
    ( * )
      msg_error "Invalid Sub Command: \"$1\""
      SUBCOMMAND="help"
      commands_usage
      return 1
      ;;
  esac
}

main "$@"
