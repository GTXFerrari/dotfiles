--[[
███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ ███████╗
████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝███████╗
██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗╚════██║
██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║███████║
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
                                                                   
--]]

local hdr = require("scripts.hdr")

hl.monitor(hdr.monitor_config())

-- hl.monitor({
-- 	output = "DP-1",
-- 	mode = "3440x1440@165",
-- 	position = "2732x0",
-- 	scale = "1",
-- 	supports_hdr = 1,
-- 	supports_wide_color = 1,
-- 	sdr_min_luminance = 0.005,
-- 	sdr_max_luminance = 200,
-- 	vrr = 3,
--
-- 	cm = "auto",
-- 	bitdepth = 8,
-- })

hl.monitor({
	output = "HEADLESS-2",
	mode = "2732x2048@120",
	-- mode = "3840x2160@120",
	position = "0x0",
	scale = "2",
	supports_hdr = 1,
	supports_wide_color = 1,
	cm = "auto",
	bitdepth = 8,
	vrr = 3,
})

hl.config({
	render = {
		cm_auto_hdr = 1,
	},
})
