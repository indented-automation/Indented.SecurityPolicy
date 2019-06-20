using namespace System.Security.Principal

class AccountStatus : AccountBase {
    [Enabled]$Value

    [AccountStatus] Get() {
        $localUser = GetIadsLocalUser -Sid $this.GetSid()
        $this.Value = [Enabled][Int]$localUser.Enabled

        return $this
    }

    [Void] Set() {
        if ([Boolean][Int]$this.Value) {
            EnableIadsLocalUser -Sid $this.GetSid()
        } else {
            DisableIadsLocalUser -Sid $this.GetSid()
        }
    }

    [Boolean] Test() {
        $localUser = GetIadsLocalUser -Sid $this.GetSid()

        return $localUser.Enabled -eq ([Boolean][Int]$this.Value)
    }
}