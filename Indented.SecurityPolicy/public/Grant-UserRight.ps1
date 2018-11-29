using namespace System.Security.Principal

function Grant-UserRight {
    <#
    .SYNOPSIS
        Grant rights to an account.
    .DESCRIPTION
        Grants one or more rights to the specified accounts.
    .EXAMPLE
        Grant-UserRight -Name 'Allow logon locally' -AccountName 'Administrators'

        Grants the allow logon locally right to the Administrators group.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The user right, or rights, to query.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateScript( { $_ | Resolve-UserRight } )]
        [Alias('UserRight')]
        [String[]]$Name,

        # Grant rights to the specified accounts. Each account may be a string, an NTAccount object, or a SecurityIdentifier object.
        [Parameter(Mandatory, Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Object[]]$AccountName
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
                $userRights = $Name | Resolve-UserRight

                if ($pscmdlet.ShouldProcess(('Adding {0} to {1}' -f $account, $userRights.Name -join ', '))) {
                    $lsa.AddAccountRights($account, $userRights.Name)
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