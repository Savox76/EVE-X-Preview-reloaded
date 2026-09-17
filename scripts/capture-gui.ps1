param(
    [Parameter(Mandatory = $true)]
    [string]$ApplicationPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
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

    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern IntPtr FindWindow(string className, string windowName);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool GetWindowRect(IntPtr windowHandle, out RECT rectangle);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool PrintWindow(IntPtr windowHandle, IntPtr deviceContext, uint flags);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr windowHandle);
}
"@

function Wait-ForProcessWindow {
    param([System.Diagnostics.Process]$Process, [int]$TimeoutSeconds = 20)

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        $Process.Refresh()
        if ($Process.HasExited) {
            throw "Application exited before showing its GUI (exit code $($Process.ExitCode))."
        }
        if ($Process.MainWindowHandle -ne [IntPtr]::Zero) {
            Write-Host "Found GUI window: $($Process.MainWindowTitle)"
            return $Process.MainWindowHandle
        }
        Start-Sleep -Milliseconds 250
    } while ((Get-Date) -lt $deadline)

    $visibleWindows = Get-Process | Where-Object { $_.MainWindowTitle } | ForEach-Object { $_.MainWindowTitle }
    throw "The application GUI did not appear. Visible windows: $($visibleWindows -join '; ')"
}

function Save-WindowImage {
    param([IntPtr]$WindowHandle, [string]$Path)

    $rectangle = New-Object WindowCaptureNative+RECT
    if (-not [WindowCaptureNative]::GetWindowRect($WindowHandle, [ref]$rectangle)) {
        throw "Could not read the window dimensions."
    }

    $width = $rectangle.Right - $rectangle.Left
    $height = $rectangle.Bottom - $rectangle.Top
    if ($width -lt 100 -or $height -lt 100) {
        throw "The captured window dimensions are invalid: ${width}x${height}."
    }

    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $deviceContext = $graphics.GetHdc()
    try {
        if (-not [WindowCaptureNative]::PrintWindow($WindowHandle, $deviceContext, 2)) {
            throw "PrintWindow failed."
        }
    }
    finally {
        $graphics.ReleaseHdc($deviceContext)
        $graphics.Dispose()
    }

    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
}

function Invoke-Button {
    param([IntPtr]$WindowHandle, [string[]]$Names)

    $window = [System.Windows.Automation.AutomationElement]::FromHandle($WindowHandle)
    foreach ($name in $Names) {
        $condition = New-Object System.Windows.Automation.PropertyCondition(
            [System.Windows.Automation.AutomationElement]::NameProperty,
            $name
        )
        $button = $window.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $condition)
        if ($null -ne $button) {
            $pattern = $button.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
            $pattern.Invoke()
            return
        }
    }
    throw "None of the buttons '$($Names -join ', ')' was found."
}

$application = (Resolve-Path $ApplicationPath).Path
$applicationDirectory = Split-Path $application -Parent
New-Item $OutputDirectory -ItemType Directory -Force | Out-Null

# Generate a compatible settings file, add an editable demonstration profile,
# and restart so Profile Settings can be photographed without a dialog.
$bootstrap = Start-Process $application -WorkingDirectory $applicationDirectory -PassThru
Start-Sleep -Seconds 2
if (-not $bootstrap.HasExited) {
    Stop-Process -Id $bootstrap.Id -Force
    $bootstrap.WaitForExit()
}

$settingsPath = Join-Path $applicationDirectory "EVE-X-Preview.json"
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
$demoProfile = $settings._Profiles.Default | ConvertTo-Json -Depth 100 | ConvertFrom-Json
$settings._Profiles | Add-Member -NotePropertyName "Demo" -NotePropertyValue $demoProfile -Force
$settings.global_Settings.LastUsedProfile = "Demo"
$settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding utf8

$process = Start-Process $application -WorkingDirectory $applicationDirectory -ArgumentList "--capture-gui" -PassThru
try {
    $windowHandle = Wait-ForProcessWindow -Process $process
    [WindowCaptureNative]::SetForegroundWindow($windowHandle) | Out-Null
    Start-Sleep -Milliseconds 750

    Save-WindowImage -WindowHandle $windowHandle -Path (Join-Path $OutputDirectory "global-settings.png")

    Invoke-Button -WindowHandle $windowHandle -Names @("Profileinstellungen", "Profile Settings")
    Start-Sleep -Milliseconds 750
    Save-WindowImage -WindowHandle $windowHandle -Path (Join-Path $OutputDirectory "profile-settings.png")
}
finally {
    if (-not $process.HasExited) {
        Stop-Process -Id $process.Id -Force
        $process.WaitForExit()
    }
}

$images = Get-ChildItem $OutputDirectory -Filter *.png
if ($images.Count -lt 2) {
    throw "Expected at least two GUI screenshots."
}

foreach ($image in $images) {
    if ($image.Length -lt 10000) {
        throw "Screenshot '$($image.Name)' is unexpectedly small."
    }
    Write-Output "$($image.Name): $($image.Length) bytes"
}
