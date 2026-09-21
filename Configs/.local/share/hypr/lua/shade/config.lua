-- config.lua

-- Main Hyprland Lua config file
-- This is loaded before any other files
-- Users can declare their config in ~/.config/hypr/hyprland.lua

_G.shade = _G.shade or {}
shade.config = shade.config or {}

-- ! Experimental! !
shade.get_config = shade.get_config or {}
function shade.get_config(path)
	local cur = shade.config
	for part in path:gmatch("[^.]+") do
		cur = cur[part]
	end
	return cur
end

function shade.config.get(path)
	return function()
		return shade.get_config(path)
	end
end

-- We use this to make shade.config reactive in binds and handlers
-- this is not so cheap , but useful if we want to respect `shade.config...  = values otf
-- without redeclaring binds and handlers, so we can change behavior on the fly by just changing config values!
-- This is analoggus to `shade.dsp.exec_cmd`
function shade.config.exec(path)
	return function()
		local cmd = shade.get_config(path)
		if type(cmd) ~= "string" or cmd == "" then
			return
		end
		if type(hl.notification.create) == "function" then
			hl.notification.create(
				{
					text = "Launching " .. cmd,
					timeout = 1000
				}
			)
		end
		if type(hl.dsp.exec_cmd) == "function" then
			hl.dispatch(hl.dsp.exec_cmd(cmd))
		end
	end
end

-- * Stable *

local function merge_config(dest, src, opts)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dest[k]) == "table" then
			merge_config(dest[k], v, opts)
		elseif opts and opts.skip_empty and (v == "" or v == nil) then
			-- preserve existing destination value when source is empty
		else
			dest[k] = v
		end
	end
end

function shade.config.apply(cfg, opts)
	if type(cfg) ~= "table" then
		return shade.config
	end
	merge_config(shade.config, cfg, opts)
	return shade.config
end

setmetatable(
	shade.config,
	{
		__call = function(t, cfg, opts)
			return shade.config.apply(cfg, opts)
		end
	}
)

-- * config.toml
local ok, toml = pcall(check_require, "toml")
if not ok then
	local message = "[shade] Hyprland does not detect TOML parser! Run: shade-shell luainit"
	if type(hl.exec_cmd) == "function" then
		hl.exec_cmd("hyprctl seterror 'rgba(c79bf0ff)' " .. message)
	end
	toml = nil
end

function shade.config.load_toml(filename)
	if type(toml) ~= "table" or type(toml.parse) ~= "function" then
		-- error("TOML parser not available")
		return -- Silent failure if TOML parser is not available, as this is an optional feature
	end
	local ok, data = pcall(toml.parse, filename)
	if not ok then
		error("Failed to parse TOML: " .. tostring(data))
	end

	if type(data) ~= "table" then
		return shade.config
	end

	local desktop = data.desktop
	if type(desktop) == "table" then
		if type(desktop.apps) == "table" and desktop.app == nil then
			desktop.app = desktop.apps
		end
		shade.config.apply(desktop)
	end

	local hyprland = data.hyprland
	if type(hyprland) == "table" then
		shade.config.apply(hyprland)
	end

	return shade.config
end

local default_config = {
	ui = {
		shade_theme = nil,
		-- gtk
		gtk_theme = nil,
		icon_theme = nil,
		color_scheme = nil,
		button_layout = nil,
		-- Cursor
		cursor_theme = nil,
		cursor_size = nil,
		-- Fonts
		font = nil,
		font_size = nil,
		document_font = nil,
		document_font_size = nil,
		monospace_font = nil,
		monospace_font_size = nil,
		notification_font = nil,
		bar_font = nil,
		menu_font = nil,
		font_antialiasing = nil,
		font_hinting = nil,
		-- Extra Themes
		code_theme = nil,
		sddm_theme = nil
	},
	wallbash = {
		mode = "theme"
	},
	window = {
		float_size_bounds = {
			enabled = true,
			scale = 0.95,
			force_center = false
		},
		float_follow_cursor = {
			enabled = true,
			mode = "default"
		}
	},
	monitor = {
		edge_margin = {0.01}
	},
	anim = {
		duration_scale = 1.0
	}
}

shade.config(default_config)
shade.config.ui = shade.config.ui or {}
shade.config.wallbash = shade.config.wallbash or {}
shade.config.window = shade.config.window or {}
shade.config.window.float = shade.config.window.float or {}
shade.config.monitor = shade.config.monitor or {}
shade.config.anim = shade.config.anim or {}
shade.config.app = shade.config.app or {}
shade.config.modifiers = shade.config.modifiers or {}
shade.config.start = shade.config.start or {}

-- Example usage:
--
-- Direct table assignment:
-- shade.config.ui.groupbar_font = "JetBrainsMono Nerd Font"
-- shade.config.anim.duration_scale = 0.9
-- shade.config.window.float_follow_cursor.enabled = true
--
-- Merge a config block safely:
-- shade.config({
--     ui = {
--         groupbar_font = "JetBrainsMono Nerd Font",
--         icon_theme = "Tela-circle-dracula",
--     },
--     anim = {
--         duration_scale = 0.9,
--     },
--     other = {
--         added = "some other config",
--     },
-- })s
--
-- Bad: do not reassign shade.config to a new table.
-- This file establishes defaults and merge behavior, so keep the table object intact.
-- Devs! Defualts are in `variables.lua`! Do not set defaults here, only in `variables.lua`! This file is for merge behavior and helper functions!
