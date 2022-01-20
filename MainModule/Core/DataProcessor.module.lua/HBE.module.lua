-- Madonox
-- 2022

local ignoredUsers = {}

local function punishUser(conf,player)
	if not table.find(ignoredUsers,player) then
		if conf[1] == "respawn" then
			player:LoadCharacter()
		elseif conf[1] == "kick" then
			player:Kick()
		end
	end
end

return {
	function(player,conf,part,partSize)
		if part:IsA("Part") then
			if typeof(partSize) == "Vector3" then
				if part.Size ~= partSize then
					punishUser(conf,player)
					return true
				else
					return false
				end
			else
				punishUser(conf,player)
			end
		else
			punishUser(conf,player)
		end
	end;
	{"punishment"};
	function(method,...) -- API function
		local args = {...}
		if method == "ignoreUser" then
			if args[1] then
				if args[1]:IsA("Player") then
					table.insert(ignoredUsers,args[1])
				else
					warn("Please supply a valid player.")
				end
			else
				warn("Please supply a valid argument for argument 1.")
			end
		elseif method == "removeIgnoreUser" then
			if args[1] then
				if args[1]:IsA("Player") then
					if table.find(ignoredUsers,args[1]) then
						table.remove(ignoredUsers,table.find(ignoredUsers,args[1]))
					end
				else
					warn("Please supply a valid player.")
				end
			else
				warn("Please supply a valid argument for argument 1.")
			end
		end
	end;
}
