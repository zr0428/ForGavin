-- ForGavin/prototypes/Energyunitconversiontool.lua
-- 🔧 Energy unit conversion tool
local M = {}

function M.parse_energy(str)
    if not str then return 0 end
    local num, unit = str:match("([%d%.]+)%s*(%a+)")
    num = tonumber(num) or 0
    local multipliers = {
        W = 1, kW = 1e3, MW = 1e6, GW = 1e9,
        J = 1, kJ = 1e3, MJ = 1e6, GJ = 1e9
    }
    return num * (multipliers[unit] or 1)
end

function M.format_energy(value, unit)
    local divisors = {
        W = 1, kW = 1e3, MW = 1e6, GW = 1e9,
        J = 1, kJ = 1e3, MJ = 1e6, GJ = 1e9
    }
    local div = divisors[unit] or 1
    return tostring(math.floor(value / div)) .. unit
end

return M