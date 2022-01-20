-- Madonox
-- 2022

local MadAntiCheatAPI = {}

local folder = nil
local re = nil
local rf = nil
local api = {}

function MadAntiCheatAPI.init(apiFunctions)
	folder = game.ReplicatedStorage.MadAntiCheatAPI
	re = folder.ApiRE
	rf = folder.ApiRF
	api = apiFunctions
end
function MadAntiCheatAPI.invoke(functionName,method,...)
	if api[functionName] then
		local args = {...}
		local response = nil
		local success,err = pcall(function()
			response = api[functionName](method,table.unpack(args))
		end)
		if not success then
			warn("API error: Function: "..functionName.." Method: "..method.." Error: "..err)
		end
		return response
	else
		warn("No API function found.")
	end
end
function MadAntiCheatAPI.invokeClient(functionName,method,...)
	local res = nil
	local args = {...}
	local success,err = pcall(function()
		res = rf:Invoke(functionName,method,args)
	end)
	if not success then
		warn("API error: "..err)
	end
	return res
end

return MadAntiCheatAPI
