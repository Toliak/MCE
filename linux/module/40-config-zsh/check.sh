#! /bin/bash

# The check will be executed before all modules installation started
# @stderr Error messages
# @return Check status
function checkTheModuleBeforeAll() {
  return 0
}

# The check will be executed before the module installation started
# @stderr Error messages
# @return Check status
function checkTheModuleBefore() {
  local ZSHRC
  ZSHRC=$(getTheModuleZshrc)

  if [ ! -e "$ZSHRC" ]; then
    printf '\e[34mZshrc\e[0m \e[31mnot found\e[0m\n' >&2
    return 1
  fi

  return 0
}

# The check will be executed after the module installation complete
# @stderr Error messages
# @return Check status
function checkTheModuleAfter() {
  return 0
}
