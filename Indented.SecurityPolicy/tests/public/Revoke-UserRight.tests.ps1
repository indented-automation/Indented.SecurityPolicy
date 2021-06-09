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
    Describe Revoke-UserRight {
        BeforeAll {
            Mock CloseLsaPolicy
            Mock OpenLsaPolicy {
                [PSCustomObject]@{} |
                    Add-Member RemoveAccountRights -MemberType ScriptMethod -PassThru -Value {
                        $Script:removeWasCalled++
                    } |
                    Add-Member RemoveAllAccountRights -MemberType ScriptMethod -PassThru -Value {
                        $Script:removeAllWasCalled++
                    }
            }
            Mock Resolve-UserRight {
                [PSCustomObject]@{
                    Name = 'SeDenyServiceLogonRight'
                }
            }

            $defaultParams = @{
                AccountName = 'username'
                Name        = 'SeDenyServiceLogonRight'
            }
        }

        BeforeEach {
            $Script:removeWasCalled = 0
            $Script:removeAllWasCalled = 0
        }

        Context 'Removes an account from a right' {
            It 'Given a account to remove from a right, calls RemoveAccountRights' {
                Revoke-UserRight @defaultParams

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:removeWasCalled | Should -Be 1
                $Script:removeAllWasCalled | Should -Be 0
            }

            It 'When AllRights is set, removes the account from all assigned rights' {
                Revoke-UserRight -AccountName $defaultParams['AccountName'] -AllRights

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:removeWasCalled | Should -Be 0
                $Script:removeAllWasCalled | Should -Be 1
            }
        }

        Context 'ShouldProcess' {
            It 'When WhatIf is used, does not call RemoveAccountRights' {
                Revoke-UserRight @defaultParams -WhatIf

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:removeWasCalled | Should -Be 0
            }
        }

        Context 'Error handling - RemoveAccountRights' {
            BeforeAll {
                Mock OpenLsaPolicy {
                    [PSCustomObject]@{} |
                        Add-Member RemoveAccountRights -MemberType ScriptMethod -PassThru -Value {
                            throw 'remove error'
                        }
                }
            }

            It 'When RemoveAccountRights throws, writes an error' {
                { Revoke-UserRight @defaultParams -ErrorAction Stop } | Should -Throw 'remove error'
                { Revoke-UserRight @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 2
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1
            }
        }
    }
}