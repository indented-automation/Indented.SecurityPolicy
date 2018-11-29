InModuleScope Indented.SecurityPolicy {
    Describe Get-AssignedUserRight {
        BeforeAll {
            Mock CloseLsaPolicy
            Mock OpenLsaPolicy {
                [PSCustomObject]@{} |
                    Add-Member EnumerateAccountRights -MemberType ScriptMethod -PassThru -Value {
                        'SeDenyServiceLogonRight'
                    }
            }

            $defaultParams = @{
                AccountName = 'username'
            }
        }

        Context 'Account has rights assigned' {
            It 'When a account has rights assigned, returns the rights' {
                $result = Get-AssignedUserRight @defaultParams

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 1
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1

                $result | Should -Not -BeNullOrEmpty
                @($result).Count | Should -Be 1
                $result.AccountName | Should -Be 'username'
                $result.Name | Should -Be 'SeDenyServiceLogonRight'
            }
        }

        Context 'Error handling - EnumerateAccountsWithUserRight' {
            BeforeAll {
                Mock OpenLsaPolicy {
                    [PSCustomObject]@{} |
                        Add-Member EnumerateAccountRights -MemberType ScriptMethod -PassThru -Value {
                            throw 'enumerate error'
                        }
                }
            }

            It 'When EnumerateAccountRights throws, writes an error' {
                { Get-AssignedUserRight @defaultParams -ErrorAction Stop } | Should -Throw 'enumerate error'
                { Get-AssignedUserRight @defaultParams -ErrorAction SilentlyContinue } | Should -Not -Throw

                Assert-MockCalled OpenLsaPolicy -Scope It -Times 2
                Assert-MockCalled CloseLsaPolicy -Scope It -Times 1
            }
        }
    }
}