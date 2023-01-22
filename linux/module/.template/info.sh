#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Template module"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git bash)
  printf "%s" "${ARRAY[*]}"
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Template module description"
}
