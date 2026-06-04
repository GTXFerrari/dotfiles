--[[
██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗     ██╗     ██╗   ██╗ █████╗ 
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗    ██║     ██║   ██║██╔══██╗
███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║    ██║     ██║   ██║███████║
██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║    ██║     ██║   ██║██╔══██║
██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝    ███████╗╚██████╔╝██║  ██║
╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝
                                                                                                
--]]

require("config/env")
require("config/monitors")
require("config/input")
require("config/animations")
require("config/decoration")
require("config/rules")
require("config/keybinds")
require("config/layout")
require("config/autostart")
require("config/bitwarden_web_fix").setup()
require("scripts/cycle_layouts")

-- This loads Noctalia-generated Hyprland colors.
dofile("/home/jake/.config/hypr/noctalia/noctalia-colors.lua")
