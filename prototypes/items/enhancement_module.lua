-- ForGavin/prototypes/items/enhancement_module.lua
-- 装备模块增强（仅在建筑师开局为“增强”或“传说”模式时生效）

local BuilderStartSetting = settings.startup["builder-start"].value
if BuilderStartSetting == "Enabled-and-Enhance" or BuilderStartSetting == "legendary" then
    local EnergyUtils = require("__ForGavin__/prototypes/Energyunitconversiontool")
    local parse_energy = EnergyUtils.parse_energy
    local format_energy = EnergyUtils.format_energy

    -- ========================
    -- ⚙ 倍率配置
    -- ========================
    local generator_multiplier = 1000          -- 发电机/反应堆功率 ×1000
    local solar_panel_multiplier = 1000        -- 太阳能板功率 ×1000
    local battery_multiplier = 1000            -- 电池容量/充放电功率 ×1000
    local roboport_multiplier = 1000           -- 机器人平台充能功率 ×1000

    local laser_cooldown_divisor = 10          -- 激光射速：冷却时间 ÷10（射速 ×10）
    local laser_range_multiplier = 2           -- 激光射程 ×2
    local laser_buffer_multiplier = 1000       -- 激光内部缓存容量 ×1000

    local shield_multiplier = 100              -- 护盾全属性 ×100（强度、输入、缓存）

    -- ========================
    -- 🔋 发电机/反应堆
    -- ========================
    for _, item in pairs(data.raw["generator-equipment"] or {}) do
        if item.power then
            local base = parse_energy(item.power)
            item.power = format_energy(base * generator_multiplier, "W")
        end
    end

    -- ========================
    -- 🔆 太阳能板
    -- ========================
    for _, item in pairs(data.raw["solar-panel-equipment"] or {}) do
        if item.power then
            local base = parse_energy(item.power)
            item.power = format_energy(base * solar_panel_multiplier, "W")
        end
    end

    -- ========================
    -- 🔋 电池
    -- ========================
    for _, item in pairs(data.raw["battery-equipment"] or {}) do
        local src = item.energy_source
        if src then
            if src.buffer_capacity then
                src.buffer_capacity = format_energy(parse_energy(src.buffer_capacity) * battery_multiplier, "J")
            end
            if src.input_flow_limit then
                src.input_flow_limit = format_energy(parse_energy(src.input_flow_limit) * battery_multiplier, "W")
            end
            if src.output_flow_limit then
                src.output_flow_limit = format_energy(parse_energy(src.output_flow_limit) * battery_multiplier, "W")
            end
        end
    end

    -- ========================
    -- 🤖 机器人平台
    -- ========================
    for _, item in pairs(data.raw["roboport-equipment"] or {}) do
        item.robot_limit = (item.robot_limit or 0) * 2                -- 机器人数量上限翻倍

        -- 范围与充电口数量（直接赋值目标值）
        item.construction_radius = 32                                 -- 建筑范围：默认 20 → 32
        item.charging_station_count = 100                             -- 充电口数量：默认 4 → 100

        if item.charging_energy then
            local base = parse_energy(item.charging_energy)
            item.charging_energy = format_energy(base * roboport_multiplier, "W")
        end

        if item.energy_source then
            if item.energy_source.input_flow_limit then
                local base = parse_energy(item.energy_source.input_flow_limit)
                item.energy_source.input_flow_limit = format_energy(base * roboport_multiplier, "W")
            end
            if item.energy_source.buffer_capacity then
                local base = parse_energy(item.energy_source.buffer_capacity)
                item.energy_source.buffer_capacity = format_energy(base * laser_buffer_multiplier, "J")
            end
        end
    end

    -- ========================
    -- 🔫 激光防御
    -- ========================
    for _, item in pairs(data.raw["active-defense-equipment"] or {}) do
        if item.attack_parameters and item.attack_parameters.ammo_category == "laser" then
            item.attack_parameters.cooldown = (item.attack_parameters.cooldown or 60) / laser_cooldown_divisor
            item.attack_parameters.range = (item.attack_parameters.range or 20) * laser_range_multiplier
        end
        if item.energy_source then
            local src = item.energy_source
            if src.buffer_capacity then
                src.buffer_capacity = format_energy(parse_energy(src.buffer_capacity) * laser_buffer_multiplier, "J")
            end
        end
    end

    -- ========================
    -- 🛡️ 护盾
    -- ========================
    for _, item in pairs(data.raw["energy-shield-equipment"] or {}) do
        if item.max_shield_value then
            item.max_shield_value = item.max_shield_value * shield_multiplier
        end
        if item.energy_source then
            local src = item.energy_source
            if src.input_flow_limit then
                src.input_flow_limit = format_energy(parse_energy(src.input_flow_limit) * shield_multiplier, "W")
            end
            if src.buffer_capacity then
                src.buffer_capacity = format_energy(parse_energy(src.buffer_capacity) * shield_multiplier, "J")
            end
        end
    end
end