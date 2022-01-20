-- Madonox
-- 2022

local player = game.Players.LocalPlayer

local re = game.ReplicatedStorage:WaitForChild("MadAntiCheatRE") :: RemoteEvent
local rf = game.ReplicatedStorage:WaitForChild("MadAntiCheatRF") :: RemoteFunction

local cam = workspace.CurrentCamera
local mouse = player:GetMouse()

script.Parent.Changed:Connect(function()
	if script.Parent.Disabled == true then
		re:FireServer("kick")
		player:Kick()
		script.Parent.Disabled = false
	end
end)

rf.OnClientInvoke = function(method,args)
	if method == "screen" then
		return {mouse.X,mouse.Y},cam.CFrame
	end
end
