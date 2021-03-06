using namespace System.Security.Principal

function RenameIadsLocalUser {
    <#
    .SYNOPSIS
        ADSI based alternative to Rename-LocalUser.
    .DESCRIPTION
        This simple ADSI-based version of Rename-LocalUser allows use the RenameAccount security option on PowerShell Core.
    #>

    [CmdletBinding()]
    param (
        # The SID of a user.
        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [SecurityIdentifier]$Sid,

        # The new name of the user.
        [Parameter(Mandatory)]
        [String]$NewName
    )

    process {
        $iadsUser = GetIadsLocalUser -Sid $Sid -AsIadsUser

        if ($iadsUser.Get('Name') -ne $NewName) {
            $iadsUser.Rename($NewName)
        }
    }
}