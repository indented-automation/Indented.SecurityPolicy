using namespace System.Security.Principal

class RenameAccount : AccountBase {
    [String]$Value

    [RenameAccount] Get() {
        $this.Value = (Get-LocalUser -Sid $this.GetSid()).Name

        return $this
    }

    [Void] Set() {
        Rename-LocalUser -Sid $this.GetSid() -NewName $this.Value
    }

    [Boolean] Test() {
        $localUser = Get-LocalUser -Sid $this.GetSid()

        return $localUser.Name -eq $this.Value
    }
}