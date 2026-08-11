-- ForGavin/scripts/InfinityChest.lua
function InfinityChest(event)
    if settings.startup["infinity-chest"].value then
        local Player = game.players[event.player_index]
        local Items = {
            {"infinity-chest", 50},
            {"infinity-pipe", 50},
            {"electric-energy-interface", 10},
            {"loader", 50},
        }
        for i, v in pairs(Items) do
            if v[2] > 0 then
                Player.insert{name = v[1], count = v[2]}
            end
        end
    end
end