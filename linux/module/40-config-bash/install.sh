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
    printf '\x1b[34mBashrc \x1b[0m are \x1b[32malready installed\x1b[0m\n'
    return 0
  fi

  echo "source $DATA_BASH_CONFIG_PATH" >>"$BASHRC"
  echo "source $DATA_ALIAS_CONFIG_PATH" >>"$BASHRC"

  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\x1b[34mBashrc \x1b[0m os-specific config \x1b[31mnot found\x1b[0m\n'
  else
    echo "source $DATA_ALIAS_CONFIG_PATH" >>"$BASHRC"
  fi

  printf '\x1b[34mBASHRC configs\x1b[0m is \x1b[32minstalled\x1b[0m\n'
  return 0
}
