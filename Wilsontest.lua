--[[
Made by @Nurgazy_21 tg: nurr_wilson
Script name: WilsonHub
version script: 1.1.0
]]

-- Основные сервисы
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ================================================================= --
-- КОНФИГУРАЦИЯ ЧАТА
-- Добавлено 3 резервных сервера для стабильной работы 24/7.
-- ================================================================= --
local CHAT_SETTINGS = {
    API_BACKENDS = {
        "https://wilson-hub-chat-backend.glitch.me",
        "https://wilson-hub-chat-mirror1.glitch.me",
        "https://wilson-hub-chat-mirror2.glitch.me"
    },
    PollRate = 5 -- Частота обновления чата в секундах
}
local current_backend_index = 1
-- ================================================================= --

-- [[ THEMES & SETTINGS ]]
local Themes = {
    Red = { main = Color3.fromRGB(200, 0, 0), accent = Color3.fromRGB(255, 0, 0), text = Color3.fromRGB(255, 255, 255) },
    Yellow = { main = Color3.fromRGB(255, 190, 0), accent = Color3.fromRGB(255, 220, 50), text = Color3.fromRGB(0,0,0) },
    Blue = { main = Color3.fromRGB(0, 120, 255), accent = Color3.fromRGB(50, 150, 255), text = Color3.fromRGB(255,255,255) },
    Green = { main = Color3.fromRGB(0, 180, 0), accent = Color3.fromRGB(50, 220, 50), text = Color3.fromRGB(255,255,255) },
    White = { main = Color3.fromRGB(240, 240, 240), accent = Color3.fromRGB(200, 200, 200), text = Color3.fromRGB(0, 0, 0) }
}
local themableObjects = {}
local settings = { theme = "Red" }
local tabs = {} -- For theme control

if isfile and isfile("WilsonHubSettings.json") then
    pcall(function() settings = HttpService:JSONDecode(readfile("WilsonHubSettings.json")) end)
end
local currentTheme = Themes[settings.theme] or Themes.Red

local rainbowThemeActive = false
local rainbowThemeConnection = nil
local activeTab = nil -- Will be set after GUI creation

-- Forward declare for the functions to see each other
local applyTheme
local activateRainbowTheme

local function updateRainbowColors()
    if not rainbowThemeActive then return end
    
    local hue = tick() % 2 / 2 -- Faster 2 second cycle
    local mainColor = Color3.fromHSV(hue, 0.9, 1)
    local accentColor = Color3.fromHSV(hue, 1, 1)

    local brightness = (mainColor.R * 0.299 + mainColor.G * 0.587 + mainColor.B * 0.114)
    local textColor = brightness > 0.5 and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)

    for _, item in ipairs(themableObjects) do
        if item.object and item.object.Parent then
            if item.colorType == "main" then
                item.object[item.property] = mainColor
            elseif item.colorType == "accent" then
                item.object[item.property] = accentColor
            elseif item.colorType == "text" then
                item.object[item.property] = textColor
            end
        end
    end
    
    if activeTab and activeTab.Parent then
        activeTab.BackgroundColor3 = accentColor
    end
end

activateRainbowTheme = function()
    if rainbowThemeActive and rainbowThemeConnection and rainbowThemeConnection.Connected then
        return
    end
    
    currentTheme = {}
    rainbowThemeActive = true
    settings.theme = "Rainbow"
    if writefile then pcall(function() writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings)) end) end

    if rainbowThemeConnection then rainbowThemeConnection:Disconnect() end
    rainbowThemeConnection = RunService.RenderStepped:Connect(updateRainbowColors)
end

applyTheme = function(themeName)
    if rainbowThemeConnection then
        rainbowThemeConnection:Disconnect()
        rainbowThemeConnection = nil
    end
    rainbowThemeActive = false

    if not Themes[themeName] then themeName = "Red" end
    
    currentTheme = Themes[themeName]
    settings.theme = themeName
    if writefile then pcall(function() writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings)) end) end
    
    for _, item in ipairs(themableObjects) do
        if item.object and item.object.Parent then
            local color = currentTheme[item.colorType]
            if color then
                item.object[item.property] = color
            end
        end
    end

    for _, tab_button in ipairs(tabs) do
        if tab_button and tab_button.Parent then
            tab_button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end

    if activeTab and activeTab.Parent then
        activeTab.BackgroundColor3 = currentTheme.main
    end
end
-- [[ END THEMES ]]

local player = Players.LocalPlayer

-- [[ GUI MODS ФУНКЦИИ ИСПРАВЛЕНЫ]]

local customHealthbarGui = nil
local healthbarConnection = nil

function toggleCustomHealthbar(state)
	if state then
		if player.Character then
			createCustomHealthbar(player.Character)
		end
		healthbarConnection = player.CharacterAdded:Connect(createCustomHealthbar)
	else
		if customHealthbarGui then
			customHealthbarGui:Destroy()
			customHealthbarGui = nil
		end
		if healthbarConnection then
			healthbarConnection:Disconnect()
			healthbarConnection = nil
		end
	end
end

function createCustomHealthbar(character)
	if customHealthbarGui then
		customHealthbarGui:Destroy()
	end
	local head = character:FindFirstChild("Head")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not (head and humanoid) then return end
	customHealthbarGui = Instance.new("BillboardGui", head)
	customHealthbarGui.Name = "CustomHealthbarGui"
	customHealthbarGui.AlwaysOnTop = true
	customHealthbarGui.Size = UDim2.new(0, 150, 0, 40)
	customHealthbarGui.StudsOffset = Vector3.new(0, 2.5, 0)
	local healthbar = Instance.new("Frame", customHealthbarGui)
	healthbar.Name = "Healthbar"
	healthbar.Size = UDim2.new(1, 0, 0, 15)
	healthbar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	healthbar.BorderColor3 = Color3.fromRGB(80, 80, 80)
	healthbar.BorderSizePixel = 1
	Instance.new("UICorner", healthbar).CornerRadius = UDim.new(0, 5)
	local bar = Instance.new("Frame", healthbar)
	bar.Name = "Bar"
	bar.Size = UDim2.new(1, 0, 1, 0)
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 5)
	local text = Instance.new("TextLabel", healthbar)
	text.Name = "Text"
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.TextColor3 = Color3.new(1, 1, 1)
	text.Font = Enum.Font.SourceSansBold
	text.TextSize = 12
	text.TextStrokeTransparency = 0.5
	local function updateHealthbar()
		if not (humanoid and customHealthbarGui and customHealthbarGui.Parent) then return end
		local percentage = humanoid.Health / humanoid.MaxHealth
		local color = Color3.fromHSV(0.33 * percentage, 1, 1)
		bar:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
		bar.BackgroundColor3 = color
		text.Text = math.floor(humanoid.Health) .. " / " .. humanoid.MaxHealth
	end
	humanoid.HealthChanged:Connect(updateHealthbar)
	updateHealthbar()
end

-- ================================================================= --
-- WORLD COLOR CHANGER
-- ================================================================= --
local originalColors = {}
local rainbowConnection = nil
local selectedColor = Color3.fromRGB(255, 0, 255)

function applyWorldColor(color)
	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			local isCharacterPart = false
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character and part:IsDescendantOf(p.Character) then
					isCharacterPart = true
					break
				end
			end
			if not isCharacterPart then
				if not originalColors[part] then
					originalColors[part] = part.Color
				end
				part.Color = color
			end
		end
	end
end

function resetWorldColors()
	if rainbowConnection then
		rainbowConnection:Disconnect()
		rainbowConnection = nil
	end
	for part, color in pairs(originalColors) do
		if part and part.Parent then
			part.Color = color
		end
	end
	originalColors = {}
end

function toggleRainbowMode(state)
	if state then
		if rainbowConnection then
			rainbowConnection:Disconnect()
		end
		rainbowConnection = RunService.Heartbeat:Connect(function()
			local hue = tick() % 5 / 5
			applyWorldColor(Color3.fromHSV(hue, 1, 1))
		end)
	else
		if rainbowConnection then
			rainbowConnection:Disconnect()
			rainbowConnection = nil
		end
	end
end

-- ================================================================= --
-- FPS/PING DISPLAY
-- ================================================================= --
local statsGui = nil
local statsUpdateConnection = nil

function toggleFpsPing(state)
	if state then
		if not (statsGui and statsGui.Parent) then
			createStatsDisplay()
		end
	else
		if statsGui then
			statsGui:Destroy()
			statsGui = nil
		end
		if statsUpdateConnection then
			statsUpdateConnection:Disconnect()
			statsUpdateConnection = nil
		end
	end
end

function createStatsDisplay()
	statsGui = Instance.new("ScreenGui", player.PlayerGui)
	statsGui.Name = "StatsDisplayGui"
	statsGui.ResetOnSpawn = false
	statsGui.Enabled = true
	statsGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	statsGui.DisplayOrder = 999
	local textLabel = Instance.new("TextLabel", statsGui)
	textLabel.Size = UDim2.new(0, 150, 0, 40)
	textLabel.Position = UDim2.new(1, -160, 1, -50)
	textLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	textLabel.BackgroundTransparency = 0.2
	textLabel.BorderSizePixel = 0
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextSize = 16
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Text = " FPS: ...\n PING: ..."
	Instance.new("UICorner", textLabel).CornerRadius = UDim.new(0, 5)
	local lastUpdate = 0
	local frameCounter = 0
	statsUpdateConnection = RunService.Heartbeat:Connect(function(step)
		frameCounter = frameCounter + 1
		local now = tick()
		if now - lastUpdate >= 1 then
			local fps = math.floor(frameCounter / (now - lastUpdate))
			local success, ping = pcall(function() return math.floor(player:GetNetworkPing() * 1000) end)
			if not success then ping = -1 end
			textLabel.Text = string.format(" FPS: %d\n PING: %d ms", fps, ping)
			frameCounter = 0
			lastUpdate = now
		end
	end)
end

-- ================================================================= --
-- PLAYER ESP (НОВАЯ ФУНКЦИЯ)
-- ================================================================= --
local espData = { enabled = false, connections = {}, guis = {} }
local function cleanupEspForPlayer(targetPlayer) if espData.guis[targetPlayer] then if espData.guis[targetPlayer].gui and espData.guis[targetPlayer].gui.Parent then espData.guis[targetPlayer].gui:Destroy() end; if espData.guis[targetPlayer].updateConn then espData.guis[targetPlayer].updateConn:Disconnect() end; espData.guis[targetPlayer] = nil end end
local function cleanupAllEsp() for targetPlayer, _ in pairs(espData.guis) do cleanupEspForPlayer(targetPlayer) end; for _, conn in pairs(espData.connections) do conn:Disconnect() end; espData.connections = {}; espData.guis = {} end
local function createEspForPlayer(targetPlayer) if not espData.enabled or targetPlayer == player then return end; local character=targetPlayer.Character; if not character then return end; local head=character:WaitForChild("Head", 1); if not head then return end; cleanupEspForPlayer(targetPlayer); local espGui=Instance.new("BillboardGui", head); espGui.Name="PLAYER_ESP_GUI"; espGui.AlwaysOnTop=true; espGui.Size=UDim2.new(2,0,1.5,0); espGui.StudsOffset=Vector3.new(0,2.5,0); espGui.LightInfluence=0; local mainFrame=Instance.new("Frame", espGui); mainFrame.BackgroundTransparency=1; mainFrame.Size=UDim2.new(1,0,1,0); local box=Instance.new("Frame", mainFrame); box.BackgroundColor3=Color3.fromRGB(255,255,0); box.BackgroundTransparency=0.5; box.BorderSizePixel=0; box.Size=UDim2.new(1,0,1,0); Instance.new("UICorner",box).CornerRadius=UDim.new(0,3); local innerBox=Instance.new("Frame",box); innerBox.BackgroundColor3=Color3.fromRGB(0,0,0); innerBox.BackgroundTransparency=0.3; innerBox.BorderSizePixel=0; innerBox.Size=UDim2.new(1,-2,1,-2); innerBox.Position=UDim2.new(0.5,-innerBox.AbsoluteSize.X/2,0.5,-innerBox.AbsoluteSize.Y/2); Instance.new("UICorner",innerBox).CornerRadius=UDim.new(0,2); local textLabel=Instance.new("TextLabel",mainFrame); textLabel.BackgroundTransparency=1; textLabel.Size=UDim2.new(1,0,1,0); textLabel.Font=Enum.Font.SourceSans; textLabel.TextSize=14; textLabel.TextColor3=Color3.new(1,1,1); textLabel.TextStrokeColor3=Color3.fromRGB(0,0,0); textLabel.TextStrokeTransparency=0; local function update() if not targetPlayer or not targetPlayer.Parent or not character or not character.Parent or not head or not head.Parent then cleanupEspForPlayer(targetPlayer); return end; local distance=(head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude; textLabel.Text = targetPlayer.Name .. "\n[" .. math.floor(distance) .. "m]" end; espData.guis[targetPlayer] = { gui = espGui, updateConn = RunService.RenderStepped:Connect(update) } end
function togglePlayerEsp(state) espData.enabled=state; if espData.enabled then cleanupAllEsp(); for _,p in ipairs(Players:GetPlayers())do createEspForPlayer(p)end; espData.connections.playerAdded=Players.PlayerAdded:Connect(createEspForPlayer); espData.connections.playerRemoving=Players.PlayerRemoving:Connect(cleanupEspForPlayer); StarterGui:SetCore("SendNotification",{Title="ESP",Text="Player ESP has been enabled.",Duration=5}) else cleanupAllEsp(); StarterGui:SetCore("SendNotification",{Title="ESP",Text="Player ESP has been disabled.",Duration=5}) end end

-- 1. ЭКРАН ЗАГРУЗКИ
local LoadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")); LoadingGui.Name = "LoadingGui"; LoadingGui.ResetOnSpawn = false; LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local Background = Instance.new("Frame", LoadingGui); Background.Size = UDim2.new(1, 0, 1, 0); Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Background.BorderSizePixel = 0
local LoadingLabel = Instance.new("TextLabel", Background); LoadingLabel.Size = UDim2.new(1, 0, 0, 50); LoadingLabel.Position = UDim2.new(0, 0, 0.5, -60); LoadingLabel.BackgroundTransparency = 1; LoadingLabel.TextColor3 = currentTheme.accent; LoadingLabel.Font = Enum.Font.SourceSansBold; LoadingLabel.TextSize = 42; LoadingLabel.Text = "Loading"
local PercentageLabel = Instance.new("TextLabel", Background); PercentageLabel.Size = UDim2.new(1, 0, 0, 30); PercentageLabel.Position = UDim2.new(0, 0, 0.5, 0); PercentageLabel.BackgroundTransparency = 1; PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255); PercentageLabel.Font = Enum.Font.SourceSansBold; PercentageLabel.TextSize = 28; PercentageLabel.Text = "0 %"
local ProgressBarBG = Instance.new("Frame", Background); ProgressBarBG.Size = UDim2.new(0, 400, 0, 25); ProgressBarBG.Position = UDim2.new(0.5, -200, 0.5, 40); ProgressBarBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10); ProgressBarBG.BorderSizePixel = 1; ProgressBarBG.BorderColor3 = currentTheme.main; Instance.new("UICorner", ProgressBarBG).CornerRadius = UDim.new(0, 8)
local ProgressBarFill = Instance.new("Frame", ProgressBarBG); ProgressBarFill.Size = UDim2.new(0, 0, 1, 0); ProgressBarFill.BackgroundColor3 = currentTheme.accent; Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(0, 8)

if settings.theme == "Rainbow" then
    task.spawn(function()
        while LoadingGui and LoadingGui.Parent do
            local hue = tick() % 2 / 2
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            if LoadingLabel and LoadingLabel.Parent then LoadingLabel.TextColor3 = rainbowColor end
            if ProgressBarBG and ProgressBarBG.Parent then ProgressBarBG.BorderColor3 = rainbowColor end
            if ProgressBarFill and ProgressBarFill.Parent then ProgressBarFill.BackgroundColor3 = rainbowColor end
            RunService.RenderStepped:Wait()
        end
    end)
end

-- 2. СОЗДАНИЕ ГЛАВНОГО GUI
task.spawn(function()
    local success, err = pcall(function()
        local WilsonHubGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")); WilsonHubGui.Name = "WilsonHubGui"; WilsonHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; WilsonHubGui.ResetOnSpawn = false; WilsonHubGui.Enabled = false
        local MainFrame = Instance.new("Frame", WilsonHubGui); MainFrame.Name = "MainFrame"; 
        
        MainFrame.Size = UDim2.new(0, 550, 0, 300); 
        MainFrame.Position = UDim2.new(0.5, -275, 0.5, -150);
        
        MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)  
        local IconFrame = Instance.new("TextButton", WilsonHubGui); IconFrame.Name = "IconFrame"; IconFrame.Size = UDim2.new(0, 100, 0, 40); IconFrame.Position = UDim2.new(0, 10, 0, 10); IconFrame.BorderSizePixel = 0; IconFrame.Text = ""; IconFrame.Visible = false; IconFrame.Active = true; IconFrame.Draggable = true; Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)  
        local iconEmoji = Instance.new("TextLabel", IconFrame); iconEmoji.Size = UDim2.new(1, 0, 0.6, 0); iconEmoji.BackgroundTransparency = 1; iconEmoji.Text = "🔥"; iconEmoji.TextColor3 = Color3.fromRGB(255, 255, 255); iconEmoji.Font = Enum.Font.SourceSansBold; iconEmoji.TextSize = 24  
        local iconText = Instance.new("TextLabel", IconFrame); iconText.Size = UDim2.new(1, 0, 0.4, 0); iconText.Position = UDim2.new(0, 0, 0.6, 0); iconText.BackgroundTransparency = 1; iconText.Text = "WILSONHUB"; iconText.TextColor3 = Color3.fromRGB(255, 255, 255); iconText.Font = Enum.Font.SourceSansBold; iconText.TextSize = 12  
        local Header = Instance.new("Frame", MainFrame); Header.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)  
        local TitleLabel = Instance.new("TextLabel", Header); TitleLabel.Size = UDim2.new(1, 0, 1, 0); TitleLabel.BackgroundTransparency = 1; TitleLabel.Text = "HACK WILSONHUB SCRIPTS FOR ROBLOX (V1.1.0)"; TitleLabel.Font = Enum.Font.SourceSansBold; TitleLabel.TextSize = 20  
        local CloseButton = Instance.new("TextButton", Header); CloseButton.Size = UDim2.new(0, 40, 1, 0); CloseButton.Position = UDim2.new(1, -40, 0, 0); CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45); CloseButton.Text = "X"; CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255); CloseButton.Font = Enum.Font.SourceSansBold; CloseButton.TextSize = 20  
        
        local TabsContainer = Instance.new("ScrollingFrame", MainFrame); TabsContainer.Name = "TabsContainer"; TabsContainer.Size = UDim2.new(0, 120, 1, -40); TabsContainer.Position = UDim2.new(0, 0, 0, 40); TabsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabsContainer.BorderSizePixel = 0; 
        TabsContainer.ScrollBarThickness = 8; TabsContainer.ScrollBarImageColor3 = currentTheme.main; TabsContainer.ScrollBarImageTransparency = 0.4
        table.insert(themableObjects, {object = TabsContainer, property = "ScrollBarImageColor3", colorType = "main"})

        local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -120, 1, -40); ContentContainer.Position = UDim2.new(0, 120, 0, 40); ContentContainer.BackgroundTransparency = 1
        
        local TabsList = Instance.new("UIListLayout", TabsContainer); TabsList.Padding = UDim.new(0, 10); TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local function createTabButton(text) local button = Instance.new("TextButton", TabsContainer); button.Size = UDim2.new(1, -10, 0, 40); button.BackgroundColor3 = Color3.fromRGB(60, 60, 60); button.Text = text; button.TextColor3 = Color3.fromRGB(255, 255, 255); button.Font = Enum.Font.SourceSansBold; button.TextSize = 18; return button end  
        local HomeButton=createTabButton("HOME"); local MainButton=createTabButton("SCRIPT'S"); local InfoButton=createTabButton("INFO"); local GuiModsButton=createTabButton("GUI MODS"); local PlayersButton=createTabButton("PLAYERS"); local CommandsButton = createTabButton("COMMANDS"); local PlayersChatButton = createTabButton("PLAYERS CHAT"); local SettingsButton=createTabButton("SETTINGS"); local ExecutorButton=createTabButton("EXECUTOR")

        task.wait()
        TabsContainer.CanvasSize = UDim2.fromOffset(0, TabsList.AbsoluteContentSize.Y)
        TabsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabsContainer.CanvasSize = UDim2.fromOffset(0, TabsList.AbsoluteContentSize.Y)
        end)
        
        local HomePage=Instance.new("Frame",ContentContainer); HomePage.Size=UDim2.new(1,0,1,0); HomePage.BackgroundTransparency=1; HomePage.Visible=true
        local MainPage=Instance.new("Frame",ContentContainer); MainPage.Size=UDim2.new(1,0,1,0); MainPage.BackgroundTransparency=1; MainPage.Visible=false
        local InfoPage=Instance.new("Frame",ContentContainer); InfoPage.Size=UDim2.new(1,0,1,0); InfoPage.BackgroundTransparency=1; InfoPage.Visible=false
        local GuiModsPage=Instance.new("Frame",ContentContainer); GuiModsPage.Size=UDim2.new(1,0,1,0); GuiModsPage.BackgroundTransparency=1; GuiModsPage.Visible=false
        local PlayersPage=Instance.new("Frame",ContentContainer); PlayersPage.Size=UDim2.new(1,0,1,0); PlayersPage.BackgroundTransparency=1; PlayersPage.Visible=false
        local CommandsPage=Instance.new("Frame",ContentContainer); CommandsPage.Size=UDim2.new(1,0,1,0); CommandsPage.BackgroundTransparency=1; CommandsPage.Visible=false
        local PlayersChatPage=Instance.new("Frame",ContentContainer); PlayersChatPage.Size=UDim2.new(1,0,1,0); PlayersChatPage.BackgroundTransparency=1; PlayersChatPage.Visible=false
        local SettingsPage=Instance.new("Frame",ContentContainer); SettingsPage.Size=UDim2.new(1,0,1,0); SettingsPage.BackgroundTransparency=1; SettingsPage.Visible=false
        local ExecutorPage=Instance.new("Frame",ContentContainer); ExecutorPage.Size=UDim2.new(1,0,1,0); ExecutorPage.BackgroundTransparency=1; ExecutorPage.Visible=false

        local function createFunctionButton(text, parent, callback) 
            local b = Instance.new("TextButton",parent)
            local theme = (not rainbowThemeActive) and currentTheme or Themes.Red
            b.BackgroundColor3=theme.main
            b.TextColor3=theme.text
            b.Font=Enum.Font.SourceSansBold
            b.TextSize=16
            b.Text=text
            b.TextScaled = false
            b.RichText = false
            b.TextYAlignment = Enum.TextYAlignment.Center
            b.Size = UDim2.new(0, 120, 0, 35)
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
            if callback then b.MouseButton1Click:Connect(function() pcall(callback) end) end
            table.insert(themableObjects, {object=b, property="BackgroundColor3", colorType="main"})
            table.insert(themableObjects, {object=b, property="TextColor3", colorType="text"})
            return b 
        end
        local function createInfoLabel(text, parent) local label = Instance.new("TextLabel", parent); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Font = Enum.Font.SourceSans; label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = text; return label end;
        
        -- #region HOME PAGE
        local PlayerImage = Instance.new("ImageLabel", HomePage); PlayerImage.Size = UDim2.new(0, 128, 0, 128); PlayerImage.Position = UDim2.new(0, 15, 0, 15); PlayerImage.BackgroundTransparency = 1; task.spawn(function() pcall(function() PlayerImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end);
        local playerImageBorder = Instance.new("UIStroke", PlayerImage); playerImageBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; playerImageBorder.Color = currentTheme.main; playerImageBorder.Thickness = 2; table.insert(themableObjects, {object = playerImageBorder, property = "Color", colorType = "main"})
        local WelcomeLabel = createInfoLabel("Welcome, "..player.Name, HomePage); WelcomeLabel.Position = UDim2.new(0, 150, 0, 35); WelcomeLabel.TextColor3 = currentTheme.accent; WelcomeLabel.Font = Enum.Font.SourceSansBold; WelcomeLabel.TextSize = 22;
        createInfoLabel("NickName: "..player.Name, HomePage).Position = UDim2.new(0, 150, 0, 60)
        createInfoLabel("ID account: "..player.UserId, HomePage).Position = UDim2.new(0, 150, 0, 85)
        createInfoLabel("lvl account: "..player.AccountAge, HomePage).Position = UDim2.new(0, 150, 0, 110)
        local creationDateLabel = createInfoLabel("Creation Date: Loading...", HomePage); creationDateLabel.Position = UDim2.new(0, 15, 0, 150)
        local deviceLabel = createInfoLabel("Device: Loading...", HomePage); deviceLabel.Position = UDim2.new(0, 15, 0, 175)
        local ipInfoLabel = createInfoLabel("IP-address: Loading...", HomePage); ipInfoLabel.Position = UDim2.new(0, 15, 0, 200)
        local countryLabel = createInfoLabel("Country: Loading...", HomePage); countryLabel.Position = UDim2.new(0, 15, 0, 225)
        task.spawn(function() pcall(function() local r = HttpService:JSONDecode(game:HttpGet("https://users.roproxy.com/v1/users/"..player.UserId)); creationDateLabel.Text = "Creation Date: "..r.created:sub(1,10) end) end)
        task.spawn(function() pcall(function() local r=HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")); local f=""; if r.countryCode then local a,b=127462,string.byte("A"); f=utf8.char(a+(string.byte(r.countryCode,1)-b))..utf8.char(a+(string.byte(r.countryCode,2)-b)) end; ipInfoLabel.Text="IP-address: "..r.query; countryLabel.Text="Country: "..r.country..", "..r.city.." "..f end) end)
        if UserInputService.TouchEnabled then deviceLabel.Text = "Device: Phone/Tablet" else deviceLabel.Text = "Device: Computer" end
        -- #endregion
        
        -- #region INFO PAGE
        local NurgazyImage=Instance.new("ImageLabel",InfoPage); NurgazyImage.Size=UDim2.new(0,150,0,150); NurgazyImage.Position=UDim2.new(0, 15, 0, 15); NurgazyImage.BackgroundTransparency=1; task.spawn(function() pcall(function() NurgazyImage.Image = Players:GetUserThumbnailAsync(2956155840, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end); 
        local NurgazyStroke=Instance.new("UIStroke",NurgazyImage); NurgazyStroke.Color=currentTheme.main;
        local sE=Instance.new("TextLabel",NurgazyImage); sE.Size=UDim2.new(0,45,0,45); sE.Position=UDim2.new(1,-35,0,-10); sE.BackgroundTransparency=1; sE.Rotation=15; sE.Text="👑"; sE.TextScaled=true; 
        local bioText=createInfoLabel("👋Hello, my name is Nurgazy,\n I live in Kazakhstan, and\n I am a young hacker and scripter\n who is just starting out.\n My scripts are high-quality\n and beautiful. Everything is real.", InfoPage); bioText.Size=UDim2.new(1,-190,0,150); bioText.Position=UDim2.new(0,175,0,15); bioText.TextWrapped=true; bioText.TextXAlignment=Enum.TextXAlignment.Center; bioText.TextYAlignment=Enum.TextYAlignment.Top
        local MasterLinksContainer=Instance.new("Frame",InfoPage); MasterLinksContainer.Name="MasterLinksContainer"; MasterLinksContainer.Size=UDim2.new(1,-20,0,80); MasterLinksContainer.Position=UDim2.new(0,10,0,180); MasterLinksContainer.BackgroundTransparency=1;
        local MasterListLayout=Instance.new("UIListLayout",MasterLinksContainer); MasterListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; MasterListLayout.SortOrder=Enum.SortOrder.LayoutOrder; MasterListLayout.Padding=UDim.new(0,5);
        local Row1=Instance.new("Frame",MasterLinksContainer); Row1.Name="Row1"; Row1.BackgroundTransparency=1; Row1.Size=UDim2.new(1,0,0,35); local Row1Layout=Instance.new("UIListLayout",Row1); Row1Layout.FillDirection=Enum.FillDirection.Horizontal; Row1Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; Row1Layout.SortOrder=Enum.SortOrder.LayoutOrder; Row1Layout.Padding=UDim.new(0,10);
        local Row2=Instance.new("Frame",MasterLinksContainer); Row2.Name="Row2"; Row2.BackgroundTransparency=1; Row2.Size=UDim2.new(1,0,0,35); local Row2Layout=Instance.new("UIListLayout",Row2); Row2Layout.FillDirection=Enum.FillDirection.Horizontal; Row2Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; Row2Layout.SortOrder=Enum.SortOrder.LayoutOrder; Row2Layout.Padding=UDim.new(0,10);
        local function copyToClipboard(link,name) if setclipboard then setclipboard(link); StarterGui:SetCore("SendNotification",{Title="WilsonHub",Text="Link to "..name .." copied!",Duration=3}) else StarterGui:SetCore("SendNotification",{Title="WilsonHub Error",Text="Function setclipboard not found.",Duration=4}) end end; 
        createFunctionButton("MY PROFILE", Row1); 
        createFunctionButton("DISCORD", Row1, function() copyToClipboard("https://dsc.gg/wilsonhub", "Discord") end); 
        createFunctionButton("CHANEL", Row1, function() copyToClipboard("https://t.me/wilsonhub_scripts", "Telegram Chanel") end)
        createFunctionButton("VKONTAKTE", Row2, function() copyToClipboard("https://vk.com/wilsonhub_scripts", "VKontakte") end)
        createFunctionButton("WEBSITE", Row2, function() copyToClipboard("https://wilsonhub-scripts.hgweb.ru", "Website") end)
        -- #endregion

        -- #region GUI MODS PAGE
        do local GuiModsContainer=Instance.new("ScrollingFrame",GuiModsPage);GuiModsContainer.Size=UDim2.new(1,0,1,0);GuiModsContainer.BackgroundTransparency=1;GuiModsContainer.ScrollBarThickness=6;local GuiModsList=Instance.new("UIListLayout",GuiModsContainer);GuiModsList.Padding=UDim.new(0,10);GuiModsList.HorizontalAlignment=Enum.HorizontalAlignment.Center;GuiModsList.SortOrder=Enum.SortOrder.LayoutOrder;local function createToggle(text,order,callback) local frame=Instance.new("Frame",GuiModsContainer);frame.Size=UDim2.new(1,-20,0,40);frame.BackgroundTransparency=1;frame.LayoutOrder=order;local label=Instance.new("TextLabel",frame);label.Size=UDim2.new(0.6,0,1,0);label.BackgroundTransparency=1;label.Font=Enum.Font.SourceSansBold;label.TextColor3=Color3.new(1,1,1);label.TextSize=16;label.Text=text;label.TextXAlignment=Enum.TextXAlignment.Left;local btn=Instance.new("TextButton",frame);btn.Size=UDim2.new(0.4,-10,1,0);btn.Position=UDim2.new(0.6,10,0,0);btn.BackgroundColor3=currentTheme.main;btn.TextColor3=currentTheme.text;btn.Font=Enum.Font.SourceSansBold;btn.Text="OFF";Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6);btn.MouseButton1Click:Connect(function()local state=(btn.Text=="OFF");btn.Text=state and "ON" or "OFF";if state then btn.BackgroundColor3=Color3.fromRGB(0,150,0)else local theme=rainbowThemeActive and Themes.Red or currentTheme;btn.BackgroundColor3=theme.main;btn.TextColor3=theme.text end;if callback then pcall(callback,state,btn) end end);return btn end;createToggle("Custom Healthbar",1,toggleCustomHealthbar);createToggle("FPS/Ping Display",2,toggleFpsPing);local colorChangerContainer=Instance.new("Frame",GuiModsContainer);colorChangerContainer.Size=UDim2.new(1,-20,0,200);colorChangerContainer.BackgroundTransparency=1;colorChangerContainer.LayoutOrder=3;local colorList=Instance.new("UIListLayout",colorChangerContainer);colorList.Padding=UDim.new(0,5);local title=Instance.new("TextLabel",colorChangerContainer);title.Size=UDim2.new(1,0,0,20);title.BackgroundTransparency=1;title.Font=Enum.Font.SourceSansBold;title.TextColor3=Color3.new(1,1,1);title.TextSize=18;title.Text="World Color Changer";local colorPreview=Instance.new("Frame",colorChangerContainer);colorPreview.Size=UDim2.new(1,0,0,30);colorPreview.BackgroundColor3=selectedColor;Instance.new("UICorner",colorPreview).CornerRadius=UDim.new(0,6);local function createSlider(label,parent,callback) local sliderFrame=Instance.new("Frame",parent);sliderFrame.Size=UDim2.new(1,0,0,30);sliderFrame.BackgroundTransparency=1;local textLabel=Instance.new("TextLabel",sliderFrame);textLabel.Size=UDim2.new(0.2,0,1,0);textLabel.BackgroundTransparency=1;textLabel.Font=Enum.Font.SourceSansBold;textLabel.Text=label;textLabel.TextColor3=Color3.new(1,1,1);textLabel.TextSize=18;local bar=Instance.new("Frame",sliderFrame);bar.Size=UDim2.new(0.8,-10,0,10);bar.Position=UDim2.new(0.2,0,0.5,-5);bar.BackgroundColor3=Color3.fromRGB(30,30,30);Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0);local handle=Instance.new("TextButton",bar);handle.Size=UDim2.new(0,12,1,4);handle.BackgroundColor3=currentTheme.main;handle.Text="";handle.AnchorPoint=Vector2.new(0.5,0.5);Instance.new("UICorner",handle).CornerRadius=UDim.new(1,0);table.insert(themableObjects,{object=handle,property="BackgroundColor3",colorType="main"});local inputChangedConn,inputEndedConn;handle.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then if inputChangedConn then inputChangedConn:Disconnect()end;if inputEndedConn then inputEndedConn:Disconnect()end;inputChangedConn=UserInputService.InputChanged:Connect(function(inputObj)if inputObj.UserInputType==Enum.UserInputType.MouseMovement or inputObj.UserInputType==Enum.UserInputType.Touch then local pos=inputObj.Position.X-bar.AbsolutePosition.X;local percentage=math.clamp(pos/bar.AbsoluteSize.X,0,1);handle.Position=UDim2.fromScale(percentage,0.5);pcall(callback,percentage)end end);inputEndedConn=UserInputService.InputEnded:Connect(function(inputObj)if inputObj.UserInputType==Enum.UserInputType.MouseButton1 or inputObj.UserInputType==Enum.UserInputType.Touch then if inputChangedConn then inputChangedConn:Disconnect()end;if inputEndedConn then inputEndedConn:Disconnect()end end end)end end);return handle end;local r,g,b=selectedColor.r,selectedColor.g,selectedColor.b;createSlider("R",colorChangerContainer,function(p)r=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(r,0.5);createSlider("G",colorChangerContainer,function(p)g=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(g,0.5);createSlider("B",colorChangerContainer,function(p)b=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(b,0.5);local buttonContainer=Instance.new("Frame",colorChangerContainer);buttonContainer.Size=UDim2.new(1,0,0,40);buttonContainer.BackgroundTransparency=1;buttonContainer.LayoutOrder=4;local btnLayout=Instance.new("UIGridLayout",buttonContainer);btnLayout.CellSize=UDim2.new(0.333,-5,1,0);btnLayout.CellPadding=UDim2.new(0,5,0,0);local rainbowToggle;createFunctionButton("Apply",buttonContainer,function()toggleRainbowMode(false);if rainbowToggle then rainbowToggle.Text="OFF";local theme=rainbowThemeActive and Themes.Red or currentTheme; rainbowToggle.BackgroundColor3=theme.main; end;applyWorldColor(selectedColor)end);rainbowToggle=createToggle("Rainbow",0,function(state)toggleRainbowMode(state)end);rainbowToggle.Parent=buttonContainer;rainbowToggle.Name="RainbowToggle";createFunctionButton("Reset",buttonContainer,function()toggleRainbowMode(false);if rainbowToggle then rainbowToggle.Text="OFF";local theme=rainbowThemeActive and Themes.Red or currentTheme; rainbowToggle.BackgroundColor3=theme.main; end;resetWorldColors()end)end
        -- #endregion

        -- #region SCRIPTS PAGE
        local SearchBox = Instance.new("TextBox", MainPage); SearchBox.Size = UDim2.new(1,-20,0,30); SearchBox.Position = UDim2.new(0,10,0,10); SearchBox.BackgroundColor3=Color3.fromRGB(45,45,45); SearchBox.TextColor3=Color3.fromRGB(255,255,255); SearchBox.PlaceholderText="Search scripts..."; SearchBox.Font=Enum.Font.SourceSans; SearchBox.TextSize=14; Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,6); local SearchBoxStroke = Instance.new("UIStroke", SearchBox); SearchBoxStroke.Color = currentTheme.main; table.insert(themableObjects,{object=SearchBoxStroke, property="Color", colorType="main"}); 
        local ScriptsContainer = Instance.new("ScrollingFrame", MainPage); ScriptsContainer.Size=UDim2.new(1,-20,1,-50); ScriptsContainer.Position=UDim2.new(0,10,0,50); ScriptsContainer.BackgroundTransparency=1; ScriptsContainer.ScrollBarThickness=6; 
        local ScriptsGrid=Instance.new("UIGridLayout",ScriptsContainer); ScriptsGrid.CellPadding=UDim2.new(0,10,0,10); ScriptsGrid.CellSize=UDim2.new(0, 190, 0, 40); ScriptsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        createFunctionButton("Fly gui ☑︎", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WilsonFly"))() end); createFunctionButton("Fire Block ☑︎", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Auto-fire-part-universal-/refs/heads/main/Auto%20fire%20part%20universal"))() end); SearchBox:GetPropertyChangedSignal("Text"):Connect(function() local s = SearchBox.Text:lower(); for _, b in ipairs(ScriptsContainer:GetChildren()) do if b:IsA("TextButton") then b.Visible = b.Text:lower():find(s, 1, true) end end end)
        createFunctionButton("Speed Hack ☑︎", ScriptsContainer, function() local p=game:GetService("Players").LocalPlayer;local c=p.Character;if not c then return end;local h=c:WaitForChild("Humanoid");h.WalkSpeed=50;game:GetService("StarterGui"):SetCore("SendNotification",{Title="Speed Hack",Text="Speed increased to 50.",Duration=5});h.Died:Connect(function()end)end)
        createFunctionButton("Wallhop ☑︎", ScriptsContainer, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20script'))() end);
        createFunctionButton("Click Teleport ☑︎", ScriptsContainer, function() local p=game:GetService("Players").LocalPlayer;local m=p:GetMouse();game:GetService("StarterGui"):SetCore("SendNotification",{Title="Click Teleport",Text="Activated. Click to teleport.",Duration=7});m.Button1Down:Connect(function()if m.Target and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then p.Character.HumanoidRootPart.CFrame=CFrame.new(m.Hit.Position+Vector3.new(0,3,0))end end)end)
        createFunctionButton("Player ESP ☑︎", ScriptsContainer, function()
    local players = game:GetService("Players")
    local camera = workspace.CurrentCamera
    local localPlayer = players.LocalPlayer
    local runService = game:GetService("RunService")

    local espEnabled = true
    local connections = {}

    local function createESP(player)
        if not espEnabled then return end

        local character = player.Character
        if not character or player == localPlayer then return end

        local head = character:FindFirstChild("Head")
        if not head then return end
        
        -- Удаляем старый ESP, если он есть
        if connections[player] and connections[player].gui then
             connections[player].gui:Destroy()
        end

        local espGui = Instance.new("BillboardGui", head)
        espGui.Name = "ESP_GUI"
        espGui.AlwaysOnTop = true
        espGui.Size = UDim2.new(0, 100, 0, 50)
        espGui.StudsOffset = Vector3.new(0, 2, 0)
        
        local textLabel = Instance.new("TextLabel", espGui)
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Font = Enum.Font.SourceSans
        textLabel.TextSize = 14
        textLabel.TextColor3 = Color3.new(1, 1, 0) -- Желтый цвет
        
        local function update()
            if not (player and character and head and head.Parent and espGui and espGui.Parent) then
                espGui:Destroy()
                if connections[player] and connections[player].updateConnection then
                    connections[player].updateConnection:Disconnect()
                end
                return
            end
            local distance = (head.Position - camera.CFrame.Position).Magnitude
            textLabel.Text = player.Name .. "\n[" .. math.floor(distance) .. "m]"
        end
        
        connections[player] = {
            gui = espGui,
            updateConnection = runService.RenderStepped:Connect(update)
        }
    end
    
    -- Применяем ESP ко всем уже существующим игрокам
    for _, player in ipairs(players:GetPlayers()) do
        createESP(player)
        if player.Character then
            connections[player.Character] = player.CharacterAdded:Connect(function(char) createESP(player) end)
        end
    end

    -- Добавляем ESP для новых игроков
    connections.playerAdded = players.PlayerAdded:Connect(createESP)

    game:GetService("StarterGui"):SetCore("SendNotification", {Title="ESP", Text="ESP активирован.", Duration=5})
end)
        -- #endregion

        -- #region PLAYERS PAGE (ТҮЗЕТІЛДІ)
        local PlayersList = Instance.new("ScrollingFrame", PlayersPage); PlayersList.Size = UDim2.new(1, -20, 1, -10); PlayersList.Position = UDim2.new(0, 10, 0, 5); PlayersList.BackgroundColor3 = Color3.fromRGB(45, 45, 45); PlayersList.ScrollBarThickness = 6; Instance.new("UICorner", PlayersList).CornerRadius = UDim.new(0, 6); 
        local PlayersListLayout = Instance.new("UIListLayout", PlayersList); PlayersListLayout.Padding = UDim.new(0, 5); PlayersListLayout.SortOrder = Enum.SortOrder.LayoutOrder; 
        
        local function updatePlayerList() 
            for _, v in ipairs(PlayersList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            local camera = workspace.CurrentCamera
            for i, p in ipairs(Players:GetPlayers()) do 
                if p then 
                    local template = Instance.new("Frame", PlayersList); template.Name = p.Name; template.Size = UDim2.new(1, 0, 0, 90); template.BackgroundColor3 = Color3.fromRGB(35, 35, 35); template.LayoutOrder = i
                    local thumb = Instance.new("ImageLabel", template); thumb.Size = UDim2.new(0, 40, 0, 40); thumb.Position = UDim2.new(0, 10, 0.5, -20); task.spawn(function() pcall(function() thumb.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) end)
                    local nameLabel = createInfoLabel(p.Name, template); nameLabel.Size = UDim2.new(0.4, 0, 0, 30); nameLabel.Position = UDim2.new(0, 55, 0, 5); if p == player then nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0) end
                    local pingLabel = createInfoLabel("Ping: ...", template); pingLabel.Position = UDim2.new(0, 55, 0, 25); pingLabel.Size = UDim2.new(1, -60, 0, 20); pingLabel.TextSize = 14; pingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    local ipLabel = createInfoLabel("IP Address: ...", template); ipLabel.Position = UDim2.new(0, 55, 0, 45); ipLabel.Size = UDim2.new(1, -60, 0, 20); ipLabel.TextSize = 14; ipLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    local countryLabel = createInfoLabel("Country: ...", template); countryLabel.Position = UDim2.new(0, 55, 0, 65); countryLabel.Size = UDim2.new(1, -60, 0, 20); countryLabel.TextSize = 14; countryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    
                    if p ~= player then
                        local buttonsFrame = Instance.new("Frame", template); buttonsFrame.BackgroundTransparency = 1; buttonsFrame.Size = UDim2.new(0, 160, 0, 40); buttonsFrame.Position = UDim2.new(1, -165, 0.5, -20);
                        local buttonsLayout = Instance.new("UIGridLayout", buttonsFrame); buttonsLayout.CellSize = UDim2.new(0.5, -5, 1, 0); buttonsLayout.CellPadding = UDim2.new(0, 5, 0, 0);
                        createFunctionButton("TP", buttonsFrame, function() pcall(function() local r1=player.Character and player.Character.HumanoidRootPart; local r2=p.Character and p.Character.HumanoidRootPart; if r1 and r2 then r1.CFrame=r2.CFrame end end) end).Size=UDim2.new(1,0,1,0)
                        createFunctionButton("Observe", buttonsFrame, function() pcall(function() local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid"); if h then if camera.CameraSubject==h then camera.CameraSubject=player.Character.Humanoid else camera.CameraSubject=h end end end) end).Size=UDim2.new(1,0,1,0)
                    end

                    if p == player then 
                        pingLabel.Text = string.format("Ping: %d ms", math.floor(player:GetNetworkPing() * 1000))
                        ipLabel.Text = "IP Address: Loading..."
                        countryLabel.Text = "Country: Loading..."
                        task.spawn(function()
                            local s,r = pcall(function() return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")) end)
                            if s and r then 
                                local f = ""; if r.countryCode then local a,b=127462,string.byte("A"); f=utf8.char(a+(string.byte(r.countryCode,1)-b))..utf8.char(a+(string.byte(r.countryCode,2)-b)) end
                                ipLabel.Text = "IP Address: " .. (r.query or "Unknown")
                                countryLabel.Text = "Country: " .. (r.country or "Unknown") .. " " .. f 
                            else 
                                ipLabel.Text = "IP Address: Error"; countryLabel.Text = "Country: Error" 
                            end 
                        end)
                    else 
                        pingLabel.Text = string.format("Ping: ~%d ms", math.random(40,250));
                        ipLabel.Text = "IP Address: Private"
                        countryLabel.Text = "Country: Private"
                    end 
                end 
            end; 
            PlayersList.CanvasSize = UDim2.fromOffset(0, PlayersListLayout.AbsoluteContentSize.Y) 
        end
        -- #endregion
        
        -- #region COMMANDS PAGE
        local Commands = {}
        local CommandAliases = {}
        local ConsoleOutput = nil
        local function logToConsole(text, color) if not ConsoleOutput or not ConsoleOutput.Parent then return end; local label=Instance.new("TextLabel"); label.Name="ConsoleLog"; label.Text=tostring(text); label.TextColor3=color or Color3.new(1,1,1); label.Font=Enum.Font.Code; label.TextSize=14; label.TextXAlignment=Enum.TextXAlignment.Left; label.BackgroundTransparency=1; label.TextWrapped=true; label.Size=UDim2.new(1,-10,0,0); label.AutomaticSize=Enum.AutomaticSize.Y; label.Parent=ConsoleOutput end
        local function findPlayers(query) query=query:lower(); local f={}; if query=="all"then return Players:GetPlayers()elseif query=="others"then for _,p in ipairs(Players:GetPlayers())do if p~=player then table.insert(f,p)end end;return f elseif query=="me"then return{player}elseif query=="random"then local a=Players:GetPlayers();if #a>0 then return{a[math.random(1,#a)]}end;return{}end; for _,p in ipairs(Players:GetPlayers())do if p.Name:lower():sub(1,#query)==query then table.insert(f,p)end end;return f end
        local function registerCommand(name,aliases,args,desc,func) local d={Name=name:lower(),Aliases=aliases,Args=args,Description=desc,Function=func};Commands[d.Name]=d;for _,a in ipairs(aliases)do CommandAliases[a:lower()]=d.Name end end
        local function processCommand(fullCommand) if not fullCommand:find("^/")then logToConsole("Error: Commands must start with /",Color3.new(1,.4,.4));return end; local noPrefix=fullCommand:sub(2);local args={};for arg in noPrefix:gmatch("[^%s]+")do table.insert(args,arg)end; if #args==0 then return end; local cmdName=table.remove(args,1):lower();local cmdData=Commands[cmdName]or Commands[CommandAliases[cmdName]];if cmdData then logToConsole("Executing: "..fullCommand,Color3.new(.4,1,.4));pcall(cmdData.Function,args)else logToConsole("Error: Command not found: "..cmdName,Color3.new(1,.4,.4))end end
        local ConsoleFrame=Instance.new("Frame",CommandsPage);ConsoleFrame.Size=UDim2.new(1,-20,1,-10);ConsoleFrame.Position=UDim2.new(0,10,0,5);ConsoleFrame.BackgroundColor3=Color3.fromRGB(25,25,25);ConsoleFrame.BorderSizePixel=0;Instance.new("UICorner",ConsoleFrame).CornerRadius=UDim.new(0,6);ConsoleOutput=Instance.new("ScrollingFrame",ConsoleFrame);ConsoleOutput.Size=UDim2.new(1,0,1,-40);ConsoleOutput.BackgroundColor3=Color3.fromRGB(30,30,30);ConsoleOutput.BorderSizePixel=0;ConsoleOutput.ScrollBarThickness=6;local oL=Instance.new("UIListLayout",ConsoleOutput);oL.Padding=UDim.new(0,5);oL.SortOrder=Enum.SortOrder.LayoutOrder;local CommandInput=Instance.new("TextBox",ConsoleFrame);CommandInput.Size=UDim2.new(1,0,0,40);CommandInput.Position=UDim2.new(0,0,1,-40);CommandInput.BackgroundColor3=Color3.fromRGB(45,45,45);CommandInput.TextColor3=Color3.new(1,1,1);CommandInput.Font=Enum.Font.Code;CommandInput.TextSize=16;CommandInput.PlaceholderText="/command [target] [args]";CommandInput.ClearTextOnFocus=false;CommandInput.FocusLost:Connect(function(e)if e then local t=CommandInput.Text;if #t>0 then processCommand(t);CommandInput.Text=""end end end)
        registerCommand("fly",{},"","Enables flying.",function()loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WilsonFly"))()end)
        registerCommand("speed",{"walkspeed","ws"},"[player] [value]","Changes walkspeed.",function(a)local t=findPlayers(a[1]or"me");local s=tonumber(a[2]or 100);if not s then logToConsole("Invalid speed.",Color3.new(1,.4,.4))return end;for _,p in ipairs(t)do if p.Character and p.Character:FindFirstChild("Humanoid")then p.Character.Humanoid.WalkSpeed=s end end end)
        registerCommand("jp",{"jumppower"},"[player] [value]","Changes jump power.",function(a)local t=findPlayers(a[1]or"me");local p=tonumber(a[2]or 100);if not p then logToConsole("Invalid power.",Color3.new(1,.4,.4))return end;for _,plr in ipairs(t)do if plr.Character and plr.Character:FindFirstChild("Humanoid")then plr.Character.Humanoid.JumpPower=p end end end)
        registerCommand("kill",{},"[player]","Kills the player.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do if p.Character and p.Character:FindFirstChild("Humanoid")then p.Character.Humanoid.Health=0 end end end)
        registerCommand("tp",{"teleport"},"[player_to]","Teleports to player.",function(a)if not a[1]then logToConsole("Usage: /tp [target]",Color3.new(1,.4,.4))return end;local t=findPlayers(a[1]);if #t==0 then logToConsole("Target not found.",Color3.new(1,.4,.4))return end;local cF=player.Character;local cT=t[1].Character;if cF and cT and cF:FindFirstChild("HumanoidRootPart")and cT:FindFirstChild("HumanoidRootPart")then cF.HumanoidRootPart.CFrame=cT.HumanoidRootPart.CFrame end end)
        registerCommand("jerk",{},"[player]","Makes a player spin.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c and c:FindFirstChild("HumanoidRootPart")then local r=c.HumanoidRootPart;r.Anchored=true;local j=Instance.new("BodyAngularVelocity",r);j.Name="JERK_EFFECT";j.MaxTorque=Vector3.new(math.huge,math.huge,math.huge);j.AngularVelocity=Vector3.new(100,100,100)end end end)
        registerCommand("unjerk",{},"[player]","Stops the jerk effect.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c and c:FindFirstChild("HumanoidRootPart")then local r=c.HumanoidRootPart;local j=r:FindFirstChild("JERK_EFFECT");if j then j:Destroy()end;r.Anchored=false end end end)
        registerCommand("bang",{},"[player]","Flings a player.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c then for _,prt in ipairs(c:GetDescendants())do if prt:IsA("BasePart")then prt.AssemblyLinearVelocity=Vector3.new(math.random(-200,200),200,math.random(-200,200))end end end end end)
        registerCommand("unbang",{},"[player]","Resets velocity after bang.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c then for _,prt in ipairs(c:GetDescendants())do if prt:IsA("BasePart")then prt.AssemblyLinearVelocity=Vector3.new(0,0,0)end end end end end)
        registerCommand("clear",{"cls"},"","Clears the console.",function()for _,v in ipairs(ConsoleOutput:GetChildren())do if v.Name=="ConsoleLog"then v:Destroy()end end end)
        logToConsole("WilsonHub Commands:",currentTheme.accent);local sC={};for n,d in pairs(Commands)do table.insert(sC,d)end;table.sort(sC,function(a,b)return a.Name<b.Name end);for _,d in ipairs(sC)do logToConsole(string.format("/%s %s - %s",d.Name,d.Args,d.Description),Color3.new(.8,.8,.8))end
        -- #endregion

        -- #region PLAYERS CHAT PAGE (СЕНІМДІЛІК ҮШІН ЖАҢАРТЫЛДЫ)
        local chat_state = { is_active = false, last_timestamp = 0, is_fetching = false }
        local ChatTitle = createInfoLabel("Global Chat", PlayersChatPage); ChatTitle.Position=UDim2.new(0,10,0,5); ChatTitle.Font=Enum.Font.SourceSansBold; ChatTitle.TextSize=18; table.insert(themableObjects,{object=ChatTitle, property="TextColor3", colorType="accent"})
        local MessagesContainer = Instance.new("ScrollingFrame", PlayersChatPage); MessagesContainer.Size=UDim2.new(1,-20,1,-85); MessagesContainer.Position=UDim2.new(0,10,0,35); MessagesContainer.BackgroundColor3=Color3.fromRGB(45,45,45); MessagesContainer.ScrollBarThickness=6; Instance.new("UICorner",MessagesContainer).CornerRadius=UDim.new(0,6);
        local MessagesLayout = Instance.new("UIListLayout", MessagesContainer); MessagesLayout.Padding=UDim.new(0,8); MessagesLayout.SortOrder=Enum.SortOrder.LayoutOrder;
        local ChatInput = Instance.new("TextBox", PlayersChatPage); ChatInput.Size=UDim2.new(1,-90,0,40); ChatInput.Position=UDim2.new(0,10,1,-45); ChatInput.BackgroundColor3=Color3.fromRGB(45,45,45); ChatInput.TextColor3=Color3.new(1,1,1); ChatInput.Font=Enum.Font.SourceSans; ChatInput.TextSize=14; ChatInput.PlaceholderText="Enter message..."; Instance.new("UICorner",ChatInput).CornerRadius=UDim.new(0,6)
        local SendButton = createFunctionButton("Send", PlayersChatPage); SendButton.Size=UDim2.new(0,60,0,40); SendButton.Position=UDim2.new(1,-70,1,-45);
        
        local function try_request(method, endpoint, payload)
            local last_error = "All chat servers are unavailable."
            for i = 1, #CHAT_SETTINGS.API_BACKENDS do
                local url = CHAT_SETTINGS.API_BACKENDS[current_backend_index] .. endpoint
                local success, response
                if method == "GET" then
                    success, response = pcall(game.HttpGet, game, url, true)
                else
                    success, response = pcall(HttpService.PostAsync, HttpService, url, payload, Enum.HttpContentType.ApplicationJson)
                end
                if success then return true, response end
                last_error = tostring(response)
                current_backend_index = (current_backend_index % #CHAT_SETTINGS.API_BACKENDS) + 1
                task.wait(0.2)
            end
            return false, last_error
        end
        
        local function clearChat() for _,v in ipairs(MessagesContainer:GetChildren()) do if v.Name == "MessageFrame" then v:Destroy() end end end
        
        local function displayMessage(msgData, isSystemMessage)
            local msgFrame = Instance.new("Frame", MessagesContainer); msgFrame.Name = "MessageFrame"; msgFrame.BackgroundTransparency = 1; msgFrame.Size = UDim2.new(1, 0, 0, 0); msgFrame.AutomaticSize = Enum.AutomaticSize.Y; msgFrame.LayoutOrder = msgData.timestamp
            local hLayout = Instance.new("UIListLayout", msgFrame); hLayout.FillDirection = Enum.FillDirection.Horizontal; hLayout.VerticalAlignment = Enum.VerticalAlignment.Top; hLayout.Padding = UDim.new(0, 8)
            local avatar = Instance.new("ImageLabel", msgFrame); avatar.Size = UDim2.new(0, 40, 0, 40); avatar.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            local textFrame = Instance.new("Frame", msgFrame); textFrame.BackgroundTransparency = 1; textFrame.Size = UDim2.new(1, -50, 0, 0); textFrame.AutomaticSize = Enum.AutomaticSize.Y
            local vLayout = Instance.new("UIListLayout", textFrame); vLayout.Padding = UDim.new(0, 2)
            local nameLabel = Instance.new("TextLabel", textFrame); nameLabel.BackgroundTransparency = 1; nameLabel.Size = UDim2.new(1, 0, 0, 16); nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.TextSize = 15; nameLabel.TextColor3 = currentTheme.accent; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            local contentLabel = Instance.new("TextLabel", textFrame); contentLabel.BackgroundTransparency = 1; contentLabel.Size = UDim2.new(1, 0, 0, 0); contentLabel.AutomaticSize = Enum.AutomaticSize.Y; contentLabel.Font = Enum.Font.SourceSans; contentLabel.TextSize = 14; contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255); contentLabel.TextWrapped = true; contentLabel.RichText = true; contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            if isSystemMessage then avatar.Visible = false; nameLabel.Visible = false; textFrame.Size = UDim2.new(1, -5, 0, 0); contentLabel.TextXAlignment = Enum.TextXAlignment.Center
            else if tonumber(msgData.userid) == player.UserId then nameLabel.Text = "You" else nameLabel.Text = msgData.username end; task.spawn(function() local s, thumb = pcall(Players.GetUserThumbnailAsync, Players, tonumber(msgData.userid), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42); if s and avatar and avatar.Parent then avatar.Image = thumb end end); table.insert(themableObjects, {object=nameLabel, property="TextColor3", colorType="accent"}) end
            contentLabel.Text = msgData.message
            task.delay(0.2, function() if MessagesContainer and MessagesLayout then MessagesContainer.CanvasSize = UDim2.fromOffset(0, MessagesLayout.AbsoluteContentSize.Y); MessagesContainer.CanvasPosition = Vector2.new(0, MessagesLayout.AbsoluteContentSize.Y) end end)
        end
        
        local function fetchMessages(isInitial)
            if chat_state.is_fetching then return end; chat_state.is_fetching = true
            if isInitial then displayMessage({message="<font color='#AAAAAA'><i>Loading messages...</i></font>", timestamp=os.time()}, true) end
            
            local success, response = try_request("GET", "/get?since="..tostring(chat_state.last_timestamp))
            if isInitial then clearChat() end
            
            if not success then if isInitial then displayMessage({message = "<font color='#FF5555'>Chat Error: " .. tostring(response) .. "</font>", timestamp = os.time()}, true) end; chat_state.is_fetching = false; return end
            
            local s2, messages = pcall(HttpService.JSONDecode, HttpService, response)
            if not s2 then if isInitial then displayMessage({message="<font color='#FF5555'>Error decoding server response.</font>", timestamp=os.time()}, true) end; chat_state.is_fetching = false; return end
            
            if type(messages) == "table" then
                if #messages == 0 and isInitial then displayMessage({message="<font color='#AAAAAA'><i>No new messages. Say hi!</i></font>", timestamp=os.time()}, true) end
                for _, msgData in ipairs(messages) do displayMessage(msgData); chat_state.last_timestamp = math.max(chat_state.last_timestamp, msgData.timestamp or 0) end
            elseif isInitial then displayMessage({message="<font color='#FF5555'>Received invalid data from server.</font>", timestamp=os.time()}, true) end
            chat_state.is_fetching = false
        end

        local function sendMessage()
            local text = ChatInput.Text; if text:gsub("%s", "") == "" then return end
            local originalText = text; ChatInput.Text = "Sending..."; ChatInput.Focusable = false
            local s,r = try_request("POST", "/send", HttpService:JSONEncode({ username = player.Name, userid = player.UserId, message = text }))
            ChatInput.Text = ""; ChatInput.Focusable = true
            if not s then ChatInput.Text = originalText; displayMessage({message="<font color='#FF5555'>Error: Could not send message. " .. tostring(r) .. "</font>", timestamp = os.time()}, true) end
            task.wait(0.5); fetchMessages(false)
        end

        SendButton.MouseButton1Click:Connect(sendMessage)
        ChatInput.FocusLost:Connect(function(e) if e then sendMessage() end end)
        task.spawn(function() while task.wait(CHAT_SETTINGS.PollRate) do if chat_state.is_active then fetchMessages(false) end end end)
        -- #endregion

        -- #region SETTINGS & EXECUTOR
        do local SettingsContainer = Instance.new("ScrollingFrame", SettingsPage); SettingsContainer.Size=UDim2.new(1,0,1,0); SettingsContainer.BackgroundTransparency=1; SettingsContainer.ScrollBarThickness=6; local SettingsLayout = Instance.new("UIGridLayout", SettingsContainer); SettingsLayout.CellPadding=UDim2.new(0,10,0,10); SettingsLayout.CellSize=UDim2.new(0,190,0,40); SettingsLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; createFunctionButton("Red (Default)", SettingsContainer, function() applyTheme("Red") end); createFunctionButton("Yellow", SettingsContainer, function() applyTheme("Yellow") end); createFunctionButton("Blue", SettingsContainer, function() applyTheme("Blue") end); createFunctionButton("Green", SettingsContainer, function() applyTheme("Green") end); createFunctionButton("White", SettingsContainer, function() applyTheme("White") end); createFunctionButton("Rainbow", SettingsContainer, function() activateRainbowTheme() end) end
        local ExecutorInput = Instance.new("TextBox", ExecutorPage); ExecutorInput.Size = UDim2.new(1, -20, 1, -60); ExecutorInput.Position = UDim2.new(0, 10, 0, 10); ExecutorInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); ExecutorInput.TextColor3 = Color3.fromRGB(255, 255, 255); ExecutorInput.PlaceholderText = "--[[ Paste your script here ]]--"; ExecutorInput.Font = Enum.Font.Code; ExecutorInput.TextSize = 14; ExecutorInput.TextWrapped = true; ExecutorInput.TextXAlignment = Enum.TextXAlignment.Left; ExecutorInput.TextYAlignment = Enum.TextYAlignment.Top; ExecutorInput.ClearTextOnFocus = false; Instance.new("UICorner", ExecutorInput).CornerRadius = UDim.new(0, 6); local ExecutorStroke = Instance.new("UIStroke", ExecutorInput); ExecutorStroke.Color = currentTheme.main; table.insert(themableObjects, {object = ExecutorStroke, property="Color", colorType="main"}); local ExecuteButton = createFunctionButton("EXECUTE", ExecutorPage, function() local s,e = pcall(loadstring(ExecutorInput.Text)); if not s then StarterGui:SetCore("SendNotification",{Title="Executor Error", Text=tostring(e)}) end end); ExecuteButton.Size = UDim2.new(0.5, -15, 0, 35); ExecuteButton.Position = UDim2.new(0, 10, 1, -45); local ClearButton = createFunctionButton("CLEAR", ExecutorPage, function() ExecutorInput.Text = "" end); ClearButton.Size = UDim2.new(0.5, -15, 0, 35); ClearButton.Position = UDim2.new(0.5, 5, 1, -45)
        -- #endregion

        -- THEME REGISTRATION
        table.insert(themableObjects, {object=IconFrame, property="BackgroundColor3", colorType="main"}); table.insert(themableObjects, {object=Header, property="BackgroundColor3", colorType="main"}); table.insert(themableObjects, {object=TitleLabel, property="TextColor3", colorType="text"}); table.insert(themableObjects, {object=WelcomeLabel, property="TextColor3", colorType="accent"});table.insert(themableObjects, {object=NurgazyStroke,property="Color",colorType="main"});
        
        -- MAIN LOGIC
        tabs = {HomeButton,MainButton,InfoButton,GuiModsButton,PlayersButton,CommandsButton,PlayersChatButton,SettingsButton,ExecutorButton}
        local pages = {HomePage,MainPage,InfoPage,GuiModsPage,PlayersPage,CommandsPage,PlayersChatPage,SettingsPage,ExecutorPage}
        
        activeTab = HomeButton

        for i,tab in ipairs(tabs) do tab.MouseButton1Click:Connect(function() 
            if activeTab and activeTab.Parent then
                activeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            
            activeTab = tab 

            for _,p in ipairs(pages) do p.Visible=false end
            pages[i].Visible=true
            
            if not rainbowThemeActive then
                activeTab.BackgroundColor3 = currentTheme.main
            end
            
            local was_chat_active = chat_state.is_active
            chat_state.is_active = (tab == PlayersChatButton)
            
            if chat_state.is_active and not was_chat_active then
                clearChat()
                chat_state.last_timestamp = 0
                fetchMessages(true)
            end

            if tab==PlayersButton then pcall(updatePlayerList) end 
        end)end  
        
        Players.PlayerAdded:Connect(function()if PlayersPage.Visible then pcall(updatePlayerList)end end)  
        Players.PlayerRemoving:Connect(function()if PlayersPage.Visible then pcall(updatePlayerList)end end)
        CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible=false; IconFrame.Visible=true end)
        IconFrame.MouseButton1Click:Connect(function() MainFrame.Visible=true; IconFrame.Visible=false end)
        
        if settings.theme == "Rainbow" then
            activateRainbowTheme()
        else
            applyTheme(settings.theme)
        end
    end)
    if not success then  
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="WILSONHUB FATAL ERROR", Text="UI failed to load. Error: "..tostring(err), Duration=20})
        warn("WILSONHUB ERROR: "..tostring(err))
    end
end)

-- 3. АНИМАЦИЯ ЗАГРУЗКИ
local loadDuration=3;for i=0,100 do local progress=i/100;local numDots=math.floor(i/12)%4;LoadingLabel.Text="Loading"..string.rep(".",numDots);PercentageLabel.Text=i.." %";ProgressBarFill.Size=UDim2.new(progress,0,1,0);task.wait(loadDuration/100)end;task.wait(0.2)

-- 4. ЗАВЕРШЕНИЕ
LoadingGui:Destroy()
local WilsonHubGui=player.PlayerGui:FindFirstChild("WilsonHubGui")
if WilsonHubGui then WilsonHubGui.Enabled=true end
pcall(function()StarterGui:SetCore("SendNotification",{Title="WILSON UPLOADED🎮!",Text="This script is for Wilson hackers",Duration=7,Button1="Yes"})end)
