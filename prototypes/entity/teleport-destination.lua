-- ForGavin/prototypes/entity/teleport-destination.lua
data:extend({
    {
        type = "simple-entity",
        name = "teleport-destination",
        icon = "__base__/graphics/icons/blueprint.png",
        icon_size = 64,
        flags = {"not-on-map", "placeable-off-grid", "player-creation"},
        collision_mask = { layers = {} },
        collision_box = {{0, 0}, {0, 0}},
        selection_box = {{0, 0}, {0, 0}},
        picture = {
            filename = "__core__/graphics/empty.png",
            priority = "extra-high",
            width = 1,
            height = 1
        }
    }
})