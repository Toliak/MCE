function global:GetJetbrainsShortcutsData() {
  return "$SharedDataDir\options-intellij"
}

function global:InstallJetbrainsDirectoryConfig($Dir) {
  $DataDir = GetJetbrainsShortcutsData
  Copy-Item -Path "$DataDir\*" -Destination "$Dir\options\" -Verbose
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
