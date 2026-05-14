--[[
██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
█████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝
                                                              
--]]

local meta = "SUPER"
local terminal = "kitty"
local tui_fileManager = "kitty --class lf-kitty -e lf"
local gui_fileManager = "dolphin"
local menu = "fuzzel"
local browser = "zen-browser"

-- Launch Kitty
hl.bind(meta .. " + SHIFT + Return", hl.dsp.exec_cmd(terminal))
-- Close Windows
hl.bind(meta .. " + SHIFT + C", hl.dsp.window.close())
-- Exit Hyprland
hl.bind(meta .. " + SHIFT + Q", hl.dsp.exit())
-- Launch lf
hl.bind(meta .. " + E", hl.dsp.exec_cmd(tui_fileManager))
-- Launch Dolphin
hl.bind(meta .. " + SHIFT + E", hl.dsp.exec_cmd(gui_fileManager))
-- Launch Fuzzel (or defined menu var)
hl.bind(meta .. " + P", hl.dsp.exec_cmd(menu))
-- Launch Zen-Browser (or defined browser var)
hl.bind(meta .. " + SHIFT + Z", hl.dsp.exec_cmd(browser))
-- Launch MissionCenter
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("missioncenter"))
-- Lock Screen using hyprlock
hl.bind(meta .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
-- Toggle Float
hl.bind(meta .. " + F", hl.dsp.window.float({ action = "toggle" }))
-- Open Clipboard Hist in Fuzzel
hl.bind(meta .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

-- Move focus with meta + arrow keys
hl.bind(meta .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(meta .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(meta .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(meta .. " + down", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces
hl.bind(meta .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(meta .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(meta .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(meta .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(meta .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(meta .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(meta .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(meta .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(meta .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(meta .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to workspace (silent)
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
hl.bind(meta .. " + l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
hl.bind(meta .. " + h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))

-- Resize/move with mouse
hl.bind(meta .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(meta .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Scrollable Workspaces
hl.bind(meta .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(meta .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

-- Multimedia Keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))

-- Waybar
hl.bind(meta .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(meta .. " + SHIFT + R", hl.dsp.exec_cmd("killall waybar && waybar"))

-- Kitty scratchpad
hl.bind(
	meta .. " + S",
	hl.dsp.workspace.toggle_special("kitty_scratch", {
		description = "Toggle Kitty Term",
	})
)
-- Theme Switcher
local theme = require("config.theme")
hl.bind(meta .. " + F10", function()
	theme.next()
end)

--TODO: Kitty Scratchpad, OBS Key passthrough
