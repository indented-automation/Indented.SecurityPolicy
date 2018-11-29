InModuleScope Indented.SecurityPolicy {
    Describe GroupManagedServiceAccount {
        BeforeAll {
            Mock Install-GroupManagedServiceAccount
            Mock Test-GroupManagedServiceAccount {
                return $true
            }
            Mock Uninstall-GroupManagedServiceAccount
        }

        BeforeEach {
            $class = [GroupManagedServiceAccount]::new()
            $class.Ensure = 'Present'
            $class.Name = 'accountName$'
        }

        Context 'Get, account is present' {
            It 'When the account is present, sets Ensure to present' {
                $class.Ensure = 'Absent'

                $instance = $class.Get()
                $instance.Ensure | Should -Be 'Present'
            }
        }

        Context 'Get, account is absent' {
            BeforeAll {
                Mock Test-GroupManagedServiceAccount {
                    return $false
                }
            }

            It 'When the account is absent, sets Ensure to absent' {
                $class.Ensure = 'Present'

                $instance = $class.Get()
                $instance.Ensure | Should -Be 'Absent'
            }
        }

        Context 'Set, account is present' {
            It 'When ensure is present, does nothing' {
                $class.Ensure = 'Present'
                $class.Set()

                Assert-MockCalled Install-GroupManagedServiceAccount -Times 0 -Scope It
                Assert-MockCalled Uninstall-GroupManagedServiceAccount -Times 0 -Scope It
            }

            It 'When ensure is absent, uninstalls the account' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Install-GroupManagedServiceAccount -Times 0 -Scope It
                Assert-MockCalled Uninstall-GroupManagedServiceAccount -Times 1 -Scope It
            }
        }

        Context 'Set, account is absent' {
            BeforeAll {
                Mock Test-GroupManagedServiceAccount {
                    return $false
                }
            }

            It 'When ensure is present, installs the account' {
                $class.Ensure = 'Present'
                $class.Set()

                Assert-MockCalled Install-GroupManagedServiceAccount -Times 1 -Scope It
                Assert-MockCalled Uninstall-GroupManagedServiceAccount -Times 0 -Scope It
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Install-GroupManagedServiceAccount -Times 0 -Scope It
                Assert-MockCalled Uninstall-GroupManagedServiceAccount -Times 0 -Scope It
            }
        }

        Context 'Test, account is present' {
            It 'When ensure is present, returns true' {
                $class.Ensure = 'Present'

                $class.Test() | Should -Be $true
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, account is absent' {
            BeforeAll {
                Mock Test-GroupManagedServiceAccount {
                    return $false
                }
            }

            It 'When ensure is present, returns false' {
                $class.Ensure = 'Present'

                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, returns true' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $true
            }
        }
    }
}