#! /bin/bash

_THE_MODULE_DATA_DIR="$GLOBAL_SHARED_DATA_DIR/options-intellij"

# @param $1 Directory
# @stdout Log messages
function _installTheModuleIdeKeymap() {
  local DIR="$1"

  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  local KEYMAP_TARGET_DIR="$DIR/options"

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

  local JB_DIR
  JB_DIR=$(detectJetbrainsConfigDir)
  STATUS="$?"
  if [ ! "$STATUS" = "0" ]; then
    printf "\e[31m%s\e[0m\n" "JetBrains Config directory not found"
    return 1
  fi
  printf "JetBrains directory: \e[1;4;34m%s\e[0m\n" "$JB_DIR"

  local JB_IDE_DIRS=($(detectJetbrainsIdeConfigDirs "$JB_DIR"))
  if [ "${JB_IDE_DIRS[*]}" = "" ]; then
    printf "\e[31m%s\e[0m\n" "JetBrains IDE Config directories not found"
    return 1
  fi

  printf "IDE Config directories:\n"
  printFormatArray "${JB_IDE_DIRS[*]}"

  local DIR
  for DIR in ${JB_IDE_DIRS[*]}; do
    _installTheModuleIdeKeymap "$DIR"
  done
}
