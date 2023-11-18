#! /bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT_DIR="$SCRIPT_DIR/.."
PROJECT_DIR="$PROJECT_ROOT_DIR/mac"
PROJECT_LINUX_DIR="$PROJECT_ROOT_DIR/linux"

function checkCommand() {
  local COMMAND="$1"
  if ! command -v "$COMMAND" 1>/dev/null 2>/dev/null; then
    printf "checkCommand: Command \"\e[34m%s\e[0m\" \e[31mnot found\e[0m\n" \
      "$COMMAND" >&2
    return 1
  fi

  return 0
}

# TODO: colors
function macPrerequirements() {
    if ! checkCommand "brew" 2&>/dev/null; then
        printf "Homebrew not found. Installing...\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        printf "Homebrew found. ok\n"
    fi
    if ! checkCommand "realpath" 2&>/dev/null; then
        printf "Coreutils not found. Installing...\n"
        brew install -v -f coreutils git
    else
        printf "Coreutils found. ok\n"
    fi

    source "$PROJECT_LINUX_DIR/_util.sh"

    PROJECT_ROOT_DIR=$(realpath "$SCRIPT_DIR/..")
    PROJECT_DIR=$(realpath "$PROJECT_ROOT_DIR/mac")
    PROJECT_LINUX_DIR=$(realpath "$PROJECT_ROOT_DIR/linux")

    return 0;
}

