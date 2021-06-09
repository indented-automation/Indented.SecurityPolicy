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
    Describe Reset-SecurityOption {
        BeforeAll {
            Mock Remove-ItemProperty
            Mock Get-Item {
                [PSCustomObject]@{
                    PSPath = 'TestDrive:\Software\Microsoft'
                } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {
                    return @('MachineAccessRestriction')
                }
            }
            Mock Set-SecurityOption
            Mock Test-Path { $true }

            $defaultParams = @{
                Name = 'MachineAccessRestriction'
            }
        }

        Context 'Registry value, "Not Defined", key exists, value exists' {
            BeforeAll {
                $contextParams = @{
                    Name = 'MachineAccessRestriction'
                }
            }

            It 'When the default value is "Not Defined", removes the registry value' {
                Reset-SecurityOption @contextParams

                Assert-MockCalled Remove-ItemProperty -Times 1 -Scope It
                Assert-MockCalled Set-SecurityOption -Times 0 -Scope It
            }
        }

        Context 'Registry value, "Not Defined", key does not exist' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'When the key does not exist, does nothing' {
                Reset-SecurityOption @defaultParams

                Assert-MockCalled Remove-ItemProperty -Times 0
                Assert-MockCalled Set-SecurityOption -Times 0
            }
        }

        Context 'Registry value, "Not Defined", value does not exist' {
            BeforeAll {
                Mock Get-Item {
                    [PSCustomObject]@{
                        PSPath = 'TestDrive:\Software\Microsoft'
                    } | Add-Member GetValueNames -MemberType ScriptMethod -PassThru -Value {}
                }
            }

            It 'When the value does not exist, does nothing' {
                Reset-SecurityOption @defaultParams

                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-SecurityOption -Times 0 -Scope It
            }
        }

        Context 'All values other than "Not Defined"' {
            It 'When a class-based change is requested, calls Set-SecurityOption' {
                $testParams = @{
                    Name = 'GuestAccountStatus'
                }

                Reset-SecurityOption @testParams

                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-SecurityOption -Times 1 -Scope It
            }

            It 'When a registry change is requested, and the default value is something other than "Not Defined"' {
                $testParams = @{
                    Name = 'LimitBlankPasswordUse'
                }

                Reset-SecurityOption @testParams

                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-SecurityOption -Times 1 -Scope It
            }

            It 'When the default value is an empty string, passes the empty string to Set-SecurityOption' {
                $testParams = @{
                    Name = 'LegalNoticeText'
                }

                Reset-SecurityOption @testParams

                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-SecurityOption -Times 1 -Scope It
            }

            It 'When the default value is an empty array, passes the empty array to Set-SecurityOption' {
                $testParams = @{
                    Name = 'NullSessionShares'
                }

                Reset-SecurityOption @testParams

                Assert-MockCalled Remove-ItemProperty -Times 0 -Scope It
                Assert-MockCalled Set-SecurityOption -Times 1 -Scope It
            }
        }
    }
}