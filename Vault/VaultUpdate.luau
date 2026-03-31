local ReplicatedStorage = game:GetService("ReplicatedStorage")
local getVaultFunc = ReplicatedStorage:WaitForChild("GetVaultItems")
local withdrawEvent = ReplicatedStorage:WaitForChild("WithdrawItem")
local vaultFrame = script.Parent

local function refreshVault()
	local itemsInVault = getVaultFunc:InvokeServer() 

	for _, child in pairs(vaultFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child.Text = "Empty"
		end
	end

	local buttons = {}
	for _, child in pairs(vaultFrame:GetChildren()) do
		if child:IsA("TextButton") then table.insert(buttons, child) end
	end

	for i, itemName in ipairs(itemsInVault) do
		if buttons[i] then
			buttons[i].Text = itemName

			local connection
			connection = buttons[i].MouseButton1Click:Connect(function()
				if buttons[i].Text ~= "Empty" then
					withdrawEvent:FireServer(itemName)
					connection:Disconnect()
					task.wait(0.2)
					refreshVault() 
				end
			end)
		end
	end
end

vaultFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	if vaultFrame.Visible then
		refreshVault()
	end
end)