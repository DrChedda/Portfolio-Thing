local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local textLabel = script.Parent

local function updateCoordinates()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local position = character.HumanoidRootPart.Position
		textLabel.Text = string.format("%.0f X, %.0f Z", position.X, position.Z)
	else 
		textLabel.Text = "Loading coordinates..."
	end
end

RunService.RenderStepped:Connect(updateCoordinates)