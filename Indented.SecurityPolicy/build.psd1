@{
    ModuleManifest           = 'Indented.SecurityPolicy.psd1'
    OutputDirectory          = '../build'
    VersionedOutputDirectory = $true
    SourceDirectories        = @(
        'enum'
        'class'
        'private'
        'public'
    )
    Suffix                   = 'InitializeModule.ps1'
    CopyPaths                = @(
        'en'
        'data'
    )
}
