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
    Describe GetIadsLocalUser {
        BeforeAll {
            $defaultParams = @{
                Sid = [System.Security.Principal.SecurityIdentifier]::new([Byte[]](@(1) * 12), 0)
            }
        }

        It 'Gets users from the local account database' {
            GetIadsLocalUser | Should -Not -BeNullOrEmpty
        }

        It 'Gets a user by name' {
            $guest = GetIadsLocalUser | Where-Object Sid -like '*501'

            GetIadsLocalUser -Name $guest.Name | Should -Not -BeNullOrEmpty
        }

        It 'Gets a user by SID' {
            $guest = GetIadsLocalUser | Where-Object Sid -like '*501'

            GetIadsLocalUser -Sid $guest.Sid | Should -Not -BeNullOrEmpty
        }
    }
}