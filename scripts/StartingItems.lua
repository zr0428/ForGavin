-- ForGavin/scripts/StartingItems.lua
--StartingItems--
function StartingItems(event)
    local startup = settings.startup["starting-items"].value
    if startup == "Not-Enabled" then return end

    local Acount = 5
    local Player = game.players[event.player_index]
    local Sitems = {}
    local StartItems = {
        assembling  = "assembling-machine-1",    -- 组装机
        lab         = "lab",                      -- 研究中心
        drill       = "electric-mining-drill",    -- 电力矿机
        pole        = "medium-electric-pole",     -- 电线杆
        substation  = "substation",               -- 广域配电站
        boiler      = "boiler",                   -- 锅炉
        steameg     = "steam-engine",             -- 蒸汽机
        belt        = "transport-belt",           -- 传送带
        unbelt      = "underground-belt",         -- 地下传送带
        splitter    = "splitter",                 -- 分流器
        inserter    = "inserter",                 -- 爪子
        linserter   = "long-handed-inserter",     -- 红爪
        pipe        = "pipe",                     -- 管道
        unpipe      = "pipe-to-ground",           -- 地下管道
        pump        = "offshore-pump",            -- 抽水泵
        solarpanel  = "solar-panel",              -- 太阳能
        accumulator = "accumulator",              -- 蓄电池
        furnace     = "stone-furnace",            -- 2x2 炉子
        furnace1    = "electric-furnace",         -- 3x3 电炉
    }

    if startup == "simple" then
        Sitems = {
            {StartItems.assembling, 50},
            {StartItems.lab, 20},
            {StartItems.drill, 50},
            {StartItems.pole, 200},
            {StartItems.substation, 10},
            {StartItems.boiler, 20},
            {StartItems.steameg, 40},
            {StartItems.belt, 500},
            {StartItems.unbelt, 100},
            {StartItems.splitter, 50},
            {StartItems.inserter, 200},
            {StartItems.linserter, 100},
            {StartItems.pipe, 100},
            {StartItems.unpipe, 100},
            {StartItems.pump, 10},
            {StartItems.solarpanel, 50},
            {StartItems.accumulator, 50},
            {StartItems.furnace, 100},
            {StartItems.furnace1, 50},
        }
    elseif startup == "abundant" then
        StartItems["assembling"] = "assembling-machine-2"
        StartItems["belt"] = "fast-transport-belt"
        StartItems["unbelt"] = "fast-underground-belt"
        StartItems["splitter"] = "fast-splitter"
        StartItems["inserter"] = "fast-inserter"
        StartItems["furnace"] = "steel-furnace"

        Sitems = {
            {StartItems["assembling"], 50 * Acount},
            {StartItems["lab"], 20 * Acount},
            {StartItems["drill"], 50 * Acount},
            {StartItems["pole"], 200 * Acount},
            {StartItems["substation"], 10 * Acount},
            {StartItems["boiler"], 20 * Acount},
            {StartItems["steameg"], 40 * Acount},
            {StartItems["belt"], 500 * Acount},
            {StartItems["unbelt"], 100 * Acount},
            {StartItems["splitter"], 50 * Acount},
            {StartItems["inserter"], 200 * Acount},
            {StartItems["linserter"], 100 * Acount},
            {StartItems["pipe"], 100 * Acount},
            {StartItems["unpipe"], 100 * Acount},
            {StartItems["pump"], 10},
            {StartItems["solarpanel"], 50 * Acount},
            {StartItems["accumulator"], 50 * Acount},
            {StartItems.furnace, 100},
            {StartItems.furnace1, 50 * Acount},
        }
    end

    for _, v in pairs(Sitems) do
        if v[2] > 0 then
            Player.insert{name = v[1], count = v[2]}
        end
    end
end