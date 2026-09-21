local M = {}

local function get_multiplier()
    local multiplier = shade.meta.get("animation_duration_scale")
    if multiplier == nil then
        multiplier = shade.meta.get("animation.duration_scale")
    end

    multiplier = tonumber(multiplier) or 1
    if multiplier <= 0 then
        multiplier = 1
    end

    return multiplier
end

function M.set_duration_scale(value)
    local v = tonumber(value)
    if v and v > 0 then
        return shade.meta.set("animation_duration_scale", v)
    end
    return nil
end

function M.get_duration_scale()
    return get_multiplier()
end

function M.speed()
    local multiplier = get_multiplier()
    return function(speed)
        local s = tonumber(speed)
        return s and s * multiplier or speed
    end
end

function M.animation(opts)
    if type(opts) == "table" and opts.speed ~= nil then
        local speed = tonumber(opts.speed)
        if speed then
            opts.speed = speed * get_multiplier()
        end
    end
    return hl.animation(opts)
end

function M.curve(name, opts)
    return hl.curve(name, opts)
end

_G.shade = _G.shade or {}
_G.shade.animations = M
_G.shade.anim = M

return M
