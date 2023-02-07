#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "IntelliJ Shortcut"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "UnifiedShortcuts for IntelliJ"
}
