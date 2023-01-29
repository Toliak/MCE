

# @stdout Message
function formatPrintTheModuleOldConfigurationNotice() {
  printf "\e[1;31mOld configuration will be removed\e[0m"
}

# @param $1 Subject to be required
# @stdout Message
function formatPrintTheModuleRequired() {
  local SUBJECT="$1"
  printf "\e[1;33m%s required\e[0m" "$SUBJECT"
}

# @param $1 Subject is not installed
# @stdout Message
function formatPrintTheModuleNotInstalled() {
  local SUBJECT="$1"
  printf '\e[34m%s\e[0m is \e[31mnot installed\e[0m\n' "$SUBJECT"
}

# @param $1 Line to add into the file
# @param $2 The file path
# @param $3 (Optional) Line description,
#                      that will be shown in the error message
# @stdout Messages
# @stderr Error message
# @return Status. 0 if added successfully, 1 if no change
function checkAppendTheModuleLineIntoFile() {
  local LINE="$1"
  local FILE="$2"

  if grep -Fxq "$LINE" "$FILE"; then
      if [ -z ${3+x} ]; then
        printf 'Line \e[34m%s\e[0m (in file \e[1;4;34m%s\e[0m) \e[1;33malready set\e[0m\n' \
          "$LINE" "$FILE"
      else
        printf '\e[34m%s\e[0m (in file \e[1;4;34m%s\e[0m) \e[1;33malready installed\e[0m\n' \
          "$3" "$FILE"
      fi
      return 1
  fi

  echo "$LINE" >> "$FILE"
  if [ -z ${3+x} ]; then
    printf 'Line \e[34m%s\e[0m append into file \e[1;4;34m%s\e[0m\n' \
      "$LINE" "$FILE"
  else
    printf '\e[34m%s\e[0m installed (into file \e[1;4;34m%s\e[0m)\n' \
      "$3" "$FILE"
  fi
}

# See [checkAppendTheModuleLineIntoFile]
# @return Status. 0 if added successfully or no change performed
function checkAppendTheModuleLineIntoFileSilent() {
  set +e
  checkAppendTheModuleLineIntoFile "$@"
  local STATUS="$?"
  set -e

  if [ "$STATUS" = "0" ] || [ "$STATUS" = "1" ]; then
    return 0
  fi
  return "$STATUS"
}