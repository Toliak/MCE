#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Tmux theme"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git tmux)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Oh My Tmux\n"
  printf "Source: \e[1;4;34m%s\e[0m\n" "$(getTheModuleThemeUrl)"
}
