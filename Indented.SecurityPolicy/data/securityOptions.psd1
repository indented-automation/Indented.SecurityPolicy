@{
    AdministratorAccountStatus = @{
        Class      = 'AccountStatusAdministrator'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    NoConnectedUser = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'NoConnectedUser'
        Default    = 'Not Defined'
    }
    GuestAccountStatus = @{
        Class      = 'AccountStatusGuest'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    LimitBlankPasswordUse = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    RenameAdministratorAccount = @{
        Class      = 'RenameAccountAdministrator'
        ValueType  = 'String'
        Default    = 'Administrator'
    }
    RenameGuestAccount = @{
        Class      = 'RenameAccountGuest'
        ValueType  = 'String'
        Default    = 'Guest'
    }
    AuditBaseObjects = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    FullPrivilegeAuditing = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    SCENoApplyLegacyAuditPolicy = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    CrashOnAuditFail = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    MachineAccessRestriction = @{
        Key        = 'HKLM:\Software\policies\Microsoft\windows NT\DCOM'
        ValueType  = 'String'
        Default    = 'Not Defined'
    }
    MachineLaunchRestriction = @{
        Key        = 'HKLM:\Software\policies\Microsoft\windows NT\DCOM'
        ValueType  = 'String'
        Default    = 'Not Defined'
    }
    UndockWithoutLogon = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    AllocateDASD = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'AllocateDASD'
        Default    = 'Administrators'
    }
    AddPrinterDrivers = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers'
        ValueType  = 'Enabled'
        # Default for server operating systems
        Default    = 'Enabled'
    }
    AllocateCDRoms = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    AllocateFloppies = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    SubmitControl = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    LDAPServerIntegrity = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\NTDS\Parameters'
        ValueType  = 'LDAPServerIntegrity'
        Default    = 'Not Defined'
    }
    RefusePasswordChange = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    RequireSignOrSeal = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    SealSecureChannel = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    SignSecureChannel = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    DisablePasswordChange = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    MaximumPasswordAge = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Int32'
        Default    = 30
    }
    RequireStrongKey = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    DontDisplayLockedUserId = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'DontDisplayLockedUserId'
        Default    = 'Not Defined'
    }
    DisableCAD = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    DontDisplayLastUserName = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    DontDisplayUserName = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    InactivityTimeoutSecs = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Int32'
        Default    = 'Not Defined'
    }
    LegalNoticeText = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'String'
        Default    = ''
    }
    LegalNoticeCaption = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'String'
        Default    = ''
    }
    CachedLogonsCount = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'Int32'
        Default    = 10
    }
    PasswordExpiryWarning = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'Int32'
        Default    = 5
    }
    ForceUnlockLogon = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    ScRemoveOption = @{
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
        ValueType  = 'ScRemoveOption'
        Default    = 'NoAction'
    }
    RequireSecuritySignature = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    EnableSecuritySignature = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    EnablePlainTextPassword = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    AutoDisconnect = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters'
        ValueType  = 'Int32'
        Default    = 'Not Defined'
    }
    ServerRequireSecuritySignature = @{
        Name    = 'RequireSecuritySignature'
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'Enabled'
        # Enabled for Domain Controllers
        Default    = 'Disabled'
    }
    ServerEnableSecuritySignature = @{
        Name    = 'EnableSecuritySignature'
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'Enabled'
        # Enabled for Domain Controllers
        Default    = 'Disabled'
    }
    EnableForcedLogOff = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    SmbServerNameHardeningLevel = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'SmbServerNameHardeningLevel'
        Default    = 'Not Defined'
    }
    TurnOffAnonymousBlock = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    RestrictAnonymousSAM = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    RestrictAnonymous = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    DisableDomainCreds = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    EveryoneIncludesAnonymous = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    NullSessionPipes = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'String[]'
        Default    = ''
    }
    RemoteRegistryPaths = @{
        Name       = 'Machine'
        Key        = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths'
        ValueType  = 'String[]'
        Default    = @(
            'System\CurrentControlSet\Control\ProductOptions'
            'System\CurrentControlSet\Control\Server Applications'
            'Software\Microsoft\Windows NT\CurrentVersion'
        )
    }
    RemoteRegistryPathsAndSubPaths = @{
        Name       = 'Machine'
        Key        = 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths'
        ValueType  = 'String[]'
        Default    = @(
            'System\CurrentControlSet\Control\Print\Printers'
            'System\CurrentControlSet\Services\Eventlog'
            'Software\Microsoft\OLAP Server'
            'Software\Microsoft\Windows NT\CurrentVersion\Print'
            'Software\Microsoft\Windows NT\CurrentVersion\Windows'
            'System\CurrentControlSet\Control\ContentIndex'
            'System\CurrentControlSet\Control\Terminal Server'
            'System\CurrentControlSet\Control\Terminal Server\UserConfig'
            'System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration'
            'Software\Microsoft\Windows NT\CurrentVersion\Perflib'
            'System\CurrentControlSet\Services\SysmonLog'
        )
    }
    RestrictNullSessAccess = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    RestrictRemoteSam = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'String'
        Default    = 'Not Defined'
    }
    NullSessionShares = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters'
        ValueType  = 'String[]'
        Default    = @()
    }
    ForceGuest = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'ForceGuest'
        Default    = 'Classic'
    }
    UseMachineId = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    AllowNullSessionFallback = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    AllowOnlineID = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\pku2u'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    SupportedEncryptionTypes = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters'
        ValueType  = 'SupportedEncryptionTypes'
        Default    = 'Not Defined'
    }
    NoLMHash = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    LmCompatibilityLevel = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'LmCompatibilityLevel'
        Default    = 'Not Defined'
    }
    LDAPClientIntegrity = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\LDAP'
        ValueType  = 'LDAPClientIntegrity'
        Default    = 'NegotiateSigning'
    }
    NTLMMinClientSec = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'NTLMMinSec'
        Default    = 'Require128BitEncryption'
    }
    NTLMMinServerSec = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'NTLMMinSec'
        Default    = 'Require128BitEncryption'
    }
    ClientAllowedNTLMServers = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'String[]'
        Default    = 'Not Defined'
    }
    DCAllowedNTLMServers = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'String[]'
        Default    = 'Not Defined'
    }
    AuditReceivingNTLMTraffic = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'AuditReceivingNTLMTraffic'
        Default    = 'Not Defined'
    }
    AuditNTLMInDomain = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'AuditNTLMInDomain'
        Default    = 'Not Defined'
    }
    RestrictReceivingNTLMTraffic = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'RestrictReceivingNTLMTraffic'
        Default    = 'Not Defined'
    }
    RestrictNTLMInDomain = @{
        Key        = 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters'
        ValueType  = 'RestrictNTLMInDomain'
        Default    = 'Disable'
    }
    RestrictSendingNTLMTraffic = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0'
        ValueType  = 'RestrictSendingNTLMTraffic'
        Default    = 'Not Defined'
    }
    RecoveryConsoleSecurityLevel = @{
        Name       = 'SecurityLevel'
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    RecoveryConsoleSetCommand = @{
        Name       = 'SetCommand'
        Key        = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole'
        ValueType  = 'Enabled'
        Default    = 'Not Defined'
    }
    ShutdownWithoutLogon = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    ClearPageFileAtShutdown = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Memory Management'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    ForceKeyProtection = @{
        Key        = 'HKLM:\Software\Policies\Microsoft\Cryptography'
        ValueType  = 'ForceKeyProtection'
        Default    = 'Not Defined'
    }
    FIPSAlgorithmPolicy = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Lsa'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    ObCaseInsensitive = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    ProtectionMode = @{
        Key        = 'HKLM:\System\CurrentControlSet\Control\Session Manager'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    OptionalSubsystems = @{
        Name       = 'Optional'
        Key        = 'HKLM:\System\CurrentControlSet\Control\Session Manager\Subsystems'
        ValueType  = 'String[]'
        Default    = @()
    }
    AuthenticodeEnabled = @{
        Key        = 'HKLM:\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    FilterAdministratorToken = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    EnableUIADesktopToggle = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    ConsentPromptBehaviorAdmin = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'ConsentPromptBehaviorAdmin'
        Default    = 'PromptForConsentForNonWindowsBinaries'
    }
    ConsentPromptBehaviorUser = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'ConsentPromptBehaviorUser'
        Default    = 'PromptForCredentials'
    }
    EnableInstallerDetection = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
    ValidateAdminCodeSignatures = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Disabled'
    }
    EnableSecureUIAPaths = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
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
    EnableVirtualization = @{
        Key        = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'
        ValueType  = 'Enabled'
        Default    = 'Enabled'
    }
}