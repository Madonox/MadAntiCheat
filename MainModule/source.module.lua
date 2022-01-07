-- Madonox
-- 2022

local MadAntiCheat = {}

local library = {}
local instanceRegistry = {}
local localFileCollection = {}
local configData = {}
local checks = {}

local clientModules = {
	"HBE";
	"Injection";
}

local function loadCheck(player,check)
	local localConfig = configData.checks[check]
	if localConfig then
		if localConfig.enabled == true then
			if not table.find(clientModules,check) then
				local mainCheck = checks[check]
				if mainCheck then
					local confData = {}
					for _,v in ipairs(mainCheck[2]) do
						table.insert(confData,localConfig[v])
					end
					mainCheck[1](player,confData)
				else
					error("Cannot find check module "..check)
				end
			end
		end
	else
		error("Cannot find check config "..check)
	end
end

function MadAntiCheat.init()
	for i,v in ipairs(script.Library:GetChildren()) do
		library[v.Name] = require(v)
	end
	localFileCollection = script.SavedInstances.ClientReplication:GetChildren()
	instanceRegistry.re = library.create("RemoteEvent",{
		Name="MadAntiCheatRE";
		Parent=game.ReplicatedStorage;
	})
	instanceRegistry.rf = library.create("RemoteFunction",{
		Name="MadAntiCheatRF";
		Parent=game.ReplicatedStorage;
	})
end
function MadAntiCheat.start(conf)
	configData.checks = {}
	configData.admin = {}
	configData.admin.externalAdmins = {}
	for _,v in ipairs(conf.CheckConfiguration:GetChildren()) do
		configData.checks[v.Name] = require(v)
	end
	for i,v in ipairs(script.Core.Checks:GetChildren()) do
		if configData.checks[v.Name].enabled == true then
			checks[v.Name] = require(v)
		end
	end
	for _,v in ipairs(script.Core.Processes:GetChildren()) do
		local module = require(v)
		if typeof(module) == "function" then
			module(configData)
		elseif typeof(module) == "table" then
			if module.init ~= nil then
				module.init(configData)
			end
			if module.start ~= nil then
				module.start(configData)
			end
		end
	end
	
	library.StreamFiles.streamLocalScriptsAll(localFileCollection)
	for _,player in ipairs(game.Players:GetPlayers()) do
		for checkName,config in pairs(configData.checks) do
			loadCheck(player,checkName)
		end
	end
	game.Players.PlayerAdded:Connect(function(player)
		library.StreamFiles.streamLocalScriptsPlayer(player,localFileCollection)
		for checkName,config in pairs(configData.checks) do
			loadCheck(player,checkName)
		end
	end)
end

return MadAntiCheat
