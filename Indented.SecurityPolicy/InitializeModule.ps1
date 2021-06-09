ImportSecurityOptionData
ImportUserRightData

$manifest = Join-Path -Path $PSScriptRoot -ChildPath ('{0}.psd1' -f (Get-Item $PSCommandPath).BaseName)
$commands = (Import-PowerShellDataFile $manifest).FunctionsToExport
Register-ArgumentCompleter -CommandName ($commands -like '*UserRight') -ParameterName Name -ScriptBlock {
    param (
        [String]$CommandName,

        [String]$ParameterName,

        [String]$WordToComplete
    )

    [Indented.SecurityPolicy.UserRight].GetEnumValues().Where{
        $_ -like "$WordToComplete*"
    }
}

Register-ArgumentCompleter -CommandName ($commands -like '*SecurityOption') -ParameterName Name -ScriptBlock {
    param (
        [String]$CommandName,

        [String]$ParameterName,

        [String]$WordToComplete
    )

    (Resolve-SecurityOption | Where-Object Name -like "$WordToComplete*").Name
}
