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

if ($psversiontable.PSVersion.Major -gt 5) {
    InModuleScope Indented.SecurityPolicy {
        Describe Disable-LocalUser {
            BeforeAll {
                Mock Get-LocalUser {
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
                $Script:userFlagsValue = 0
                $Script:putValue = -1
                $Script:setInfoCalled = $false
            }

            It 'Calls Get-LocalUser to find the account' {
                Disable-LocalUser @defaultParams

                Assert-MockCalled Get-LocalUser -Scope It
            }

            It 'When the account is enabled, sets userFlags and calls SetInfo' {
                Disable-LocalUser @defaultParams

                $Script:putValue | Should -Be 2
                $Script:setInfoCalled | Should -BeTrue
            }

            It 'When the account is disabled, does nothing' {
                $Script:userFlagsValue = 2

                Disable-LocalUser @defaultParams

                $Script:putValue | Should -Be -1
                $Script:setInfoCalled | Should -BeFalse
            }
        }
    }
}