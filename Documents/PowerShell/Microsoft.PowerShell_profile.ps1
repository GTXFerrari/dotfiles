# Set Vi mode when PSReadLine is available in an interactive session.
if (Get-Module -Name PSReadLine) {
    Set-PSReadLineOption -EditMode Vi
}

if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
}

# Shared editor and tool shortcuts from Zsh.
$env:EDITOR = 'nvim'
Set-Alias -Name e -Value nvim -Force
Set-Alias -Name v -Value nvim -Force
Set-Alias -Name vi -Value nvim -Force
Set-Alias -Name vim -Value nvim -Force
Set-Alias -Name nano -Value nvim -Force
Set-Alias -Name lg -Value lazygit -Force
Set-Alias -Name ff -Value fastfetch -Force
Set-Alias -Name ytdl -Value yt-dlp -Force
Set-Alias -Name hbcli -Value HandBrakeCLI -Force
Set-Alias -Name tf -Value terraform -Force

function vimdiff { nvim -d @args }

# Listing shortcuts include hidden files. Named parameters remain available.
function Get-AllChildItems {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(Position = 0, ValueFromPipeline, ParameterSetName = 'Path')]
        [string[]] $Path,
        [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
        [Alias('PSPath', 'LP')]
        [string[]] $LiteralPath,
        [string] $Filter,
        [switch] $Recurse,
        [switch] $Directory,
        [switch] $File,
        [switch] $Name
    )
    process { Get-ChildItem @PSBoundParameters -Force }
}
Set-Alias -Name ll -Value Get-AllChildItems -Force
Set-Alias -Name la -Value Get-AllChildItems -Force

# Keep native PowerShell parameter handling for file commands. Set-Alias
# accepts a command name, not a command followed by argument text.
Set-Alias -Name rm -Value Remove-Item -Force
Set-Alias -Name touch -Value New-Item -Force

# Git commands with arguments need functions, not Set-Alias.
function gb { git branch @args }
function gco { git checkout @args }
function ga { git add . @args }
function gcom { git commit -m @args }
function gd { git diff @args }
function gs { git status @args }
# Zsh's gc is gco here so PowerShell's Get-Content alias remains available.

# Chezmoi: ccd changes this shell's directory rather than opening a subshell.
function cs { chezmoi status @args }
function ccd {
    $sourceDirectory = & chezmoi source-path
    if ($LASTEXITCODE -eq 0 -and $sourceDirectory) {
        Set-Location -LiteralPath $sourceDirectory
    }
}
function cm { chezmoi merge @args }

function dcu { docker compose up -d @args }
function dcd { docker compose down @args }

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell | Out-String)
}

# Starship (keep at bottom). The profile directory follows Documents redirection.
$env:STARSHIP_CONFIG = Join-Path $PSScriptRoot 'Starship/starship.toml'
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell | Out-String)
}
