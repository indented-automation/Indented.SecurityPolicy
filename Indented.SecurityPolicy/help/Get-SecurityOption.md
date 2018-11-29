---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Get-SecurityOption

## SYNOPSIS
Get the value of a security option.

## SYNTAX

```
Get-SecurityOption [[-Name] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Get the value of a security option.

## EXAMPLES

### EXAMPLE 1
```
Get-SecurityOption 'Accounts: Administrator account status'
```

Gets the current value of the administrator account status policy (determined by the state of the account).

### EXAMPLE 2
```
Get-SecurityOption 'EnableLUA'
```

Get the value of the "User Account Control: Run all administrators in Admin Approval Mode" policy.

## PARAMETERS

### -Name
The name of the security option to set.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
