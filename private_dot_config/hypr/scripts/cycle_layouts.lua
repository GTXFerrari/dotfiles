local meta = "SUPER"

local function notify_layout(layout)
	local pretty = layout:sub(1, 1):upper() .. layout:sub(2)

	hl.exec_cmd(string.format([[notify-send -a "Hyprland" -u low -t 1500 "Layout: %s"]], pretty))
end

hl.bind(meta .. "+ TAB", function()
	local layouts = { "scrolling", "dwindle", "master", "monocle" }
	local workspace = hl.get_active_workspace()
	local next_layout = "master"

	if not workspace then
		return
	end

	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end
	hl.workspace_rule({ workspace = workspace.name, layout = next_layout })
	notify_layout(next_layout)
end)
