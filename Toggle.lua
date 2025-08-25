pcall(function() game.CoreGui:FindFirstChild("FlashGUI"):Destroy() end)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local normalSpeed = 16
local currentSpeed = 70
local maxSpeed = 300
local accelerationRate = 5
local isFlash = false

-- Sounds
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local rumble = Instance.new("Sound", hrp)
rumble.SoundId = "rbxassetid://1837635124"
rumble.Looped = true
rumble.Volume = 1

local zap = Instance.new("Sound", hrp)
zap.SoundId = "rbxassetid://138218317"
zap.Volume = 1

-- Trail Colors
local trailColor = ColorSequence.new(Color3.fromRGB(255, 0, 0)) -- Main
local bodyTrailColor = ColorSequence.new(Color3.fromRGB(255, 255, 0)) -- Body
local electricTrails = {}

local function lightningTrail()
	local a0 = Instance.new("Attachment", hrp)
	local a1 = Instance.new("Attachment", hrp)
	a0.Position = Vector3.new(0, 2, 0)
	a1.Position = Vector3.new(0, -2, 0)

	local trail = Instance.new("Trail", hrp)  
	trail.Attachment0 = a0  
	trail.Attachment1 = a1  
	trail.Color = trailColor  
	trail.Lifetime = 0.3  
	trail.WidthScale = NumberSequence.new({  
		NumberSequenceKeypoint.new(0, 1.2),   
		NumberSequenceKeypoint.new(1, 0)  
	})  
	trail.Transparency = NumberSequence.new(0.2)  
	trail.LightEmission = 1  

	Debris:AddItem(trail, 1)  
	Debris:AddItem(a0, 1)  
	Debris:AddItem(a1, 1)
end

local function createElectricTrails()
	local parts = {
		{part = char:FindFirstChild("Head"), offset = Vector3.new(0, 0.4, 0)},
		{part = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm"), offset = Vector3.new(0, -0.5, 0)},
		{part = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm"), offset = Vector3.new(0, -0.5, 0)},
		{part = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg"), offset = Vector3.new(0, -0.5, 0)},
		{part = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg"), offset = Vector3.new(0, -0.5, 0)},
		{part = hrp, offset = Vector3.new(0.5, 1, 0)}
	}
	for _, info in ipairs(parts) do  
		if info.part then  
			local att0 = Instance.new("Attachment", info.part)  
			local att1 = Instance.new("Attachment", info.part)  
			att0.Position = info.offset  
			att1.Position = info.offset + Vector3.new(0, -0.3, 0)  
			local trail = Instance.new("Trail", info.part)  
			trail.Attachment0 = att0  
			trail.Attachment1 = att1  
			trail.Color = bodyTrailColor  
			trail.Lifetime = 0.2  
			trail.Transparency = NumberSequence.new(0.15)  
			trail.WidthScale = NumberSequence.new(0.35)  
			trail.LightEmission = 1  
			table.insert(electricTrails, trail)  
			table.insert(electricTrails, att0)  
			table.insert(electricTrails, att1)  
		end  
	end
end

local function destroyElectricTrails()
	for _, obj in pairs(electricTrails) do
		if obj and obj.Parent then obj:Destroy() end
	end
	electricTrails = {}
end

local function startShaking()
	while isFlash do
		if humanoid.MoveDirection.Magnitude < 0.1 then
			local offset = Vector3.new(
				math.random(-8, 8) * 0.1,
				math.random(-8, 8) * 0.1,
				math.random(-8, 8) * 0.1
			)
			pcall(function()
				hrp.CFrame = hrp.CFrame * CFrame.new(offset)
			end)
		end
		task.wait(0.03)
	end
end

local function toggleFlash()
	isFlash = not isFlash
	if isFlash then
		currentSpeed = 70
		rumble:Play()
		TweenService:Create(cam, TweenInfo.new(0.3), {FieldOfView = 100}):Play()
		createElectricTrails()
		task.spawn(function()
			while isFlash do
				local moving = humanoid.MoveDirection.Magnitude > 0.1  
				if moving then  
					currentSpeed = math.min(currentSpeed + accelerationRate, maxSpeed)  
					lightningTrail()  
					if not zap.IsPlaying and math.random() < 0.15 then zap:Play() end  
				else  
					currentSpeed = normalSpeed  
				end  
				humanoid.WalkSpeed = currentSpeed  

				-- Smooth Blur and FOV effect based on speed
if currentSpeed > 150 then
	local targetBlur = math.clamp((currentSpeed - 150) * 0.1, 0, 0)
	local targetFOV = math.clamp(70 + (currentSpeed - 150) * 0.1, 80, 100)

	TweenService:Create(blur, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = targetBlur
	}):Play()

	TweenService:Create(cam, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		FieldOfView = targetFOV
	}):Play()
else
	TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = 0
	}):Play()

	TweenService:Create(cam, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		FieldOfView = 70
	}):Play()
end

				task.wait(0.08)  
			end
		end)
		task.spawn(startShaking)
	else
		humanoid.WalkSpeed = normalSpeed
		rumble:Stop()
		blur.Size = 0
		currentSpeed = normalSpeed
		TweenService:Create(cam, TweenInfo.new(0.3), {FieldOfView = 70}):Play()
		destroyElectricTrails()
	end
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FlashGUI"
gui.ResetOnSpawn = false

-- Flash Toggle Button
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 140, 0, 50)
btn.Position = UDim2.new(0, 20, 1, -110)
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Text = "Toggle ⚡️"
btn.TextSize = 16
btn.Font = Enum.Font.SourceSansBold
btn.TextColor3 = Color3.new(0, 0, 0)
btn.BorderSizePixel = 2
btn.Draggable = true
btn.Active = true
btn.MouseButton1Click:Connect(toggleFlash)

-- Color Panel
local colorGui = Instance.new("Frame", gui)
colorGui.Size = UDim2.new(0, 140, 0, 120)
colorGui.Position = UDim2.new(0, 20, 1, -230)
colorGui.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
colorGui.BorderSizePixel = 2
colorGui.Visible = false

local function createColorBtn(text, mainColor, bodyColor, y)
	local b = Instance.new("TextButton", colorGui)
	b.Size = UDim2.new(1, 0, 0, 30)
	b.Position = UDim2.new(0, 0, 0, y)
	b.Text = text
	b.BackgroundColor3 = mainColor
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 14
	b.MouseButton1Click:Connect(function()
		trailColor = ColorSequence.new(mainColor)
		bodyTrailColor = ColorSequence.new(bodyColor)
	end)
end
