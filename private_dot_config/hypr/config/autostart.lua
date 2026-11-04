--[[
 █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
                                                                             
--]]

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- /home/jake/.config/hypr/scripts/wvkbd.sh start")
	hl.exec_cmd("uwsm app -- noctalia")
	hl.exec_cmd("uwsm app -- firefox", {
		workspace = "2 silent",
	})
	hl.exec_cmd("uwsm app -- chatgpt --ozone-platform=wayland", {
		workspace = "5 silent",
	})
	hl.exec_cmd("uwsm app -- Telegram -startintray")
	hl.exec_cmd("uwsm app -- obsidian", {
		workspace = "7 silent",
	})
	hl.exec_cmd("uwsm app -- discord --start-minimized", {
		workspace = "8 silent",
	})
	-- Set 200% font DPI before Steam without blocking Hyprland on XWayland.
	hl.exec_cmd("printf 'Xft.dpi: 192\\n' | xrdb -merge -; uwsm app -- steam", {
		workspace = "9 silent",
	})
	hl.exec_cmd("uwsm app -- obs", {
		workspace = "10 silent",
	})
	hl.exec_cmd("uwsm app -- easyeffects")
	hl.exec_cmd("uwsm app -- /opt/piavpn/bin/pia-client --quiet")
end)
