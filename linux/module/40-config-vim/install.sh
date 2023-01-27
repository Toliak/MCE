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
    printf '\e[34mUltimate Vim\e[0m is not \e[32minstalled\e[0m\n'
    return 1
  fi

  cp "$VIM_RUNTIME/my_configs.vim" "$MODULE_DATA_DIR/my_configs.vim"
  printf '\e[34mUltimate Vim additional config\e[0m is \e[32minstalled\e[0m\n'
  return 0
}
