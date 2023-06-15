#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Vim theme"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git vim)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Ultimate Vim\n"
  printf "Source: \e[1;4;34m%s\e[0m\n" "$(getTheModuleThemeUrl)"
}
