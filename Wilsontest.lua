--[[
Made by @Nurgazy_21 tg: nurr_wilson
Script name: WilsonHub
version script: 1.2.0 (Gemini Enhanced)
]]

-- Основные сервисы
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ================================================================= --
-- НОВЫЕ ФУНКЦИИ: МУЗЫКА, ПЕРЕВОДЧИК, ЛОКАЛИЗАЦИЯ
-- ================================================================= --
-- 1. Музыка
local MUSIC_SETTINGS = {
    TrackIDs = {
        "rbxassetid://1842818969", -- Phonk Track 1
        "rbxassetid://6332219708", -- Phonk Track 2
        "rbxassetid://5128562999"  -- Phonk Track 3
    },
    VolumeLevels = { Low = 0.2, Medium = 0.5, High = 1.0 },
    currentTrack = 1
}
local MusicPlayer = Instance.new("Sound")
MusicPlayer.Name = "WilsonHubMusicPlayer"
MusicPlayer.Parent = CoreGui

-- 2. Переводчик
local TRANSLATOR_SETTINGS = {
    -- ВАЖНО: Этот URL - всего лишь заглушка. Вам нужен РАБОЧИЙ прокси-сервер для перевода.
    -- Пример: ваш сервер на Glitch/Heroku, который принимает POST-запросы с текстом и языком,
    -- и возвращает переведенный текст от Google Translate.
    API_Endpoint = "https://your-translator-proxy.glitch.me/translate",
    TargetLanguage = "None" -- 'ru', 'en', 'kk', 'zh-CN', 'fr'
}

-- 3. Локализация (перевод меню)
local activeLocale = "English"
local Localization = {
    -- GENERAL
    Close = { English = "X", Russian = "X", Kazakh = "X", French = "X", ['China language'] = "X" },
    Search = { English = "Search scripts...", Russian = "Поиск скриптов...", Kazakh = "Скрипттерді іздеу...", French = "Rechercher des scripts...", ['China language'] = "搜索脚本..." },
    Send = { English = "Send", Russian = "Отпр.", Kazakh = "Жіберу", French = "Envoyer", ['China language'] = "发送" },
    EnterMessage = { English = "Enter message...", Russian = "Введите сообщение...", Kazakh = "Хабарлама енгізіңіз...", French = "Entrez votre message...", ['China language'] = "输入消息..." },
    Execute = { English = "EXECUTE", Russian = "ВЫПОЛНИТЬ", Kazakh = "ОРЫНДАУ", French = "EXÉCUTER", ['China language'] = "执行" },
    Clear = { English = "CLEAR", Russian = "ОЧИСТИТЬ", Kazakh = "ТАЗАЛАУ", French = "EFFACER", ['China language'] = "清除" },
    Apply = { English = "Apply", Russian = "Прим.", Kazakh = "Қолд.", French = "Appliquer", ['China language'] = "应用" },
    Reset = { English = "Reset", Russian = "Сброс", Kazakh = "Қалпына келтіру", French = "Réinit.", ['China language'] = "重置" },
    -- TABS
    TabHome = { English = "HOME", Russian = "ГЛАВНАЯ", Kazakh = "БАСТЫ", French = "ACCUEIL", ['China language'] = "主页" },
    TabScripts = { English = "SCRIPT'S", Russian = "СКРИПТЫ", Kazakh = "СКРИПТТЕР", French = "SCRIPTS", ['China language'] = "脚本" },
    TabInfo = { English = "INFO", Russian = "ИНФО", Kazakh = "АҚПАРАТ", French = "INFO", ['China language'] = "信息" },
    TabGuiMods = { English = "GUI MODS", Russian = "GUI МОДЫ", Kazakh = "GUI МОДТАР", French = "MODS GUI", ['China language'] = "GUI模组" },
    TabPlayers = { English = "PLAYERS", Russian = "ИГРОКИ", Kazakh = "ОЙЫНШЫЛАР", French = "JOUEURS", ['China language'] = "玩家" },
    TabCommands = { English = "COMMANDS", Russian = "КОМАНДЫ", Kazakh = "КОМАНДАЛАР", French = "COMMANDES", ['China language'] = "命令" },
    TabChat = { English = "PLAYERS CHAT", Russian = "ЧАТ ИГРОКОВ", Kazakh = "ОЙЫНШЫ ЧАТЫ", French = "CHAT", ['China language'] = "玩家聊天" },
    TabSettings = { English = "SETTINGS", Russian = "НАСТРОЙКИ", Kazakh = "БАПТАУЛАР", French = "RÉGLAGES", ['China language'] = "设置" },
    TabExecutor = { English = "EXECUTOR", Russian = "ИСПОЛНИТЕЛЬ", Kazakh = "ОРЫНДАУШЫ", French = "EXÉCUTEUR", ['China language'] = "执行器" },
    TabHelp = { English = "HELP", Russian = "ПОМОЩЬ", Kazakh = "КӨМЕК", French = "AIDE", ['China language'] = "帮助" },
    TabTranslator = { English = "TRANSLATOR", Russian = "ПЕРЕВОДЧИК", Kazakh = "АУДАРМАШЫ", French = "TRADUCTEUR", ['China language'] = "翻译机" },
    -- HOME PAGE
    Welcome = { English = "Welcome, ", Russian = "Добро пожаловать, ", Kazakh = "Қош келдіңіз, ", French = "Bienvenue, ", ['China language'] = "欢迎, " },
    NickName = { English = "NickName: ", Russian = "Никнейм: ", Kazakh = "Лақап аты: ", French = "Surnom: ", ['China language'] = "昵称: " },
    IDAccount = { English = "ID account: ", Russian = "ID аккаунта: ", Kazakh = "Аккаунт ID: ", French = "ID du compte: ", ['China language'] = "账户ID: " },
    LVLAccount = { English = "lvl account: ", Russian = "Возраст аккаунта: ", Kazakh = "Аккаунт жасы: ", French = "Âge du compte: ", ['China language'] = "账户年龄: " },
    CreationDate = { English = "Creation Date: ", Russian = "Дата создания: ", Kazakh = "Құрылған күні: ", French = "Date de création: ", ['China language'] = "创建日期: " },
    Device = { English = "Device: ", Russian = "Устройство: ", Kazakh = "Құрылғы: ", French = "Appareil: ", ['China language'] = "设备: " },
    IPAddress = { English = "IP-address: ", Russian = "IP-адрес: ", Kazakh = "IP-мекенжайы: ", French = "Adresse IP: ", ['China language'] = "IP地址: " },
    Country = { English = "Country: ", Russian = "Страна: ", Kazakh = "Мемлекет: ", French = "Pays: ", ['China language'] = "国家: " },
    -- INFO PAGE
    Bio = { English = "👋Hello, my name is Nurgazy,\n I live in Kazakhstan, and\n I am a young hacker and scripter\n who is just starting out.\n My scripts are high-quality\n and beautiful. Everything is real.", Russian = "👋Привет, меня зовут Нургазы,\n я живу в Казахстане, и\n я молодой хакер и скриптер,\n который только начинает свой путь.\n Мои скрипты качественные\n и красивые. Всё по-настоящему.", Kazakh = "👋Сәлем, менің атым Нұрғазы,\n мен Қазақстанда тұрамын, және\n мен өз жолын енді бастап жатқан\n жас хакер әрі скриптермін.\n Менің скриптерім сапалы\n және әдемі. Барлығы шынайы.", French = "👋Bonjour, je m'appelle Nurgazy,\n j'habite au Kazakhstan, et\n je suis un jeune hacker et scripteur\n qui débute à peine.\n Mes scripts sont de haute qualité\n et magnifiques. Tout est réel.", ['China language'] = "👋你好，我叫Nurgazy，\n我住在哈萨克斯坦，\n我是一名刚刚起步的\n年轻黑客和脚本编写者。\n我的脚本质量高\n而且设计精美。一切都是真实的。" },
    MyProfile = { English = "MY PROFILE", Russian = "МОЙ ПРОФИЛЬ", Kazakh = "МЕНІҢ ПРОФИЛІМ", French = "MON PROFIL", ['China language'] = "我的个人资料" },
    -- GUI MODS PAGE
    CustomHealthbar = { English = "Custom Healthbar", Russian = "Кастомный Хелсбар", Kazakh = "Жеке Денсаулық Жолағы", French = "Barre de vie perso", ['China language'] = "自定义血条" },
    FPSPing = { English = "FPS/Ping Display", Russian = "Отображение FPS/Ping", Kazakh = "FPS/Ping Көрсеткіші", French = "Affichage FPS/Ping", ['China language'] = "显示FPS/延迟" },
    WorldColorChanger = { English = "World Color Changer", Russian = "Смена Цвета Мира", Kazakh = "Әлем Түсін Өзгерткіш", French = "Changeur de couleur du monde", ['China language'] = "世界颜色变换器" },
    -- PLAYERS PAGE
    Ping = { English = "Ping: ", Russian = "Пинг: ", Kazakh = "Пинг: ", French = "Ping: ", ['China language'] = "延迟: " },
    TP = { English = "TP", Russian = "ТП", Kazakh = "ТП", French = "TP", ['China language'] = "传送" },
    Observe = { English = "Observe", Russian = "Наблюдать", Kazakh = "Бақылау", French = "Observer", ['China language'] = "观察" },
    -- SETTINGS PAGE
    TypeLanguages = { English = "Interface Language", Russian = "Язык интерфейса", Kazakh = "Интерфейс тілі", French = "Langue de l'interface", ['China language'] = "界面语言" },
    MusicVolume = { English = "Music Volume", Russian = "Громкость музыки", Kazakh = "Музыка дыбысы", French = "Volume de la musique", ['China language'] = "音乐音量" },
    Low = { English = "Low", Russian = "Тихо", Kazakh = "Жай", French = "Bas", ['China language'] = "低" },
    Medium = { English = "Medium", Russian = "Средне", Kazakh = "Орташа", French = "Moyen", ['China language'] = "中" },
    High = { English = "High", Russian = "Громко", Kazakh = "Қатты", French = "Haut", ['China language'] = "高" },
    -- HELP PAGE
    HelpTitle = { English = "About WilsonHub", Russian = "О WilsonHub", Kazakh = "WilsonHub туралы", French = "À propos de WilsonHub", ['China language'] = "关于WilsonHub" },
    HelpText = { English = "WilsonHub is a multi-functional script designed for both experienced hackers and novice developers. This script provides a wide range of features, from convenient GUI modifications to powerful server-side commands. The developer, Nurgazy_21, is constantly working on improving the script, adding new features and ensuring maximum stability. WilsonHub aims to provide the best possible user experience. Use its power responsibly.", Russian = "WilsonHub - это многофункциональный скрипт, предназначенный как для опытных хакеров, так и для начинающих разработчиков. Этот скрипт предоставляет широкий спектр возможностей, от удобных модификаций интерфейса до мощных серверных команд. Разработчик Nurgazy_21 постоянно работает над улучшением скрипта, добавляя новые функции и обеспечивая максимальную стабильность. WilsonHub стремится предоставить лучший пользовательский опыт. Используйте его возможности ответственно.", Kazakh = "WilsonHub — тәжірибелі хакерлерге де, жаңадан бастаған әзірлеушілерге де арналған көпфункционалды скрипт. Бұл скрипт ыңғайлы интерфейс модификацияларынан бастап, қуатты серверлік командаларға дейінгі кең ауқымды мүмкіндіктерді ұсынады. Әзірлеуші Nurgazy_21 скриптті үнемі жақсартып, жаңа функциялар қосып, максималды тұрақтылықты қамтамасыз етуде. WilsonHub ең жақсы пайдаланушы тәжірибесін ұсынуға тырысады. Оның мүмкіндіктерін жауапкершілікпен пайдаланыңыз.", French = "WilsonHub est un script multifonctionnel conçu pour les hackers expérimentés et les développeurs novices. Ce script offre un large éventail de fonctionnalités, des modifications pratiques de l'interface graphique aux commandes serveur puissantes. Le développeur, Nurgazy_21, travaille constamment à l'amélioration du script, en ajoutant de nouvelles fonctionnalités et en assurant une stabilité maximale. WilsonHub vise à offrir la meilleure expérience utilisateur possible. Utilisez sa puissance de manière responsable.", ['China language'] = "WilsonHub 是一个为经验丰富的黑客和新手开发者设计的多功能脚本。该脚本提供了广泛的功能，从方便的GUI修改到强大的服务器端命令。开发者 Nurgazy_21 正在不断改进脚本，增加新功能并确保最大程度的稳定性。WilsonHub 旨在提供最佳的用户体验。请负责任地使用其功能。" },
    -- TRANSLATOR PAGE
    TranslatorTitle = { English = "Chat Translator", Russian = "Переводчик чата", Kazakh = "Чат аудармашысы", French = "Traducteur de chat", ['China language'] = "聊天翻译器" },
    TranslatorDesc = { English = "Select a language to translate incoming messages.", Russian = "Выберите язык для перевода входящих сообщений.", Kazakh = "Кіріс хабарламаларды аудару үшін тілді таңдаңыз.", French = "Sélectionnez une langue pour traduire les messages entrants.", ['China language'] = "选择一种语言来翻译传入的消息。" },
    RussianLang = { English = "Russian", Russian = "Русский", Kazakh = "Орысша", French = "Russe", ['China language'] = "俄语" },
    EnglishLang = { English = "English", Russian = "Английский", Kazakh = "Ағылшынша", French = "Anglais", ['China language'] = "英语" },
    KazakhLang = { English = "Kazakh", Russian = "Казахский", Kazakh = "Қазақша", French = "Kazakh", ['China language'] = "哈萨克语" },
    ChinaLang = { English = "Chinese", Russian = "Китайский", Kazakh = "Қытайша", French = "Chinois", ['China language'] = "中文" },
    FrenchLang = { English = "French", Russian = "Французский", Kazakh = "Французша", French = "Français", ['China language'] = "法语" },
    TranslatorOff = { English = "Turn Off", Russian = "Выключить", Kazakh = "Сөндіру", French = "Désactiver", ['China language'] = "关闭" },
}
local localizedObjects = {}
local function localize(object, key)
    if not object or not key or not Localization[key] then return end
    table.insert(localizedObjects, {obj = object, key = key})
    local text = Localization[key][activeLocale]
    if text then
        if object:IsA("TextBox") then object.PlaceholderText = text else object.Text = text end
    end
end
local function applyLanguage(langName)
    activeLocale = langName
    settings.language = langName
    if writefile then pcall(function() writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings)) end) end
    
    for _, item in ipairs(localizedObjects) do
        if item.obj and item.obj.Parent and Localization[item.key] and Localization[item.key][activeLocale] then
            local text = Localization[item.key][activeLocale]
            if item.obj:IsA("TextBox") then
                item.obj.PlaceholderText = text
            else
                item.obj.Text = text
            end
        end
    end
end
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
local settings = { theme = "Red", language = "English", musicVolume = "Medium" } -- Добавлены новые настройки
local tabs = {} 

if isfile and isfile("WilsonHubSettings.json") then
    pcall(function() 
        local loadedSettings = HttpService:JSONDecode(readfile("WilsonHubSettings.json"))
        if type(loadedSettings) == "table" then
            for key, value in pairs(loadedSettings) do
                settings[key] = value
            end
        end
    end)
end
activeLocale = settings.language
TRANSLATOR_SETTINGS.TargetLanguage = "None" 

local currentTheme = Themes[settings.theme] or Themes.Red
local rainbowThemeActive = false
local rainbowThemeConnection = nil
local activeTab = nil 

local applyTheme
local activateRainbowTheme
local function saveSettings()
    if writefile then pcall(function() writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings)) end) end
end

local function updateRainbowColors()
    if not rainbowThemeActive then return end
    local hue = tick() % 2 / 2
    local mainColor = Color3.fromHSV(hue, 0.9, 1)
    local accentColor = Color3.fromHSV(hue, 1, 1)
    local brightness = (mainColor.R * 0.299 + mainColor.G * 0.587 + mainColor.B * 0.114)
    local textColor = brightness > 0.5 and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
    for _, item in ipairs(themableObjects) do
        if item.object and item.object.Parent then
            if item.colorType == "main" then item.object[item.property] = mainColor
            elseif item.colorType == "accent" then item.object[item.property] = accentColor
            elseif item.colorType == "text" then item.object[item.property] = textColor end
        end
    end
    if activeTab and activeTab.Parent then activeTab.BackgroundColor3 = accentColor end
end

activateRainbowTheme = function()
    if rainbowThemeActive and rainbowThemeConnection and rainbowThemeConnection.Connected then return end
    currentTheme = {}
    rainbowThemeActive = true
    settings.theme = "Rainbow"
    saveSettings()
    if rainbowThemeConnection then rainbowThemeConnection:Disconnect() end
    rainbowThemeConnection = RunService.RenderStepped:Connect(updateRainbowColors)
end

applyTheme = function(themeName)
    if rainbowThemeConnection then rainbowThemeConnection:Disconnect(); rainbowThemeConnection = nil end
    rainbowThemeActive = false
    if not Themes[themeName] then themeName = "Red" end
    currentTheme = Themes[themeName]
    settings.theme = themeName
    saveSettings()
    for _, item in ipairs(themableObjects) do
        if item.object and item.object.Parent then
            local color = currentTheme[item.colorType]
            if color then item.object[item.property] = color end
        end
    end
    for _, tab_button in ipairs(tabs) do
        if tab_button and tab_button.Parent then tab_button.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end
    end
    if activeTab and activeTab.Parent then activeTab.BackgroundColor3 = currentTheme.main end
end
-- [[ END THEMES & SETTINGS ]]

-- ... (весь остальной код до GUI) ...
local player = Players.LocalPlayer
local customHealthbarGui = nil
local healthbarConnection = nil
function toggleCustomHealthbar(state) if state then if player.Character then createCustomHealthbar(player.Character) end; healthbarConnection = player.CharacterAdded:Connect(createCustomHealthbar) else if customHealthbarGui then customHealthbarGui:Destroy(); customHealthbarGui = nil end; if healthbarConnection then healthbarConnection:Disconnect(); healthbarConnection = nil end end end
function createCustomHealthbar(character) if customHealthbarGui then customHealthbarGui:Destroy() end; local head = character:FindFirstChild("Head"); local humanoid = character:FindFirstChildOfClass("Humanoid"); if not (head and humanoid) then return end; customHealthbarGui = Instance.new("BillboardGui", head); customHealthbarGui.Name = "CustomHealthbarGui"; customHealthbarGui.AlwaysOnTop = true; customHealthbarGui.Size = UDim2.new(0, 150, 0, 40); customHealthbarGui.StudsOffset = Vector3.new(0, 2.5, 0); local healthbar = Instance.new("Frame", customHealthbarGui); healthbar.Name = "Healthbar"; healthbar.Size = UDim2.new(1, 0, 0, 15); healthbar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); healthbar.BorderColor3 = Color3.fromRGB(80, 80, 80); healthbar.BorderSizePixel = 1; Instance.new("UICorner", healthbar).CornerRadius = UDim.new(0, 5); local bar = Instance.new("Frame", healthbar); bar.Name = "Bar"; bar.Size = UDim2.new(1, 0, 1, 0); Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 5); local text = Instance.new("TextLabel", healthbar); text.Name = "Text"; text.Size = UDim2.new(1, 0, 1, 0); text.BackgroundTransparency = 1; text.TextColor3 = Color3.new(1, 1, 1); text.Font = Enum.Font.SourceSansBold; text.TextSize = 12; text.TextStrokeTransparency = 0.5; local function updateHealthbar() if not (humanoid and customHealthbarGui and customHealthbarGui.Parent) then return end; local percentage = humanoid.Health / humanoid.MaxHealth; local color = Color3.fromHSV(0.33 * percentage, 1, 1); bar:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true); bar.BackgroundColor3 = color; text.Text = math.floor(humanoid.Health) .. " / " .. humanoid.MaxHealth end; humanoid.HealthChanged:Connect(updateHealthbar); updateHealthbar() end
local originalColors = {}; local rainbowConnection = nil; local selectedColor = Color3.fromRGB(255, 0, 255); function applyWorldColor(color) for _, part in ipairs(workspace:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then local isCharacterPart = false; for _, p in ipairs(Players:GetPlayers()) do if p.Character and part:IsDescendantOf(p.Character) then isCharacterPart = true; break end end; if not isCharacterPart then if not originalColors[part] then originalColors[part] = part.Color end; part.Color = color end end end end; function resetWorldColors() if rainbowConnection then rainbowConnection:Disconnect(); rainbowConnection = nil end; for part, color in pairs(originalColors) do if part and part.Parent then part.Color = color end end; originalColors = {} end; function toggleRainbowMode(state) if state then if rainbowConnection then rainbowConnection:Disconnect() end; rainbowConnection = RunService.Heartbeat:Connect(function() local hue = tick() % 5 / 5; applyWorldColor(Color3.fromHSV(hue, 1, 1)) end) else if rainbowConnection then rainbowConnection:Disconnect(); rainbowConnection = nil end end end
local statsGui = nil; local statsUpdateConnection = nil; function toggleFpsPing(state) if state then if not (statsGui and statsGui.Parent) then createStatsDisplay() end else if statsGui then statsGui:Destroy(); statsGui = nil end; if statsUpdateConnection then statsUpdateConnection:Disconnect(); statsUpdateConnection = nil end end end; function createStatsDisplay() statsGui = Instance.new("ScreenGui", player.PlayerGui); statsGui.Name = "StatsDisplayGui"; statsGui.ResetOnSpawn = false; statsGui.Enabled = true; statsGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; statsGui.DisplayOrder = 999; local textLabel = Instance.new("TextLabel", statsGui); textLabel.Size = UDim2.new(0, 150, 0, 40); textLabel.Position = UDim2.new(1, -160, 1, -50); textLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20); textLabel.BackgroundTransparency = 0.2; textLabel.BorderSizePixel = 0; textLabel.TextColor3 = Color3.new(1, 1, 1); textLabel.Font = Enum.Font.SourceSansBold; textLabel.TextSize = 16; textLabel.TextXAlignment = Enum.TextXAlignment.Left; textLabel.Text = " FPS: ...\n PING: ..."; Instance.new("UICorner", textLabel).CornerRadius = UDim.new(0, 5); local lastUpdate = 0; local frameCounter = 0; statsUpdateConnection = RunService.Heartbeat:Connect(function(step) frameCounter = frameCounter + 1; local now = tick(); if now - lastUpdate >= 1 then local fps = math.floor(frameCounter / (now - lastUpdate)); local success, ping = pcall(function() return math.floor(player:GetNetworkPing() * 1000) end); if not success then ping = -1 end; textLabel.Text = string.format(" FPS: %d\n PING: %d ms", fps, ping); frameCounter = 0; lastUpdate = now end end) end
local espData = { enabled = false, connections = {}, guis = {} }; local function cleanupEspForPlayer(targetPlayer) if espData.guis[targetPlayer] then if espData.guis[targetPlayer].gui and espData.guis[targetPlayer].gui.Parent then espData.guis[targetPlayer].gui:Destroy() end; if espData.guis[targetPlayer].updateConn then espData.guis[targetPlayer].updateConn:Disconnect() end; espData.guis[targetPlayer] = nil end end; local function cleanupAllEsp() for targetPlayer, _ in pairs(espData.guis) do cleanupEspForPlayer(targetPlayer) end; for _, conn in pairs(espData.connections) do conn:Disconnect() end; espData.connections = {}; espData.guis = {} end; local function createEspForPlayer(targetPlayer) if not espData.enabled or targetPlayer == player then return end; local character=targetPlayer.Character; if not character then return end; local head=character:WaitForChild("Head", 1); if not head then return end; cleanupEspForPlayer(targetPlayer); local espGui=Instance.new("BillboardGui", head); espGui.Name="PLAYER_ESP_GUI"; espGui.AlwaysOnTop=true; espGui.Size=UDim2.new(2,0,1.5,0); espGui.StudsOffset=Vector3.new(0,2.5,0); espGui.LightInfluence=0; local mainFrame=Instance.new("Frame", espGui); mainFrame.BackgroundTransparency=1; mainFrame.Size=UDim2.new(1,0,1,0); local box=Instance.new("Frame", mainFrame); box.BackgroundColor3=Color3.fromRGB(255,255,0); box.BackgroundTransparency=0.5; box.BorderSizePixel=0; box.Size=UDim2.new(1,0,1,0); Instance.new("UICorner",box).CornerRadius=UDim.new(0,3); local innerBox=Instance.new("Frame",box); innerBox.BackgroundColor3=Color3.fromRGB(0,0,0); innerBox.BackgroundTransparency=0.3; innerBox.BorderSizePixel=0; innerBox.Size=UDim2.new(1,-2,1,-2); innerBox.Position=UDim2.new(0.5,-innerBox.AbsoluteSize.X/2,0.5,-innerBox.AbsoluteSize.Y/2); Instance.new("UICorner",innerBox).CornerRadius=UDim.new(0,2); local textLabel=Instance.new("TextLabel",mainFrame); textLabel.BackgroundTransparency=1; textLabel.Size=UDim2.new(1,0,1,0); textLabel.Font=Enum.Font.SourceSans; textLabel.TextSize=14; textLabel.TextColor3=Color3.new(1,1,1); textLabel.TextStrokeColor3=Color3.fromRGB(0,0,0); textLabel.TextStrokeTransparency=0; local function update() if not targetPlayer or not targetPlayer.Parent or not character or not character.Parent or not head or not head.Parent then cleanupEspForPlayer(targetPlayer); return end; local distance=(head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude; textLabel.Text = targetPlayer.Name .. "\n[" .. math.floor(distance) .. "m]" end; espData.guis[targetPlayer] = { gui = espGui, updateConn = RunService.RenderStepped:Connect(update) } end; function togglePlayerEsp(state) espData.enabled=state; if espData.enabled then cleanupAllEsp(); for _,p in ipairs(Players:GetPlayers())do createEspForPlayer(p)end; espData.connections.playerAdded=Players.PlayerAdded:Connect(createEspForPlayer); espData.connections.playerRemoving=Players.PlayerRemoving:Connect(cleanupEspForPlayer); StarterGui:SetCore("SendNotification",{Title="ESP",Text="Player ESP has been enabled.",Duration=5}) else cleanupAllEsp(); StarterGui:SetCore("SendNotification",{Title="ESP",Text="Player ESP has been disabled.",Duration=5}) end end

-- ================================================================= --
-- CHAT BACKEND
-- ================================================================= --
local CHAT_SETTINGS = { API_BACKENDS = { "https://wilson-hub-chat-backend.glitch.me", "https://wilson-hub-chat-mirror1.glitch.me", "https://wilson-hub-chat-mirror2.glitch.me" }, PollRate = 5 }
local current_backend_index = 1
-- ================================================================= --


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
        MainFrame.Size = UDim2.new(0, 600, 0, 350); -- Увеличено для новых вкладок
        MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175);
        MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)  
        local IconFrame = Instance.new("TextButton", WilsonHubGui); IconFrame.Name = "IconFrame"; IconFrame.Size = UDim2.new(0, 100, 0, 40); IconFrame.Position = UDim2.new(0, 10, 0, 10); IconFrame.BorderSizePixel = 0; IconFrame.Text = ""; IconFrame.Visible = false; IconFrame.Active = true; IconFrame.Draggable = true; Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 8)  
        local iconEmoji = Instance.new("TextLabel", IconFrame); iconEmoji.Size = UDim2.new(1, 0, 0.6, 0); iconEmoji.BackgroundTransparency = 1; iconEmoji.Text = "🔥"; iconEmoji.TextColor3 = Color3.fromRGB(255, 255, 255); iconEmoji.Font = Enum.Font.SourceSansBold; iconEmoji.TextSize = 24  
        local iconText = Instance.new("TextLabel", IconFrame); iconText.Size = UDim2.new(1, 0, 0.4, 0); iconText.Position = UDim2.new(0, 0, 0.6, 0); iconText.BackgroundTransparency = 1; iconText.Text = "WILSONHUB"; iconText.TextColor3 = Color3.fromRGB(255, 255, 255); iconText.Font = Enum.Font.SourceSansBold; iconText.TextSize = 12  
        local Header = Instance.new("Frame", MainFrame); Header.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)  
        local TitleLabel = Instance.new("TextLabel", Header); TitleLabel.Size = UDim2.new(1, -40, 1, 0); TitleLabel.Position = UDim2.new(0.5, -TitleLabel.AbsoluteSize.X/2, 0.5, -TitleLabel.AbsoluteSize.Y/2); TitleLabel.BackgroundTransparency = 1; TitleLabel.Text = "WilsonHub (Nurgazy_21)"; TitleLabel.Font = Enum.Font.SourceSansBold; TitleLabel.TextSize = 20  
        local CloseButton = Instance.new("TextButton", Header); CloseButton.Size = UDim2.new(0, 40, 1, 0); CloseButton.Position = UDim2.new(1, -40, 0, 0); CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45); localize(CloseButton, 'Close'); CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255); CloseButton.Font = Enum.Font.SourceSansBold; CloseButton.TextSize = 20  
        
        local TabsContainer = Instance.new("ScrollingFrame", MainFrame); TabsContainer.Name = "TabsContainer"; TabsContainer.Size = UDim2.new(0, 140, 1, -40); TabsContainer.Position = UDim2.new(0, 0, 0, 40); TabsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabsContainer.BorderSizePixel = 0; 
        TabsContainer.ScrollBarThickness = 8; TabsContainer.ScrollBarImageColor3 = currentTheme.main; TabsContainer.ScrollBarImageTransparency = 0.4
        table.insert(themableObjects, {object = TabsContainer, property = "ScrollBarImageColor3", colorType = "main"})

        local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -140, 1, -40); ContentContainer.Position = UDim2.new(0, 140, 0, 40); ContentContainer.BackgroundTransparency = 1
        
        local TabsList = Instance.new("UIListLayout", TabsContainer); TabsList.Padding = UDim.new(0, 10); TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local function createTabButton(textKey) local button = Instance.new("TextButton", TabsContainer); button.Size = UDim2.new(1, -10, 0, 40); button.BackgroundColor3 = Color3.fromRGB(60, 60, 60); localize(button, textKey); button.TextColor3 = Color3.fromRGB(255, 255, 255); button.Font = Enum.Font.SourceSansBold; button.TextSize = 16; button.TextWrapped = true; return button end  
        local HomeButton=createTabButton("TabHome"); local MainButton=createTabButton("TabScripts"); local InfoButton=createTabButton("TabInfo"); local GuiModsButton=createTabButton("TabGuiMods"); local PlayersButton=createTabButton("TabPlayers"); local CommandsButton = createTabButton("TabCommands"); local PlayersChatButton = createTabButton("TabChat"); local SettingsButton=createTabButton("TabSettings"); local ExecutorButton=createTabButton("TabExecutor"); local HelpButton = createTabButton("TabHelp"); local TranslatorButton = createTabButton("TabTranslator")

        task.wait()
        TabsContainer.CanvasSize = UDim2.fromOffset(0, TabsList.AbsoluteContentSize.Y)
        TabsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabsContainer.CanvasSize = UDim2.fromOffset(0, TabsList.AbsoluteContentSize.Y)
        end)
        
        local pages = {}
        local function createPage(parent) local p = Instance.new("Frame", parent); p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.Visible=false; table.insert(pages, p); return p end
        local HomePage=createPage(ContentContainer); HomePage.Visible=true
        local MainPage=createPage(ContentContainer); local InfoPage=createPage(ContentContainer)
        local GuiModsPage=createPage(ContentContainer); local PlayersPage=createPage(ContentContainer)
        local CommandsPage=createPage(ContentContainer); local PlayersChatPage=createPage(ContentContainer)
        local SettingsPage=createPage(ContentContainer); local ExecutorPage=createPage(ContentContainer)
        local HelpPage = createPage(ContentContainer); local TranslatorPage = createPage(ContentContainer)
        
        local function createFunctionButton(textKey, parent, callback) 
            local b = Instance.new("TextButton",parent)
            local theme = (not rainbowThemeActive) and currentTheme or Themes.Red
            b.BackgroundColor3=theme.main
            b.TextColor3=theme.text
            b.Font=Enum.Font.SourceSansBold
            b.TextSize=16
            localize(b, textKey)
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
        local function createInfoLabel(textKey, parent, isStatic, staticText) 
            local label = Instance.new("TextLabel", parent); 
            label.BackgroundTransparency = 1; 
            label.TextColor3 = Color3.fromRGB(255, 255, 255); 
            label.Font = Enum.Font.SourceSans; 
            label.TextSize = 16; 
            label.TextXAlignment = Enum.TextXAlignment.Left; 
            if isStatic then label.Text = staticText else localize(label, textKey) end
            return label 
        end;
        
        -- #region HOME PAGE
        local PlayerImage = Instance.new("ImageLabel", HomePage); PlayerImage.Size = UDim2.new(0, 128, 0, 128); PlayerImage.Position = UDim2.new(0, 15, 0, 15); PlayerImage.BackgroundTransparency = 1; task.spawn(function() pcall(function() PlayerImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end);
        local playerImageBorder = Instance.new("UIStroke", PlayerImage); playerImageBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; playerImageBorder.Color = currentTheme.main; playerImageBorder.Thickness = 2; table.insert(themableObjects, {object = playerImageBorder, property = "Color", colorType = "main"})
        local WelcomeLabel = createInfoLabel("Welcome", HomePage); WelcomeLabel.Position = UDim2.new(0, 150, 0, 35); WelcomeLabel.TextColor3 = currentTheme.accent; WelcomeLabel.Font = Enum.Font.SourceSansBold; WelcomeLabel.TextSize = 22; WelcomeLabel.Text = Localization.Welcome[activeLocale]..player.Name
        createInfoLabel(nil, HomePage, true, Localization.NickName[activeLocale]..player.Name).Position = UDim2.new(0, 150, 0, 60)
        createInfoLabel(nil, HomePage, true, Localization.IDAccount[activeLocale]..player.UserId).Position = UDim2.new(0, 150, 0, 85)
        createInfoLabel(nil, HomePage, true, Localization.LVLAccount[activeLocale]..player.AccountAge).Position = UDim2.new(0, 150, 0, 110)
        local creationDateLabel = createInfoLabel(nil, HomePage, true, Localization.CreationDate[activeLocale] .. "Loading..."); creationDateLabel.Position = UDim2.new(0, 15, 0, 150)
        local deviceLabel = createInfoLabel(nil, HomePage, true, Localization.Device[activeLocale] .. "Loading..."); deviceLabel.Position = UDim2.new(0, 15, 0, 175)
        local ipInfoLabel = createInfoLabel(nil, HomePage, true, Localization.IPAddress[activeLocale] .. "Loading..."); ipInfoLabel.Position = UDim2.new(0, 15, 0, 200)
        local countryLabel = createInfoLabel(nil, HomePage, true, Localization.Country[activeLocale] .. "Loading..."); countryLabel.Position = UDim2.new(0, 15, 0, 225)
        task.spawn(function() pcall(function() local r = HttpService:JSONDecode(game:HttpGet("https://users.roproxy.com/v1/users/"..player.UserId)); creationDateLabel.Text = Localization.CreationDate[activeLocale]..r.created:sub(1,10) end) end)
        task.spawn(function() pcall(function() local r=HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")); local f=""; if r.countryCode then local a,b=127462,string.byte("A"); f=utf8.char(a+(string.byte(r.countryCode,1)-b))..utf8.char(a+(string.byte(r.countryCode,2)-b)) end; ipInfoLabel.Text=Localization.IPAddress[activeLocale]..r.query; countryLabel.Text=Localization.Country[activeLocale]..r.country..", "..r.city.." "..f end) end)
        if UserInputService.TouchEnabled then deviceLabel.Text = Localization.Device[activeLocale] .. "Phone/Tablet" else deviceLabel.Text = Localization.Device[activeLocale] .. "Computer" end
        -- #endregion
        
        -- #region INFO PAGE
        local NurgazyImage=Instance.new("ImageLabel",InfoPage); NurgazyImage.Size=UDim2.new(0,150,0,150); NurgazyImage.Position=UDim2.new(0, 15, 0, 15); NurgazyImage.BackgroundTransparency=1; task.spawn(function() pcall(function() NurgazyImage.Image = Players:GetUserThumbnailAsync(2956155840, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end); 
        local NurgazyStroke=Instance.new("UIStroke",NurgazyImage); NurgazyStroke.Color=currentTheme.main;
        local sE=Instance.new("TextLabel",NurgazyImage); sE.Size=UDim2.new(0,45,0,45); sE.Position=UDim2.new(1,-35,0,-10); sE.BackgroundTransparency=1; sE.Rotation=15; sE.Text="👑"; sE.TextScaled=true; 
        local bioText=createInfoLabel("Bio", InfoPage); bioText.Size=UDim2.new(1,-190,0,150); bioText.Position=UDim2.new(0,175,0,15); bioText.TextWrapped=true; bioText.TextXAlignment=Enum.TextXAlignment.Center; bioText.TextYAlignment=Enum.TextYAlignment.Top
        local MasterLinksContainer=Instance.new("Frame",InfoPage); MasterLinksContainer.Name="MasterLinksContainer"; MasterLinksContainer.Size=UDim2.new(1,-20,0,80); MasterLinksContainer.Position=UDim2.new(0,10,0,180); MasterLinksContainer.BackgroundTransparency=1;
        local MasterListLayout=Instance.new("UIListLayout",MasterLinksContainer); MasterListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; MasterListLayout.SortOrder=Enum.SortOrder.LayoutOrder; MasterListLayout.Padding=UDim.new(0,5);
        local Row1=Instance.new("Frame",MasterLinksContainer); Row1.Name="Row1"; Row1.BackgroundTransparency=1; Row1.Size=UDim2.new(1,0,0,35); local Row1Layout=Instance.new("UIListLayout",Row1); Row1Layout.FillDirection=Enum.FillDirection.Horizontal; Row1Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; Row1Layout.SortOrder=Enum.SortOrder.LayoutOrder; Row1Layout.Padding=UDim.new(0,10);
        local Row2=Instance.new("Frame",MasterLinksContainer); Row2.Name="Row2"; Row2.BackgroundTransparency=1; Row2.Size=UDim2.new(1,0,0,35); local Row2Layout=Instance.new("UIListLayout",Row2); Row2Layout.FillDirection=Enum.FillDirection.Horizontal; Row2Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; Row2Layout.SortOrder=Enum.SortOrder.LayoutOrder; Row2Layout.Padding=UDim.new(0,10);
        local function copyToClipboard(link,name) if setclipboard then setclipboard(link); StarterGui:SetCore("SendNotification",{Title="WilsonHub",Text="Link to "..name .." copied!",Duration=3}) else StarterGui:SetCore("SendNotification",{Title="WilsonHub Error",Text="Function setclipboard not found.",Duration=4}) end end; 
        createFunctionButton("MyProfile", Row1); 
        createFunctionButton("DISCORD", Row1, function() copyToClipboard("https://dsc.gg/wilsonhub", "Discord") end); 
        createFunctionButton("CHANEL", Row1, function() copyToClipboard("https://t.me/wilsonhub_scripts", "Telegram Chanel") end)
        createFunctionButton("VKONTAKTE", Row2, function() copyToClipboard("https://vk.com/wilsonhub_scripts", "VKontakte") end)
        createFunctionButton("WEBSITE", Row2, function() copyToClipboard("https://wilsonhub-scripts.hgweb.ru", "Website") end)
        -- #endregion

        -- #region GUI MODS PAGE
        do local GuiModsContainer=Instance.new("ScrollingFrame",GuiModsPage);GuiModsContainer.Size=UDim2.new(1,0,1,0);GuiModsContainer.BackgroundTransparency=1;GuiModsContainer.ScrollBarThickness=6;local GuiModsList=Instance.new("UIListLayout",GuiModsContainer);GuiModsList.Padding=UDim.new(0,10);GuiModsList.HorizontalAlignment=Enum.HorizontalAlignment.Center;GuiModsList.SortOrder=Enum.SortOrder.LayoutOrder;local function createToggle(textKey,order,callback) local frame=Instance.new("Frame",GuiModsContainer);frame.Size=UDim2.new(1,-20,0,40);frame.BackgroundTransparency=1;frame.LayoutOrder=order;local label=Instance.new("TextLabel",frame);label.Size=UDim2.new(0.6,0,1,0);label.BackgroundTransparency=1;label.Font=Enum.Font.SourceSansBold;label.TextColor3=Color3.new(1,1,1);label.TextSize=16;localize(label, textKey);label.TextXAlignment=Enum.TextXAlignment.Left;local btn=Instance.new("TextButton",frame);btn.Size=UDim2.new(0.4,-10,1,0);btn.Position=UDim2.new(0.6,10,0,0);btn.BackgroundColor3=currentTheme.main;btn.TextColor3=currentTheme.text;btn.Font=Enum.Font.SourceSansBold;btn.Text="OFF";Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6);btn.MouseButton1Click:Connect(function()local state=(btn.Text=="OFF");btn.Text=state and "ON" or "OFF";if state then btn.BackgroundColor3=Color3.fromRGB(0,150,0)else local theme=rainbowThemeActive and Themes.Red or currentTheme;btn.BackgroundColor3=theme.main;btn.TextColor3=theme.text end;if callback then pcall(callback,state,btn) end end);return btn end;createToggle("CustomHealthbar",1,toggleCustomHealthbar);createToggle("FPSPing",2,toggleFpsPing);local colorChangerContainer=Instance.new("Frame",GuiModsContainer);colorChangerContainer.Size=UDim2.new(1,-20,0,200);colorChangerContainer.BackgroundTransparency=1;colorChangerContainer.LayoutOrder=3;local colorList=Instance.new("UIListLayout",colorChangerContainer);colorList.Padding=UDim.new(0,5);local title=Instance.new("TextLabel",colorChangerContainer);title.Size=UDim2.new(1,0,0,20);title.BackgroundTransparency=1;title.Font=Enum.Font.SourceSansBold;title.TextColor3=Color3.new(1,1,1);title.TextSize=18;localize(title,"WorldColorChanger");local colorPreview=Instance.new("Frame",colorChangerContainer);colorPreview.Size=UDim2.new(1,0,0,30);colorPreview.BackgroundColor3=selectedColor;Instance.new("UICorner",colorPreview).CornerRadius=UDim.new(0,6);local function createSlider(label,parent,callback) local sliderFrame=Instance.new("Frame",parent);sliderFrame.Size=UDim2.new(1,0,0,30);sliderFrame.BackgroundTransparency=1;local textLabel=Instance.new("TextLabel",sliderFrame);textLabel.Size=UDim2.new(0.2,0,1,0);textLabel.BackgroundTransparency=1;textLabel.Font=Enum.Font.SourceSansBold;textLabel.Text=label;textLabel.TextColor3=Color3.new(1,1,1);textLabel.TextSize=18;local bar=Instance.new("Frame",sliderFrame);bar.Size=UDim2.new(0.8,-10,0,10);bar.Position=UDim2.new(0.2,0,0.5,-5);bar.BackgroundColor3=Color3.fromRGB(30,30,30);Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0);local handle=Instance.new("TextButton",bar);handle.Size=UDim2.new(0,12,1,4);handle.BackgroundColor3=currentTheme.main;handle.Text="";handle.AnchorPoint=Vector2.new(0.5,0.5);Instance.new("UICorner",handle).CornerRadius=UDim.new(1,0);table.insert(themableObjects,{object=handle,property="BackgroundColor3",colorType="main"});local inputChangedConn,inputEndedConn;handle.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then if inputChangedConn then inputChangedConn:Disconnect()end;if inputEndedConn then inputEndedConn:Disconnect()end;inputChangedConn=UserInputService.InputChanged:Connect(function(inputObj)if inputObj.UserInputType==Enum.UserInputType.MouseMovement or inputObj.UserInputType==Enum.UserInputType.Touch then local pos=inputObj.Position.X-bar.AbsolutePosition.X;local percentage=math.clamp(pos/bar.AbsoluteSize.X,0,1);handle.Position=UDim2.fromScale(percentage,0.5);pcall(callback,percentage)end end);inputEndedConn=UserInputService.InputEnded:Connect(function(inputObj)if inputObj.UserInputType==Enum.UserInputType.MouseButton1 or inputObj.UserInputType==Enum.UserInputType.Touch then if inputChangedConn then inputChangedConn:Disconnect()end;if inputEndedConn then inputEndedConn:Disconnect()end end end)end end);return handle end;local r,g,b=selectedColor.r,selectedColor.g,selectedColor.b;createSlider("R",colorChangerContainer,function(p)r=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(r,0.5);createSlider("G",colorChangerContainer,function(p)g=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(g,0.5);createSlider("B",colorChangerContainer,function(p)b=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(b,0.5);local buttonContainer=Instance.new("Frame",colorChangerContainer);buttonContainer.Size=UDim2.new(1,0,0,40);buttonContainer.BackgroundTransparency=1;buttonContainer.LayoutOrder=4;local btnLayout=Instance.new("UIGridLayout",buttonContainer);btnLayout.CellSize=UDim2.new(0.333,-5,1,0);btnLayout.CellPadding=UDim2.new(0,5,0,0);local rainbowToggle;createFunctionButton("Apply",buttonContainer,function()toggleRainbowMode(false);if rainbowToggle then rainbowToggle.Text="OFF";local theme=rainbowThemeActive and Themes.Red or currentTheme; rainbowToggle.BackgroundColor3=theme.main; end;applyWorldColor(selectedColor)end);rainbowToggle=createToggle("Rainbow",0,function(state)toggleRainbowMode(state)end);rainbowToggle.Parent=buttonContainer;rainbowToggle.Name="RainbowToggle";createFunctionButton("Reset",buttonContainer,function()toggleRainbowMode(false);if rainbowToggle then rainbowToggle.Text="OFF";local theme=rainbowThemeActive and Themes.Red or currentTheme; rainbowToggle.BackgroundColor3=theme.main; end;resetWorldColors()end)end
        -- #endregion
        
        -- #region SCRIPTS PAGE
        local SearchBox = Instance.new("TextBox", MainPage); SearchBox.Size = UDim2.new(1,-20,0,30); SearchBox.Position = UDim2.new(0,10,0,10); SearchBox.BackgroundColor3=Color3.fromRGB(45,45,45); SearchBox.TextColor3=Color3.fromRGB(255,255,255); localize(SearchBox, "Search"); SearchBox.Font=Enum.Font.SourceSans; SearchBox.TextSize=14; Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,6); local SearchBoxStroke = Instance.new("UIStroke", SearchBox); SearchBoxStroke.Color = currentTheme.main; table.insert(themableObjects,{object=SearchBoxStroke, property="Color", colorType="main"}); 
        local ScriptsContainer = Instance.new("ScrollingFrame", MainPage); ScriptsContainer.Size=UDim2.new(1,-20,1,-50); ScriptsContainer.Position=UDim2.new(0,10,0,50); ScriptsContainer.BackgroundTransparency=1; ScriptsContainer.ScrollBarThickness=6; 
        local ScriptsGrid=Instance.new("UIGridLayout",ScriptsContainer); ScriptsGrid.CellPadding=UDim2.new(0,10,0,10); ScriptsGrid.CellSize=UDim2.new(0, 190, 0, 40); ScriptsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        createFunctionButton(nil, ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WilsonFly"))() end).Text = "Fly gui ☑︎"
        createFunctionButton(nil, ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Auto-fire-part-universal-/refs/heads/main/Auto%20fire%20part%20universal"))() end).Text = "Fire Block ☑︎"
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function() local s = SearchBox.Text:lower(); for _, b in ipairs(ScriptsContainer:GetChildren()) do if b:IsA("TextButton") then b.Visible = b.Text:lower():find(s, 1, true) end end end)
        createFunctionButton(nil, ScriptsContainer, function() local p=game:GetService("Players").LocalPlayer;local c=p.Character;if not c then return end;local h=c:WaitForChild("Humanoid");h.WalkSpeed=50;game:GetService("StarterGui"):SetCore("SendNotification",{Title="Speed Hack",Text="Speed increased to 50.",Duration=5});h.Died:Connect(function()end)end).Text = "Speed Hack ☑︎"
        createFunctionButton(nil, ScriptsContainer, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20script'))() end).Text = "Wallhop ☑︎"
        createFunctionButton(nil, ScriptsContainer, function() local p=game:GetService("Players").LocalPlayer;local m=p:GetMouse();game:GetService("StarterGui"):SetCore("SendNotification",{Title="Click Teleport",Text="Activated. Click to teleport.",Duration=7});m.Button1Down:Connect(function()if m.Target and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then p.Character.HumanoidRootPart.CFrame=CFrame.new(m.Hit.Position+Vector3.new(0,3,0))end end)end).Text = "Click Teleport ☑︎"
        createFunctionButton(nil, ScriptsContainer, function() togglePlayerEsp(true) end).Text = "Player ESP ☑︎"
        -- #endregion

        -- #region PLAYERS PAGE
        local PlayersList = Instance.new("ScrollingFrame", PlayersPage); PlayersList.Size = UDim2.new(1, -20, 1, -10); PlayersList.Position = UDim2.new(0, 10, 0, 5); PlayersList.BackgroundColor3 = Color3.fromRGB(45, 45, 45); PlayersList.ScrollBarThickness = 6; Instance.new("UICorner", PlayersList).CornerRadius = UDim.new(0, 6); 
        local PlayersListLayout = Instance.new("UIListLayout", PlayersList); PlayersListLayout.Padding = UDim.new(0, 5); PlayersListLayout.SortOrder = Enum.SortOrder.LayoutOrder; 
        local function updatePlayerList() 
            for _, v in ipairs(PlayersList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            local camera = workspace.CurrentCamera
            for i, p in ipairs(Players:GetPlayers()) do 
                if p then 
                    local template = Instance.new("Frame", PlayersList); template.Name = p.Name; template.Size = UDim2.new(1, 0, 0, 90); template.BackgroundColor3 = Color3.fromRGB(35, 35, 35); template.LayoutOrder = i
                    local thumb = Instance.new("ImageLabel", template); thumb.Size = UDim2.new(0, 40, 0, 40); thumb.Position = UDim2.new(0, 10, 0.5, -20); task.spawn(function() pcall(function() thumb.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) end) end)
                    local nameLabel = createInfoLabel(nil, template, true, p.Name); nameLabel.Size = UDim2.new(0.4, 0, 0, 30); nameLabel.Position = UDim2.new(0, 55, 0, 5); if p == player then nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0) end
                    local pingLabel = createInfoLabel(nil, template, true, "Ping: ..."); pingLabel.Position = UDim2.new(0, 55, 0, 25); pingLabel.Size = UDim2.new(1, -60, 0, 20); pingLabel.TextSize = 14; pingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    local ipLabel = createInfoLabel(nil, template, true, "IP Address: ..."); ipLabel.Position = UDim2.new(0, 55, 0, 45); ipLabel.Size = UDim2.new(1, -60, 0, 20); ipLabel.TextSize = 14; ipLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    local countryLabel = createInfoLabel(nil, template, true, "Country: ..."); countryLabel.Position = UDim2.new(0, 55, 0, 65); countryLabel.Size = UDim2.new(1, -60, 0, 20); countryLabel.TextSize = 14; countryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    if p ~= player then
                        local buttonsFrame = Instance.new("Frame", template); buttonsFrame.BackgroundTransparency = 1; buttonsFrame.Size = UDim2.new(0, 160, 0, 40); buttonsFrame.Position = UDim2.new(1, -165, 0.5, -20);
                        local buttonsLayout = Instance.new("UIGridLayout", buttonsFrame); buttonsLayout.CellSize = UDim2.new(0.5, -5, 1, 0); buttonsLayout.CellPadding = UDim2.new(0, 5, 0, 0);
                        createFunctionButton("TP", buttonsFrame, function() pcall(function() local r1=player.Character and player.Character.HumanoidRootPart; local r2=p.Character and p.Character.HumanoidRootPart; if r1 and r2 then r1.CFrame=r2.CFrame end end) end).Size=UDim2.new(1,0,1,0)
                        createFunctionButton("Observe", buttonsFrame, function() pcall(function() local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid"); if h then if camera.CameraSubject==h then camera.CameraSubject=player.Character.Humanoid else camera.CameraSubject=h end end end) end).Size=UDim2.new(1,0,1,0)
                    end
                    if p == player then 
                        pingLabel.Text = string.format("%s%d ms", Localization.Ping[activeLocale], math.floor(player:GetNetworkPing() * 1000))
                        ipLabel.Text = Localization.IPAddress[activeLocale] .. "Loading..."
                        countryLabel.Text = Localization.Country[activeLocale] .. "Loading..."
                        task.spawn(function()
                            local s,r = pcall(function() return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")) end)
                            if s and r then 
                                local f = ""; if r.countryCode then local a,b=127462,string.byte("A"); f=utf8.char(a+(string.byte(r.countryCode,1)-b))..utf8.char(a+(string.byte(r.countryCode,2)-b)) end
                                ipLabel.Text = Localization.IPAddress[activeLocale] .. (r.query or "Unknown")
                                countryLabel.Text = Localization.Country[activeLocale] .. (r.country or "Unknown") .. " " .. f 
                            else 
                                ipLabel.Text = Localization.IPAddress[activeLocale] .. "Error"; countryLabel.Text = Localization.Country[activeLocale] .. "Error" 
                            end 
                        end)
                    else 
                        pingLabel.Text = string.format("%s~%d ms", Localization.Ping[activeLocale], math.random(40,250));
                        ipLabel.Text = Localization.IPAddress[activeLocale] .. "Private"
                        countryLabel.Text = Localization.Country[activeLocale] .. "Private"
                    end 
                end 
            end; 
            PlayersList.CanvasSize = UDim2.fromOffset(0, PlayersListLayout.AbsoluteContentSize.Y) 
        end
        -- #endregion
        
        -- #region COMMANDS PAGE
        do local Commands={};local CommandAliases={};local ConsoleOutput=nil;local function logToConsole(text,color)if not ConsoleOutput or not ConsoleOutput.Parent then return end;local label=Instance.new("TextLabel");label.Name="ConsoleLog";label.Text=tostring(text);label.TextColor3=color or Color3.new(1,1,1);label.Font=Enum.Font.Code;label.TextSize=14;label.TextXAlignment=Enum.TextXAlignment.Left;label.BackgroundTransparency=1;label.TextWrapped=true;label.Size=UDim2.new(1,-10,0,0);label.AutomaticSize=Enum.AutomaticSize.Y;label.Parent=ConsoleOutput end;local function findPlayers(query)query=query:lower();local f={};if query=="all"then return Players:GetPlayers()elseif query=="others"then for _,p in ipairs(Players:GetPlayers())do if p~=player then table.insert(f,p)end end;return f elseif query=="me"then return{player}elseif query=="random"then local a=Players:GetPlayers();if #a>0 then return{a[math.random(1,#a)]}end;return{}end;for _,p in ipairs(Players:GetPlayers())do if p.Name:lower():sub(1,#query)==query then table.insert(f,p)end end;return f end;local function registerCommand(name,aliases,args,desc,func)local d={Name=name:lower(),Aliases=aliases,Args=args,Description=desc,Function=func};Commands[d.Name]=d;for _,a in ipairs(aliases)do CommandAliases[a:lower()]=d.Name end end;local function processCommand(fullCommand)if not fullCommand:find("^/")then logToConsole("Error: Commands must start with /",Color3.new(1,.4,.4));return end;local noPrefix=fullCommand:sub(2);local args={};for arg in noPrefix:gmatch("[^%s]+")do table.insert(args,arg)end;if #args==0 then return end;local cmdName=table.remove(args,1):lower();local cmdData=Commands[cmdName]or Commands[CommandAliases[cmdName]];if cmdData then logToConsole("Executing: "..fullCommand,Color3.new(.4,1,.4));pcall(cmdData.Function,args)else logToConsole("Error: Command not found: "..cmdName,Color3.new(1,.4,.4))end end;local ConsoleFrame=Instance.new("Frame",CommandsPage);ConsoleFrame.Size=UDim2.new(1,-20,1,-10);ConsoleFrame.Position=UDim2.new(0,10,0,5);ConsoleFrame.BackgroundColor3=Color3.fromRGB(25,25,25);ConsoleFrame.BorderSizePixel=0;Instance.new("UICorner",ConsoleFrame).CornerRadius=UDim.new(0,6);ConsoleOutput=Instance.new("ScrollingFrame",ConsoleFrame);ConsoleOutput.Size=UDim2.new(1,0,1,-40);ConsoleOutput.BackgroundColor3=Color3.fromRGB(30,30,30);ConsoleOutput.BorderSizePixel=0;ConsoleOutput.ScrollBarThickness=6;local oL=Instance.new("UIListLayout",ConsoleOutput);oL.Padding=UDim.new(0,5);oL.SortOrder=Enum.SortOrder.LayoutOrder;local CommandInput=Instance.new("TextBox",ConsoleFrame);CommandInput.Size=UDim2.new(1,0,0,40);CommandInput.Position=UDim2.new(0,0,1,-40);CommandInput.BackgroundColor3=Color3.fromRGB(45,45,45);CommandInput.TextColor3=Color3.new(1,1,1);CommandInput.Font=Enum.Font.Code;CommandInput.TextSize=16;CommandInput.PlaceholderText="/command [target] [args]";CommandInput.ClearTextOnFocus=false;CommandInput.FocusLost:Connect(function(e)if e then local t=CommandInput.Text;if #t>0 then processCommand(t);CommandInput.Text=""end end end);registerCommand("fly",{},"","Enables flying.",function()loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WilsonFly"))()end);registerCommand("speed",{"walkspeed","ws"},"[player] [value]","Changes walkspeed.",function(a)local t=findPlayers(a[1]or"me");local s=tonumber(a[2]or 100);if not s then logToConsole("Invalid speed.",Color3.new(1,.4,.4))return end;for _,p in ipairs(t)do if p.Character and p.Character:FindFirstChild("Humanoid")then p.Character.Humanoid.WalkSpeed=s end end end);registerCommand("jp",{"jumppower"},"[player] [value]","Changes jump power.",function(a)local t=findPlayers(a[1]or"me");local p=tonumber(a[2]or 100);if not p then logToConsole("Invalid power.",Color3.new(1,.4,.4))return end;for _,plr in ipairs(t)do if plr.Character and plr.Character:FindFirstChild("Humanoid")then plr.Character.Humanoid.JumpPower=p end end end);registerCommand("kill",{},"[player]","Kills the player.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do if p.Character and p.Character:FindFirstChild("Humanoid")then p.Character.Humanoid.Health=0 end end end);registerCommand("tp",{"teleport"},"[player_to]","Teleports to player.",function(a)if not a[1]then logToConsole("Usage: /tp [target]",Color3.new(1,.4,.4))return end;local t=findPlayers(a[1]);if #t==0 then logToConsole("Target not found.",Color3.new(1,.4,.4))return end;local cF=player.Character;local cT=t[1].Character;if cF and cT and cF:FindFirstChild("HumanoidRootPart")and cT:FindFirstChild("HumanoidRootPart")then cF.HumanoidRootPart.CFrame=cT.HumanoidRootPart.CFrame end end);registerCommand("jerk",{},"[player]","Makes a player spin.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c and c:FindFirstChild("HumanoidRootPart")then local r=c.HumanoidRootPart;r.Anchored=true;local j=Instance.new("BodyAngularVelocity",r);j.Name="JERK_EFFECT";j.MaxTorque=Vector3.new(math.huge,math.huge,math.huge);j.AngularVelocity=Vector3.new(100,100,100)end end end);registerCommand("unjerk",{},"[player]","Stops the jerk effect.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c and c:FindFirstChild("HumanoidRootPart")then local r=c.HumanoidRootPart;local j=r:FindFirstChild("JERK_EFFECT");if j then j:Destroy()end;r.Anchored=false end end end);registerCommand("bang",{},"[player]","Flings a player.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c then for _,prt in ipairs(c:GetDescendants())do if prt:IsA("BasePart")then prt.AssemblyLinearVelocity=Vector3.new(math.random(-200,200),200,math.random(-200,200))end end end end end);registerCommand("unbang",{},"[player]","Resets velocity after bang.",function(a)local t=findPlayers(a[1]or"me");for _,p in ipairs(t)do local c=p.Character;if c then for _,prt in ipairs(c:GetDescendants())do if prt:IsA("BasePart")then prt.AssemblyLinearVelocity=Vector3.new(0,0,0)end end end end end);registerCommand("clear",{"cls"},"","Clears the console.",function()for _,v in ipairs(ConsoleOutput:GetChildren())do if v.Name=="ConsoleLog"then v:Destroy()end end end);logToConsole("WilsonHub Commands:",currentTheme.accent);local sC={};for n,d in pairs(Commands)do table.insert(sC,d)end;table.sort(sC,function(a,b)return a.Name<b.Name end);for _,d in ipairs(sC)do logToConsole(string.format("/%s %s - %s",d.Name,d.Args,d.Description),Color3.new(.8,.8,.8))end end
        -- #endregion
        
        -- #region PLAYERS CHAT PAGE
        local chat_state = { is_active = false, last_timestamp = 0, is_fetching = false }
        local ChatTitle = createInfoLabel(nil, PlayersChatPage, true, "Global Chat"); ChatTitle.Position=UDim2.new(0,10,0,5); ChatTitle.Font=Enum.Font.SourceSansBold; ChatTitle.TextSize=18; table.insert(themableObjects,{object=ChatTitle, property="TextColor3", colorType="accent"})
        local MessagesContainer = Instance.new("ScrollingFrame", PlayersChatPage); MessagesContainer.Size=UDim2.new(1,-20,1,-85); MessagesContainer.Position=UDim2.new(0,10,0,35); MessagesContainer.BackgroundColor3=Color3.fromRGB(45,45,45); MessagesContainer.ScrollBarThickness=6; Instance.new("UICorner",MessagesContainer).CornerRadius=UDim.new(0,6);
        local MessagesLayout = Instance.new("UIListLayout", MessagesContainer); MessagesLayout.Padding=UDim.new(0,8); MessagesLayout.SortOrder=Enum.SortOrder.LayoutOrder;
        local ChatInput = Instance.new("TextBox", PlayersChatPage); ChatInput.Size=UDim2.new(1,-90,0,40); ChatInput.Position=UDim2.new(0,10,1,-45); ChatInput.BackgroundColor3=Color3.fromRGB(45,45,45); ChatInput.TextColor3=Color3.new(1,1,1); ChatInput.Font=Enum.Font.SourceSans; ChatInput.TextSize=14; localize(ChatInput, "EnterMessage"); Instance.new("UICorner",ChatInput).CornerRadius=UDim.new(0,6)
        local SendButton = createFunctionButton("Send", PlayersChatPage); SendButton.Size=UDim2.new(0,60,0,40); SendButton.Position=UDim2.new(1,-70,1,-45);
        
        local function try_request(method, endpoint, payload) local last_error = "All chat servers are unavailable."; for i = 1, #CHAT_SETTINGS.API_BACKENDS do local url = CHAT_SETTINGS.API_BACKENDS[current_backend_index] .. endpoint; local success, response; if method == "GET" then success, response = pcall(game.HttpGet, game, url, true) else success, response = pcall(HttpService.PostAsync, HttpService, url, payload, Enum.HttpContentType.ApplicationJson) end; if success then return true, response end; last_error = tostring(response); current_backend_index = (current_backend_index % #CHAT_SETTINGS.API_BACKENDS) + 1; task.wait(0.2) end; return false, last_error end
        local function clearChat() for _,v in ipairs(MessagesContainer:GetChildren()) do if v.Name == "MessageFrame" then v:Destroy() end end end
        
        local function translateText(text, callback)
            if TRANSLATOR_SETTINGS.TargetLanguage == "None" or TRANSLATOR_SETTINGS.TargetLanguage == "" then callback(text); return end
            local success, response = pcall(function()
                return HttpService:PostAsync(TRANSLATOR_SETTINGS.API_Endpoint, HttpService:JSONEncode({text = text, target = TRANSLATOR_SETTINGS.TargetLanguage}), Enum.HttpContentType.ApplicationJson)
            end)
            if success then
                local s, res_data = pcall(HttpService.JSONDecode, HttpService, response)
                if s and res_data and res_data.translated_text then
                    callback(res_data.translated_text)
                else
                    callback(text .. " [trans. err]")
                end
            else
                callback(text .. " [trans. api err]")
            end
        end

        local function displayMessage(msgData, isSystemMessage)
            local msgFrame = Instance.new("Frame", MessagesContainer); msgFrame.Name = "MessageFrame"; msgFrame.BackgroundTransparency = 1; msgFrame.Size = UDim2.new(1, 0, 0, 0); msgFrame.AutomaticSize = Enum.AutomaticSize.Y; msgFrame.LayoutOrder = msgData.timestamp
            local hLayout = Instance.new("UIListLayout", msgFrame); hLayout.FillDirection = Enum.FillDirection.Horizontal; hLayout.VerticalAlignment = Enum.VerticalAlignment.Top; hLayout.Padding = UDim.new(0, 8)
            local avatar = Instance.new("ImageLabel", msgFrame); avatar.Size = UDim2.new(0, 40, 0, 40); avatar.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
            local textFrame = Instance.new("Frame", msgFrame); textFrame.BackgroundTransparency = 1; textFrame.Size = UDim2.new(1, -50, 0, 0); textFrame.AutomaticSize = Enum.AutomaticSize.Y
            local vLayout = Instance.new("UIListLayout", textFrame); vLayout.Padding = UDim.new(0, 2)
            local nameLabel = Instance.new("TextLabel", textFrame); nameLabel.BackgroundTransparency = 1; nameLabel.Size = UDim2.new(1, 0, 0, 16); nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.TextSize = 15; nameLabel.TextColor3 = currentTheme.accent; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            local contentLabel = Instance.new("TextLabel", textFrame); contentLabel.BackgroundTransparency = 1; contentLabel.Size = UDim2.new(1, 0, 0, 0); contentLabel.AutomaticSize = Enum.AutomaticSize.Y; contentLabel.Font = Enum.Font.SourceSans; contentLabel.TextSize = 14; contentLabel.TextColor3 = Color3.fromRGB(255, 255, 255); contentLabel.TextWrapped = true; contentLabel.RichText = true; contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            if isSystemMessage then avatar.Visible = false; nameLabel.Visible = false; textFrame.Size = UDim2.new(1, -5, 0, 0); contentLabel.TextXAlignment = Enum.TextXAlignment.Center; contentLabel.Text = msgData.message
            else
                if tonumber(msgData.userid) == player.UserId then nameLabel.Text = "You" else nameLabel.Text = msgData.username end
                task.spawn(function() local s, thumb = pcall(Players.GetUserThumbnailAsync, Players, tonumber(msgData.userid), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42); if s and avatar and avatar.Parent then avatar.Image = thumb end end)
                table.insert(themableObjects, {object=nameLabel, property="TextColor3", colorType="accent"})
                translateText(msgData.message, function(translated) contentLabel.Text = translated end)
            end
            task.delay(0.2, function() if MessagesContainer and MessagesLayout then MessagesContainer.CanvasSize = UDim2.fromOffset(0, MessagesLayout.AbsoluteContentSize.Y); if MessagesContainer.CanvasPosition.Y < MessagesLayout.AbsoluteContentSize.Y - MessagesContainer.AbsoluteSize.Y - 50 then MessagesContainer.CanvasPosition = Vector2.new(0, MessagesLayout.AbsoluteContentSize.Y) end end end)
        end
        
        local function fetchMessages(isInitial) if chat_state.is_fetching then return end; chat_state.is_fetching = true; if isInitial then displayMessage({message="<font color='#AAAAAA'><i>Loading messages...</i></font>", timestamp=os.time()}, true) end; local success, response = try_request("GET", "/get?since="..tostring(chat_state.last_timestamp)); if isInitial then clearChat() end; if not success then if isInitial then displayMessage({message = "<font color='#FF5555'>Chat Error: " .. tostring(response) .. "</font>", timestamp = os.time()}, true) end; chat_state.is_fetching = false; return end; local s2, messages = pcall(HttpService.JSONDecode, HttpService, response); if not s2 then if isInitial then displayMessage({message="<font color='#FF5555'>Error decoding server response.</font>", timestamp=os.time()}, true) end; chat_state.is_fetching = false; return end; if type(messages) == "table" then if #messages == 0 and isInitial then displayMessage({message="<font color='#AAAAAA'><i>No new messages. Say hi!</i></font>", timestamp=os.time()}, true) end; for _, msgData in ipairs(messages) do displayMessage(msgData); chat_state.last_timestamp = math.max(chat_state.last_timestamp, msgData.timestamp or 0) end elseif isInitial then displayMessage({message="<font color='#FF5555'>Received invalid data from server.</font>", timestamp=os.time()}, true) end; chat_state.is_fetching = false end
        local function sendMessage() local text = ChatInput.Text; if text:gsub("%s", "") == "" then return end; local originalText = text; ChatInput.Text = "Sending..."; ChatInput.Focusable = false; local s,r = try_request("POST", "/send", HttpService:JSONEncode({ username = player.Name, userid = player.UserId, message = text })); ChatInput.Text = ""; ChatInput.Focusable = true; if not s then ChatInput.Text = originalText; displayMessage({message="<font color='#FF5555'>Error: Could not send message. " .. tostring(r) .. "</font>", timestamp = os.time()}, true) end; task.wait(0.5); fetchMessages(false) end
        SendButton.MouseButton1Click:Connect(sendMessage); ChatInput.FocusLost:Connect(function(e) if e then sendMessage() end end)
        task.spawn(function() while task.wait(CHAT_SETTINGS.PollRate) do if chat_state.is_active then fetchMessages(false) end end end)
        -- #endregion

        -- #region SETTINGS
        do 
            local SettingsContainer = Instance.new("ScrollingFrame", SettingsPage); SettingsContainer.Size=UDim2.new(1,-10,1,-10); SettingsContainer.Position=UDim2.new(0,5,0,5); SettingsContainer.BackgroundTransparency=1; SettingsContainer.ScrollBarThickness=6; 
            local SettingsLayout = Instance.new("UIListLayout", SettingsContainer); SettingsLayout.Padding=UDim.new(0,15); SettingsLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
            
            -- THEMES
            local ThemeFrame = Instance.new("Frame", SettingsContainer); ThemeFrame.BackgroundTransparency=1; ThemeFrame.Size=UDim2.new(1,0,0,100);
            local ThemeTitle = createInfoLabel(nil, ThemeFrame, true, "Color Theme"); ThemeTitle.Font=Enum.Font.SourceSansBold; ThemeTitle.TextSize=18;
            local ThemeGrid = Instance.new("UIGridLayout", ThemeFrame); ThemeGrid.CellPadding=UDim2.new(0,10,0,10); ThemeGrid.CellSize=UDim2.new(0,120,0,40); ThemeGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left; ThemeGrid.StartPosition = UDim2.new(0,0,0,30)
            createFunctionButton(nil, ThemeFrame, function() applyTheme("Red") end).Text = "Red (Default)"; createFunctionButton(nil, ThemeFrame, function() applyTheme("Yellow") end).Text = "Yellow"; createFunctionButton(nil, ThemeFrame, function() applyTheme("Blue") end).Text = "Blue"; createFunctionButton(nil, ThemeFrame, function() applyTheme("Green") end).Text = "Green"; createFunctionButton(nil, ThemeFrame, function() applyTheme("White") end).Text = "White"; createFunctionButton(nil, ThemeFrame, function() activateRainbowTheme() end).Text = "Rainbow";

            -- MENU LANGUAGE
            local LangFrame = Instance.new("Frame", SettingsContainer); LangFrame.BackgroundTransparency=1; LangFrame.Size=UDim2.new(1,0,0,100);
            local LangTitle = createInfoLabel("TypeLanguages", LangFrame); LangTitle.Font=Enum.Font.SourceSansBold; LangTitle.TextSize=18;
            local LangGrid = Instance.new("UIGridLayout", LangFrame); LangGrid.CellPadding=UDim2.new(0,10,0,10); LangGrid.CellSize=UDim2.new(0,120,0,40); LangGrid.HorizontalAlignment=Enum.HorizontalAlignment.Left; LangGrid.StartPosition = UDim2.new(0,0,0,30)
            createFunctionButton("EnglishLang", LangFrame, function() applyLanguage("English") end); createFunctionButton("RussianLang", LangFrame, function() applyLanguage("Russian") end); createFunctionButton("KazakhLang", LangFrame, function() applyLanguage("Kazakh") end); createFunctionButton("ChinaLang", LangFrame, function() applyLanguage("China language") end); createFunctionButton("FrenchLang", LangFrame, function() applyLanguage("French") end);
            
            -- MUSIC VOLUME
            local MusicFrame = Instance.new("Frame", SettingsContainer); MusicFrame.BackgroundTransparency=1; MusicFrame.Size=UDim2.new(1,0,0,60);
            local MusicTitle = createInfoLabel("MusicVolume", MusicFrame); MusicTitle.Font=Enum.Font.SourceSansBold; MusicTitle.TextSize=18;
            local MusicGrid = Instance.new("UIGridLayout", MusicFrame); MusicGrid.CellPadding=UDim2.new(0,10,0,10); MusicGrid.CellSize=UDim2.new(0,120,0,40); MusicGrid.HorizontalAlignment=Enum.HorizontalAlignment.Left; MusicGrid.StartPosition = UDim2.new(0,0,0,30)
            local function setVolume(levelName) MusicPlayer.Volume = MUSIC_SETTINGS.VolumeLevels[levelName]; settings.musicVolume = levelName; saveSettings() end
            createFunctionButton("Low", MusicFrame, function() setVolume("Low") end); createFunctionButton("Medium", MusicFrame, function() setVolume("Medium") end); createFunctionButton("High", MusicFrame, function() setVolume("High") end)
        end
        -- #endregion

        -- #region EXECUTOR
        local ExecutorInput = Instance.new("TextBox", ExecutorPage); ExecutorInput.Size = UDim2.new(1, -20, 1, -60); ExecutorInput.Position = UDim2.new(0, 10, 0, 10); ExecutorInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); ExecutorInput.TextColor3 = Color3.fromRGB(255, 255, 255); ExecutorInput.PlaceholderText = "--[[ Paste your script here ]]--"; ExecutorInput.Font = Enum.Font.Code; ExecutorInput.TextSize = 14; ExecutorInput.TextWrapped = true; ExecutorInput.TextXAlignment = Enum.TextXAlignment.Left; ExecutorInput.TextYAlignment = Enum.TextYAlignment.Top; ExecutorInput.ClearTextOnFocus = false; Instance.new("UICorner", ExecutorInput).CornerRadius = UDim.new(0, 6); local ExecutorStroke = Instance.new("UIStroke", ExecutorInput); ExecutorStroke.Color = currentTheme.main; table.insert(themableObjects, {object = ExecutorStroke, property="Color", colorType="main"}); local ExecuteButton = createFunctionButton("Execute", ExecutorPage, function() local s,e = pcall(loadstring(ExecutorInput.Text)); if not s then StarterGui:SetCore("SendNotification",{Title="Executor Error", Text=tostring(e)}) end end); ExecuteButton.Size = UDim2.new(0.5, -15, 0, 35); ExecuteButton.Position = UDim2.new(0, 10, 1, -45); local ClearButton = createFunctionButton("Clear", ExecutorPage, function() ExecutorInput.Text = "" end); ClearButton.Size = UDim2.new(0.5, -15, 0, 35); ClearButton.Position = UDim2.new(0.5, 5, 1, -45)
        -- #endregion

        -- #region HELP PAGE
        do
            local HelpContainer = Instance.new("Frame", HelpPage); HelpContainer.Size=UDim2.new(1,-20,1,-20); HelpContainer.Position=UDim2.new(0,10,0,10); HelpContainer.BackgroundTransparency=1;
            local HelpList = Instance.new("UIListLayout", HelpContainer); HelpList.Padding = UDim.new(0,10); HelpList.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            local Title = createInfoLabel("HelpTitle", HelpContainer); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20; Title.TextColor3=currentTheme.accent; Title.TextXAlignment=Enum.TextXAlignment.Center; Title.Size = UDim2.new(1,0,0,30); table.insert(themableObjects, {object=Title, property="TextColor3", colorType="accent"})
            local Description = createInfoLabel("HelpText", HelpContainer); Description.TextWrapped = true; Description.Size = UDim2.new(1,0,1,-40); Description.TextYAlignment = Enum.TextYAlignment.Top;
        end
        -- #endregion
        
        -- #region TRANSLATOR PAGE
        do
            local TransContainer = Instance.new("Frame", TranslatorPage); TransContainer.Size=UDim2.new(1,-20,1,-20); TransContainer.Position=UDim2.new(0,10,0,10); TransContainer.BackgroundTransparency=1;
            local TransList = Instance.new("UIListLayout", TransContainer); TransList.Padding = UDim.new(0,10); TransList.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            local Title = createInfoLabel("TranslatorTitle", TransContainer); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20; Title.TextColor3=currentTheme.accent; Title.TextXAlignment=Enum.TextXAlignment.Center; Title.Size = UDim2.new(1,0,0,30); table.insert(themableObjects, {object=Title, property="TextColor3", colorType="accent"})
            local Desc = createInfoLabel("TranslatorDesc", TransContainer); Desc.TextXAlignment=Enum.TextXAlignment.Center; Desc.Size=UDim2.new(1,0,0,40); Desc.TextWrapped=true;
            local Grid = Instance.new("UIGridLayout", TransContainer); Grid.CellPadding=UDim2.new(0,10,0,10); Grid.CellSize=UDim2.new(0,120,0,40);
            local function setTransLang(langCode, langName) TRANSLATOR_SETTINGS.TargetLanguage = langCode; StarterGui:SetCore("SendNotification", {Title="Translator", Text="Chat will be translated to "..langName, Duration=5}) end
            createFunctionButton("RussianLang", TransContainer, function() setTransLang('ru', "Russian") end)
            createFunctionButton("EnglishLang", TransContainer, function() setTransLang('en', "English") end)
            createFunctionButton("KazakhLang", TransContainer, function() setTransLang('kk', "Kazakh") end)
            createFunctionButton("ChinaLang", TransContainer, function() setTransLang('zh-CN', "Chinese") end)
            createFunctionButton("FrenchLang", TransContainer, function() setTransLang('fr', "French") end)
            createFunctionButton("TranslatorOff", TransContainer, function() setTransLang('None', "Off") end)
        end
        -- #endregion

        -- THEME REGISTRATION
        table.insert(themableObjects, {object=IconFrame, property="BackgroundColor3", colorType="main"}); table.insert(themableObjects, {object=Header, property="BackgroundColor3", colorType="main"}); table.insert(themableObjects, {object=TitleLabel, property="TextColor3", colorType="text"}); table.insert(themableObjects, {object=WelcomeLabel, property="TextColor3", colorType="accent"});table.insert(themableObjects, {object=NurgazyStroke,property="Color",colorType="main"});
        
        -- MAIN LOGIC
        tabs = {HomeButton,MainButton,InfoButton,GuiModsButton,PlayersButton,CommandsButton,PlayersChatButton,SettingsButton,ExecutorButton,HelpButton,TranslatorButton}
        activeTab = HomeButton
        
        for i,tab in ipairs(tabs) do tab.MouseButton1Click:Connect(function() 
            if activeTab and activeTab.Parent then activeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end
            activeTab = tab 
            for j, p in ipairs(pages) do p.Visible = (i == j) end
            if not rainbowThemeActive then activeTab.BackgroundColor3 = currentTheme.main end
            
            local was_chat_active = chat_state.is_active
            chat_state.is_active = (tab == PlayersChatButton)
            
            if chat_state.is_active and not was_chat_active then clearChat(); chat_state.last_timestamp = 0; fetchMessages(true) end
            if tab==PlayersButton then pcall(updatePlayerList) end 
        end)end  
        
        Players.PlayerAdded:Connect(function()if PlayersPage.Visible then pcall(updatePlayerList)end end)  
        Players.PlayerRemoving:Connect(function()if PlayersPage.Visible then pcall(updatePlayerList)end end)
        CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible=false; IconFrame.Visible=true end)
        IconFrame.MouseButton1Click:Connect(function() MainFrame.Visible=true; IconFrame.Visible=false end)
        
        if settings.theme == "Rainbow" then activateRainbowTheme() else applyTheme(settings.theme) end
        applyLanguage(settings.language) -- Применяем язык при запуске
    end)
    if not success then  
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="WILSONHUB FATAL ERROR", Text="UI failed to load. Error: "..tostring(err), Duration=20})
        warn("WILSONHUB ERROR: "..tostring(err))
    end
end)

-- 3. АНИМАЦИЯ ЗАГРУЗКИ
local loadDuration=3;for i=0,100 do local progress=i/100;local numDots=math.floor(i/12)%4;LoadingLabel.Text="Loading"..string.rep(".",numDots);PercentageLabel.Text=i.." %";ProgressBarFill.Size=UDim2.new(progress,0,1,0);task.wait(loadDuration/100)end;task.wait(0.2)

-- 4. ЗАВЕРШЕНИЕ И ЗАПУСК МУЗЫКИ
LoadingGui:Destroy()
local WilsonHubGui=player.PlayerGui:FindFirstChild("WilsonHubGui")
if WilsonHubGui then WilsonHubGui.Enabled=true end

-- Запуск музыки
local function playNextSong()
    MusicPlayer:Stop()
    MusicPlayer.SoundId = MUSIC_SETTINGS.TrackIDs[MUSIC_SETTINGS.currentTrack]
    MusicPlayer:Play()
    MUSIC_SETTINGS.currentTrack = (MUSIC_SETTINGS.currentTrack % #MUSIC_SETTINGS.TrackIDs) + 1
end
MusicPlayer.Volume = MUSIC_SETTINGS.VolumeLevels[settings.musicVolume] or 0.5
MusicPlayer.Ended:Connect(playNextSong)
playNextSong()

pcall(function()StarterGui:SetCore("SendNotification",{Title="WILSON UPLOADED🎮!",Text="This script is for Wilson hackers",Duration=7,Button1="Yes"})end)
