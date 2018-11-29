using namespace System.Security.Principal

function Revoke-UserRight {
    <#
    .SYNOPSIS
        Revokes rights granted to an account.
    .DESCRIPTION
        Revokes the rights granted to an account or set of accounts.

        The All switch may be used to revoke all rights granted to the specified accounts.
    .EXAMPLE
        Revoke-UserRight -Name 'Log on as a service' -AccountName 'JonDoe'

        Revokes the logon as a service right granted to the account named JonDoe.
    .EXAMPLE
        Revoke-UserRight -AccountName 'JonDoe' -All

        Revokes all rights which have been granted to the identity JonDoe.
    #>

    [CmdletBinding(DefaultParameterSetName = 'List', SupportsShouldProcess)]
    param (
        # The user right, or rights, to query.
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'List')]
        [ValidateScript( { $_ | Resolve-UserRight } )]
        [Alias('UserRight')]
        [String[]]$Name,

        # Grant rights to the specified principals. The principal may be a string, an NTAccount object, or a SecurityIdentifier object.
        [Parameter(Mandatory, Position = 2)]
        [Object[]]$AccountName,

        # Clear all rights granted to the specified accounts.
        [Parameter(Mandatory, ParameterSetName = 'All')]
        [Switch]$AllRights
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
                if ($pscmdlet.ParameterSetName -eq 'All' -and $AllRights) {
                    if ($pscmdlet.ShouldProcess(('Removing all rights from {0}' -f $account))) {
                        $lsa.RemoveAllAccountRights($account)
                    }
                } elseif ($pscmdlet.ParameterSetName -eq 'List') {
                    $userRights = $Name | Resolve-UserRight

                    if ($pscmdlet.ShouldProcess(('Removing {0} from {1}' -f $account, $userRights.Name -join ', '))) {
                        $lsa.RemoveAccountRights($account, $userRights.Name)
                    }
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