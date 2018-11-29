using namespace System.Management.Automation
using namespace Indented.SecurityPolicy

filter Resolve-UserRight {
    <#
    .SYNOPSIS
        Resolves the name of a user right as shown in the local security policy editor to its constant name.
    .DESCRIPTION
        Resolves the name of a user right as shown in the local security policy editor to its constant name.
    .EXAMPLE
        Resolve-UserRight "Generate security audits"

        Returns the value SeAuditPrivilege.
    .EXAMPLE
        Resolve-UserRight "*batch*"

        Returns SeBatchLogonRight and SeDenyBatchLogonRight via the description.
    .EXAMPLE
        Resolve-UserRight SeBatchLogonRight

        Returns the name and description of the user right.
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [CmdletBinding()]
    param (
        # The name or description of a user right. Wildcards are supported for description values.
        [Parameter(Position = 1, ValueFromPipeline)]
        [String]$Name
    )

    if ($Name) {
        if ($Script:userRightData.Contains($Name)) {
            $Script:userRightData[$Name]
        } elseif ($Script:userRightLookupHelper.Contains($Name)) {
            $Script:userRightData[$Script:userRightLookupHelper[$Name]]
        } else {
            $isLikeDescription = $false
            foreach ($value in $Script:userRightLookupHelper.Keys -like $Name) {
                $isLikeDescription = $true
                $Script:userRightData[$Script:userRightLookupHelper[$value]]
            }
            if (-not $isLikeDescription) {
                $errorRecord = [ErrorRecord]::new(
                    [ArgumentException]::new('"{0}" does not resolve to a user right' -f $Name),
                    'UserRightCannotResolve',
                    'InvalidArgument',
                    $Name
                )
                $pscmdlet.ThrowTerminatingError($errorRecord)
            }
        }
    } else {
        $Script:userRightData.Values
    }
}