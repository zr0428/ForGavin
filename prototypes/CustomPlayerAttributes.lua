-- ForGavin/prototypes/CustomPlayerAttributes.lua
--startup-CustomPlayerAttributes--
if settings.startup["adjustable-backpack-enabled"].value then
    local NewbackpackSize = tonumber(settings.startup["adjustable-backpack-enabled"].value)
    for _, character in pairs(data.raw["character"] or {}) do
        character.inventory_size = NewbackpackSize
    end
end

if settings.startup["player-mining-speed"].value then
    local speed = settings.startup["player-mining-speed"].value * 0.5
    for _, character in pairs(data.raw["character"] or {}) do
        character.mining_speed = speed
    end
end

if settings.startup["player-run-speed"].value then
    local speed = settings.startup["player-run-speed"].value * 0.15
    for _, character in pairs(data.raw["character"] or {}) do
        character.running_speed = speed
    end
end

if settings.startup["player-reach-distance"].value ~= "default" then
    local PRdistance = tonumber(settings.startup["player-reach-distance"].value)
    for _, character in pairs(data.raw["character"] or {}) do
        character.build_distance = PRdistance
        character.reach_distance = PRdistance
        character.reach_resource_distance = PRdistance
        character.drop_item_distance = PRdistance
    end
end