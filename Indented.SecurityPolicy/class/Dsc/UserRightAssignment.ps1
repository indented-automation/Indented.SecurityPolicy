using namespace System.Collections.Generic
using namespace System.Security.Principal

[DscResource()]
class UserRightAssignment {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [DscProperty()]
    [String[]]$AccountName

    [DscProperty()]
    [Boolean]$Replace

    [DscProperty(NotConfigurable)]
    [String]$Description

    Hidden [SecurityIdentifier[]]$requestedIdentities

    Hidden [SecurityIdentifier[]]$currentIdentities

    Hidden [Void] InitializeRequest() {
        try {
            $userRight = Resolve-UserRight $this.Name
            if (@($userRight).Count -ne 1) {
                throw 'The requested user right is ambiguous, matched right names: {0}' -f
                    ($userRight.UserRight -join ', ')
            }
            $this.Name = $userRight.Name
            $this.Description = $userRight.Description
        } catch {
            throw
        }

        if ($this.Ensure -eq 'Present' -and $this.AccountName.Count -eq 0) {
            throw 'Invalid request. AccountName cannot be empty when ensuring a right is present.'
        }
        if ($this.Ensure -eq 'Absent' -and $this.Replace) {
            throw 'Replace may only be set when ensuring a set of accounts is present.'
        }

        $this.requestedIdentities = foreach ($identity in $this.AccountName) {
            ([NTAccount]$identity).Translate([SecurityIdentifier])
        }
        $this.currentIdentities = foreach ($identity in (Get-UserRight -Name $this.Name).AccountName) {
            if ($identity -is [NTAccount]) {
                $identity.Translate([SecurityIdentifier])
            } else {
                $identity
            }
        }
    }

    Hidden [Boolean] CompareAccountNames() {
        return [Boolean](-not (Compare-Object @($this.requestedIdentities) @($this.currentIdentities)))
    }

    Hidden [Boolean] IsAssignedRight([String]$Identity) {
        return $this.currentIdentities -contains ([NTAccount]$Identity).Translate([SecurityIdentifier])
    }

    [UserRightAssignment] Get() {
        try {
            $this.InitializeRequest()
            $this.AccountName = (Get-UserRight -Name $this.Name).AccountName

            return $this
        } catch {
            throw
        }
    }

    [Void] Set() {
        try {
            $this.InitializeRequest()
            if ($this.Ensure -eq 'Present') {
                if ($this.Replace) {
                    Set-UserRight -Name $this.Name -AccountName $this.AccountName
                } else {
                    foreach ($identity in $this.AccountName) {
                        if (-not $this.IsAssignedRight($identity)) {
                            Grant-UserRight -Name $this.Name -AccountName $identity
                        }
                    }
                }
            } elseif ($this.Ensure -eq 'Absent') {
                if ($this.AccountName.Count -eq 0 -and $this.currentIdentities.Count -gt 0) {
                    Clear-UserRight -Name $this.Name
                } elseif ($this.AccountName -gt 0) {
                    foreach ($identity in $this.AccountName) {
                        if ($this.IsAssignedRight($identity)) {
                            Revoke-UserRight -Name $this.Name -AccountName $identity
                        }
                    }
                }
            }
        } catch {
            throw
        }
    }

    [Boolean] Test() {
        try {
            $this.InitializeRequest()
            $userRight = Get-UserRight -Name $this.Name

            if ($this.Ensure -eq 'Present') {
                if ($this.Replace) {
                    if ($this.currentIdentities.Count -eq 0) {
                        return $false
                    }
                    return $this.CompareAccountNames()
                } else {
                    foreach ($identity in $this.AccountName) {
                        if (-not $this.IsAssignedRight($identity)) {
                            return $false
                        }
                    }
                }
            } elseif ($this.Ensure -eq 'Absent') {
                if ($this.AccountName.Count -eq 0 -and $userRight.AccountName) {
                    return $false
                } elseif ($this.AccountName.Count -gt 0) {
                    foreach ($identity in $this.AccountName) {
                        if ($this.IsAssignedRight($identity)) {
                            return $false
                        }
                    }
                }
            }

            return $true
        } catch {
            throw
        }
    }
}