#! /bin/bash

# @stdout File path
function getTheModuleTmuxConfLocal() {
  printf "$HOME/.tmux.conf.local"
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  local MODULE_DATA_DIR=$(getModuleDataPath $(basename "$MODULE_DIR"))
  local TMUX_CONF_LOCAL
  TMUX_CONF_LOCAL=$(getTheModuleTmuxConfLocal)

  checkAppendTheModuleLineIntoFileSilent \
    "source -q $MODULE_DATA_DIR/tmux.conf" \
    "$TMUX_CONF_LOCAL" \
    "Additional TMUX configs"

  detectSed -i 's/#set \-g @plugin '"'"'tmux\-plugins\/tmux-cpu'"'"'/set -g @plugin '"'"'tmux-plugins\/tmux-cpu'"'"'/g' "$TMUX_CONF_LOCAL"
  printf '\e[34mtmux-plugins/tmux-cpu\e[0m enabled\n'

  detectSed -i 's/#set \-g @plugin '"'"'tmux\-plugins\/tmux-resurrect'"'"'/set -g @plugin '"'"'tmux-plugins\/tmux-resurrect'"'"'/g' "$TMUX_CONF_LOCAL"
  printf '\e[34mtmux-plugins/tmux-resurrect\e[0m enabled\n'

  return 0
}
