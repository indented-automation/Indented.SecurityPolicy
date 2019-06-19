---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Get-AssignedUserRight

## SYNOPSIS
Gets all user rights granted to a principal.

## SYNTAX

```
Get-AssignedUserRight [[-AccountName] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get a list of all the user rights granted to one or more principals.
Does not expand group membership.

## EXAMPLES

### EXAMPLE 1
```
Get-AssignedUserRight
```

Returns a list of all defined for the current user.

### EXAMPLE 2
```
Get-AssignedUserRight Administrator
```

Get the list of rights assigned to the administrator account.

## PARAMETERS

### -AccountName
Find rights for the specified account names.
By default AccountName is the current user.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $env:USERNAME
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Indented.SecurityPolicy.AssignedUserRight
## NOTES

## RELATED LINKS
