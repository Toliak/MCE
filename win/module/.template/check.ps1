# The check will be executed before all modules installation started
# @writeWarning Warning messages
# @return [bool] True if the check passed, false otherwise
function global:CheckTheModuleBeforeAll()
{
    Write-Warning "This is a CheckTheModuleBeforeAll"
    return $true;
}

# The check will be executed before the module installation started
# @writeWarning Warning messages
# @return [bool] True if the check passed, false otherwise
function global:CheckTheModuleBefore()
{
    Write-Warning "This is a CheckTheModuleBefore"
    return $true;
}

# The check will be executed after the module installation finished
# @writeWarning Warning messages
# @return [bool] True if the check passed, false otherwise
function global:CheckTheModuleAfter()
{
    Write-Warning "This is a CheckTheModuleAfter"
    return $true;
}
