filter Get-SecurityOption {
    <#
    .SYNOPSIS
        Get the value of a security option.
    .DESCRIPTION
        Get the value of a security option.
    .EXAMPLE
        Get-SecurityOption 'Accounts: Administrator account status'

        Gets the current value of the administrator account status policy (determined by the state of the account).
    .EXAMPLE
        Get-SecurityOption 'EnableLUA'

        Get the value of the "User Account Control: Run all administrators in Admin Approval Mode" policy.
    #>

    [CmdletBinding()]
    param (
        # The name of the security option to set.
        [Parameter(Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String[]]$Name
    )

    foreach ($securityOptionInfo in $Name | Resolve-SecurityOption | Sort-Object Category, ShortDescription) {
        try {
            $value = $securityOptionInfo.Default

            if ($securityOptionInfo.Key) {
                Write-Debug ('Registry value type: {0}' -f $securityOption.ValueName)

                if (Test-Path $securityOptionInfo.Key) {
                    $key = Get-Item $securityOptionInfo.Key -ErrorAction Stop

                    if ($key.GetValueNames() -contains $securityOptionInfo.Name) {
                        $value = Get-ItemPropertyValue -Path $securityOptionInfo.Key -Name $securityOptionInfo.Name -ErrorAction Stop
                    }
                }
            } else {
                Write-Debug ('Class-handled value type: {0}' -f $securityOptionInfo.Name)

                $class = NewImplementingType $securityOptionInfo.Class
                $value = $class.Get().Value
            }

            if ($value -ne 'Not Defined') {
                $value = $value -as ($securityOptionInfo.ValueType -as [Type])
            }

            [PSCustomObject]@{
                Name             = $securityOptionInfo.Name
                Description      = $securityOptionInfo.Name
                Value            = $value
                Category         = $securityOptionInfo.Category
                ShortDescription = $securityOptionInfo.ShortDescription
                PSTypeName       = 'Indented.SecurityPolicy.SecurityOptionSetting'
            }
        } catch {
            $innerException = $_.Exception.GetBaseException()
            $errorRecord = [ErrorRecord]::new(
                [InvalidOperationException]::new(
                    ('An error occurred retrieving the security option {0}: {1}' -f $securityOptionInfo.ValueName, $innerException.Message),
                    $innerException
                ),
                'FailedToRetrieveSecurityOptionSetting',
                'OperationStopped',
                $null
            )
            Write-Error -ErrorRecord $errorRecord
        }
    }
}