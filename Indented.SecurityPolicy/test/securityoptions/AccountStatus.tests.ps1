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
    Describe AccountStatus {
        BeforeAll {
            Mock GetIadsLocalUser {
                [PSCustomObject]@{
                    Enabled = $true
                }
            }
            Mock EnableIadsLocalUser
            Mock DisableIadsLocalUser
        }

        BeforeEach {
            $class = [AccountStatus]@{
                SidType = 'AccountGuestSid'
                Value   = 'Enabled'
            }
        }

        Context 'Get' {
            It 'Gets the current status of the account' {
                $class.Value = 'Disabled'
                $instance = $class.Get()
                $instance.Value | Should -Be 'Enabled'
            }
        }

        Context 'Set' {
            It 'When the account should be enabled, calls EnableIadsLocalUser' {
                $class.Set()

                Assert-MockCalled EnableIadsLocalUser -Times 1 -Scope It
                Assert-MockCalled DisableIadsLocalUser -Times 0 -Scope It
            }

            It 'When the account should be disabled, calls DisableIadsLocalUser' {
                $class.Value = 'Disabled'
                $class.Set()

                Assert-MockCalled EnableIadsLocalUser -Times 0 -Scope It
                Assert-MockCalled DisableIadsLocalUser -Times 1 -Scope It
            }
        }

        Context 'Test, account is enabled' {
            It 'When the account should be enabled, returns true' {
                $class.Test() | Should -Be $true
            }

            It 'When the account should be disabled, returns false' {
                $class.Value = 'Disabled'

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, account is disabled' {
            BeforeAll {
                Mock GetIadsLocalUser {
                    [PSCustomObject]@{
                        Enabled = $false
                    }
                }
            }

            It 'When the account should be disabled, returns true' {
                $class.Value = 'Disabled'

                $class.Test() | Should -Be $true
            }

            It 'When the account should be enabled, returns false' {
                $class.Test() | Should -Be $false
            }
        }
    }
}