-- ScrollOverview built for Hyprland 0.56.2; rebuild after a Hyprland version change.
hl.plugin.load("/home/jake/.config/hypr/plugins/scrolloverview/scrolloverview.so")

-- Plugin loading triggers a config reload. Its options are unavailable during
-- the first parse and in Hyprland's standalone --verify-config mode.
if hl.plugin.scrolloverview then
	hl.config({
		plugin = {
			scrolloverview = {
				scale = 0.5,
				workspace_gap = 100,
				layout = "vertical",
				wallpaper = 2,
				blur = true,
				shadow = {
					enabled = true,
					range = 50,
				},
			},
		},
	})
end
