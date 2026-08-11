-- ForGavin/scripts/PCustomPlayerAttributes.lua
--CustomPlayerAttributes--
function PCustomPlayerAttributes(event)
    if not settings.startup["custom-player-attributes"].value then return end

    if event.player_index ~= nil then
        local player_index = event.player_index
        local player = game.players[player_index]

        if player and player.character then
            local player_settings = settings.get_player_settings(player_index)

            -- Check if the settings keys exist before accessing their values
            local backpack_enabled = player_settings["p-adjustable-backpack-enabled"].value
            local mining_speed = player_settings["p-player-mining-speed"].value
            local running_speed = player_settings["p-player-run-speed"].value
            local crafting_speed = player_settings["p-crafting-revolution"].value

            -- Apply the modifiers only if the values are valid
            if backpack_enabled ~= nil then
                player.character_inventory_slots_bonus = backpack_enabled
            end
            if mining_speed ~= nil then
                player.character_mining_speed_modifier = mining_speed
            end
            if running_speed ~= nil then
                player.character_running_speed_modifier = running_speed
            end
            if crafting_speed ~= nil then
                player.character_crafting_speed_modifier = crafting_speed
            end
        else
            log("Invalid player index: " .. tostring(player_index))
        end
    end
end