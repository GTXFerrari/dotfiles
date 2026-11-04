--[[
██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗    ██████╗ ██╗   ██╗██╗     ███████╗███████╗
██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║    ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║    ██████╔╝██║   ██║██║     █████╗  ███████╗
██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║    ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝    ██║  ██║╚██████╔╝███████╗███████╗███████║
 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
                                                                                               
--]]

-- (Window Rules)
local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

local fixWaylandDrag = hl.window_rule({
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
fixWaylandDrag:set_enabled(true)

hl.window_rule({
	name = "tui filemanager",
	float = true,
	center = true,
	opacity = 0.8,
	animation = "popin",
	size = {
		"(monitor_w*0.75)",
		"(monitor_h*0.75)",
	},
	match = {
		class = "lf-kitty",
	},
})

hl.window_rule({
	name = "GOverlay preview (float and center)",
	float = true,
	center = true,
	match = {
		initial_class = "^pascube$",
	},
})

hl.window_rule({
	name = "OpenRGB(float)",
	float = true,
	center = true,
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

hl.window_rule({
	name = "Discord (Pin to workspace 8)",
	workspace = "8 silent",
	match = {
		class = "^(discord)$",
	},
})

hl.window_rule({
	name = "Steam (Pin to game workspace)",
	workspace = "9 silent",
	match = {
		class = "^(steam)$",
	},
})

hl.window_rule({
	name = "Prism Launcher console (float)",
	float = true,
	match = {
		class = [[org\.prismlauncher\.PrismLauncher]],
		title = "Console window for .*",
	},
})

hl.window_rule({
	name = "OBS (Workspace 10, silent)",
	workspace = "10 silent",
	match = {
		class = "^(com.obsproject.Studio)$",
	},
})

hl.window_rule({
	name = "kitty opacity",
	opacity = 0.85,
	match = {
		class = "^(kitty)",
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
	animation = "slide",
	size = {
		"(monitor_w*0.8)",
		"(monitor_h*0.8)",
	},
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
	-- opacity = 1,
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
	name = "Kitty Scratchpad",
	float = true,
	workspace = "special:kitty_scratch",
	size = { "monitor_w * 0.75", "monitor_h * 0.75" },
	match = {
		class = "kitty-scratch",
	},
})

hl.window_rule({
	name = "Satty",
	float = true,
	center = true,
	match = {
		class = "com.gabm.satty",
		title = "satty",
	},
})

hl.window_rule({
	name = "imv",
	fullscreen = true,
	match = {
		class = "imv",
	},
})

hl.window_rule({
	name = "Sushi Preview (nautilus)",
	float = true,
	match = {
		class = "org.gnome.NautilusPreviewer",
	},
})

hl.window_rule({
	name = "Zathura Float",
	float = true,
	center = true,
	size = {
		"(monitor_w*0.3)",
		"(monitor_h*0.9)",
	},
	match = {
		class = "org.pwmt.zathura",
	},
})

hl.window_rule({
	name = "Virt-manager-spawned",
	float = true,
	center = true,
	size = {
		"(monitor_w*0.8)",
		"(monitor_h*0.8)",
	},
	match = {
		initial_class = "^virt-manager$",
		initial_title = "negative:^Virtual Machine Manager$",
	},
})

hl.window_rule({
	name = "float-steam-spawned-windows",
	match = {
		initial_class = "^steam$",
		initial_title = "negative:^Steam$",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-duckstation-spawned-windows",
	match = {
		initial_class = [[^org\.duckstation\.DuckStation$]],
		initial_title = [[negative:^DuckStation( [0-9].*)?$]],
	},
	size = {
		"(monitor_h*0.6)",
		"(monitor_w*0.6)",
	},
	float = true,
	center = true,
})

hl.window_rule({
	name = "qt5ct",
	float = true,
	center = true,
	match = {
		class = "qt5ct",
	},
	size = {
		"(monitor_w*0.35)",
		"(monitor_h*0.5)",
	},
})

hl.window_rule({
	name = "qt6ct",
	float = true,
	center = true,
	match = {
		class = "qt6ct",
	},
	size = {
		"(monitor_w*0.3.5)",
		"(monitor_h*0.5)",
	},
})

hl.window_rule({
	name = "nwg-look",
	float = true,
	center = true,
	match = {
		class = "nwg-look",
	},
	size = {
		"(monitor_w*0.4)",
		"(monitor_h*0.5)",
	},
})

hl.window_rule({
	match = {
		class = "^(steam)$",
		title = "^(notificationtoasts_.*_desktop)$",
	},
	rounding = 0,
})

hl.window_rule({
	name = "FIFA 22",
	float = true,
	center = true,
	match = {
		class = "steam_app_1506830",
		title = "FIFA 22",
	},
})

hl.window_rule({
	name = "Noctalia Settings",
	float = true,
	center = true,
	match = {
		class = "dev.noctalia.Noctalia",
		title = "Noctalia Settings",
	},
	size = {
		"(monitor_w*0.75)",
		"(monitor_h*0.75)",
	},
})

hl.window_rule({
	match = {
		class = "^pcsx2-qt$",
		title = "negative:^PCSX2 v[0-9].*",
	},
	float = true,
	center = true,
})

hl.window_rule({
	match = {
		class = "firefox",
		title = "Library",
	},
	size = {
		"(monitor_w*0.75)",
		"(monitor_h*0.75)",
	},
	float = true,
	center = true,
})

hl.window_rule({
	match = {
		class = "",
		title = "",
	},
})

-- Smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

-- Scrolling test workspace: Niri's 10px gaps, including for a single column.
-- Keep these after smart gaps so a lone half-width window keeps its decoration.
hl.workspace_rule({ workspace = "10", layout = "scrolling", gaps_out = 10, gaps_in = 5 })
hl.window_rule({ match = { float = false, workspace = "10" }, border_size = 2, rounding = 15 })

-- Layer Rules
hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
	},
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})
