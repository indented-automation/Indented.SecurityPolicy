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
    Describe Grant-UserRight {
        BeforeAll {
            Mock CloseLsaPolicy
            Mock OpenLsaPolicy {
                [PSCustomObject]@{} |
                    Add-Member AddAccountRights -MemberType ScriptMethod -PassThru -Value {
                        $Script:addWasCalled++
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
            $Script:addWasCalled = 0
        }

        Context 'Add an account to a right' {
            It 'Given a account to add to a right, calls AddAccountRights' {
                Grant-UserRight @defaultParams

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:addWasCalled | Should -Be 1
            }
        }

        Context 'ShouldProcess' {
            It 'When WhatIf is used, does not call AddAccountRights' {
                Grant-UserRight @defaultParams -WhatIf

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $Script:addWasCalled | Should -Be 0
            }
        }

        Context 'Error handling - AddAccountRights' {
            BeforeAll {
                Mock OpenLsaPolicy {
                    [PSCustomObject]@{} |
                        Add-Member AddAccountRights -MemberType ScriptMethod -PassThru -Value {
                            throw 'add error'
                        }
                }
            }

            It 'When AddAccountRights throws, writes an error' {
                { Grant-UserRight @defaultParams -ErrorAction Stop } | Should -Throw 'add error'
                { Grant-UserRight @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 2
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1
            }
        }
    }
}