#! /bin/bash

# @stdout Module name
function getTheModuleName() {
  printf "Zsh theme"
}

# @stdout Array of required commands
function getTheModuleRequiredCommands() {
  ARRAY=(git zsh)
  echo -n ${ARRAY[@]+"${ARRAY[@]}"}
}

# @stdout Module description
function getTheModuleDescription() {
  printf "Oh My Zsh with additions\n"
  printf "Plugin list with sources:\n"
  printf "  %22s: \e[1;4;34m%s\e[0m\n" \
    "Oh My Zsh" "$(getTheModuleOhMyZshUrl)"
  printf "  %22s: \e[1;4;34m%s\e[0m\n" \
    "PowerLevel 10k" "$(getTheModulePowerlevelUrl)"
  printf "  %22s: \e[1;4;34m%s\e[0m\n" \
    "Zsh Syntax Highlight" "$(getTheModuleHighlightUrl)"
}
