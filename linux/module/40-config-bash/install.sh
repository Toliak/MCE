#! /bin/bash

# @stdout Zshrc file path
function getTheModuleBashrc() {
  printf "%s" "$HOME/.bashrc"
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  local MODULE_DATA_DIR="$MODULE_DIR/data"
  local SHARED_DATA_DIR="$MODULE_DIR/../.shared"
  local DATA_BASH_CONFIG_PATH="$MODULE_DATA_DIR/bash_config"
  local DATA_ALIAS_CONFIG_PATH="$SHARED_DATA_DIR/alias_config"

  local OS
  OS=$(detectOs)
  local BASHRC
  BASHRC=$(getTheModuleBashrc)

  # TODO(toliak): encapsulate
  local DATA_BASH_CONFIG_LINE="source $DATA_BASH_CONFIG_PATH"
  if grep -Fxq "$DATA_BASH_CONFIG_LINE" "$BASHRC"; then
    printf '\e[34mBash config\e[0m is \e[1;33malready installed\e[0m\n'
  else
    echo "$DATA_BASH_CONFIG_LINE" >>"$BASHRC"
    printf '\e[34mBash config\e[0m \e[32minstalled\e[0m\n'
  fi

  local DATA_ALIAS_CONFIG_LINE="source $DATA_ALIAS_CONFIG_PATH"
  if grep -Fxq "$DATA_ALIAS_CONFIG_LINE" "$BASHRC"; then
    printf '\e[34mBash alias config\e[0m is \e[1;33malready installed\e[0m\n'
  else
    echo "$DATA_ALIAS_CONFIG_LINE" >>"$BASHRC"
    printf '\e[34mBash alias config\e[0m \e[32minstalled\e[0m\n'
  fi

  local DATA_ALIAS_CONFIG_OS_PATH="$SHARED_DATA_DIR/alias_config_$OS"
  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\e[34mBashrc \e[0m os-specific config \e[31mnot found\e[0m\n'
  else
    local DATA_ALIAS_CONFIG_OS_LINE="source $DATA_ALIAS_CONFIG_OS_PATH"
    if grep -Fxq "$DATA_ALIAS_CONFIG_OS_LINE" "$BASHRC"; then
      printf '\e[34mBash OS-specific aliases\e[0m are \e[1;33malready installed\e[0m\n' >&2
    else
      echo "$DATA_ALIAS_CONFIG_OS_LINE" >>"$BASHRC"
      printf '\e[34mBash OS-specific aliases\e[0m \e[32m installed\e[0m\n'
    fi
  fi
}
