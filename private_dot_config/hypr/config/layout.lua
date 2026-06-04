--[[
██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗
██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝
██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║   
██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║   
███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║   
╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   
                                                    
--]]

local meta = "SUPER"

hl.config({
	general = {
		layout = "master",
		gaps_in = 5,
		gaps_out = 10,
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
		special_scale_factor = 1,
		mfact = 0.5,
		new_status = "master",
		new_on_top = false,
		new_on_active = "none",
		orientation = "left",
		smart_resizing = true,
		drop_at_cursor = true,
	},
	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 1,
		focus_fit_method = 1,
		follow_focus = true,
		follow_min_visible = 0.4,
		explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
		wrap_focus = true,
		wrap_swapcol = true,
		direction = "right",
	},
})

-- Master Layout Keybinds
hl.bind(meta .. " + j", hl.dsp.layout("cyclenext"))
hl.bind(meta .. " + k", hl.dsp.layout("cycleprev"))
hl.bind(meta .. " + Return", hl.dsp.layout("swapwithmaster master"))
hl.bind(meta .. " + M", hl.dsp.window.fullscreen())

-- Scrolling Layout Keybinds
hl.bind(meta .. " + Up", hl.dsp.layout("move +col"))
hl.bind(meta .. " + Down", hl.dsp.layout("move -col"))
hl.bind(meta .. " + Left", hl.dsp.layout("swapcol l"))
hl.bind(meta .. " + Right", hl.dsp.layout("swapcol r"))
