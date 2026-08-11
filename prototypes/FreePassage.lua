-- ForGavin/prototypes/FreePassage.lua
-- FreePassage --
-- 缩小角色碰撞箱，使其能在管道、太阳能板等建筑缝隙间穿行

if settings.startup["free-passage"].value then
    local character = data.raw["character"]["character"]
    if character then
        -- 碰撞箱缩至极小，可穿过任意 1 格宽缝隙
        character.collision_box = {{-0.01, -0.01}, {0.01, 0.01}}
    end
end