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
  if [ "$OS" = "mac" ]; then
    printf "brew install -f -v"
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
  if [ "$OS" = "mac" ]; then
    printf "brew update -f"
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
  )
  local APPS_LINUX=(
    "zsh"
    "powerline"
    "tmux"
    "vim"
    "curl"
    "xclip"
    "patch"
  )
  if [ "$OS" = "debian" ]; then
    APPS=("${APPS[@]}" "${APPS_LINUX[@]}")
  elif [ "$OS" = "arch" ]; then
    APPS=("${APPS[@]}" "${APPS_LINUX[@]}")
  elif [ "$OS" = "mac" ]; then
    APPS=(
      "${APPS[@]}" 
      gnu-sed
      vim
      tmux
      curl
      coreutils
    )
  else
    printf "_installTheModulePackageInstall: failed, maybe internal error (OS=%s)\n" \
      "$OS" >&2
    return 1
  fi

  echo -n "${APPS[*]}"
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
  UPDATE_CMD=$(sudolifyCommand "$UPDATE_CMD")

  # shellcheck disable=SC2086
  $UPDATE_CMD

  local INSTALL_CMD
  INSTALL_CMD=$(_installTheModulePackageInstall "$OS")
  INSTALL_CMD=$(sudolifyCommand "$INSTALL_CMD")

  # shellcheck disable=SC2086
  $INSTALL_CMD ${PACKAGES[*]}
}
