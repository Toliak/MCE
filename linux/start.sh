#! /bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=linux/module/_util.sh
source "$SCRIPT_DIR/_util.sh"
source "$PROJECT_DIR/misc.sh"
# WARNING: DO NOT USE $SCRIPT_DIR ANYMORE!

function mceLogVariables() {
  printf "Variable \x1b[34m%s\x1b[0m = '\x1b[35m%s\x1b[0m'\n" \
    "PROJECT_ROOT_DIR" "$PROJECT_ROOT_DIR"
  printf "Variable \x1b[34m%s\x1b[0m = '\x1b[35m%s\x1b[0m'\n" \
    "PROJECT_DIR" "$PROJECT_DIR"
  printf "Variable \x1b[34m%s\x1b[0m = '\x1b[35m%s\x1b[0m'\n" \
    "MODULES_DIR" "$MODULES_DIR"
}

function mceMain() {
  local ALL_MODULES
  ALL_MODULES=($(getAllModules))

  printf "\nModules to load:\n"
  printFormatArray "${ALL_MODULES[*]}"

  local MODULE
  for MODULE in ${ALL_MODULES[*]}; do
    checkModule "$MODULE"
  done
  checkAllModulesBeforeAll "${ALL_MODULES[*]}"

  printSeparator

  local SHORTCUT_STR
  SHORTCUT_STR="$(getModuleShortcutsString)"

  local I
  for I in "${!ALL_MODULES[@]}"; do
    local MODULE="${ALL_MODULES[$I]}"
    loadModuleContext "$MODULE"
    local MODULE_NAME
    MODULE_NAME=$(getTheModuleName)
    local MODULE_DESC
    MODULE_DESC=$(getTheModuleDescription)

    local SHORTCUT="${SHORTCUT_STR:$I:1}"
    printf "[%s] %s -- %s\n" "$SHORTCUT" "$MODULE_NAME" "$MODULE_DESC"
  done

  printf "\nEnter script letters (square brackets) to install (without spaces):\n"
  local USER_INPUT
  read -r USER_INPUT
  local MODULE_IDS
  MODULE_IDS=$(reduceStringToSingleChar "$USER_INPUT")

  # TODO(toliak): move user_input filtering into the separated function
  printf "Will be installed:\n"
  local STRING_LENGTH="${#MODULE_IDS}"
  local I
  for (( I=0; I<"$STRING_LENGTH"; I++ )); do
    local SHORTCUT="${MODULE_IDS:$I:1}"
    local MODULE_ID
    MODULE_ID=$(firstStringContainsCharIndex "$SHORTCUT_STR" "$SHORTCUT")
    if [ "$MODULE_ID" = "${#SHORTCUT_STR}" ] || [ "$MODULE_ID" -gt "${#ALL_MODULES[@]}" ]; then
      printf "Module with ID \x1b[34m%s\x1b[0m [%s] \x1b[31mnot found\x1b[0m\n" \
        "$MODULE_ID" "$SHORTCUT"
      continue
    fi

    local MODULE="${ALL_MODULES[$MODULE_ID]}"
    loadModuleContext "$MODULE"
    local MODULE_NAME
    MODULE_NAME=$(getTheModuleName)
    local MODULE_DESC
    MODULE_DESC=$(getTheModuleDescription)

    local SHORTCUT="${SHORTCUT_STR:$MODULE_ID:1}"
    printf "[%s] %s -- %s\n" "$SHORTCUT" "$MODULE_NAME" "$MODULE_DESC"
  done

  for (( I=0; I<"$STRING_LENGTH"; I++ )); do
    local SHORTCUT="${MODULE_IDS:$I:1}"
    local MODULE_ID
    MODULE_ID=$(firstStringContainsCharIndex "$SHORTCUT_STR" "$SHORTCUT")
    # TODO(toliak): code duplication
    if [ "$MODULE_ID" = "${#SHORTCUT_STR}" ] || [ "$MODULE_ID" -gt "${#ALL_MODULES[@]}" ]; then
      printf "Module with ID \x1b[34m%s\x1b[0m [%s] \x1b[31mnot found\x1b[0m\n" \
        "$MODULE_ID" "$SHORTCUT"
      continue
    fi

    printSeparator
    printf "Module [%s] \x1b[34m%s\x1b[0m\n" "$SHORTCUT" "$MODULE"
    installModule "$MODULE"
  done

  printSeparator
}


mceLogo
printf "\n"
mceWelcomeMessage
printf "\n"
mceLogVariables
mceMain
