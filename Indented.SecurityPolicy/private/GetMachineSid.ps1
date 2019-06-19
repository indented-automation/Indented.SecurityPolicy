function GetMachineSid {
    <#
    .SYNOPSIS
        Get the SID of the current machine.
    .DESCRIPTION
        Get the SID of the current machine.

        The current machine SID should not be confused with a SID used by Active Directory.
    #>

    [CmdletBinding()]
    [OutputType([System.Security.Principal.SecurityIdentifier])]
    param ( )

    [Indented.SecurityPolicy.Account]::LookupAccountName($env:COMPUTERNAME, $env:COMPUTERNAME)
}