-- ForGavin/prototypes/functional-enhancements.lua
-- 功能优化集合（雷达禁用、视距放大、矿机强化）

if settings.startup["functional-enhancements"].value then

    -- 1. 禁用雷达扫描图层
    for _, radar in pairs(data.raw.radar or {}) do
        radar.max_distance_of_sector_revealed = 0        -- 禁用远程扫描
        --radar.max_distance_of_nearby_sector_revealed = 0 -- 禁用近距离持续扫描
    end

    -- -- 2. 视距上限提升 1.5 倍（影响新创建的世界）
    -- local map_settings = data.raw["map-settings"]["map-settings"]
    -- if map_settings and map_settings.max_zoom then
    --     map_settings.max_zoom = map_settings.max_zoom * 1.5
    -- end

    -- 3. 所有矿机固有速度与产能 +100%
    for _, drill in pairs(data.raw["mining-drill"] or {}) do
        -- 基础速度翻倍
        drill.mining_speed = (drill.mining_speed or 1) * 2

        -- 固有产能增加 100%（即 +1.0，使得总产能为 200%）
        if not drill.effect_receiver then
            drill.effect_receiver = {}
        end
        if not drill.effect_receiver.base_effect then
            drill.effect_receiver.base_effect = {}
        end
        local base = drill.effect_receiver.base_effect.productivity or 0
        drill.effect_receiver.base_effect.productivity = base + 1.0
    end

    -- 4. 广域电线杆发光（白光，自定义）
    -- 广域定义：拉线距离 >= 16 或供电距离 >= 9（覆盖中型以上电线杆与变电站，以及所有模组广域电线杆）
    -- 先加载电线杆修改模块（确保数据已准备好）
    require("prototypes.entity.modify-electric-pole")

    for _, pole in pairs(data.raw["electric-pole"] or {}) do
        local wire = pole.maximum_wire_distance or 0
        local supply = pole.supply_area_distance or 0
        if wire >= 16 or supply >= 9 then
            pole.light = {
                intensity = 0.9,
                size = math.max(40, supply * 4),  -- 最小40，最大为供电半径*4
                color = {r = 1, g = 1, b = 1},
                shift = {0, -0.8},
            }
        end
    end
end
