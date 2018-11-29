InModuleScope Indented.SecurityPolicy {
    Describe Set-UserRight {

        BeforeAll {
            Mock CloseLsaPolicy
            Mock OpenLsaPolicy {
                [PSCustomObject]@{} |
                    Add-Member EnumerateAccountsWithUserRight -MemberType ScriptMethod -PassThru -Value {
                        $Script:accountNames
                    } |
                    Add-Member AddAccountRights -MemberType ScriptMethod -PassThru -Value {
                        $Script:addWasCalled++
                    } |
                    Add-Member RemoveAccountRights -MemberType ScriptMethod -PassThru -Value {
                        $Script:removeWasCalled++
                    }
            }
            Mock Resolve-UserRight {
                [PSCustomObject]@{
                    Name = 'SeDenyServiceLogonRight'
                }
            }

            $defaultParams = @{
                AccountName = 'Administrators', 'NT AUTHORITY\SYSTEM'
                Name        = 'SeDenyServiceLogonRight'
            }
        }

        BeforeEach {
            $Script:addWasCalled = 0
            $Script:removeWasCalled = 0

            $Script:accountNames = @(
                [System.Security.Principal.NTAccount]'Administrators',
                [System.Security.Principal.NTAccount]'NT AUTHORITY\SYSTEM'
            )
        }

        Context 'Account list matches' {
            It 'When no changes are required, does not call AddAccountRights or RemoveAccountRights' {
                Set-UserRight @defaultParams

                $Script:addWasCalled | Should -Be 0
                $Script:removeWasCalled | Should -Be 0
            }
        }

        Context 'Account list does not match' {
            BeforeEach {
                $Script:accountNames = [System.Security.Principal.NTAccount]'NT AUTHORITY\NETWORK SERVICE'
            }

            It 'When changes are required, adds and removes accounts' {
                Set-UserRight @defaultParams

                $Script:addWasCalled | Should -Be 2
                $Script:removeWasCalled | Should -Be 1
            }
        }

        Context 'Account list partial match' {
            BeforeEach {
                $Script:accountNames = @(
                    [System.Security.Principal.NTAccount]'NT AUTHORITY\NETWORK SERVICE',
                    [System.Security.Principal.NTAccount]'Administrators'
                )
            }

            It 'When changes are required, adds and removes accounts, but does not remove matching accounts' {
                Set-UserRight @defaultParams

                $Script:addWasCalled | Should -Be 1
                $Script:removeWasCalled | Should -Be 1
            }
        }

        Context 'Account list type handling' {
            BeforeEach {
                $Script:accountNames = [System.Security.Principal.NTAccount]'Administrators'
            }

            It 'Converts a string to a SecurityIdentifier for comparison' {
                $accountName = 'Administrators'

                Set-UserRight -AccountName $accountName -Name $defaultParams['Name']

                $Script:addWasCalled | Should -Be 0
                $Script:removeWasCalled | Should -Be 0
            }

            It 'Converts an NTAccount to a SecurityIdentifier for comparison' {
                $accountName = [System.Security.Principal.NTAccount]'Administrators'

                Set-UserRight -AccountName $accountName -Name $defaultParams['Name']

                $Script:addWasCalled | Should -Be 0
                $Script:removeWasCalled | Should -Be 0
            }

            It 'Accepts SecurityIdentifier values' {
                $accountName = ([System.Security.Principal.NTAccount]'Administrators').Translate([System.Security.Principal.SecurityIdentifier])

                Set-UserRight -AccountName $accountName -Name $defaultParams['Name']

                $Script:addWasCalled | Should -Be 0
                $Script:removeWasCalled | Should -Be 0
            }
        }
    }
}