param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath,

    [Parameter(Mandatory = $true)]
    [ValidateSet("ModernDark", "ModernLight")]
    [string]$Theme,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class WindowCaptureNative {
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);

    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBlt, uint flags);
}
"@

$exe = (Resolve-Path $ExePath).Path
$workingDirectory = Split-Path $exe -Parent
$settingsPath = Join-Path $workingDirectory "EVE-X-Preview.json"
if (Test-Path $settingsPath) {
    Remove-Item $settingsPath -Force
}

$process = Start-Process `
    -FilePath $exe `
    -ArgumentList @("--ui-preview", $Theme) `
    -WorkingDirectory $workingDirectory `
    -PassThru

try {
    $deadline = [DateTime]::UtcNow.AddSeconds(20)
    do {
        Start-Sleep -Milliseconds 250
        $process.Refresh()
    } while ($process.MainWindowHandle -eq [IntPtr]::Zero -and [DateTime]::UtcNow -lt $deadline)

    if ($process.MainWindowHandle -eq [IntPtr]::Zero) {
        throw "The $Theme settings window did not appear."
    }

    Start-Sleep -Milliseconds 750
    $rect = New-Object WindowCaptureNative+RECT
    if (-not [WindowCaptureNative]::GetWindowRect($process.MainWindowHandle, [ref]$rect)) {
        throw "Could not read the $Theme settings window bounds."
    }

    $width = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top
    if ($width -lt 1000 -or $height -lt 700) {
        throw "Unexpected $Theme settings window size: ${width}x${height}."
    }

    $outputDirectory = Split-Path $OutputPath -Parent
    New-Item $outputDirectory -ItemType Directory -Force | Out-Null
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $hdc = $graphics.GetHdc()
    try {
        if (-not [WindowCaptureNative]::PrintWindow($process.MainWindowHandle, $hdc, 2)) {
            throw "PrintWindow failed for $Theme."
        }
    }
    finally {
        $graphics.ReleaseHdc($hdc)
        $graphics.Dispose()
    }

    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()

    if ((Get-Item $OutputPath).Length -lt 10000) {
        throw "The $Theme screenshot is unexpectedly small."
    }
}
finally {
    if (-not $process.HasExited) {
        Stop-Process -Id $process.Id -Force
    }
    if (Test-Path $settingsPath) {
        Remove-Item $settingsPath -Force
    }
}
