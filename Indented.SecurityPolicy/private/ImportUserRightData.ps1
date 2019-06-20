using namespace Indented.SecurityPolicy

function ImportUserRightData {
    <#
    .SYNOPSIS
        Import and merge localized user rights data.
    .DESCRIPTION
        Import and merge localized user rights data.
    #>

    [CmdletBinding()]
    param ( )

    try {
        $params = @{
            FileName        = 'userRights'
            BindingVariable = 'localizedUserRights'
            BaseDirectory   = $myinvocation.MyCommand.Module.ModuleBase
            ErrorAction     = 'Stop'
        }
        Import-LocalizedData @params
    } catch {
        Import-LocalizedData @params -UICulture en
    }

    $Script:userRightData = @{}
    $Script:userRightLookupHelper = @{}

    foreach ($key in $localizedUserRights.Keys) {
        $value = [PSCustomObject]@{
            Name        = [UserRight]$key
            Description = $localizedUserRights[$key]
            PSTypeName  = 'Indented.SecurityPolicy.UserRightInfo'
        }
        $Script:userRightData.Add($key, $value)
        $Script:userRightLookupHelper.Add($value.Description, $key)
    }
}