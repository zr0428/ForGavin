-- ForGavin/scripts/CraftingRevolution.lua
function ApplyCraftingRevolution()
    for _, force in pairs(game.forces) do
        local tech = force.technologies["crafting-revolution"]
        if tech and not tech.researched then
            tech.researched = true
        end
    end
end