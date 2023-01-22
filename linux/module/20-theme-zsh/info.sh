#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Zsh theme"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Oh My Zsh"
}
