local part = script.Parent
local Players = game:GetService("Players")

local targetPosition = Vector3.new(150, 20, -300) 

local globalVariables = require(game:GetService("ReplicatedStorage"):WaitForChild("GlobalVariables"))
local fadeEvent = game:GetService("ReplicatedStorage"):WaitForChild("TeleportFade")

local function onPartTouched(hit)
	if globalVariables.RecentlyTeleported == false then
		local character = hit.Parent
		local player = Players:GetPlayerFromCharacter(character)

		if player and character:FindFirstChild("HumanoidRootPart") then
			globalVariables.RecentlyTeleported = true
			fadeEvent:FireClient(player)
			task.wait(0.5)
			character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
			print("Teleported player to: " .. tostring(targetPosition))
			task.wait(3)
			globalVariables.RecentlyTeleported = false
		end
	end
end

part.Touched:Connect(onPartTouched)
