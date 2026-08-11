-- ForGavin/settings.lua

data:extend({

-- ============================================
-- 启动设置 (startup)
-- ============================================

    -- 建筑师开局
    {
        type = "string-setting",
        name = "builder-start",
        setting_type = "startup",
        default_value = "Not-Enabled",
        allowed_values = {
            "Not-Enabled",
            "Enabled",
            "Enabled-and-Enhance",
            "legendary",
        },
        order = "aaa"
    },

    -- 初始机器人数量
    {
        type = "int-setting",
        name = "starting-robot-count",
        setting_type = "startup",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 2000,
        order = "aab"
    },

    -- 机器人速度倍率
    {
        type = "int-setting",
        name = "faster-robots",
        setting_type = "startup",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 100,
        order = "aaca"
    },

    -- 机器人零能耗
    {
        type = "bool-setting",
        name = "robot-no-energy",
        setting_type = "startup",
        default_value = false,
        order = "aacb"
    },

    -- 初始物品
    {
        type = "string-setting",
        name = "starting-items",
        setting_type = "startup",
        default_value = "Not-Enabled",
        allowed_values = {
            "Not-Enabled",
            "simple",
            "abundant",
        },
        order = "aacc"
    },

    -- 调整背包大小
    {
        type = "int-setting",
        name = "adjustable-backpack-enabled",
        setting_type = "startup",
        default_value = 80,
        minimum_value = 0,
        maximum_value = 5000,
        order = "ab"
    },

    -- 堆叠倍率
    {
        type = "int-setting",
        name = "stack-multiplier",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 100,
        order = "ac"
    },

    -- 手搓革命
    {
        type = "double-setting",
        name = "crafting-revolution",
        setting_type = "startup",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 10000,
        order = "ad"
    },

    -- 扣矿速度
    {
        type = "double-setting",
        name = "player-mining-speed",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 0.1,
        maximum_value = 1000,
        order = "ae"
    },

    -- 移动速度
    {
        type = "double-setting",
        name = "player-run-speed",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 0.1,
        maximum_value = 100,
        order = "af"
    },

    -- 操作距离
    {
        type = "string-setting",
        name = "player-reach-distance",
        setting_type = "startup",
        default_value = "default",
        allowed_values = {"default","10","50","100","1000","10000","100000"},
        order = "ag"
    },

    -- 自由穿梭
    {
        type = "bool-setting",
        name = "free-passage",
        setting_type = "startup",
        default_value = false,
        order = "aga"
    },
    
    -- 自由传送
    {
        type = "bool-setting",
        name = "teleport-mode",
        setting_type = "startup",
        default_value = false,
        order = "agb",
    },

    -- 自定义玩家属性
    {
        type = "bool-setting",
        name = "custom-player-attributes",
        setting_type = "startup",
        default_value = false,
        order = "aha"
    },

    -- 矿机筛选
    {
        type = "bool-setting",
        name = "drill-filter",
        setting_type = "startup",
        default_value = false,
        order = "ahb"
    },

    --超级泵
    {
    type = "string-setting",
    name = "electric-pump-mode",
    setting_type = "startup",
    default_value = "disabled",
    allowed_values = {"disabled", "single", "super"},
    order = "ahe"
    },

    -- 功能优化
    {
        type = "bool-setting",
        name = "functional-enhancements",
        setting_type = "startup",
        default_value = false,
        order = "ahf"
    },

    -- 轨道太阳能发电
    {
        type = "string-setting",
        name = "orbital-solar-power",
        setting_type = "startup",
        default_value = "default",
        allowed_values = {"default","+0.1%","+1%","+5%","+10%","+100%"},
        order = "baaa"
    },

    -- 太阳能发电配置 (生效范围)
    {
        type = "string-setting",
        name = "orbital-solar-scope",
        setting_type = "startup",
        default_value = "current-surface",
        allowed_values = {"current-surface", "all-surfaces"},
        order = "baab"
    },

    -- 蓄电池储能倍率
    {
        type = "int-setting",
        name = "config-accumulator",
        setting_type = "startup",
        default_value = 1,
        minimum_value = 1,
        maximum_value = 10000,
        order = "bab"
    },

    -- 永续箱和永续管
    {
        type = "bool-setting",
        name = "infinity-chest",
        setting_type = "startup",
        default_value = false,
        order = "bb"
    },

    -- 管道最大连接距离
    {
        type = "int-setting",
        name = "max-pipeline-config",
        setting_type = "startup",
        default_value = 320,
        minimum_value = 320,
        maximum_value = 1000000,
        order = "bc"
    },

    -- 调整电线杆范围
    {
        type = "string-setting",
        name = "electric-pole-config",
        setting_type = "startup",
        default_value = "default",
        allowed_values = {"default","1","2","3","4","5"},
        order = "caa"
    },

    -- 机器人平台配置（范围与强化合并）
    {
        type = "string-setting",
        name = "roboport-config",
        setting_type = "startup",
        default_value = "default",
        allowed_values = {
            "default",
            "64",
            "128",
            "enhanced",
            "64-enhanced",
            "128-enhanced",
        },
        order = "cab"
    },

-- ============================================
-- 地图设置 (runtime-global)
-- ============================================


-- ============================================
-- 个性设置 (runtime-per-user)
-- ============================================

    -- 增加背包格数 (个性)
    {
        type = "int-setting",
        name = "p-adjustable-backpack-enabled",
        setting_type = "runtime-per-user",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 2000,
        order = "aaa"
    },

    -- 提高手搓速度 (个性)
    {
        type = "int-setting",
        name = "p-crafting-revolution",
        setting_type = "runtime-per-user",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 10000,
        order = "aab"
    },

    -- 提高扣矿速度 (个性)
    {
        type = "int-setting",
        name = "p-player-mining-speed",
        setting_type = "runtime-per-user",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 1000,
        order = "aac"
    },

    -- 提高移动速度 (个性)
    {
        type = "int-setting",
        name = "p-player-run-speed",
        setting_type = "runtime-per-user",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 100,
        order = "aad"
    },

    -- 自动报告火箭发射统计 (个性)
    {
        type = "bool-setting",
        name = "auto-report-rocket-stats",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "baa"
    },

    -- 自动报告间隔（分钟） (个性)
    {
        type = "int-setting",
        name = "auto-report-rocket-stats-times",
        setting_type = "runtime-per-user",
        default_value = 30,
        minimum_value = 1,
        maximum_value = 300,
        order = "bab"
    }
})

-- ============================================
-- Space Age 专属设置
-- ============================================
if mods["space-age"] then
    data:extend({
        -- 功能强化 (铸造厂/电磁工厂/低温工厂)
        {
            type = "string-setting",
            name = "processing-enhanced",
            setting_type = "startup",
            default_value = "disabled",
            allowed_values = {"disabled", "merge", "full"},
            order = "aia"
        },

        -- 变质时间倍率调整
        {
            type = "double-setting",
            name = "spoil-time-multiplier",
            setting_type = "startup",
            default_value = 1.0,
            minimum_value = 0.1,
            maximum_value = 100.0,
            order = "aja"
        },
    })
end

-- ============================================
-- 品质模组专属设置
-- ============================================
if mods["quality"] then
    data:extend({
        -- 所有配方允许品质
        {
            type = "bool-setting",
            name = "allow-quality-all-recipes",
            setting_type = "startup",
            default_value = false,
            order = "aka"
        },
    })
end