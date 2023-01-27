#! /bin/bash

# @stdout Logo string
function mceLogo() {
  # Logo original:
  #
  # / __/\\\\____________/\\\\______________/\\\\\\\\\________/\\\\\\\\\\\\\\\_________ /
  # / __\/\\\\\\________/\\\\\\___________/\\\////////________\/\\\///////////_________ /
  # / ___\/\\\//\\\____/\\\//\\\_________/\\\/_________________\/\\\___________________ /
  # / ____\/\\\\///\\\/\\\/_\/\\\________/\\\___________________\/\\\\\\\\\\\__________ /
  # / _____\/\\\__\///\\\/___\/\\\_______\/\\\___________________\/\\\///////__________ /
  # / ______\/\\\____\///_____\/\\\_______\//\\\__________________\/\\\________________ /
  # / _______\/\\\_____________\/\\\________\///\\\________________\/\\\_______________ /
  # / ________\/\\\_____________\/\\\__________\////\\\\\\\\\_______\/\\\\\\\\\\\\\\\__ /
  # / _________\///______________\///______________\/////////________\///////////////__ /

  # Applied regexp /\\/ -> \\\\
  # Applied regexp: /_([/\\])/ -> _\\e[34m$1
  # Applied regexp: /([/\\])_/ -> $1\\e[0m_
  # Applied regexp: /_/ -> " "

  printf '/_________________________________________________________________________________/\n'
  printf '/                                                                                 /\n'
  printf '/__\e[34m/\\\\\\\\\e[0m____________\e[34m/\\\\\\\\\e[0m______________\e[34m/\\\\\\\\\\\\\\\\\\\e[0m________\e[34m/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\e[0m_________/\n'
  printf '/__\e[34m\\/\\\\\\\\\\\\\e[0m________\e[34m/\\\\\\\\\\\\\e[0m___________\e[34m/\\\\\\////////\e[0m________\e[34m\\/\\\\\\///////////\e[0m_________/\n'
  printf '/___\e[34m\\/\\\\\\//\\\\\\\e[0m____\e[34m/\\\\\\//\\\\\\\e[0m_________\e[34m/\\\\\\/\e[0m_________________\e[34m\\/\\\\\\\e[0m___________________/\n'
  printf '/____\e[34m\\/\\\\\\\\///\\\\\\/\\\\\\/\e[0m_\e[34m\\/\\\\\\\e[0m________\e[34m/\\\\\\\e[0m___________________\e[34m\\/\\\\\\\\\\\\\\\\\\\\\\\e[0m__________/\n'
  printf '/_____\e[34m\\/\\\\\\\e[0m__\e[34m\\///\\\\\\/\e[0m___\e[34m\\/\\\\\\\e[0m_______\e[34m\\/\\\\\\\e[0m___________________\e[34m\\/\\\\\\///////\e[0m__________/\n'
  printf '/______\e[34m\\/\\\\\\\e[0m____\e[34m\\///\e[0m_____\e[34m\\/\\\\\\\e[0m_______\e[34m\\//\\\\\\\e[0m__________________\e[34m\\/\\\\\\\e[0m________________/\n'
  printf '/_______\e[34m\\/\\\\\\\e[0m_____________\e[34m\\/\\\\\\\e[0m________\e[34m\\///\\\\\\\e[0m________________\e[34m\\/\\\\\\\e[0m_______________/\n'
  printf '/________\e[34m\\/\\\\\\\e[0m_____________\e[34m\\/\\\\\\\e[0m__________\e[34m\\////\\\\\\\\\\\\\\\\\\\e[0m_______\e[34m\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\e[0m__/\n'
  printf '/_________\e[34m\\///\e[0m______________\e[34m\\///\e[0m______________\e[34m\\/////////\e[0m________\e[34m\\///////////////\e[0m__/\n'
  printf '/                                                                                 /\n'
  printf '/                           Make Configuration Easier                             /\n'
  printf '/                                                                                 /\n'
  printf '/_________________________________________________________________________________/\n'
}

# @stdout Welcome message
function mceWelcomeMessage() {
  printf "Welcome to Make Configuration Easier\n"
}
