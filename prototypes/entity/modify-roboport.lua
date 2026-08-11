-- ForGavin/prototypes/entity/modify-roboport.lua
-- 功能：根据设置调整机器人平台的范围和增强参数
-- 范围仅修改原版 roboport；增强应用于所有 roboport

local EnergyUtils = require("__ForGavin__/prototypes/Energyunitconversiontool")
local parse_energy = EnergyUtils.parse_energy
local format_energy = EnergyUtils.format_energy

local config = settings.startup["roboport-config"].value

-- 配置映射
local range_by_config = {
    ["64"] = 64,
    ["64-enhanced"] = 64,
    ["128"] = 128,
    ["128-enhanced"] = 128,
}
local enhanced_configs = {
    ["enhanced"] = true,
    ["64-enhanced"] = true,
    ["128-enhanced"] = true,
}

local range = range_by_config[config]
local enhanced = enhanced_configs[config] or false

-- ===== 倍率常量 =====
local STATION_COUNT_MULTIPLIER = 10    -- 充电口数量
local CHARGING_ENERGY_MULTIPLIER = 100 -- 每个机器人充电消耗能量
local BUFFER_CAPACITY_MULTIPLIER = 100 -- 内部电池容量
local POWER_FLOW_MULTIPLIER = 10       -- 输入/输出功率上限

-- 如果既没有范围也没有增强，直接返回
if not range and not enhanced then
    return
end

-- ============================================
-- 充电口偏移生成（环形排布）
-- 2.x 固定机器人平台没有 charging_station_count 字段，
-- 充电口数量由 charging_offsets 数组长度决定，因此必须生成更多偏移。
-- ============================================
local function round1(value)
    return math.floor(value * 10 + 0.5) / 10
end

local function build_charging_offsets(count)
    if count <= 4 then
        return {{-1.5, -1}, {1.5, -1}, {1.5, 1}, {-1.5, 1}}
    end
    local offsets = {}
    local remaining = count
    local ring = 1
    while remaining > 0 do
        local radius = 1.6 + (ring - 1) * 1.2
        local ring_count = math.min(remaining, 8 * ring)
        for i = 1, ring_count do
            local angle = (i - 0.5) * 2 * math.pi / ring_count
            table.insert(offsets, {round1(radius * math.cos(angle)), round1(radius * math.sin(angle))})
        end
        remaining = remaining - ring_count
        ring = ring + 1
    end
    return offsets
end

-- ============================================
-- 1. 修改原版 roboport 的范围（仅原版）
-- ============================================
if range then
    local roboport = data.raw["roboport"] and data.raw["roboport"]["roboport"]
    if roboport then
        roboport.logistics_radius = range / 2
        roboport.construction_radius = range + 6
    end
end

-- ============================================
-- 2. 增强所有 roboport（包括模组添加的）
-- ============================================
if enhanced then
    for _, roboport in pairs(data.raw["roboport"] or {}) do
        -- 2.1 充电口数量（修复 2.x 固定平台 charging_station_count 不生效问题）
        if roboport.charging_offsets and #roboport.charging_offsets > 0 then
            -- 固定机器人平台：2.x 版本没有 charging_station_count 字段，
            -- 充电口数量由 charging_offsets 数组长度决定，直接生成更多充电口偏移。
            roboport.charging_offsets = build_charging_offsets(#roboport.charging_offsets * STATION_COUNT_MULTIPLIER)
        elseif roboport.charging_station_count then
            -- 装备型机器人平台：保留 charging_station_count 字段逻辑
            roboport.charging_station_count = math.floor(roboport.charging_station_count * STATION_COUNT_MULTIPLIER)
            -- 关键修复：禁用品质影响，确保修改生效
            roboport.charging_station_count_affected_by_quality = false
        end

        -- 2.2 充电能量（顶层字段）
        if roboport.charging_energy then
            roboport.charging_energy = format_energy(
                parse_energy(roboport.charging_energy) * CHARGING_ENERGY_MULTIPLIER,
                "W"
            )
        end

        -- 2.3 能量源属性
        local energy_source = roboport.energy_source
        if energy_source then
            if energy_source.buffer_capacity then
                energy_source.buffer_capacity = format_energy(
                    parse_energy(energy_source.buffer_capacity) * BUFFER_CAPACITY_MULTIPLIER,
                    "J"
                )
            end
            if energy_source.input_flow_limit then
                energy_source.input_flow_limit = format_energy(
                    parse_energy(energy_source.input_flow_limit) * POWER_FLOW_MULTIPLIER / 5,
                    "W"
                )
            end
            if energy_source.output_flow_limit then
                energy_source.output_flow_limit = format_energy(
                    parse_energy(energy_source.output_flow_limit) * POWER_FLOW_MULTIPLIER,
                    "W"
                )
            end
        end
    end
end
