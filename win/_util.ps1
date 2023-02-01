# script directory
$ScriptDir = $PSScriptRoot
$ProjectDir = $ScriptDir
$ProjectRootDir = Split-Path -Parent $ScriptDir
$ModulesDir = "$ProjectDir\module"

# ----------
# Modules
# ----------


# @return [string[]] Array of module names
function global:GetAllModules()
{
    $files = Get-ChildItem -Exclude ".*" -Directory -Path $ModulesDir
    return $files | ForEach-Object { $_.Name }
}

# @param [string] $moduleName The module name
# @return [string] Path to the module
function global:GetModulePath($moduleName)
{
    return "$ModulesDir\$moduleName"
}

# @return [string[]] Array of required function names
function global:GetModuleRequiredFunctions()
{
    return @(
        "CheckTheModuleBeforeAll",
        "CheckTheModuleBefore",
        "CheckTheModuleAfter",
        "GetTheModuleName",
        "GetTheModuleRequiredCommands",
        "GetTheModuleDescription",
        "InstallTheModule"
    )
}

function global:ClearModuleContext() {
    GetModuleRequiredFunctions | ForEach-Object {
        Remove-Item Function:$_ -ErrorAction Ignore
    }
}

# @param [string] $moduleName The module name
function global:LoadModuleContext($moduleName) {
    $modulePath = GetModulePath $moduleName

    $installFile = "$modulePath\install.ps1"
    $checkFile = "$modulePath\check.ps1"
    $infoFile = "$modulePath\info.ps1"

    ClearModuleContext
    . $installFile
    . $checkFile
    . $infoFile
}

# @param [string] $moduleName The module name
function global:CheckModule($moduleName) {
    $success = $true

    $modulePath = GetModulePath $moduleName
    if (-not (Test-Path $modulePath)) {
        Write-Warning "Module '$moduleName' not found"
        $success = $false
    }
    if ($success -eq $false) {
        throw "Check '$moduleName' failed"
    }

    $installFile = "$modulePath\install.ps1"
    if (-not (Test-Path $installFile)) {
        Write-Warning "Module '$moduleName' does not have an install.ps1 file"
        $success = $false
    }
    $checkFile = "$modulePath\check.ps1"
    if (-not (Test-Path $checkFile)) {
        Write-Warning "Module '$moduleName' does not have a check.ps1 file"
        $success = $false
    }
    $infoFile = "$modulePath\info.ps1"
    if (-not (Test-Path $infoFile)) {
        Write-Warning "Module '$moduleName' does not have an info.ps1 file"
        $success = $false
    }
    if ($success -eq $false) {
        throw "Check '$moduleName' failed"
    }

    LoadModuleContext $moduleName

    GetModuleRequiredFunctions | ForEach-Object {
        if (-not (Test-Path Function:$_)) {
            Write-Warning "Module '$moduleName' does not have function '$_'"
            $success = $false
        }
    }
    if ($success -eq $false) {
        ClearModuleContext
        throw "Check '$moduleName' failed"
    }
}

function global:InstallModule($moduleName) {
    $success = $true
    $modulePath = GetModulePath $moduleName
    LoadModuleContext $moduleName

    Write-Information "Installing module '$moduleName'"
    Write-Information "Checking required commands"

    # TODO(toliak): checkCommand
    GetTheModuleRequiredCommands | ForEach-Object {
        if (-not (Get-Command $_ -errorAction SilentlyContinue))
        {
            Write-Warning "Module '$moduleName' requires command '$_'"
            $success = $false
        }
    }
    if ($success -eq $false) {
        throw "Check '$moduleName' failed"
    }

    Write-Information "Performing before check..."
    if (-not (CheckTheModuleBefore)) {
        throw "Module '$moduleName' failed before check"
    }

    Write-Information "Performing installation..."
    InstallTheModule

    Write-Information "Performing after check..."
    if (-not (CheckTheModuleAfter)) {
        throw "Module '$moduleName' failed after check"
    }

    Write-Information "Module '$moduleName' installed"
}

# TODO(toliak): checkAllModulesBeforeAll
# TODO(toliak): getModuleShortcutsString
# TODO(toliak): checkCommand
