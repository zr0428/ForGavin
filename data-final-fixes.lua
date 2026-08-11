-- ForGavin/data-final-fixes.lua
-- 数据最终修正阶段（按类别分组加载）

-- ============================================
-- 实体修改
-- ============================================
require("prototypes.entity.config-accumulator")        -- 蓄电池充放电与容量优化
require("prototypes.entity.drill-filter")              -- 矿机筛选功能
require("prototypes.entity.max-pipeline-config")       -- 管道最大连接距离
require("prototypes.entity.modify-electric-pole")      -- 电线杆范围调整
require("prototypes.entity.modify-roboport")           -- 机器人平台范围调整
require("prototypes.entity.modify-offshore-pump")      -- 抽水泵随地放置

-- ============================================
-- 物品修改
-- ============================================
require("prototypes.items.enhancement_module")         -- 装备模块强化（发电机/太阳能/电池/激光/护盾）
require("prototypes.items.RobotNoEnergy")              -- 机器人零能耗

-- ============================================
-- 配方修改
-- ============================================
require("prototypes.recipe.allow-quality-all-recipes")       -- 所有配方允许品质模块
require("prototypes.recipe.assembling-machine-enhanced")     -- 组装机配方增强

-- ============================================
-- 核心功能
-- ============================================
require("prototypes.CustomPlayerAttributes")          -- 自定义玩家属性
require("prototypes.FreePassage")                     -- 自由穿梭（无碰撞）
require("prototypes.modified-size")                   -- 全局物品堆叠大小调整
require("prototypes.spoil-time")                      -- 变质时间倍率调整

-- ============================================
-- 隐藏科技
-- ============================================
require("prototypes.technology.crafting-revolution")  -- 手搓革命
require("prototypes.technology.faster-robots")        -- 机器人速度加成
require("prototypes.technology.Enabled-and-Enhance")  -- 激光伤害加成
require("prototypes.teleport")                      --传送工具
require("prototypes.functional-enhancements")       --功能优化

