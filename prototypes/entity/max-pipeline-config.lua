-- ForGavin/prototypes/entity/max-pipeline-config.lua
local config = settings.startup["max-pipeline-config"].value
local fluid_box_fields = {
    "fluid_box",
    "input_fluid_box",
    "output_fluid_box",
    "fuel_fluid_box",
    "oxidizer_fluid_box"
}

if config ~= 320 then
    for _, prototypes in pairs(data.raw) do
        if type(prototypes) ~= "table" then goto continue end

        for _, prototype in pairs(prototypes) do
            -- 1. 顶层流体字段
            for _, field in ipairs(fluid_box_fields) do
                local box = prototype[field]
                if type(box) == "table" then
                    box.max_pipeline_extent = config
                end
            end

            -- 2. fluid_boxes 数组
            if type(prototype.fluid_boxes) == "table" then
                for _, box in ipairs(prototype.fluid_boxes) do
                    if type(box) == "table" then
                        box.max_pipeline_extent = config
                    end
                end
            end

            -- 3. energy_source 内部的 fluid_box
            local es = prototype.energy_source
            if type(es) == "table" then
                if type(es.fluid_box) == "table" then
                    es.fluid_box.max_pipeline_extent = config
                end
            end
        end

        ::continue::
    end
end