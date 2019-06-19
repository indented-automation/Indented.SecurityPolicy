using namespace System.Management.Automation

function GetSecurityOptionData {
    <#
    .SYNOPSIS
        Get option data for the named security option.
    .DESCRIPTION
        Get option data for the named security option.
    #>

    [CmdletBinding()]
    param (
        # The name of the security option.
        [Parameter(Mandatory)]
        [String]$Name
    )

    if ($Script:securityOptionData.Contains($Name)) {
        $securityOptionData = $Script:securityOptionData[$Name]
        if (-not $securityOptionData.Name) {
            $securityOptionData.Name = $Name
        }
        $securityOptionData
    } else {
        $errorRecord = [ErrorRecord]::new(
            [ArgumentException]::new('{0} is an invalid security option name' -f $Name),
            'InvalidSecurityOptionName',
            'InvalidArgument',
            $Name
        )
        throw $errorRecord
    }
}