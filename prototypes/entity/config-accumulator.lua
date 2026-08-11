-- ForGavin/prototypes/entity/config-accumulator.lua
local EnergyUtils = require("__ForGavin__/prototypes/Energyunitconversiontool")
local parse_energy = EnergyUtils.parse_energy
local format_energy = EnergyUtils.format_energy
local accumulator_config = settings.startup["config-accumulator"].value

-- 遍历游戏中所有的蓄电池
for name, accumulator in pairs(data.raw["accumulator"]) do
    if accumulator.energy_source then
        local source = accumulator.energy_source
        if source.output_flow_limit then
            source.output_flow_limit = format_energy(parse_energy(source.output_flow_limit) * accumulator_config, "W")
        end
        if source.input_flow_limit then
            source.input_flow_limit = format_energy(parse_energy(source.input_flow_limit) * accumulator_config, "W")
        end
        if source.buffer_capacity then
            source.buffer_capacity = format_energy(parse_energy(source.buffer_capacity) * accumulator_config, "J")
        end
    end
end