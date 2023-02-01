$ErrorActionPreference = "Stop"
$InformationPreference = [System.Management.Automation.ActionPreference]::Continue

. "$PSScriptRoot\_util.ps1"

function MceLogVariables() {
    Write-Information "ProjectRootDir: $ProjectRootDir"
    Write-Information "ProjectDir: $ProjectDir"
    Write-Information "ModulesDir: $ModulesDir"
}

function MceMain() {
    $modules = GetAllModules
    Write-Information "Modules:"
    $modules | ForEach-Object { Write-Information " - $_" }
    Write-Information ""

    try
    {
        CheckModule "template"
        InstallModule "template"
    }
    catch
    {
        Write-Warning "Caught exception: $_"
        Write-Information "Module 'template' failed"
        return
    }
}

MceLogVariables
MceMain
