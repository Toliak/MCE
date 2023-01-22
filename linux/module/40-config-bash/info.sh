#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Bash config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(bash)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Bash configuration (\x1b[31mOld configuration will be removed\x1b[0m)"
}
