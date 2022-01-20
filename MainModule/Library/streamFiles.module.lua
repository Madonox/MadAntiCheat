-- Madonox
-- 2022

local StreamFiles = {}

function StreamFiles.streamLocalScriptsAll(files)
	for _,player in ipairs(game.Players:GetPlayers()) do
		for _,file in ipairs(files) do
			local clone = file:Clone()
			for _,localFile in ipairs(clone:GetDescendants()) do
				if localFile:IsA("LocalScript") then
					localFile.Disabled = false
				end
			end
			clone.Parent = player:WaitForChild("PlayerGui")
			clone.Disabled = false
		end
	end
end
function StreamFiles.streamLocalScriptsPlayer(player,files)
	for _,file in ipairs(files) do
		local clone = file:Clone()
		for _,localFile in ipairs(clone:GetDescendants()) do
			if localFile:IsA("LocalScript") then
				localFile.Disabled = false
			end
		end
		clone.Parent = player:WaitForChild("PlayerGui")
		clone.Disabled = false
	end
end

return StreamFiles
