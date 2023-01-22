#! /bin/bash

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local VIM_RUNTIME="$HOME/.vim_runtime"
  local MODULE_DATA_DIR="$MODULE_DIR/data"

  if [ ! -e "$VIM_RUNTIME" ]; then
    printf '\x1b[34mUltimate Vim\x1b[0m is not \x1b[32minstalled\x1b[0m\n'
    return 1
  fi

  cp "$VIM_RUNTIME/my_configs.vim" "$MODULE_DATA_DIR/my_configs.vim"
  printf '\x1b[34mUltimate Vim additional config\x1b[0m is \x1b[32minstalled\x1b[0m\n'
  return 0
}
