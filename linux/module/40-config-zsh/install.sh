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

  # TODO(toliak): encapsulate
  local DATA_ZSH_CONFIG_LINE="source $MODULE_DATA_DIR/zsh_config"
  if grep -Fxq "$DATA_ZSH_CONFIG_LINE" "$ZSHRC"; then
    printf '\e[34mZsh additional config\e[0m is \e[1;33malready installed\e[0m\n' >&2
  else
    echo "$DATA_ZSH_CONFIG_LINE" >>"$ZSHRC"
    printf '\e[34mZsh additional config\e[0m \e[32minstalled\e[0m\n'
  fi

  local DATA_ALIAS_CONFIG_LINE="source $SHARED_DATA_DIR/alias_config"
  if grep -Fxq "$DATA_ALIAS_CONFIG_LINE" "$ZSHRC"; then
    printf '\e[34mZsh bind and aliases\e[0m are \e[1;33malready installed\e[0m\n' >&2
  else
    echo "$DATA_ALIAS_CONFIG_LINE" >>"$ZSHRC"
    printf '\e[34mZsh bind and aliases\e[0m \e[32minstalled\e[0m\n'
  fi

  local DATA_ALIAS_CONFIG_OS_PATH="$SHARED_DATA_DIR/alias_config_$OS"
  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\e[34mAlias \e[0m os-specific config \e[31mnot found\e[0m\n'
  else
    local DATA_ALIAS_CONFIG_OS_LINE="source $DATA_ALIAS_CONFIG_OS_PATH"
    if grep -Fxq "$DATA_ALIAS_CONFIG_OS_LINE" "$ZSHRC"; then
      printf '\e[34mZsh OS-specific aliases\e[0m are \e[1;33malready installed\e[0m\n' >&2
    else
      echo "$DATA_ALIAS_CONFIG_OS_LINE" >>"$ZSHRC"
      printf '\e[34mZsh OS-specific aliases\e[0m \e[32m installed\e[0m\n'
    fi
  fi
}
