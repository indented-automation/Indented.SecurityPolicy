InModuleScope Indented.SecurityPolicy {
    Describe ImportSecurityOptionData {
        AfterAll {
            ImportSecurityOptionData
        }

        Context 'Import' {
            BeforeAll {
                Mock Import-LocalizedData {
                    @{
                        EnableLUA             = 'User Account Control: Run all administrators in Admin Approval Mode'
                        PromptOnSecureDesktop = 'User Account Control: Switch to the secure desktop when prompting for elevation'
                    }
                }
                Mock Import-PowerShellDataFile {
                    @{
                        EnableLUA = @{
                            Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
                            ValueType  = 'Enabled'
                            Default    = 'Enabled'
                        }
                        PromptOnSecureDesktop = @{
                            Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
                            ValueType  = 'Enabled'
                            Default    = 'Enabled'
                        }
                    }
                }
            }

            BeforeEach {
                $Script:securityOptionData = $null
                $Script:securityOptionLookupHelper = $null
            }

            It 'Fills a module scoped hashtable with values' {
                ImportSecurityOptionData

                $Script:securityOptionData | Should -Not -BeNullOrEmpty
                $Script:securityOptionLookupHelper | Should -Not -BeNullOrEmpty
            }

            It 'Converts the description "<description>" to the name "<name>"' -TestCases @(
                @{ Description = 'User Account Control: Run all administrators in Admin Approval Mode';             Name = 'EnableLUA' }
                @{ Description = 'User Account Control: Switch to the secure desktop when prompting for elevation'; Name = 'PromptOnSecureDesktop' }
            ) {
                param ( $Description, $Name )

                ImportSecurityOptionData

                $Script:securityOptionLookupHelper.Contains($Description) | Should -Be $true
                $Script:securityOptionLookupHelper[$Description] | Should -Be $Name
            }
        }
    }
}