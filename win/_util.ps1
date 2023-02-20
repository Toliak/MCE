# script directory
$ScriptDir = $PSScriptRoot
$ProjectDir = $ScriptDir
$ProjectRootDir = Split-Path -Parent $ScriptDir
$SharedDataDir = "$ProjectRootDir\shared_data"
$ModulesDir = "$ProjectDir\module"

# ----------
# Modules
# ----------


# @return [string[]] Array of module names
function global:GetAllModules()
{
    $Files = Get-ChildItem -Exclude ".*" -Directory -Path $ModulesDir
    return $Files | ForEach-Object { $_.Name }
}

# @param [string] $ModuleName The module name
# @return [string] Path to the module
function global:GetModulePath($ModuleName)
{
    return "$ModulesDir\$ModuleName"
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

# @param [string] $ModuleName The module name
function global:LoadModuleContext($ModuleName) {
    $ModulePath = GetModulePath $ModuleName

    $InstallFile = "$ModulePath\install.ps1"
    $CheckFile = "$ModulePath\check.ps1"
    $InfoFile = "$ModulePath\info.ps1"

    ClearModuleContext
    . $InstallFile
    . $CheckFile
    . $InfoFile
}

# @param [string] $ModuleName The module name
function global:CheckModule($ModuleName) {
    $Success = $true

    $ModulePath = GetModulePath $ModuleName
    if (-not (Test-Path $ModulePath)) {
        Write-Warning "Module '$ModuleName' not found"
        $Success = $false
    }
    if ($Success -eq $false) {
        throw "Check '$ModuleName' failed"
    }

    $InstallFile = "$ModulePath\install.ps1"
    if (-not (Test-Path $InstallFile)) {
        Write-Warning "Module '$ModuleName' does not have an install.ps1 file"
        $Success = $false
    }
    $CheckFile = "$ModulePath\check.ps1"
    if (-not (Test-Path $CheckFile)) {
        Write-Warning "Module '$ModuleName' does not have a check.ps1 file"
        $Success = $false
    }
    $InfoFile = "$ModulePath\info.ps1"
    if (-not (Test-Path $InfoFile)) {
        Write-Warning "Module '$ModuleName' does not have an info.ps1 file"
        $Success = $false
    }
    if ($Success -eq $false) {
        throw "Check '$ModuleName' failed"
    }

    LoadModuleContext $ModuleName

    GetModuleRequiredFunctions | ForEach-Object {
        if (-not (Test-Path Function:$_)) {
            Write-Warning "Module '$ModuleName' does not have function '$_'"
            $Success = $false
        }
    }
    if ($Success -eq $false) {
        ClearModuleContext
        throw "Check '$ModuleName' failed"
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

function global:InstallModule($ModuleName) {
    $Success = $true
    $ModulePath = GetModulePath $ModuleName
    LoadModuleContext $ModuleName

    Write-Information "Installing module '$ModuleName'"
    Write-Information "Checking required commands"

    GetTheModuleRequiredCommands | ForEach-Object {
        if (-not (CheckCommand $_))
        {
            $Success = $false
        }
    }
    if ($Success -eq $false) {
        throw "Check '$ModuleName' failed"
    }

    Write-Information "Performing before check..."
    if (-not (CheckTheModuleBefore)) {
        throw "Module '$ModuleName' failed before check"
    }

    Write-Information "Performing installation..."
    InstallTheModule

    Write-Information "Performing after check..."
    if (-not (CheckTheModuleAfter)) {
        throw "Module '$ModuleName' failed after check"
    }

    Write-Information "Module '$ModuleName' installed"
}

# @param [string[]] $ModuleNames Module names to check
# @return [bool] True, if all check passed. False, otherwise
function global:CheckAllModulesBeforeAll($ModuleNames) {
    $Status = $true
    $ModuleNames | ForEach-Object {
        Write-Information "Checking module '$_'"
        loadModuleContext $_

        if (-not (CheckTheModuleBeforeAll)) {
            Write-Warning "Module '$_' check beforeAll failed"
            $Status = $false
        }

        clearModuleContext
    }

    return $Status
}

# @return [string] Shortcuts string
function global:GetModuleShortcutsString() {
    return "qwertyuiopasdfghjklzxcvbnm1234567890"
}

# @return [string] Separator string
function global:GetSeparatorString() {
    return "\_____________________________________________________________________________\"
}

# @param [string] $StrToReduce String to reduce
# @return [string] Reduced string
function global:ReduceStringToSingleChar($StrToReduce) {
    $Result = ""
    $StrToReduce | ForEach-Object {
        if (-not ($Result -contains $_)) {
            $Result = "$Result$_"
        }
    }
    return $Result
}

#
#
#   ----- Util Module functions -----
#
#

function global:AddLineIfNotExists($FilePath, $LineToAdd, $LineDescription) {
    $File = Get-ChildItem -Path "$FilePath"
    $Result = $File | Select-String -SimpleMatch "$LineToAdd"
    if ($Result.Length -ne 0) {
        Write-Warning "$LineDescription line already exists in (file $FilePath)"
        return
    }

    Add-Content $PROFILE "$LineToAdd"
}

# @param [string] $Dir Directory path
# @return [boolean] Is VSCode config dir
function global:IsVSCodeConfigDir($Dir) {
    if (-not (Test-Path $Dir)) {
        return $false
    }

    if ((Get-ChildItem -File "$Dir").Length -le 2) {
        return $false
    }
    if ((Get-ChildItem -Directory "$Dir").Length -le 2) {
        return $false
    }

    return $true
}

# @return [string[]] Detected VSCode directories
function global:DetectVsCodeDirectories() {
    $DirsToCheck = @(
        "$env:APPDATA\VSCode"
        "$env:APPDATA\Code"
        "$env:APPDATA\Code-OSS"
    )

    return $DirsToCheck | Where-Object {
        if (IsVSCodeConfigDir $_) {
            Write-Information "Directory '$_' is VSCode config directory"
            return $true
        }

        Write-Information "Directory '$_' is not VSCode config directory"
        return $false
    }
}

# @param [string] $Dir Directory path
# @return [boolean] Is Jetbrains dir
function global:IsJetbrainsDir($Dir) {
    if (-not (Test-Path $Dir)) {
        return $false
    }

    if ((Get-ChildItem -File "$Dir").Length -le 2) {
        return $false
    }
    if ((Get-ChildItem -Directory "$Dir").Length -le 2) {
        return $false
    }

    return $true
}

# @param [string] $Dir Directory path
# @return [boolean] Is Jetbrains config dir
function global:IsJetbrainsConfigDir($Dir) {
    if (-not (Test-Path $Dir)) {
        return $false
    }

    if ((Get-ChildItem -File "$Dir").Length -le 1) {
        return $false
    }

    return $true
}

# @return [string[]] Detected JetBrains directories
function global:DetectJetbrainsConfigDirectories() {
    $DirsToCheck = @(
        "$env:APPDATA\JetBrains"
    )

    return $DirsToCheck | Where-Object {
        if (IsJetbrainsConfigDir $_) {
            Write-Information "Directory '$_' is Jetbrains config directory"
            return $true
        }

        Write-Information "Directory '$_' is not Jetbrains config directory"
        return $false
    }
}

# @param [string] $Dir Directory path
# @return [boolean] Is Jetbrains IDE Config dir
function global:IsJetbrainsIdeConfigDir($Dir) {
    if (-not (Test-Path $Dir)) {
        return $false
    }

    if ((Get-ChildItem -File "$Dir").Length -le 2) {
        return $false
    }
    if ((Get-ChildItem -Directory "$Dir").Length -le 1) {
        return $false
    }

    return $true
}

# @return [string[]] Detected JetBrains IDE Config directories
function global:DetectJetbrainsIdeConfigDirectories($ConfigPath) {
    $DirsToCheck = Get-ChildItem -Directory $ConfigPath | ForEach-Object {
        "$ConfigPath\$_"
    }

    return $DirsToCheck | Where-Object {
        if (IsJetbrainsIdeConfigDir $_) {
            Write-Information "Directory '$_' is Jetbrains Ide Config directory"
            return $true
        }

        Write-Information "Directory '$_' is not Jetbrains Ide Config directory"
        return $false
    }
}
