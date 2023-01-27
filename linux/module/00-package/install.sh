#! /bin/bash

# @param $1 OS
# @stderr Error messages
# @stdout Package manager install command (may be with arguments)
function _installTheModulePackageInstall() {
  local OS="$1"

  if [ "$OS" = "debian" ]; then
    printf "apt-get install -y"
    return 0
  fi
  if [ "$OS" = "arch" ]; then
    printf "pacman --noconfirm -S"
    return 0
  fi

  printf "_installTheModulePackageInstall: failed, maybe internal error (OS=%s)\n" \
    "$OS" >&2
  return 1
}

# @param $1 OS
# @stderr Error messages
# @stdout Package manager update command (may be with arguments)
function _installTheModulePackageUpdate() {
  local OS="$1"

  if [ "$OS" = "debian" ]; then
    printf "apt-get update -y"
    return 0
  fi
  if [ "$OS" = "arch" ]; then
    printf "pacman --noconfirm -Syy"
    return 0
  fi

  printf "_installTheModulePackageInstall: failed, maybe internal error (OS=%s)\n" \
    "$OS" >&2
  return 1
}

# @param $1 OS
# @stderr Error messages
# @stdout Package names
function _installTheModulePackages() {
  local OS="$1"

  local APPS=(
    "git"
    "zsh"
    "powerline"
    "tmux"
    "vim"
    "curl"
    "xclip"
  )
  if [ "$OS" = "debian" ]; then
    APPS+=()
  elif [ "$OS" = "arch" ]; then
    APPS+=()
  else
    printf "_installTheModulePackageInstall: failed, maybe internal error (OS=%s)\n" \
      "$OS" >&2
    return 1
  fi

  printf "%s" "${APPS[*]}"
}

# TODO(toliak): move into _util.sh
# @param $1 Command
function _installTheModuleSudolify() {
  local CMD="$1"
  if [ "$UID" = "0" ]; then
    printf "%s" "$CMD"
    return
  fi

  printf "sudo %s" "$CMD"
}

# Installation
# @stderr Error messages
# @stdout Log messages
# @return Status
function installTheModule() {
  local MODULE_DIR
  MODULE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  local OS
  OS=$(detectOs)
  echo "OS $OS"

  local PACKAGES
  PACKAGES=($(_installTheModulePackages "$OS"))

  printf "Packages to install:\n"
  printFormatArray "${PACKAGES[*]}"

  local UPDATE_CMD
  UPDATE_CMD=$(_installTheModulePackageUpdate "$OS")
  UPDATE_CMD=$(_installTheModuleSudolify "$UPDATE_CMD")

  # shellcheck disable=SC2086
  $UPDATE_CMD

  local INSTALL_CMD
  INSTALL_CMD=$(_installTheModulePackageInstall "$OS")
  INSTALL_CMD=$(_installTheModuleSudolify "$INSTALL_CMD")

  # shellcheck disable=SC2086
  $INSTALL_CMD ${PACKAGES[*]}
}
