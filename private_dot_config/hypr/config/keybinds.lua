--[[
██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
█████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
                                                              
--]]

-- Variables
local meta = "SUPER"
local terminal = "kitty"
local tui_fileManager = "kitty --class lf-kitty -e lf"
local gui_fileManager = "dolphin"
local browser = "zen-browser"
local ipc = "qs -c noctalia-shell ipc call"
local hdr = require("scripts.hdr")

-- 1. System Keybinds
hl.bind(meta .. "+ SHIFT + C", hl.dsp.window.close(), { description = "Close a window" })
hl.bind(meta .. "+ SHIFT + Q", hl.dsp.exit(), { description = "Exit Hyprland" })
hl.bind(meta .. "+ SHIFT + L", hl.dsp.exec_cmd(ipc .. " lockScreen lock"), { description = "Lock the screen" })
hl.bind(meta .. "+ F", hl.dsp.window.float({ action = "toggle" }), { description = "Float a window" })

-- 2. Application Keybinds
hl.bind(meta .. "+ SHIFT + Return", hl.dsp.exec_cmd(terminal), { description = "Launch Kitty" })
hl.bind(meta .. "+ E", hl.dsp.exec_cmd(tui_fileManager), { description = "launch lf file manager (float)" })
hl.bind(meta .. "+ SHIFT + E", hl.dsp.exec_cmd(gui_fileManager), { description = "Launch dolphin file manager" })
hl.bind(meta .. "+ SHIFT + Z", hl.dsp.exec_cmd(browser), { description = "Launch Zen-Browser" })
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("missioncenter"), { description = "Launch missioncenter" })

-- 3. Window Management
hl.bind(meta .. "+ left", hl.dsp.focus({ direction = "l" }), { description = "Change active window (Left)" })
hl.bind(meta .. "+ right", hl.dsp.focus({ direction = "r" }), { description = "Change active window (Right)" })
hl.bind(meta .. "+ up", hl.dsp.focus({ direction = "u" }), { description = "Change active window (Up)" })
hl.bind(meta .. "+ down", hl.dsp.focus({ direction = "d" }), { description = "Change active window (Down)" })

-- 4. Special Workspaces
hl.bind(meta .. "+ S", hl.dsp.workspace.toggle_special("kitty_scratch"), { description = "Toggle Kitty Scratchpad" })
hl.bind(meta .. "+ I", hl.dsp.workspace.toggle_special("codex"), { description = "Toggle Codex Workspace" })
hl.bind(meta .. "+ O", hl.dsp.workspace.toggle_special("obs"), { description = "Toggle OBS Workspace" })
hl.bind("ALT + F", hl.dsp.workspace.toggle_special("firefox"), { description = "Toggle Firefox Workspace" })
hl.bind(meta .. "+ SHIFT + I", hl.dsp.window.move({ workspace = "special:codex", follow = false }))

-- 5. Workspace Management
hl.bind(meta .. "+ 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(meta .. "+ 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(meta .. "+ 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(meta .. "+ 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(meta .. "+ 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(meta .. "+ 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(meta .. "+ 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(meta .. "+ 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(meta .. "+ 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(meta .. "+ 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(meta .. "+ SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(meta .. "+ SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(meta .. "+ SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(meta .. "+ SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(meta .. "+ SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(meta .. "+ SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(meta .. "+ SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(meta .. "+ SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(meta .. "+ SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind(meta .. "+ SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

-- Resize Windows
hl.bind(meta .. "+ l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(meta .. "+ h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })

-- Resize/move with mouse
hl.bind(meta .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(meta .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Scrollable Workspaces
hl.bind(meta .. "+ mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(meta .. "+ mouse_down", hl.dsp.focus({ workspace = "e+1" }))

-- Noctalia-Shell
hl.bind(meta .. "+ P", hl.dsp.exec_cmd(ipc .. " launcher toggle"))
hl.bind(meta .. "+ Comma", hl.dsp.exec_cmd(ipc .. " controlCenter toggle"))
hl.bind(meta .. "+ Period", hl.dsp.exec_cmd(ipc .. " settings toggle"))
hl.bind(meta .. "+ V", hl.dsp.exec_cmd(ipc .. " launcher clipboard"))
hl.bind(meta .. "+ B", hl.dsp.exec_cmd(ipc .. " bar toggle"))
hl.bind(meta .. "+ SPACE", hl.dsp.exec_cmd(ipc .. " wallpaper toggle"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(ipc .. " wallpaper toggle")) -- Needed for ipad (iPad os captures meta+Space)
-- Multimedia Keys (Noctalia-Shell)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume increase"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume decrease"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume muteOutput"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness increase"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness decrease"), { repeating = true })

-- Noctalia Plugins
-- hl.bind("ALT + TAB", hl.dsp.exec_cmd(ipc .. " plugin:workspace-overview toggle"))
hl.bind(meta .. "+F1", hl.dsp.exec_cmd(ipc .. " plugin:keybind-cheatsheet toggle"))

-- Screenshots
-- Full Screen
hl.bind(
	"Print",
	hl.dsp.exec_cmd(
		[[mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"]]
	)
)
-- Region picker & annotation with satty
hl.bind(
	"SHIFT + Print",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy --output-filename "$HOME/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"'
	)
)

-- OBS Keybinds
hl.bind(meta .. "+ F5", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" })) -- Toggle Recording with SUPER+F5

-- HDR Toggle (Win+ALT+B)
hl.bind(meta .. " + ALT + B", function()
	hdr.toggle()
end, {
	description = "Toggle HDR / SDR",
})
