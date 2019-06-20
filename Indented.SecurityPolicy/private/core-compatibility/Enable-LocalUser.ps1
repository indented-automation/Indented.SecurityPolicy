using namespace System.Security.Principal
using namespace System.Security.Principal

if ($psversiontable.PSVersion.Major -gt 5) {
    function Enable-LocalUser {
        <#
        .SYNOPSIS
            ADSI based alternative to Enable-LocalUser.
        .DESCRIPTION
            This simple ADSI-based version of Enable-LocalUser allows use the AccountStatus security option on PowerShell Core.
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
            if (($userFlags -band 2) -eq 2) {
                $iadsUser.Put(
                    'userFlags',
                    $userFlags -bxor 2
                )
                $iadsUser.SetInfo()
            }
        }
    }
}