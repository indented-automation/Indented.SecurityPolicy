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
    Describe RenameAccount {
        BeforeAll {
            Mock GetIadsLocalUser {
                [PSCustomObject]@{
                    Name = 'Guest'
                }
            }
            Mock RenameIadsLocalUser
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
            It 'Calls RenameIadsLocalUser' {
                $class.Set()

                Assert-MockCalled RenameIadsLocalUser -Times 1 -Scope It
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