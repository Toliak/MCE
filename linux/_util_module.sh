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

# ----------
# Modules specific and shared
# ----------

# @param $1 Directory to check
# @return 0, if the directory is a VSCode directory.
#         1 otherwise
function _isVSCodeConfigDir() {
  local DIR="$1"
  if [ ! -d "$DIR" ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type d | wc -l)" -le 2 ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type f | wc -l)" -le 2 ]; then
    return 1
  fi

  return 0
}

# @stdout The detected directories array
# @stderr Log messages and errors
# @return 0 if a directory found, 1 otherwise
function detectVSCodeConfigDir() {
  local DIRS_TO_CHECK=(
    "$HOME/.config/Code"
    "$HOME/.config/code"
    "$HOME/.config/code-oss"
    "$HOME/.config/Code-OSS"
  )

  local FOUND=()
  local DIR
  for DIR in "${DIRS_TO_CHECK[@]}"; do
    if ! _isVSCodeConfigDir "$DIR"; then
      printf "Directory \e[1;4;34m%s\e[0m is not a VSCode directory\n" \
        "$DIR" >&2
      continue
    fi

    printf "Directory \e[1;4;34m%s\e[0m is a VSCode directory\n" \
      "$DIR" >&2
    FOUND+=("$DIR")
  done

  printf "%s" "${FOUND[*]}"
}

# @param $1 Directory to check
# @return 0, if the directory is a Jetbrains directory.
#         1 otherwise
function _isJetbrainsDir() {
  local DIR="$1"
  if [ ! -d "$DIR" ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type d | wc -l)" -le 1 ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type f | wc -l)" -le 1 ]; then
    return 1
  fi

  return 0
}

# @stdout The detected directory
# @stderr Log messages and errors
# @return 0 if a directory found, 1 otherwise
function detectJetbrainsDir() {
  local DIRS_TO_CHECK=(
    "$HOME/.local/share/JetBrains"
    "$HOME/.JetBrains"
    "/usr/share/JetBrains"
    "/usr/local/share/JetBrains"
  )

  local DIR
  for DIR in ${DIRS_TO_CHECK[*]}; do
    if ! _isJetbrainsDir "$DIR"; then
      printf "Directory \e[1;4;34m%s\e[0m is not a JetBrains directory\n" \
        "$DIR" >&2
      continue
    fi

    printf "Directory \e[1;4;34m%s\e[0m is a JetBrains directory\n" \
      "$DIR" >&2
    printf "%s" "$DIR"
    return 0
  done

  printf "JetBrains directory not found\n" >&2
  return 1
}

# @param $1 Directory to check
# @return 0, if the directory is a Jetbrains directory.
#         1 otherwise
function _isJetbrainsIdeDir() {
  local DIR="$1"
  if [ ! -d "$DIR" ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type d | wc -l)" -le 2 ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type f | wc -l)" -le 2 ]; then
    return 1
  fi

  return 0
}

# @param $1 The Jetbrains IDE directory
# @stdout The detected directory array
# @stderr Log messages and errors
function detectJetbrainsIdeDirs() {
  local DIR="$1"
  local FOUND=()
  for LOCAL_DIR in "$DIR"/*; do
    if [ ! -d "$LOCAL_DIR" ]; then
      printf "Entry \e[1;4;34m%s\e[0m is not a directory\n" \
        "$LOCAL_DIR" >&2
      continue
    fi

    if _isJetbrainsIdeDir "$LOCAL_DIR"; then
      printf "Directory \e[1;4;34m%s\e[0m is a JetBrains IDE directory\n" \
        "$LOCAL_DIR" >&2
      FOUND+=("$LOCAL_DIR")
    else
      printf "Directory \e[1;4;34m%s\e[0m is not a JetBrains IDE directory\n" \
        "$LOCAL_DIR" >&2
    fi
  done
  printf "%s" "${FOUND[*]}"
}

# @param $1 Directory to check
# @return 0, if the directory is a Jetbrains directory.
#         1 otherwise
function _isJetbrainsConfigDir() {
  local DIR="$1"
  if [ ! -d "$DIR" ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type d | wc -l)" -le 1 ]; then
    return 1
  fi
}

# @stdout The detected directory
# @stderr Log messages and errors
# @return 0 if a directory found, 1 otherwise
function detectJetbrainsConfigDir() {
  local DIRS_TO_CHECK=(
    "$HOME/.config/JetBrains"
  )

  local DIR
  for DIR in ${DIRS_TO_CHECK[*]}; do
    if ! _isJetbrainsConfigDir "$DIR"; then
      printf "Directory \e[1;4;34m%s\e[0m is not a JetBrains Config directory\n" \
        "$DIR" >&2
      continue
    fi

    printf "Directory \e[1;4;34m%s\e[0m is a JetBrains Config directory\n" \
      "$DIR" >&2
    printf "%s" "$DIR"
    return 0
  done

  printf "JetBrains Config directory not found\n" >&2
  return 1
}

# @param $1 Directory to check
# @return 0, if the directory is a Jetbrains directory.
#         1 otherwise
function _isJetbrainsIdeConfigDir() {
  local DIR="$1"
  if [ ! -d "$DIR" ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type d | wc -l)" -le 2 ]; then
    return 1
  fi
  if [ "$(find "$DIR" -mindepth 1 -type f | wc -l)" -le 2 ]; then
    return 1
  fi

  return 0
}

# @param $1 The Jetbrains IDE Config directory
# @stdout The detected directory array
# @stderr Log messages and errors
function detectJetbrainsIdeConfigDirs() {
  local DIR="$1"
  local FOUND=()
  for LOCAL_DIR in "$DIR"/*; do
    if [ ! -d "$LOCAL_DIR" ]; then
      printf "Entry \e[1;4;34m%s\e[0m is not a directory\n" \
        "$LOCAL_DIR" >&2
      continue
    fi

    if _isJetbrainsIdeConfigDir "$LOCAL_DIR"; then
      printf "Directory \e[1;4;34m%s\e[0m is a JetBrains Config IDE directory\n" \
        "$LOCAL_DIR" >&2
      FOUND+=("$LOCAL_DIR")
    else
      printf "Directory \e[1;4;34m%s\e[0m is not a JetBrains Config IDE directory\n" \
        "$LOCAL_DIR" >&2
    fi
  done
  printf "%s" "${FOUND[*]}"
}
