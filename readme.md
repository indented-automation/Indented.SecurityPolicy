[![Build status](https://ci.appveyor.com/api/projects/status/7xs9k5m69dahdb51?svg=true)](https://ci.appveyor.com/project/indented-automation/indented-securitypolicy)

# Indented.SecurityPolicy

This module provides commands and DSC resources for manipulating and maintaining User Rights Assignment, Security Options, and Group Managed Service Account installation.

## Installation

```powershell
Install-Module Indented.SecurityPolicy
```

## Commands

The commands below are exported by this module.

### User rights

- [Clear-UserRight](Indented.SecurityPolicy/help/Clear-UserRight.md)
- [Get-AssignedUserRight](Indented.SecurityPolicy/help/Get-AssignedUserRight.md)
- [Get-UserRight](Indented.SecurityPolicy/help/Get-UserRight.md)
- [Grant-UserRight](Indented.SecurityPolicy/help/Grant-UserRight.md)
- [Grant-UserRight](Indented.SecurityPolicy/help/Grant-UserRight.md)
- [Resolve-UserRight](Indented.SecurityPolicy/help/Resolve-UserRight.md)
- [Revoke-UserRight](Indented.SecurityPolicy/help/Revoke-UserRight.md)
- [Set-UserRight](Indented.SecurityPolicy/help/Set-UserRight.md)

### Security Option

- [Get-SecurityOption](Indented.SecurityPolicy/help/Get-SecurityOption.md)
- [Reset-SecurityOption](Indented.SecurityPolicy/help/Reset-SecurityOption.md)
- [Resolve-SecurityOption](Indented.SecurityPolicy/help/Resolve-SecurityOption.md)
- [Set-SecurityOption](Indented.SecurityPolicy/help/Set-SecurityOption.md)

### Service accounts

- [Install-GroupManagedServiceAccount](Indented.SecurityPolicy/help/Install-GroupManagedServiceAccount.md)
- [Test-GroupManagedServiceAccount](Indented.SecurityPolicy/help/Test-GroupManagedServiceAccount.md)
- [Uninstall-GroupManagedServiceAccount](Indented.SecurityPolicy/help/Uninstall-GroupManagedServiceAccount.md)

## DSC resources

The following DSC resources are made available.

### GroupManagedServiceAccount

- **Ensure** - _Optional_. Present by default.
- **Name** - _Mandatory_. The SamAccountName of the account to install.

Example usage:

```powershell
GroupManagedServiceAccount AccountName {
    Ensure = 'Present'
    Name   = 'Username$'
}
```

### RegistryPolicy

- **Ensure** - _Optional_. Present by default.
- **Name** - _Key_. The name of the policy, a registry value.
- **Path** - _Key_. The path to the registry key.
- **Data** - _Optional_. Should be defined if Ensure is present.
- **ValueType** - _Optional_. String by default. Permissible values: String, DWord, QWord, MultiString, and Binary.

A helper resource used to configure arbitrary policies.

```powershell
RegistryPolicy LocalAccountTokenFilterPolicy {
    Ensure    = 'Present'
    Name      = 'LocalAccountTokenFilterPolicy'
    Path      = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Data      = 0
    ValueType = 'DWord'
}
```

### SecurityOption

- **Ensure** - _Optional_. Present by default.
- **Name** - _Key_. The name or descriptive name of the policy. See Resolve-SecurityOption.
- **Value** - _Optional_. Should be defined if Ensure is present. A value consistent with the value type for the option.

Policies may be referenced either using the short name, see Resolve-SecurityOption, or the long policy name.

Example usage:

```powershell
SecurityOption EnableLUA {
    Ensure = 'Present'
    Name   = 'EnableLUA'
    Value  = 'Enabled'
}

SecurityOption ShutdownWithoutLogon {
    Ensure = 'Present'
    Name   = 'Shutdown: Allow system to be shut down without having to log on'
    Value  = 'Enabled'
}
```

### UserRightAssignment

- **Ensure** - _Optional_. Present by default.
- **Name** - _Mandatory_. The name or descriptive name of a policy.
- **AccountName** - An array of accounts to add or remove. To clear the right, set Ensure to absent, and leave this list empty.
- **Replace** - By default principals are added to, or removed from, the list. Setting replace to true rewrites the list.
- **Description** - _NotConfigurable_ Set by the resource to the descriptive name of the policy.

Rights may be referenced either using the short name, see Resolve-UserRight, or the long right name.

Example usage:

```powershell
UserRightAssignment SeMachineAccountPrivilege {
    Ensure      = 'Present'
    Name        = 'Add workstations to domain'
    AccountName = 'Account1', 'Account2'
}
```
