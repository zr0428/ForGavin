-- ForGavin/prototypes/modified-size.lua
--modified_size
function modified_size( oldvalue, multiplier )
	if oldvalue == nil then oldvalue = 1 end
	local v = oldvalue * multiplier
	if v > oldvalue then
		return( v )
	else
		return oldvalue
	end
end

for _,dat in pairs(data.raw) do
	for _,item in pairs(dat) do
		if item.stack_size and type(item.stack_size) == "number" and item.stack_size > 1 then
			item.stack_size = modified_size( item.stack_size,  settings.startup["stack-multiplier"].value )
			if defult_logistics_request_multiplier ~= nil then
				item.default_request_amount = defult_logistics_request_multiplier
			end
		end
	end
end