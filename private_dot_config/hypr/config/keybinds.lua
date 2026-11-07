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
local terminal = "uwsm app -- kitty"
local tui_fileManager = "uwsm app -- kitty --class lf-kitty -e lf"
local gui_fileManager = "uwsm app -- nautilus"
local ipc = "noctalia msg"
local hdr = require("scripts.hdr")
local layout_bind = require("scripts.layout_bind")

-- 1. System Keybinds
hl.bind(meta .. "+ SHIFT + C", hl.dsp.window.close(), { description = "Close a window" })
hl.bind(meta .. "+ SHIFT + Q", function()
	-- A forwarded client quit shortcut must not log out the streaming host.
	local runtime = os.getenv("XDG_RUNTIME_DIR")
	local instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
	local stream_state = runtime and instance
		and io.open(runtime .. "/sunshine-vmon-" .. instance .. "/state.json", "r")
	if stream_state then
		stream_state:close()
		hl.exec_cmd("notify-send 'Streaming session active' 'Use Moonlight to disconnect or quit the streaming application.'")
		return
	end
	hl.exec_cmd("uwsm stop")
end, { description = "Log out (blocked during Sunshine sessions)" })
hl.bind(meta .. "+ SHIFT + L", hl.dsp.exec_cmd(ipc .. " lockScreen lock"), { description = "Lock the screen" })
hl.bind(meta .. "+ F", hl.dsp.window.float({ action = "toggle" }), { description = "Float a window" })
hl.bind(
	meta .. "+ CTRL + K",
	hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/wvkbd.sh toggle"),
	{ description = "Toggle on-screen keyboard" }
)

-- 2. Application Keybinds
hl.bind(meta .. "+ SHIFT + Return", hl.dsp.exec_cmd(terminal), { description = "Launch Kitty" })
hl.bind(meta .. "+ E", hl.dsp.exec_cmd(tui_fileManager), { description = "launch lf file manager (float)" })
hl.bind(meta .. "+ SHIFT + E", hl.dsp.exec_cmd(gui_fileManager), { description = "Launch dolphin file manager" })
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("uwsm app -- missioncenter"), { description = "Launch missioncenter" })

-- 3. Window Management
hl.bind(
	meta .. "+ left",
	layout_bind(hl.dsp.layout("focus l"), hl.dsp.focus({ direction = "l" })),
	{ description = "Change active window (Left)", repeating = true }
)
hl.bind(
	meta .. "+ right",
	layout_bind(hl.dsp.layout("focus r"), hl.dsp.focus({ direction = "r" })),
	{ description = "Change active window (Right)", repeating = true }
)
hl.bind(
	meta .. "+ up",
	layout_bind(hl.dsp.layout("focus u"), hl.dsp.focus({ direction = "u" })),
	{ description = "Change active window (Up)", repeating = true }
)
hl.bind(
	meta .. "+ down",
	layout_bind(hl.dsp.layout("focus d"), hl.dsp.focus({ direction = "d" })),
	{ description = "Change active window (Down)", repeating = true }
)

-- 4. Special Workspaces
hl.bind(meta .. "+ S", hl.dsp.workspace.toggle_special("kitty_scratch"), { description = "Toggle Kitty Scratchpad" })
hl.bind(meta .. "+ G", hl.dsp.workspace.toggle_special("game"), { description = "Toggle Gaming Workspace" })

-- Niri-style overview on all monitors.
if hl.plugin.scrolloverview then
	hl.bind(
		meta .. "+ O",
		hl.plugin.scrolloverview.overview("toggle all"),
		{ description = "Toggle workspace overview" }
	)
end

-- 5. Workspace Management
hl.bind(meta .. "+ 1", hl.dsp.focus({ workspace = 1 }), { description = "Focus workspace 1" })
hl.bind(meta .. "+ 2", hl.dsp.focus({ workspace = 2 }), { description = "Focus workspace 2" })
hl.bind(meta .. "+ 3", hl.dsp.focus({ workspace = 3 }), { description = "Focus workspace 3" })
hl.bind(meta .. "+ 4", hl.dsp.focus({ workspace = 4 }), { description = "Focus workspace 4" })
hl.bind(meta .. "+ 5", hl.dsp.focus({ workspace = 5 }), { description = "Focus workspace 5" })
hl.bind(meta .. "+ 6", hl.dsp.focus({ workspace = 6 }), { description = "Focus workspace 6" })
hl.bind(meta .. "+ 7", hl.dsp.focus({ workspace = 7 }), { description = "Focus workspace 7" })
hl.bind(meta .. "+ 8", hl.dsp.focus({ workspace = 8 }), { description = "Focus workspace 8" })
hl.bind(meta .. "+ 9", hl.dsp.focus({ workspace = 9 }), { description = "Focus workspace 9" })
hl.bind(meta .. "+ 0", hl.dsp.focus({ workspace = 10 }), { description = "Focus workspace 10" })
hl.bind(
	meta .. "+ SHIFT + 1",
	hl.dsp.window.move({ workspace = 1, follow = false }),
	{ description = "Send window to workspace 1" }
)
hl.bind(
	meta .. "+ SHIFT + 2",
	hl.dsp.window.move({ workspace = 2, follow = false }),
	{ description = "Send window to workspace 2" }
)
hl.bind(
	meta .. "+ SHIFT + 3",
	hl.dsp.window.move({ workspace = 3, follow = false }),
	{ description = "Send window to workspace 3" }
)
hl.bind(
	meta .. "+ SHIFT + 4",
	hl.dsp.window.move({ workspace = 4, follow = false }),
	{ description = "Send window to workspace 4" }
)
hl.bind(
	meta .. "+ SHIFT + 5",
	hl.dsp.window.move({ workspace = 5, follow = false }),
	{ description = "Send window to workspace 5" }
)
hl.bind(
	meta .. "+ SHIFT + 6",
	hl.dsp.window.move({ workspace = 6, follow = false }),
	{ description = "Send window to workspace 6" }
)
hl.bind(
	meta .. "+ SHIFT + 7",
	hl.dsp.window.move({ workspace = 7, follow = false }),
	{ description = "Send window to workspace 7" }
)
hl.bind(
	meta .. "+ SHIFT + 8",
	hl.dsp.window.move({ workspace = 8, follow = false }),
	{ description = "Send window to workspace 8" }
)
hl.bind(
	meta .. "+ SHIFT + 9",
	hl.dsp.window.move({ workspace = 9, follow = false }),
	{ description = "Send window to workspace 9" }
)
hl.bind(
	meta .. "+ SHIFT + 0",
	hl.dsp.window.move({ workspace = 10, follow = false }),
	{ description = "Send window to workspace 10" }
)

-- 6. Resizing and mouse controls
hl.bind(
	meta .. "+ l",
	layout_bind(hl.dsp.layout("colresize +0.05"), hl.dsp.window.resize({ x = 10, y = 0, relative = true })),
	{ description = "Widen window / scrolling column", repeating = true }
)
hl.bind(
	meta .. "+ h",
	layout_bind(hl.dsp.layout("colresize -0.05"), hl.dsp.window.resize({ x = -10, y = 0, relative = true })),
	{ description = "Narrow window / scrolling column", repeating = true }
)

-- Resize/move with mouse
hl.bind(meta .. "+ mouse:272", hl.dsp.window.drag(), { description = "Drag window", mouse = true })
hl.bind(meta .. "+ mouse:273", hl.dsp.window.resize(), { description = "Resize window with mouse", mouse = true })

-- Scrollable Workspaces
hl.bind(meta .. "+ mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(meta .. "+ mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })

-- 7. Noctalia Shell
hl.bind(meta .. "+ P", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"), { description = "Open application launcher" })
hl.bind(
	meta .. "+ Comma",
	hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"),
	{ description = "Toggle control center" }
)
hl.bind(meta .. "+ Period", hl.dsp.exec_cmd(ipc .. " settings-toggle"), { description = "Toggle Noctalia settings" })
hl.bind(meta .. "+ V", hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"), { description = "Toggle clipboard history" })
hl.bind(meta .. "+ B", hl.dsp.exec_cmd(ipc .. " bar-toggle"), { description = "Toggle Noctalia bar" })
hl.bind(
	meta .. "+ SPACE",
	hl.dsp.exec_cmd(ipc .. " panel-toggle wallpaper"),
	{ description = "Toggle wallpaper picker" }
)
hl.bind(
	"ALT + SPACE",
	hl.dsp.exec_cmd(ipc .. " panel-toggle wallpaper"),
	{ description = "Toggle wallpaper picker (iPad)" }
) -- Needed for ipad (iPad os captures meta+Space)
hl.bind(
	"CTRL + ALT + slash",
	hl.dsp.exec_cmd(
		ipc
			.. " plugin kenn/keybind-cheatsheet:data all refresh && "
			.. ipc
			.. " panel-toggle kenn/keybind-cheatsheet:cheatsheet"
	),
	{ description = "Toggle keybinding cheat sheet" }
)
hl.bind(
	meta .. "+ SHIFT + SPACE",
	hl.dsp.exec_cmd(ipc .. " panel-toggle noctalia/mpvpaper:picker"),
	{ description = "Toggle Video Wallpaper Chooser" }
)

-- 8. Media and brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"), { description = "Volume up", repeating = true })
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(ipc .. " volume-down "),
	{ description = "Volume down", repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"), { description = "Mute audio" })
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(ipc .. " brightness-up"),
	{ description = "Brightness up", repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(ipc .. " brightness-down"),
	{ description = "Brightness down", repeating = true }
)
hl.bind(meta .. "+ N", hl.dsp.exec_cmd(ipc .. " wallpaper-next"), { description = "Next wallpaper" })
-- Window Switcher (ALT+TAB)
hl.bind(
	"ALT + TAB",
	hl.dsp.exec_cmd(ipc .. " window-switcher"),
	{ description = "Open window switcher", repeating = true }
)

-- Noctalia Plugins

-- 9. Screenshots
-- Full Screen
hl.bind("Print", hl.dsp.exec_cmd(ipc .. " screenshot-region"), { description = "Take a region screenshot" })

-- 10. OBS
hl.bind(
	meta .. "+ F5",
	hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }),
	{ description = "Toggle OBS recording" }
) -- Toggle Recording with SUPER+F5

-- 11. Display
hl.bind(meta .. " + ALT + B", function()
	hdr.toggle()
end, {
	description = "Toggle HDR / SDR",
})
