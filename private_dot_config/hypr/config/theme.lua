--[[
████████╗██╗  ██╗███████╗███╗   ███╗███████╗███████╗
╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝██╔════╝
   ██║   ███████║█████╗  ██╔████╔██║█████╗  ███████╗
   ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  ╚════██║
   ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗███████║
   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚══════╝
                                                    
--]]

local theme = {}

theme.themes = {
	tokyo_night = {
		active_border = {
			colors = {
				"rgba(7aa2f7ff)",
				"rgba(bb9af7ff)",
			},
			angle = 45,
		},

		inactive_border = "rgba(292e42ff)",
	},

	nord = {
		active_border = {
			colors = {
				"rgba(88c0d0ff)",
				"rgba(81a1c1ff)",
			},
			angle = 0,
		},

		inactive_border = "rgba(3b4252ff)",
	},
	gruvbox = {
		active_border = {
			colors = {
				"rgba(fabd2fff)", -- yellow
				"rgba(fb4934ff)", -- red
			},
			angle = 45,
		},

		inactive_border = "rgba(504945ff)",
	},
}

theme.order = {
	"tokyo_night",
	"nord",
	"gruvbox",
}

theme.current = 1

function theme.apply(name)
	local t = theme.themes[name]
	local win = hl.get_active_window()

	hl.config({
		general = {
			col = {
				active_border = t.active_border,
				inactive_border = t.inactive_border,
			},
		},
	})

	hl.dispatch(hl.dsp.window.cycle_next()) -- This is super hacky, need to debug this so you return to the original window.. Breaks when windows open is >2, also is triggered anytime a hypr config file is saved
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.exec_cmd(string.format('notify-send "Hyprland Theme" "%s"', name))
end

function theme.next()
	theme.current = theme.current + 1

	if theme.current > #theme.order then
		theme.current = 1
	end

	local name = theme.order[theme.current]

	theme.apply(name)
end

return theme
