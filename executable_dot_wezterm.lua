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
config.font = wezterm.font("JetBrains Mono")
config.font_size = 9.0

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
	{
		key = "V",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PasteFrom("Clipboard"),
	},

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

	-- toggle color
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},

	-- Miscellaneous
	{ key = "9", mods = "CTRL|SHIFT|ALT", action = act.PaneSelect },
	{ key = "L", mods = "CTRL|SHIFT|ALT", action = act.ShowDebugOverlay },
}

-- Custom event for toggling the color scheme
-- List of themes to rotate through
local theme_cycle = {
	{ wezterm = "nord", nvim = "nightfox" },
	{ wezterm = "rose-pine-dawn", nvim = "rose-pine-dawn" },
	{ wezterm = "rose-pine-moon", nvim = "rose-pine-moon" },
	{ wezterm = "Gruvbox Material (Gogh)", nvim = "gruvbox-material" },
	{ wezterm = "Everforest Dark (Gogh)", nvim = "everforest" },
	{ wezterm = "catppuccin-latte", nvim = "catppuccin-latte" },
	{ wezterm = "Dracula (Gogh)", nvim = "dracula" },
	{ wezterm = "dawnfox", nvim = "dawnfox" },
}

-- Helper to find current index in the cycle
local function find_current_index(current_theme)
	for i, theme in ipairs(theme_cycle) do
		if theme.wezterm == current_theme then
			return i
		end
	end
	return 0 -- Not found
end
wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	local current = overrides.color_scheme or "rose-pine-dawn"
	local theme_file = "/home/leppy/.config/nvim/lua/plugins/theme.lua"

	local i = find_current_index(current)
	local next_index = (i % #theme_cycle) + 1
	local next_theme = theme_cycle[next_index]

	overrides.color_scheme = next_theme.wezterm

	-- Replace Neovim colorscheme line using sed
	wezterm.run_child_process({
		"wsl",
		"sed",
		"-i",
		[[s/colorscheme = ".*"/colorscheme = "]] .. next_theme.nvim .. [["/]],
		theme_file,
	})

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
