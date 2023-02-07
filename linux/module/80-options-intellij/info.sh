#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "IntelliJ Preset"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "UI Preset for IntelliJ\n"
  printf "%s\n" "$(formatPrintTheModuleRequired 'Any JetBrains IDE')"
  printf "%s\n" "$(formatPrintTheModuleOldConfigurationNotice)"
}
