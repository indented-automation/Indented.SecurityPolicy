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
    Describe Clear-UserRight {
        BeforeAll {
            Mock CloseLsaPolicy
            Mock OpenLsaPolicy {
                [PSCustomObject]@{} |
                    Add-Member EnumerateAccountsWithUserRight -MemberType ScriptMethod -PassThru -Value {
                        $Script:accountNames
                    } |
                    Add-Member RemoveAccountRights -MemberType ScriptMethod -PassThru -Value {
                        $Script:removeWasCalled++
                    }
            }
            Mock Resolve-UserRight {
                [PSCustomObject]@{
                    Name = 'SeDenyServiceLogonRight'
                }
            }

            $defaultParams = @{
                Name = 'SeDenyServiceLogonRight'
            }
        }

        BeforeEach {
            $Script:removeWasCalled = 0
            $Script:accountNames = 'first', 'second'
        }

        Context 'Accounts are assigned the right' {
            It 'When a policy has accounts defined, removes all accounts' {
                Clear-UserRight @defaultParams

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:removeWasCalled | Should -Be 2
            }
        }

        Context 'No accounts are assigned the right' {
            BeforeEach {
                $Script:accountNames = $null
            }

            It 'When a policy does not have accounts assigned, does nothing' {
                Clear-UserRight @defaultParams

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:removeWasCalled | Should -Be 0
            }
        }

        Context 'Error handling - EnumerateAccountsWithUserRight' {
            BeforeAll {
                Mock OpenLsaPolicy {
                    [PSCustomObject]@{} |
                        Add-Member EnumerateAccountsWithUserRight -MemberType ScriptMethod -PassThru -Value {
                            throw 'enumerate error'
                        } |
                        Add-Member RemoveAccountRights -MemberType ScriptMethod -PassThru -Value {
                            $Script:removeWasCalled++
                        }
                }
            }

            It 'When EnumerateAccountsWithUserRight throws, writes an error' {
                { Clear-UserRight @defaultParams -ErrorAction Stop } | Should -Throw 'enumerate error'
                { Clear-UserRight @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 2
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1
            }
        }

        Context 'Error handling - RemoveAccountRights' {
            BeforeAll {
                Mock OpenLsaPolicy {
                    [PSCustomObject]@{} |
                        Add-Member EnumerateAccountsWithUserRight -MemberType ScriptMethod -PassThru -Value {
                            $Script:accountNames
                        } |
                        Add-Member RemoveAccountRights -MemberType ScriptMethod -PassThru -Value {
                            throw 'remove error'
                        }
                }
            }

            It 'When RemoveAccountRights throws, writes an error' {
                { Clear-UserRight @defaultParams -ErrorAction Stop } | Should -Throw 'remove error'
                { Clear-UserRight @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 2
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1
            }
        }
    }
}