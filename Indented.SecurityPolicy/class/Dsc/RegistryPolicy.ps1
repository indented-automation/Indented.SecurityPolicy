[DscResource()]
class RegistryPolicy {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [DscProperty(Key)]
    [String]$Path

    [DscProperty()]
    [String[]]$Data = @()

    [DscProperty()]
    [RegistryValueType]$ValueType = 'String'

    Hidden [Object] $ParsedData

    Hidden [Boolean] CompareValue() {
        $value = Get-ItemPropertyValue -Path $this.Path -Name $this.Name
        if ($this.ValueType -eq 'MultiString') {
            if (Compare-Object @($this.ParsedData) @($value) -SyncWindow 0) {
                return $false
            }
        } elseif ($value -ne $this.ParsedData) {
            return $false
        }

        return $true
    }

    Hidden [Void] ParseData() {
        try {
            $this.ParsedData = switch ($this.ValueType) {
                'DWord'       { [UInt32]::Parse($this.Data[0]); break }
                'QWord'       { [UInt64]::Parse($this.Data[0]); break }
                'MultiString' { $this.Data; break }
                'Binary'      {
                    foreach ($value in $this.Data -split ' ') {
                        [Convert]::ToByte($value, 16)
                    }
                    break
                }
                default       { $this.Data[0] }
            }
        } catch {
            throw
        }
    }

    [RegistryPolicy] Get() {
        $this.ParseData()

        if (-not $this.Test()) {
            $this.Ensure = $this.Ensure -bxor 1
        }

        return $this
    }

    [Void] Set() {
        $this.ParseData()

        $params = @{
            Name  = $this.Name
            Path  = $this.Path
        }

        if ($this.Ensure -eq 'Present') {
            if (Test-Path $this.Path) {
                $key = Get-Item $this.Path
            } else {
                $key = New-Item $this.Path -ItemType Key -Force
            }

            if ($this.Name -in $key.GetValueNames()) {
                if ($key.GetValueKind($this.Name).ToString() -eq $this.ValueType) {
                    if (-not $this.CompareValue()) {
                        Set-ItemProperty -Value $this.ParsedData @params
                    }
                } else {
                    Remove-ItemProperty @params
                    New-ItemProperty -PropertyType $this.ValueType -Value $this.ParsedData @params
                }
            } else {
                New-ItemProperty -PropertyType $this.ValueType -Value $this.ParsedData @params
            }
        } elseif ($this.Ensure -eq 'Absent') {
            if (Test-Path $this.Path) {
                $key = Get-Item $this.Path
                if ($this.Name -in $key.GetValueNames()) {
                    Remove-ItemProperty @params
                }
            }
        }
    }

    [Boolean] Test() {
        $this.ParseData()

        if ($this.Ensure -eq 'Present') {
            if (-not (Test-Path $this.Path)) {
                return $false
            }

            $key = Get-Item $this.Path
            if ($key.GetValueNames() -notcontains $this.Name) {
                return $false
            }

            if ($key.GetValueKind($this.Name).ToString() -ne $this.ValueType) {
                return $false
            }

            return $this.CompareValue()
        } elseif ($this.Ensure -eq 'Absent') {
            if (Test-Path $this.Path) {
                $key = Get-Item $this.Path
                if ($key.GetValueNames() -contains $this.Name) {
                    return $false
                }
            }
        }

        return $true
    }
}