-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

---------------------------------------------------
-- APPEARANCE & FONT
---------------------------------------------------
-- Set the color scheme. The keymap below toggles between these.
config.color_scheme = "nord"

-- Set font size
config.font_size = 10.0

-- Terminal identifier
config.term = "xterm-256color"

---------------------------------------------------
-- WINDOW & LAYOUT
---------------------------------------------------
-- Set the initial window size in terms of character cells
config.initial_cols = 100
config.initial_rows = 25

-- Window decorations (title bar)
-- "INTEGRATED_BUTTONS | RESIZE" gives a proper title bar with buttons
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"

-- Window padding
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 5,
}

---------------------------------------------------
-- TAB BAR
---------------------------------------------------
config.use_fancy_tab_bar = true -- A simpler, cleaner look
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false -- Set to false to have tabs at the top

---------------------------------------------------
-- CURSOR
---------------------------------------------------
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.animation_fps = 1 -- Lower value for less CPU usage on animations

---------------------------------------------------
-- PERFORMANCE
---------------------------------------------------
config.front_end = "OpenGL"
config.max_fps = 144
config.prefer_egl = true

---------------------------------------------------
-- KEYMAPS & CUSTOM ACTIONS
---------------------------------------------------
config.keys = {
	-- Pane splitting
	{
		key = "v",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "s",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},

	-- Toggle background opacity between 0.9 and 1.0
	{
		key = "O",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 or overrides.window_background_opacity == nil then
				overrides.window_background_opacity = 0.9
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},

	-- Miscellaneous
	{ key = "9", mods = "CTRL|SHIFT|ALT", action = act.PaneSelect },
	{ key = "L", mods = "CTRL|SHIFT|ALT", action = act.ShowDebugOverlay },
}

-- Custom event for toggling the color scheme
wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "rose-pine-dawn" then
		-- You can replace "Cloud (terminal.sexy)" with any other theme you like
		overrides.color_scheme = "nord"
	else
		overrides.color_scheme = "rose-pine-dawn"
	end
	window:set_config_overrides(overrides)
end)

---------------------------------------------------
-- Environment
---------------------------------------------------
config.set_environment_variables = {
	WEZTERM_SHELL_INTEGRATION = "1",
}
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.scrollback_lines = 5000

---------------------------------------------------
-- FINALIZE CONFIGURATION
---------------------------------------------------
-- and finally, return the configuration to wezterm
return config
