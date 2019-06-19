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
    Describe ImportUserRightData {
        AfterAll {
            ImportUserRightData
        }

        Context 'Import' {
            BeforeAll {
                Mock Import-LocalizedData {
                    Set-Variable $BindingVariable -Scope Script -Value @{
                        SeTrustedCredManAccessPrivilege = 'Access Credential Manager as a trusted caller'
                        SeNetworkLogonRight             = 'Access this computer from the network'
                    }
                }
            }

            BeforeEach {
                $Script:userRightData = $null
                $Script:userRightLookupHelper = $null
            }

            It 'Fills a module scoped hashtable with values' {
                ImportUserRightData

                $Script:userRightData | Should -Not -BeNullOrEmpty
                $Script:userRightLookupHelper | Should -Not -BeNullOrEmpty
            }

            It 'Converts the description "<description>" to the constant name "<name>"' -TestCases @(
                @{ Description = 'Access Credential Manager as a trusted caller'; Name = 'SeTrustedCredManAccessPrivilege' }
                @{ Description = 'Access this computer from the network';         Name = 'SeNetworkLogonRight' }
            ) {
                param ( $Description, $Name )

                ImportUserRightData

                $Script:userRightLookupHelper.Contains($Description) | Should -Be $true
                $Script:userRightLookupHelper[$Description] | Should -Be $Name
            }
        }
    }
}