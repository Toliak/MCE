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
  printf "Additional bash configuration\n"
  printf "%s\n" "$(formatPrintTheModuleOldConfigurationNotice)"
}
