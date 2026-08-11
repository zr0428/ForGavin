-- ForGavin/prototypes/entity/drill-filter.lua
if settings.startup["drill-filter"] and settings.startup["drill-filter"].value then
    for _, drill in pairs(data.raw["mining-drill"]) do
        drill.filter_count = 5
    end
end