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
  local BASHRC
  BASHRC=$(getTheModuleBashrc)

  if [ ! -e "$BASHRC" ]; then
    printf '\e[34mBashrc\e[0m \e[1;33mnot found\e[0m. ' >&2
    printf 'The new one will be created\n' >&2
  fi

  return 0
}

# The check will be executed after the module installation complete
# @stderr Error messages
# @return Check status
function checkTheModuleAfter() {
  return 0
}
