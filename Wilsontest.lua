--[[
    WilsonHub Script
    Original Author: @Nurgazy_21 tg: nurr_wilson
    Version: 1.3.0 (Optimization & Feature Update)
]]

-- СЕРВИСЫ
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- КОНФИГУРАЦИЯ ЧАТА
local CHAT_SETTINGS = {
    API_BACKENDS = {
        "https://wilson-hub-chat-backend.glitch.me",
        "https://wilson-hub-chat-mirror1.glitch.me",
        "https://wilson-hub-chat-mirror2.glitch.me"
    },
    PollRate = 5
}
local current_backend_index = 1

-- ТЕМЫ И НАСТРОЙКИ
local Themes = {
    Red = { main = Color3.fromRGB(200, 0, 0), accent = Color3.fromRGB(255, 0, 0), text = Color3.fromRGB(255, 255, 255) },
    Yellow = { main = Color3.fromRGB(255, 190, 0), accent = Color3.fromRGB(255, 220, 50), text = Color3.fromRGB(0, 0, 0) },
    Blue = { main = Color3.fromRGB(0, 120, 255), accent = Color3.fromRGB(50, 150, 255), text = Color3.fromRGB(255, 255, 255) },
    Green = { main = Color3.fromRGB(0, 180, 0), accent = Color3.fromRGB(50, 220, 50), text = Color3.fromRGB(255, 255, 255) },
    White = { main = Color3.fromRGB(240, 240, 240), accent = Color3.fromRGB(200, 200, 200), text = Color3.fromRGB(0, 0, 0) }
}
local settings = { theme = "Red", language = "English" }

-- ЗАГРУЗКА НАСТРОЕК
if isfile and isfile("WilsonHubSettings.json") then
    pcall(function()
        local decoded = HttpService:JSONDecode(readfile("WilsonHubSettings.json"))
        if type(decoded) == "table" then
            for k, v in pairs(decoded) do settings[k] = v end
        end
    end)
end

local currentTheme = Themes[settings.theme] or Themes.Red
local player = Players.LocalPlayer

-- СИСТЕМА ЛОКАЛИЗАЦИИ
local languageMap = { English = "en", Russian = "ru", Kazakh = "kz", Chinese = "zh", French = "fr" }
local translations = {
    -- Общие
    on = { en = "ON", ru = "ВКЛ", kz = "ҚОСУЛЫ", zh = "开", fr = "ACTIF" },
    off = { en = "OFF", ru = "ВЫКЛ", kz = "ӨШІРУЛІ", zh = "关", fr = "INACTIF" },
    apply = { en = "Apply", ru = "Применить", kz = "Қолдану", zh = "应用", fr = "Appliquer" },
    reset = { en = "Reset", ru = "Сброс", kz = "Ысыру", zh = "重置", fr = "Réinitialiser" },
    execute = { en = "EXECUTE", ru = "ВЫПОЛНИТЬ", kz = "ОРЫНДАУ", zh = "执行", fr = "EXÉCUTER" },
    clear = { en = "CLEAR", ru = "ОЧИСТИТЬ", kz = "ТАЗАЛАУ", zh = "清除", fr = "EFFACER" },
    send = { en = "Send", ru = "Отпр.", kz = "Жіберу", zh = "发送", fr = "Envoyer" },
    loading = { en = "Loading", ru = "Загрузка", kz = "Жүктелуде", zh = "加载中", fr = "Chargement" },
    main_title = { en = "HACK WILSONHUB SCRIPTS FOR ROBLOX (V1.3.0)", ru = "HACK WILSONHUB SCRIPTS ДЛЯ ROBLOX (V1.3.0)", kz = "ROBLOX ҮШІН WILSONHUB SCRIPTS ХАГЫ (V1.3.0)", zh = "ROBLOX版WILSONHUB脚本黑客工具 (V1.3.0)", fr = "HACK WILSONHUB SCRIPTS POUR ROBLOX (V1.3.0)" },
    close_button = { en = "X", ru = "X", kz = "X", zh = "X", fr = "X" },
    
    -- Вкладки
    tab_home = { en = "HOME", ru = "ГЛАВНАЯ", kz = "БАСТЫ", zh = "主页", fr = "ACCUEIL" },
    tab_scripts = { en = "SCRIPTS", ru = "СКРИПТЫ", kz = "СКРИПТТЕР", zh = "脚本", fr = "SCRIPTS" },
    tab_skins = { en = "SKINS", ru = "СКИНЫ", kz = "СКИНДЕР", zh = "皮肤", fr = "SKINS" },
    tab_info = { en = "INFO", ru = "ИНФО", kz = "АҚПАРАТ", zh = "信息", fr = "INFOS" },
    tab_guimods = { en = "GUI MODS", ru = "МОДЫ GUI", kz = "GUI МОДТАРЫ", zh = "界面模组", fr = "MODS GUI" },
    tab_players = { en = "PLAYERS", ru = "ИГРОКИ", kz = "ОЙЫНШЫЛАР", zh = "玩家", fr = "JOUEURS" },
    tab_commands = { en = "COMMANDS", ru = "КОМАНДЫ", kz = "КОМАНДАЛАР", zh = "命令", fr = "COMMANDES" },
    tab_chat = { en = "CHAT", ru = "ЧАТ", kz = "ЧАТ", zh = "聊天", fr = "CHAT" },
    tab_settings = { en = "SETTINGS", ru = "НАСТРОЙКИ", kz = "БАПТАУЛАР", zh = "设置", fr = "RÉGLAGES" },
    tab_executor = { en = "EXECUTOR", ru = "ИСПОЛНИТЕЛЬ", kz = "ОРЫНДАУШЫ", zh = "执行器", fr = "EXÉCUTEUR" },
    
    -- Главная
    home_welcome = { en = "Welcome, %s", ru = "Добро пожаловать, %s", kz = "Қош келдің, %s", zh = "欢迎, %s", fr = "Bienvenue, %s" },
    home_nickname = { en = "NickName: %s", ru = "Никнейм: %s", kz = "Лақап аты: %s", zh = "昵称: %s", fr = "Surnom: %s" },
    home_userid = { en = "ID account: %s", ru = "ID аккаунта: %s", kz = "Аккаунт ID: %s", zh = "账户ID: %s", fr = "ID du compte: %s" },
    home_userage = { en = "Account Age: %s", ru = "Возраст аккаунта: %s", kz = "Аккаунт жасы: %s", zh = "账户年龄: %s", fr = "Âge du compte: %s" },
    home_creationdate = { en = "Creation Date: %s", ru = "Дата создания: %s", kz = "Құрылған күні: %s", zh = "创建日期: %s", fr = "Date de création: %s" },
    home_creationdate_loading = { en = "Creation Date: Loading...", ru = "Дата создания: Загрузка...", kz = "Құрылған күні: Жүктелуде...", zh = "创建日期: 加载中...", fr = "Date de création: Chargement..." },
    home_device = { en = "Device: %s", ru = "Устройство: %s", kz = "Құрылғы: %s", zh = "设备: %s", fr = "Appareil: %s" },
    home_device_phone = { en = "Phone/Tablet", ru = "Телефон/Планшет", kz = "Телефон/Планшет", zh = "手机/平板电脑", fr = "Téléphone/Tablette" },
    home_device_pc = { en = "Computer", ru = "Компьютер", kz = "Компьютер", zh = "电脑", fr = "Ordinateur" },
    
    -- Скрипты
    search_placeholder = { en = "Search scripts...", ru = "Поиск скриптов...", kz = "Скрипттерді іздеу...", zh = "搜索脚本...", fr = "Rechercher des scripts..." },
    script_fly = { en = "Fly", ru = "Fly", kz = "Fly", zh = "飞行", fr = "Fly" },
    script_fireblock = { en = "Fire Block", ru = "Огненный Блок", kz = "Отты Блок", zh = "火焰方块", fr = "Bloc de feu" },
    script_speed = { en = "Speed Hack", ru = "Спидхак", kz = "Жылдамдық хагы", zh = "速度破解", fr = "Hack de vitesse" },
    script_wallhop = { en = "Wallhop", ru = "Wallhop", kz = "Wallhop", zh = "爬墙", fr = "Wallhop" },
    script_clicktp = { en = "Click TP", ru = "Клик ТП", kz = "Басу арқылы ТП", zh = "点击传送", fr = "Clic TP" },
    script_playereesp = { en = "Player ESP", ru = "ЕСП Игроков", kz = "Ойыншы ESP", zh = "玩家透视", fr = "ESP Joueur" },
    
    -- Скины (НОВОЕ)
    skins_copy_section_title = { en = "Copy Player Avatar", ru = "Копировать аватар игрока", kz = "Ойыншы аватарын көшіру", zh = "复制玩家形象", fr = "Copier l'avatar du joueur" },
    skins_nickname_placeholder = { en = "Enter nickname...", ru = "Введите никнейм...", kz = "Никнеймді енгізіңіз...", zh = "输入昵称...", fr = "Entrez le pseudo..." },
    skins_copy_button_label = { en = "Copy Avatar", ru = "Копировать", kz = "Көшіру", zh = "复制形象", fr = "Copier" },
    skins_hacker_section_title = { en = "Hacker Skins", ru = "Скины хакеров", kz = "Хакер скин-дері", zh = "黑客皮肤", fr = "Skins de hackers" },
    
    -- Игроки
    player_ping = { en = "Ping: %s", ru = "Пинг: %s", kz = "Пинг: %s", zh = "延迟: %s", fr = "Ping: %s" },
    player_ip_private = { en = "IP Address: Private", ru = "IP-адрес: Скрыт", kz = "IP-мекенжайы: Жасырын", zh = "IP地址：私密", fr = "Adresse IP: Privée" },
    player_country_private = { en = "Country: Private", ru = "Страна: Скрыта", kz = "Ел: Жасырын", zh = "国家：私密", fr = "Pays: Privé" },
    player_tp = { en = "TP", ru = "ТП", kz = "ТП", zh = "传送", fr = "TP" },
    player_observe = { en = "Observe", ru = "Наблюдать", kz = "Бақылау", zh = "观察", fr = "Observer" },

    -- Команды
    commands_placeholder = { en = "/command [target] [args]", ru = "/команда [цель] [аргументы]", kz = "/команда [нысана] [аргументтер]", zh = "/命令 [目标] [参数]", fr = "/commande [cible] [args]" },

    -- Чат
    chat_title = { en = "Global Chat", ru = "Глобальный Чат", kz = "Жалпы Чат", zh = "全球聊天", fr = "Chat Mondial" },
    chat_placeholder = { en = "Enter message...", ru = "Введите сообщение...", kz = "Хабарламаны енгізіңіз...", zh = "输入消息...", fr = "Entrez votre message..." },
    chat_sending = { en = "Sending...", ru = "Отправка...", kz = "Жіберілуде...", zh = "发送中...", fr = "Envoi..." },
    chat_you = { en = "You", ru = "Вы", kz = "Сіз", zh = "你", fr = "Vous" },
    chat_loading = { en = "<font color='#AAAAAA'><i>Loading messages...</i></font>", ru = "<font color='#AAAAAA'><i>Загрузка сообщений...</i></font>", kz = "<font color='#AAAAAA'><i>Хабарламалар жүктелуде...</i></font>", zh = "<font color='#AAAAAA'><i>加载消息中...</i></font>", fr = "<font color='#AAAAAA'><i>Chargement des messages...</i></font>" },
    chat_error_fetch = { en = "<font color='#FF5555'>Chat Error: %s</font>", ru = "<font color='#FF5555'>Ошибка чата: %s</font>", kz = "<font color='#FF5555'>Чат қатесі: %s</font>", zh = "<font color='#FF5555'>聊天错误: %s</font>", fr = "<font color='#FF5555'>Erreur du chat: %s</font>" },
    chat_no_messages = { en = "<font color='#AAAAAA'><i>No new messages. Say hi!</i></font>", ru = "<font color='#AAAAAA'><i>Нет новых сообщений. Поздоровайтесь!</i></font>", kz = "<font color='#AAAAAA'><i>Жаңа хабарламалар жоқ. Сәлемдесіңіз!</i></font>", zh = "<font color='#AAAAAA'><i>没有新消息。打个招呼吧！</i></font>", fr = "<font color='#AAAAAA'><i>Aucun nouveau message. Dites bonjour !</i></font>" },
    chat_error_send = { en = "<font color='#FF5555'>Error: Could not send message. %s</font>", ru = "<font color='#FF5555'>Ошибка: Не удалось отправить сообщение. %s</font>", kz = "<font color='#FF5555'>Қате: Хабарламаны жіберу мүмкін болмады. %s</font>", zh = "<font color='#FF5555'>错误：无法发送消息。 %s</font>", fr = "<font color='#FF5555'>Erreur: Impossible d'envoyer le message. %s</font>" },
    
    -- Настройки
    settings_themes_title = { en = "Themes", ru = "Темы", kz = "Тақырыптар", zh = "主题", fr = "Thèmes" },
    theme_red = { en = "Red (Default)", ru = "Красная (По умолч.)", kz = "Қызыл (Стандартты)", zh = "红色（默认）", fr = "Rouge (Défaut)" },
    theme_yellow = { en = "Yellow", ru = "Желтая", kz = "Сары", zh = "黄色", fr = "Jaune" },
    theme_blue = { en = "Blue", ru = "Синяя", kz = "Көк", zh = "蓝色", fr = "Bleu" },
    theme_green = { en = "Green", ru = "Зеленая", kz = "Жасыл", zh = "绿色", fr = "Vert" },
    theme_white = { en = "White", ru = "Белая", kz = "Ақ", zh = "白色", fr = "Blanc" },
    theme_rainbow = { en = "Rainbow", ru = "Радуга", kz = "Кемпірқосақ", zh = "彩虹", fr = "Arc-en-ciel" },
    settings_language_title = { en = "Languages", ru = "Языки", kz = "Тілдер", zh = "语言", fr = "Langues" },
    lang_en = { en = "English", ru = "English", kz = "English", zh = "English", fr = "English" },
    lang_ru = { en = "Russian", ru = "Русский", kz = "Орысша", zh = "俄语", fr = "Russe" },
    lang_kz = { en = "Kazakh", ru = "Казахский", kz = "Қазақша", zh = "哈萨克语", fr = "Kazakh" },
    lang_zh = { en = "Chinese", ru = "Китайский", kz = "Қытайша", zh = "中文", fr = "Chinois" },
    lang_fr = { en = "French", ru = "Французский", kz = "Французша", zh = "法语", fr = "Français" },
    
    -- Исполнитель
    executor_placeholder = { en = "-- Paste your script here", ru = "-- Вставьте свой скрипт сюда", kz = "-- Скриптіңізді осы жерге қойыңыз", zh = "-- 在此处粘贴您的脚本", fr = "-- Collez votre script ici" },
    
    -- Уведомления
    notif_welcome_title = { en = "WILSONHUB LOADED!", ru = "WILSONHUB ЗАГРУЖЕН!", kz = "WILSONHUB ЖҮКТЕЛДІ!", zh = "WILSONHUB 已加载!", fr = "WILSONHUB CHARGÉ!" },
    notif_welcome_text = { en = "Script by Nurgazy_21. Enjoy!", ru = "Скрипт от Nurgazy_21. Наслаждайтесь!", kz = "Nurgazy_21 скрипті. Рахаттаныңыз!", zh = "脚本作者 Nurgazy_21。祝您玩得愉快！", fr = "Script par Nurgazy_21. Profitez-en!" },
    notif_fatal_error_title = { en = "FATAL ERROR", ru = "КРИТИЧЕСКАЯ ОШИБКА", kz = "КРИТИКАЛЫҚ ҚАТЕ", zh = "致命错误", fr = "ERREUR FATALE" },
    notif_fatal_error_text = { en = "UI failed to load. Error: %s", ru = "Не удалось загрузить UI. Ошибка: %s", kz = "UI жүктелмеді. Қате: %s", zh = "UI加载失败。错误: %s", fr = "Échec du chargement de l'IU. Erreur: %s" },
    notif_speed_title = { en = "Speed Hack", ru = "Спидхак", kz = "Жылдамдық хагы", zh = "速度破解", fr = "Hack de vitesse" },
    notif_speed_text = { en = "Speed set to 50.", ru = "Скорость установлена на 50.", kz = "Жылдамдық 50-ге қойылды.", zh = "速度提升至50。", fr = "Vitesse réglée à 50." },
    notif_clicktp_title = { en = "Click Teleport", ru = "Телепорт по клику", kz = "Басу арқылы телепорт", zh = "点击传送", fr = "Téléportation par clic" },
    notif_clicktp_text = { en = "Activated. Click to teleport.", ru = "Активировано. Нажмите для телепортации.", kz = "Белсендірілді. Телепорттау үшін басыңыз.", zh = "已激活。点击进行传送。", fr = "Activé. Cliquez pour vous téléporter." },
    notif_executor_error_title = { en = "Executor Error", ru = "Ошибка исполнителя", kz = "Орындаушы қатесі", zh = "执行器错误", fr = "Erreur de l'exécuteur" },
    notif_skin_copy_success_title = { en = "Avatar Copied", ru = "Аватар скопирован", kz = "Аватар көшірілді", zh = "形象已复制", fr = "Avatar copié" },
    notif_skin_copy_success_text = { en = "Successfully copied avatar from %s.", ru = "Аватар %s успешно скопирован.", kz = "%s аватары сәтті көшірілді.", zh = "已成功复制 %s 的形象。", fr = "Avatar de %s copié avec succès." },
    notif_skin_copy_fail_title = { en = "Avatar Copy Failed", ru = "Ошибка копирования", kz = "Көшіру қатесі", zh = "形象复制失败", fr = "Échec de la copie" },
    notif_skin_copy_fail_text = { en = "Could not load appearance for %s.", ru = "Не удалось загрузить внешность для %s.", kz = "%s үшін сыртқы келбетті жүктеу мүмкін болмады.", zh = "无法加载 %s 的形象。", fr = "Impossible de charger l'apparence de %s." },
    notif_skin_char_fail_text = { en = "Your character was not found.", ru = "Ваш персонаж не найден.", kz = "Сіздің кейіпкеріңіз табылмады.", zh = "未找到您的角色。", fr = "Votre personnage n'a pas été trouvé." },
}

-- [[ ВСПОМОГАТЕЛЬНЫЕ ПЕРЕМЕННЫЕ ]]
local themableObjects = {}
local translatableObjects = {}
local activeTab, rainbowThemeConnection
local rainbowThemeActive = false

-- [[ СИСТЕМНЫЕ ФУНКЦИИ ]]

local function saveSettings()
    if writefile then
        pcall(function() writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings)) end)
    end
end

local function sendTranslatedNotification(titleKey, textKey, duration, button1Key, textArgs)
    local langCode = languageMap[settings.language] or "en"
    local title = (translations[titleKey] and (translations[titleKey][langCode] or translations[titleKey].en)) or titleKey
    local textFormat = (translations[textKey] and (translations[textKey][langCode] or translations[textKey].en)) or textKey
    
    local text = textFormat
    if textArgs then
        pcall(function() text = string.format(textFormat, unpack(textArgs)) end)
    end
    
    local notificationInfo = { Title = title, Text = text, Duration = duration or 5 }
    if button1Key then
         notificationInfo.Button1 = (translations[button1Key] and (translations[button1Key][langCode] or translations[button1Key].en)) or button1Key
    end
    
    pcall(StarterGui.SetCore, StarterGui, "SendNotification", notificationInfo)
end

-- Система Языка
local function applyLanguage(langName)
    if not languageMap[langName] then langName = "English" end
    settings.language = langName
    saveSettings()
    
    local langCode = languageMap[settings.language] or "en"
    
    for _, item in ipairs(translatableObjects) do
        if item.object and item.object.Parent then
            local translationData = translations[item.key]
            if translationData then
                local translatedText = translationData[langCode] or translationData.en
                pcall(function()
                    if item.dynamic_args then
                        item.object[item.property] = string.format(translatedText, unpack(item.dynamic_args))
                    else
                        item.object[item.property] = translatedText
                    end
                end)
            end
        end
    end
end

-- Система Тем
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
            elseif item.colorType == "text" then item.object[item.property] = textColor
            end
        end
    end
    
    if activeTab and activeTab.Parent then
        activeTab.BackgroundColor3 = accentColor
    end
end

local function applyTheme(themeName)
    if rainbowThemeConnection and rainbowThemeConnection.Connected then
        rainbowThemeConnection:Disconnect()
    end
    rainbowThemeConnection, rainbowThemeActive = nil, false

    if not Themes[themeName] then themeName = "Red" end
    
    currentTheme = Themes[themeName]
    settings.theme = themeName
    saveSettings()
    
    for _, item in ipairs(themableObjects) do
        if item.object and item.object.Parent then
            if currentTheme[item.colorType] then
                item.object[item.property] = currentTheme[item.colorType]
            end
        end
    end

    local allTabs = CoreGui:FindFirstChild("WilsonHubGui").MainFrame.TabsContainer:GetChildren()
    for _, tabButton in ipairs(allTabs) do
        if tabButton:IsA("TextButton") then
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end

    if activeTab and activeTab.Parent then
        activeTab.BackgroundColor3 = currentTheme.main
    end
end

local function activateRainbowTheme()
    if rainbowThemeActive then return end
    
    rainbowThemeActive = true
    settings.theme = "Rainbow"
    saveSettings()
    
    if rainbowThemeConnection and rainbowThemeConnection.Connected then rainbowThemeConnection:Disconnect() end
    rainbowThemeConnection = RunService.RenderStepped:Connect(updateRainbowColors)
end

-- [[ ОСНОВНЫЕ ФУНКЦИИ ]]

-- Функция копирования скина (НОВОЕ)
local function copyAvatarFromUsername(username)
    if not username or username:gsub("%s", "") == "" then return end
    
    local success, targetUserId = pcall(Players.GetUserIdFromNameAsync, Players, username)
    if not success or not targetUserId then
        sendTranslatedNotification("notif_skin_copy_fail_title", "notif_skin_copy_fail_text", 5, nil, {username})
        return
    end

    local success, appearanceModel = pcall(Players.GetCharacterAppearanceAsync, Players, targetUserId)
    if not success or not appearanceModel then
        sendTranslatedNotification("notif_skin_copy_fail_title", "notif_skin_copy_fail_text", 5, nil, {username})
        return
    end

    local character = player.Character
    if not character then
        sendTranslatedNotification("notif_skin_copy_fail_title", "notif_skin_char_fail_text", 5)
        return
    end

    -- Очистка старых аксессуаров
    for _, v in pairs(character:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
            v:Destroy()
        end
    end
    if character:FindFirstChild("Body Colors") then character["Body Colors"]:Destroy() end

    -- Применение новых
    for _, item in pairs(appearanceModel:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then
            item:Clone().Parent = character
        end
    end

    sendTranslatedNotification("notif_skin_copy_success_title", "notif_skin_copy_success_text", 5, nil, {username})
end

-- [[ ЗАГРУЗОЧНЫЙ ЭКРАН ]]
local function createLoadingScreen()
    local LoadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    LoadingGui.Name = "LoadingGui"; LoadingGui.ResetOnSpawn = false; LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local Background = Instance.new("Frame", LoadingGui)
    Background.Size = UDim2.new(1, 0, 1, 0); Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    local LoadingLabel = Instance.new("TextLabel", Background)
    LoadingLabel.Size = UDim2.new(1, 0, 0, 50); LoadingLabel.Position = UDim2.new(0, 0, 0.5, -60); LoadingLabel.BackgroundTransparency = 1; LoadingLabel.Font = Enum.Font.SourceSansBold; LoadingLabel.TextSize = 42
    table.insert(translatableObjects, {object=LoadingLabel, property="Text", key="loading"})

    local PercentageLabel = Instance.new("TextLabel", Background)
    PercentageLabel.Size = UDim2.new(1, 0, 0, 30); PercentageLabel.Position = UDim2.new(0, 0, 0.5, 0); PercentageLabel.BackgroundTransparency = 1; PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255); PercentageLabel.Font = Enum.Font.SourceSansBold; PercentageLabel.TextSize = 28; PercentageLabel.Text = "0 %"

    local ProgressBarBG = Instance.new("Frame", Background)
    ProgressBarBG.Size = UDim2.new(0, 400, 0, 25); ProgressBarBG.Position = UDim2.new(0.5, -200, 0.5, 40); ProgressBarBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10); ProgressBarBG.BorderColor3 = currentTheme.main; ProgressBarBG.BorderSizePixel = 1; Instance.new("UICorner", ProgressBarBG).CornerRadius = UDim.new(0, 8)

    local ProgressBarFill = Instance.new("Frame", ProgressBarBG)
    ProgressBarFill.Size = UDim2.fromScale(0, 1); ProgressBarFill.BackgroundColor3 = currentTheme.accent; Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(0, 8)
    
    -- Анимация
    local loadDuration = 2.5
    for i = 0, 100 do
        local progress = i / 100
        local numDots = math.floor(i / 15) % 4
        
        if LoadingLabel and LoadingLabel.Parent then
            local langCode = languageMap[settings.language] or "en"
            local baseText = translations.loading[langCode] or translations.loading.en
            LoadingLabel.Text = baseText .. string.rep(".", numDots)
        end
        PercentageLabel.Text = i .. " %"
        ProgressBarFill:TweenSize(UDim2.fromScale(progress, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, loadDuration / 120, true)
        
        if settings.theme == "Rainbow" then
            local hue = tick() % 2 / 2
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            LoadingLabel.TextColor3 = rainbowColor
            ProgressBarBG.BorderColor3 = rainbowColor
            ProgressBarFill.BackgroundColor3 = rainbowColor
        else
             LoadingLabel.TextColor3 = currentTheme.accent
        end
        
        task.wait(loadDuration / 100)
    end
    task.wait(0.2)
    LoadingGui:Destroy()
end

-- [[ ГЛАВНЫЙ КОД GUI ]]
task.spawn(function()
    local success, err = pcall(function()
        -- Создание основной структуры GUI
        local WilsonHubGui = Instance.new("ScreenGui", CoreGui)
        WilsonHubGui.Name = "WilsonHubGui"; WilsonHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; WilsonHubGui.ResetOnSpawn = false
        
        local MainFrame = Instance.new("Frame", WilsonHubGui)
        MainFrame.Name = "MainFrame"; MainFrame.Size = UDim2.new(0, 600, 0, 350); MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175); MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
        
        local Header = Instance.new("Frame", MainFrame)
        Header.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8); table.insert(themableObjects, {object=Header, property="BackgroundColor3", colorType="main"})
        
        local TitleLabel = Instance.new("TextLabel", Header)
        TitleLabel.Size = UDim2.new(1, -40, 1, 0); TitleLabel.Position = UDim2.fromScale(0,0); TitleLabel.BackgroundTransparency = 1; TitleLabel.Font = Enum.Font.SourceSansBold; TitleLabel.TextSize = 20; table.insert(translatableObjects, {object=TitleLabel, property="Text", key="main_title"}); table.insert(themableObjects, {object=TitleLabel, property="TextColor3", colorType="text"})
        
        local CloseButton = Instance.new("TextButton", Header)
        CloseButton.Size = UDim2.new(0, 40, 1, 0); CloseButton.Position = UDim2.fromScale(1, 0); CloseButton.AnchorPoint = Vector2.new(1, 0); CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45); CloseButton.Font = Enum.Font.SourceSansBold; CloseButton.TextSize = 20; table.insert(translatableObjects, {object=CloseButton, property="Text", key="close_button"});
        CloseButton.MouseEnter:Connect(function() CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) end)
        CloseButton.MouseLeave:Connect(function() CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
        
        local TabsContainer = Instance.new("ScrollingFrame", MainFrame)
        TabsContainer.Name = "TabsContainer"; TabsContainer.Size = UDim2.new(0, 120, 1, -40); TabsContainer.Position = UDim2.new(0, 0, 0, 40); TabsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabsContainer.BorderSizePixel = 0; TabsContainer.ScrollBarThickness = 6; table.insert(themableObjects, {object = TabsContainer, property = "ScrollBarImageColor3", colorType = "main"})
        
        local ContentContainer = Instance.new("Frame", MainFrame)
        ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -120, 1, -40); ContentContainer.Position = UDim2.new(0, 120, 0, 40); ContentContainer.BackgroundTransparency = 1
        
        local TabsListLayout = Instance.new("UIListLayout", TabsContainer)
        TabsListLayout.Padding = UDim.new(0, 10); TabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- [[ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ GUI ]]
        local function createTabButton(textKey)
            local button = Instance.new("TextButton", TabsContainer)
            button.Size = UDim2.new(1, -10, 0, 40); button.BackgroundColor3 = Color3.fromRGB(60, 60, 60); button.TextColor3 = Color3.fromRGB(255, 255, 255); button.Font = Enum.Font.SourceSansBold; button.TextSize = 16
            table.insert(translatableObjects, {object=button, property="Text", key=textKey})
            return button
        end
        
        local function createFunctionButton(parent, textKey, callback) 
            local btn = Instance.new("TextButton", parent)
            btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 16
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            if callback then btn.MouseButton1Click:Connect(function() pcall(callback) end) end
            table.insert(themableObjects, {object=btn, property="BackgroundColor3", colorType="main"})
            table.insert(themableObjects, {object=btn, property="TextColor3", colorType="text"})
            table.insert(translatableObjects, {object=btn, property="Text", key=textKey})
            return btn 
        end
        
        local function createSection(parent, titleKey)
            local frame = Instance.new("Frame", parent)
            frame.BackgroundTransparency = 1; frame.Size = UDim2.new(1, 0, 0, 0); frame.AutomaticSize = Enum.AutomaticSize.Y
            local layout = Instance.new("UIListLayout", frame); layout.Padding = UDim.new(0, 5)
            
            local label = Instance.new("TextLabel", frame)
            label.BackgroundTransparency = 1; label.Font = Enum.Font.SourceSansBold; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 18; label.TextXAlignment = Enum.TextXAlignment.Left; label.Size = UDim2.new(1, 0, 0, 20)
            table.insert(translatableObjects, {object = label, property = "Text", key = titleKey})
            
            local contentFrame = Instance.new("Frame", frame)
            contentFrame.BackgroundTransparency = 1; contentFrame.Size = UDim2.new(1, 0, 0, 0); contentFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            return contentFrame
        end

        -- СОЗДАНИЕ ВКЛАДОК И СТРАНИЦ
        local HomeButton = createTabButton("tab_home")
        local ScriptsButton = createTabButton("tab_scripts")
        local SkinsButton = createTabButton("tab_skins") -- Новая вкладка
        local PlayersButton = createTabButton("tab_players")
        local CommandsButton = createTabButton("tab_commands")
        local ChatButton = createTabButton("tab_chat")
        local SettingsButton = createTabButton("tab_settings")
        local ExecutorButton = createTabButton("tab_executor")

        local tabs = {HomeButton, ScriptsButton, SkinsButton, PlayersButton, CommandsButton, ChatButton, SettingsButton, ExecutorButton}
        
        local pageContainer = {}
        for _, tabBtn in ipairs(tabs) do
            local page = Instance.new("ScrollingFrame", ContentContainer)
            page.Name = tabBtn.Text .. "Page"; page.Size = UDim2.new(1, -10, 1, -10); page.Position = UDim2.new(0, 5, 0, 5); page.BackgroundTransparency = 1; page.ScrollBarThickness = 6; page.Visible = false
            local layout = Instance.new("UIListLayout", page); layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            pageContainer[tabBtn] = page
        end
        
        -- [[ ЗАПОЛНЕНИЕ СТРАНИЦ КОНТЕНТОМ ]]

        -- HOME PAGE
        do
            local page = pageContainer[HomeButton]
            local playerInfoFrame = Instance.new("Frame", page); playerInfoFrame.BackgroundTransparency = 1; playerInfoFrame.Size = UDim2.new(1, 0, 0, 140)
            local playerImageLayout = Instance.new("UIListLayout", playerInfoFrame); playerImageLayout.FillDirection = Enum.FillDirection.Horizontal; playerImageLayout.Padding = UDim.new(0, 15)
            
            local PlayerImage = Instance.new("ImageLabel", playerInfoFrame); PlayerImage.Size = UDim2.new(0, 128, 0, 128); PlayerImage.BackgroundTransparency = 1; task.spawn(function() pcall(function() PlayerImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end)
            local playerImageBorder = Instance.new("UIStroke", PlayerImage); playerImageBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; playerImageBorder.Thickness = 2; table.insert(themableObjects, {object=playerImageBorder, property="Color", colorType="main"})

            local textInfoFrame = Instance.new("Frame", playerInfoFrame); textInfoFrame.BackgroundTransparency = 1; textInfoFrame.Size = UDim2.new(1, -158, 1, 0)
            local textInfoLayout = Instance.new("UIListLayout", textInfoFrame); textInfoLayout.Padding = UDim.new(0, 2)
            
            local function createInfoLabel(parent, key, args)
                local label = Instance.new("TextLabel", parent); label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1,1,1); label.Font = Enum.Font.SourceSans; label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left; label.Size = UDim2.new(1, 0, 0, 18)
                table.insert(translatableObjects, {object=label, property="Text", key=key, dynamic_args=args})
                return label
            end

            local welcome = createInfoLabel(textInfoFrame, "home_welcome", {player.DisplayName}); welcome.Font = Enum.Font.SourceSansBold; welcome.TextSize = 20; table.insert(themableObjects, {object=welcome, property="TextColor3", colorType="accent"})
            createInfoLabel(textInfoFrame, "home_nickname", {player.Name})
            createInfoLabel(textInfoFrame, "home_userid", {player.UserId})
            createInfoLabel(textInfoFrame, "home_userage", {player.AccountAge})
            local dev_type = UserInputService.TouchEnabled and "home_device_phone" or "home_device_pc"; local dev_text = translations[dev_type].en; createInfoLabel(textInfoFrame, "home_device", {dev_text})
        end

        -- SCRIPTS PAGE
        do
            local page = pageContainer[ScriptsButton]
            local SearchBox = Instance.new("TextBox", page); SearchBox.Size = UDim2.new(1, 0, 0, 30); SearchBox.BackgroundColor3=Color3.fromRGB(45,45,45); SearchBox.TextColor3=Color3.fromRGB(255,255,255); SearchBox.Font=Enum.Font.SourceSans; SearchBox.TextSize=14; Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,6); table.insert(translatableObjects, {object=SearchBox, property="PlaceholderText", key="search_placeholder"});
            local SearchBoxStroke = Instance.new("UIStroke", SearchBox); SearchBoxStroke.Color = currentTheme.main; table.insert(themableObjects,{object=SearchBoxStroke, property="Color", colorType="main"});

            local scriptsContent = Instance.new("Frame", page); scriptsContent.Size = UDim2.new(1, 0, 0, 0); scriptsContent.AutomaticSize = Enum.AutomaticSize.Y; scriptsContent.BackgroundTransparency = 1
            local ScriptsGrid = Instance.new("UIGridLayout", scriptsContent); ScriptsGrid.CellPadding=UDim2.new(0,10,0,10); ScriptsGrid.CellSize=UDim2.new(0, 140, 0, 40); ScriptsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            
            local function addScript(key, url, isLoadstring)
                createFunctionButton(scriptsContent, key, function()
                    if isLoadstring then
                        pcall(function() loadstring(game:HttpGet(url))() end)
                    else
                        -- Future use for non-loadstring scripts
                    end
                end).Size = ScriptsGrid.CellSize
            end
            
            addScript("script_fly", "https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/WilsonFly", true)
            addScript("script_fireblock", "https://raw.githubusercontent.com/amdzy088/Auto-fire-part-universal-/main/Auto%20fire%20part%20universal", true)
            addScript("script_wallhop", "https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/main/Roblox%20WallHop%20script", true)
            createFunctionButton(scriptsContent, "script_speed", function() local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed=50; sendTranslatedNotification("notif_speed_title","notif_speed_text") end end).Size = ScriptsGrid.CellSize
            createFunctionButton(scriptsContent, "script_clicktp", function() local m=player:GetMouse(); sendTranslatedNotification("notif_clicktp_title","notif_clicktp_text"); m.Button1Down:Connect(function() if m.Target and player.Character and player.Character.PrimaryPart then player.Character:SetPrimaryPartCFrame(CFrame.new(m.Hit.Position+Vector3.new(0,3,0))) end end) end).Size = ScriptsGrid.CellSize
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function() local s = SearchBox.Text:lower(); for _, b in ipairs(scriptsContent:GetChildren()) do if b:IsA("TextButton") then b.Visible = b.Text:lower():find(s, 1, true) end end end)
        end
        
        -- SKINS PAGE (НОВЫЙ РАЗДЕЛ)
        do
            local page = pageContainer[SkinsButton]
            
            -- Секция копирования по нику
            local copySection = createSection(page, "skins_copy_section_title")
            local copyLayout = Instance.new("UIListLayout", copySection); copyLayout.FillDirection = Enum.FillDirection.Horizontal; copyLayout.Padding = UDim.new(0, 10);
            
            local nicknameInput = Instance.new("TextBox", copySection)
            nicknameInput.Size = UDim2.new(1, -140, 0, 40); nicknameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45); nicknameInput.TextColor3 = Color3.fromRGB(255, 255, 255); nicknameInput.Font = Enum.Font.SourceSans; nicknameInput.TextSize = 16
            Instance.new("UICorner", nicknameInput).CornerRadius = UDim.new(0, 6)
            table.insert(translatableObjects, {object = nicknameInput, property = "PlaceholderText", key = "skins_nickname_placeholder"})

            local copyBtn = createFunctionButton(copySection, "skins_copy_button_label", function() copyAvatarFromUsername(nicknameInput.Text) end)
            copyBtn.Size = UDim2.new(0, 120, 0, 40)

            -- Секция готовых скинов
            local hackerSection = createSection(page, "skins_hacker_section_title")
            local hackerGrid = Instance.new("UIGridLayout", hackerSection); hackerGrid.CellPadding = UDim2.new(0,10,0,10); hackerGrid.CellSize = UDim2.new(0, 140, 0, 40); hackerGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local hacker_skins = {
                ["C00lkidd"] = "UlanB2210",
                ["Hacker_Wilson"] = "Nurgazy_21",
                ["tubers93"] = "Krasav4ik_181",
                ["1x1x1x1"] = "1x1x1x1svz",
                ["ERROR1545OLD"] = "Error1545OLD",
                ["JOHN DOE"] = "JohnDoe",
            }

            for btnText, targetUser in pairs(hacker_skins) do
                local btn = createFunctionButton(hackerSection, btnText, function() copyAvatarFromUsername(targetUser) end)
                btn.Text = btnText -- Override translation system for specific names
                btn.Size = hackerGrid.CellSize
            end
        end

        -- SETTINGS PAGE
        do
            local page = pageContainer[SettingsButton]
            
            -- Секция тем
            local themesContent = createSection(page, "settings_themes_title")
            local themesGrid = Instance.new("UIGridLayout", themesContent); themesGrid.CellPadding = UDim2.new(0,10,0,10); themesGrid.CellSize = UDim2.new(0, 140, 0, 40); themesGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            
            createFunctionButton(themesContent, "theme_red", function() applyTheme("Red") end).Size = themesGrid.CellSize
            createFunctionButton(themesContent, "theme_yellow", function() applyTheme("Yellow") end).Size = themesGrid.CellSize
            createFunctionButton(themesContent, "theme_blue", function() applyTheme("Blue") end).Size = themesGrid.CellSize
            createFunctionButton(themesContent, "theme_green", function() applyTheme("Green") end).Size = themesGrid.CellSize
            createFunctionButton(themesContent, "theme_white", function() applyTheme("White") end).Size = themesGrid.CellSize
            createFunctionButton(themesContent, "theme_rainbow", function() activateRainbowTheme() end).Size = themesGrid.CellSize

            -- Секция языков
            local langContent = createSection(page, "settings_language_title")
            local langGrid = Instance.new("UIGridLayout", langContent); langGrid.CellPadding = UDim2.new(0,10,0,10); langGrid.CellSize = UDim2.new(0, 140, 0, 40); langGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
            
            createFunctionButton(langContent, "lang_en", function() applyLanguage("English") end).Size = langGrid.CellSize
            createFunctionButton(langContent, "lang_ru", function() applyLanguage("Russian") end).Size = langGrid.CellSize
            createFunctionButton(langContent, "lang_kz", function() applyLanguage("Kazakh") end).Size = langGrid.CellSize
            createFunctionButton(langContent, "lang_zh", function() applyLanguage("Chinese") end).Size = langGrid.CellSize
            createFunctionButton(langContent, "lang_fr", function() applyLanguage("French") end).Size = langGrid.CellSize
        end
        
        -- EXECUTOR PAGE
        do
            local page = pageContainer[ExecutorButton]
            page.ScrollingEnabled = false
            
            local executorInput = Instance.new("TextBox", page); executorInput.Size = UDim2.new(1, 0, 1, -50); executorInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); executorInput.TextColor3 = Color3.fromRGB(255, 255, 255); executorInput.Font = Enum.Font.Code; executorInput.TextSize = 14; executorInput.TextWrapped = true; executorInput.TextXAlignment = Enum.TextXAlignment.Left; executorInput.TextYAlignment = Enum.TextYAlignment.Top; executorInput.ClearTextOnFocus = false; Instance.new("UICorner", executorInput).CornerRadius = UDim.new(0, 6);
            table.insert(translatableObjects, {object=executorInput, property="PlaceholderText", key="executor_placeholder"});
            local executorStroke = Instance.new("UIStroke", executorInput); executorStroke.Color = currentTheme.main; table.insert(themableObjects, {object = executorStroke, property="Color", colorType="main"});
            
            local buttonFrame = Instance.new("Frame", page); buttonFrame.Size = UDim2.new(1, 0, 0, 40); buttonFrame.Position = UDim2.new(0, 0, 1, -40); buttonFrame.BackgroundTransparency = 1;
            local buttonLayout = Instance.new("UIListLayout", buttonFrame); buttonLayout.FillDirection = Enum.FillDirection.Horizontal; buttonLayout.Padding = UDim.new(0, 10);
            
            local executeBtn = createFunctionButton(buttonFrame, "execute", function() local s,e = pcall(loadstring(executorInput.Text)); if not s then sendTranslatedNotification("notif_executor_error_title", tostring(e)) end end)
            executeBtn.Size = UDim2.new(0.5, -5, 1, 0)
            local clearBtn = createFunctionButton(buttonFrame, "clear", function() executorInput.Text = "" end)
            clearBtn.Size = UDim2.new(0.5, -5, 1, 0)
        end
        
        -- ЛОГИКА ПЕРЕКЛЮЧЕНИЯ ВКЛАДОК
        activeTab = HomeButton
        pageContainer[activeTab].Visible = true

        for tabBtn, page in pairs(pageContainer) do
            tabBtn.MouseButton1Click:Connect(function()
                pageContainer[activeTab].Visible = false
                if not rainbowThemeActive then
                    activeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
                
                activeTab = tabBtn
                page.Visible = true
                if not rainbowThemeActive then
                    activeTab.BackgroundColor3 = currentTheme.main
                end
            end)
        end
        
        CloseButton.MouseButton1Click:Connect(function() WilsonHubGui.Enabled = false end)
        
        -- ПРИМЕНЕНИЕ НАСТРОЕК
        if settings.theme == "Rainbow" then
            activateRainbowTheme()
        else
            applyTheme(settings.theme)
        end
        applyLanguage(settings.language)
        
    end)
    if not success then
        warn("WILSONHUB FATAL ERROR: " .. tostring(err))
        sendTranslatedNotification("notif_fatal_error_title", "notif_fatal_error_text", 20, nil, {tostring(err)})
    end
end)

-- ЗАПУСК
applyLanguage(settings.language)
createLoadingScreen()
sendTranslatedNotification("notif_welcome_title", "notif_welcome_text", 7)
