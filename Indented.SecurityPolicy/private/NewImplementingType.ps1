function NewImplementingType {
    <#
    .SYNOPSIS
        A short helper to create a named type.
    .DESCRIPTION
        A short helper to create a named type. Persent to help mocking.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name
    )

    ($Name -as [Type])::new()
}