#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "(WIP) IntelliJ Shortcut"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Shortcut for IntelliJ (\e[31mOld configuration will be removed\e[0m)"
}
