using namespace System.Management.Automation

function GetSecurityOptionData {
    param (
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