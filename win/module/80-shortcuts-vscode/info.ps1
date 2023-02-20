# @return [string] The module name
function global:GetTheModuleName() {
    return "Shortcuts for VSCode"
}

# @return [string[]] The list of commands that are required to be installed
function global:GetTheModuleRequiredCommands() {
    return @("code")
}

# @return [string] The module description
function global:GetTheModuleDescription() {
    return "UnifiedShortcuts for VSCode`nOld shortcuts will be removed"
}
