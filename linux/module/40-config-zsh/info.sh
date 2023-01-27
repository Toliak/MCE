#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Zsh config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git sed zsh)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Zsh configuration (\x1b[31mOld configuration will be removed\x1b[0m)"
}
