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
        Describe Get-LocalUser {
            BeforeAll {
                $defaultParams = @{
                    Sid = [System.Security.Principal.SecurityIdentifier]::new([Byte[]](@(1) * 12), 0)
                }
            }

            It 'Gets users from the local account database' {
                Get-LocalUser | Should -Not -BeNullOrEmpty
            }

            It 'Gets a user by name' {
                $guest = Get-LocalUser | Where-Object Sid -like '*501'

                Get-LocalUser -Name $guest.Name | Should -Not -BeNullOrEmpty
            }

            It 'Gets a user by SID' {
                $guest = Get-LocalUser | Where-Object Sid -like '*501'

                Get-LocalUser -Sid $guest.Sid | Should -Not -BeNullOrEmpty
            }
        }
    }
}