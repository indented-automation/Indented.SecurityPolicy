using namespace System.Management.Automation

function Set-SecurityOption {
    <#
    .SYNOPSIS
        Set the value of a security option.
    .DESCRIPTION
        Set the value of a security option.
    .PARAMETER Value
        The value to set.
    .EXAMPLE
        Set-SecurityOption EnableLUA Enabled

        Enables the "User Account Control: Run all administrators in Admin Approval Mode" policy.
    .EXAMPLE
        Set-SecurityOption LegalNoticeText ''

        Sets the value of the LegalNoticeText policy to an empty string.
    .EXAMPLE

    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The name of the security option to set.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String]$Name,

        # The value to set.
        [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName)]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [Object]$Value
    )

    process {
        if ($value -eq 'Not Defined') {
            $errorRecord = [ErrorRecord]::new(
                [ArgumentException]::new('Cannot set "Not Defined" for {0}. Please use Reset-SecurityOption' -f $Name),
                'CannotUseSetToReset',
                'InvalidArgument',
                $Value
            )
            $pscmdlet.ThrowTerminatingError($errorRecord)
        }

        $securityOptionInfo = Resolve-SecurityOption $Name

        $valueType = $securityOptionInfo.ValueType -as [Type]
        if ($valueType.BaseType -eq [Enum]) {
            $parsedValue = 0 -as $valueType
            if ($valueType::TryParse([String]$Value, $true, [Ref]$parsedValue)) {
                $Value = $parsedValue
            } else {
                $errorRecord = [ErrorRecord]::new(
                    [ArgumentException]::new(('{0} is not a valid value for {1}. Valid values are: {2}' -f
                        $Value,
                        $securityOptionInfo.ValueName,
                        ([Enum]::GetNames($valueType) -join ', ')
                    )),
                    'InvalidValueForSecurityOption',
                    'InvalidArgument',
                    $Value
                )
                $pscmdlet.ThrowTerminatingError($errorRecord)
            }
        }

        try {
            if ($securityOptionInfo.Key) {
                Write-Debug ('Registry value type: {0}' -f $securityOption.Name)

                if (Test-Path $securityOptionInfo.Key) {
                    $key = Get-Item -Path $securityOptionInfo.Key
                } else {
                    $key = New-Item -Path $securityOptionInfo.Key -ItemType Key -Force
                }

                if ($key.GetValueNames() -contains $securityOptionInfo.Name) {
                    $currentValue = Get-ItemPropertyValue -Path $key.PSPath -Name $securityOptionInfo.Name

                    $shouldSet = $false
                    if ($value -is [Array] -or $currentValue -is [Array]) {
                        $shouldSet = ($currentValue -join ' ') -ne ($value -join ' ')
                    } elseif ($currentValue -ne $Value) {
                        $shouldSet = $true
                    }

                    if ($shouldSet -and $pscmdlet.ShouldProcess(('Setting policy {0} to {1}' -f $securityOption.Name, $Value))) {
                        Set-ItemProperty -Path $key.PSPath -Name $securityOptionInfo.Name -Value $Value
                    }
                } else {
                    $propertyType = switch ($securityOptionInfo.ValueType) {
                        { $valueType.BaseType -eq [Enum] } { $_ = ($_ -as [Type]).GetEnumUnderlyingType().Name }
                        'Int32'                            { 'DWord'; break }
                        'Int64'                            { 'QWord'; break }
                        'String'                           { 'String'; break }
                        'String[]'                         { 'MultiString'; break }
                        default                            { throw 'Invalid or unhandled registry property type' }
                    }

                    if ($pscmdlet.ShouldProcess(('Setting policy {0} to {1} with value type {2}' -f $securityOption.Name, $Value, $propertyType))) {
                        New-ItemProperty -Path $key.PSPath -Name $securityOptionInfo.Name -Value $Value -PropertyType $propertyType
                    }
                }
            } else {
                Write-Debug ('Class-handled value type: {0}' -f $securityOption.Name)

                $class = NewImplementingType $securityOptionInfo.Class
                $class.Value = $Value

                if (-not $class.Test()) {
                    if ($pscmdlet.ShouldProcess(('Setting policy {0} to {1}' -f $securityOption.Name, $Value))) {
                        $class.Set()
                    }
                }
            }
        } catch {
            $pscmdlet.ThrowTerminatingError($_)
        }
    }
}