#! /bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT_DIR=$(realpath "$SCRIPT_DIR/..")
PROJECT_DIR=$(realpath "$PROJECT_ROOT_DIR/mac")
PROJECT_LINUX_DIR=$(realpath "$PROJECT_ROOT_DIR/linux")

source "$PROJECT_LINUX_DIR/_util.sh"

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

    return 0;
}

