# Dotfiles (managed by chezmoi)

One repository for Linux, macOS, and native Windows. OS selection uses
`.chezmoi.os`: `linux`, `darwin`, or `windows`.

| Configuration | Linux | macOS | Windows |
| --- | --- | --- | --- |
| Git | `.gitconfig` | `.gitconfig` | `.gitconfig` |
| Bash and Zsh | Home directory | Home directory | Unmanaged |
| btop, Kitty, tmux | `.config` | `.config` | Unmanaged |
| mpv base settings | `.config/mpv` | `.config/mpv` | `AppData/Roaming/mpv` |
| lf | Linux variant in `.config/lf` | macOS variant in `.config/lf` | Windows variant in `AppData/Roaming/lf` |
| PowerShell profile | Unmanaged | Unmanaged | `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` |
| Linux desktop and services | Managed | Unmanaged | Unmanaged |

`.chezmoiignore` excludes Hyprland, systemd, UWSM, desktop portals, PipeWire,
GameMode, MPD, pacman, Chromium/Electron flags, and the Linux mpv screenshot
helpers on other operating systems. Repository documentation and the raw `os/`
variants are also excluded from deployment.

The Unix shell templates adapt GNU/BSD command flags and use `$HOME` instead of
a fixed Linux home path. Linux-only aliases are omitted on macOS. Optional Zsh
plugins, Starship, and zoxide are loaded only when available.

Linux retains its Noctalia theme integration. macOS uses btop's built-in theme,
Kitty's normal palette, and a simple tmux status line. Applications and fonts
must already be installed; this repository does not install them. Git LFS is
required when using Git LFS repositories with the shared Git configuration.

## Local identity

`chezmoi init` asks for the Git display name and email and stores them in the
machine's local chezmoi configuration. `dot_gitconfig.tmpl` reads those local
`gitName` and `gitEmail` values; neither value is stored in this repository.
Use `chezmoi edit-config` to change them later.

Home directories are resolved from the environment or chezmoi's template data.
Keep personal identities, private host addresses, and machine-specific account
paths in local configuration rather than adding them to the source files.

## Shared mpv settings

`.chezmoitemplates/mpv.conf.tmpl` supplies the Unix and Windows destination
wrappers. Linux keeps its Vulkan/OpenGL preference; macOS and Windows let mpv
choose an available graphics API.

The screenshot mosaic extension remains Linux-only because it depends on Unix
commands and Linux font paths. It is not deployed to macOS or Windows.

## Separate lf configurations

Edit the raw files for the appropriate OS:

```text
os/lf/
├── linux/      # Original Linux configuration and preview helpers
├── darwin/     # macOS configuration and preview helpers
└── windows/    # Native Windows configuration and preview helpers
```

These are real files in the repository, not links back to the import folder.
Keep them as ordinary files, not Go templates: lf shell blocks contain `{{`
syntax of their own. Thin destination templates use `include` to copy the
selected OS's bytes without interpreting the lf configuration.

`private_dot_config/lf/` contains the Linux/macOS destination wrappers;
`AppData/Roaming/lf/` contains the Windows wrappers. Each local `.chezmoiignore`
excludes optional files missing from the selected variant, leaving existing
local files unmanaged. For example, the macOS-only `video-preview` helper is
not installed on Linux, and Linux's `colors` file is not installed on macOS.

When adding a helper with a new filename, add a matching destination wrapper
and include that relative filename in its local `.chezmoiignore` list. Unix
program wrappers need the `executable_` prefix. Do not add `exact_` to these
directories: locally generated files and separately installed helpers should
remain untouched.

The Windows `lfrc` wrapper substitutes the current home directory for the
generic `@HOME@` placeholder. Its `sixel-preview` helpers are included;
timestamped backup files were excluded. Chafa 1.18.3 is downloaded from its
public release archive with a pinned SHA-256 checksum through
`.chezmoiexternal.toml.tmpl`, keeping its binary build metadata out of Git.
The imported compiled `lf-video.exe` uses
`D:\.cache\lf\sixel\mpv-sessions` and
`C:\Program Files\MPV Player\mpv.exe`. Both locations are available on the
source Windows machine; another Windows machine needs the same layout or a
rebuilt helper with different paths.

## Windows PowerShell

The PowerShell profile is managed at
`Documents/PowerShell/Microsoft.PowerShell_profile.ps1`, the standard PowerShell
7 `$PROFILE` location. The `Documents` source tree is Windows-only. A machine
with Documents redirected to OneDrive needs its destination adjusted to match
its actual `$PROFILE`.

Portable shortcuts from Zsh are included:

| Purpose | Shortcuts |
| --- | --- |
| Editors | `e`, `v`, `vi`, `vim`, `nano`, `vimdiff` |
| Listing (including hidden files) | `ll`, `la` |
| Git | `gb`, `gco`, `ga`, `gcom`, `gd`, `gs`, `lg` |
| Chezmoi | `cs`, `ccd`, `cm` |
| Docker Compose | `dcu`, `dcd` |
| Other tools | `ff`, `ytdl`, `hbcli`, `tf` |

`gco` is the equivalent of Zsh's `gc`; PowerShell's `gc` remains `Get-Content`.
Commands with fixed arguments use functions, so additional arguments and
quoted paths work. `rm` and `touch` resolve to the native `Remove-Item` and
`New-Item` cmdlets; the previous argument strings were not valid alias targets.
`ccd` changes the current shell to `chezmoi source-path`.

Terminal-Icons, Starship, and zoxide load only when available. Starship's
configuration remains in the profile directory's `Starship/starship.toml`.

## Preview changes

On each real machine:

```sh
chezmoi managed
chezmoi diff
chezmoi apply
```

To inspect another OS's file selection without applying it, for example from
Linux:

```sh
chezmoi --override-data '{"chezmoi":{"os":"darwin"}}' managed
chezmoi --override-data '{"chezmoi":{"os":"windows"}}' managed
```

Overriding template data checks selection and rendering; native application
behavior still needs checking on the corresponding OS. Never apply an OS
override to a real home directory.
