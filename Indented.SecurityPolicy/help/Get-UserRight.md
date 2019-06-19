---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Get-UserRight

## SYNOPSIS
Gets all accounts that are assigned a specified user right.

## SYNTAX

```
Get-UserRight [[-Name] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Gets a list of all accounts that hold a specified user right.

Group membership is not evaluated, the values returned are explicitly listed under the specified user rights.

## EXAMPLES

### EXAMPLE 1
```
Get-UserRight SeServiceLogonRight
```

Returns a list of all accounts that hold the "Log on as a service" right.

### EXAMPLE 2
```
Get-UserRight SeServiceLogonRight, SeDebugPrivilege
```

Returns accounts with the SeServiceLogonRight and SeDebugPrivilege rights.

## PARAMETERS

### -Name
The user right, or rights, to query.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: UserRight

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Indented.SecurityPolicy.UserRight
## NOTES

## RELATED LINKS
