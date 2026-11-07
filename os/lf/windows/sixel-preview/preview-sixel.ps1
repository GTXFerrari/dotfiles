param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [int]$PreviewWidth = 80,
    [int]$PreviewHeight = 25,
    [int]$PreviewX = 0,
    [int]$PreviewY = 0,
    [string]$PreviewMode = 'preview'
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
$PreviewWidth = [Math]::Max(1, $PreviewWidth)
$PreviewHeight = [Math]::Max(1, $PreviewHeight)

try {
    $extension = [IO.Path]::GetExtension($FilePath).ToLowerInvariant()
    if ($extension -in @('.mp4', '.mkv', '.webm', '.avi', '.mov', '.m4v', '.mpg', '.mpeg', '.wmv', '.flv', '.ts', '.mts', '.m2ts', '.vob', '.ogv', '.3gp')) {
        # Video previews are managed outside lf's static SIXEL preview stream.
        if ($PreviewMode -eq 'preload') { exit 1 }
        $ownerId = 0
        if (-not [int]::TryParse($env:id, [ref]$ownerId) -or $ownerId -le 0) {
            exit 1
        }
        $videoHelper = Join-Path $PSScriptRoot 'lf-video.exe'
        $videoInfo = New-Object Diagnostics.ProcessStartInfo
        $videoInfo.FileName = $videoHelper
        $videoInfo.UseShellExecute = $false
        $videoInfo.CreateNoWindow = $true
        $videoInfo.Arguments = 'start {0} "{1}" {2} {3} {4} {5}' -f $ownerId, $FilePath, $PreviewWidth, $PreviewHeight, $PreviewX, $PreviewY
        $controller = [Diagnostics.Process]::Start($videoInfo)
        try { $controller.WaitForExit() } finally { $controller.Dispose() }
        exit 1
    }
    if ($extension -in @('.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp', '.tif', '.tiff', '.ico', '.avif', '.svg')) {
        $chafa = Join-Path $PSScriptRoot 'tools\Chafa.exe'
        if (-not (Test-Path -LiteralPath $chafa)) {
            $chafa = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\chafa.exe'
        }
        if (-not (Test-Path -LiteralPath $chafa)) {
            $command = Get-Command chafa.exe -ErrorAction SilentlyContinue
            if ($command) {
                $chafa = $command.Source
            } else {
                # Existing terminal windows may not have Winget's updated PATH yet.
                $package = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\hpjansson.Chafa_Microsoft.Winget.Source_8wekyb3d8bbwe'
                $chafa = (Get-ChildItem -LiteralPath $package -Filter chafa.exe -Recurse | Select-Object -First 1).FullName
                if (-not $chafa) { throw 'Chafa is not installed.' }
            }
        }

        # Cache the encoded preview across lf sessions. Include the source metadata,
        # pane dimensions, renderer identity, and render options in the key.
        $cachePath = $null
        try {
            $source = Get-Item -LiteralPath $FilePath
            $renderer = Get-Item -LiteralPath $chafa
            $cacheDir = 'D:\.cache\lf\sixel'
            [void][IO.Directory]::CreateDirectory($cacheDir)
            $identity = @(
                'lf-sixel-v1:animate=off:polite=on:t=1:bg=black',
                $source.FullName.ToLowerInvariant(),
                $source.Length,
                $source.LastWriteTimeUtc.Ticks,
                $PreviewWidth,
                $PreviewHeight,
                $renderer.Length,
                $renderer.LastWriteTimeUtc.Ticks
            ) -join "`n"
            $hash = [Security.Cryptography.SHA256]::Create()
            try {
                $key = [BitConverter]::ToString($hash.ComputeHash([Text.Encoding]::UTF8.GetBytes($identity))).Replace('-', '').ToLowerInvariant()
            } finally {
                $hash.Dispose()
            }
            $cachePath = Join-Path $cacheDir ($key + '.sixel')
            if ([IO.File]::Exists($cachePath) -and (Get-Item -LiteralPath $cachePath).Length -gt 0) {
                $cached = [IO.File]::OpenRead($cachePath)
                try {
                    $cached.CopyTo([Console]::OpenStandardOutput())
                } finally {
                    $cached.Dispose()
                }
                exit 0
            }
        } catch {
            # Disk caching is optional; keep previews working if storage is unavailable.
            $cachePath = $null
        }

        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $chafa
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true
        $startInfo.RedirectStandardOutput = $true
        $startInfo.Arguments = '-f sixel -s {0}x{1} --animate off --polite on -t 1 --bg black -- "{2}"' -f $PreviewWidth, $PreviewHeight, $FilePath
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $rendered = New-Object IO.MemoryStream
        try {
            [void]$process.Start()
            # Preserve the raw SIXEL bytes instead of decoding them through a PowerShell pipeline.
            $process.StandardOutput.BaseStream.CopyTo($rendered)
            $process.WaitForExit()
            $renderExitCode = $process.ExitCode
            if ($renderExitCode -ne 0) { exit $renderExitCode }

            if ($cachePath -and $rendered.Length -gt 0) {
                $temporaryPath = $cachePath + '.' + [Guid]::NewGuid().ToString('N') + '.tmp'
                try {
                    $output = [IO.File]::Open($temporaryPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
                    try {
                        $rendered.Position = 0
                        $rendered.CopyTo($output)
                    } finally {
                        $output.Dispose()
                    }
                    # An atomic rename prevents another lf instance from reading a partial image.
                    if (-not [IO.File]::Exists($cachePath)) { [IO.File]::Move($temporaryPath, $cachePath) }
                } catch {
                    # Concurrent writers or a full disk must not prevent displaying the image.
                } finally {
                    try {
                        if ([IO.File]::Exists($temporaryPath)) { [IO.File]::Delete($temporaryPath) }
                    } catch { }
                }
            }
            $rendered.Position = 0
            $rendered.CopyTo([Console]::OpenStandardOutput())
            exit 0
        } finally {
            $rendered.Dispose()
            $process.Dispose()
        }
    }

    # Limit reads so large files and binary files remain cheap to select.
    $stream = [IO.File]::OpenRead($FilePath)
    try {
        $buffer = New-Object byte[] 65536
        $length = $stream.Read($buffer, 0, $buffer.Length)
    } finally {
        $stream.Dispose()
    }
    $unicodeBom = $length -ge 2 -and (($buffer[0] -eq 255 -and $buffer[1] -eq 254) -or ($buffer[0] -eq 254 -and $buffer[1] -eq 255))
    if (-not $unicodeBom -and [Array]::IndexOf($buffer, [byte]0, 0, $length) -ge 0) {
        $item = Get-Item -LiteralPath $FilePath
        [Console]::WriteLine('Binary file ({0:N0} bytes)' -f $item.Length)
        exit 0
    }
    $memory = New-Object IO.MemoryStream(,$buffer)
    $memory.SetLength($length)
    $reader = New-Object IO.StreamReader($memory, [Text.Encoding]::UTF8, $true)
    try {
        for ($lineIndex = 0; $lineIndex -lt $PreviewHeight -and -not $reader.EndOfStream; $lineIndex++) {
            $line = $reader.ReadLine()
            # Do not pass file-supplied terminal control sequences through to lf.
            $line = $line -replace '[\x00-\x08\x0B-\x1F\x7F]', ''
            [Console]::WriteLine($line)
        }
    } finally {
        $reader.Dispose()
    }
    exit 0
} catch {
    [Console]::WriteLine('Preview unavailable: ' + $_.Exception.Message)
    exit 1
}
