--[[
██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗
██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝
██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║   
██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║   
███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║   
╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   
                                                    
--]]

local meta = "SUPER"
local layout_bind = require("scripts.layout_bind")

hl.config({
	general = {
		layout = "master",
		border_size = 2,
		resize_on_border = false,
		allow_tearing = true,
	},
	misc = {
		enable_swallow = true,
		swallow_regex = "^(Alacritty|kitty|foot|ghostty)$",
		on_focus_under_fullscreen = 2,
		vrr = 3,
	},
	master = {
		allow_small_split = false,
		mfact = 0.5,
		new_status = "master",
		new_on_top = false,
		new_on_active = "none",
		orientation = "left",
		smart_resizing = true,
		drop_at_cursor = true,
	},
	scrolling = {
		-- Niri-like columns: keep their width, fit at the edges, and stop at each end.
		fullscreen_on_one_column = false,
		column_width = 0.5,
		focus_fit_method = 1,
		follow_focus = true,
		follow_min_visible = 0.4,
		explicit_column_widths = "0.5, 1.0",
		wrap_focus = false,
		wrap_swapcol = false,
		direction = "right",
	},
})

-- 1. Layout controls
-- Preserve master controls; J/K focus left/right on scrolling workspaces like Niri.
hl.bind(
	meta .. " + j",
	layout_bind(hl.dsp.layout("focus l"), hl.dsp.layout("cyclenext")),
	{ description = "Next master window / scrolling column left" }
)
hl.bind(
	meta .. " + k",
	layout_bind(hl.dsp.layout("focus r"), hl.dsp.layout("cycleprev")),
	{ description = "Previous master window / scrolling column right" }
)
hl.bind(meta .. " + Return", hl.dsp.layout("swapwithmaster master"), { description = "Swap window with master" })
hl.bind(meta .. " + M", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })
hl.bind(meta .. " + SHIFT + T", hl.dsp.layout("orientationtop"), { description = "Master layout: put master on top" })
hl.bind(meta .. " + T", hl.dsp.layout("orientationleft"), { description = "Master layout: put master on left" })

-- 2. Scrolling
-- Niri-style controls, active only for tiled windows in the scrolling layout.
local function scrolling_bind(keys, message, description, repeating)
	hl.bind(meta .. " + " .. keys, layout_bind(hl.dsp.layout(message)), {
		description = "Scrolling: " .. description,
		repeating = repeating or false,
	})
end

scrolling_bind("CTRL + Left", "swapcol l", "move column left", true)
scrolling_bind("CTRL + Right", "swapcol r", "move column right", true)
hl.bind(meta .. " + CTRL + Up", layout_bind(hl.dsp.window.move({ direction = "u" })), {
	description = "Scrolling: move window up in column",
	repeating = true,
})
hl.bind(meta .. " + CTRL + Down", layout_bind(hl.dsp.window.move({ direction = "d" })), {
	description = "Scrolling: move window down in column",
	repeating = true,
})
scrolling_bind("bracketleft", "consume_or_expel prev", "stack/unstack to the left")
scrolling_bind("bracketright", "consume_or_expel next", "stack/unstack to the right")
scrolling_bind("R", "colresize +conf", "next column width (half/full)")
scrolling_bind("SHIFT + R", "colresize -conf", "previous column width (half/full)")
scrolling_bind("minus", "colresize -0.1", "narrow column by 10%", true)
scrolling_bind("equal", "colresize +0.1", "widen column by 10%", true)
scrolling_bind("C", "center", "center column")
scrolling_bind("CTRL + F", "fit expand", "expand column into available space")
hl.bind(meta .. " + SHIFT + F", layout_bind(hl.dsp.window.fullscreen()), {
	description = "Scrolling: toggle fullscreen",
})
scrolling_bind("SHIFT + mouse_up", "focus l", "focus column left")
scrolling_bind("SHIFT + mouse_down", "focus r", "focus column right")
scrolling_bind("mouse_left", "focus l", "focus column left")
scrolling_bind("mouse_right", "focus r", "focus column right")
