using namespace System.Security.Principal

class AccountBase {
    [WellKnownSidType]$SidType

    [SecurityIdentifier]$MachineSid = (GetMachineSid)

    [SecurityIdentifier] GetSid() {
        $domainRole = (Get-CimInstance Win32_ComputerSystem -Property DomainRole).DomainRole
        if ($domainRole -in 4, 5) {
            $searcher = [ADSISearcher]'(objectClass=domainDNS)'
            $null = $searcher.PropertiesToLoad.Add('objectSID')
            $domainSid = [SecurityIdentifier]::new($searcher.FindOne().Properties['objectSID'][0], 0)

            return [SecurityIdentifier]::new($this.SidType, $domainSid)
        } else {
            return [SecurityIdentifier]::new($this.SidType, $this.MachineSid)
        }
    }
}