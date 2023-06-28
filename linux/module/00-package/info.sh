#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Packages"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=()
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Packages: git, zsh,  tmux  \n"
  printf "          vim, curl, xclip \n"
}
