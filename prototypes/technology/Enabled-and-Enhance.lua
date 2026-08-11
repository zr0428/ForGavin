-- ForGavin/prototypes/technology/Enabled-and-Enhance.lua
-- 激光伤害加成
local builder_start = settings.startup["builder-start"].value
if builder_start == "Enabled-and-Enhance" or builder_start == "legendary" then
    data:extend({
        {
            type = "technology",
            name = "gavin-laser-damage-bonus",
            hidden = true,
            enabled = false,
            icon = "__base__/graphics/technology/laser-weapons-damage.png",
            icon_size = 256,
            effects = {
                {
                    type = "ammo-damage",
                    ammo_category = "laser",
                    modifier = 2.0
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