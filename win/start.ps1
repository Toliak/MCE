$ErrorActionPreference = "Stop"
$InformationPreference = [System.Management.Automation.ActionPreference]::Continue

. "$PSScriptRoot\_util.ps1"

function MceLogVariables() {
    Write-Information "ProjectRootDir: $ProjectRootDir"
    Write-Information "ProjectDir: $ProjectDir"
    Write-Information "ModulesDir: $ModulesDir"
}

function MceMain() {
    $Modules = @(GetAllModules)
    Write-Information "Module directories:"
    $Modules | ForEach-Object { Write-Information " - $_" }
    Write-Information ""

    $Keychars = GetModuleShortcutsString

    Write-Information "Module list:"
    for ($I = 0; $I -lt $Modules.Length; $I++) {
        $ModuleKey = $Modules[$I]
        $Key = $Keychars[$I]

        ClearModuleContext
        LoadModuleContext $ModuleKey
        $ModuleName = GetTheModuleName
        $ModuleDescription = GetTheModuleDescription
        Write-Information "[$Key] $ModuleKey -- $ModuleName"
        Write-Information "$ModuleDescription"
        Write-Information ""
    }
    ClearModuleContext
    Write-Information ""

    $Keys = Read-Host "Enter script letters (square brackets) to install (without spaces)"
    $Keys = ReduceStringToSingleChar $Keys

    $ToInstall = $Keys.ToCharArray() | Where-Object {
        if ($Keychars.IndexOf($_) -eq -1) {
            Write-Warning "Key [$_] is invalid"
            return $false
        }
        if ($Keychars.IndexOf($_) -ge $Modules.Length) {
            Write-Warning "Module for Key [$_] is not available"
            return $false
        }

        return $true
    } | ForEach-Object {
        $Index = $Keychars.IndexOf($_)
        return $Modules[$Index]
    }

    Write-Information "Modules will be installed:"
    $ToInstall | ForEach-Object {
        ClearModuleContext
        LoadModuleContext $ModuleKey
        $ModuleName = GetTheModuleName
        $Key = $Keychars[$Modules.IndexOf($ModuleKey)]
        Write-Information "[$Key] $ModuleKey -- $ModuleName"
    }
    ClearModuleContext
    Write-Information ""
    
    Write-Information "Checking all Modules before the installation..."
    if (-not (CheckAllModulesBeforeAll $ToInstall)) {
        Write-Error "CheckAllModulesBeforeAll failed. Aborting the installation..."
        return
    }

    Write-Information ""
    Write-Information "Module installation..."

    Write-Information (GetSeparatorString)
    Write-Information ""

    $ToInstall = $ToInstall | Where-Object {
        $ModuleKey = $_
        try
        {
            CheckModule $ModuleKey
        }
        catch
        {
            Write-Warning "Module '$ModuleKey' check failed"
            Write-Warning "Caught exception: $_"
            return $false
        }
        return $true
    }

    $ToInstall | ForEach-Object {
        try
        {
            InstallModule $_
        }
        catch
        {
            Write-Warning "Module '$ModuleKey' installation failed"
            Write-Warning "Caught exception: $_"
        }

        Write-Information (GetSeparatorString)
        Write-Information ""
    }
}

MceLogVariables
MceMain
