---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Reset-SecurityOption

## SYNOPSIS
Reset the value of a security option to its default.

## SYNTAX

```
Reset-SecurityOption [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Reset the value of a security option to its default.

## EXAMPLES

### EXAMPLE 1
```
Reset-SecurityOption FIPSAlgorithmPolicy
```

Resets the FIPSAlgorithmPolicy policy to the default value, Disabled.

### EXAMPLE 2
```
Reset-SecurityOption 'Interactive logon: Message text for users attempting to log on'
```

Resets the LegalNoticeText policy to an empty string.

### EXAMPLE 3
```
Reset-SecurityOption ForceKeyProtection
```

Resets the ForceKeyProtection policy to "Not Defined" by removing the associated registry value.

## PARAMETERS

### -Name
The name of the security option to set.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
