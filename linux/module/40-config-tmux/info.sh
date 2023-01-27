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
  printf "Tmux configuration (\x1b[31mOld configuration will be removed\x1b[0m)"
}
