# @return [string] The module name
function global:GetTheModuleName() {
    return "Options for IntelliJ"
}

# @return [string[]] The list of commands that are required to be installed
function global:GetTheModuleRequiredCommands() {
    return @()
}

# @return [string] The module description
function global:GetTheModuleDescription() {
    return "UI Options for IntelliJ-based IDEs`nOld configuration files will be removed"
}
