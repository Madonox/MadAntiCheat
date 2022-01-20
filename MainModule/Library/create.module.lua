-- Madonox
-- 2022

return function(ins,properties)
	local inst = Instance.new(ins)
	for i,v in pairs(properties) do
		inst[i] = v
	end
	return inst
end
