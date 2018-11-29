using namespace System.Management.Automation

filter Resolve-SecurityOption {
    <#
    .SYNOPSIS
        Resolves the name of a security option as shown in the local security policy editor.
    .DESCRIPTION
        Resolves the name of a security option as shown in the local security policy editor to either the registry value name, or the name of an implementing class.
    .EXAMPLE
        Resolve-SecurityOption "User Account Control: Run all administrators in Admin Approval Mode"

        Returns information about the security option.
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    [CmdletBinding()]
    param (
        # The name or description of a user right. Wildcards are supported for description values.
        [Parameter(Position = 1, ValueFromPipeline, ParameterSetName = 'ByName')]
        [String]$Name,

        # Get the policies under a specific category, for example "Network security".
        [Parameter(Mandatory, ParameterSetName = 'ByCategory')]
        [ArgumentCompleter( {
            param (
                [String]$CommandName,
                [String]$ParameterName,
                [String]$WordToComplete
            )

            [System.Collections.Generic.HashSet[String]](Resolve-SecurityOption).Category -like "$WordToComplete*"
        } )]
        [String]$Category
    )

    if ($Name) {
        if ($Script:securityOptionData.Contains($Name)) {
            $Script:securityOptionData[$Name]
        } elseif ($Script:securityOptionLookupHelper.Contains($Name)) {
            $Script:securityOptionData[$Script:securityOptionLookupHelper[$Name]]
        } else {
            $isLikeDescription = $false
            foreach ($value in $Script:securityOptionLookupHelper.Keys -like $Name) {
                $isLikeDescription = $true
                $Script:securityOptionData[$Script:securityOptionLookupHelper[$value]]
            }
            if (-not $isLikeDescription) {
                $errorRecord = [ErrorRecord]::new(
                    [ArgumentException]::new('"{0}" does not resolve to a security option' -f $Name),
                    'CannotResolveSecurityOption',
                    'InvalidArgument',
                    $Name
                )
                $pscmdlet.ThrowTerminatingError($errorRecord)
            }
        }
    } elseif ($Category) {
        $Script:securityOptionData.Values.Where{ $_.Category -like $Category }
    } else {
        $Script:securityOptionData.Values
    }
}