#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Tmux config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git sed tmux)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Tmux configuration (\e[31mOld configuration will be removed\e[0m)"
}
