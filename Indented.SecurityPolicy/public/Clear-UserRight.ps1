using namespace Indented.SecurityPolicy

function Clear-UserRight {
    <#
    .SYNOPSIS
        Clears the accounts from the specified user right.
    .DESCRIPTION
        Clears the accounts from the specified user right.
    .EXAMPLE
        Clear-UserRight 'Log on as a batch job'

        Clear the SeBatchLogonRight right.
    #>

    [CmdletBinding()]
    param (
        # The name of the user right to clear.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
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
                foreach ($identity in $lsa.EnumerateAccountsWithUserRight($userRight.Name)) {
                    $lsa.RemoveAccountRights($identity, [UserRight[]]$userRight.Name)
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