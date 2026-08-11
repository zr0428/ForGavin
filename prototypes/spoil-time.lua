-- ForGavin/prototypes/spoil-time.lua
-- 变质时间倍率调整（仅 Space Age 启用时生效）
if mods["space-age"] then
    local multiplier = settings.startup["spoil-time-multiplier"].value or 1

    -- 当倍率不为 1 时才修改变质时间
    if multiplier ~= 1 then
        -- 手动豁免名单（名称完全匹配）
        local keep_default = {
            ["nutrients"] = true,           -- 营养素
            ["iron-bacteria"] = true,       -- 铁细菌
            ["copper-bacteria"] = true,     -- 铜细菌
        }

        -- 处理一组原型（物品或胶囊）
        local function process_prototypes(prototypes)
            if not prototypes then return end

            for _, prototype in pairs(prototypes) do
                if prototype.spoil_ticks then
                    local name = prototype.name

                    -- 豁免：1）手动名单中的物品  2）名称包含 "bacteria" 的物品
                    if not (keep_default[name] or string.find(name, "bacteria")) then
                        prototype.spoil_ticks =
                            math.max(
                                1,
                                math.floor(prototype.spoil_ticks * multiplier + 0.5)
                            )
                    end
                end
            end
        end

        -- 同时遍历物品和胶囊原型，确保覆盖所有可变质物品
        process_prototypes(data.raw.item)
        process_prototypes(data.raw.capsule)
    end
end