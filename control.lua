-- ForGavin/control.lua
-- 顶部 require
-- 隐藏科技
require("scripts.FasterRobots")            -- 机器人速度加成
require("scripts.CraftingRevolution")      -- 手搓革命
require("scripts.EnabledandEnhance")       -- 激光伤害加成

-- 开局物品
require("scripts.BuilderStart")            -- 开局装备发放
require("scripts.InfinityChest")           -- 无限箱子
require("scripts.StartingItems")           -- 开局物品

-- 功能性
require("scripts.OrbitalSolarPower")       -- 轨道太阳能统计与火箭报告
require("scripts.PCustomPlayerAttributes") -- 自定义玩家属性（个性设置）
require("scripts.TeleportTool")            -- 自由传送工具

-- 注册命令
RegisterRocketStatsCommand()

-- 获取自动报告配置
local AutoReportConfig = GetAutoReportConfig()

-- 统一初始化 storage
local function init_storage()
    storage = storage or {}
    storage.shared_rocket_count = storage.shared_rocket_count or {}
    storage.total_rockets = storage.total_rockets or 0
    storage.surface_rocket_counts = storage.surface_rocket_counts or {}
    if AutoReportConfig.init_storage then
        AutoReportConfig.init_storage()
    end
end

-- 注册自动报告定时器
local function register_auto_report()
    script.on_nth_tick(AutoReportConfig.check_interval_ticks, AutoReportConfig.callback)
end

-- ============================================
-- 三个隐藏科技应用函数集中调用
-- ============================================
local function ApplyAllTechnologies()
    ApplyCraftingRevolution()
    ApplyRobotSpeedBonus()
    ApplyLaserDamageBonus()
end

-- 新游戏初始化
script.on_init(function()
    init_storage()
    ApplyAllTechnologies()
    register_auto_report()
    ApplySolarPowerFromHistory()
end)

-- 加载存档时重新绑定事件
script.on_load(function()
    register_auto_report()
end)

-- 模组配置变更（版本更新、设置改动）
script.on_configuration_changed(function()
    init_storage()
    ApplyAllTechnologies()
    register_auto_report()
    ApplySolarPowerFromHistory()
end)

-- 火箭发射事件
script.on_event(defines.events.on_rocket_launched, OrbitalSolarPower)

-- 玩家创建 / 跳过开场动画
script.on_event(defines.events.on_player_created, function(event)
    BuilderStart(event)
    InfinityChest(event)
    StartingItems(event)
end)

script.on_event(defines.events.on_cutscene_cancelled, function(event)
    BuilderStart(event)
    InfinityChest(event)
    StartingItems(event)
end)

-- 运行时设置变更（个性设置）
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
    PCustomPlayerAttributes(event)
end)

-- 玩家重生
script.on_event(defines.events.on_player_respawned, function(event)
    PCustomPlayerAttributes(event)
end)

-- 科技变化时（保留空函数）
script.on_event(defines.events.on_research_finished, function(event)
    -- 无需操作
end)

-- ============================================
-- 传送功能
-- ============================================
-- 键盘快捷键
script.on_event("teleport-tool", OnTeleportToolActivated)

-- 快捷栏按钮
script.on_event(defines.events.on_lua_shortcut, function(event)
    if event.prototype_name == "teleport-shortcut" then
        OnTeleportToolActivated(event)
    end
end)

-- 蓝图放置（传送触发）
script.on_event(defines.events.on_built_entity, OnTeleportBlueprintPlaced)

-- 每 tick 传送队列处理
script.on_event(defines.events.on_tick, OnTickTeleport)

-- 玩家离开时清理
script.on_event(defines.events.on_player_left_game, OnTeleportPlayerLeft)