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
  printf "Vim configuration (\e[31mOld configuration will be removed\e[0m)"
}
