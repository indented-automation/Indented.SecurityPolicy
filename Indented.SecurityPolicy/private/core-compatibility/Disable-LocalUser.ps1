using namespace System.Security.Principal

if ($psversiontable.PSVersion.Major -gt 5) {
    function Disable-LocalUser {
        <#
        .SYNOPSIS
            ADSI based alternative to Disable-LocalUser.
        .DESCRIPTION
            This simple ADSI-based version of Disable-LocalUser allows use the AccountStatus security option on PowerShell Core.
        #>

        [CmdletBinding()]
        param (
            # The SID of a user.
            [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
            [SecurityIdentifier]$Sid
        )

        process {
            $iadsUser = Get-LocalUser -Sid $Sid -AsIadsUser

            $userFlags = $iadsUser.Get('userFlags')
            if (($userFlags -band 2) -eq 0) {
                $iadsUser.Put(
                    'userFlags',
                    $userFlags -bor 2
                )
                $iadsUser.SetInfo()
            }
        }
    }
}