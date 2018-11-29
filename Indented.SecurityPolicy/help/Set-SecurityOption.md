---
external help file: Indented.SecurityPolicy-help.xml
Module Name: Indented.SecurityPolicy
online version:
schema: 2.0.0
---

# Set-SecurityOption

## SYNOPSIS
Set the value of a security option.

## SYNTAX

```
Set-SecurityOption [-Name] <String> [-Value] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Set the value of a security option.

## EXAMPLES

### EXAMPLE 1
```
Set-SecurityOption EnableLUA Enabled
```

Enables the "User Account Control: Run all administrators in Admin Approval Mode" policy.

### EXAMPLE 2
```
Set-SecurityOption LegalNoticeText ''
```

Sets the value of the LegalNoticeText policy to an empty string.

### EXAMPLE 3
```

```

## PARAMETERS

### -Name
The name of the security option to set.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Value
The value to set.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
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
