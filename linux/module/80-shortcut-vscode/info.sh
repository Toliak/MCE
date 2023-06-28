#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "VSCode Shortcut"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "UnifiedShortcuts for VSCode\n"
  printf "%s\n" "$(formatPrintTheModuleRequired 'VSCode')"
  printf "%s\n" "$(formatPrintTheModuleOldConfigurationNotice)"
}
