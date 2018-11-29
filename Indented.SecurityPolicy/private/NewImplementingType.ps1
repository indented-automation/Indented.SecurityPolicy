function NewImplementingType {
    param (
        [String]$Name
    )

    ($Name -as [Type])::new()
}