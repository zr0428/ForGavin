-- ForGavin/prototypes/recipe/allow-quality-all-recipes.lua
-- 任意配方允许品质模块
if mods["quality"] then
    if settings.startup["allow-quality-all-recipes"].value then
        for _, recipe in pairs(data.raw.recipe) do
            recipe.allow_quality = true
        end
    end
end