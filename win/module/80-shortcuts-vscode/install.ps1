function global:GetVSCodeShortcutsData() {
  return "$SharedDataDir\shortcuts-vscode"
}

function global:InstallCodeDirectoryConfig($Dir) {
  $DataDir = GetVSCodeShortcutsData
  Copy-Item -Path "$DataDir\*" -Destination "$Dir\User" -Verbose
}

# Installation
# @writeInformation Log messages
# @throwable
function global:InstallTheModule() {
  $Dirs = @(DetectVsCodeDirectories)
  if ($Dirs.Length -eq 0) {
    Write-Warning "No VSCode directories detected"
    return
  }

  $Dir = $Dirs[0]
  Write-Information "Detected VSCode directory: $Dir"

  InstallCodeDirectoryConfig $Dir
}
