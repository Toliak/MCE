$global:PSProfileDir = Split-Path -Path $PROFILE

function global:InitConfigsPs1() {
  New-Item -Path $PROFILE -Type File -ErrorAction Ignore

  AddLineIfNotExists $PROFILE "`$MAKE_CONFIG_EASIER_PATH = `"$ProjectRootDir`"" "Add `$MAKE_CONFIG_EASIER_PATH variable"

  Split-Path -Path "$DataDir\*.ps1" -Leaf -Resolve | ForEach-Object {
    AddLineIfNotExists $PROFILE ". $PSProfileDir\$_" "Init config '$_'"
  }
}

# Installation
# @writeInformation Log messages
# @throwable
function global:InstallTheModule() {
  $DataDir = "$PSScriptRoot\data"

  Copy-Item "$DataDir\*.ps1" "$PSProfileDir"
  Write-Information "Copied MCE configuration files"

  # TODO(toliak): Create original path, without config copy

  InitConfigsPs1
  Write-Information "Add MCE configuration files into the PROFILE"
}
