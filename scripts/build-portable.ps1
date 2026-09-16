param(
    [Parameter(Mandatory = $true)]
    [string]$AutoHotkeyRoot,

    [Parameter(Mandatory = $true)]
    [string]$Ahk2ExePath
)

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$version = (Get-Content (Join-Path $projectRoot "VERSION") -Raw).Trim()
$distRoot = Join-Path $projectRoot "dist"
$portableName = "EVE-X-Preview-Reloaded-v$version-portable"
$portableRoot = Join-Path $distRoot $portableName
$outputExe = Join-Path $portableRoot "EVE-X-Preview-Reloaded.exe"
$outputZip = Join-Path $distRoot "$portableName.zip"
$baseExe = Join-Path $AutoHotkeyRoot "AutoHotkey64.exe"

if (-not (Test-Path $baseExe -PathType Leaf)) {
    throw "AutoHotkey64.exe was not found at $baseExe"
}
if (-not (Test-Path $Ahk2ExePath -PathType Leaf)) {
    throw "Ahk2Exe.exe was not found at $Ahk2ExePath"
}

if (Test-Path $distRoot) {
    Remove-Item $distRoot -Recurse -Force
}
New-Item $portableRoot -ItemType Directory -Force | Out-Null

$mainScript = Join-Path $projectRoot "Main.ahk"
$iconPath = Join-Path $projectRoot "Icon.ico"
$compilerArguments = @(
    "/in", "`"$mainScript`"",
    "/out", "`"$outputExe`"",
    "/base", "`"$baseExe`"",
    "/icon", "`"$iconPath`"",
    "/silent", "verbose"
)
$compilerProcess = Start-Process `
    -FilePath $Ahk2ExePath `
    -ArgumentList $compilerArguments `
    -Wait `
    -PassThru `
    -NoNewWindow

if ($compilerProcess.ExitCode -ne 0 -or -not (Test-Path $outputExe -PathType Leaf)) {
    throw "Ahk2Exe compilation failed with exit code $($compilerProcess.ExitCode)"
}

Copy-Item (Join-Path $projectRoot "locales") $portableRoot -Recurse
Copy-Item (Join-Path $projectRoot "LICENSE") $portableRoot
Copy-Item (Join-Path $projectRoot "README.MD") $portableRoot
Copy-Item (Join-Path $projectRoot "PORTABLE.md") $portableRoot

Compress-Archive -Path $portableRoot -DestinationPath $outputZip -CompressionLevel Optimal
if (-not (Test-Path $outputZip -PathType Leaf)) {
    throw "Portable ZIP was not created"
}

Write-Output $outputZip
