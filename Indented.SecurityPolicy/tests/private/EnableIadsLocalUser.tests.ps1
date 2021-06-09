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
    Describe EnableIadsLocalUser {
        BeforeAll {
            Mock GetIadsLocalUser {
                [PSCustomObject]@{
                    DistinguishedName = ''
                    Path              = 'WinNT://DOMAIN/COMPUTER/Name'
                } |
                    Add-Member Get -MemberType ScriptMethod -PassThru -Value {
                        $Script:userFlagsValue
                    } |
                    Add-Member Put -MemberType ScriptMethod -PassThru -Value {
                        $Script:putValue = $args[1]
                    } |
                    Add-Member SetInfo -MemberType ScriptMethod -PassThru -Value {
                        $Script:setInfoCalled = $true
                    }
            }

            $defaultParams = @{
                Sid = [System.Security.Principal.SecurityIdentifier]::new([Byte[]](@(1) * 12), 0)
            }
        }

        BeforeEach {
            $Script:userFlagsValue = 2
            $Script:putValue = -1
            $Script:setInfoCalled = $false
        }

        It 'Calls GetIadsLocalUser to find the account' {
            EnableIadsLocalUser @defaultParams

            Assert-MockCalled GetIadsLocalUser -Scope It
        }

        It 'When the account is disabled, sets userFlags and calls SetInfo' {
            EnableIadsLocalUser @defaultParams

            $Script:putValue | Should -Be 0
            $Script:setInfoCalled | Should -BeTrue
        }

        It 'When the account is enabled, does nothing' {
            $Script:userFlagsValue = 0

            EnableIadsLocalUser @defaultParams

            $Script:putValue | Should -Be -1
            $Script:setInfoCalled | Should -BeFalse
        }
    }
}