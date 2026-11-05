-- hyprpm loads the plugin at startup and triggers a config reload. Its options
-- are unavailable during the first parse and in standalone --verify-config mode.
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
