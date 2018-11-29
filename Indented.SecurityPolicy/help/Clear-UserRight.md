---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Clear-UserRight

## SYNOPSIS
Clears the accounts from the specified user right.

## SYNTAX

```
Clear-UserRight [-Name] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Clears the accounts from the specified user right.

## EXAMPLES

### EXAMPLE 1
```
Clear-UserRight 'Log on as a batch job'
```

Clear the SeBatchLogonRight right.

## PARAMETERS

### -Name
The name of the user right to clear.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: UserRight

Required: True
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
