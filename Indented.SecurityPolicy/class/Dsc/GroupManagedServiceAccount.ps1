[DscResource()]
class GroupManagedServiceAccount {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [GroupManagedServiceAccount] Get() {
        if (Test-GroupManagedServiceAccount -AccountName $this.Name) {
            $this.Ensure = 'Present'
        } else {
            $this.Ensure = 'Absent'
        }

        return $this
    }

    [Void] Set() {
        if ($this.Ensure -eq 'Present' -and -not (Test-GroupManagedServiceAccount -AccountName $this.Name)) {
            Install-GroupManagedServiceAccount -AccountName $this.Name
        } elseif ($this.Ensure -eq 'Absent' -and (Test-GroupManagedServiceAccount -AccountName $this.Name)) {
            Uninstall-GroupManagedServiceAccount -AccountName $this.Name
        }
    }

    [Boolean] Test() {
        if ($this.Ensure -eq 'Present') {
            return Test-GroupManagedServiceAccount -AccountName $this.Name
        } elseif ($this.Ensure -eq 'Absent') {
            return -not (Test-GroupManagedServiceAccount -AccountName $this.Name)
        }
        return $true
    }
}