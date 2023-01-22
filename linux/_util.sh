#! /bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT_DIR=$(realpath "$SCRIPT_DIR/..")
PROJECT_DIR=$(realpath "$PROJECT_ROOT_DIR/linux")
MODULES_DIR=$(realpath "$PROJECT_DIR/module")

# ----------
# Modules
# ----------

# @stdout Array of module names
function getAllModules() {
  local ARRAY=()

  shopt -s nullglob
  local NAME
  for NAME in "$MODULES_DIR"/*; do
    local BASE_NAME
    BASE_NAME=$(basename "$NAME")

    ARRAY+=("$BASE_NAME")
  done
  shopt -u nullglob

  printf "%s" "${ARRAY[*]}"
}

# @param $1 Module name
# @stdout Array of module absolute paths
function getModulePath() {
  local NAME="$1"
  printf "%s" "$MODULES_DIR/$NAME"
}

# @stdout Array of function names
function getModuleRequiredFunctions() {
  local FUNCTIONS=(
    "checkTheModuleBeforeAll"
    "checkTheModuleBefore"
    "checkTheModuleAfter"
    "getTheModuleName"
    "getTheModuleRequiredCommands"
    "getTheModuleDescription"
    "installTheModule"
  )

  printf "%s" "${FUNCTIONS[*]}"
}

function clearModuleContext() {
  local FUN
  for FUN in $(getModuleRequiredFunctions); do
    unset -f "$FUN" 2>/dev/null || true
  done
}

function loadModuleContext() {
  local MODULE_NAME="$1"
  local LOCAL_PATH
  LOCAL_PATH=$(getModulePath "$MODULE_NAME")

  local INSTALL_FILE="$LOCAL_PATH/install.sh"
  local CHECK_FILE="$LOCAL_PATH/check.sh"
  local INFO_FILE="$LOCAL_PATH/info.sh"

  clearModuleContext
  # shellcheck source=linux/module/.template/info.sh
  source "$INSTALL_FILE"
  # shellcheck source=linux/module/.template/check.sh
  source "$CHECK_FILE"
  # shellcheck source=linux/module/.template/install.sh
  source "$INFO_FILE"
}

# @param $1 Module name
# @stderr Error messages
# @return Check result
function checkModule() {
  local MODULE_NAME="$1"
  local LOCAL_PATH
  LOCAL_PATH=$(getModulePath "$MODULE_NAME")

  # Check the directory
  local RESULT="0"
  if [ ! -d "$LOCAL_PATH" ]; then
    printf "Directory '%s' not found\n" "$LOCAL_PATH" >&2
    RESULT="1"
  fi
  if [ ! "$RESULT" = "0" ]; then
    return "$RESULT"
  fi

  # Check the files
  local INSTALL_FILE="$LOCAL_PATH/install.sh"
  local CHECK_FILE="$LOCAL_PATH/check.sh"
  local INFO_FILE="$LOCAL_PATH/info.sh"
  if [ ! -f "$INSTALL_FILE" ]; then
    printf "The Module '%s' Installation file '%s' not found\n" \
      "$MODULE_NAME" "$INSTALL_FILE" >&2
    RESULT="1"
  fi
  if [ ! -f "$CHECK_FILE" ]; then
    printf "The Module '%s' Check file '%s' not found\n" \
      "$MODULE_NAME" "$CHECK_FILE" >&2
    RESULT="1"
  fi
  if [ ! -f "$INFO_FILE" ]; then
    printf "The Module '%s' Information file '%s' not found\n" \
      "$MODULE_NAME" "$INFO_FILE" >&2
    RESULT="1"
  fi
  if [ ! "$RESULT" = "0" ]; then
    return "$RESULT"
  fi

  # Check the context

  clearModuleContext
  # shellcheck source=linux/module/.template/info.sh
  source "$INSTALL_FILE"
  # shellcheck source=linux/module/.template/check.sh
  source "$CHECK_FILE"
  # shellcheck source=linux/module/.template/install.sh
  source "$INFO_FILE"

  local FUN
  for FUN in $(getModuleRequiredFunctions); do
    if [ "$(type -t "$FUN")" == "function" ]; then
      continue
    fi

    printf "The Module '%s' function '%s' not found\n" \
      "$MODULE_NAME" "$FUN" >&2
    RESULT="1"
  done

  clearModuleContext
  return "$RESULT"
}

# @param $1 Module name
# @stderr Error messages
# @stdout Log messages
function installModule() {
  local MODULE_NAME="$1"
  loadModuleContext "$MODULE"

  local MODULE_NAME
  MODULE_NAME=$(getTheModuleName)
  local MODULE_DESC
  MODULE_DESC=$(getTheModuleDescription)

  printf "Installing module \x1b[34m%s\x1b[0m -- %s\n" \
    "$MODULE_NAME" "$MODULE_DESC"

  printf "Checking required commands...\n"
  local COMMANDS
  COMMANDS=($(getTheModuleRequiredCommands))
  local RESULT="0"
  local CMD
  for CMD in ${COMMANDS[*]}; do
    if ! checkCommand "$CMD"; then
      RESULT="1"
    fi
  done
  if [ ! "$RESULT" = "0" ]; then
    return "$RESULT"
  fi

  printf "Performing before check...\n"
  checkTheModuleBefore

  printf "Performing installation process...\n"
  installTheModule

  printf "Performing after check...\n"
  checkTheModuleAfter

  printf "Module \x1b[34m%s\x1b[0m installation complete" "$MODULE_NAME"
}

# @param $1 Array of Module names
# @stderr Error messages
# @stdout Log messages
function checkAllModulesBeforeAll() {
  local MODULE_NAMES="$1"

  local RESULT="0"
  local MODULE
  for MODULE in ${MODULE_NAMES[*]}; do
    loadModuleContext "$MODULE"

    set +e
    checkTheModuleBeforeAll
    local LOCAL_RESULT="$?"
    set -e

    if [ ! "$LOCAL_RESULT" = "0" ]; then
      printf "Module \x1b[34m%s\x1b[0m check (beforeAll) \x1b[31mfailed\x1b[0m\n" "$MODULE"
      RESULT="1"
    fi
  done

  clearModuleContext
  return "$RESULT"
}

# @stdout Shortcuts string
function getModuleShortcutsString() {
  printf "qwertyuiopasdfghjklzxcvbnm1234567890"
}

# ----------
# Misc
# ----------

# @param $1 The command to check
# @stderr Error messages
function checkCommand() {
  local COMMAND="$1"
  if ! command -v "$COMMAND" 1>/dev/null 2>/dev/null; then
    printf "checkCommand: Command \"\e[34m%s\e[0m\" \e[31mnot found\e[0m\n" "$COMMAND"
    return 1
  fi

  return 0
}

# @param $1 Array of strings
# @stdout Formatted array
function printFormatArray() {
  local ARRAY
  ARRAY="$1"
  local ITEM
  for ITEM in ${ARRAY[*]}; do
    printf "%s \x1b[1;34m%s\x1b[0m\n" "-" "$ITEM"
  done
}

# @param $1 Array of strings
# @stdout Separator line
function printSeparator() {
  printf "\x1b[0m\n"
  printf "/_________________________________________________________________________________/\n"
  printf "\x1b[0m\n"
}

# @param $1 String to search in
# @param $2 Char to search for
# @return 0 if the is match, 1 otherwise
function doesStringContainsChar() {
  local SEARCH_IN="$1"
  local SEARCH_FOR="$2"

  if firstStringContainsCharIndex "$SEARCH_IN" "$SEARCH_FOR" >/dev/null; then
    return 0
  fi

  return 1
}

# @param $1 String to search in
# @param $2 Char to search for
# @stdout String index (starts from 0), string length if nothing found
# @result 0 if found, 1 otherwise
function firstStringContainsCharIndex() {
  local SEARCH_IN="$1"
  local SEARCH_FOR="$2"

  local STRING_LENGTH="${#SEARCH_IN}"
  local I
  for (( I=0; I<"$STRING_LENGTH"; I++ )); do
    local SUBSTR="${SEARCH_IN:$I:1}"
    if [ "$SUBSTR" = "$SEARCH_FOR" ]; then
      printf "%s" "$I"
      return 0
    fi
  done

  printf "%s" "$STRING_LENGTH"
  return 1
}

# @param $1 String to reduce
# @stdout String with only one occurance of each character
function reduceStringToSingleChar() {
  local STRING="$1"
  local RESULT=""

  local STRING_LENGTH="${#STRING}"
  local I
  for (( I=0; I<"$STRING_LENGTH"; I++ )); do
    local SUBSTR="${STRING:$I:1}"
    if ! doesStringContainsChar "$RESULT" "$SUBSTR"; then
      RESULT="$RESULT$SUBSTR"
    fi
  done

  printf "%s" "$RESULT"
}