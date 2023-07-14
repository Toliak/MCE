#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Vim config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git vim patch)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Vim configuration\n"
  printf "%s\n" "$(formatPrintTheModuleRequired 'Vim Theme')"
  printf "%s\n" "$(formatPrintTheModuleOldConfigurationNotice)"
}
