InModuleScope Indented.SecurityPolicy {
    Describe Resolve-SecurityOption {
        It 'Resolves data for the localized policy <Name>' -TestCases $(
            foreach ($name in $Script:securityOptionData.Keys) {
                @{ Name = $name }
            }
        ) {
            param (
                $Name
            )

            $Script:securityOptionData[$Name].Description | Should -Not -BeNullOrEmpty
        }

        It 'Gets option information based on the short name' {
            $securityOptionInfo = Resolve-SecurityOption 'EnableLUA'

            $securityOptionInfo | Should -Not -BeNullOrEmpty
            $securityOptionInfo.Name | Should -Be 'EnableLUA'
            $securityOptionInfo.Default | Should -Be 'Enabled'
        }

        It 'Gets option information based on the description' {
            $securityOptionInfo = Resolve-SecurityOption 'User Account Control: Run all administrators in Admin Approval Mode'

            $securityOptionInfo | Should -Not -BeNullOrEmpty
            $securityOptionInfo.Name | Should -Be 'EnableLUA'
            $securityOptionInfo.Default | Should -Be 'Enabled'
        }

        It 'Finds option information based on the description when a wildcard is used' {
            $securityOptionInfo = Resolve-SecurityOption 'User*'

            $securityOptionInfo | Should -Not -BeNullOrEmpty
            $securityOptionInfo.Name | Should -Contain 'EnableLUA'
        }

        It 'Finds option information based on the category' {
            $securityOptionInfo = Resolve-SecurityOption -Category 'User Account Control'

            $securityOptionInfo | Should -Not -BeNullOrEmpty
            $securityOptionInfo.Name | Should -Contain 'EnableLUA'
        }

        It 'When an invalid option is passed, throws an error' {
            { Resolve-SecurityOption 'Invalid' } | Should -Throw -ErrorId 'CannotResolveSecurityOption'
        }
    }
}