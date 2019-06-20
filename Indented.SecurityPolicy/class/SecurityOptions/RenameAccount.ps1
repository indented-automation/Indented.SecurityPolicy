using namespace System.Security.Principal

class RenameAccount : AccountBase {
    [String]$Value

    [RenameAccount] Get() {
        $this.Value = (GetIadsLocalUser -Sid $this.GetSid()).Name

        return $this
    }

    [Void] Set() {
        RenameIadsLocalUser -Sid $this.GetSid() -NewName $this.Value
    }

    [Boolean] Test() {
        $localUser = GetIadsLocalUser -Sid $this.GetSid()

        return $localUser.Name -eq $this.Value
    }
}