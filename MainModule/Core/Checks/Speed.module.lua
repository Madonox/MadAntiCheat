-- Madonox
-- 2022

--[[
	ConfigTableData:
	checkTime,multiplier
]]

local ignoredPlayers_1 = {}
local ignoredPlayers = {}

return {
	function(player:Player,confData)
		task.spawn(function()
			local waitTime = confData[1]*2
			local mainWaitTime = confData[1]
			local ignoreNextCheck = false
			while true do
				local char = player.Character
				if char then
					if char.PrimaryPart then
						local currentPos = char.PrimaryPart.Position
						local currentSpeed = char:FindFirstChildOfClass("Humanoid").WalkSpeed
						task.delay(mainWaitTime,function()
							if char then
								if char.PrimaryPart then
									local magnitude = (currentPos-char.PrimaryPart.Position).Magnitude
									local nowSpeed = char:FindFirstChildOfClass("Humanoid").WalkSpeed
									local maxSpeed = math.max(currentSpeed,nowSpeed)
									local maxTravel = maxSpeed+maxSpeed*confData[2]*mainWaitTime
									if (magnitude > maxTravel) and (ignoreNextCheck == false) and (not table.find(ignoredPlayers,player)) then
										if ignoreNextCheck == false then
											if not table.find(ignoredPlayers_1,player) then
												ignoreNextCheck = true
												char.PrimaryPart.Anchored = true
												char:PivotTo(CFrame.new(currentPos))
												delay(mainWaitTime/4,function()
													char.PrimaryPart.Anchored = false
												end)
											else
												table.remove(ignoredPlayers_1,table.find(ignoredPlayers_1,player))
											end
										else
											ignoreNextCheck = false
										end
									end
								end
							end
						end)
					end
				end
				task.wait(waitTime)
			end
		end)
	end;
	
	{"checkTime","distanceMultiplier"};
	
	function(method,...) -- API function.
		local args = {...}
		if method == "ignorePlayerNext" then
			if args[1] then
				if args[1]:IsA("Player") then
					table.insert(ignoredPlayers_1,args[1])
				else
					warn("API: Speed: "..args[1].." is not a valid player!")
				end
			end
		elseif method == "ignorePlayer" then
			if args[1] then
				if args[1]:IsA("Player") then
					table.insert(ignoredPlayers,args[1])
				else
					warn("API: Speed: "..args[1].." is not a valid player!")
				end
			end
		else
			warn("API: Speed: "..method.." is not a valid method!")
		end
	end;
}
