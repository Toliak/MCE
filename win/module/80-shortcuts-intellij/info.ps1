# @return [string] The module name
function global:GetTheModuleName() {
    return "Shortcuts for IntelliJ"
}

# @return [string[]] The list of commands that are required to be installed
function global:GetTheModuleRequiredCommands() {
    return @()
}

# @return [string] The module description
function global:GetTheModuleDescription() {
    return "UnifiedShortcuts for IntelliJ-based IDEs"
}
