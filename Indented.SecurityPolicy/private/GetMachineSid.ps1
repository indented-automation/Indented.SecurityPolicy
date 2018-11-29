function GetMachineSid {
    [OutputType([System.Security.Principal.SecurityIdentifier])]
    param ( )

    [Indented.SecurityPolicy.Account]::LookupAccountName($env:COMPUTERNAME, $env:COMPUTERNAME)
}