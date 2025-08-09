--[[
    WilsonHub Scripts
    Создано: Gemini (по вашему запросу)
    Обновленный интерфейс с функциями из вашего старого скрипта
]]

-- Основные игровые сервисы
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Локальный игрок
local player = Players.LocalPlayer

-- Основные элементы GUI
local WilsonHubGui = Instance.new("ScreenGui")
WilsonHubGui.Name = "WilsonHubGui"
WilsonHubGui.Parent = player:WaitForChild("PlayerGui")
WilsonHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WilsonHubGui.ResetOnSpawn = false

-- Свернутая иконка (появляется, когда меню закрыто)
local IconFrame = Instance.new("TextButton")
IconFrame.Name = "IconFrame"
IconFrame.Size = UDim2.new(0, 100, 0, 40)
IconFrame.Position = UDim2.new(0, 10, 0, 10)
IconFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
IconFrame.BorderSizePixel = 0
IconFrame.Text = ""
IconFrame.Visible = false -- Изначально невидима
IconFrame.Parent = WilsonHubGui

local iconCorner = Instance.new("UICorner", IconFrame)
iconCorner.CornerRadius = UDim.new(0, 8)

local iconEmoji = Instance.new("TextLabel", IconFrame)
iconEmoji.Size = UDim2.new(1, 0, 0.6, 0)
iconEmoji.Position = UDim2.new(0, 0, 0, 0)
iconEmoji.BackgroundTransparency = 1
iconEmoji.Text = "🔥"
iconEmoji.TextColor3 = Color3.fromRGB(255, 255, 255)
iconEmoji.Font = Enum.Font.SourceSansBold
iconEmoji.TextSize = 24

local iconText = Instance.new("TextLabel", IconFrame)
iconText.Size = UDim2.new(1, 0, 0.4, 0)
iconText.Position = UDim2.new(0, 0, 0.6, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "WILSONHUB"
iconText.TextColor3 = Color3.fromRGB(255, 255, 255)
iconText.Font = Enum.Font.SourceSansBold
iconText.TextSize = 12

-- Главное окно меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = WilsonHubGui

local frameCorner = Instance.new("UICorner", MainFrame)
frameCorner.CornerRadius = UDim.new(0, 8)

-- Заголовок (Header)
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Красный цвет
Header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", Header)
headerCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WilsonHub Scripts"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Кнопка закрытия (X)
local CloseButton = Instance.new("TextButton", Header)
CloseButton.Size = UDim2.new(0, 40, 1, 0)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 20
CloseButton.BackgroundTransparency = 0.1

-- Кнопки переключения вкладок (Tabs)
local TabsContainer = Instance.new("Frame", MainFrame)
TabsContainer.Size = UDim2.new(0, 120, 1, -40)
TabsContainer.Position = UDim2.new(0, 0, 0, 40)
TabsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabsContainer.BorderSizePixel = 0

local HomeButton = Instance.new("TextButton", TabsContainer)
HomeButton.Size = UDim2.new(1, 0, 0, 40)
HomeButton.Position = UDim2.new(0, 0, 0, 10)
HomeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Активный цвет
HomeButton.Text = "Главная"
HomeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeButton.Font = Enum.Font.SourceSansBold
HomeButton.TextSize = 18

local MainButton = Instance.new("TextButton", TabsContainer)
MainButton.Size = UDim2.new(1, 0, 0, 40)
MainButton.Position = UDim2.new(0, 0, 0, 55)
MainButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Неактивный цвет
MainButton.Text = "Скрипты"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.TextSize = 18

-- Страницы с контентом
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -120, 1, -40)
ContentContainer.Position = UDim2.new(0, 120, 0, 40)
ContentContainer.BackgroundTransparency = 1

-- Страница "Главная" (Home Page)
local HomePage = Instance.new("Frame", ContentContainer)
HomePage.Size = UDim2.new(1, 0, 1, 0)
HomePage.BackgroundTransparency = 1
HomePage.Visible = true -- Изначально видима

local PlayerImage = Instance.new("ImageLabel", HomePage)
PlayerImage.Size = UDim2.new(0, 128, 0, 128)
PlayerImage.Position = UDim2.new(0, 15, 0, 15)
PlayerImage.BackgroundTransparency = 1
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
PlayerImage.Image = content

local WelcomeLabel = Instance.new("TextLabel", HomePage)
WelcomeLabel.Size = UDim2.new(1, -150, 0, 40)
WelcomeLabel.Position = UDim2.new(0, 150, 0, 15)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Добро пожаловать, "..player.Name
WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.Font = Enum.Font.SourceSansBold
WelcomeLabel.TextSize = 22
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left

local InfoListLayout = Instance.new("UIListLayout", HomePage)
InfoListLayout.Padding = UDim.new(0, 5)
InfoListLayout.SortOrder = Enum.SortOrder.LayoutOrder
InfoListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

local function createInfoLabel(order, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -150, 0, 20)
	label.Position = UDim2.new(0, 150, 0, 0)
	label.Parent = HomePage
	label.LayoutOrder = order
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	return label
end

createInfoLabel(1, "Имя: "..player.Name).Position = UDim2.new(0,150,0,60)
createInfoLabel(2, "ID: "..player.UserId).Position = UDim2.new(0,150,0,85)
createInfoLabel(3, "Возраст аккаунта: "..player.AccountAge).Position = UDim2.new(0,150,0,110)

local ipInfoLabel = createInfoLabel(4, "IP-адрес: Загрузка...")
ipInfoLabel.Position = UDim2.new(0, 15, 0, 160)
ipInfoLabel.Size = UDim2.new(1, -30, 0, 20)
local countryLabel = createInfoLabel(5, "Страна: Загрузка...")
countryLabel.Position = UDim2.new(0, 15, 0, 185)
countryLabel.Size = UDim2.new(1, -30, 0, 20)

task.spawn(function()
	local success, response = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/"))
	end)
	if success and response then
		ipInfoLabel.Text = "IP-адрес: ".. (response.query or "Неизвестно")
		countryLabel.Text = "Страна: " .. (response.country or "Неизвестно") .. ", " .. (response.city or "Неизвестно")
	else
		ipInfoLabel.Text = "IP-адрес: Не удалось загрузить"
		countryLabel.Text = "Страна: Не удалось загрузить"
	end
end)


-- Страница "Скрипты" (Main Page)
local MainPage = Instance.new("Frame", ContentContainer)
MainPage.Size = UDim2.new(1, 0, 1, 0)
MainPage.BackgroundTransparency = 1
MainPage.Visible = false -- Изначально скрыта

local ScriptsGrid = Instance.new("UIGridLayout", MainPage)
ScriptsGrid.CellPadding = UDim2.new(0, 10, 0, 10)
ScriptsGrid.CellSize = UDim2.new(0, 120, 0, 40)
ScriptsGrid.StartCorner = Enum.StartCorner.TopLeft

-- Создание функциональных кнопок
local function createFunctionButton(text, parent)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 14
    button.Text = text
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)
    return button
end

local loopButton = createFunctionButton("Fe Fire Block: Выкл", ScriptsGrid)
local airButton = createFunctionButton("Ходьба по воздуху: Выкл", ScriptsGrid)
local toolButton = createFunctionButton("Взять огн. предмет", ScriptsGrid)
local teleportButton = createFunctionButton("ТП на кнопку", ScriptsGrid)
local flyGuiButton = createFunctionButton("GUI для полета", ScriptsGrid)

----------------------------------------------------
-- ИНТЕГРАЦИЯ ФУНКЦИЙ ИЗ ВАШЕГО СТАРОГО СКРИПТА --
----------------------------------------------------

-- Функция симуляции касания
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

-- Логика постоянного касания
local loopTouching = false
loopButton.MouseButton1Click:Connect(function()
	loopTouching = not loopTouching
	if loopTouching then
		loopButton.Text = "Fe Fire Block: Вкл"
		loopButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Зеленый
	else
		loopButton.Text = "Fe Fire Block: Выкл"
		loopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Красный
	end

	task.spawn(function()
		while loopTouching do
			for _, part in ipairs(workspace:GetDescendants()) do
				if part:IsA("BasePart") and (part.Name == "사라지는 파트" or part.Name == "Gudock" or part.Name == "Part") then
					touchPartAsync(part)
				end
			end
			task.wait(1)
		end
	end)
end)

-- Логика ходьбы по воздуху
local walkOnAir = false
local airPart = Instance.new("Part")
airPart.Size = Vector3.new(6, 1, 6)
airPart.Anchored = true
airPart.Transparency = 1
airPart.CanCollide = true
airPart.Name = "WilsonAirPlatform"
airPart.Parent = workspace

airButton.MouseButton1Click:Connect(function()
	walkOnAir = not walkOnAir
	if walkOnAir then
		airButton.Text = "Ходьба по воздуху: Вкл"
		airButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
	else
		airButton.Text = "Ходьба по воздуху: Выкл"
		airButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		airPart.Position = Vector3.new(0, -1000, 0) -- Спрятать
	end
end)

RunService.RenderStepped:Connect(function()
	if walkOnAir and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		airPart.Position = hrp.Position - Vector3.new(0, 3.5, 0)
	end
end)

-- Логика инструмента
toolButton.MouseButton1Click:Connect(function()
	local backpack = player:FindFirstChildOfClass("Backpack")
	local existingTool = backpack and backpack:FindFirstChild("Fire Part") or player.Character and player.Character:FindFirstChild("Fire Part")

	toolButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
	task.delay(0.2, function()
		toolButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	end)

	if existingTool then
		existingTool:Destroy()
        toolButton.Text = "Взять огн. предмет"
	else
		local tool = Instance.new("Tool")
		tool.RequiresHandle = false
		tool.Name = "Fire Part"
		tool.Parent = player.Backpack
        toolButton.Text = "Убрать предмет"
		tool.Activated:Connect(function()
			local mouse = player:GetMouse()
			if mouse and mouse.Target then
				touchPartAsync(mouse.Target)
			end
		end)
	end
end)

-- Логика телепорта
teleportButton.MouseButton1Click:Connect(function()
	local gudockPart = workspace:FindFirstChild("Gudock")
	if gudockPart and player.Character then
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        task.delay(0.2, function() teleportButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) end)
		player.Character:MoveTo(gudockPart.Position + Vector3.new(0, 5, 0))
	else
		StarterGui:SetCore("SendNotification", {Title = "WilsonHub", Text = "Часть для телепорта не найдена!", Duration = 3})
	end
end)

-- Выполнение скрипта для полета
flyGuiButton.MouseButton1Click:Connect(function()
    flyGuiButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    task.delay(0.2, function() flyGuiButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) end)
	pcall(function()
		loadstring(game:HttpGet("https://pastebin.com/raw/Y1G9RJgE"))()
	end)
end)


---------------------------------
-- ЛОГИКА ИНТЕРФЕЙСА --
---------------------------------

-- Переключение вкладок
local tabs = {HomeButton, MainButton}
local pages = {HomePage, MainPage}

for i, tab in ipairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        for _, otherTab in ipairs(tabs) do
            otherTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Окрасить все в серый цвет
        end
        for _, page in ipairs(pages) do
            page.Visible = false -- Скрыть все страницы
        end
        
        tab.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Сделать нажатую красной
        pages[i].Visible = true -- Показать соответствующую страницу
    end)
end

-- Закрыть/открыть меню
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IconFrame.Visible = true
end)

IconFrame.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    IconFrame.Visible = false
end)

-- Уведомление
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "WilsonHub Загружен!",
		Text = "Спасибо за использование моего скрипта!",
		Duration = 7,
        Button1 = "OK"
	})
end)
