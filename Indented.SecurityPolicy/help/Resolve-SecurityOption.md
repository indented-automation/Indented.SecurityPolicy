---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Resolve-SecurityOption

## SYNOPSIS
Resolves the name of a security option as shown in the local security policy editor.

## SYNTAX

### ByName
```
Resolve-SecurityOption [[-Name] <String>] [<CommonParameters>]
```

### ByCategory
```
Resolve-SecurityOption -Category <String> [<CommonParameters>]
```

## DESCRIPTION
Resolves the name of a security option as shown in the local security policy editor to either the registry value name, or the name of an implementing class.

## EXAMPLES

### EXAMPLE 1
```
Resolve-SecurityOption "User Account Control: Run all administrators in Admin Approval Mode"
```

Returns information about the security option.

## PARAMETERS

### -Name
The name or description of a user right.
Wildcards are supported for description values.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Category
Get the policies under a specific category, for example "Network security".

```yaml
Type: String
Parameter Sets: ByCategory
Aliases:

Required: True
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
