#! /bin/bash

set -eu

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=linux/module/_util.sh
source "$SCRIPT_DIR/_util.sh"
source "$PROJECT_DIR/misc.sh"
# WARNING: DO NOT USE $SCRIPT_DIR ANYMORE!

function mceLogVariables() {
  printf "Variable \e[34m%s\e[0m = '\e[35m%s\e[0m'\n" \
    "PROJECT_ROOT_DIR" "$PROJECT_ROOT_DIR"
  printf "Variable \e[34m%s\e[0m = '\e[35m%s\e[0m'\n" \
    "PROJECT_DIR" "$PROJECT_DIR"
  printf "Variable \e[34m%s\e[0m = '\e[35m%s\e[0m'\n" \
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
    printf "\e[7m[%s]\e[0m %s -- %s\n" "$SHORTCUT" "$MODULE" "$MODULE_NAME"
    printf "%s\n\n" "$MODULE_DESC"
  done

  printf "\nEnter script letters (square brackets) to install (without spaces):\n"
  local USER_INPUT
  read -r USER_INPUT
  local MODULE_IDS
  MODULE_IDS=$(reduceStringToSingleChar "$USER_INPUT")

  # TODO(toliak): move user_input filtering into the separated function
  printf "\nWill be installed:\n"
  local STRING_LENGTH="${#MODULE_IDS}"
  local I
  for (( I=0; I<"$STRING_LENGTH"; I++ )); do
    local SHORTCUT="${MODULE_IDS:$I:1}"
    local MODULE_ID
    MODULE_ID=$(firstStringContainsCharIndex "$SHORTCUT_STR" "$SHORTCUT")
    if [ "$MODULE_ID" = "${#SHORTCUT_STR}" ] || [ "$MODULE_ID" -ge "${#ALL_MODULES[@]}" ]; then
      printf "Module with ID \e[34m%s\e[0m [%s] \e[31mnot found\e[0m\n" \
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
    printf "[%s] %s -- %s\n" "$SHORTCUT" "$MODULE" "$MODULE_NAME"
  done

  local INSTALL_RESULT
  INSTALL_RESULT="0"
  local I
  for I in "${!ALL_MODULES[@]}"; do
    local MODULE="${ALL_MODULES[$I]}"
    local SHORTCUT="${SHORTCUT_STR:$I:1}"
    local CHAR_ID
    CHAR_ID=$(firstStringContainsCharIndex "$MODULE_IDS" "$SHORTCUT")
    if [ "$CHAR_ID" = "${#MODULE_IDS}" ]; then
      continue
    fi

    printSeparator

    printf "Module [%s] \e[34m%s\e[0m\n" "$SHORTCUT" "$MODULE"
    set +e
    installModule "$MODULE"
    INSTALL_RESULT="$?"
    set -e
    if [ ! "$INSTALL_RESULT" = "0" ]; then
      printf "Module [%s] \e[34m%s\e[0m \e[31minstallation failed\e[0m\n" \
        "$SHORTCUT" "$MODULE"
    fi
  done

  printSeparator

  if [ ! "$INSTALL_RESULT" = "0" ]; then
    return "$INSTALL_RESULT"
  fi
}


mceLogo
printf "\n"
mceWelcomeMessage
printf "\n"
mceLogVariables
mceMain
