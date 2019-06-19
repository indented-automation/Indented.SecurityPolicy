$enumeration = @(
    'SecurityOptions\AllocateDASD'
    'SecurityOptions\AuditNTLMInDomain'
    'SecurityOptions\AuditReceivingNTLMTraffic'
    'SecurityOptions\ConsentPromptBehaviorAdmin'
    'SecurityOptions\ConsentPromptBehaviorUser'
    'SecurityOptions\DontDisplayLockedUserId'
    'SecurityOptions\ForceGuest'
    'SecurityOptions\ForceKeyProtection'
    'SecurityOptions\LdapClientIntegrity'
    'SecurityOptions\LdapServerIntegrity'
    'SecurityOptions\LmCompatibilityLevel'
    'SecurityOptions\NoConnectedUser'
    'SecurityOptions\NTLMMinSec'
    'SecurityOptions\RestrictNTLMInDomain'
    'SecurityOptions\RestrictReceivingNTLMTraffic'
    'SecurityOptions\RestrictSendingNTLMTraffic'
    'SecurityOptions\ScRemoveOption'
    'SecurityOptions\SmbServerNameHardeningLevel'
    'SecurityOptions\SupportedEncryptionTypes'
    'Enabled'
    'Ensure'
    'RegistryValueType'
)

foreach ($file in $enumeration) {
    . ("{0}\enum\{1}.ps1" -f $psscriptroot, $file)
}

$class = @(
    'Dsc\GroupManagedServiceAccount'
    'Dsc\RegistryPolicy'
    'Dsc\SecurityOption'
    'Dsc\UserRightAssignment'
    'SecurityOptions\AccountBase'
    'SecurityOptions\AccountStatus'
    'SecurityOptions\AccountStatusAdministrator'
    'SecurityOptions\AccountStatusGuest'
    'SecurityOptions\RenameAccount'
    'SecurityOptions\RenameAccountAdministrator'
    'SecurityOptions\RenameAccountGuest'
)

foreach ($file in $class) {
    . ("{0}\class\{1}.ps1" -f $psscriptroot, $file)
}

$private = @(
    'CloseLsaPolicy'
    'GetMachineSid'
    'GetSecurityOptionData'
    'ImportSecurityOptionData'
    'ImportUserRightData'
    'NewImplementingType'
    'OpenLsaPolicy'
)

foreach ($file in $private) {
    . ("{0}\private\{1}.ps1" -f $psscriptroot, $file)
}

$public = @(
    'Clear-UserRight'
    'Get-AssignedUserRight'
    'Get-SecurityOption'
    'Get-UserRight'
    'Grant-UserRight'
    'Install-GroupManagedServiceAccount'
    'Reset-SecurityOption'
    'Resolve-SecurityOption'
    'Resolve-UserRight'
    'Revoke-UserRight'
    'Set-SecurityOption'
    'Set-UserRight'
    'Test-GroupManagedServiceAccount'
    'Uninstall-GroupManagedServiceAccount'
)

foreach ($file in $public) {
    . ("{0}\public\{1}.ps1" -f $psscriptroot, $file)
}

$functionsToExport = @(
    'Clear-UserRight'
    'Get-AssignedUserRight'
    'Get-SecurityOption'
    'Get-UserRight'
    'Grant-UserRight'
    'Install-GroupManagedServiceAccount'
    'Reset-SecurityOption'
    'Resolve-SecurityOption'
    'Resolve-UserRight'
    'Revoke-UserRight'
    'Set-SecurityOption'
    'Set-UserRight'
    'Test-GroupManagedServiceAccount'
    'Uninstall-GroupManagedServiceAccount'
)
Export-ModuleMember -Function $functionsToExport

. ("{0}\InitializeModule.ps1" -f $psscriptroot)
InitializeModule

