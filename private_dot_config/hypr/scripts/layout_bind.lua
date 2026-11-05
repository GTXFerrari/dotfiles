-- Use scrolling actions only for tiled windows on a scrolling workspace.
-- Special workspaces take priority over the workspace underneath them.
return function(scrolling_action, fallback)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
		local window = hl.get_active_window()
		local action = fallback

		if workspace and workspace.tiled_layout == "scrolling" and window and not window.floating then
			action = scrolling_action
		end

		if action then
			hl.dispatch(action)
		end
	end
end
