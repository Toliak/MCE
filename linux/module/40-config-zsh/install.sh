#! /bin/bash

# @stdout Zshrc file path
function getTheModuleZshrc() {
  printf "%s" "$HOME/.zshrc"
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  local MODULE_DATA_DIR="$MODULE_DIR/data"
  local SHARED_DATA_DIR="$MODULE_DIR/../.shared"

  local ZSHRC
  ZSHRC=$(getTheModuleZshrc)
  local OS
  OS=$(detectOs)

  checkAppendTheModuleLineIntoFileSilent \
    "source $MODULE_DATA_DIR/zsh_config" \
    "$ZSHRC" \
    "Zsh additional config"

  checkAppendTheModuleLineIntoFileSilent \
    "source $SHARED_DATA_DIR/alias_config" \
    "$ZSHRC" \
    "Zsh bind and aliases"

  local DATA_ALIAS_CONFIG_OS_PATH="$SHARED_DATA_DIR/alias_config_$OS"
  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\e[34mAlias \e[0m os-specific config \e[31mnot found\e[0m\n'
  else
    checkAppendTheModuleLineIntoFileSilent \
      "source $DATA_ALIAS_CONFIG_OS_PATH" \
      "$ZSHRC" \
      "Zsh OS-specific aliases"
  fi
}
