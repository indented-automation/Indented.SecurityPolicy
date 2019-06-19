using namespace System.Management.Automation

function Uninstall-GroupManagedServiceAccount {
    <#
    .SYNOPSIS
        Uninstalls a Group Managed Service Account from the local machine.
    .DESCRIPTION
        Uninstalls a Group Managed Service Account from the local machine.
    #>

    [CmdletBinding()]
    param (
        # The name of the Group Managed Service Account.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$AccountName
    )

    process {
        try {
            if (Test-GroupManagedServiceAccount $AccountName) {
                [Indented.SecurityPolicy.ServiceAccount]::RemoveServiceAccount($AccountName)
            } else {
                $errorRecord = [ErrorRecord]::new(
                    [ArgumentException]::new('The specified account, {0}, is not installed' -f $AccountName),
                    'GMSANotInstalled',
                    'InvalidArgument',
                    $AccountName
                )
                $pscmdlet.ThrowTerminatingError($errorRecord)
            }
        } catch {
            $pscmdlet.ThrowTerminatingError($_)
        }
    }
}