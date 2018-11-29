using namespace Indented.SecurityPolicy

filter Install-GroupManagedServiceAccount {
    <#
    .SYNOPSIS
        Adds a Group Managed Service Account to the local machine.
    .DESCRIPTION
        Adds a Group Managed Service Account to the local machine.
    .EXAMPLE
        Install-GroupManagedServiceAccount -AccountName domain\name$
    #>

    [CmdletBinding()]
    param (
        # The name of the Group Managed Service Account.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$AccountName
    )

    try {
        [ServiceAccount]::AddServiceAccount($AccountName)
    } catch {
        $pscmdlet.ThrowTerminatingError($_)
    }
}