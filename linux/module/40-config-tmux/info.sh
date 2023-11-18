#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Tmux config"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git sed tmux)
  if [ "$(detectOs)" = "mac" ]; then
    ARRAY+=(gsed)
  fi
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Tmux configuration\n"
  printf "%s\n" "$(formatPrintTheModuleRequired 'Tmux Theme')"
  printf "%s\n" "$(formatPrintTheModuleOldConfigurationNotice)"
}
