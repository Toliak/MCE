$global:PSProfileDir = Split-Path -Path $PROFILE

function global:InitOhMyPosh() {
  New-Item -Path $PROFILE -Type File -ErrorAction Ignore

  AddLineIfNotExists `
    $PROFILE `
    "oh-my-posh init pwsh --config `"$PSProfileDir\minimal-theme.json`" | Invoke-Expression" `
    "OhMyPosh init"
}

function global:InstallOhMyPosh() {
  winget install JanDeDobbeleer.OhMyPosh -s winget
}

# Installation
# @writeInformation Log messages
# @throwable
function global:InstallTheModule() {
  InstallOhMyPosh
  Write-Information "Oh My Posh has been installed"

  $DataDir = "$PSScriptRoot\data"
  Copy-Item "$DataDir\*.json" "$PSProfileDir"

  InitOhMyPosh
  Write-Information "Oh My Posh has been configured. Restart the terminal"
}
