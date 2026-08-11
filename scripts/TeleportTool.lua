-- ForGavin/scripts/TeleportTool.lua
-- 自由传送工具（2 秒充能、动态光环与粒子效果）

local TELEPORT_DELAY = 120
local COOLDOWN_DURATION = 300
local PARTICLE_INTERVAL = 8
local TWO_PI = math.pi * 2

local function ensure_storage()
    storage.teleport_requests = storage.teleport_requests or {}
    storage.teleport_cooldown = storage.teleport_cooldown or {}
end

local function is_teleport_enabled(player)
    if not player or not player.valid then return false end
    if player.controller_type == defines.controllers.editor then return false end

    local setting = settings.startup["teleport-mode"]
    return setting and setting.value == true
end

local function destroy_render_object(object)
    if object and object.valid then
        object.destroy()
    end
end

local function destroy_request_effects(request)
    local effects = request and request.effects
    if not effects then return end

    for _, object in pairs(effects) do
        destroy_render_object(object)
    end
    request.effects = nil
end

local function clear_request(player_index)
    ensure_storage()
    local request = storage.teleport_requests[player_index]
    if request then
        destroy_request_effects(request)
        storage.teleport_requests[player_index] = nil
    end
end

local function draw_charge_circle(surface, position, player_index, radius, width, alpha)
    return rendering.draw_circle({
        color = { r = 0.05, g = 0.45, b = 1, a = alpha },
        radius = radius,
        width = width,
        filled = false,
        target = position,
        surface = surface,
        players = { player_index },
    })
end

local function ensure_request_effects(request, source_surface, target_surface, player_index)
    request.effects = request.effects or {}
    local effects = request.effects

    if not effects.source_outer or not effects.source_outer.valid then
        effects.source_outer = draw_charge_circle(source_surface, request.source_position, player_index, 2.2, 3, 0.9)
    end
    if not effects.source_inner or not effects.source_inner.valid then
        effects.source_inner = draw_charge_circle(source_surface, request.source_position, player_index, 1.4, 2, 0.65)
    end
    if not effects.target_outer or not effects.target_outer.valid then
        effects.target_outer = draw_charge_circle(target_surface, request.position, player_index, 0.25, 3, 0.9)
    end
    if not effects.target_inner or not effects.target_inner.valid then
        effects.target_inner = draw_charge_circle(target_surface, request.position, player_index, 0.15, 2, 0.65)
    end
end

local function update_request_effects(request, source_surface, target_surface, player_index)
    ensure_request_effects(request, source_surface, target_surface, player_index)

    local remaining = math.max(0, request.tick - game.tick)
    local progress = 1 - remaining / TELEPORT_DELAY
    local pulse = (math.sin(progress * math.pi * 8) + 1) * 0.5
    local source_radius = 2.2 - progress * 1.7
    local target_radius = 0.25 + progress * 1.95

    request.effects.source_outer.radius = source_radius
    request.effects.source_inner.radius = math.max(0.2, source_radius * 0.62 + pulse * 0.08)
    request.effects.target_outer.radius = target_radius
    request.effects.target_inner.radius = math.max(0.15, target_radius * 0.62 + pulse * 0.08)

    local alpha = 0.55 + pulse * 0.4
    request.effects.source_outer.color = { r = 0.05, g = 0.45, b = 1, a = alpha }
    request.effects.target_outer.color = { r = 0.05, g = 0.45, b = 1, a = alpha }
end

local function create_particle_ring(surface, position, seed, inward)
    for i = 1, 4 do
        local angle = ((seed * 0.17) + (i - 1) / 4) * TWO_PI
        local dx = math.cos(angle)
        local dy = math.sin(angle)
        local direction = inward and -1 or 1

        surface.create_particle({
            name = "forgavin-teleport-particle",
            position = {
                x = position.x + dx * 1.5,
                y = position.y + dy * 1.5,
            },
            movement = {
                x = dx * 0.045 * direction,
                y = dy * 0.045 * direction,
            },
            height = 0.25,
            vertical_speed = 0.015,
            frame_speed = 1,
        })
    end
end

local function play_arrival_burst(surface, position, player_index)
    local radii = { 0.65, 1.3, 2.1 }
    for i, radius in ipairs(radii) do
        rendering.draw_circle({
            color = { r = 0.05, g = 0.55, b = 1, a = 1 - i * 0.18 },
            radius = radius,
            width = 4 - i * 0.6,
            filled = false,
            target = position,
            surface = surface,
            players = { player_index },
            time_to_live = 12 + i * 8,
        })
    end

    for i = 1, 16 do
        local angle = (i / 16) * TWO_PI
        surface.create_particle({
            name = "forgavin-teleport-particle",
            position = position,
            movement = {
                x = math.cos(angle) * 0.09,
                y = math.sin(angle) * 0.09,
            },
            height = 0.35,
            vertical_speed = 0.025,
            frame_speed = 1,
        })
    end
end

local function equip_teleport_tool(player)
    if not player or not player.valid then return end
    if not is_teleport_enabled(player) then
        player.print({ "mod-teleport.mode-disabled" })
        return
    end

    if player.clear_cursor() then
        player.cursor_stack.set_stack({ name = "teleport-tool-blueprint" })
        player.cursor_stack.set_blueprint_entities({
            { entity_number = 1, name = "teleport-destination-entity", position = { x = 0, y = 0 } }
        })
    end
end

local function perform_teleport(player, request, target_surface)
    local entity = (player.vehicle and player.vehicle.valid) and player.vehicle or player.character
    if not entity or not entity.valid then
        player.print({ "mod-teleport.no-entity" })
        return false
    end

    local position = target_surface.find_non_colliding_position(
        entity.prototype.name,
        request.position,
        10,
        0.5
    )

    if not position then
        player.print({ "mod-teleport.cannot-stand" })
        return false
    end

    local source_surface = entity.surface
    local source_position = entity.position
    local teleported = entity.teleport(position, target_surface)
    if not teleported then
        player.print({ "mod-teleport.failed", "destination rejected the entity" })
        return false
    end

    create_particle_ring(source_surface, source_position, player.index, false)
    play_arrival_burst(target_surface, position, player.index)
    player.play_sound({ path = "utility/scenario_message" })
    player.print({
        "mod-teleport.success",
        string.format("%.1f", position.x),
        string.format("%.1f", position.y),
        target_surface.name,
    })
    storage.teleport_cooldown[player.index] = game.tick + COOLDOWN_DURATION
    return true
end

function OnTeleportToolActivated(event)
    local player = game.get_player(event.player_index)
    if player then equip_teleport_tool(player) end
end

function OnTeleportBlueprintPlaced(event)
    local entity = event.entity or event.created_entity
    if not entity or not entity.valid then return end
    if entity.name ~= "entity-ghost" or entity.ghost_name ~= "teleport-destination-entity" then
        return
    end

    local player = game.get_player(event.player_index)
    local target_position = { x = entity.position.x, y = entity.position.y }
    local target_surface_index = entity.surface.index
    entity.destroy()

    if not player then return end
    if not is_teleport_enabled(player) then
        player.print({ "mod-teleport.mode-disabled" })
        return
    end

    ensure_storage()
    local cooldown_tick = storage.teleport_cooldown[event.player_index]
    if cooldown_tick and game.tick < cooldown_tick then
        local remaining = math.ceil((cooldown_tick - game.tick) / 60)
        player.print({ "mod-teleport.cooldown", tostring(remaining) })
        return
    end

    clear_request(event.player_index)
    player.clear_cursor()

    storage.teleport_requests[event.player_index] = {
        position = target_position,
        target_surface_index = target_surface_index,
        source_position = { x = player.position.x, y = player.position.y },
        source_surface_index = player.surface.index,
        tick = game.tick + TELEPORT_DELAY,
    }

    local delay_seconds = math.ceil(TELEPORT_DELAY / 60)
    local target_surface = game.surfaces[target_surface_index]
    player.print({
        "mod-teleport.delay",
        tostring(delay_seconds),
        string.format("%.1f", target_position.x),
        string.format("%.1f", target_position.y),
        target_surface and target_surface.name or "?",
    })
end

function OnTickTeleport()
    ensure_storage()

    for player_index, request in pairs(storage.teleport_requests) do
        local player = game.get_player(player_index)
        local source_surface = game.surfaces[request.source_surface_index]
        local target_surface = game.surfaces[request.target_surface_index]

        if not player or not player.valid or not is_teleport_enabled(player)
            or not source_surface or not source_surface.valid
            or not target_surface or not target_surface.valid then
            clear_request(player_index)
        else
            update_request_effects(request, source_surface, target_surface, player_index)

            if game.tick % PARTICLE_INTERVAL == player_index % PARTICLE_INTERVAL then
                local seed = game.tick / PARTICLE_INTERVAL + player_index
                create_particle_ring(source_surface, request.source_position, seed, true)
                create_particle_ring(target_surface, request.position, seed + 0.5, true)
            end

            if game.tick >= request.tick then
                destroy_request_effects(request)
                perform_teleport(player, request, target_surface)
                storage.teleport_requests[player_index] = nil
            end
        end
    end
end

function OnTeleportPlayerLeft(event)
    clear_request(event.player_index)
    storage.teleport_cooldown[event.player_index] = nil
end
