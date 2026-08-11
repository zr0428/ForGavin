-- ForGavin/prototypes/teleport.lua
local chr = data.raw.character.character
local mod_path = "__ForGavin__/graphics/"
local particle_animations = require("__base__.prototypes.particle-animations")

local teleport_particle = {
    type = "optimized-particle",
    name = "forgavin-teleport-particle",
    life_time = 36,
    fade_away_duration = 14,
    render_layer = "air-object",
    render_layer_when_on_ground = "air-object",
    movement_modifier = 0.96,
    movement_modifier_when_on_ground = 0.9,
    vertical_acceleration = -0.002,
    pictures = particle_animations.get_sparks_particle_pictures(),
    ended_in_water_trigger_effect = nil,
}

for _, picture in pairs(teleport_particle.pictures) do
    if picture.sheet then
        picture.sheet.tint = { r = 0.1, g = 0.55, b = 1, a = 1 }
    else
        picture.tint = { r = 0.1, g = 0.55, b = 1, a = 1 }
    end
end

data:extend({
    teleport_particle,

    -- 隐藏物品，用于蓝图引用
    {
        type = "item",
        name = "teleport-destination",
        hidden = true,
        icon = mod_path .. "teleport-tool_128.png",
        icon_size = 128,
        order = "tele-i1",
        place_result = "teleport-destination-entity",
        stack_size = 1,
    },

    -- 传送占位实体（生成幽灵）
    {
        type = "simple-entity-with-owner",
        name = "teleport-destination-entity",
        icon = mod_path .. "teleport-tool_128.png",
        icon_size = 128,
        hidden = true,
        flags = { "not-on-map", "placeable-off-grid", "placeable-player", "player-creation" },
        collision_mask = { layers = { player = true } },
        collision_box = util.table.deepcopy(chr.collision_box),
        selection_box = util.table.deepcopy(chr.selection_box),
        placeable_by = { item = "teleport-destination", count = 1 },
        picture = util.table.deepcopy(chr.animations[1].idle),
    },

    -- 传送蓝图（手持工具）
    {
        type = "blueprint",
        name = "teleport-tool-blueprint",
        icon = mod_path .. "teleport-tool_128.png",
        icon_size = 128,
        hidden = true,
        flags = { "not-stackable", "only-in-cursor" },
        stack_size = 1,
        select = {
            border_color = {0, 1, 0},
            mode = "blueprint",
            cursor_box_type = "logistics",
            ignore_cannot_select_entities = true,
            ignore_cannot_select_tiles = true,
        },
        alt_select = {
            border_color = {0, 1, 0},
            mode = "blueprint",
            cursor_box_type = "logistics",
            ignore_cannot_select_entities = true,
            ignore_cannot_select_tiles = true,
        },
    },

    -- 键盘快捷键
    {
        type = "custom-input",
        name = "teleport-tool",
        key_sequence = "CONTROL + SHIFT + T",
        consuming = "none",
        action = "lua",
    },

    -- 快捷栏按钮
    {
        type = "shortcut",
        name = "teleport-shortcut",
        order = "z[teleport]",
        action = "lua",
        icon = mod_path .. "teleport-tool_128.png",
        icon_size = 128,
        small_icon = mod_path .. "teleport-tool.png",
        small_icon_size = 64,
        associated_control_input = "teleport-tool",
    },
})
