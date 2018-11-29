function ImportSecurityOptionData {
    $localizedSecurityOptions = Import-LocalizedData -FileName securityOptions

    $path = Join-Path $myinvocation.MyCommand.Module.ModuleBase 'data\securityOptions.psd1'
    $Script:securityOptionData = Import-PowerShellDataFile $path

    # Create the lookup helper
    $Script:securityOptionLookupHelper = @{}
    # Merge localized descriptions and fill the helper
    foreach ($key in [String[]]$Script:securityOptionData.Keys) {
        $value = $Script:securityOptionData[$key]

        $description = $localizedSecurityOptions[$key]
        $category, $shortDescription = $description -split ': *', 2

        $value.Add('Category', $category)
        $value.Add('Description', $description)
        $value.Add('ShortDescription', $shortDescription)
        $value.Add('PSTypeName', 'Indented.SecurityPolicy.SecurityOptionInfo')

        if (-not $value.Contains('Name')) {
            $value.Add('Name', $key)
        }

        $value = [PSCustomObject]$value

        $Script:securityOptionData[$key] = $value
        $Script:securityOptionLookupHelper.Add($description, $key)
    }
}