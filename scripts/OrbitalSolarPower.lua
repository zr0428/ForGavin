-- ForGavin/scripts/OrbitalSolarPower.lua
-- 轨道太阳能统计与加成模组

-- ========================
-- 常量定义
-- ========================
local BONUS_MAP = {
    ["+0.1%"] = 0.001,
    ["+1%"]   = 0.01,
    ["+5%"]   = 0.05,
    ["+10%"]  = 0.1,
    ["+100%"] = 1.0,
}

local COLORS = {
    title = "[color=#FFD700]",
    label = "[color=#00BFFF]",
    value = "[color=#00FF7F]",
    highlight = "[color=#FF6B6B]",
    dim = "[color=#A0A0A0]",
    end_color = "[/color]",
}

-- ========================
-- 辅助函数
-- ========================
local function GetPlanetDisplayName(surface_name)
    return "[img=space-location/" .. surface_name .. "] " .. surface_name
end

local function get_startup_setting(name)
    local s = settings.startup[name]
    return s and s.value
end

local function init_storage()
    storage.total_rockets = storage.total_rockets or 0
    storage.surface_rocket_counts = storage.surface_rocket_counts or {}
    if not storage.original_solar_multipliers then
        storage.original_solar_multipliers = {}
        for _, s in pairs(game.surfaces) do
            if s.valid then
                storage.original_solar_multipliers[s.name] = s.solar_power_multiplier
            end
        end
    end
end

local function apply_solar_multiplier(surface, increment, scope_setting)
    if not surface or not surface.valid then return end
    local base = storage.original_solar_multipliers[surface.name] or 1.0
    local count = storage.surface_rocket_counts[surface.name] or 0
    local total = storage.total_rockets or 0
    if scope_setting == "current-surface" then
        surface.solar_power_multiplier = base + count * increment
    elseif scope_setting == "all-surfaces" then
        surface.solar_power_multiplier = base + total * increment
    end
end

-- ========================
-- 主要事件函数
-- ========================
function OrbitalSolarPower(event)
    init_storage()
    local setting_value = get_startup_setting("orbital-solar-power")
    local scope_setting = get_startup_setting("orbital-solar-scope")
    local rocket_silo = event.rocket_silo
    if not (rocket_silo and rocket_silo.valid) then return end
    local surface = rocket_silo.surface
    local force = rocket_silo.force
    if not (surface and surface.valid and force and force.valid) then return end

    storage.total_rockets = storage.total_rockets + 1
    local surface_name = surface.name
    storage.surface_rocket_counts[surface_name] = (storage.surface_rocket_counts[surface_name] or 0) + 1

    if setting_value ~= "default" then
        local increment = BONUS_MAP[setting_value]
        if increment then
            if scope_setting == "current-surface" then
                apply_solar_multiplier(surface, increment, "current-surface")
            elseif scope_setting == "all-surfaces" then
                for _, s in pairs(game.surfaces) do
                    apply_solar_multiplier(s, increment, "all-surfaces")
                end
            end
        end
    end
end

function ApplySolarPowerFromHistory()
    local setting_value = get_startup_setting("orbital-solar-power")
    if setting_value == "default" then return end
    local increment = BONUS_MAP[setting_value]
    if not increment then return end
    init_storage()
    local scope_setting = get_startup_setting("orbital-solar-scope")
    for _, s in pairs(game.surfaces) do
        if s.valid then
            apply_solar_multiplier(s, increment, scope_setting)
        end
    end
end

-- ========================
-- 统计信息与命令
-- ========================
local function SendStatsMessage(player, title_prefix)
    storage.total_rockets = storage.total_rockets or 0
    storage.surface_rocket_counts = storage.surface_rocket_counts or {}
    local c = COLORS
    local prefix = title_prefix or ""
    local lines = {}

    lines[#lines + 1] = c.title .. "    ==== " .. prefix .. "轨道太阳能火箭发射统计 ====" .. c.end_color

    local setting_value = get_startup_setting("orbital-solar-power")
    if setting_value ~= "default" then
        local increment = BONUS_MAP[setting_value]
        if increment then
            local percentage = increment * 100
            lines[#lines + 1] = c.label .. "单发加成: " .. c.end_color .. c.value .. "+" .. string.format("%.1f", percentage) .. "%" .. c.end_color
        end
    else
        lines[#lines + 1] = c.label .. "单发加成: " .. c.end_color .. c.dim .. "未启用" .. c.end_color
    end

    lines[#lines + 1] = c.label .. "总发射次数: " .. c.end_color .. c.highlight .. storage.total_rockets .. c.end_color

    local player_surface = player.surface
    if player_surface and player_surface.valid then
        local current_multiplier = player_surface.solar_power_multiplier or 1.0
        local current_bonus = (current_multiplier - 1.0) * 100
        lines[#lines + 1] = c.label .. "当前星球太阳能加成: " .. c.end_color .. c.value .. "+" .. string.format("%.1f", current_bonus) .. "%" .. c.end_color
    end

    lines[#lines + 1] = c.label .. "-- 各星球发射次数与当前加成 --" .. c.end_color

    local has_data = false
    for surface_name, count in pairs(storage.surface_rocket_counts) do
        local display_name = GetPlanetDisplayName(surface_name)
        local surface = game.surfaces[surface_name]
        local multiplier_str = "N/A"
        if surface and surface.valid then
            local mult = surface.solar_power_multiplier or 1.0
            local bonus = (mult - 1.0) * 100
            multiplier_str = "+" .. string.format("%.1f", bonus) .. "%"
        end
        lines[#lines + 1] = "  " .. display_name .. ": " .. c.highlight .. count .. c.end_color .. " 次  加成: " .. c.value .. multiplier_str .. c.end_color
        has_data = true
    end
    if not has_data then
        lines[#lines + 1] = "  " .. c.dim .. "(暂无数据)" .. c.end_color
    end

    lines[#lines + 1] = c.title .. "=============================" .. c.end_color
    player.print(table.concat(lines, "\n"))
end

function RegisterRocketStatsCommand()
    if commands.commands["rocket-stats"] then return end
    commands.add_command("rocket-stats",
        "查看轨道太阳能发射统计：各星球及总计火箭发射数量",
        function(cmd)
            local player = game.players[cmd.player_index]
            if player then SendStatsMessage(player, nil) end
        end
    )
end

-- ========================
-- 自动报告
-- ========================
local CHECK_INTERVAL_TICKS = 60 * 60  -- 1 分钟

local function init_auto_report_storage()
    storage.auto_report_last_time = storage.auto_report_last_time or {}
end

local function AutoReportCheck()
    if #game.connected_players == 0 then return end
    local current_tick = game.tick
    for _, player in pairs(game.connected_players) do
        local player_settings = settings.get_player_settings(player.index)
        if player_settings["auto-report-rocket-stats"].value then
            local interval_minutes = player_settings["auto-report-rocket-stats-times"].value
            local interval_ticks = interval_minutes * 60 * 60
            local last_time = storage.auto_report_last_time[player.index] or 0
            if current_tick - last_time >= interval_ticks then
                SendStatsMessage(player, "[自动报告] ")
                player.print("[color=#A0A0A0]提示: 输入 /rocket-stats 可随时查看统计[/color]")
                storage.auto_report_last_time[player.index] = current_tick
            end
        end
    end
end

function GetAutoReportConfig()
    return {
        check_interval_ticks = CHECK_INTERVAL_TICKS,
        callback = AutoReportCheck,
        init_storage = init_auto_report_storage,
    }
end