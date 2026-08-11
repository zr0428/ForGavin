-- ForGavin/prototypes/entity/modify-electric-pole.lua
-- ModifyElectricPole --
-- Adjust wire distance and supply area for electric poles based on startup setting --

-- Get config option (values: "default", "1" ~ "5")
local config = settings.startup["electric-pole-config"].value

-- Preset configurations: each entry is {wire_distance, supply_area}
local pole_data = {
    ["1"] = {{7.5, 3.5}, {9.5, 4.5}, {64, 4}, {32, 16}},
    ["2"] = {{7.5, 3.5}, {9.5, 4.5}, {64, 4}, {64, 32}},
    ["3"] = {{8, 4}, {16, 8}, {64, 4}, {32, 16}},
    ["4"] = {{8, 4}, {16, 8}, {64, 4}, {64, 32}},
    ["5"] = {{64, 32}},   -- Only one set of values, applied to all electric poles
}

-- If setting is not "default", apply configuration
if config ~= "default" then
    local values = pole_data[config]

    -- Invalid config check
    if not values then
        log("Invalid electric-pole-config value: " .. tostring(config))
        return
    end

    if config == "5" then
        -- Apply the same values to all electric poles
        local wire_dist = values[1][1]
        local supply_dist = values[1][2]
        for _, pole in pairs(data.raw["electric-pole"] or {}) do
            pole.maximum_wire_distance = wire_dist
            pole.supply_area_distance = supply_dist
        end
    else
        -- Apply per-type values to the four standard electric poles
        local pole_names = {
            "small-electric-pole",
            "medium-electric-pole",
            "big-electric-pole",
            "substation"
        }
        for i, name in ipairs(pole_names) do
            local prototype = data.raw["electric-pole"][name]
            if prototype then
                prototype.maximum_wire_distance = values[i][1]
                prototype.supply_area_distance = values[i][2]
            end
        end
    end
end