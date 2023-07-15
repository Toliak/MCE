#! /bin/bash

# @stdout Zshrc file path
function getTheModuleBashrc() {
  echo -n "$HOME/.bashrc"
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  local MODULE_DATA_DIR=$(getModuleDataPath $(basename "$MODULE_DIR"))
  local DATA_BASH_CONFIG_PATH="$MODULE_DATA_DIR/bash_config"
  local DATA_ALIAS_CONFIG_PATH="$SHARED_DATA_DIR/alias_config"

  local OS
  OS=$(detectOs)
  local BASHRC
  BASHRC=$(getTheModuleBashrc)

  checkAppendTheModuleLineIntoFileSilent \
    "\$MAKE_CONFIG_EASIER_PATH=\"$PROJECT_ROOT_DIR\"" \
    "$BASHRC" \
    "Bash MAKE_CONFIG_EASIER_PATH variable"

  checkAppendTheModuleLineIntoFileSilent \
    "source $DATA_BASH_CONFIG_PATH" \
    "$BASHRC" \
    "Bash additional config"

  checkAppendTheModuleLineIntoFileSilent \
    "source $DATA_ALIAS_CONFIG_PATH" \
    "$BASHRC" \
    "Bash alias config"

  local DATA_ALIAS_CONFIG_OS_PATH="$SHARED_DATA_DIR/alias_config_$OS"
  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\e[34mBashrc \e[0m os-specific config \e[31mnot found\e[0m\n'
  else
    checkAppendTheModuleLineIntoFileSilent \
      "source $DATA_ALIAS_CONFIG_OS_PATH" \
      "$BASHRC" \
      "Bash OS-specific aliases"
  fi
}
