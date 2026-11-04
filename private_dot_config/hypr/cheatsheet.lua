-- Lightweight category hints for Noctalia; not loaded by Hyprland.
-- Actual keys and descriptions always come from the live hyprctl bind registry.
-- Keep this small: the plugin's metadata scanner has a short CPU budget.
local suffix = ""

return {
	-- 1. System
	{ description = "Close a window" },
	{ description = "Log out" },
	{ description = "Lock the screen" },
	{ description = "Toggle on-screen keyboard" },

	-- 2. Applications
	{ description = "Launch " .. suffix },
	{ description = "launch " .. suffix },

	-- 3. Window management
	{ description = "Change active window " .. suffix },
	{ description = "Float a window" },
	{ description = "Widen window / scrolling column" },
	{ description = "Narrow window / scrolling column" },
	{ description = "Drag window" },
	{ description = "Resize window with mouse" },
	{ description = "Open window switcher" },
	{ description = "Toggle fullscreen" },

	-- 4. Workspaces and overview
	{ description = "Focus workspace " .. suffix },
	{ description = "Send window to workspace " .. suffix },
	{ description = "Previous workspace" },
	{ description = "Next workspace" },
	{ description = "Toggle workspace overview" },
	{ description = "Toggle Kitty Scratchpad" },
	{ description = "Toggle Gaming Workspace" },

	-- 5. Layout controls
	{ description = "Next master window / scrolling column left" },
	{ description = "Previous master window / scrolling column right" },
	{ description = "Swap window with master" },
	{ description = "Master layout: " .. suffix },
	{ description = "Cycle workspace layout" },

	-- 6. Scrolling
	{ description = "Scrolling: " .. suffix },

	-- 7. Noctalia Shell
	{ description = "Open application launcher" },
	{ description = "Toggle control center" },
	{ description = "Toggle Noctalia " .. suffix },
	{ description = "Toggle clipboard history" },
	{ description = "Toggle wallpaper picker" .. suffix },
	{ description = "Toggle keybinding cheat sheet" },
	{ description = "Next wallpaper" },

	-- 8. Media, screenshots and recording
	{ description = "Volume " .. suffix },
	{ description = "Mute audio" },
	{ description = "Brightness " .. suffix },
	{ description = "Take a region screenshot" },
	{ description = "Toggle OBS recording" },
	{ description = "Toggle HDR / SDR" },
}
