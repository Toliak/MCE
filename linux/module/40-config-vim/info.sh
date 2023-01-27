#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Vim config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git vim)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Vim configuration (\x1b[31mOld configuration will be removed\x1b[0m)"
}
