using namespace System.Security.Principal

class AccountStatus : AccountBase {
    [Enabled]$Value

    [AccountStatus] Get() {
        $localUser = Get-LocalUser -Sid $this.GetSid()
        $this.Value = [Enabled][Int]$localUser.Enabled

        return $this
    }

    [Void] Set() {
        if ([Boolean][Int]$this.Value) {
            Enable-LocalUser -Sid $this.GetSid()
        } else {
            Disable-LocalUser -Sid $this.GetSid()
        }
    }

    [Boolean] Test() {
        $localUser = Get-LocalUser -Sid $this.GetSid()

        return $localUser.Enabled -eq ([Boolean][Int]$this.Value)
    }
}