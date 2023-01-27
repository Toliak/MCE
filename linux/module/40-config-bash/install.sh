#! /bin/bash

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local OS
  OS=$(detectOs)

  local MODULE_DATA_DIR="$MODULE_DIR/data"
  local SHARED_DATA_DIR="$MODULE_DIR/../.shared"
  local DATA_BASH_CONFIG_PATH="$MODULE_DATA_DIR/bash_config"
  local DATA_ALIAS_CONFIG_PATH="$SHARED_DATA_DIR/alias_config"
  local BASHRC="$HOME/.bashrc"

  local DATA_ALIAS_CONFIG_OS_PATH="$SHARED_DATA_DIR/alias_config_$OS"

  if grep -Fxq "source $DATA_BASH_CONFIG_PATH" "$BASHRC" && grep -Fxq "source $DATA_ALIAS_CONFIG_PATH" "$BASHRC"; then
    printf '\e[34mBashrc \e[0m are \e[32malready installed\e[0m\n'
    return 0
  fi

  echo "source $DATA_BASH_CONFIG_PATH" >>"$BASHRC"
  echo "source $DATA_ALIAS_CONFIG_PATH" >>"$BASHRC"

  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\e[34mBashrc \e[0m os-specific config \e[31mnot found\e[0m\n'
  else
    echo "source $DATA_ALIAS_CONFIG_PATH" >>"$BASHRC"
  fi

  printf '\e[34mBASHRC configs\e[0m is \e[32minstalled\e[0m\n'
  return 0
}
