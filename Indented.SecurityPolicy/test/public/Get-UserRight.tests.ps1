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
    Describe Get-UserRight {
        BeforeAll {
            Mock CloseLsaPolicy
            Mock OpenLsaPolicy {
                [PSCustomObject]@{} |
                    Add-Member EnumerateAccountsWithUserRight -MemberType ScriptMethod -PassThru -Value {
                        'username'
                    }
            }
            Mock Resolve-UserRight {
                [PSCustomObject]@{
                    Name        = 'SeDenyServiceLogonRight'
                    Description = 'Deny log on as a service'
                }
            }

            $defaultParams = @{
                Name = 'SeDenyServiceLogonRight'
            }
        }

        Context 'Accounts are assigned to the right' {
            It 'When one or more accounts is assigned to the right, returns the list of accounts' {
                $result = Get-UserRight @defaultParams

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $result | Should -Not -BeNullOrEmpty
                @($result).Count | Should -Be 1
                $result.Name | Should -Be 'SeDenyServiceLogonRight'
                $result.Description | Should -Be 'Deny log on as a service'
                $result.AccountName | Should -Be 'username'
            }
        }

        Context 'Error handling - EnumerateAccountsWithUserRight' {
            BeforeAll {
                Mock OpenLsaPolicy {
                    [PSCustomObject]@{} |
                        Add-Member EnumerateAccountsWithUserRight -MemberType ScriptMethod -PassThru -Value {
                            throw 'enumerate error'
                        }
                }
            }

            It 'When EnumerateAccountsWithUserRight throws, writes an error' {
                { Get-UserRight @defaultParams -ErrorAction Stop } | Should -Throw 'enumerate error'
                { Get-UserRight @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 2
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1
            }
        }
    }
}