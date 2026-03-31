local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local scrollingFrame = script.Parent
local vaultBtn1 = game.ReplicatedStorage:WaitForChild("VaultBtn1")
local depositEvent = game.ReplicatedStorage:WaitForChild("DepositItem")
local vaultFrame = scrollingFrame.Parent:FindFirstChild("VaultFrame")

local function updateInventory()
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("GuiButton") then child:Destroy() end
	end

	for _, item in pairs(backpack:GetChildren()) do
		local newSlot = vaultBtn1:Clone()
		newSlot.Text = item.Name
		newSlot.Parent = scrollingFrame

		newSlot.MouseButton1Click:Connect(function()
			depositEvent:FireServer(item.Name)

			task.wait(0.2)

			if vaultFrame and vaultFrame.Visible then
				vaultFrame.Visible = false
				vaultFrame.Visible = true
			end
		end)
	end
end

backpack.ChildAdded:Connect(updateInventory)
backpack.ChildRemoved:Connect(updateInventory)
updateInventory()