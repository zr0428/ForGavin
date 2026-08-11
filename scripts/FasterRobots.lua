-- ForGavin/scripts/FasterRobots.lua
function ApplyRobotSpeedBonus()
    local robot_speed = settings.startup["faster-robots"].value

    for _, force in pairs(game.forces) do
        local tech_speed = force.technologies["gavin-robot-speed-bonus"]
        if tech_speed then
            tech_speed.researched = (robot_speed > 0)
        end
    end
end