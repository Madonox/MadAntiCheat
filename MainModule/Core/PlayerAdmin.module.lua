-- Madonox
-- 2022

local PlayerAdmin = {}

local config = {}
local modules = {}
local StreamFiles = nil

local adminEnabled = {}

function PlayerAdmin.init(conf)
	config = conf
	for _,v in ipairs(script.Parent:GetChildren()) do
		if v.Name ~= "PlayerAdmin" then
			local module = require(v)
			modules[v.Name] = module
			if typeof(module) == "table" then
				if module.init ~= nil then
					module.init(conf)
				end
			end
		end
	end
	StreamFiles = require(script.Parent.Parent.Parent.Library.StreamFiles)
end
function PlayerAdmin.buildPlayer(player)
	if modules.PermissionManager.checkPlayer(player) == true then
		player.Chatted:Connect(function(msg)
			if msg == config.command then
				if not table.find(adminEnabled,player) then
					script["AnticheatGui"]:Clone().Parent = player.PlayerGui
					table.insert(adminEnabled,player)
				end
			end
		end)
	end
end
function PlayerAdmin.requestPlayerState(player)
	return table.find(adminEnabled,player)
end
function PlayerAdmin.destroyPlayer(player)
	if table.find(adminEnabled,player) then
		table.remove(adminEnabled,table.find(adminEnabled,player))
	end
end

return PlayerAdmin
