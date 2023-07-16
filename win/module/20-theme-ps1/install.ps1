$global:PSProfileDir = Split-Path -Path $PROFILE

function global:InitOhMyPosh() {
  $DataDir = "$PSScriptRoot\data"

  if (-not (Test-Path $PROFILE)) {
    Write-Information "Profile file not foundm creating a new one ($PROFILE)"
    New-Item -Path $PROFILE -Type File -Force
  }

  AddLineIfNotExists `
    $PROFILE `
    "oh-my-posh init pwsh --config `"$DataDir\minimal-theme.json`" | Invoke-Expression" `
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

  InitOhMyPosh
  Write-Information "Oh My Posh has been configured. Restart the terminal"
}
