#!/bin/bash

######
###### VARS
######

declare _SCRIPT_NAME="${0##*/}"
declare _SCRIPT_VERSION="1.0"
declare _INSTALL_DIR="$(cd "$(dirname "$0")" && echo "$PWD")"

_SHOW_VERSION() {
  _PRINT_INFO "${_SCRIPT_NAME} ${_SCRIPT_VERSION}"
}

_PRINT_COLOR() {
    local _color="%s"
    case "$1" in
        default)
            _color='\e[0;39m%b\e[0m';;
        red)
            _color='\e[0;31m%b\e[0m';; # red
        blue)
            _color='\e[0;34m%b\e[0m';; # blue
        yellow)
            _color='\e[0;33m%b\e[0m';; # yellow
        green)
            _color='\e[0;32m%b\e[0m';; # green
        cyan)
            _color='\e[0;36m%b\e[0m';; # cyan
        error|bred)
            _color='\e[1;31m%b\e[0m';; # bold red
        skip|bblue)
            _color='\e[1;34m%b\e[0m';; # bold blue
        warn|byellow)
            _color='\e[1;33m%b\e[0m';; # bold yellow
        pass|bgreen)
            _color='\e[1;32m%b\e[0m';; # bold green
        info|bcyan)
            _color='\e[1;36m%b\e[0m';; # bold cyan
    esac
    shift
    printf "$_color" "$*"
}

_PRINT_INFO() {
  _PRINT_COLOR info "$*\n"
}

_PRINT_ERROR() {
  _PRINT_COLOR error "ERROR $*\n" >&2
}

_PRINT_WARN() {
  _PRINT_COLOR warn "WARNING $*\n" >&2
}

_PRINT() {
  _PRINT_COLOR default "$*\n"
}

_ARGS_OPT() {
OPTS=($@)

if [[ ${#OPTS[@]} > 1 ]]; then
  _PRINT_ERROR "Too much options '${@#}'"
  USAGE
  _PRINT_ERROR "Try '${_SCRIPT_NAME} --help' for more information"
  exit 1
fi

if [[ "$OPTS" ]];  then
  if [[ "$OPTS" =~ ^-h$ ]]; then
    USAGE_FULL
    exit 0
  elif [[ "$OPTS" =~ ^-V$ ]]; then
    _SHOW_VERSION
    exit 0
  elif [[ "$OPTS" =~ ^-i$ ]]; then
    INSTALL_SCRIPT
  elif [[ "$OPTS" =~ ^-u$ ]]; then
    UNINSTALL_SCRIPT
  elif [[ "$OPTS" =~ ^--help$ ]]; then
    USAGE_FULL
    exit 0
  elif [[ "$OPTS" =~ ^--version$ ]]; then
    _SHOW_VERSION
    exit 0
  # no option
  else
    _PRINT_ERROR "invalid option '${@#}'"
    USAGE
    _PRINT_ERROR "Try '${_SCRIPT_NAME} --help' for more information"
    exit 1
  fi
else
  _PRINT_ERROR "No option given"
  USAGE
  _PRINT_ERROR "Try '${_SCRIPT_NAME} --help' for more information"
  exit 1
fi
}

_CHECK_MD5() {
    md5sum "$1" | awk '{print $1}'
}
