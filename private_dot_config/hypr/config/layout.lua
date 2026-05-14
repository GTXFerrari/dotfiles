--[[
██╗      █████╗ ██╗   ██╗ ██████╗ ██╗   ██╗████████╗
██║     ██╔══██╗╚██╗ ██╔╝██╔═══██╗██║   ██║╚══██╔══╝
██║     ███████║ ╚████╔╝ ██║   ██║██║   ██║   ██║   
██║     ██╔══██║  ╚██╔╝  ██║   ██║██║   ██║   ██║   
███████╗██║  ██║   ██║   ╚██████╔╝╚██████╔╝   ██║   
╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝    ╚═╝   
                                                    
--]]

--TODO: Set up scrolling layout

local meta = "SUPER"

hl.config({
	general = {
		layout = "master",
		gaps_in = 5,
		gaps_out = 5,
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
})

-- Master Layout Keybinds
hl.bind(meta .. " + j", hl.dsp.layout("cyclenext"))
hl.bind(meta .. " + k", hl.dsp.layout("cycleprev"))
hl.bind(meta .. " + Return", hl.dsp.layout("swapwithmaster master"))
hl.bind(meta .. " + M", hl.dsp.window.fullscreen())
