local RunService = game:GetService("RunService")
local proximityPrompt = workspace.Prompt.ProximityPrompt
local player = game.Players.LocalPlayer
local gui = script.Parent
local closeBtn = gui.Frame.Close
local maxDistance = 15

proximityPrompt.Triggered:Connect(function()
	if gui.Enabled == false then 
		gui.Enabled = true
		proximityPrompt.Enabled = false
	else
		print("gui is already open")
	end
end)

local function close()
	gui.Enabled = false
	proximityPrompt.Enabled = true
end

RunService.Heartbeat:Connect(function()
	if gui.Enabled then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local distance = (character.HumanoidRootPart.Position - proximityPrompt.Parent.Position).Magnitude
			if distance > maxDistance then
				close()
			end
		end
	end
end)

closeBtn.MouseButton1Click:Connect(close)

