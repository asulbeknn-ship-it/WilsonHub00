local GUI_TITLE = "WILSONGUI V 1.0.0 BY WILLIAM"
local GUI_MAIN_COLOR = Color3.fromRGB(0, 0, 255)
local ICON_BACKGROUND_COLOR = Color3.fromRGB(25, 25, 25)
local ICON_BORDER_COLOR = Color3.fromRGB(0, 0, 255)
local ICON_ASSET_ID = "rbxassetid://121928953984347"

local UserInputService = game:GetService("UserInputService")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WilsonGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
mainFrame.BackgroundColor3 = GUI_MAIN_COLOR
mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Visible = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 139)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Text = GUI_TITLE
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Text = "X"
closeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -10, 1, -35)
contentFrame.Position = UDim2.new(0, 5, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, 0, 1, 0)
buttonContainer.Parent = contentFrame
buttonContainer.BackgroundTransparency = 1
buttonContainer.BorderSizePixel = 0
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
buttonContainer.ScrollBarThickness = 6
buttonContainer.ScrollingEnabled = true
buttonContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 5)
padding.Parent = buttonContainer

local gridLayout = Instance.new("UIGridLayout")
gridLayout.Parent = buttonContainer
gridLayout.CellSize = UDim2.new(0, 140, 0, 40)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.FillDirectionMaxCells = 3
gridLayout.StartCorner = Enum.StartCorner.TopLeft

local iconButton = Instance.new("ImageButton")
iconButton.Name = "IconButton"
iconButton.Size = UDim2.new(0, 60, 0, 60)
iconButton.BackgroundColor3 = ICON_BACKGROUND_COLOR
iconButton.Image = ICON_ASSET_ID
iconButton.Visible = false
iconButton.Parent = screenGui

local cornerForIcon = Instance.new("UICorner")
cornerForIcon.CornerRadius = UDim.new(0, 8)
cornerForIcon.Parent = iconButton

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = ICON_BORDER_COLOR
iconStroke.Thickness = 2
iconStroke.Parent = iconButton

local function makeDraggable(triggerObject, objectToDrag)
	local dragging = false
	local startPosition
	local lastPosition
	triggerObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPosition = input.Position
			lastPosition = objectToDrag.Position
		end
	end)
	triggerObject.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startPosition
			objectToDrag.Position = UDim2.new(lastPosition.X.Scale, lastPosition.X.Offset + delta.X, lastPosition.Y.Scale, lastPosition.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(titleBar, mainFrame)
makeDraggable(iconButton, iconButton)

local isFirstClose = true
closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	if isFirstClose then
		iconButton.Position = UDim2.new(0.5, -30, 0.5, -30)
		isFirstClose = false
	end
	iconButton.Visible = true
end)

iconButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	iconButton.Visible = false
end)

local function CreateScriptButton(buttonText, scriptFunction)
	local button = Instance.new("TextButton")
	button.Name = buttonText
	button.Text = buttonText
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 139)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 16
	button.Parent = buttonContainer
	if scriptFunction then
		button.MouseButton1Click:Connect(scriptFunction)
	end
end

screenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

task.spawn(function()
    task.wait(2)

    local player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    
    local WatermarkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    WatermarkGui.Name = "WilsonHubWatermark"
    WatermarkGui.ResetOnSpawn = false
    WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    WatermarkGui.IgnoreGuiInset = true

    local WatermarkLabel = Instance.new("TextLabel", WatermarkGui)
    WatermarkLabel.Name = "WatermarkLabel"
    WatermarkLabel.AnchorPoint = Vector2.new(0, 1)
    WatermarkLabel.Position = UDim2.new(0, 10, 1, -10)
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.Font = Enum.Font.SourceSansSemibold
    WatermarkLabel.TextSize = 18
    WatermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local TextStroke = Instance.new("UIStroke", WatermarkLabel)
    TextStroke.Color = Color3.fromRGB(0, 0, 0)
    TextStroke.Thickness = 1.2
    TextStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    RunService.Heartbeat:Connect(function()
        local currentTime = os.date("%H:%M:%S")
        local watermarkText = string.format("Build WILSONGUI || V 1.0.0 || %s || %s", player.Name, currentTime)
        WatermarkLabel.Text = watermarkText
    end)
end)

CreateScriptButton("WilsonHub", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WILSONHUB1.lua"))() end)
CreateScriptButton("GhostHub", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))() end)
CreateScriptButton("Fly", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-GUI-minicapy-46765"))() end)
CreateScriptButton("Gravitate", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Gravitate.lua"))() end)
CreateScriptButton("FireParts", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Auto-fire-part-universal-/refs/heads/main/Auto%20fire%20part%20universal"))() end)
CreateScriptButton("Infiniteyield", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()  end)
CreateScriptButton("Anti-slap", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Antislap.lua"))() end)
CreateScriptButton("Spamdecal", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Decalspam.lua"))() end)
CreateScriptButton("Spamdecal2", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Spamdecalwilson.lua"))() end)
CreateScriptButton("JohnDoe", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Client-Replication-John-doe-up-by-gojohdkaisenkt-34198"))() end)
CreateScriptButton("Jerk", function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script") end)
CreateScriptButton("Spamchat", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/spamchat.lua"))() end)
CreateScriptButton("Dance", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Dance.lua"))() end)
CreateScriptButton("Ban hummer", function() loadstring(game:HttpGet("https://pastebin.com/raw/h9NvY2PD"))() end)
CreateScriptButton("Meteor tool", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Meteor.lua"))() end)
CreateScriptButton("Keyboard", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Keyboard.lua"))() end)
CreateScriptButton("Xester", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Prison-Life-Xester-18937"))() end)
CreateScriptButton("Fire tool", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/FireParts.lua"))() end)
CreateScriptButton("Invisible", function() loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))() end)
CreateScriptButton("Telekinesis", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Telekinesis-34345"))() end)
CreateScriptButton("Disco", function()

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator") -- Анимацияны ойнататын сенімдірек әдіс

if animator then
    
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    local danceAnim = Instance.new("Animation")
    danceAnim.AnimationId = "rbxassetid://27789359"

    local danceTrack = animator:LoadAnimation(danceAnim)
    danceTrack.Looped = true -- Анимация қайталанып тұруы үшін
    danceTrack:Play()
end


local TweenService = game:GetService("TweenService")

local function applyRainbowEffect(part)
    
    spawn(function()
        while part and part.Parent do
            
            for i = 0, 1, 0.01 do
                if not part or not part.Parent then break end
                
                local hue = i
                local color = Color3.fromHSV(hue, 1, 1) 

                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
                local goal = {Color = color}
                local tween = TweenService:Create(part, tweenInfo, goal)
                tween:Play()
                wait(0.1)
            end
        end
    end)
end

for _, object in pairs(workspace:GetDescendants()) do
    
    if object:IsA("BasePart") and not object:IsDescendantOf(character) then
        
        if object.Size.X > 10 or object.Size.Y > 10 or object.Size.Z > 10 then
            applyRainbowEffect(object)
        end
    end
end
 end)
CreateScriptButton("666", function()

local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

lighting.Ambient = Color3.fromRGB(100, 0, 0)
lighting.OutdoorAmbient = Color3.fromRGB(80, 0, 0)
lighting.ColorShift_Top = Color3.fromRGB(255, 0, 0)
lighting.FogColor = Color3.fromRGB(50, 0, 0)
lighting.FogEnd = 200
lighting.FogStart = 0


local sky = lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", lighting)
local skyTexture = "rbxassetid://104977457" -- Қызыл-қара ғарыш текстурасы

sky.SkyboxBk = skyTexture
sky.SkyboxDn = skyTexture
sky.SkyboxFt = skyTexture
sky.SkyboxLf = skyTexture
sky.SkyboxRt = skyTexture
sky.SkyboxUp = skyTexture
sky.StarCount = 3000


for _, sound in pairs(workspace:GetChildren()) do
    if sound.Name == "HorrorSound" or sound.Name == "FireSound" then
        sound:Destroy()
    end
end

local fireSound = Instance.new("Sound", workspace)
fireSound.Name = "FireSound"
fireSound.SoundId = "rbxassetid://122222402"
fireSound.Volume = 2
fireSound.Looped = true
fireSound:Play()

local horrorSound = Instance.new("Sound", workspace)
horrorSound.Name = "HorrorSound"
horrorSound.SoundId = "rbxassetid://152679294"
horrorSound.Volume = 3
horrorSound.Looped = true
horrorSound:Play()


for _, part in pairs(workspace:GetDescendants()) do
    if part:IsA("BasePart") and not part:IsDescendantOf(character) then
        
        part.Color = Color3.fromRGB(139, 0, 0)
        
        if part.Material == Enum.Material.Neon then
            part.Color = Color3.fromRGB(255, 20, 20)
        end

        if not part:FindFirstChildOfClass("Fire") then
            local fire = Instance.new("Fire", part)
            fire.Color = Color3.fromRGB(255, 100, 0)
            fire.SecondaryColor = Color3.fromRGB(150, 0, 0)
            fire.Size = 8
        end
    end
end

print("666")
 end)
 CreateScriptButton("Kill all", function() local player = game:GetService("Players").LocalPlayer
local isActive = false

-- Buat GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "KillAllGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 139) -- Warna abu-abu
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

-- Kotak rounded
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 15)

-- Tombol ON/OFF
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0.5, -70, 0, 30)
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Merah untuk OFF
button.Text = "OFF KILL"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20

-- Tulisan bawah
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 30)
label.Position = UDim2.new(0, 0, 1, -30)
label.BackgroundTransparency = 1
label.Text = "KILL ALL BY WILSON"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.SourceSans
label.TextSize = 14

-- Logic tombol
button.MouseButton1Click:Connect(function()
	isActive = not isActive
	if isActive then
		button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		button.Text = "ON KILL"
	else
		button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		button.Text = "OFF KILL"
	end
end)

-- Cek teman
local function isFriendWith(p1, p2)
	return p1:IsFriendsWith(p2.UserId)
end

-- Kill All Logic
game:GetService("RunService").RenderStepped:Connect(function()
	if isActive then
		for _, target in ipairs(game.Players:GetPlayers()) do
			if target ~= player and target.Character and not isFriendWith(player, target) then
				local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					tool:Activate()
					for _, part in ipairs(target.Character:GetChildren()) do
						if part:IsA("BasePart") then
							firetouchinterest(tool.Handle, part, 0)
							firetouchinterest(tool.Handle, part, 1)
						end
					end
				end
			end
		end
	end
end) end)
CreateScriptButton("Univ fireparts", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Paul512-max/Troll-is-a-Pinning-Tower-2-Script-Trolling/refs/heads/main/Troll%20is%20a%20Pinning%20Tower%202%20Script"))() end)
CreateScriptButton("Kill all fortline", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/ExploiterGuy/4d95c83a854d6e7265a43094219d0b00/raw/8bc8d511803b2e5b2a1b6abe70c6e1c994601323/%255B%25F0%259F%2594%25AB%255D%2520Fortline"))() end)
