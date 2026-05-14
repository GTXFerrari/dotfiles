--[[
██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗    ██████╗ ██╗   ██╗██╗     ███████╗███████╗
██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║    ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║    ██████╔╝██║   ██║██║     █████╗  ███████╗
██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║    ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝    ██║  ██║╚██████╔╝███████╗███████╗███████║
 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
                                                                                               
--]]

-- Window Rules

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "WineTricks(float)",
	float = true,
	match = {
		class = "zenity",
		title = "WineTricks",
	},

	hl.window_rule({
		name = "lf keybind spawn",
		float = true,
		opacity = 1,
		animation = "popin",
		match = {
			class = "lf-kitty",
		},
	}),
})

hl.window_rule({
	name = "Blueman(float)",
	float = true,
	match = {
		class = "blueman-manager",
		title = "Bluetooth Devices",
	},
})

hl.window_rule({
	name = "Xarchiver(float)",
	float = true,
	match = {
		class = "xarchiver",
	},
})

hl.window_rule({
	name = "Pavucontrol(float)",
	float = true,
	match = {
		class = "org.pulseaudio.pavucontrol",
		title = "Volume Control",
	},
})

hl.window_rule({
	name = "Steam Settings (float)",
	float = true,
	match = {
		class = "steam",
		title = "Steam Settings",
	},
})

hl.window_rule({
	name = "Steam Friends List (float)",
	float = true,
	match = {
		class = "steam",
		title = "Friends List",
	},
})

hl.window_rule({
	name = "OpenRGB(float)",
	float = true,
	match = {
		class = "org.openrgb.OpenRGB",
		title = "OpenRGB",
	},
})

hl.window_rule({
	name = "OpenRGB Profile Name (float)",
	float = true,
	match = {
		class = "org.openrgb.OpenRGB",
		title = "Profile Name",
	},
})

--TODO: Needs testing
hl.window_rule({
	name = "Discord (Pin to workspace 8)",
	workspace = "8 silent",
	match = {
		class = "^(discord)$",
	},
})

--TODO: Needs testing
hl.window_rule({
	name = "Steam (Pin to workspace 9)",
	workspace = "9 silent",
	match = {
		class = "^(steam)$",
	},
})

--TODO: Needs testing
hl.window_rule({
	name = "OBS (Pin to workspace 10)",
	workspace = "10 silent",
	match = {
		class = "^(com.obsproject.Studio)$",
	},
})

hl.window_rule({
	name = "kitty opacity",
	opacity = 0.9,
	match = {
		class = "^(kitty)",
	},
})

hl.window_rule({
	name = "yay-waybar opacity",
	opacity = 0.9,
	float = true,
	match = {
		class = "^(yay-waybar)",
	},
})

hl.window_rule({
	name = "btop-waybar opacity",
	opacity = 0.9,
	float = true,
	match = {
		class = "^(btop-waybar)",
	},
})

hl.window_rule({
	name = "nvtop-waybar opacity",
	opacity = 0.9,
	float = true,
	match = {
		class = "^(nvtop-waybar)",
	},
})

hl.window_rule({
	name = "pulsemixer-waybar opacity",
	opacity = 0.9,
	match = {
		class = "^(pulsemixer-waybar)",
	},
})

hl.window_rule({
	name = "bluetui-waybar opacity",
	opacity = 0.9,
	float = true,
	match = {
		class = "^(bluetui-waybar)",
	},
})

hl.window_rule({
	name = "GnomeCalculator(float)",
	float = true,
	match = {
		class = "org.gnome.Calculator",
		title = "Calculator",
	},
})

hl.window_rule({
	name = "KCalc(float)",
	float = true,
	match = {
		class = "org.kde.kcalc",
		title = "KCalc",
	},
})

hl.window_rule({
	name = "Easyeffects(float)",
	float = true,
	match = {
		class = "com.github.wwmm.easyeffects",
		title = "Easy Effects",
	},
})

hl.window_rule({
	name = "RazerGenie(float)",
	float = true,
	match = {
		class = "xyz.z3ntu.razergenie",
		title = "RazerGenie",
	},
})

hl.window_rule({
	name = "MissionCenter(float)",
	float = true,
	match = {
		class = "io.missioncenter.MissionCenter",
		title = "Mission Center",
	},
})

hl.window_rule({
	name = "Pulsemixer(float)",
	float = true,
	match = {
		class = "kitty",
		title = "pulsemixer",
	},
})

hl.window_rule({
	name = "xdg-desktop-portal-gtk(float)",
	float = true,
	match = {
		class = "xdg-desktop-portal-gtk",
	},
})

hl.window_rule({
	name = "lf(opacity)",
	opacity = 1,
	match = {
		class = "kitty",
		title = "lf",
	},
})

hl.window_rule({
	name = "rbw unlock",
	float = true,
	size = "400 150",
	match = {
		title = "^(rbw-unlock)$",
	},
})

hl.window_rule({
	name = "Claude PWA",
	workspace = "3 silent",
	match = {
		class = "FFPWA-01KN2MKV58Q7N04YFXAT3G9BPJ",
		title = "Claude — Mozilla Firefox",
	},
})

hl.window_rule({
	name = "Kitty Scratchpad",
	float = true,
	workspace = "special:kitty_scratch",
	size = { "monitor_w * 0.75", "monitor_h * 0.75" },
	match = {
		class = "kitty-scratch",
	},
})

-- Layer Rules
hl.layer_rule({
	name = "Fuzzel",
	blur = true,
	blur_popups = true,
	dim_around = true,
	xray = false,
	animation = "slide top",
	match = {
		namespace = "launcher",
	},
})
