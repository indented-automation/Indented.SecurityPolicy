using namespace System.Security.Principal
using namespace Indented.SecurityPolicy

function Set-UserRight {
    <#
    .SYNOPSIS
        Set the value of a user rights assignment to the specified list of principals.
    .DESCRIPTION
        Set the value of a user rights assignment to the specified list of principals, replacing any existing entries.
    .EXAMPLE
        Set-UserRight -Name SeShutdownPrivilege -AccountName 'Administrators'

        Replaces the accounts granted the SeShutdownPrivilege right with Administrators.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The user right, or rights, to query.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateScript( { $_ | Resolve-UserRight } )]
        [Alias('UserRight')]
        [String[]]$Name,

        # The list of identities which should set for the specified policy.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
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
        try {
            # Ensure all identity values are SecurityIdentifier type
            $requestedIdentities = foreach ($account in $AccountName) {
                $securityIdentifier = switch ($account.GetType()) {
                    ([String])    { ([NTAccount]$account).Translate([SecurityIdentifier]); break }
                    ([NTAccount]) { $account.Translate([SecurityIdentifier]); break }
                    default       { $account }
                }

                [PSCustomObject]@{
                    Value              = $account
                    SecurityIdentifier = $securityIdentifier
                }
            }

            foreach ($userRight in $Name | Resolve-UserRight) {
                # Get the current value and ensure all returned values are SecurityIdentifier type
                $currentIdentities = foreach ($account in $lsa.EnumerateAccountsWithUserRight($userRight.Name)) {
                    $securityIdentifier = if ($account -is [NTAccount]) {
                        $account.Translate([SecurityIdentifier])
                    } else {
                        $account
                    }

                    [PSCustomObject]@{
                        Value              = $account
                        SecurityIdentifier = $securityIdentifier
                    }
                }

                foreach ($account in Compare-Object @($requestedIdentities) @($currentIdentities) -Property SecurityIdentifier -PassThru) {
                    if ($account.SideIndicator -eq '<=') {
                        if ($pscmdlet.ShouldProcess(('Adding {0} to user right {1}' -f $account.Value, $userRight.Name))) {
                            $lsa.AddAccountRights($account.SecurityIdentifier, $userRight.Name)
                        }
                    } elseif ($account.SideIndicator -eq '=>') {
                        if ($pscmdlet.ShouldProcess(('Removing {0} from user right {1}' -f $account.Value, $userRight.Name))) {
                            $lsa.RemoveAccountRights($account.SecurityIdentifier, [UserRight[]]$userRight.Name)
                        }
                    }
                }
            }
        } catch {
            Write-Error -ErrorRecord $_
        }
    }

    end {
        CloseLsaPolicy $lsa
    }
}