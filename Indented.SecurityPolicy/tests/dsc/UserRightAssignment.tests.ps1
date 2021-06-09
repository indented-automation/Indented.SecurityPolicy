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
    Describe 'UserRightAssignment' {
        BeforeAll {
            Mock Clear-UserRight
            Mock Get-UserRight {
                [PSCustomObject]@{
                    Name        = 'SeBatchLogonRight'
                    Description = 'Log on as a batch job'
                    AccountName = @(
                        [System.Security.Principal.NTAccount]'Administrator'
                        [System.Security.Principal.NTAccount]'NT AUTHORITY\SYSTEM'
                    )
                }
            }
            Mock Grant-UserRight
            Mock Set-UserRight
            Mock Revoke-UserRight
        }

        BeforeEach {
            $class = [UserRightAssignment]::new()
            $class.Ensure = 'Present'
            $class.Name = 'Log on as a batch job'
            $class.AccountName = 'Administrator', 'NT AUTHORITY\SYSTEM'
        }

        Context 'Get' {
            It 'Updates the AccountName property with the current list of accounts' {
                $class.AccountName = 'NT AUTHORITY\NETWORK SERVICE'
                $instance = $class.Get()

                $instance.AccountName -contains 'Administrator' | Should -Be $true
                $instance.AccountName -contains 'NT AUTHORITY\SYSTEM' | Should -Be $true
            }
        }

        Context 'Set, all accounts present' {
            It 'When ensure is present, does nothing' {
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }

            It 'When ensure is present, and replace is set, calls Set-UserRight' {
                $class.Replace = $true
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 1 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }

            It 'When ensure is absent, removes each matching account' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 2 -Scope It
            }
        }

        Context 'Set, all accounts absent' {
            BeforeAll {
                Mock Get-UserRight
            }

            It 'When ensure is present, adds the missing accounts' {
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 2 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }

            It 'When ensure is absent, does nothing' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }
        }

        Context 'Set, clear account list' {
            It 'When ensure is absent, the account list is empty, clears the list' {
                $class.Ensure = 'Absent'
                $class.AccountName = $null
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 1 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }
        }

        Context 'Set, account list overlaps' {
            BeforeAll {
                Mock Get-UserRight {
                    [PSCustomObject]@{
                        Name        = 'SeBatchLogonRight'
                        Description = 'Log on as a batch job'
                        AccountName = @(
                            [System.Security.Principal.NTAccount]'NT AUTHORITY\NETWORK SERVICE'
                            [System.Security.Principal.NTAccount]'NT AUTHORITY\SYSTEM'
                        )
                    }
                }
            }

            It 'When ensure is present, adds missing accounts' {
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 1 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }

            It 'When ensure is absent, removes matching accounts' {
                $class.Ensure = 'Absent'
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 0 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 1 -Scope It
            }

            It 'When ensure is present, and replace is set, calls Set-UserRight' {
                $class.Replace = $true
                $class.Set()

                Assert-MockCalled Clear-UserRight -Times 0 -Scope It
                Assert-MockCalled Grant-UserRight -Times 0 -Scope It
                Assert-MockCalled Set-UserRight -Times 1 -Scope It
                Assert-MockCalled Revoke-UserRight -Times 0 -Scope It
            }
        }

        Context 'Test, all accounts present' {
            It 'When ensure is present, returns true' {
                $class.Test() | Should -Be $true
            }

            It 'When ensure is present, and replace is set, returns true' {
                $class.Replace = $true

                $class.Test() | Should -Be $true
            }

            It 'When ensure is absent, returns false' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, all accounts absent' {
            BeforeAll {
                Mock Get-UserRight
            }

            It 'When ensure is persent, returns false' {
                $class.Test() | Should -Be $false
            }

            It 'When ensure is present, and replace is set, returns false' {
                $class.Replace = $true

                $class.Test() | Should -Be $false
            }

            It 'When ensure is absent, returns true' {
                $class.Ensure = 'Absent'

                $class.Test() | Should -Be $true
            }
        }

        Context 'Test, clear account list' {
            It 'When ensure is absent, the account list is empty, returns false' {
                $class.Ensure = 'Absent'
                $class.AccountName = $null

                $class.Test() | Should -Be $false
            }
        }

        Context 'Test, account list overlaps' {
            BeforeAll {
                Mock Get-UserRight {
                    [PSCustomObject]@{
                        Name        = 'SeBatchLogonRight'
                        Description = 'Log on as a batch job'
                        AccountName = @(
                            [System.Security.Principal.NTAccount]'NT AUTHORITY\NETWORK SERVICE'
                            [System.Security.Principal.NTAccount]'NT AUTHORITY\SYSTEM'
                        )
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

        Context 'Parameter initialization and validation' {
            It 'When the user right does not exist, throws an error' {
                $class.Name = 'NonExistent'

                { $class.InitializeRequest() } | Should -Throw
            }

            It 'When the user right is ambiguous, throws an error' {
                $class.Name = '*batch*'

                { $class.InitializeRequest() } | Should -Throw 'The requested user right is ambiguous, matched right names'
            }

            It 'When ensure is present, and AccountName is null, throws an error' {
                $class.AccountName = $null

                { $class.InitializeRequest() } | Should -Throw 'Invalid request. AccountName cannot be empty when ensuring a right is present.'
            }

            It 'When ensure is absent, and Replace is set, throws an error' {
                $class.Ensure = 'Absent'
                $class.Replace = $true

                { $class.InitializeRequest() } | Should -Throw 'Replace may only be set when ensuring a set of accounts is present.'
            }
        }
    }
}