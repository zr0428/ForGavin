-- ForGavin/scripts/EnabledandEnhance.lua
function ApplyLaserDamageBonus()
    local builder = settings.startup["builder-start"].value

    for _, force in pairs(game.forces) do
        local tech_laser = force.technologies["gavin-laser-damage-bonus"]
        if tech_laser then
            if builder == "Enabled-and-Enhance" or builder == "legendary" then
                tech_laser.researched = true
            else
                tech_laser.researched = false
            end
        end
    end
end