function Reset-SecurityOption {
    <#
    .SYNOPSIS
        Reset the value of a security option to its default.
    .DESCRIPTION
        Reset the value of a security option to its default.
    .EXAMPLE
        Reset-SecurityOption FIPSAlgorithmPolicy

        Resets the FIPSAlgorithmPolicy policy to the default value, Disabled.
    .EXAMPLE
        Reset-SecurityOption 'Interactive logon: Message text for users attempting to log on'

        Resets the LegalNoticeText policy to an empty string.
    .EXAMPLE
        Reset-SecurityOption ForceKeyProtection

        Resets the ForceKeyProtection policy to "Not Defined" by removing the associated registry value.
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        # The name of the security option to set.
        [Parameter(Mandatory, Position = 1, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [String[]]$Name
    )

    process {
        foreach ($securityOptionInfo in $Name | Resolve-SecurityOption | Sort-Object Category, ShortDescription) {
            $value = $securityOptionInfo.Default

            if ($value -eq 'Not Defined' -and $securityOptionInfo.Key) {
                if (Test-Path $securityOptionInfo.Key) {
                    $key = Get-Item -Path $securityOptionInfo.Key
                    if ($key.GetValueNames() -contains $securityOptionInfo.Name) {
                        Remove-ItemProperty -Path $key.PSPath -Name $securityOptionInfo.Name
                    }
                }
            } else {
                Set-SecurityOption -Name $securityOptionInfo.Name -Value $value
            }
        }
    }
}