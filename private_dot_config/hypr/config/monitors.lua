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

-- Keep the VNC virtual display disabled across configuration reloads.
hl.monitor({ output = "Virtual-1", disabled = true })

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
-- 	cm = "hdr",
-- 	bitdepth = 10,
-- })

hl.monitor({
	output = "HEADLESS-2",
	mode = "2732x2048@120",
	-- mode = "3024x1964@120",
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
	xwayland = {
		force_zero_scaling = true,
	},
	render = {
		cm_auto_hdr = 1,
	},
})

-- Keep the physical output off if a preset/config reload happens mid-stream.
local runtime = os.getenv("XDG_RUNTIME_DIR")
local instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
if runtime and instance then
	local stream_state = io.open(runtime .. "/sunshine-vmon-" .. instance .. "/state.json", "r")
	if stream_state then
		stream_state:close()
		hl.monitor({ output = "DP-1", disabled = true })
	end
end
