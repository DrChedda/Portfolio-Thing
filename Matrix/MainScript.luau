local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local topModel = script.Parent
local landscape = topModel:WaitForChild("ActiveState")
local entrance = topModel:WaitForChild("EntrancePoint")

-- CONFIGURATION
local INITIAL_SPEED = 15 
local BATCH_SIZE = 8    
local SNAP_TIME = 1.0   
local SCAN_COLOR = Color3.fromRGB(0, 255, 70)

local isActive = false
local isProcessing = false
local sortedLandscape = {}

-- PRE-PROCESS EVERYTHING
for _, obj in ipairs(landscape:GetDescendants()) do
	if obj:IsA("BasePart") then
		local data = {
			Instance = obj,
			IsWall = false,
			TargetTransparency = obj.Transparency,
			TargetCanCollide = obj.CanCollide,
			TargetMaterial = obj.Material,
			TargetColor = obj.Color,
			Distance = (obj.Position - entrance.Position).Magnitude
		}

		local sGui = obj:FindFirstChildOfClass("SurfaceGui")
		if sGui then
			local gridImg = sGui:FindFirstChild("MatrixGrid")
			local spaceImg = sGui:FindFirstChild("SpaceLabel")

			if gridImg and spaceImg then
				data.IsWall = true
				data.GridOverlay = gridImg
				data.SpaceImage = spaceImg

				spaceImg.ImageTransparency = 1
				gridImg.ImageTransparency = 0
				gridImg.ImageColor3 = SCAN_COLOR
			end
		end

		table.insert(sortedLandscape, data)

		obj.Transparency = 1
		obj.CanCollide = false

		-- Turn it Green and Neon at the very start
		if not data.IsWall then
			obj.Color = SCAN_COLOR
			obj.Material = Enum.Material.Neon
		end
	end
end

table.sort(sortedLandscape, function(a, b) return a.Distance < b.Distance end)

local function toggleLandscape(enable)
	if isProcessing or isActive == enable then return end
	isActive = enable
	isProcessing = true
	local startTime = os.clock()

	for i = 1, #sortedLandscape, BATCH_SIZE do
		if isActive ~= enable then break end 

		local currentDistance = sortedLandscape[i].Distance
		local targetTime = currentDistance / INITIAL_SPEED

		while (os.clock() - startTime) < targetTime do RunService.Heartbeat:Wait() end

		for j = 0, BATCH_SIZE - 1 do
			local index = i + j
			local data = sortedLandscape[index]
			if not data then break end
			local obj = data.Instance

			if enable then
				if data.IsWall then
					TweenService:Create(data.SpaceImage, TweenInfo.new(SNAP_TIME), {ImageTransparency = 0}):Play()

					local gridTween = TweenService:Create(data.GridOverlay, TweenInfo.new(SNAP_TIME), {ImageTransparency = 1})
					gridTween:Play()

					gridTween.Completed:Connect(function()
						if data.GridOverlay then
							data.GridOverlay:Destroy()
						end
					end)

					obj.Transparency = 0 
				else
					TweenService:Create(obj, TweenInfo.new(SNAP_TIME/2), {Transparency = data.TargetTransparency}):Play()
					obj.CanCollide = data.TargetCanCollide

					task.delay(SNAP_TIME/2, function()
						TweenService:Create(obj, TweenInfo.new(SNAP_TIME), {Color = data.TargetColor}):Play()
						task.delay(SNAP_TIME, function() 
							if isActive == enable then obj.Material = data.TargetMaterial end
						end)
					end)
				end
			end
		end
	end
	isProcessing = false
end

-- PLAYER INTERACTION
entrance.Touched:Connect(function(hit)
	local char = hit.Parent
	if char:FindFirstChild("Humanoid") and not isActive and not isProcessing then
		toggleLandscape(true)
	end
end)