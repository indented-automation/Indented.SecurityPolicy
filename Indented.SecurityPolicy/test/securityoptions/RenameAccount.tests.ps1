InModuleScope Indented.SecurityPolicy {
    Describe RenameAccount {
        BeforeAll {
            Mock Get-LocalUser {
                [PSCustomObject]@{
                    Name = 'Guest'
                }
            }
            Mock Rename-LocalUser
        }

        BeforeEach {
            $class = [RenameAccount]@{
                SidType = 'AccountGuestSid'
                Value   = 'Guest'
            }
        }

        Context 'Get' {
            It 'Gets the current status of the account' {
                $class.Value = 'OtherName'
                $instance = $class.Get()
                $instance.Value | Should -Be 'Guest'
            }
        }

        Context 'Set' {
            It 'Calls Rename-LocalUser' {
                $class.Set()

                Assert-MockCalled Rename-LocalUser -Times 1 -Scope It
            }
        }

        Context 'Test' {
            It 'When the account name matches, returns true' {
                $class.Test() | Should -Be $true
            }

            It 'When the account name does not match, returns false' {
                $class.Value = 'NewName'

                $class.Test() | Should -Be $false
            }
        }
    }
}