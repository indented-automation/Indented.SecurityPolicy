using namespace System.Security.Principal

function GetIadsLocalUser {
    <#
    .SYNOPSIS
        ADSI based alternative to Get-LocalUser.
    .DESCRIPTION
        This simple ADSI-based version of Get-LocalUser allows use the AccountStatus and RenameAccount security options on PowerShell Core.
    #>

    [CmdletBinding()]
    param (
        # The exact name of a user.
        [String]$Name,

        # The SID of a user.
        [SecurityIdentifier]$Sid,

        # Return the IAdsUser object as-is.
        [Switch]$AsIadsUser
    )

    $iadsComputer = [ADSI]('WinNT://{0}' -f $env:COMPUTERNAME)
    $null = $iadsComputer.Children.SchemaFilter.Add('user')

    if ($Name) {
        $iadsUserCollection = $iadsComputer.Children.Find(
            $Name,
            'user'
        )
    } else {
        $iadsUserCollection = $iadsComputer.Children
    }

    foreach ($iadsUser in $iadsUserCollection) {
        $iadsUserSid = [SecurityIdentifier]::new([Byte[]]$iadsUser.Get('objectSID'), 0)

        if (-not $Sid -or $iadsUserSid -eq $Sid) {
            if ($AsIadsUser) {
                $iadsUser
            } else {
                [PSCustomObject]@{
                    Name    = $iadsUser.Get('Name')
                    Enabled = -not ($iadsUser.Get('userFlags') -band 2)
                    SID     = $iadsUserSid
                }
            }
        }
    }
}