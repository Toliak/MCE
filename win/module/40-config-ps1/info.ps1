# @return [string] The module name
function global:GetTheModuleName() {
    return "Powershell config"
}

# @return [string[]] The list of commands that are required to be installed
function global:GetTheModuleRequiredCommands() {
    return @()
}

# @return [string] The module description
function global:GetTheModuleDescription() {
    return "Powershell config with aliases"
}
