--[[
 █████╗ ██╗   ██╗████████╗ ██████╗ ███████╗████████╗ █████╗ ██████╗ ████████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
███████║██║   ██║   ██║   ██║   ██║███████╗   ██║   ███████║██████╔╝   ██║   
██╔══██║██║   ██║   ██║   ██║   ██║╚════██║   ██║   ██╔══██║██╔══██╗   ██║   
██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║   ██║   ██║  ██║██║  ██║   ██║   
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
                                                                             
--]]

hl.on("hyprland.start", function()
	-- Bitwarden Web Fix
	hl.exec_cmd("$HOME/.local/bin/scripts/bitwardenhypr_fix")
	-- Clipboard
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	-- Hypr
	hl.exec_cmd("systemctl --user start hyprpaper")
	hl.exec_cmd("systemctl --user start hypridle")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	-- Applications
	hl.exec_cmd("mako")
	hl.exec_cmd("waybar -c ~/.config/waybar/config.jsonc")
	hl.exec_cmd("zen-browser", {
		workspace = "2 silent",
	})
	hl.exec_cmd("firefoxpwa site launch 01KN2MKV58Q7N04YFXAT3G9BPJ", {
		workspace = "3 silent",
	})
	-- hl.exec_cmd(
	-- 	[[env WINEPREFIX=/home/jake/Wine/foobar2000 wine "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\foobar2000.lnk"]],
	-- 	{
	-- 		workspace = "4 silent",
	-- 	}
	-- )
	hl.exec_cmd("fooyin", {
		workspace = "4 silent",
	})
	hl.exec_cmd("Telegram", {
		workspace = "5 silent",
	})
	hl.exec_cmd("virt-manager", {
		workspace = "6 silent",
	})
	hl.exec_cmd("obsidian", {
		workspace = "7 silent",
	})
	hl.exec_cmd("discord", {
		workspace = "8 silent",
	})
	hl.exec_cmd("steam -silent", {
		workspace = "9 silent",
	})
	hl.exec_cmd("jdownloader", {
		workspace = "special:jdl silent",
	})
	hl.exec_cmd("easyeffects")
	hl.exec_cmd("/opt/piavpn/bin/pia-client --quiet")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("xrdb ~/.Xresources")
	hl.exec_cmd("rbw-agent")
	hl.exec_cmd('kitty --title "rbw_unlock" rbw-unlock.sh')
end)
