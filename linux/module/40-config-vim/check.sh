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
  local VIM_RUNTIME
  VIM_RUNTIME=$(getTheModuleVimRuntime)
  if [ ! -e "$VIM_RUNTIME" ]; then
    formatPrintTheModuleNotInstalled "Vim Theme" >&2
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
