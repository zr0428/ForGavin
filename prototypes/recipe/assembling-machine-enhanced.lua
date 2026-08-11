-- ForGavin/prototypes/recipe/assembling-machine-enhanced.lua
-- 太空时代特产机器配方增强（铸造厂/电磁工厂/低温工厂）

-- 合并两个机器的制造类别
local function merge_crafting_categories(from_machine, to_machine)
    local from = data.raw["assembling-machine"][from_machine]
              or data.raw["furnace"][from_machine]
    local to   = data.raw["assembling-machine"][to_machine]
              or data.raw["furnace"][to_machine]
    if not (from and to and from.crafting_categories) then return end

    to.crafting_categories = to.crafting_categories or {}
    local existing = {}
    for _, cat in ipairs(to.crafting_categories) do
        existing[cat] = true
    end
    for _, cat in ipairs(from.crafting_categories) do
        if not existing[cat] then
            table.insert(to.crafting_categories, cat)
        end
    end
end

-- 仅在 Space Age 启用时执行增强
if mods["space-age"] then

    -- 获取配方第一个物品类产出
    local function first_item_product(recipe)
        if not recipe or not recipe.results then return nil end
        for _, result in ipairs(recipe.results) do
            if result.type == "item" then return result.name end
        end
        return nil
    end

    -- 判断配方是否属于指定类别
    local function has_category(recipe, cat)
        if not recipe.categories then return false end
        for _, c in ipairs(recipe.categories) do
            if c == cat then return true end
        end
        return false
    end

    -- 收集所有铸造厂配方，按产出物品建立映射
    local casting_by_product = {}
    for _, recipe in pairs(data.raw.recipe) do
        if has_category(recipe, "metallurgy") then
            local product = first_item_product(recipe)
            if product and not casting_by_product[product] then
                casting_by_product[product] = recipe
            end
        end
    end

    -- 修复铸造厂信号选择配方顺序：让铸造配方排在冶炼配方之前
    for _, recipe in pairs(data.raw.recipe) do
        if has_category(recipe, "smelting") then
            local product = first_item_product(recipe)
            local casting = product and casting_by_product[product]
            local item    = product and data.raw.item[product]
            if casting and item then
                casting.subgroup = item.subgroup
                casting.order    = "a[casting]-a[" .. product .. "]"
            end
        end
    end

    -- 获取设置模式（disabled / merge / full）
    local mode = settings.startup["processing-enhanced"].value

    -- 给配方追加制造类别（避免重复添加）
    local function add_recipe_category(recipe_name, new_category)
        local recipe = data.raw.recipe[recipe_name]
        if not recipe then return end
        if not recipe.categories then recipe.categories = {"crafting"} end
        for _, cat in ipairs(recipe.categories) do
            if cat == new_category then return end
        end
        table.insert(recipe.categories, new_category)
    end

    -- 铸造厂新增浇筑配方列表（仅在 full 模式生效）
    local foundry_recipes = {
        -- 标准弹匣
        {
            type = "recipe", name = "foundry-firearm-magazine", categories = {"metallurgy"},
            enabled = false, energy_required = 1,
            ingredients = {{type="fluid", name="molten-iron", amount=40}},
            results = {{type="item", name="firearm-magazine", amount=1}},
            order = "a[casting]-a[basic-clips]-a[firearm-magazine]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-firearm-magazine.png", icon_size = 64 }
            },
        },
        -- 穿甲弹匣
        {
            type = "recipe", name = "foundry-piercing-rounds-magazine", categories = {"metallurgy"},
            enabled = false, energy_required = 6,
            ingredients = {
                {type="item", name="firearm-magazine", amount=2},
                {type="fluid", name="molten-iron", amount=30},
                {type="fluid", name="molten-copper", amount=20}
            },
            results = {{type="item", name="piercing-rounds-magazine", amount=1}},
            order = "a[casting]-a[basic-clips]-b[piercing-rounds-magazine]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-piercing-rounds-magazine.png", icon_size = 64 }
            },
        },
        -- 霰弹
        {
            type = "recipe", name = "foundry-shotgun-shell", categories = {"metallurgy"},
            enabled = false, energy_required = 3,
            ingredients = {
                {type="fluid", name="molten-iron", amount=20},
                {type="fluid", name="molten-copper", amount=20}
            },
            results = {{type="item", name="shotgun-shell", amount=1}},
            order = "a[casting]-b[shotgun]-a[basic]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-shotgun-shell.png", icon_size = 64 }
            },
        },
        -- 穿甲霰弹
        {
            type = "recipe", name = "foundry-piercing-shotgun-shell", categories = {"metallurgy"},
            enabled = false, energy_required = 8,
            ingredients = {
                {type="item", name="shotgun-shell", amount=2},
                {type="fluid", name="molten-iron", amount=30},
                {type="fluid", name="molten-copper", amount=20}
            },
            results = {{type="item", name="piercing-shotgun-shell", amount=1}},
            order = "a[casting]-b[shotgun]-b[piercing]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-piercing-shotgun-shell.png", icon_size = 64 }
            },
        },
        -- 内燃机（支持产能插件）
        {
            type = "recipe", name = "foundry-engine-unit", categories = {"metallurgy"},
            enabled = false, energy_required = 10,
            subgroup = "vulcanus-processes",
            ingredients = {
                {type="item", name="pipe", amount=1},
                {type="fluid", name="molten-iron", amount=40}
            },
            results = {{type="item", name="engine-unit", amount=1}},
            order = "b[casting]-e[engine-unit]", allow_productivity = true,
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-engine-unit.png", icon_size = 64 }
            },
        },
        -- 铁箱
        {
            type = "recipe", name = "foundry-iron-chest", categories = {"metallurgy"},
            enabled = false, energy_required = 0.5,
            ingredients = {{type="fluid", name="molten-iron", amount=80}},
            results = {{type="item", name="iron-chest", amount=1}},
            order = "a[casting]-a[items]-b[iron-chest]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-iron-chest.png", icon_size = 64 }
            },
        },
        -- 钢箱
        {
            type = "recipe", name = "foundry-steel-chest", categories = {"metallurgy"},
            enabled = false, energy_required = 0.5,
            ingredients = {{type="fluid", name="molten-iron", amount=240}},
            results = {{type="item", name="steel-chest", amount=1}},
            order = "a[casting]-a[items]-c[steel-chest]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-steel-chest.png", icon_size = 64 }
            },
        },
        -- 储液罐（加4铁管）
        {
            type = "recipe", name = "foundry-storage-tank", categories = {"metallurgy"},
            enabled = false, energy_required = 3,
            ingredients = {
                {type="item", name="pipe", amount=4},
                {type="fluid", name="molten-iron", amount=350}
            },
            results = {{type="item", name="storage-tank", amount=1}},
            order = "a[casting]-b[fluid]-a[storage-tank]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-storage-tank.png", icon_size = 64 }
            },
        },
        -- 铁路
        {
            type = "recipe", name = "foundry-rail", categories = {"metallurgy"},
            enabled = false, energy_required = 0.5,
            ingredients = {
                {type="fluid", name="molten-iron", amount=35},
                {type="item", name="stone", amount=1}
            },
            results = {{type="item", name="rail", amount=1}},
            order = "a[casting]-a[rail]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-rail.png", icon_size = 64 }
            },
        },
        -- 钢筋混凝土
        {
            type = "recipe", name = "foundry-refined-concrete", categories = {"metallurgy"},
            enabled = false, energy_required = 15,
            group = "intermediate-products",
            ingredients = {
                {type="fluid", name="molten-iron", amount=70},
                {type="fluid", name="water", amount=100},
                {type="item", name="concrete", amount=20}
            },
            results = {{type="item", name="refined-concrete", amount=10}},
            order = "b[casting]-g[concrete]-c[refined]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-refined-concrete.png", icon_size = 64 }
            },
        },
        -- 太空平台基座
        {
            type = "recipe", name = "foundry-space-platform-foundation", categories = {"metallurgy"},
            enabled = false, energy_required = 10,
            ingredients = {
                {type="fluid", name="molten-iron", amount=600},
                {type="fluid", name="molten-copper", amount=50}
            },
            results = {{type="item", name="space-platform-foundation", amount=1}},
            order = "a[casting]-a[space-platform-foundation]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-space-platform-foundation.png", icon_size = 64 }
            },
        },
        -- 空桶
        {
            type = "recipe", name = "foundry-barrel", categories = {"metallurgy"},
            enabled = false, energy_required = 1,
            subgroup = "vulcanus-processes",
            ingredients = {{type="fluid", name="molten-iron", amount=30}},
            results = {{type="item", name="barrel", amount=1}},
            order = "b[casting]-e[barrel]",
            icons = {
                { icon = "__ForGavin__/graphics/icons/foundry-barrel.png", icon_size = 64 }
            },
        },
    }

    -- 根据设置模式执行相应增强
    if mode == "merge" or mode == "full" then
        -- 合并制造类别
        merge_crafting_categories("electric-furnace", "foundry")
        merge_crafting_categories("centrifuge",       "electromagnetic-plant")
        merge_crafting_categories("oil-refinery",     "cryogenic-plant")
        merge_crafting_categories("chemical-plant",   "cryogenic-plant")

        -- 电路网络子组 → 电磁工厂
        for item_name, item in pairs(data.raw.item) do
            if item.subgroup == "circuit-network" then
                add_recipe_category(item_name, "electromagnetics")
            end
        end

        -- 物流网络子组 → 电磁工厂
        for item_name, item in pairs(data.raw.item) do
            if item.subgroup == "logistic-network" then
                add_recipe_category(item_name, "electromagnetics")
            end
        end

        -- 所有机械臂子组 → 电磁工厂
        for item_name, item in pairs(data.raw.item) do
            if item.subgroup == "inserter" then
                add_recipe_category(item_name, "electromagnetics")
            end
        end

        -- 手动补充电磁工厂配方
        local manual_em_recipes = {
            "electric-engine-unit",
            "flying-robot-frame",
        }
        for _, name in ipairs(manual_em_recipes) do
            add_recipe_category(name, "electromagnetics")
        end

        -- 火箭燃料 → 低温工厂
        add_recipe_category("rocket-fuel", "cryogenics")

        -- 铁路斜坡、铁路支架 → 铸造厂（仅追加类别）
        add_recipe_category("rail-ramp", "metallurgy")
        add_recipe_category("rail-support", "metallurgy")
    end

    -- 注册铸造厂新增配方并解锁科技
    if mode == "full" then
        data:extend(foundry_recipes)

        local tech = data.raw.technology["foundry"]
        if tech then
            tech.effects = tech.effects or {}
            for _, recipe_def in ipairs(foundry_recipes) do
                table.insert(tech.effects, {type="unlock-recipe", recipe=recipe_def.name})
            end
        end
    end
end