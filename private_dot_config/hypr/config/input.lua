--[[
██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
██║██╔██╗ ██║██████╔╝██║   ██║   ██║   
██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   
██║██║ ╚████║██║     ╚██████╔╝   ██║   
╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝   
                                       
--]]

hl.config({
	input = {
		kb_layout = "us",
		repeat_delay = 300,
		repeat_rate = 50,
		follow_mouse = 1,
		sensitivity = 0,
		accel_profile = "flat",
	},
	cursor = {
		inactive_timeout = 3,
	},
})

-- Sunshine / Moonlight relative mouse
hl.device({
	name = "libvirtualhid-mouse",
	sensitivity = 0.0,
	accel_profile = "flat",
	scroll_factor = 0.5,
	natural_scroll = false,
})

-- Sunshine / Moonlight absolute mouse
hl.device({
	name = "libvirtualhid-mouse-(absolute)",
	sensitivity = 0.0,
	accel_profile = "flat",
	scroll_factor = 0.5,
	natural_scroll = false,
})
