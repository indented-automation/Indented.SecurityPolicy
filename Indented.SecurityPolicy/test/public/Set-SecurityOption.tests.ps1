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
    Describe Set-SecurityOption {
        BeforeAll {
            Mock Get-Item {
                [PSCustomObject]@{
                    PSPath = 'TestDrive:\Software\Microsoft'
                } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                    return @('EnableLUA', 'LegalNoticeText', 'NullSessionShares')
                }
            }
            Mock Get-ItemPropertyValue {
                1
            }
            Mock New-Item {
                [PSCustomObject]@{
                    PSPath = 'TestDrive:\Software\Microsoft'
                } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {}
            }
            Mock New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' }
            Mock New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' }
            Mock New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' }
            Mock New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' }
            Mock Set-ItemProperty
            Mock Test-Path { $true }

            Mock NewImplementingType {
                [PSCustomObject]@{
                    Value = $null
                } | Add-Member Test -MemberType ScriptMethod -PassThru -Value {
                    return $Script:testReturn
                } | Add-Member Set -MemberType ScriptMethod -PassThru -Value {
                    $Script:setCalled = $true
                }
            }

            $defaultParams = @{
                Name  = 'EnableLUA'
                Value = 'Enabled'
            }
        }

        BeforeEach {
            $Script:testReturn = $true
            $Script:setCalled = $false
        }

        Context 'Parameter validation' {
            It 'When the requested option does not exist, throws an error' {
                { Set-SecurityOption -Name Invalid -Value 10 } | Should -Throw -ErrorId CannotResolveSecurityOption
            }

            It 'When the value is set to "Not Defined", throws an error' {
                { Set-SecurityOption -Name EnableLUA -Value 'Not Defined' } | Should -Throw -ErrorId CannotUseSetToReset
            }

            It 'When the value is defined by an enum, and the value is not a valid value, throws an error' {
                { Set-SecurityOption -Name EnableLUA -Value 'Invalid' } | Should -Throw -ErrorId InvalidValueForSecurityOption
            }
        }

        Context 'Registry value, key exists, value exists, value matches' {
            It 'Does not attempt to change the registry value' {
                Set-SecurityOption @defaultParams

                Assert-MockCalled Set-ItemProperty -Times 0
                Assert-MockCalled New-Item -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }
        }

        Context 'Registry value, key exists, value exists, value differs' {
            BeforeAll {
                Mock Get-ItemPropertyValue {
                    0
                }
            }

            It 'Updates the existing registry value' {
                Set-SecurityOption @defaultParams

                Assert-MockCalled Set-ItemProperty -Times 1
                Assert-MockCalled New-Item -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }

            It 'Handles empty string values' {
                $testParams = @{
                    Name  = 'LegalNoticeText'
                    Value = ''
                }

                Set-SecurityOption @testParams

                Assert-MockCalled Set-ItemProperty -Times 1
                Assert-MockCalled New-Item -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }

            It 'Handles empty array values' {
                $testParams = @{
                    Name = 'NullSessionShares'
                    Value = @()
                }

                Set-SecurityOption @testParams

                Assert-MockCalled Set-ItemProperty -Times 1
                Assert-MockCalled New-Item -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }
        }

        Context 'Registry value, key exists, value does not exist' {
            BeforeAll {
                Mock Get-Item {
                    [PSCustomObject]@{
                        PSPath = 'TestDrive:\Software\Microsoft'
                    } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {}
                }
            }

            It 'Creates a new registry value' {
                Set-SecurityOption @defaultParams

                Assert-MockCalled Set-ItemProperty -Times 0
                Assert-MockCalled New-Item -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 1
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }
        }

        Context 'Registry value, key does not exist, value does not exist' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'Creates a new key and adds the new registry value' {
                Set-SecurityOption @defaultParams

                Assert-MockCalled Set-ItemProperty -Times 0
                Assert-MockCalled New-Item -Times 1
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 1
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }
        }

        Context 'Registry value, new value, string type' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'Creates a MultiString registry value' {
                $testParams = @{
                    Name  = 'LegalNoticeText'
                    Value = 'NewValue'
                }

                Set-SecurityOption @testParams

                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 1
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }

            It 'Creates a new value holding an empty string' {
                $testParams = @{
                    Name  = 'LegalNoticeText'
                    Value = ''
                }

                Set-SecurityOption @testParams

                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 1
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 0
            }
        }

        Context 'Registry value, new value, multi-string type' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'Creates a MultiString registry value' {
                $testParams = @{
                    Name = 'NullSessionShares'
                    Value = @(
                        'First'
                        'Second'
                    )
                }

                Set-SecurityOption @testParams

                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 1
            }

            It 'Alloows an empty collection for a MultiString registry value' {
                $testParams = @{
                    Name = 'NullSessionShares'
                    Value = @()
                }

                Set-SecurityOption @testParams

                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'DWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'QWord' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'String' } -Times 0
                Assert-MockCalled New-ItemProperty -ParameterFilter { $PropertyType -eq 'MultiString' } -Times 1
            }
        }

        Context 'Class value' {
            BeforeAll {
                $contextParams = @{
                    Name  = 'GuestAccountStatus'
                    Value = 'Disabled'
                }
            }

            It 'When Test returns true, does nothing' {
                Set-SecurityOption @contextParams

                $Script:setCalled | Should -Be $false
            }

            It 'When Test returns false, calls Set' {
                $Script:testReturn = $false

                Set-SecurityOption @contextParams

                $Script:setCalled | Should -Be $true
            }
        }
    }
}