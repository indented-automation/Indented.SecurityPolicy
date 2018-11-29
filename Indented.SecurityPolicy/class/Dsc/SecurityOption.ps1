[DscResource()]
class SecurityOption {
    [DscProperty()]
    [Ensure]$Ensure = 'Present'

    [DscProperty(Key)]
    [String]$Name

    [DscProperty()]
    [String[]]$Value

    [DscProperty(NotConfigurable)]
    [String]$Description

    [Object]$ParsedValue

    Hidden [Void] ParseValue() {
        $securityOptionInfo = Resolve-SecurityOption $this.Name
        $valueType = $securityOptionInfo.ValueType -as [Type]

        $candidateValue = $this.Value
        if ($valueType.BaseType -ne [Array]) {
            $candidateValue = $this.Value[0]
        }
        if ($valueType.BaseType -eq [Enum]) {
            $enumValue = 0 -as $valueType
            if ($valueType::TryParse([String]$candidateValue, $true, [Ref]$enumValue)) {
                $this.ParsedValue = $enumValue
            }
        } else {
            $this.ParsedValue = $candidateValue -as $securityOptionInfo.ValueType
        }
    }

    Hidden [Boolean] CompareValue([Object]$ReferenceValue, [Object]$DifferenceValue) {
        if ($ReferenceValue -is [Array] -or $DifferenceValue -is [Array]) {
            return ($ReferenceValue -join ' ') -eq ($DifferenceValue -join ' ')
        } else {
            return $ReferenceValue -eq $DifferenceValue
        }
    }

    [SecurityOption] Get() {
        $securityOption = Get-SecurityOption -Name $this.Name

        $this.Name = $securityOption.Name
        $this.Value = $securityOption.Value
        $this.Description = $securityOption.Description

        return $this
    }

    [Void] Set() {
        if ($this.Ensure -eq 'Present') {
            $this.ParseValue()

            Set-SecurityOption -Name $this.Name -Value $this.ParsedValue
        } elseif ($this.Ensure -eq 'Absent') {
            Reset-SecurityOption -Name $this.Name
        }
    }

    [Boolean] Test() {
        $securityOption = Get-SecurityOption -Name $this.Name

        if ($this.Ensure -eq 'Present') {
            $this.ParseValue()

            return $this.CompareValue($this.ParsedValue, $securityOption.Value)
        } elseif ($this.Ensure -eq 'Absent') {
            $securityOptionInfo = Resolve-SecurityOption $this.Name

            return $this.CompareValue($securityOptionInfo.Default, $securityOption.Value)
        }

        return $true
    }
}