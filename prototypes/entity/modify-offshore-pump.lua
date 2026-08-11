-- ForGavin/prototypes/entity/modify-offshore-pump.lua
-- 随地泵：仅修改已有原型，不创建平行物品或运行时事件。

local setting = settings.startup["electric-pump-mode"]
local mode = setting and setting.value or "disabled"

if mode == "disabled" then
    return
end

local function enable_anywhere(pump)
    pump.tile_buildability_rules = nil
end

if mode == "single" then
    local pump = data.raw["offshore-pump"] and data.raw["offshore-pump"]["offshore-pump"]
    if pump then
        enable_anywhere(pump)
    end
elseif mode == "super" then
    for _, pump in pairs(data.raw["offshore-pump"] or {}) do
        enable_anywhere(pump)
        pump.pumping_speed = (pump.pumping_speed or 20) * 10
    end
end

-- 抽取泵从 fluid_source_offset 指向的地块读取 fluid。给普通陆地设置
-- 默认水源后，移除建造规则的抽取泵才会在陆地上实际产水。
local lava_tiles = {
    ["lava"] = true,
    ["lava-hot"] = true,
    ["volcanic-cracks"] = true,
    ["volcanic-cracks-hot"] = true,
    ["volcanic-cracks-warm"] = true,
    ["volcanic-smooth-stone"] = true,
    ["volcanic-smooth-stone-warm"] = true,
}
local has_lava = data.raw.fluid and data.raw.fluid.lava

for _, tile in pairs(data.raw.tile or {}) do
    if not tile.fluid then
        local is_lava_tile = lava_tiles[tile.name] or string.find(tile.name, "^volcanic-")
        tile.fluid = has_lava and is_lava_tile and "lava" or "water"
    end
end
