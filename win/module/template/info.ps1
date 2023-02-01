# @return [string] The module name
function global:GetTheModuleName() {
    return "Template Module"
}

# @return [string[]] The list of commands that are required to be installed
function global:GetTheModuleRequiredCommands() {
    return @("git")
}

# @return [string] The module description
function global:GetTheModuleDescription() {
    return "Template module description"
}
