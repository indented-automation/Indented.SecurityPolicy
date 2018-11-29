InModuleScope Indented.SecurityPolicy {
    Describe SecurityOption {
        BeforeAll {
            Mock Get-SecurityOption {
                $securityOptionInfo = $Name | Resolve-SecurityOption
                [PSCustomObject]@{
                    Name             = $securityOptionInfo.Name
                    Description      = $securityOptionInfo.Description
                    Value            = 'Enabled'
                    PSTypeName       = 'Indented.SecurityPolicy.SecurityOptionSetting'
                }
            }
            Mock Reset-SecurityOption
            Mock Set-SecurityOption
        }

        BeforeEach {
            $class = [SecurityOption]@{
                Ensure = 'Present'
                Name   = 'EnableLUA'
                Value  = 'Enabled'
            }
        }

        Context 'Get' {
            It 'Gets the current state of the security option' {
                $class.Value = 'Disabled'
                $instance = $class.Get()

                $instance.Name | Should -Be 'EnableLUA'
                $instance.Description | Should -match 'Run all administrators in Admin Approval Mode'
                $instance.Value | Should -Be 'Enabled'
            }
        }

        Context 'Set' {
            It 'When ensure is present, calls Set-SecurityOption' {
                $class.Set()

                Assert-MockCalled Set-SecurityOption -Times 1 -Scope It
            }

            It 'When ensure is absent, calls Reset-SecurityOption' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Reset-SecurityOption -Times 1 -Scope It
            }
        }

        Context 'Test, value matches' {
            It 'When ensure is present, and the value matches, returns true' {
                $class.Test() | Should -Be $true
            }

            It 'When ensure is absent, and the value matches the default, returns true' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $true
            }
        }

        Context 'Test, value does not match' {
            BeforeAll {
                Mock Get-SecurityOption {
                    $securityOptionInfo = $Name | Resolve-SecurityOption
                    [PSCustomObject]@{
                        Name             = $securityOptionInfo.Name
                        Description      = $securityOptionInfo.Description
                        Value            = 'Disabled'
                        PSTypeName       = 'Indented.SecurityPolicy.SecurityOptionSetting'
                    }
                }
            }

            It 'When ensure is present, and the value does not match, returns false' {
                $class.Test() | Should -Be $false
            }

            It ' When ensure is absent, and the value does not match the default, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, value is an array' {
            BeforeAll {
                Mock Get-SecurityOption {
                    $securityOptionInfo = $Name | Resolve-SecurityOption
                    [PSCustomObject]@{
                        Name             = $securityOptionInfo.Name
                        Description      = $securityOptionInfo.Description
                        Value            = $Script:ReturnValue
                        PSTypeName       = 'Indented.SecurityPolicy.SecurityOptionSetting'
                    }
                }
            }

            BeforeEach {
                $class.Name = 'NullSessionPipes'
                $class.Value = 'Value1', 'Value2'

                $Script:ReturnValue = [String[]]@()
            }

            It 'When ensure is present, and the value matches, returns true' {
                $Script:ReturnValue = [String[]]@('Value1', 'Value2')

                $class.Test() | Should -Be $true
            }

            It 'When ensure is present, and the value does not match, returns false' {
                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, and the value matches the default, returns true' {
                $class.Ensure = 'Absent'
                $class.Value = $null

                $class.Test() | Should -Be $true
            }

            It 'When ensure is absent, and the value does not match the default, returns false' {
                $Script:ReturnValue = [String[]]@('Value1', 'Value2')
                $class.Ensure = 'Absent'

                $class.Test() | SHould -Be $false
            }
        }
    }
}