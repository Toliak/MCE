# @return [string] The module name
function global:GetTheModuleName() {
    return "Powershell Theme"
}

# @return [string[]] The list of commands that are required to be installed
function global:GetTheModuleRequiredCommands() {
    return @("winget")
}

# @return [string] The module description
function global:GetTheModuleDescription() {
    return "Oh My Posh with Honukai config"
}
