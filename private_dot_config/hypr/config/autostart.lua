--[[
 █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
                                                                             
--]]

hl.on("hyprland.start", function()
	-- Noctalia-Shell
	hl.exec_cmd("qs -c noctalia-shell")
	-- Applications
	hl.exec_cmd("zen-browser", {
		workspace = "2 silent",
	})
	hl.exec_cmd("firefox", {
		workspace = "special:firefox silent",
	})
	hl.exec_cmd("firefoxpwa site launch 01KP4V3YWRRT6NCRRWKP774QP3", {
		workspace = "special:codex silent",
	}) -- ChatGPT
	hl.exec_cmd("fooyin", {
		workspace = "4 silent",
	})
	hl.exec_cmd("Telegram", {
		workspace = "5 silent",
	})
	-- hl.exec_cmd("virt-manager", {
	-- 	workspace = "6 silent",
	-- })
	hl.exec_cmd("obsidian", {
		workspace = "7 silent",
	})
	hl.exec_cmd("discord", {
		workspace = "8 silent",
	})
	hl.exec_cmd("steam", {
		workspace = "9 silent",
	})
	hl.exec_cmd("jdownloader", {
		workspace = "10 silent",
	})
	hl.exec_cmd("obs", {
		workspace = "special:obs",
	})
	hl.exec_cmd("easyeffects")
	hl.exec_cmd("/opt/piavpn/bin/pia-client --quiet")
	-- hl.exec_cmd("rbw-agent")
	-- hl.exec_cmd('kitty --title "rbw_unlock" rbw-unlock.sh')
end)
