-- Madonox
-- 2022

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")

local gameLoaded = false
local windowMinimized = false

local re = game.ReplicatedStorage:WaitForChild("MadAntiCheatRE") :: RemoteEvent
local rf = game.ReplicatedStorage:WaitForChild("MadAntiCheatRF") :: RemoteFunction

script.DataFetcher.Changed:Connect(function()
	if script.DataFetcher.Disabled == true then
		re:FireServer("kick")
		player:Kick()
		script.DataFetcher.Disabled = false
	end
end)

game.Workspace.DescendantAdded:Connect(function(desc)
	if desc:IsA("Humanoid") then
		if not desc:FindFirstChild("_HumanoidDescription") then
			local humanoidRig = desc.Parent
			for _,part in ipairs(humanoidRig:GetDescendants()) do
				if part:IsA("BasePart") then
					part:GetPropertyChangedSignal("Size"):Connect(function()
						if gameLoaded == true then
							game.ReplicatedStorage.MadAntiCheatRE:FireServer("hbeDetection",part,part.Size)
						end
					end)
				end
			end
			local marker = Instance.new("ObjectValue")
			marker.Name = "_HumanoidDescription"
			marker.Parent = desc
		end
	end
end)
for _,desc in ipairs(workspace:GetDescendants()) do
	if desc:IsA("Humanoid") then
		if not desc:FindFirstChild("_HumanoidDescription") then
			local humanoidRig = desc.Parent
			for _,part in ipairs(humanoidRig:GetDescendants()) do
				if part:IsA("BasePart") then
					part:GetPropertyChangedSignal("Size"):Connect(function()
						if gameLoaded == true then
							game.ReplicatedStorage.MadAntiCheatRE:FireServer("hbeDetection",part,part.Size)
						end
					end)
				end
			end
			local marker = Instance.new("ObjectValue")
			marker.Name = "_HumanoidDescription"
			marker.Parent = desc
		end
	end
end

gameLoaded = game:IsLoaded()

game.Loaded:Connect(function()
	gameLoaded = true
end)

local function startMemoryCheck()
	task.spawn(function()
		while windowMinimized == true do
			local current = StatsService:GetMemoryUsageMbForTag("LuaHeap")
			wait()
			local new = StatsService:GetMemoryUsageMbForTag("LuaHeap")
			if new ~= current and new - current > 6 then
				player:Kick()
			end
		end
	end)
end
if rf:InvokeServer("getConfig","Injection").enabled == true then
	UserInputService.WindowFocused:Connect(function()
		windowMinimized = false
	end)
	UserInputService.WindowFocusReleased:Connect(function()
		windowMinimized = true
		startMemoryCheck()
	end)
end
