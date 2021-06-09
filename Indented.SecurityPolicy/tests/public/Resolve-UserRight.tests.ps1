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
    Describe Resolve-UserRight {
        It 'Given a constant name, returns an object with the same name' {
            $userRight = Resolve-UserRight SeMachineAccountPrivilege

            $userRight.Name | Should -Be SeMachineAccountPrivilege
            $userRight.Description | Should -Be 'Add workstations to domain'
        }

        It 'Given a descriptive name, returns an object with the constant name' {
            $userRight = Resolve-UserRight 'Add workstations to domain'

            $userRight.Name | Should -Be SeMachineAccountPrivilege
            $userRight.Description | Should -Be 'Add workstations to domain'
        }

        It 'Given a wildcard, returns all rights with matching descriptions' {
            $userRight = Resolve-UserRight "*batch*"

            @($userRight).Count | Should -Be 2
            $userRight.Name | Should -Contain 'SeDenyBatchLogonRight'
            $userRight.Name | Should -Contain 'SeBatchLogonRight'
        }
    }
}