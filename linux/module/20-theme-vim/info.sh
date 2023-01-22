#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Vim theme"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Ultimate Vim"
}
