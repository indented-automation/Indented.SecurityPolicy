InModuleScope Indented.SecurityPolicy {
    Describe Get-SecurityOption {
        BeforeAll {
            Mock Get-Item {
                [PSCustomObject]@{
                    PSPath = 'TestDrive:\Software\Microsoft'
                } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                    return 'EnableLUA'
                }
            }
            Mock Get-ItemPropertyValue {
                0
            }
            Mock Test-Path { $true }

            Mock NewImplementingType {
                [PSCustomObject]@{
                    Value = $null
                } | Add-Member Get -MemberType ScriptMethod -PassThru -Value {
                    $this.Value = 'Disabled'

                    return $this
                }
            }

            $defaultParams = @{
                Name = 'EnableLUA'
            }
        }

        Context 'Registry value, key exists, value exists' {
            It 'Gets the value and converts it to an enumerated value' {
                $securityOption = Get-SecurityOption @defaultParams

                $securityOption.Name | Should -Be 'EnableLUA'
                $securityOption.Value | Should -Be 'Disabled'
            }
        }

        Context 'Registry value, key exists, value does not exist' {
            Mock Get-Item {
                [PSCustomObject]@{
                    PSPath = 'TestDrive:\Software\Microsoft'
                } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {}
            }

            It 'Returns the default value for the policy' {
                $securityOption = Get-SecurityOption @defaultParams

                $securityOption.Name | Should -Be 'EnableLUA'
                $securityOption.Value | Should -Be 'Enabled'
            }
        }

        Context 'Registry value, key does not exist' {
            Mock Test-Path { $false }

            It 'Returns the default value for the policy' {
                $securityOption = Get-SecurityOption @defaultParams

                $securityOption.Name | Should -Be 'EnableLUA'
                $securityOption.Value | Should -Be 'Enabled'
            }
        }

        Context 'Class value' {
            BeforeAll {
                $contextParams = @{
                    Name = 'GuestAccountStatus'
                }
            }

            It 'Calls Get and returns the value' {
                $securityOption = Get-SecurityOption @contextParams

                $securityOption.Name | Should -Be 'GuestAccountStatus'
                $securityOption.Value | Should -Be 'Disabled'
            }
        }

        Context 'Error handling' {
            Mock Get-Item {
                throw 'Access denied'
            }

            It 'When an error is thrown when acquiring a value, throws a non-terminating error' {
                { Get-SecurityOption @defaultParams -ErrorAction Stop } | Should -Throw -ErrorId 'FailedToRetrieveSecurityOptionSetting'
                { Get-SecurityOption @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw
            }
        }
    }
}