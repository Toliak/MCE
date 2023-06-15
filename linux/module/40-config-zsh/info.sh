#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Zsh config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git sed zsh)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Zsh configuration\n"
  printf "%s\n" "$(formatPrintTheModuleRequired 'Zsh Theme')"
  printf "%s\n" "$(formatPrintTheModuleOldConfigurationNotice)"
}
