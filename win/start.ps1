$ErrorActionPreference = "Stop"
$InformationPreference = [System.Management.Automation.ActionPreference]::Continue

. "$PSScriptRoot\_util.ps1"

function MceLogVariables() {
    Write-Information "ProjectRootDir: $ProjectRootDir"
    Write-Information "ProjectDir: $ProjectDir"
    Write-Information "ModulesDir: $ModulesDir"
}

function MceMain() {
    $modules = @(GetAllModules)
    Write-Information "Module directories:"
    $modules | ForEach-Object { Write-Information " - $_" }
    Write-Information ""

    $keychars = GetModuleShortcutsString

    Write-Information "Module list:"
    for ($i = 0; $i -lt $modules.Length; $i++) {
        $moduleKey = $modules[$i]
        $key = $keychars[$i]

        ClearModuleContext
        LoadModuleContext $moduleKey
        $moduleName = GetTheModuleName
        $moduleDescription = GetTheModuleDescription
        Write-Information "[$key] $moduleKey -- $moduleName"
        Write-Information "$moduleDescription"
        Write-Information ""
    }
    ClearModuleContext
    Write-Information ""

    $keys = Read-Host "Enter script letters (square brackets) to install (without spaces)"
    $keys = ReduceStringToSingleChar $keys

    $toInstall = $keys.ToCharArray() | Where-Object {
        if ($keychars.IndexOf($_) -eq -1) {
            Write-Warning "Key [$_] is invalid"
            return $false
        }
        if ($keychars.IndexOf($_) -ge $modules.Length) {
            Write-Warning "Module for key [$_] is not available"
            return $false
        }

        return $true
    } | ForEach-Object {
        $index = $keychars.IndexOf($_)
        return $modules[$index]
    }

    Write-Information "Modules will be installed:"
    $toInstall | ForEach-Object {
        ClearModuleContext
        LoadModuleContext $moduleKey
        $moduleName = GetTheModuleName
        $key = $keychars[$modules.IndexOf($moduleKey)]
        Write-Information "[$key] $moduleKey -- $moduleName"
    }
    ClearModuleContext
    Write-Information ""
    
    Write-Information "Checking all modules before the installation..."
    if (-not (CheckAllModulesBeforeAll $toInstall)) {
        Write-Error "CheckAllModulesBeforeAll failed. Aborting the installation..."
        return
    }

    Write-Information ""
    Write-Information "Module installation..."

    Write-Information (GetSeparatorString)
    Write-Information ""

    $toInstall = $toInstall | Where-Object {
        $moduleKey = $_
        try
        {
            CheckModule $moduleKey
        }
        catch
        {
            Write-Warning "Module '$moduleKey' check failed"
            Write-Warning "Caught exception: $_"
            return $false
        }
        return $true
    }

    $toInstall | ForEach-Object {
        try
        {
            InstallModule $_
        }
        catch
        {
            Write-Warning "Module '$moduleKey' installation failed"
            Write-Warning "Caught exception: $_"
        }

        Write-Information (GetSeparatorString)
        Write-Information ""
    }
}

MceLogVariables
MceMain
