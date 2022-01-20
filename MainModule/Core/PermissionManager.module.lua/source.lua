-- Madonox
-- 2022

local PermissionManager = {}

local checkModules = {}
local config
local adminConfig

function PermissionManager.init(_config)
	for _,v in ipairs(script:GetChildren()) do
		checkModules[v.Name] = require(v)
	end
	config = _config
	adminConfig = _config.admin
end

function PermissionManager.checkPlayer_Adonis(player)
	local res = false
	if config.admin.externalAdmins.Adonis == true then
		res = checkModules.Adonis(player)
	end
	return res
end
function PermissionManager.checkPlayer(player)
	local res = false
	if table.find(adminConfig.users,player.Name) or table.find(adminConfig.users,player.UserId) then
		res = true
	end
	if res == false then
		for groupId,ranks in pairs(adminConfig.groups) do
			local rank = player:GetRankInGroup(groupId)
			if table.find(ranks,rank) then
				res = true
				break
			end
		end
	end
	if res == false then
		if PermissionManager.checkPlayer_Adonis(player) == true then
			res = true
		end
	end
	return res
end

return PermissionManager
