using namespace System.Management.Automation

filter Test-GroupManagedServiceAccount {
    <#
    .SYNOPSIS
        Test whether or not a Group Managed Service Account is installed in the NetLogon store.
    .DESCRIPTION
        Test whether or not a Group Managed Service Account is installed in the NetLogon store.
    #>

    [CmdletBinding()]
    param (
        # The name of the Group Managed Service Account.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$AccountName
    )

    try {
        return [Indented.SecurityPolicy.ServiceAccount]::IsServiceAccount($AccountName)
    } catch {
        $pscmdlet.ThrowTerminatingError($_)
    }
}