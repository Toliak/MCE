#! /bin/bash

function _installTheModuleOhMyZsh() {
  local OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"
  local OH_MY_ZSH_URL="https://github.com/robbyrussell/oh-my-zsh.git"
  if [ -e "$OH_MY_ZSH_PATH" ]; then
    printf '\e[34mOh my ZSH\e[0m is \e[32malready installed\e[0m\n'
    return 0
  fi

  git clone "$OH_MY_ZSH_URL" "$OH_MY_ZSH_PATH" --depth 1
  cp "$OH_MY_ZSH_PATH/templates/zshrc.zsh-template" "$HOME/.zshrc"
  printf '\e[34mOh my ZSH\e[0m is \e[32minstalled\e[0m\n'
}

function _installTheModulePowerlevel() {
  local OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"
  local POWERLEVEL_10K_PATH="$OH_MY_ZSH_PATH/custom/themes/powerlevel10k"
  local POWERLEVEL_10K_URL="https://github.com/romkatv/powerlevel10k.git"
  if [ -e "$POWERLEVEL_10K_PATH" ]; then
    printf '\e[34mPowerLevel 10k\e[0m is \e[32malready installed\e[0m\n'
    return 0
  fi

  git clone "$POWERLEVEL_10K_URL" "$POWERLEVEL_10K_PATH" --depth 1
  sed -i 's/ZSH_THEME="[^"]\+"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' "$HOME/.zshrc"
  printf '\e[34mPowerLevel 10k\e[0m is \e[32minstalled\e[0m\n'
}

function _installTheModuleHighlight() {
  local OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"
  local ZSH_SYNTAX_HIGHLIGHT_PATH="$OH_MY_ZSH_PATH/custom/zsh-syntax-highlighting"
  local ZSH_SYNTAX_HIGHLIGHT_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  if [ -e "$ZSH_SYNTAX_HIGHLIGHT_PATH" ]; then
    printf '\e[34mZSH Syntax Highlighting\e[0m is \e[32malready installed\e[0m\n'
    return 0
  fi

  git clone "$ZSH_SYNTAX_HIGHLIGHT_URL" "$ZSH_SYNTAX_HIGHLIGHT_PATH" --depth 1
  echo "source $ZSH_SYNTAX_HIGHLIGHT_PATH/zsh-syntax-highlighting.zsh" >>"$HOME/.zshrc"
  printf '\e[34mZSH Syntax Highlighting\e[0m is \e[32minstalled\e[0m\n'
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  _installTheModuleOhMyZsh
  _installTheModulePowerlevel
  _installTheModuleHighlight
}
