function global:GetJetbrainsShortcutsData() {
  return "$SharedDataDir\shortcuts-intellij"
}

function global:InstallJetbrainsDirectoryConfig($Dir) {
  $DataDir = GetJetbrainsShortcutsData
  New-Item -Type Directory -Path "$Dir\keymaps" -ErrorAction Ignore
  Copy-Item -Path "$DataDir\*" -Destination "$Dir\keymaps\" -Verbose
}

# Installation
# @writeInformation Log messages
# @throwable
function global:InstallTheModule() {
  $Dirs = @(DetectJetbrainsConfigDirectories)
  if ($Dirs.Length -eq 0) {
    Write-Warning "No Jetbrains Config directories detected"
    return
  }

  $Dir = $Dirs[0]
  Write-Information "Detected Jetbrains Config directory: $Dir"

  DetectJetbrainsIdeConfigDirectories $Dir | ForEach-Object {
    Write-Information "Installing shortcuts into $_"
    InstallJetbrainsDirectoryConfig $_
  }
}
