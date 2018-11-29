InModuleScope Indented.SecurityPolicy {
    Describe AccountStatus {
        BeforeAll {
            Mock Get-LocalUser {
                [PSCustomObject]@{
                    Enabled = $true
                }
            }
            Mock Enable-LocalUser
            Mock Disable-LocalUser
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
            It 'When the account should be enabled, calls Enable-LocalUser' {
                $class.Set()

                Assert-MockCalled Enable-LocalUser -Times 1 -Scope It
                Assert-MockCalled Disable-LocalUser -Times 0 -Scope It
            }

            It 'When the account should be disabled, calls Disable-LocalUser' {
                $class.Value = 'Disabled'
                $class.Set()

                Assert-MockCalled Enable-LocalUser -Times 0 -Scope It
                Assert-MockCalled Disable-LocalUser -Times 1 -Scope It
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
                Mock Get-LocalUser {
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