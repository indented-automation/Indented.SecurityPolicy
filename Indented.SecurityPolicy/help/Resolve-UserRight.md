---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Resolve-UserRight

## SYNOPSIS
Resolves the name of a user right as shown in the local security policy editor to its constant name.

## SYNTAX

```
Resolve-UserRight [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Resolves the name of a user right as shown in the local security policy editor to its constant name.

## EXAMPLES

### EXAMPLE 1
```
Resolve-UserRight "Generate security audits"
```

Returns the value SeAuditPrivilege.

### EXAMPLE 2
```
Resolve-UserRight "*batch*"
```

Returns SeBatchLogonRight and SeDenyBatchLogonRight via the description.

### EXAMPLE 3
```
Resolve-UserRight SeBatchLogonRight
```

Returns the name and description of the user right.

## PARAMETERS

### -Name
The name or description of a user right.
Wildcards are supported for description values.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
