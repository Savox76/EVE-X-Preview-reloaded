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

& $Ahk2ExePath `
    /in (Join-Path $projectRoot "Main.ahk") `
    /out $outputExe `
    /base $baseExe `
    /icon (Join-Path $projectRoot "Icon.ico") `
    /silent verbose

if ($LASTEXITCODE -ne 0 -or -not (Test-Path $outputExe -PathType Leaf)) {
    throw "Ahk2Exe compilation failed with exit code $LASTEXITCODE"
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
