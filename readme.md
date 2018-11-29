# Indented.SecurityPolicy

## Commands

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

### GroupManagedServiceAccount

 - **Ensure** - _Optional_. Present by default.
 - **Name** - _Mandatory_. The SamAccountName of the account to install.

### RegistryPolicy

 - **Ensure** - _Optional_. Present by default.
 - **Name** - _Key_. The name of the policy, a registry value.
 - **Path** - _Key_. The path to the registry key.
 - **Data** - _Optional_. Should be defined if Ensure is present.
 - **ValueType** - _Optional_. String by default. Permissible values: String, DWord, QWord, MultiString, and Binary.

### SecurityOption

 - **Ensure** - _Optional_. Present by default.
 - **Name** - _Key_. The name or descriptive name of the policy. See Resolve-SecurityOption.
 - **Value** - _Optional_. Should be defined if Ensure is present. A value consistent with the value type for the option.

### UserRightAssignment

 - **Ensure** - _Optional_. Present by default.
 - **Name** - _Mandatory_. The name or descriptive name of a policy.
 - **AccountName** - An array of accounts to add or remove. To clear the right, set Ensure to absent, and leave this list empty.
 - **Replace** - By default principals are added to, or removed from, the list. Setting replace to true rewrites the list.
 - **Description** - _NotConfigurable_ Set by the resource to the descriptive name of the policy.
