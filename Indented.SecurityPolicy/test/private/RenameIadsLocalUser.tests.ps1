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
    Describe RenameIadsLocalUser {
        BeforeAll {
            Mock GetIadsLocalUser {
                [PSCustomObject]@{
                    DistinguishedName = ''
                    Path              = 'WinNT://DOMAIN/COMPUTER/Name'
                } |
                    Add-Member Get -MemberType ScriptMethod -PassThru -Value {
                        $Script:currentName
                    } |
                    Add-Member Rename -MemberType ScriptMethod -PassThru -Value {
                        $Script:renameCalled = $true
                    }
            }

            $defaultParams = @{
                Sid     = [System.Security.Principal.SecurityIdentifier]::new([Byte[]](@(1) * 12), 0)
                NewName = 'notguest'
            }
        }

        BeforeEach {
            $Script:currentName = 'guest'
            $Script:renameCalled = $false
        }

        It 'Calls GetIadsLocalUser to find the account' {
            RenameIadsLocalUser @defaultParams

            Assert-MockCalled GetIadsLocalUser -Scope It
        }

        It 'When the account has a different name, calls Rename' {
            RenameIadsLocalUser @defaultParams

            $Script:renameCalled | Should -BeTrue
        }

        It 'When the account is already named after NewName, does nothing' {
            $Script:currentName = 'notguest'

            RenameIadsLocalUser @defaultParams

            $Script:renameCalled | Should -BeFalse
        }
    }
}