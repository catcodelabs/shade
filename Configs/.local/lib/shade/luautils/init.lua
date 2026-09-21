-- luautils/init.lua
-- Initializes Lua module search paths for shade using XDG base directories.
local xdg = require("luautils.xdg")

local XDG_DATA_HOME = xdg.data
local XDG_STATE_HOME = xdg.state
local XDG_CONFIG_HOME = xdg.config

local SHADE_STATE_HOME = os.getenv("SHADE_STATE_HOME") or (XDG_STATE_HOME .. "/shade")
local SHADE_CONFIG_HOME = os.getenv("SHADE_CONFIG_HOME") or (XDG_CONFIG_HOME .. "/shade")

local SHADE_SCRIPTS_PATH = os.getenv("SHADE_SCRIPTS_PATH")
if not SHADE_SCRIPTS_PATH then
    local src = debug.getinfo(1, "S").source
    if src and src:sub(1, 1) == "@" then
        local luautils_dir = src:sub(2):match("(.*/luautils)/")
        if luautils_dir then
            SHADE_SCRIPTS_PATH = luautils_dir:gsub("/luautils/$?", "")
        end
    end
end
SHADE_SCRIPTS_PATH = SHADE_SCRIPTS_PATH or (XDG_DATA_HOME .. "/shade")
local lua_version = _VERSION:match("%d+%.%d+")

local pkg_paths = {
    SHADE_STATE_HOME .. "/?.lua",
    SHADE_SCRIPTS_PATH .. "/?.lua",
    SHADE_SCRIPTS_PATH .. "/luautils/?.lua",
    XDG_DATA_HOME .. "/hypr/lua/?.lua",
    SHADE_CONFIG_HOME .. "/hypr/?.lua",
    SHADE_STATE_HOME .. "/lua_env/share/lua/" .. lua_version .. "/?.lua",
    SHADE_STATE_HOME .. "/lua_env/share/lua/" .. lua_version .. "/?/init.lua"
}
for _, d in ipairs(xdg.dirs.config) do
    if d and d ~= "" then
        table.insert(pkg_paths, d .. "/shade/?.lua")
        table.insert(pkg_paths, d .. "/shade/?/init.lua")
    end
end
package.path = package.path .. ";" .. table.concat(pkg_paths, ";") .. ";"
package.cpath =
    package.cpath ..
    ";" ..
        SHADE_STATE_HOME ..
            "/lua_env/lib/lua/" ..
                lua_version .. "/?.so;" .. SHADE_STATE_HOME .. "/lua_env/lib/lua/" .. lua_version .. "/?/init.so;"
