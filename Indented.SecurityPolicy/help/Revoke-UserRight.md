---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Revoke-UserRight

## SYNOPSIS
Revokes rights granted to an account.

## SYNTAX

### List (Default)
```
Revoke-UserRight [-Name] <String[]> [-AccountName] <Object[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### All
```
Revoke-UserRight [-AccountName] <Object[]> [-AllRights] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Revokes the rights granted to an account or set of accounts.

The All switch may be used to revoke all rights granted to the specified accounts.

## EXAMPLES

### EXAMPLE 1
```
Revoke-UserRight -Name 'Log on as a service' -AccountName 'JonDoe'
```

Revokes the logon as a service right granted to the account named JonDoe.

### EXAMPLE 2
```
Revoke-UserRight -AccountName 'JonDoe' -All
```

Revokes all rights which have been granted to the identity JonDoe.

## PARAMETERS

### -Name
The user right, or rights, to query.

```yaml
Type: String[]
Parameter Sets: List
Aliases: UserRight

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
Grant rights to the specified principals.
The principal may be a string, an NTAccount object, or a SecurityIdentifier object.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllRights
Clear all rights granted to the specified accounts.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
