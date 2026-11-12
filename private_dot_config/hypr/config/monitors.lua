--[[
███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ ███████╗
████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝
██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝███████╗
██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗╚════██║
██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║███████║
╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝
                                                                   
--]]

local hdr = require("scripts.hdr")
local runtime = os.getenv("XDG_RUNTIME_DIR")
local instance = os.getenv("HYPRLAND_INSTANCE_SIGNATURE")
local stream_state = runtime and instance and (runtime .. "/sunshine-vmon-" .. instance .. "/state.json")

local function streaming()
	local file = stream_state and io.open(stream_state, "r")
	if file then
		file:close()
		return true
	end
	return false
end

local function primary_ready()
	local primary = hl.get_monitor("DP-1")
	return primary ~= nil and primary.enabled and primary.dpms_status
end

hl.monitor(hdr.monitor_config())

-- Sunshine's forced HDMI EDID. Other displays retain their own rules.
local hdmi_description = "Philips Consumer Electronics Company Sunshine HDR"
local hdmi_rule = {
	output = "desc:" .. hdmi_description,
	mode = "2732x2048@60",
	position = "auto",
	scale = 2,
	bitdepth = 10,
	cm = "hdr",
	vrr = 2,
}

if streaming() then
	-- Keep the selected mode and the primary's disabled rule across reloads.
	local hdmi = hl.get_monitor("HDMI-A-1")
	if hdmi and hdmi.enabled and hdmi.description == hdmi_description then
		hdmi_rule.mode = string.format("%dx%d@%.3f", hdmi.width, hdmi.height, hdmi.refresh_rate)
		hdmi_rule.cm = hdmi.cm
		hdmi_rule.bitdepth = hdmi.cm == "srgb" and 8 or 10
		hdmi_rule.supports_hdr = hdmi.cm == "srgb" and -1 or 0
	end
	hl.monitor({ output = "DP-1", disabled = true })
else
	hdmi_rule.disabled = primary_ready()
end
hl.monitor(hdmi_rule)

-- A powered-off DP panel may disappear or enter DPMS standby. Keep a KMS
-- output available until the primary is usable again.
local hdmi_disabled = hdmi_rule.disabled or false
hl.timer(function()
	if streaming() then
		return
	end
	local ready = primary_ready()
	if hdmi_disabled ~= ready then
		hl.monitor({ output = hdmi_rule.output, disabled = ready })
		hdmi_disabled = ready
	end
	if not ready then
		local hdmi = hl.get_monitor("HDMI-A-1")
		if hdmi and hdmi.enabled and hdmi.description == hdmi_description and not hdmi.dpms_status then
			hl.dispatch(hl.dsp.dpms({ monitor = "HDMI-A-1", action = "enable" }))
		end
	end
end, { timeout = 1000, type = "repeat" })

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
