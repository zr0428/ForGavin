-- ForGavin/prototypes/technology/crafting-revolution.lua
-- 手搓革命
if settings.startup["crafting-revolution"].value ~= 0 then
    data:extend({
        {
            type = "technology",
            name = "crafting-revolution",
            hidden = true,
            enabled = false,
            icon = "__ForGavin__/graphics/crafting-revolution.png",
            icon_size = 256,
            effects = {
                {
                    type = "character-crafting-speed",
                    modifier = settings.startup["crafting-revolution"].value
                }
            },
            unit = {
                count = 1,
                time = 1,
                ingredients = {}
            },
            upgrade = false,
            order = "c-k-f-a"
        }
    })
end