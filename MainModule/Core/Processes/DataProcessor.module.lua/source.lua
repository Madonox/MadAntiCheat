-- Madonox
-- 2022

local re = game.ReplicatedStorage:WaitForChild("MadAntiCheatRE") :: RemoteEvent
local rf = game.ReplicatedStorage:WaitForChild("MadAntiCheatRF") :: RemoteFunction

local checks = {}
local configData = {}

local apiFunctions = {}

local function loadCheck(player,check,...)
	local localConfig = configData.checks[check]
	if localConfig then
		if localConfig.enabled == true then
			local mainCheck = checks[check]
			if mainCheck then
				local confData = {}
				for _,v in ipairs(mainCheck[2]) do
					table.insert(confData,localConfig[v])
				end
				mainCheck[1](player,confData,...)
				if mainCheck[3] then
					apiFunctions[check] = mainCheck[3]
				end
			else
				error("Cannot find check module "..check)
			end
		end
	else
		error("Cannot find check config "..check)
	end
end

return function(config,playerAdmin)
	configData = config
	for _,v in ipairs(script.ClientChecks:GetChildren()) do
		checks[v.Name] = require(v)
	end
	
	re.OnServerEvent:Connect(function(player,method,...)
		if method == "hbeDetection" then
			loadCheck(player,"HBE",...)
		elseif method == "kick" then
			player:Kick()
		end
	end)
	rf.OnServerInvoke = function(player,method,...)
		local args = {...}
		if method == "getConfig" then
			if args[1] then
				if configData.checks[args[1]] then
					return configData.checks[args[1]]
				else
					player:Kick()
				end
			else
				player:Kick()
			end
		elseif method == "getScreenData" then
			if playerAdmin.requestPlayerState(player) then
				if args[1] then
					if args[1]:IsA("Player") then
						local dat1 = nil
						local dat2 = nil
						local success,err = pcall(function()
							dat1,dat2 = rf:InvokeClient(args[1],"screen")
						end)
						return dat1,dat2
					end
				end
			else
				player:Kick(string.format("Possible system error:\nWe could not detect the Screenwatch file data for you."))
			end
		end
	end
	local apiFolder = game.ReplicatedStorage:WaitForChild("MadAntiCheatAPI")
	local apiRF = apiFolder:WaitForChild("ApiRF") :: BindableFunction
	apiRF.OnInvoke = function(functionName,method,...)
		if apiFunctions[functionName] then
			local args = {...}
			local response = nil
			local success,err = pcall(function()
				response = apiFunctions[functionName](method,table.unpack(args))
			end)
			if not success then
				warn("API error: Function: "..functionName.." Method: "..method.." Error: "..err)
			end
			return response
		else
			warn("No API function found.")
		end
	end
end
