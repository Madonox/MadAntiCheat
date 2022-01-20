-- Madonox
-- 2022

--[[
	ConfigTableData:
	checkTime,multiplier
]]

local rf = game.ReplicatedStorage:WaitForChild("MadAntiCheatRF") :: RemoteFunction

local function pingClient(player)
	local response = false
	local success,err = pcall(function()
		response = rf:InvokeClient(player)
	end)
	return response
end

return {
	function(player:Player,confData)
		task.spawn(function()
			local mainWaitTime = confData[1]
			local returnPoint = nil
			local teleportBack = false
			
			while true do
				if pingClient(player) == false then
					local char = player.Character
					if char then
						if char.Humanoid.Health > 0 then
							local currentPos = char.PrimaryPart.CFrame
							returnPoint = currentPos
							teleportBack = true
						end
					end
				elseif teleportBack == true then
					teleportBack = false
					if returnPoint then
						local char = player.Character
						if char then
							if char.Humanoid.Health > 0 then
								char:PivotTo(returnPoint)
							end
						end
					end
				end
				task.wait(mainWaitTime)
			end
		end)
	end;
	
	{"checkTime"};
}
