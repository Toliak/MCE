#! /bin/sh

set -eu

# Variables initialization
REPO_URL="https://github.com/Toliak/MCE"

set +u
if [ "$1" = "" ]; then
  INSTALL_PATH="$HOME/.local/share/MakeConfigEasier"
else
  INSTALL_PATH="$1"
fi
set -u

printf "Installation path: \x1b[1;4;34m%s\x1b[0m\n" "$INSTALL_PATH"

# @param $1 The command to check
checkCommand() {
  COMMAND="$1"
  if ! command -v "$COMMAND" 1>/dev/null 2>/dev/null; then
    printf "checkCommand: Command \"\e[34m%s\e[0m\" \e[31mnot found\e[0m\n" "$COMMAND"
    return 1
  fi
  return 0
}

# Necessary commands check
checkCommand "bash"
checkCommand "git"

cloneAndInstall() {
  git clone "$REPO_URL" "$INSTALL_PATH"
}

pullAndUpdate() {
  OLD_PWD="$PWD"
  cd "$INSTALL_PATH"
  set +e
  git pull
  RESULT=$?
  set -e
  cd "$OLD_PWD"

  if [ ! "$RESULT" = "0" ]; then
    printf "pullAndUpdate: git pull failed\n"
    return 1
  fi
}

# The entrypoint

if [ -d "$INSTALL_PATH" ]; then
  printf "\x1b[1;33mMakeConfigurationEasier already installed. Updating...\x1b[0m\n"
  pullAndUpdate
else
  printf "Installing...\n"
  cloneAndInstall
fi

bash "$INSTALL_PATH/linux/start.sh"
