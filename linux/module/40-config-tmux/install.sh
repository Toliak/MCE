#! /bin/bash

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local MODULE_DATA_DIR="$MODULE_DIR/data"
  local ZSHRC="$HOME/.zshrc"
  if [ ! -e "$ZSHRC" ]; then
    printf '\e[34mZshrc\e[0m \e[31mnot found\e[0m\n'
    return 1
  fi

  local DATA_TMUX_CONF_LINE="source -q $MODULE_DATA_DIR/tmux.conf"

  if grep -Fxq "$DATA_TMUX_CONF_LINE" "$HOME/.tmux.conf.local"; then
      printf '\e[34mAdditional TMUX configs\e[0m is \e[32malready installed\e[0m\n'
      return 0
  fi

  echo "$DATA_TMUX_CONF_LINE" >>"$HOME/.tmux.conf.local"
  printf '\e[34mAdditional TMUX configs\e[0m is \e[32minstalled\e[0m\n'

  sed -i 's/#set \-g @plugin '"'"'tmux\-plugins\/tmux-cpu'"'"'/set -g @plugin '"'"'tmux-plugins\/tmux-cpu'"'"'/g' "$HOME/.tmux.conf.local"
  printf '\e[34mtmux-plugins/tmux-cpu\e[0m enabled\n'

  sed -i 's/#set \-g @plugin '"'"'tmux\-plugins\/tmux-resurrect'"'"'/set -g @plugin '"'"'tmux-plugins\/tmux-resurrect'"'"'/g' "$HOME/.tmux.conf.local"
  printf '\e[34mtmux-plugins/tmux-resurrect\e[0m enabled\n'

  return 0
}
