-- Madonox
-- 2022

-- _G.Adonis.CheckAdmin(client)

return function(player)
	local res = false
	if _G.Adonis then
		if _G.Adonis.CheckAdmin(player) == true then
			res = true
		end
	end
	return res
end
