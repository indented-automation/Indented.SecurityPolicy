function Get-UserRight {
    <#
     .SYNOPSIS
       Gets all accounts that are assigned a specified user right.
     .DESCRIPTION
       Gets a list of all accounts that hold a specified user right.

       Group membership is not evaluated, the values returned are explicitly listed under the specified user rights.
     .EXAMPLE
       Get-UserRight SeServiceLogonRight

       Returns a list of all accounts that hold the "Log on as a service" right.
     .EXAMPLE
       Get-UserRight SeServiceLogonRight, SeDebugPrivilege

       Returns accounts with the SeServiceLogonRight and SeDebugPrivilege rights.
    #>

    [CmdletBinding()]
    [OutputType('Indented.SecurityPolicy.UserRight')]
    param (
        # The user right, or rights, to query.
        [Parameter(Position = 1, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateScript( { $_ | Resolve-UserRight } )]
        [Alias('UserRight')]
        [String[]]$Name
    )

    begin {
        try {
            $lsa = OpenLsaPolicy
        } catch {
            $pscmdlet.ThrowTerminatingError($_)
        }
    }

    process {
        foreach ($userRight in $Name | Resolve-UserRight) {
            try {
                [PSCustomObject]@{
                    Name        = $userRight.Name
                    Description = $userRight.Description
                    AccountName = $lsa.EnumerateAccountsWithUserRight($userRight.Name)
                    PSTypeName  = 'Indented.SecurityPolicy.UserRightSetting'
                }
            } catch {
                $innerException = $_.Exception.GetBaseException()
                $errorRecord = [ErrorRecord]::new(
                    [InvalidOperationException]::new(
                        ('An error occurred retrieving the user right {0}: {1}' -f $userRight.Name, $innerException.Message),
                        $innerException
                    ),
                    'FailedToRetrieveUserRight',
                    'OperationStopped',
                    $null
                )
                Write-Error -ErrorRecord $errorRecord
            }
        }
    }

    end {
        CloseLsaPolicy $lsa
    }
}