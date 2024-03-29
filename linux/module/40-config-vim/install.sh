#! /bin/bash

# @stdout Vim Runtime path
function getTheModuleVimRuntime() {
  echo -n "$HOME/.vim_runtime"
  return
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local VIM_RUNTIME
  VIM_RUNTIME=$( getTheModuleVimRuntime )
  local MODULE_DATA_DIR=$(getModuleDataPath $(basename "$MODULE_DIR"))

  cp "$MODULE_DATA_DIR/my_configs.vim" "$VIM_RUNTIME/my_configs.vim"
  printf '\e[34mUltimate Vim additional config\e[0m \e[32minstalled\e[0m\n'

  patch "$VIM_RUNTIME/vimrcs/basic.vim" < "$MODULE_DATA_DIR/basic.vim.patch"
  printf '\e[34mUltimate Vim\e[0m \e[32mapplied basic.vim patch\e[0m\n'
  return 0
}
