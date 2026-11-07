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
require("config/overview")
require("config/rules")
require("config/keybinds")
require("config/layout")
require("config/autostart")
require("config/bitwarden_web_fix").setup()
require("scripts/cycle_layouts")

-- This loads Noctalia-generated Hyprland colors.
dofile(os.getenv("HOME") .. "/.config/hypr/noctalia/noctalia-colors.lua")

-- For Noctalia Color templates
require("noctalia")
