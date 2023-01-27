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
  printf "Bash configuration (\e[31mOld configuration will be removed\e[0m)"
}
