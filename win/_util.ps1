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

# @param [string] $command The command
# @return [bool] True if the command exists, False otherwise
function global:CheckCommand($command) {
    if (-not (Get-Command $_ -errorAction SilentlyContinue))
    {
        Write-Warning "Required command '$_'"
        return $false
    }
    return $true
}

function global:InstallModule($moduleName) {
    $success = $true
    $modulePath = GetModulePath $moduleName
    LoadModuleContext $moduleName

    Write-Information "Installing module '$moduleName'"
    Write-Information "Checking required commands"

    GetTheModuleRequiredCommands | ForEach-Object {
        if (-not (CheckCommand $_))
        {
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

# @param [string[]] $moduleNames Module names to check
# @return [bool] True, if all check passed. False, otherwise
function global:CheckAllModulesBeforeAll($moduleNames) {
    $status = $true
    $moduleNames | ForEach-Object {
        Write-Info "Checking module '$_'"
        loadModuleContext $_

        if (-not checkTheModuleBeforeAll) {
            Write-Warning "Module '$_' check beforeAll failed"
            $status = $false
        }

        clearModuleContext
    }
    return $status
}

# @return [string] Shortcuts string
function getModuleShortcutsString() {
    return "qwertyuiopasdfghjklzxcvbnm1234567890"
}

# @return [string] Separator string
function getSeparatorString() {
    return "\_____________________________________________________________________________\"
}

# @param [string] $strToReduce String to reduce
# @return [string] Reduced string
function reduceStringToSingleChar($strToReduce) {
    $result = ""
    $strToReduce | ForEach-Object {
        if (-not ($result -contains $_)) {
            $result = "$result$_"
        }
    }
    return $result
}

