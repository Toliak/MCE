#! /bin/bash

###############################################################################
###############################################################################
#
#               DO NOT RUN THIS SCRIPT ON YOUR PC
#      THIS SCRIPT MUST BE RAN ONTO TEST ENVIRONMENT ONLY
#
###############################################################################
###############################################################################

set -ue

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "$SCRIPT_DIR/_util.sh"

# @stdout Prints welcome message
function welcome() {
  printf "\n\n"
  printf "\e[7;31mDO NOT RUN THIS SCRIPT ON YOUR PC\e[0m\n"
  printf "\e[7;31mTHIS SCRIPT MUST BE RAN ONTO TEST ENVIRONMENT ONLY\e[0m\n"
  printf "\n\n"
}

# Checks the chmod (644) on tests.sh script
function checkTestsChmod() {
  local FILE_CHMOD
  FILE_CHMOD=$(stat -c '%a' "$PROJECT_DIR/tests.sh")

  if [ ! "$FILE_CHMOD" = "644" ]; then
    printf "Expected chmod 644 on tests.sh file\n"
    return 1
  fi
  return 0
}

# Mocks VSCode environment
function mockVSCodeEnv() {
  local CODE_DIR="$HOME/.local/code-oss"

  mkdir -p "$CODE_DIR/"{"User","logs"}
  mkdir -p "$CODE_DIR/User/"{"snippets","History"}

  touch "$CODE_DIR/"{"Cookies","machineid"}
}

function mockJetbrainsEnv() {
  printf "mockJetbrainsEnv TODO\n" >&2
  return 1
}

function checkAllConfigs() {
  local PATHS=(
  )
  local STATUS="0"
  local I_PATH
  for I_PATH in ${PATHS[*]}; do
    if [ ! -e "$I_PATH" ]; then
      STATUS="1"
      printf "checkAllConfigs: Path \e[1;4;34m%s\e[0m not found\n" "$I_PATH" >&2
    fi
  done

  return "$STATUS"
}

function checkUserConfigs() {
  local PATHS=(
    "$HOME/.zshrc"
    "$HOME/.bashrc"
    "$HOME/.vim_runtime/vimrcs"
    "$HOME/.vim_runtime/my_configs.vim"
    "$HOME/.tmux.conf"
    "$HOME/.tmux.conf.local"
    "$HOME/.oh-my-zsh/custom/zsh-syntax-highlighting"
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    "$HOME/.oh-my-zsh/templates/zshrc.zsh-template"
  )
  local STATUS="0"
  local I_PATH
  for I_PATH in ${PATHS[*]}; do
    if [ ! -e "$I_PATH" ]; then
      STATUS="1"
      printf "checkUserConfigs: Path \e[1;4;34m%s\e[0m not found\n" "$I_PATH" >&2
    fi
  done

  if ! isStringInFile "Bash fixes" "$HOME/.vim_runtime/my_configs.vim"; then
    printf "checkUserConfigs: Line not found 1\n"
  fi
  if ! isStringInFile "source /root/.oh-my-zsh" "$HOME/.zshrc"; then
    printf "checkUserConfigs: Line not found 2\n"
  fi
  if ! isStringInFile "source /project/linux/module" "$HOME/.bashrc"; then
    printf "checkUserConfigs: Line not found 3\n"
  fi

  return "$STATUS"
}

function e2eFullInstallTest() {
  mockVSCodeEnv

  local START_SCRIPT="$PROJECT_DIR/start.sh"
  "$START_SCRIPT" >&3 <<EOF
qwertyuia
EOF

  checkAllConfigs
}

function e2eInstallTest() {
  local START_SCRIPT="$PROJECT_DIR/start.sh"
  "$START_SCRIPT" >&3 <<EOF
qwertyui
EOF

  checkUserConfigs
}

function main() {
  local TESTS
  TESTS=(
    "checkTestsChmod"
    "e2eInstallTest"
  )

  local TEST
  for TEST in ${TESTS[*]}; do
    if ! "$TEST"; then
      printf "Test \e[35m%s\e[0m \e[31mfailed\e[0m\n" "$TEST"
    fi
  done
}

welcome >&2
main 3>&1

