#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SCRIPT_DIR/prerequirements.sh"
# WARNING: DO NOT USE $SCRIPT_DIR ANYMORE!


# @stdout Welcome message
function mceMacWelcomeMessage() {
  printf "Welcome to Make Configuration Easier (OSX wrapper)\n"
}

mceMacWelcomeMessage
printf "\n"

macPrerequirements
bash "$PROJECT_LINUX_DIR/start.sh"
