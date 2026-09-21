local systemd_env = {
    "WAYLAND_DISPLAY",
    "XDG_CURRENT_DESKTOP",
    "XDG_SESSION_TYPE",
    "XDG_SESSION_DESKTOP",
    "XDG_CONFIG_HOME",
    "XDG_DATA_HOME",
    "XDG_CACHE_HOME",
    "XDG_STATE_HOME",
    "QT_QPA_PLATFORMTHEME"
}
local systemd_env_str = table.concat(systemd_env, " ")

local unt = "shade-" .. (os.getenv("XDG_SESSION_DESKTOP") or "") -- Holder for the unit name
local svc = "service" -- Holder for the service command
local scp = "scope" -- Holder for the scope command

-- shade env
shade.env("XDG_CURRENT_DESKTOP", "Hyprland")
shade.env("XDG_SESSION_TYPE", "wayland")
shade.env("XDG_SESSION_DESKTOP", "Hyprland")
shade.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
shade.env("QT_QPA_PLATFORM", "wayland;xcb")
shade.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
shade.env("QT_QPA_PLATFORMTHEME", "qt6ct")
shade.env("MOZ_ENABLE_WAYLAND", "1")
shade.env("GDK_SCALE", "1")
shade.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
shade.env("XDG_CONFIG_HOME", os.getenv("XDG_CONFIG_HOME") or ((os.getenv("HOME") or "") .. "/.config"))
shade.env("XDG_CACHE_HOME", os.getenv("XDG_CACHE_HOME") or ((os.getenv("HOME") or "") .. "/.cache"))
shade.env("XDG_DATA_HOME", os.getenv("XDG_DATA_HOME") or ((os.getenv("HOME") or "") .. "/.local/share"))
shade.env("XDG_STATE_HOME", os.getenv("XDG_STATE_HOME") or ((os.getenv("HOME") or "") .. "/.local/state"))
shade.env("PATH", os.getenv("PATH") or "")

local hc = shade.config

-- Startup commands

hc.start.dbus_share_picker = "dbus-update-activation-environment --systemd " .. systemd_env_str
hc.start.systemd_share_picker = "systemctl --user import-environment " .. systemd_env_str
hc.start.xdg_portal_reset = "shade-shell resetxdgportal.lua"
hc.start.auth_dialogue = "shade-shell app -t " .. svc .. " -- polkitkdeauth.sh"
hc.start.idle_daemon = "shade-shell app -u " .. unt .. "-idle.service -t " .. svc .. " -- hypridle"
hc.start.blue_light_filter_daemon =
    "shade-shell app -u " .. unt .. "-blue-light-filter.service -t " .. svc .. " -- hyprsunset"
hc.start.text_clipboard =
    "shade-shell app -u " ..
    unt .. "-text-clipboard.service -t " .. svc .. " wl-paste --type text --watch cliphist store"
hc.start.image_clipboard =
    "shade-shell app -u " ..
    unt .. "-image-clipboard.service -t " .. svc .. " wl-paste --type image --watch cliphist store"
hc.start.clipboard_persist =
    "shade-shell app -u " .. unt .. "-clipboard-persist.service -t " .. svc .. " wl-clip-persist --clipboard regular"
hc.start.wallpaper =
    "shade-shell app -u " .. unt .. "-wallpaper.service -t " .. svc .. " -- wallpaper.sh --start --global"
hc.start.bar = "shade-shell app -u " .. unt .. "-bar.scope -t " .. scp .. " -- waybar.py --watch" -- waybar.py injects it itself as -u $unt.service :- therefore we use scope here to avoid conflicts
hc.start.notifications = "shade-shell app -u " .. unt .. "-notifications.service -t " .. svc .. " -- dunst"
hc.start.battery_notify = "shade-shell app -u " .. unt .. "-battery-notify.service -t " .. svc .. " -- batterynotify.lua"
hc.start.applet_network_manager =
    "shade-shell app -u " .. unt .. "-network-manager-applet.service -t " .. svc .. " -- nm-applet --indicator"
hc.start.applet_removable_media =
    "shade-shell app -u " ..
    unt .. "-removable-media-applet.service -t " .. svc .. " -- udiskie --no-automount --smart-tray"
hc.start.applet_bluetooth =
    "shade-shell app -u " .. unt .. "-bluetooth-applet.service -t " .. svc .. " -- blueman-applet"
hc.start.shade_config = "shade-shell app -u " .. unt .. "-config-watcher.service -t " .. svc .. " -- config.lua"

-- Themes (assign to shade.config.ui)
hc.ui.shade_theme = "shade"
hc.ui.gtk_theme = "Wallbash-Gtk"
hc.ui.icon_theme = "Tela-circle-dracula"
hc.ui.color_scheme = "prefer-dark"
hc.ui.button_layout = "" -- colon separated list of buttons

-- Cursor
hc.ui.cursor_theme = "Bibata-Modern-Ice"
hc.ui.cursor_size = 24

-- Fonts
hc.ui.font = "Cantarell"
hc.ui.font_size = 10
hc.ui.document_font = "Cantarell"
hc.ui.document_font_size = 10
hc.ui.monospace_font = "CaskaydiaCove Nerd Font Mono"
hc.ui.monospace_font_size = 9
hc.ui.notification_font = "Mononoki Nerd Font Mono"
hc.ui.bar_font = "JetBrainsMono Nerd Font"
hc.ui.menu_font = "JetBrainsMono Nerd Font"
hc.ui.font_antialiasing = "rgba"
hc.ui.font_hinting = ""

-- Extra Themes
hc.ui.code_theme = ""
hc.ui.sddm_theme = ""

-- Apps and launchers
hc.app.quickapps = nil
hc.app.browser = "shade-shell open --fall firefox web-browser"
hc.app.editor = "shade-shell open --fall code-oss code-editor"
hc.app.explorer = "shade-shell open --fall dolphin file-manager"
hc.app.terminal = "shade-shell app -T"
hc.app.lockscreen = "shade-shell lock-session"

-- Mod keys
hc.modifiers.main = "SUPER"
hc.modifiers.shift = "SHIFT"
hc.modifiers.alt = "ALT"
hc.modifiers.ctrl = "CTRL"
