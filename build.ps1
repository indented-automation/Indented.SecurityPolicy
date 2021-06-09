param (
    [string[]]$TaskName = ('Clean', 'Build', 'BuildSolution')
)

function Clean {
    $path = Join-Path -Path $PSScriptRoot -ChildPath 'build'
    if (Test-Path $path) {
        Remove-Item $path -Recurse
    }
}

function Build {
    Build-Module -Path (Resolve-Path $PSScriptRoot\*\build.psd1)
}

function BuildSolution {
    $targetPath = Resolve-Path $PSScriptRoot\build\*\*

    Resolve-Path $PSScriptRoot\*\class | Push-Location

    try {
        if (Test-Path packages.config) {
            nuget restore
        }

        msbuild /t:Clean /t:Build /p:DebugSymbols=false /p:DebugType=None
        if ($lastexitcode -ne 0) {
            throw 'msbuild failed'
        }

        $path = Join-Path -Path $targetPath -ChildPath 'lib'
        if (-not (Test-Path $path)) {
            $null = New-Item $path -ItemType Directory -Force
        }

        Get-Item * -Exclude *.tests, packages | Where-Object PsIsContainer | ForEach-Object {
            Get-ChildItem $_.FullName -Filter *.dll -Recurse |
                Where-Object FullName -like '*bin*' |
                Copy-Item -Destination $path
        }
    } catch {
        throw
    } finally {
        Pop-Location
    }
}

function Test {
    Write-Host 'Here'

    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'build\*\*\*.psd1' |
        Get-Item |
        Where-Object { $_.BaseName -eq $_.Directory.Parent.Name }
    $rootModule = $modulePath -replace 'd1$', 'm1'

    Write-Host $modulePath
    Write-Host $rootModule

    $stubPath = Join-Path -Path $PSScriptRoot -ChildPath '*\tests\stub\*.psm1'
    if (Test-Path -Path $stubPath) {
        foreach ($module in $stubPath | Resolve-Path) {
            Import-Module -Name $module -Global
        }
    }

    Write-Host "importing module"

    Import-Module -Name $modulePath -Force -Global

    Write-Host "Here"

    $configuration = @{
        Run          = @{
            Path     = Join-Path -Path $PSScriptRoot -ChildPath '*\tests' | Resolve-Path
            PassThru = $true
        }
        CodeCoverage = @{
            Enabled    = $true
            Path       = $rootModule
            OutputPath = Join-Path -Path $PSScriptRoot -ChildPath 'build\codecoverage.xml'
        }
        TestResult   = @{
            Enabled    = $true
            OutputPath = Join-Path -Path $PSScriptRoot -ChildPath 'build\nunit.xml'
        }
        Output       = @{
            Verbosity = 'Detailed'
        }
    }

    Write-Host "Starting pester"
    $testResult = Invoke-Pester -Configuration $configuration

    if ($env:APPVEYOR_JOB_ID) {
        $path = Join-Path -Path $PSScriptRoot -ChildPath 'build\nunit.xml'

        if (Test-Path $path) {
            [System.Net.WebClient]::new().UploadFile(('https://ci.appveyor.com/api/testresults/nunit/{0}' -f $env:APPVEYOR_JOB_ID), $path)
        }
    }

    if ($testResult.FailedCount -gt 0) {
        throw 'One or more tests failed!'
    }
}

function Publish {
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'build\*\*\*.psd1' |
        Get-Item |
        Where-Object { $_.BaseName -eq $_.Directory.Parent.Name } |
        Select-Object -ExpandProperty Directory

    Publish-Module -Path $modulePath.FullName -NuGetApiKey $env:NuGetApiKey -Repository PSGallery -ErrorAction Stop
}

function WriteMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$Message,

        [ValidateSet('Information', 'Warning', 'Error')]
        [string]$Category = 'Information',

        [string]$Details
    )

    $colour = switch ($Category) {
        'Information' { 'Cyan' }
        'Warning' { 'Yellow' }
        'Error' { 'Red' }
    }
    Write-Host -Object $Message -ForegroundColor $colour

    if ($env:APPVEYOR_JOB_ID) {
        Add-AppveyorMessage @PSBoundParameters
    }
}

function InvokeTask {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$TaskName
    )

    begin {
        Write-Host ('Build {0}' -f $PSCommandPath) -ForegroundColor Green
    }

    process {
        $ErrorActionPreference = 'Stop'
        try {
            $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

            WriteMessage -Message ('Task {0}' -f $TaskName)
            & "Script:$TaskName"
            WriteMessage -Message ('Done {0} {1}' -f $TaskName, $stopWatch.Elapsed)
        } catch {
            WriteMessage -Message ('Failed {0} {1}' -f $TaskName, $stopWatch.Elapsed) -Category Error -Details $_.Exception.Message

            exit 1
        } finally {
            $stopWatch.Stop()
        }
    }
}

$TaskName | InvokeTask
