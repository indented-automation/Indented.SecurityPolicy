function Get-AssignedUserRight {
    <#
     .SYNOPSIS
        Gets all user rights granted to a principal.
     .DESCRIPTION
        Get a list of all the user rights granted to one or more principals. Does not expand group membership.
     .EXAMPLE
        Get-AssignedUserRight

        Returns a list of all defined for the current user.
    .EXAMPLE
        Get-AssignedUserRight Administrator

        Get the list of rights assigned to the administrator account.
    #>

    [CmdletBinding()]
    [OutputType('Indented.SecurityPolicy.AssignedUserRight')]
    param (
        # Find rights for the specified account names. By default AccountName is the current user.
        [Parameter(Position = 1, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [String[]]$AccountName = $env:USERNAME
    )

    begin {
        try {
            $lsa = OpenLsaPolicy
        } catch {
            $pscmdlet.ThrowTerminatingError($_)
        }
    }

    process {
        foreach ($account in $AccountName) {
            try {
                [PSCustomObject]@{
                    AccountName = $account
                    Name        = $lsa.EnumerateAccountRights($account)
                    PSTypeName  = 'Indented.SecurityPolicy.AssignedUserRight'
                }
            } catch {
                Write-Error -ErrorRecord $_
            }
        }
    }

    end {
        CloseLsaPolicy $lsa
    }
}