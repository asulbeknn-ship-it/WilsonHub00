--[[
	ТОЛЫҚ ЖАҢАРТЫЛҒАН LOCAL SCRIPT
	Ескі скриптіңізді осымен толық алмастырыңыз
]]

-- Services and Player
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Remote Event for visuals
local visualsEvent = replicatedStorage:WaitForChild("VisualsEvent")

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false
screenGui.Name = "TouchGUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Draggable Frame (Көлемін үлкейттік, себебі жаңа батырма қосылды)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 305) -- Биіктігін 260-тан 305-ке өзгерттік
frame.Position = UDim2.new(0.5, -110, 0.5, -152)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "Hide GUI"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = screenGui
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 20)
infoLabel.Position = UDim2.new(0, 5, 0, 5)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "(⚠️Only Works in Troll is a Pinning Tower 2 ⚠️)"
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.SourceSansBold
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.Parent = frame

-- Loop Touch Button
local loopButton = Instance.new("TextButton")
loopButton.Size = UDim2.new(1, -20, 0, 35)
loopButton.Position = UDim2.new(0, 10, 0, 30)
loopButton.Text = "Loop Touch: Off"
loopButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
loopButton.TextColor3 = Color3.new(1, 1, 1)
loopButton.Font = Enum.Font.SourceSansBold
loopButton.TextSize = 18
loopButton.Parent = frame
Instance.new("UICorner", loopButton).CornerRadius = UDim.new(0, 10)

-- Walk on Air Button
local airButton = Instance.new("TextButton")
airButton.Size = UDim2.new(1, -20, 0, 35)
airButton.Position = UDim2.new(0, 10, 0, 75)
airButton.Text = "WalkOnAir: Off"
airButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
airButton.TextColor3 = Color3.new(1, 1, 1)
airButton.Font = Enum.Font.SourceSansBold
airButton.TextSize = 18
airButton.Parent = frame
Instance.new("UICorner", airButton).CornerRadius = UDim.new(0, 10)

-- Tool Button
local toolButton = Instance.new("TextButton")
toolButton.Size = UDim2.new(1, -20, 0, 35)
toolButton.Position = UDim2.new(0, 10, 0, 120)
toolButton.Text = "Get Fire Part Tool"
toolButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toolButton.TextColor3 = Color3.new(1, 1, 1)
toolButton.Font = Enum.Font.SourceSansBold
toolButton.TextSize = 18
toolButton.Parent = frame
Instance.new("UICorner", toolButton).CornerRadius = UDim.new(0, 10)

-- Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 35)
teleportButton.Position = UDim2.new(0, 10, 0, 165)
teleportButton.Text = "Teleport to Button"
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 18
teleportButton.Parent = frame
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 10)

-- Fly GUI Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1, -20, 0, 35)
flyButton.Position = UDim2.new(0, 10, 0, 210)
flyButton.Text = "Fly GUI Script"
flyButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18
flyButton.Parent = frame
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 10)

-- ========== ЖАҢА КОД БАСТАЛДЫ ==========

-- Team Wilson Visuals Button
local teamWilsonButton = Instance.new("TextButton")
teamWilsonButton.Size = UDim2.new(1, -20, 0, 35)
teamWilsonButton.Position = UDim2.new(0, 10, 0, 255) -- Ең соңғы батырманың астына қойдық
teamWilsonButton.Text = "Team Wilson FX: Off"
teamWilsonButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
teamWilsonButton.TextColor3 = Color3.new(1, 1, 1)
teamWilsonButton.Font = Enum.Font.SourceSansBold
teamWilsonButton.TextSize = 18
teamWilsonButton.Parent = frame
Instance.new("UICorner", teamWilsonButton).CornerRadius = UDim.new(0, 10)

-- ========== ЖАҢА КОД АЯҚТАЛДЫ ==========

-- Touch Simulation Function
local function touchPartAsync(part)
	local character = player.Character
	if not character then return end
	for _, bodyPart in ipairs(character:GetDescendants()) do
		if bodyPart:IsA("BasePart") then
			task.spawn(function()
				firetouchinterest(bodyPart, part, 0)
				task.wait(0.05)
				firetouchinterest(bodyPart, part, 1)
			end)
		end
	end
end

-- Loop Touch Logic
local loopTouching = false
loopButton.MouseButton1Click:Connect(function()
	loopTouching = not loopTouching
	if loopTouching then
		loopButton.Text = "Loop Touch: On"
		loopButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		loopButton.Text = "Loop Touch: Off"
		loopButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	end

	while loopTouching and task.wait(1) do
		for _, part in ipairs(workspace:GetDescendants()) do
			if part:IsA("BasePart") and (part.Name == "사라지는 파트" or part.Name == "Gudock" or part.Name == "Part") then
				touchPartAsync(part)
			end
		end
	end
end)

-- Walk on Air Logic
local walkOnAir = false
local airPart = Instance.new("Part")
airPart.Size = Vector3.new(6, 1, 6)
airPart.Anchored = true
airPart.Transparency = 1
airPart.CanCollide = true
airPart.Name = "AirPlatform"
airPart.Parent = workspace

airButton.MouseButton1Click:Connect(function()
	walkOnAir = not walkOnAir
	if walkOnAir then
		airButton.Text = "WalkOnAir: On"
		airButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		airButton.Text = "WalkOnAir: Off"
		airButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		airPart.Position = Vector3.new(0, -500, 0)
	end
end)

runService.RenderStepped:Connect(function()
	if walkOnAir and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		airPart.Position = hrp.Position - Vector3.new(0, 3.5, 0)
	end
end)

-- Tool Logic
toolButton.MouseButton1Click:Connect(function()
	local backpack = player:FindFirstChildOfClass("Backpack")
	local existingTool = backpack and backpack:FindFirstChild("Fire Part") or player.Character and player.Character:FindFirstChild("Fire Part")

	toolButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	task.delay(0.1, function() toolButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) end)

	if existingTool then
		existingTool:Destroy()
	else
		local tool = Instance.new("Tool")
		tool.RequiresHandle = false
		tool.Name = "Fire Part"
		tool.Parent = player.Backpack
		tool.Activated:Connect(function()
			local mouse = player:GetMouse()
			if mouse and mouse.Target then
				touchPartAsync(mouse.Target)
			end
		end)
	end
end)

-- Teleport Logic
teleportButton.MouseButton1Click:Connect(function()
	local gudockPart = workspace:FindFirstChild("Gudock")
	if gudockPart and player.Character then
		player.Character:MoveTo(gudockPart.Position + Vector3.new(0, 5, 0))
	else
		print("Gudock part not found!")
	end
end)

-- Fly GUI Script Execution
flyButton.MouseButton1Click:Connect(function()
	pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/Y1G9RJgE"))() end)
end)


-- ========== ЖАҢА КОД БАСТАЛДЫ ==========

-- Team Wilson Visuals Logic
local teamWilsonFXOn = false
teamWilsonButton.MouseButton1Click:Connect(function()
	teamWilsonFXOn = not teamWilsonFXOn
	if teamWilsonFXOn then
		teamWilsonButton.Text = "Team Wilson FX: On"
		teamWilsonButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		teamWilsonButton.Text = "Team Wilson FX: Off"
		teamWilsonButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	end
	-- Серверге осы ойыншы үшін визуалды қосу/өшіру туралы сигнал жіберу
	visualsEvent:FireServer(teamWilsonFXOn)
end)

-- ========== ЖАҢА КОД АЯҚТАЛДЫ ==========

-- Notification
pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Script Loaded!🔥",
		Text = "Thanks for using my Script!, Enjoy ^^",
		Duration = 5
	})
end)

-- Toggle GUI Visibility
local shown = true
toggleButton.MouseButton1Click:Connect(function()
	shown = not shown
	frame.Visible = shown
	toggleButton.Text = shown and "Hide GUI" or "Show GUI"
end)

-- Keep Toggle Button Above Frame
runService.RenderStepped:Connect(function()
	local framePosition = frame.Position
	local frameSize = frame.Size
	local toggleButtonSize = toggleButton.Size
	toggleButton.Position = UDim2.new(
		framePosition.X.Scale, framePosition.X.Offset + (frameSize.X.Offset / 2) - (toggleButtonSize.X.Offset / 2),
		framePosition.Y.Scale, framePosition.Y.Offset - toggleButtonSize.Y.Offset - 5
	)
end)
