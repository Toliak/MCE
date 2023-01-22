#! /bin/bash

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local VIM_RUNTIME="$HOME/.vim_runtime"
  local ULTIMATE_VIM_URL="https://github.com/amix/vimrc.git"

  if [ -e "$VIM_RUNTIME" ]; then
    printf '\x1b[34mUltimate Vim\x1b[0m is \x1b[32malready installed\x1b[0m\n'
    return 0
  fi

  git clone --depth=1 "$ULTIMATE_VIM_URL" "$VIM_RUNTIME"
  sh "$VIM_RUNTIME/install_awesome_vimrc.sh"
  printf '\x1b[34mUltimate Vim\x1b[0m \x1b[32minstalled\x1b[0m\n'
  return 0
}
