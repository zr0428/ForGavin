-- ForGavin/prototypes/items/RobotNoEnergy.lua
-- RobotNoEnergy --
if settings.startup["robot-no-energy"].value then
    local robot_types = {"logistic-robot", "construction-robot"}
    for _, type_name in ipairs(robot_types) do
        local robots = data.raw[type_name]
        if robots then
            for _, robot in pairs(robots) do
                robot.energy_per_move = "0J"
                robot.energy_per_tick = "0J"
                robot.min_to_charge = 0
                robot.max_to_charge = 0
            end
        end
    end
end