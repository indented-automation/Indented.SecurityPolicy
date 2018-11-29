function InitializeModule {
    ImportSecurityOptionData
    ImportUserRightData

    $manifest = Join-Path $myinvocation.MyCommand.Module.ModuleBase ('{0}.psd1' -f $myinvocation.MyCommand.Module.Name)
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
}