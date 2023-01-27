#! /bin/bash

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local OH_MY_TMUX_PATH="$HOME/.local/share/oh-my-tmux"
  local OH_MY_TMUX_URL="https://github.com/gpakosz/.tmux.git"

  if [ -e "$OH_MY_TMUX_PATH" ]; then
    printf '\e[34mOh My TMUX\e[0m is \e[1;33malready installed\e[0m\n'
    return 0
  fi

  git clone "$OH_MY_TMUX_URL" "$OH_MY_TMUX_PATH"
  rm -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.local"
  ln -s -f "$OH_MY_TMUX_PATH/.tmux.conf" "$HOME/.tmux.conf"
  cp "$OH_MY_TMUX_PATH/.tmux.conf.local" "$HOME/.tmux.conf.local"

  printf '\e[34mOh My TMUX\e[0m is \e[32minstalled\e[0m\n'
  return 0
}
