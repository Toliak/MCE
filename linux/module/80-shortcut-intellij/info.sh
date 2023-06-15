#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "IntelliJ Shortcut"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "UnifiedShortcuts for IntelliJ\n"
  printf "%s\n" "$(formatPrintTheModuleRequired 'Any JetBrains IDE')"
}
