local hdr = {}

local state_home = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
local state_dir = state_home .. "/hypr"
local state_file = state_dir .. "/hdr-state"

hdr.monitor = {
	output = "DP-1",
	mode = "3440x1440@165",
	position = "2732x0",
	scale = "1",

	supports_hdr = 1,
	supports_wide_color = 1,
	sdr_min_luminance = 0.005,
	sdr_max_luminance = 200,
	vrr = 3,
}

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end

	local content = f:read("*a")
	f:close()

	return content
end

local function write_file(path, content)
	os.execute("mkdir -p " .. state_dir)

	local f = io.open(path, "w")
	if not f then
		return false
	end

	f:write(content)
	f:close()

	return true
end

function hdr.enabled()
	local state = read_file(state_file)
	return state and state:match("1") ~= nil
end

function hdr.monitor_config()
	local enabled = hdr.enabled()

	return {
		output = hdr.monitor.output,
		mode = hdr.monitor.mode,
		position = hdr.monitor.position,
		scale = hdr.monitor.scale,

		supports_hdr = hdr.monitor.supports_hdr,
		supports_wide_color = hdr.monitor.supports_wide_color,
		sdr_min_luminance = hdr.monitor.sdr_min_luminance,
		sdr_max_luminance = hdr.monitor.sdr_max_luminance,
		vrr = hdr.monitor.vrr,

		cm = enabled and "hdr" or "auto",
		bitdepth = enabled and 10 or 8,
	}
end

function hdr.toggle()
	local next_state = not hdr.enabled()

	write_file(state_file, next_state and "1\n" or "0\n")

	if next_state then
		os.execute("notify-send 'HDR Enabled' 'Reloading Hyprland with DP-1 HDR / 10-bit' >/dev/null 2>&1 &")
	else
		os.execute("notify-send 'HDR Disabled' 'Reloading Hyprland with DP-1 SDR / 8-bit' >/dev/null 2>&1 &")
	end

	os.execute("hyprctl reload >/dev/null 2>&1 &")
end

return hdr
