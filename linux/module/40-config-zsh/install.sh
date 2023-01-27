#! /bin/bash

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  local MODULE_DATA_DIR="$MODULE_DIR/data"
  local ZSHRC="$HOME/.zshrc"

  if [ ! -e "$ZSHRC" ]; then
    printf '\e[34mZshrc\e[0m \e[31mnot found\e[0m\n'
    return 1
  fi

  local DATA_ZSH_CONFIG_LINE="source $MODULE_DATA_DIR/zsh_config"
  local DATA_ALIAS_CONFIG_LINE="source $MODULE_DATA_DIR/alias_config"

  if grep -Fxq "$DATA_ZSH_CONFIG_LINE" "$ZSHRC" && grep -Fxq "$DATA_ALIAS_CONFIG_LINE" "$ZSHRC"; then
    printf '\e[34mZsh bind and aliases\e[0m is \e[32malready installed\e[0m\n'
    return 0
  fi

  local DATA_ALIAS_CONFIG_OS_PATH="$SHARED_DATA_DIR/alias_config_$OS"

  echo "$DATA_ZSH_CONFIG_LINE" >>"$ZSHRC"
  echo "$DATA_ALIAS_CONFIG_LINE" >>"$ZSHRC"

  if [ ! -f "$DATA_ALIAS_CONFIG_OS_PATH" ]; then
    printf '\e[34mAlias \e[0m os-specific config \e[31mnot found\e[0m\n'
  else
    echo "source $DATA_ALIAS_CONFIG_PATH" >>"$ZSHRC"
  fi

  printf '\e[34mZsh bind and aliases\e[0m is \e[32minstalled\e[0m\n'
}
