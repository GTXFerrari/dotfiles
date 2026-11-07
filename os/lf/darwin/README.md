# lf live media previews on macOS

Select a video, WebM, or GIF in lf inside a local Kitty window to play a silent
preview in the right pane. The player preserves aspect ratio, centers the
preview horizontally, and aligns it with the top of the pane. Videos loop a
20-second segment centered in the file; shorter clips loop in full.

This ports the live preview setup from the Linux variant. It requires Kitty,
mpv 0.41 or later with the Kitty video output, and Python 3.13 or later. All
dependencies were already installed. Reopen lf after changing its configuration.

`mpv-preview` owns one player per lf process. The cleaner stops it on selection
changes, and the `on-quit` hook stops it before lf restores the terminal. The
worker also checks the owning process's start time, so crashes and reused process
IDs cannot leave a player attached to a different lf session. Resizing starts a
player at the new pane size.

On macOS, process identity comes from libproc. The worker inherits a descriptor
for the concrete terminal device, and frames use POSIX shared-memory snapshots.
Python's resource tracker is disabled for these objects because Kitty consumes
and unlinks each snapshot. The worker cleans up any remaining snapshots on exit.
It also unlinks mpv's source buffer immediately after mapping it on macOS. Darwin
only allows a shared-memory object to be sized once, while mpv sizes its buffer
on every frame; leaving the old name in place skips every second frame. Playback
uses the source frame rate, with no FPS cap or frame interpolation.

Scaling uses one zimg thread. Automatic threading produced a narrow vertical
seam in the smoke WebM's RGB frames before they reached Kitty. Single-thread
scaling removes that seam; output checks still delivered 24.99 FPS for the
25 FPS WebM and 59.99 FPS for a 60 FPS test video at a 1760-pixel preview width.

Live previews use separate mpv options and do not load the regular mpv config.
Opening a video still uses the existing normal mpv command. Static image and
text handlers are preserved. SSH and terminal multiplexer sessions retain the
previous GIF/thumbnail fallback. Preloading never draws or starts a player.

Files:
- `lfrc`: previewer, cleaner, and exit hook.
- `previewer`: routes videos and GIFs to the live player.
- `cleaner`: stops the player before clearing existing graphics.
- `mpv-preview`: process ownership, terminal geometry, and Kitty rendering.
- `preview-midpoint.lua`: initial seek and loop bounds.
- `video-preview`: existing cached animation fallback.

Original Mac configuration: `backups/20261030-233033/`.

Diagnostics are in
`/tmp/lf-mpv-<uid>/lf-mpv-preview/<lf-pid>-<process-starttime>/player.log`.
If `XDG_RUNTIME_DIR` is set, it replaces `/tmp/lf-mpv-<uid>`.

Validated in a separate Kitty window: moving MP4/WebM/GIF previews, disabled
audio, midpoint loop bounds, resizing, static image/text transitions, preloading,
rapid navigation, normal quit, and cleanup after a forced lf exit. No new Kitty
graphics errors occurred in the final validation run.

Frame-rate regression check: a 23.976 FPS clip delivered 11.98 FPS before the
Darwin shared-memory fix and 23.93 FPS afterward. A 60 FPS test delivered about
30 FPS before the fix and 59.31 FPS through the complete Kitty preview afterward.
