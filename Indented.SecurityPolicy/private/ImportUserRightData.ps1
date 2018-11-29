using namespace Indented.SecurityPolicy

function ImportUserRightData {
    $localizedUserRights = Import-LocalizedData -FileName userRights

    $Script:userRightData = @{}
    $Script:userRightLookupHelper = @{}

    foreach ($key in $localizedUserRights.Keys) {
        $value = [PSCustomObject]@{
            Name        = [UserRight]$key
            Description = $localizedUserRights[$key]
            PSTypeName  = 'Indented.SecurityPolicy.UserRightInfo'
        }
        $Script:userRightData.Add($key, $value)
        $Script:userRightLookupHelper.Add($value.Description, $key)
    }
}