-- ForGavin/scripts/BuilderStart.lua
-- 开局装备与模组兼容性发放

function BuilderStart(event)
    -- 辅助函数
    local function is_mod_enabled(mod_name) return script.active_mods[mod_name] ~= nil end
    local function item_exists(item_name) return prototypes.item[item_name] ~= nil end

    -- 检查启动设置
    local BuilderStartSetting = settings.startup["builder-start"].value
    if BuilderStartSetting ~= "Enabled" and BuilderStartSetting ~= "Enabled-and-Enhance" and BuilderStartSetting ~= "legendary" then
        return
    end

    -- 初始机器人数量与装备参数
    local startingRobotCount = settings.startup["starting-robot-count"].value
    local RobotMK2limit = 25
    local exoskeletoncount = 3
    local shieldcount = 10
    local lasercount = 20

    -- 默认装备（可被模组覆盖）
    local Armor = "power-armor-mk2"
    local Robot = "construction-robot"
    local Reactor = "fission-reactor-equipment"
    local Roboport = "personal-roboport-mk2-equipment"
    local Battery = "battery-mk2-equipment"
    local Exoskeleton = "exoskeleton-equipment"
    local NightVisionDevice = "night-vision-equipment"
    local BeltImmunity = "belt-immunity-equipment"
    local Panel = "solar-panel-equipment"
    local Laser = "personal-laser-defense-equipment"
    local Shield = "energy-shield-mk2-equipment"
    local Car = "car"
    local Spidertron = "spidertron"

    local NewItems = {}

    -- =============================================
    -- Space Age 兼容
    -- =============================================
    if is_mod_enabled("space-age") then
        if item_exists("mech-armor") then Armor = "mech-armor" end
        if item_exists("battery-mk3-equipment") then Battery = "battery-mk3-equipment" end
        if item_exists("fusion-reactor-equipment") then Reactor = "fusion-reactor-equipment" end
        if item_exists("toolbelt-equipment") then table.insert(NewItems, {"toolbelt-equipment", 10}) end
    end

    -- =============================================
    -- 增强/传奇模式倍率调整
    -- =============================================
    if BuilderStartSetting == "Enabled-and-Enhance" or BuilderStartSetting == "legendary" then
        RobotMK2limit = RobotMK2limit * 2
    end
    if is_mod_enabled("quality") and BuilderStartSetting == "legendary" then
        RobotMK2limit = math.floor(RobotMK2limit * 2.5)
    end
    local RoboportCount = math.ceil(startingRobotCount / RobotMK2limit)

    -- =============================================
    -- Space Exploration 兼容
    -- =============================================
    local function apply_se_equipment()
        if item_exists("se-thruster-suit-4") then Armor = "se-thruster-suit-4" end
        if item_exists("se-antimatter-reactor-equipment") then Reactor = "se-antimatter-reactor-equipment" end
        if item_exists("energy-shield-mk6-equipment") then Shield = "energy-shield-mk6-equipment" end
        if item_exists("se-adaptive-armour-equipment-5") then table.insert(NewItems, {"se-adaptive-armour-equipment-5", 10}) end
        if item_exists("jetpack-4") then table.insert(NewItems, {"jetpack-4", 10}) end
        if item_exists("se-lifesupport-equipment-4") then table.insert(NewItems, {"se-lifesupport-equipment-4", 10}) end
    end

    -- 仅 SE（无 K2）
    if is_mod_enabled("space-exploration") and not is_mod_enabled("Krastorio2") then
        apply_se_equipment()
    end

    -- =============================================
    -- Krastorio 2 兼容
    -- =============================================
    if is_mod_enabled("Krastorio2") then
        if is_mod_enabled("space-exploration") then
            -- K2 + SE
            apply_se_equipment()
            if item_exists("kr-power-armor-mk4") then table.insert(NewItems, {"kr-power-armor-mk4", 1}) end
            if item_exists("kr-dt-fuel-cell") then table.insert(NewItems, {"kr-dt-fuel-cell", 50}) end
        else
            -- 仅 K2
            if item_exists("kr-power-armor-mk4") then Armor = "kr-power-armor-mk4" end
            if item_exists("kr-antimatter-reactor-equipment") and item_exists("uranium-fuel-cell") then
                Reactor = "kr-antimatter-reactor-equipment"
                table.insert(NewItems, {"kr-charged-antimatter-fuel-cell", 50})
            end
            if item_exists("kr-dt-fuel-cell") then table.insert(NewItems, {"kr-dt-fuel-cell", 50}) end
        end

        -- K2 通用覆盖
        if item_exists("kr-big-battery-mk3-equipment") then Battery = "kr-big-battery-mk3-equipment" end
        if item_exists("kr-superior-solar-panel-equipment") then Panel = "kr-superior-solar-panel-equipment" end
        if item_exists("kr-superior-exoskeleton-equipment") then Exoskeleton = "kr-superior-exoskeleton-equipment" end
        if item_exists("kr-personal-laser-defense-mk4-equipment") then Laser = "kr-personal-laser-defense-mk4-equipment" end
        if item_exists("kr-energy-shield-mk4-equipment") then Shield = "kr-energy-shield-mk4-equipment" end
    end

    -- =============================================
    -- Ultracube 兼容
    -- =============================================
    if is_mod_enabled("Ultracube") then
        if item_exists("cube-power-armor-mk2") then Armor = "cube-power-armor-mk2" end
        if item_exists("cube-solar-panel-equipment") then Panel = "cube-solar-panel-equipment" end
        if item_exists("cube-exoskeleton-equipment-mk2") then Exoskeleton = "cube-exoskeleton-equipment-mk2" end
        shieldcount = 0
        lasercount = 0
    end

    -- =============================================
    -- PyIndustry 兼容
    -- =============================================
    if is_mod_enabled("pyindustry") then
        local robot_priority = {
            "py-construction-robot-mk04",
            "py-construction-robot-mk03",
            "py-construction-robot-mk02",
            "py-construction-robot-mk01"
        }
        local function select_optimal_robot()
            for _, robot_name in ipairs(robot_priority) do
                if item_exists(robot_name) then
                    Robot = robot_name
                    return
                end
            end
        end
        local battery_priority = {
            "quantum-battery",
            "biobattery",
            "nexelit-battery",
            "battery-mk01"
        }
        local function select_optimal_battery()
            for _, battery_name in ipairs(battery_priority) do
                if item_exists(battery_name) then
                    Battery = battery_name
                    return
                end
            end
        end
        select_optimal_robot()
        select_optimal_battery()
        if item_exists("portable-gasoline-generator") then table.insert(NewItems, {"portable-gasoline-generator", 6}) end
        if item_exists("personal-fusion-cell") then table.insert(NewItems, {"personal-fusion-cell", 100}) end
        if is_mod_enabled("pyalternativeenergy") then exoskeletoncount = 2 end
    end

    -- =============================================
    -- Nullius 兼容
    -- =============================================
    if is_mod_enabled("nullius") then
        if item_exists("nullius-chassis-6") then Armor = "nullius-chassis-6" end
        if item_exists("nullius-portable-reactor") then
            Reactor = "nullius-portable-reactor"
            if item_exists("nullius-fission-cell") then table.insert(NewItems, {"nullius-fission-cell", 100}) end
        end
        if item_exists("nullius-battery-3") then Battery = "nullius-battery-3" end
        if item_exists("nullius-construction-bot-4") then Robot = "nullius-construction-bot-4" end
        if item_exists("nullius-hangar-4") then
            Roboport = "nullius-hangar-4"
            RobotMK2limit = 50
        end
        if item_exists("nullius-leg-augmentation-4") then Exoskeleton = "nullius-leg-augmentation-4" end
        if item_exists("nullius-night-vision-3") then NightVisionDevice = "nullius-night-vision-3" end
        if item_exists("nullius-levitation-field-2") then BeltImmunity = "nullius-levitation-field-2" end
        if item_exists("nullius-solar-panel-4") then Panel = "nullius-solar-panel-4" end
        if item_exists("nullius-shield") then Shield = "nullius-shield" end
        lasercount = 0
        if item_exists("nullius-car-3") then Car = "nullius-car-3" end
        if item_exists("nullius-mecha-2") then Spidertron = "nullius-mecha-2" end
        if item_exists("nullius-large-cargo-pod-3") then table.insert(NewItems, {"nullius-large-cargo-pod-3", 10}) end
        if item_exists("nullius-telekinesis-field-3") then table.insert(NewItems, {"nullius-telekinesis-field-3", 10}) end
        if item_exists("nullius-refueler") then table.insert(NewItems, {"nullius-refueler", 1}) end
        if item_exists("nullius-multi-tool-3") then table.insert(NewItems, {"nullius-multi-tool-3", 10}) end
        if item_exists("nullius-rock-picker") then table.insert(NewItems, {"nullius-rock-picker", 1}) end
    end

    -- =============================================
    -- 核能机器人兼容
    -- =============================================
    if is_mod_enabled("NuclearRobot") or is_mod_enabled("BuggisNuclearBots") or is_mod_enabled("NuclearRobots_Reboot") then
        if item_exists("construction-robot-nuclear") then Robot = "construction-robot-nuclear" end
    end

    -- =============================================
    -- 构建物品清单
    -- =============================================
    local ItemPrototypes = {
        Armor = Armor,
        Robot = Robot,
        Reactor = Reactor,
        Roboport = Roboport,
        Battery = Battery,
        Exoskeleton = Exoskeleton,
        NightVisionDevice = NightVisionDevice,
        BeltImmunity = BeltImmunity,
        Panel = Panel,
        Laser = Laser,
        Shield = Shield,
        Car = Car,
        Spidertron = Spidertron
    }

    local Items = {
        {ItemPrototypes["Robot"], startingRobotCount},
        {ItemPrototypes["Laser"], lasercount},
        {ItemPrototypes["Shield"], shieldcount},
        {ItemPrototypes["Reactor"], 4},
        {ItemPrototypes["Roboport"], 10},
        {ItemPrototypes["Battery"], 10},
        {ItemPrototypes["Exoskeleton"], 10},
        {ItemPrototypes["Panel"], 40},
        {ItemPrototypes["Car"], 1},
        {ItemPrototypes["Spidertron"], 1},
    }

    -- 额外物品优先放入
    if #NewItems > 0 then
        local combined = {}
        for _, pair in ipairs(NewItems) do table.insert(combined, pair) end
        for _, pair in ipairs(Items) do table.insert(combined, pair) end
        Items = combined
    end

    -- 装甲模块
    local ArmorModules = {
        {ItemPrototypes["Reactor"], 1},
        {ItemPrototypes["Roboport"], RoboportCount},
        {ItemPrototypes["Battery"], 6},
        {ItemPrototypes["Exoskeleton"], exoskeletoncount},
        {ItemPrototypes["NightVisionDevice"], 1},
        {ItemPrototypes["BeltImmunity"], 1},
        {ItemPrototypes["Panel"], 40},
    }

    -- planet-picker 模组：模块也放入背包
    if is_mod_enabled("planet-picker") and #ArmorModules > 0 then
        local combined = {}
        for _, pair in ipairs(Items) do table.insert(combined, pair) end
        for _, pair in ipairs(ArmorModules) do table.insert(combined, pair) end
        Items = combined
    end

    -- =============================================
    -- 发放物品与装备
    -- =============================================
    local Player = game.players[event.player_index]
    local ArmorInventory = Player.get_inventory(defines.inventory.character_armor)
    if ArmorInventory == nil then return end

    local function safe_insert(name, count)
        if count <= 0 then return end
        if is_mod_enabled("quality") and BuilderStartSetting == "legendary" then
            local inserted = Player.insert{name = name, count = count, quality = "legendary"}
            if inserted < count then
                Player.insert{name = name, count = count - inserted}
            end
        else
            Player.insert{name = name, count = count}
        end
    end

    for _, v in ipairs(Items) do
        safe_insert(v[1], v[2])
    end

    if not ArmorInventory.is_empty() then
        ArmorInventory.clear()
    end

    local armor_name = ItemPrototypes["Armor"]
    local armor_inserted
    if is_mod_enabled("quality") and BuilderStartSetting == "legendary" then
        armor_inserted = ArmorInventory.insert{name = armor_name, count = 1, quality = "legendary"}
    else
        armor_inserted = ArmorInventory.insert{name = armor_name, count = 1}
    end

    if armor_inserted > 0 then
        local grid = ArmorInventory[1].grid
        for _, module in ipairs(ArmorModules) do
            for _ = 1, module[2] do
                if is_mod_enabled("quality") and BuilderStartSetting == "legendary" then
                    grid.put({name = module[1], quality = "legendary"})
                else
                    grid.put({name = module[1]})
                end
            end
        end
    end

    -- =============================================
    -- 补漏：确保 K2+SE 下 kr-power-armor-mk4 在背包中
    -- =============================================
    if is_mod_enabled("Krastorio2") and is_mod_enabled("space-exploration") then
        local target = "kr-power-armor-mk4"
        if item_exists(target) then
            local main_inv = Player.get_inventory(defines.inventory.character_main)
            local found = false
            if main_inv then
                for _, item in ipairs(main_inv.get_contents()) do
                    if item.name == target then
                        found = true
                        break
                    end
                end
            end
            if not found then
                if is_mod_enabled("quality") and BuilderStartSetting == "legendary" then
                    local n = Player.insert{name = target, count = 1, quality = "legendary"}
                    if n == 0 then
                        Player.insert{name = target, count = 1}
                    end
                else
                    Player.insert{name = target, count = 1}
                end
            end
        end
    end
end