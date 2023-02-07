#! /bin/bash

_THE_MODULE_DATA_DIR="$GLOBAL_SHARED_DATA_DIR/shortcuts-vscode"

# @param $1 Directory
# @stdout Log messages
function _installTheModuleIdeKeymap() {
  local DIR="$1"

  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  local KEYMAP_TARGET_DIR="$DIR/User"

  mkdir -p "$KEYMAP_TARGET_DIR"
  cp -f "$_THE_MODULE_DATA_DIR"/* "$KEYMAP_TARGET_DIR/"

  printf "Keymap copied into \e[1;4;34m%s\e[0m\n" "$KEYMAP_TARGET_DIR"
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local STATUS

  local CODE_DIRS
  CODE_DIRS=$(detectVSCodeConfigDir)

  if [ "${CODE_DIRS[*]}" = "" ]; then
    printf "\e[31m%s\e[0m\n" "VSCode Config directory not found"
    return 1
  fi

  printf "VSCode directories:\n"
  printFormatArray "${CODE_DIRS[*]}"

  local DIR
  for DIR in ${CODE_DIRS[*]}; do
    _installTheModuleIdeKeymap "$DIR"
    echo $DIR
  done
}
