--[[
███████╗███╗   ██╗██╗   ██╗
██╔════╝████╗  ██║██║   ██║
█████╗  ██╔██╗ ██║██║   ██║
██╔══╝  ██║╚██╗██║╚██╗ ██╔╝
███████╗██║ ╚████║ ╚████╔╝ 
╚══════╝╚═╝  ╚═══╝  ╚═══╝  
                           
--]]

-- Toolkits
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG Specs
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Themes
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- SSH
hl.env("SSH_AUTH_SOCK", "$XDG_RUNTIME_DIR/ssh-agent.socket")

-- Nvidia
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_GSYNC_ALLOWED", 1)
hl.env("__GL_VRR_ALLOWED", 1)
