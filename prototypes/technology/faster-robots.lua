-- ForGavin/prototypes/technology/faster-robots.lua
-- 机器人速度加成
local robot_speed_bonus = settings.startup["faster-robots"].value
if robot_speed_bonus > 0 then
    data:extend({
        {
            type = "technology",
            name = "gavin-robot-speed-bonus",
            hidden = true,
            enabled = false,
            icon = "__base__/graphics/technology/worker-robots-speed.png",
            icon_size = 256,
            effects = {
                {
                    type = "worker-robot-speed",
                    modifier = robot_speed_bonus
                }
            },
            unit = {
                count = 1,
                time = 1,
                ingredients = {}
            },
            upgrade = false,
            order = "z"
        }
    })
end