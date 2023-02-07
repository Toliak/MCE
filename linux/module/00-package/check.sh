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
  local OS
  OS=$(detectOs)

  if [ "$OS" = "unknown" ]; then
    printf "\e[31mUnable to detect OS. Packages are not available\e[0m\n"
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
