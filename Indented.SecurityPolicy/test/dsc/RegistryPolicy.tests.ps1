#region:TestFileHeader
param (
   [Boolean]$UseExisting
)

if (-not $UseExisting) {
   $moduleBase = $psscriptroot.Substring(0, $psscriptroot.IndexOf('\test'))
   $stubBase = Resolve-Path (Join-Path $moduleBase 'test*\stub\*')
   if ($null -ne $stubBase) {
       $stubBase | Import-Module -Force
   }

   Import-Module $moduleBase -Force
}
#endregion

InModuleScope Indented.SecurityPolicy {
    Describe RegistryPolicy {
        BeforeAll {
            Mock Get-Item {
                [PSCustomObject]@{} |
                    Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                        @('ValueName')
                    } |
                    Add-Member GetValueKind -MemberType ScriptMethod -PassThru -Value {
                        'String'
                    }
            }
            Mock Get-ItemPropertyValue {
                'Value'
            }
            Mock New-Item {
                [PSCustomObject]@{} |
                    Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                        @()
                    }
             }
            Mock Test-Path { $true }
            Mock Set-ItemProperty
            Mock New-ItemProperty
            Mock Remove-ItemProperty
        }

        BeforeEach {
            $class = [RegistryPolicy]@{
                Ensure = 'Present'
                Name   = 'ValueName'
                Path   = 'HKCU:\Software\Test'
                Data   = 'Value'
            }
        }

        Context 'Get, value is present' {
            It 'When the value is present, sets Ensure to present' {
                $class.Ensure = 'Absent'
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Present'
            }
        }

        Context 'Get, value is absent' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'When the value is present, sets Ensure to present' {
                $class.Ensure = 'Present'
                $instance = $class.Get()

                $instance.Ensure | Should -Be 'Absent'
            }
        }

        Context 'Set, value is present' {
            It 'When ensure is present, does nothing' {
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }

            It 'When ensure is absent, calls Remove-ItemProperty' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }
        }

        Context 'Set, key is absent' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'When ensure is present, calls New-Item and New-ItemProperty' {
                $class.Set()

                Assert-MockCalled New-Item -Times 1 -Scope It
                Assert-MockCalled New-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }
        }

        Context 'Set, key is present, value is absent' {
            BeforeAll {
                Mock Get-Item {
                    [PSCustomObject]@{} |
                        Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                            @()
                        }
                }
            }

            It 'When ensure is present, calls New-ItemProperty' {
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }
        }

        Context 'Set, key is present, value is present, type does not match' {
            BeforeAll {
                Mock Get-Item {
                    [PSCustomObject]@{} |
                        Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                            @('ValueName')
                        } |
                        Add-Member GetValueKind -MemberType ScriptMethod -PassThru -Value {
                            'DWord'
                        }
                }
            }

            It 'When ensure is present, calls Remove-ItemProperty and New-ItemProperty' {
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }

            It 'When ensure is absent, calls Remove-ItemProperty' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled New-Item -Times 0 -Scope It
                Assert-MockCalled New-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Remove-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Set-ItemProperty -Times 0 -Scope It
            }
        }

        Context 'Test, value is present' {
            It 'When ensure is present, returns true' {
                $class.Test() | Should -Be $true
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, key is absent' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, returns true' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $true
            }
        }

        Context 'Test, key is present, value is absent' {
            BeforeAll {
                Mock Get-Item {
                    [PSCustomObject]@{} |
                        Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                            @()
                        }
                }
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, returns true' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $true
            }
        }

        Context 'Test, key is present, value is present, type does not match' {
            BeforeAll {
                Mock Get-Item {
                    [PSCustomObject]@{} |
                        Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                            @('ValueName')
                        } |
                        Add-Member GetValueKind -MemberType ScriptMethod -PassThru -Value {
                            'DWord'
                        }
                }
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, key is present, value is present, type matches, value does not match' {
            BeforeAll {
                Mock Get-ItemPropertyValue {
                    'OtherValue'
                }
            }

            It 'When ensure is present, returns false' {
                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $false
            }
        }
    }
}