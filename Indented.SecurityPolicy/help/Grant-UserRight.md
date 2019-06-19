---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Grant-UserRight

## SYNOPSIS
Grant rights to an account.

## SYNTAX

```
Grant-UserRight [-Name] <String[]> [-AccountName] <Object[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Grants one or more rights to the specified accounts.

## EXAMPLES

### EXAMPLE 1
```
Grant-UserRight -Name 'Allow logon locally' -AccountName 'Administrators'
```

Grants the allow logon locally right to the Administrators group.

## PARAMETERS

### -Name
The user right, or rights, to query.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: UserRight

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AccountName
Grant rights to the specified accounts.
Each account may be a string, an NTAccount object, or a SecurityIdentifier object.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
