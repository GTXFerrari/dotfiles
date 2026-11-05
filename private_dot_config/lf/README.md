# lf live media previews

Video files, WebM, and GIF use mpv inside Kitty's right preview pane. Playback is
silent and loops a segment of up to 20 seconds centered in the file. Shorter
animations loop in full. The preview preserves the aspect ratio, centers the
image horizontally, and aligns it with the top of the pane.

The previewer starts `mpv-preview`, which owns one player per lf process. The
cleaner stops it when selection changes; `on-quit` stops it before lf exits.
The worker also watches the lf process lifetime. Resizing redraws at the new pane
size. Each frame uses a private shared-memory snapshot and a single Kitty image
ID, preserving lf's cursor and removing only the player's own image on exit.

Requirements: Kitty, mpv 0.41 or later with the Kitty video output, and Python 3
(standard library only). Live rendering is enabled for local Kitty sessions.
SSH and terminal multiplexers retain the previous preview behavior. Static
images, WebP, PDFs, and text retain the previous handlers. Normal video opening
continues to use your regular mpv configuration; previews have separate settings.

Files:

- `lfrc`: previewer/cleaner settings and exit hook.
- `previewer`: media detection and existing static previews.
- `cleaner`: stop live playback, then clear existing Kitty images.
- `mpv-preview`: process ownership and Kitty rendering.
- `preview-midpoint.lua`: initial seek and 20-second loop bounds.

Session state and player diagnostics:
`$XDG_RUNTIME_DIR/lf-mpv-preview/<lf-pid>-<process-starttime>/`

Validated on 2026-10-28: changing frames for MP4, WebM, and GIF; mute; midpoint
loop bounds; selecting text clears the player; terminal resizing; lf exit
cleanup; no new Kitty graphics errors. Tests used a separate window on
workspace 10 without switching the active workspace.
