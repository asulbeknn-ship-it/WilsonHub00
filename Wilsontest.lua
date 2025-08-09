--[[
    WilsonHub Scripts
    Создано: Gemini (по вашему запросу)
    Версия 3.0 (Критическая ошибка с созданием кнопок исправлена)
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
local UIPaddingForScripts = Instance.new("UIPadding", MainPage)
UIPaddingForScripts.PaddingTop = UDim.new(0, 10)
UIPaddingForScripts.PaddingLeft = UDim.new(0, 10)


local ScriptsGrid = Instance.new("UIGridLayout", MainPage)
ScriptsGrid.CellPadding = UDim2.new(0, 10, 0, 10)
ScriptsGrid.CellSize = UDim2.new(0, 120, 0, 40)
ScriptsGrid.StartCorner = Enum.StartCorner.TopLeft

---------------------------------
-- СКРИПТЫ ДЛЯ СТРАНИЦЫ "СКРИПТЫ" --
---------------------------------

-- Функция для создания кнопок
local function createFunctionButton(text, parent)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    button.BorderSizePixel = 0
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Text = text
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)
    return button
end

-- [ТҮЗЕТІЛДІ] Енді батырмалар 'ScriptsGrid'-ке емес, 'MainPage'-ге қосылады. Бұл дұрыс жұмыс істеуі үшін маңызды.
-- Кнопка для Fly
local flyButton = createFunctionButton("Fly", MainPage)
flyButton.MouseButton1Click:Connect(function()
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Жасыл түс
    task.delay(0.3, function() flyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) end) -- Қызылға қайтару

    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WilsonFly"))()
    end)
    if not success then
        warn("WilsonHub Fly Script Error: "..tostring(err))
        StarterGui:SetCore("SendNotification", {Title = "WilsonHub", Text = "Fly скриптін жүктеу кезінде қате!", Duration = 4})
    end
end)

-- Кнопка для Fire Block
local fireBlockButton = createFunctionButton("Fire Block", MainPage)
fireBlockButton.MouseButton1Click:Connect(function()
    fireBlockButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Жасыл түс
    task.delay(0.3, function() fireBlockButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) end) -- Қызылға қайтару

    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Auto-fire-part-universal-/refs/heads/main/Auto%20fire%20part%20universal"))()
    end)
    if not success then
        warn("WilsonHub FireBlock Script Error: "..tostring(err))
        StarterGui:SetCore("SendNotification", {Title = "WilsonHub", Text = "FireBlock скриптін жүктеу кезінде қате!", Duration = 4})
    end
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
		Text = "Скрипт исправлен. Приятного использования!",
		Duration = 7,
        Button1 = "OK"
	})
end)
