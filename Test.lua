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

-- [[ THEMES, LANGUAGES & SETTINGS ]]
local Themes = {
	Red = { main = Color3.fromRGB(200, 0, 0), accent = Color3.fromRGB(255, 0, 0), text = Color3.fromRGB(255, 255, 255) },
	Yellow = { main = Color3.fromRGB(255, 190, 0), accent = Color3.fromRGB(255, 220, 50), text = Color3.fromRGB(0,0,0) },
	Blue = { main = Color3.fromRGB(0, 120, 255), accent = Color3.fromRGB(50, 150, 255), text = Color3.fromRGB(255,255,255) },
	Green = { main = Color3.fromRGB(0, 180, 0), accent = Color3.fromRGB(50, 220, 50), text = Color3.fromRGB(255,255,255) },
	White = { main = Color3.fromRGB(240, 240, 240), accent = Color3.fromRGB(200, 200, 200), text = Color3.fromRGB(0, 0, 0) }
}
local settings = {
	theme = "Red",
	language = "English"
}

-- ЗАГРУЗКА НАСТРОЕК
if isfile and isfile("WilsonHubSettings.json")then
	pcall(function()
		local decoded_settings = HttpService:JSONDecode(readfile("WilsonHubSettings.json"))
		if type(decoded_settings) == "table" then
			for k, v in pairs(decoded_settings) do
				settings[k] = v
			end
		end
	end)
end

local currentTheme = Themes[settings.theme] or Themes.Red
local player = Players.LocalPlayer

-- [[ LANGUAGE SYSTEM ]]
local languageMap = {
	English = "en",
	Russian = "ru",
	Kazakh = "kz",
	Chinese = "zh",
	French = "fr"
}
local translations = {
	-- GENERAL & COMMON BUTTONS
	on = { en = "ON", ru = "ВКЛ", kz = "ҚОСУЛЫ", zh = "开", fr = "ACTIF" },
	off = { en = "OFF", ru = "ВЫКЛ", kz = "ӨШІРУЛІ", zh = "关", fr = "INACTIF" },
	apply = { en = "Apply", ru = "Применить", kz = "Қолдану", zh = "应用", fr = "Appliquer" },
	reset = { en = "Reset", ru = "Сброс", kz = "Ысыру", zh = "重置", fr = "Réinitialiser" },
	execute = { en = "EXECUTE", ru = "ВЫПОЛНИТЬ", kz = "ОРЫНДАУ", zh = "执行", fr = "EXÉCUTER" },
	clear = { en = "CLEAR", ru = "ОЧИСТИТЬ", kz = "ТАЗАЛАУ", zh = "清除", fr = "EFFACER" },
	send = { en = "Send", ru = "Отпр.", kz = "Жіберу", zh = "发送", fr = "Envoyer" },
	-- LOADING SCREEN
	loading = { en = "Loading", ru = "Загрузка", kz = "Жүктелуде", zh = "加载中", fr = "Chargement" },
	-- MAIN GUI
	main_title = { en = "HACK WILSONHUB SCRIPTS FOR ROBLOX (V1.1.0)", ru = "HACK WILSONHUB SCRIPTS ДЛЯ ROBLOX (V1.1.0)", kz = "ROBLOX ҮШІН WILSONHUB SCRIPTS ХАГЫ (V1.1.0)", zh = "ROBLOX版WILSONHUB脚本黑客工具 (V1.1.0)", fr = "HACK WILSONHUB SCRIPTS POUR ROBLOX (V1.1.0)" },
	close_button = { en = "X", ru = "X", kz = "X", zh = "X", fr = "X" },
	-- TABS
	tab_home = { en = "HOME", ru = "ГЛАВНАЯ", kz = "БАСТЫ", zh = "主页", fr = "ACCUEIL" },
	tab_scripts = { en = "SCRIPT'S", ru = "СКРИПТЫ", kz = "СКРИПТТЕР", zh = "脚本", fr = "SCRIPTS" },
    
    -- ============================================================= --
    -- [+] НАЧАЛО НОВОГО КОДА: ПЕРЕВОДЫ ДЛЯ ВКЛАДКИ SKINS
    -- ============================================================= --
	tab_skins = { en = "SKINS", ru = "СКИНЫ", kz = "СКИНДЕР", zh = "皮肤", fr = "SKINS" },
	skin_coolkidd = { en = "SKIN C00LKIDD", ru = "СКИН C00LKIDD", kz = "C00LKIDD СКИНІ", zh = "C00LKIDD 皮肤", fr = "SKIN C00LKIDD" },
	skin_johndoe = { en = "SKIN JOHNDOE", ru = "СКИН JOHNDOE", kz = "JOHNDOE СКИНІ", zh = "JOHNDOE 皮肤", fr = "SKIN JOHNDOE" },
	skin_hack_wilson = { en = "SKIN HACK_WILSON", ru = "СКИН HACK_WILSON", kz = "HACK_WILSON СКИНІ", zh = "HACK_WILSON 皮肤", fr = "SKIN HACK_WILSON" },
    -- ============================================================= --
    -- [+] КОНЕЦ НОВОГО КОДА
    -- ============================================================= --
    
	tab_info = { en = "INFO", ru = "ИНФО", kz = "АҚПАРАТ", zh = "信息", fr = "INFOS" },
	tab_guimods = { en = "GUI MODS", ru = "МОДЫ GUI", kz = "GUI МОДТАРЫ", zh = "界面模组", fr = "MODS GUI" },
	tab_players = { en = "PLAYERS", ru = "ИГРОКИ", kz = "ОЙЫНШЫЛАР", zh = "玩家", fr = "JOUEURS" },
	tab_commands = { en = "COMMANDS", ru = "КОМАНДЫ", kz = "КОМАНДАЛАР", zh = "命令", fr = "COMMANDES" },
	tab_chat = { en = "PLAYERS CHAT", ru = "ЧАТ ИГРОКОВ", kz = "ОЙЫНШЫЛАР ЧАТЫ", zh = "玩家聊天", fr = "CHAT JOUEURS" },
	tab_settings = { en = "SETTINGS", ru = "НАСТРОЙКИ", kz = "БАПТАУЛАР", zh = "设置", fr = "RÉGLAGES" },
	tab_executor = { en = "EXECUTOR", ru = "ИСПОЛНИТЕЛЬ", kz = "ОРЫНДАУШЫ", zh = "执行器", fr = "EXÉCUTEUR" },
	-- HOME PAGE
	home_welcome = { en = "Welcome, %s", ru = "Добро пожаловать, %s", kz = "Қош келдің, %s", zh = "欢迎, %s", fr = "Bienvenue, %s" },
	home_nickname = { en = "NickName: %s", ru = "Никнейм: %s", kz = "Лақап аты: %s", zh = "昵称: %s", fr = "Surnom: %s" },
	home_userid = { en = "ID account: %s", ru = "ID аккаунта: %s", kz = "Аккаунт ID: %s", zh = "账户ID: %s", fr = "ID du compte: %s" },
	home_userage = { en = "lvl account: %s", ru = "Возраст аккаунта: %s", kz = "Аккаунт жасы: %s", zh = "账户年龄: %s", fr = "Âge du compte: %s" },
	home_creationdate = { en = "Creation Date: %s", ru = "Дата создания: %s", kz = "Құрылған күні: %s", zh = "创建日期: %s", fr = "Date de création: %s" },
	home_creationdate_loading = { en = "Creation Date: Loading...", ru = "Дата создания: Загрузка...", kz = "Құрылған күні: Жүктелуде...", zh = "创建日期: 加载中...", fr = "Date de création: Chargement..." },
	home_device = { en = "Device: %s", ru = "Устройство: %s", kz = "Құрылғы: %s", zh = "设备: %s", fr = "Appareil: %s" },
	home_device_phone = { en = "Phone/Tablet", ru = "Телефон/Планшет", kz = "Телефон/Планшет", zh = "手机/平板电脑", fr = "Téléphone/Tablette" },
	home_device_pc = { en = "Computer", ru = "Компьютер", kz = "Компьютер", zh = "电脑", fr = "Ordinateur" },
	home_ip = { en = "IP-address: %s", ru = "IP-адрес: %s", kz = "IP-мекенжайы: %s", zh = "IP地址: %s", fr = "Adresse IP: %s" },
	home_ip_loading = { en = "IP-address: Loading...", ru = "IP-адрес: Загрузка...", kz = "IP-мекенжайы: Жүктелуде...", zh = "IP地址: 加载中...", fr = "Adresse IP: Chargement..." },
	home_country = { en = "Country: %s", ru = "Страна: %s", kz = "Ел: %s", zh = "国家: %s", fr = "Pays: %s" },
	home_country_loading = { en = "Country: Loading...", ru = "Страна: Загрузка...", kz = "Ел: Жүктелуде...", zh = "国家: 加载中...", fr = "Pays: Chargement..." },
	-- INFO PAGE
	info_bio = { en = "👋Hello, my name is Nurgazy,\n I live in Kazakhstan, and\n I am a young hacker and scripter\n who is just starting out.\n My scripts are high-quality\n and beautiful. Everything is real.", ru = "👋Привет, меня зовут Нургазы,\n я живу в Казахстане, и\n я молодой начинающий хакер и скриптер.\n Мои скрипты качественные\n и красивые. Все по-настоящему.", kz = "👋Сәлем, менің атым Нұрғазы,\n мен Қазақстанда тұрамын, және\n мен жас хакер әрі бастаушы скриптермін.\n Менің скриптерім сапалы\n және әдемі. Барлығы шынайы.", zh = "👋你好，我叫Nurgazy，\n我住在哈萨克斯坦，\n我是一个刚起步的年轻黑客和脚本编写者。\n我的脚本质量高且美观。\n一切都是真实的。", fr = "👋Bonjour, je m'appelle Nurgazy,\n j'habite au Kazakhstan, et\n je suis un jeune hacker et scripteur\n qui débute à peine.\n Mes scripts sont de haute qualité\n et beaux. Tout est réel." },
	info_profile = { en = "MY PROFILE", ru = "МОЙ ПРОФИЛЬ", kz = "МЕНІҢ ПРОФИЛІМ", zh = "我的个人资料", fr = "MON PROFIL" },
	info_discord = { en = "DISCORD", ru = "ДИСКОРД", kz = "ДИСКОРД", zh = "DISCORD", fr = "DISCORD" },
	info_channel = { en = "CHANNEL", ru = "КАНАЛ", kz = "АРНА", zh = "频道", fr = "CHAÎNE" },
	info_vk = { en = "VKONTAKTE", ru = "ВКОНТАКТЕ", kz = "ВКОНТАКТЕ", zh = "VKONTAKTE", fr = "VKONTAKTE" },
	info_website = { en = "WEBSITE", ru = "ВЕБ-САЙТ", kz = "ВЕБ-САЙТ", zh = "网站", fr = "SITE WEB" },
	-- GUI MODS PAGE
	mod_healthbar = { en = "Custom Healthbar", ru = "Кастомный Хелсбар", kz = "Жеке Денсаулық Жолағы", zh = "自定义生命条", fr = "Barre de vie perso" },
	mod_fpsping = { en = "FPS/Ping Display", ru = "Отображение FPS/Пинга", kz = "FPS/Пинг Көрсеткіші", zh = "显示FPS/延迟", fr = "Affichage FPS/Ping" },
	mod_worldcolor = { en = "World Color Changer", ru = "Смена Цвета Мира", kz = "Әлем Түсін Өзгерткіш", zh = "世界颜色变换器", fr = "Changeur de couleur du monde" },
	mod_rainbow = { en = "Rainbow", ru = "Радуга", kz = "Кемпірқосақ", zh = "彩虹", fr = "Arc-en-ciel" },
	-- SCRIPTS PAGE
	search_placeholder = { en = "Search scripts...", ru = "Поиск скриптов...", kz = "Скрипттерді іздеу...", zh = "搜索脚本...", fr = "Rechercher des scripts..." },
	script_fly = { en = "Fly gui ☑︎", ru = "Fly gui ☑︎", kz = "Fly gui ☑︎", zh = "飞行界面 ☑︎", fr = "Fly gui ☑︎" },
	script_fireblock = { en = "Fire Block ☑︎", ru = "Огненный Блок ☑︎", kz = "Отты Блок ☑︎", zh = "火焰方块 ☑︎", fr = "Bloc de feu ☑︎" },
	script_speed = { en = "Speed Hack ☑︎", ru = "Спидхак ☑︎", kz = "Жылдамдық хагы ☑︎", zh = "速度破解 ☑︎", fr = "Hack de vitesse ☑︎" },
	script_wallhop = { en = "Wallhop ☑︎", ru = "Wallhop ☑︎", kz = "Wallhop ☑︎", zh = "爬墙 ☑︎", fr = "Wallhop ☑︎" },
	script_clicktp = { en = "Click Teleport ☑︎", ru = "Телепорт по клику ☑︎", kz = "Басу арқылы телепорт ☑︎", zh = "点击传送 ☑︎", fr = "Téléportation par clic ☑︎" },
	script_playereesp = { en = "Player ESP ☑︎", ru = "ЕСП Игроков ☑︎", kz = "Ойыншы ESP ☑︎", zh = "玩家透视 ☑︎", fr = "ESP Joueur ☑︎" },
	-- PLAYERS PAGE
	player_ping = { en = "Ping: %s", ru = "Пинг: %s", kz = "Пинг: %s", zh = "延迟: %s", fr = "Ping: %s" },
	player_ip = { en = "IP Address: %s", ru = "IP-адрес: %s", kz = "IP-мекенжайы: %s", zh = "IP地址: %s", fr = "Adresse IP: %s" },
	player_country = { en = "Country: %s", ru = "Страна: %s", kz = "Ел: %s", zh = "国家: %s", fr = "Pays: %s" },
	player_ip_private = { en = "IP Address: %s", ru = "IP-адрес: %s", kz = "IP-мекенжайы: %s", zh = "IP地址：%s", fr = "Adresse IP: %s" },
	player_country_private = { en = "Country: %s", ru = "Страна: %s", kz = "Ел: %s", zh = "国家：%s", fr = "Pays: %s" },
	player_tp = { en = "TP", ru = "ТП", kz = "ТП", zh = "传送", fr = "TP" },
	player_observe = { en = "Observe", ru = "Наблюдать", kz = "Бақылау", zh = "观察", fr = "Observer" },
	-- COMMANDS PAGE
	commands_placeholder = { en = "/command [target] [args]", ru = "/команда [цель] [аргументы]", kz = "/команда [нысана] [аргументтер]", zh = "/命令 [目标] [参数]", fr = "/commande [cible] [args]" },
	-- CHAT PAGE
	chat_title = { en = "Global Chat", ru = "Глобальный Чат", kz = "Жалпы Чат", zh = "全球聊天", fr = "Chat Mondial" },
	chat_placeholder = { en = "Enter message...", ru = "Введите сообщение...", kz = "Хабарламаны енгізіңіз...", zh = "输入消息...", fr = "Entrez votre message..." },
	chat_sending = { en = "Sending...", ru = "Отправка...", kz = "Жіберілуде...", zh = "发送中...", fr = "Envoi..." },
	chat_you = { en = "You", ru = "Вы", kz = "Сіз", zh = "你", fr = "Vous" },
	chat_loading = { en = "<font color='#AAAAAA'><i>Loading messages...</i></font>", ru = "<font color='#AAAAAA'><i>Загрузка сообщений...</i></font>", kz = "<font color='#AAAAAA'><i>Хабарламалар жүктелуде...</i></font>", zh = "<font color='#AAAAAA'><i>加载消息中...</i></font>", fr = "<font color='#AAAAAA'><i>Chargement des messages...</i></font>" },
	chat_error_fetch = { en = "<font color='#FF5555'>Chat Error: %s</font>", ru = "<font color='#FF5555'>Ошибка чата: %s</font>", kz = "<font color='#FF5555'>Чат қатесі: %s</font>", zh = "<font color='#FF5555'>聊天错误: %s</font>", fr = "<font color='#FF5555'>Erreur du chat: %s</font>" },
	chat_error_decode = { en = "<font color='#FF5555'>Error decoding server response.</font>", ru = "<font color='#FF5555'>Ошибка декодирования ответа сервера.</font>", kz = "<font color='#FF5555'>Сервер жауабын декодтау қатесі.</font>", zh = "<font color='#FF5555'>解码服务器响应时出错。</font>", fr = "<font color='#FF5555'>Erreur de décodage de la réponse du serveur.</font>" },
	chat_no_messages = { en = "<font color='#AAAAAA'><i>No new messages. Say hi!</i></font>", ru = "<font color='#AAAAAA'><i>Нет новых сообщений. Поздоровайтесь!</i></font>", kz = "<font color='#AAAAAA'><i>Жаңа хабарламалар жоқ. Сәлемдесіңіз!</i></font>", zh = "<font color='#AAAAAA'><i>没有新消息。打个招呼吧！</i></font>", fr = "<font color='#AAAAAA'><i>Aucun nouveau message. Dites bonjour !</i></font>" },
	chat_error_send = { en = "<font color='#FF5555'>Error: Could not send message. %s</font>", ru = "<font color='#FF5555'>Ошибка: Не удалось отправить сообщение. %s</font>", kz = "<font color='#FF5555'>Қате: Хабарламаны жіберу мүмкін болмады. %s</font>", zh = "<font color='#FF5555'>错误：无法发送消息。 %s</font>", fr = "<font color='#FF5555'>Erreur: Impossible d'envoyer le message. %s</font>" },
	-- SETTINGS PAGE
	settings_themes_title = { en = "Themes", ru = "Темы", kz = "Тақырыптар", zh = "主题", fr = "Thèmes" },
	theme_red = { en = "Red (Default)", ru = "Красная (По умолч.)", kz = "Қызыл (Стандартты)", zh = "红色（默认）", fr = "Rouge (Défaut)" },
	theme_yellow = { en = "Yellow", ru = "Желтая", kz = "Сары", zh = "黄色", fr = "Jaune" },
	theme_blue = { en = "Blue", ru = "Синяя", kz = "Көк", zh = "蓝色", fr = "Bleu" },
	theme_green = { en = "Green", ru = "Зеленая", kz = "Жасыл", zh = "绿色", fr = "Vert" },
	theme_white = { en = "White", ru = "Белая", kz = "Ақ", zh = "白色", fr = "Blanc" },
	theme_rainbow = { en = "Rainbow", ru = "Радуга", kz = "Кемпірқосақ", zh = "彩虹", fr = "Arc-en-ciel" },
	settings_language_title = { en = "Type languages", ru = "Выберите язык", kz = "Тілдерді таңдаңыз", zh = "选择语言", fr = "Choisir la langue" },
	lang_en = { en = "English", ru = "English", kz = "English", zh = "English", fr = "English" },
	lang_ru = { en = "Russian", ru = "Русский", kz = "Русский", zh = "Русский", fr = "Русский" },
	lang_kz = { en = "Kazakh", ru = "Казахский", kz = "Қазақша", zh = "Казахский", fr = "Казахский" },
	lang_zh = { en = "Chinese", ru = "Китайский", kz = "Китайский", zh = "中文", fr = "Китайский" },
	lang_fr = { en = "French", ru = "Французский", kz = "Французский", zh = "Французский", fr = "Français" },
	-- EXECUTOR PAGE
	executor_placeholder = { en = "--[[ Paste your script here ]]--", ru = "--[[ Вставьте свой скрипт сюда ]]--", kz = "--[[ Скриптіңізді осы жерге қойыңыз ]]--", zh = "--[[ 在此处粘贴您的脚本 ]]--", fr = "--[[ Collez votre script ici ]]--" },
	-- NOTIFICATIONS
	notif_esp_title = { en = "ESP", ru = "ЕСП", kz = "ЕСП", zh = "透视", fr = "ESP" },
	notif_esp_enabled_text = { en = "Player ESP has been enabled.", ru = "ЕСП игроков включено.", kz = "Ойыншы ESP қосылды.", zh = "玩家透视已启用。", fr = "L'ESP des joueurs a été activé." },
	notif_esp_disabled_text = { en = "Player ESP has been disabled.", ru = "ЕСП игроков выключено.", kz = "Ойыншы ESP өшірілді.", zh = "玩家透视已禁用。", fr = "L'ESP des joueurs a été désactivé." },
	notif_clipboard_title = { en = "WilsonHub", ru = "WilsonHub", kz = "WilsonHub", zh = "WilsonHub", fr = "WilsonHub" },
	notif_clipboard_text = { en = "Link to %s copied!", ru = "Ссылка на %s скопирована!", kz = "%s сілтемесі көшірілді!", zh = "已复制到 %s 的链接！", fr = "Lien vers %s copié !" },
	notif_clipboard_error = { en = "WilsonHub Error", ru = "Ошибка WilsonHub", kz = "WilsonHub қатесі", zh = "WilsonHub错误", fr = "Erreur WilsonHub" },
	notif_clipboard_error_text = { en = "Function setclipboard not found.", ru = "Функция setclipboard не найдена.", kz = "setclipboard функциясы табылмады.", zh = "未找到函数 setclipboard。", fr = "Fonction setclipboard non trouvée." },
	notif_speed_title = { en = "Speed Hack", ru = "Спидхак", kz = "Жылдамдық хагы", zh = "速度破解", fr = "Hack de vitesse" },
	notif_speed_text = { en = "Speed increased to 50.", ru = "Скорость увеличена до 50.", kz = "Жылдамдық 50-ге дейін артты.", zh = "速度提升至50。", fr = "Vitesse augmentée à 50." },
	notif_clicktp_title = { en = "Click Teleport", ru = "Телепорт по клику", kz = "Басу арқылы телепорт", zh = "点击传送", fr = "Téléportation par clic" },
	notif_clicktp_text = { en = "Activated. Click to teleport.", ru = "Активировано. Нажмите для телепортации.", kz = "Белсендірілді. Телепорттау үшін басыңыз.", zh = "已激活。点击进行传送。", fr = "Activé. Cliquez pour vous téléporter." },
	notif_esp_legacy_title = { en = "ESP", ru = "ЕСП", kz = "ЕСП", zh = "透视", fr = "ESP" },
	notif_esp_legacy_text = { en = "ESP activated.", ru = "ЕСП активирован.", kz = "ЕСП белсендірілді.", zh = "透视已激活。", fr = "ESP activé." },
	notif_executor_error_title = { en = "Executor Error", ru = "Ошибка исполнителя", kz = "Орындаушы қатесі", zh = "执行器错误", fr = "Erreur de l'exécuteur" },
	notif_fatal_error_title = { en = "WILSONHUB FATAL ERROR", ru = "КРИТИЧЕСКАЯ ОШИБКА WILSONHUB", kz = "WILSONHUB КРИТИКАЛЫҚ ҚАТЕСІ", zh = "WILSONHUB 致命错误", fr = "ERREUR FATALE WILSONHUB" },
	notif_fatal_error_text = { en = "UI failed to load. Error: %s", ru = "Не удалось загрузить UI. Ошибка: %s", kz = "UI жүктелмеді. Қате: %s", zh = "UI加载失败。错误: %s", fr = "Échec du chargement de l'IU. Erreur: %s" },
	notif_welcome_title = { en = "WILSON UPLOADED🎮!", ru = "WILSON ЗАГРУЖЕН🎮!", kz = "WILSON ЖҮКТЕЛДІ🎮!", zh = "WILSON 已加载🎮!", fr = "WILSON CHARGÉ🎮!" },
	notif_welcome_text = { en = "This script is for Wilson hackers", ru = "Этот скрипт для хакеров Wilson", kz = "Бұл скрипт Wilson хакерлеріне арналған", zh = "此脚本适用于Wilson黑客", fr = "Ce script est pour les hackers de Wilson" },
	notif_welcome_button = { en = "Yes", ru = "Да", kz = "Иә", zh = "是", fr = "Oui" },
}

local themableObjects = {}
local translatableObjects = {}

-- Forward declare
local applyTheme
local activateRainbowTheme
local applyLanguage

applyLanguage = function(langName)
	if not languageMap[langName] then
		langName = "English"
	end
	settings.language = langName
	pcall(function()
		if writefile then
			writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings))
		end
	end)
    -- Применяем переводы ко всем зарегистрированным объектам
    local langCode = languageMap[settings.language] or "en"
    for _, item in ipairs(translatableObjects) do
        local obj = item.object
        if obj and obj.Parent then
            local key = item.key
            local property = item.property
            local text = (translations[key] and translations[key][langCode]) or (translations[key] and translations[key].en) or key
            obj[property] = text
        end
    end
end

local function sendTranslatedNotification(titleKey, textKey, duration, button1Key, textArgs)
	local langCode = languageMap[settings.language] or "en"
	local title = (translations[titleKey] and translations[titleKey][langCode]) or (translations[titleKey] and translations[titleKey].en) or titleKey
	local text_format = (translations[textKey] and translations[textKey][langCode]) or (translations[textKey] and translations[textKey].en) or textKey
	local text = text_format
	if textArgs then
		pcall(function()
			text = string.format(text_format, unpack(textArgs))
		end)
	end

	-- Тут должна быть ваша функция для отправки уведомлений
    -- Например: StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = duration })
end

-- [[ END LANGUAGE SYSTEM ]]

-- [[ THEME SYSTEM ]]
local rainbowThemeActive = false
local rainbowThemeConnection = nil
local activeTab = nil -- Will be set after GUI creation

local function updateRainbowColors()
	if not rainbowThemeActive then return end
	-- Логика для радужной темы
end

activateRainbowTheme = function()
	if rainbowThemeActive and rainbowThemeConnection and rainbowThemeConnection.Connected then return end
	-- Логика активации
end

applyTheme = function(themeName)
	if rainbowThemeConnection then
		rainbowThemeConnection:Disconnect()
		rainbowThemeConnection = nil
	end
	rainbowThemeActive = false
	-- Логика применения темы
end
--[[ END THEME SYSTEM ]]

-- [[ GUI MODS ФУНКЦИИ ИСПРАВЛЕНЫ]]

local customHealthbarGui = nil
local healthbarConnection = nil

function toggleCustomHealthbar(state) if state then if player.Character then createCustomHealthbar(player.Character) end; healthbarConnection = player.CharacterAdded:Connect(createCustomHealthbar) else if customHealthbarGui then customHealthbarGui:Destroy(); customHealthbarGui = nil end; if healthbarConnection then healthbarConnection:Disconnect(); healthbarConnection = nil end end end
function createCustomHealthbar(character) if customHealthbarGui then customHealthbarGui:Destroy() end; local head = character:FindFirstChild("Head"); local humanoid = character:FindFirstChildOfClass("Humanoid"); if not (head and humanoid) then return end; customHealthbarGui = Instance.new("BillboardGui", head); customHealthbarGui.Name = "CustomHealthbarGui"; customHealthbarGui.AlwaysOnTop = true; customHealthbarGui.Size = UDim2.new(0, 150, 0, 40); customHealthbarGui.StudsOffset = Vector3.new(0, 2.5, 0); local healthbar = Instance.new("Frame", customHealthbarGui); healthbar.Name = "Healthbar"; healthbar.Size = UDim2.new(1, 0, 0, 15); healthbar.BackgroundColor3 = Color3.fromRGB(10, 10, 10); healthbar.BorderColor3 = Color3.fromRGB(80, 80, 80); healthbar.BorderSizePixel = 1; Instance.new("UICorner", healthbar).CornerRadius = UDim.new(0, 5); local bar = Instance.new("Frame", healthbar); bar.Name = "Bar"; bar.Size = UDim2.new(1, 0, 1, 0); Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 5); local text = Instance.new("TextLabel", healthbar); text.Name = "Text"; text.Size = UDim2.new(1, 0, 1, 0); text.BackgroundTransparency = 1; text.TextColor3 = Color3.new(1, 1, 1); text.Font = Enum.Font.SourceSansBold; text.TextSize = 12; text.TextStrokeTransparency = 0.5; local function updateHealthbar() if not (humanoid and customHealthbarGui and customHealthbarGui.Parent) then return end; local percentage = humanoid.Health / humanoid.MaxHealth; local color = Color3.fromHSV(0.33 * percentage, 1, 1); bar:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true); bar.BackgroundColor3 = color; text.Text = math.floor(humanoid.Health) .. " / " .. humanoid.MaxHealth end; humanoid.HealthChanged:Connect(updateHealthbar); updateHealthbar() end

-- WORLD COLOR CHANGER
local originalColors= {}
local rainbowConnection= nil
local selectedColor= Color3.fromRGB(255, 0, 255)
function applyWorldColor(color) for _, part in ipairs(workspace:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then local isCharacterPart = false; for _, p in ipairs(Players:GetPlayers()) do if p.Character and part:IsDescendantOf(p.Character) then isCharacterPart = true; break end end; if not isCharacterPart then if not originalColors[part] then originalColors[part] = part.Color end; part.Color = color end end end end
function resetWorldColors() if rainbowConnection then rainbowConnection:Disconnect(); rainbowConnection = nil end; for part, color in pairs(originalColors) do if part and part.Parent then part.Color = color end end; originalColors = {} end
function toggleRainbowMode(state) if state then if rainbowConnection then rainbowConnection:Disconnect() end; rainbowConnection = RunService.Heartbeat:Connect(function() local hue = tick() % 5 / 5; applyWorldColor(Color3.fromHSV(hue, 1, 1)) end) else if rainbowConnection then rainbowConnection:Disconnect(); rainbowConnection = nil end end end

-- FPS/PING DISPLAY
local statsGui= nil
local statsUpdateConnection= nil
function toggleFpsPing(state) if state then if not (statsGui and statsGui.Parent) then createStatsDisplay() end else if statsGui then statsGui:Destroy(); statsGui = nil end; if statsUpdateConnection then statsUpdateConnection:Disconnect(); statsUpdateConnection = nil end end end
function createStatsDisplay() statsGui = Instance.new("ScreenGui", player.PlayerGui); statsGui.Name = "StatsDisplayGui"; statsGui.ResetOnSpawn = false; statsGui.Enabled = true; statsGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; statsGui.DisplayOrder = 999; local textLabel = Instance.new("TextLabel", statsGui); textLabel.Size = UDim2.new(0, 150, 0, 40); textLabel.Position = UDim2.new(1, -160, 1, -50); textLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20); textLabel.BackgroundTransparency = 0.2; textLabel.BorderSizePixel = 0; textLabel.TextColor3 = Color3.new(1, 1, 1); textLabel.Font = Enum.Font.SourceSansBold; textLabel.TextSize = 16; textLabel.TextXAlignment = Enum.TextXAlignment.Left; textLabel.Text = " FPS: ...\n PING: ..."; Instance.new("UICorner", textLabel).CornerRadius = UDim.new(0, 5); local lastUpdate = 0; local frameCounter = 0; statsUpdateConnection = RunService.Heartbeat:Connect(function(step) frameCounter = frameCounter + 1; local now = tick(); if now - lastUpdate >= 1 then local fps = math.floor(frameCounter / (now - lastUpdate)); local success, ping = pcall(function() return math.floor(player:GetNetworkPing() * 1000) end); if not success then ping = -1 end; textLabel.Text = string.format(" FPS: %d\n PING: %d ms", fps, ping); frameCounter = 0; lastUpdate = now end end) end

-- PLAYER ESP (НОВАЯ ФУНКЦИЯ)
local espData = { enabled = false, connections = {}, guis = {} }
local function cleanupEspForPlayer(targetPlayer)if espData.guis[targetPlayer] then if espData.guis[targetPlayer].gui and espData.guis[targetPlayer].gui.Parent then espData.guis[targetPlayer].gui:Destroy() end; if espData.guis[targetPlayer].updateConn then espData.guis[targetPlayer].updateConn:Disconnect() end; espData.guis[targetPlayer] = nil end end
local function cleanupAllEsp()for targetPlayer, _ in pairs(espData.guis) do cleanupEspForPlayer(targetPlayer) end; for _, conn in pairs(espData.connections) do conn:Disconnect() end; espData.connections = {}; espData.guis = {} end
local function createEspForPlayer(targetPlayer)if not espData.enabled or targetPlayer == player then return end; local character=targetPlayer.Character; if not character then return end; local head=character:WaitForChild("Head", 1); if not head then return end; cleanupEspForPlayer(targetPlayer); local espGui=Instance.new("BillboardGui", head); espGui.Name="PLAYER_ESP_GUI"; espGui.AlwaysOnTop=true; espGui.Size=UDim2.new(2,0,1.5,0); espGui.StudsOffset=Vector3.new(0,2.5,0); espGui.LightInfluence=0; local mainFrame=Instance.new("Frame", espGui); mainFrame.BackgroundTransparency=1; mainFrame.Size=UDim2.new(1,0,1,0); local box=Instance.new("Frame", mainFrame); box.BackgroundColor3=Color3.fromRGB(255,255,0); box.BackgroundTransparency=0.5; box.BorderSizePixel=0; box.Size=UDim2.new(1,0,1,0); Instance.new("UICorner",box).CornerRadius=UDim.new(0,3); local innerBox=Instance.new("Frame",box); innerBox.BackgroundColor3=Color3.fromRGB(0,0,0); innerBox.BackgroundTransparency=0.3; innerBox.BorderSizePixel=0; innerBox.Size=UDim2.new(1,-2,1,-2); innerBox.Position=UDim2.new(0.5,-innerBox.AbsoluteSize.X/2,0.5,-innerBox.AbsoluteSize.Y/2); Instance.new("UICorner",innerBox).CornerRadius=UDim.new(0,2); local textLabel=Instance.new("TextLabel",mainFrame); textLabel.BackgroundTransparency=1; textLabel.Size=UDim2.new(1,0,1,0); textLabel.Font=Enum.Font.SourceSans; textLabel.TextSize=14; textLabel.TextColor3=Color3.new(1,1,1); textLabel.TextStrokeColor3=Color3.fromRGB(0,0,0); textLabel.TextStrokeTransparency=0; local function update() if not targetPlayer or not targetPlayer.Parent or not character or not character.Parent or not head or not head.Parent then cleanupEspForPlayer(targetPlayer); return end; local distance=(head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude; textLabel.Text = targetPlayer.Name .. "\n[" .. math.floor(distance) .. "m]" end; espData.guis[targetPlayer] = { gui = espGui, updateConn = RunService.RenderStepped:Connect(update) } end
function togglePlayerEsp(state)espData.enabled=state; if espData.enabled then cleanupAllEsp(); for _,p in ipairs(Players:GetPlayers())do createEspForPlayer(p)end; espData.connections.playerAdded=Players.PlayerAdded:Connect(createEspForPlayer); espData.connections.playerRemoving=Players.PlayerRemoving:Connect(cleanupEspForPlayer); sendTranslatedNotification("notif_esp_title", "notif_esp_enabled_text", 5) else cleanupAllEsp(); sendTranslatedNotification("notif_esp_title", "notif_esp_disabled_text", 5) end end

-- 1. ЭКРАН ЗАГРУЗКИ
local LoadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"));
LoadingGui.Name = "LoadingGui";
LoadingGui.ResetOnSpawn = false;
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local Background = Instance.new("Frame", LoadingGui);
Background.Size = UDim2.new(1, 0, 1, 0);
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
Background.BorderSizePixel = 0
local LoadingLabel = Instance.new("TextLabel", Background);
LoadingLabel.Size = UDim2.new(1, 0, 0, 50);
LoadingLabel.Position = UDim2.new(0, 0, 0.5, -60);
LoadingLabel.BackgroundTransparency = 1;
LoadingLabel.TextColor3 = currentTheme.accent;
LoadingLabel.Font = Enum.Font.SourceSansBold;
LoadingLabel.TextSize = 42;
table.insert(translatableObjects, {object=LoadingLabel, property="Text", key="loading"})
local PercentageLabel = Instance.new("TextLabel", Background);
PercentageLabel.Size = UDim2.new(1, 0, 0, 30);
PercentageLabel.Position = UDim2.new(0, 0, 0.5, 0);
PercentageLabel.BackgroundTransparency = 1;
PercentageLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
PercentageLabel.Font = Enum.Font.SourceSansBold;
PercentageLabel.TextSize = 28;
PercentageLabel.Text = "0 %"
local ProgressBarBG = Instance.new("Frame", Background);
ProgressBarBG.Size = UDim2.new(0, 400, 0, 25);
ProgressBarBG.Position = UDim2.new(0.5, -200, 0.5, 40);
ProgressBarBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10);
ProgressBarBG.BorderSizePixel = 1;
ProgressBarBG.BorderColor3 = currentTheme.main;
Instance.new("UICorner", ProgressBarBG).CornerRadius = UDim.new(0, 8)
local ProgressBarFill = Instance.new("Frame", ProgressBarBG);
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0);
ProgressBarFill.BackgroundColor3 = currentTheme.accent;
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(0, 8)

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
		local WilsonHubGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"));
		WilsonHubGui.Name = "WilsonHubGui";
		WilsonHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
		WilsonHubGui.ResetOnSpawn = false;
		WilsonHubGui.Enabled = false
		
		local MainFrame = Instance.new("Frame", WilsonHubGui);
		MainFrame.Name = "MainFrame";
		MainFrame.Size = UDim2.new(0, 600, 0, 400);
		MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200);
		MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
		MainFrame.BorderSizePixel = 0;
		Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

		-- Header
		local Header = Instance.new("Frame", MainFrame)
		Header.Size = UDim2.new(1, 0, 0, 40)
		Header.BackgroundColor3 = currentTheme.main
		Header.BorderSizePixel = 0
		local HeaderCorner = Instance.new("UICorner", Header)
		HeaderCorner.CornerRadius = UDim.new(0,8)
        
        -- Title
		local TitleLabel = Instance.new("TextLabel", Header)
		TitleLabel.Size = UDim2.new(1, -50, 1, 0)
		TitleLabel.Position = UDim2.new(0, 10, 0, 0)
		TitleLabel.BackgroundTransparency = 1
		TitleLabel.Font = Enum.Font.SourceSansBold
		TitleLabel.TextSize = 16
		TitleLabel.TextColor3 = currentTheme.text
		TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(translatableObjects, {object=TitleLabel, property="Text", key="main_title"})
		
		-- Tabs Container
		local TabsContainer = Instance.new("Frame", MainFrame)
		TabsContainer.Size = UDim2.new(1, 0, 0, 35)
		TabsContainer.Position = UDim2.new(0, 0, 0, 40)
		TabsContainer.BackgroundTransparency = 1
		local TabsLayout = Instance.new("UIListLayout", TabsContainer)
		TabsLayout.FillDirection = Enum.FillDirection.Horizontal
        TabsLayout.Padding = UDim.new(0, 10)
        
		-- Pages Container
		local PagesContainer = Instance.new("Frame", MainFrame)
		PagesContainer.Size = UDim2.new(1, -10, 1, -85)
		PagesContainer.Position = UDim2.new(0.5, -PagesContainer.AbsoluteSize.X/2, 0, 80)
		PagesContainer.BackgroundTransparency = 1
		
		-- ============================================================= --
		-- СОЗДАНИЕ ВКЛАДОК И СТРАНИЦ
		-- ============================================================= --

		-- HOME
		local HomeTabButton = Instance.new("TextButton", TabsContainer)
		HomeTabButton.Name = "HomeTabButton"
		HomeTabButton.Size = UDim2.new(0, 70, 1, 0)
		HomeTabButton.BackgroundTransparency = 1
		HomeTabButton.Font = Enum.Font.SourceSansBold
		HomeTabButton.TextSize = 14
		table.insert(translatableObjects, {object = HomeTabButton, property = "Text", key = "tab_home"})

		local HomePage = Instance.new("Frame", PagesContainer)
		HomePage.Name = "HomePage"
		HomePage.Size = UDim2.new(1, 0, 1, 0)
		HomePage.BackgroundTransparency = 1
		HomePage.Visible = false
		
		-- SCRIPTS
		local ScriptsTabButton = Instance.new("TextButton", TabsContainer)
		ScriptsTabButton.Name = "ScriptsTabButton"
		ScriptsTabButton.Size = UDim2.new(0, 70, 1, 0)
		ScriptsTabButton.BackgroundTransparency = 1
		ScriptsTabButton.Font = Enum.Font.SourceSansBold
		ScriptsTabButton.TextSize = 14
		table.insert(translatableObjects, {object = ScriptsTabButton, property = "Text", key = "tab_scripts"})
        
		local ScriptsPage = Instance.new("Frame", PagesContainer)
		ScriptsPage.Name = "ScriptsPage"
		ScriptsPage.Size = UDim2.new(1, 0, 1, 0)
		ScriptsPage.BackgroundTransparency = 1
		ScriptsPage.Visible = false
        
		-- ================================================================= --
		-- [+] НАЧАЛО НОВОГО КОДА: ВКЛАДКА И СТРАНИЦА "SKINS"
		-- ================================================================= --
		local SkinsTabButton = Instance.new("TextButton", TabsContainer)
		SkinsTabButton.Name = "SkinsTabButton"
		SkinsTabButton.Size = UDim2.new(0, 70, 1, 0)
		SkinsTabButton.BackgroundTransparency = 1
		SkinsTabButton.Font = Enum.Font.SourceSansBold
		SkinsTabButton.TextSize = 14
		table.insert(translatableObjects, {object = SkinsTabButton, property = "Text", key = "tab_skins"})

		local SkinsPage = Instance.new("Frame", PagesContainer)
		SkinsPage.Name = "SkinsPage"
		SkinsPage.Size = UDim2.new(1, 0, 1, 0)
		SkinsPage.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		SkinsPage.BorderSizePixel = 0
		SkinsPage.Visible = false

		local SkinsContent = Instance.new("ScrollingFrame", SkinsPage)
		SkinsContent.Name = "SkinsContent"
		SkinsContent.Size = UDim2.new(1, -20, 1, -20)
		SkinsContent.Position = UDim2.new(0.5, -SkinsContent.AbsoluteSize.X / 2, 0.5, -SkinsContent.AbsoluteSize.Y / 2)
		SkinsContent.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		SkinsContent.BorderSizePixel = 1
		SkinsContent.BorderColor3 = Color3.fromRGB(50, 50, 50)
		SkinsContent.ScrollBarImageColor3 = currentTheme.accent
		SkinsContent.ScrollBarThickness = 6
		
		local SkinsListLayout = Instance.new("UIListLayout", SkinsContent)
		SkinsListLayout.Padding = UDim.new(0, 10)
		SkinsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local function createSkinButton(textKey, onClick)
			local button = Instance.new("TextButton", SkinsContent)
			button.Name = textKey
			button.Size = UDim2.new(1, 0, 0, 40)
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			button.Font = Enum.Font.SourceSans
			button.TextSize = 16
			button.TextColor3 = Color3.fromRGB(220, 220, 220)
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 4)
			table.insert(translatableObjects, {object = button, property = "Text", key = textKey})
			
			if onClick then
				button.MouseButton1Click:Connect(onClick)
			end
			return button
		end

		createSkinButton("skin_coolkidd", function()
			-- СЮДА ВСТАВЬТЕ ВАШ СКРИПТ ДЛЯ СКИНА C00LKIDD
			print("Активирован скин C00LKIDD")
			-- Пример: loadstring(game:HttpGet("https://example.com/coolkidd_skin.lua"))()
		end)

		createSkinButton("skin_johndoe", function()
			-- СЮДА ВСТАВЬТЕ ВАШ СКРИПТ ДЛЯ СКИНА JOHNDOE
			print("Активирован скин JOHNDOE")
		end)

		createSkinButton("skin_hack_wilson", function()
			-- СЮДА ВСТАВЬТЕ ВАШ СКРИПТ ДЛЯ СКИНА HACK_WILSON
			print("Активирован скин HACK_WILSON")
		end)
		-- ================================================================= --
		-- [+] КОНЕЦ НОВОГО КОДА
		-- ================================================================= --

		-- ЛОГИКА ПЕРЕКЛЮЧЕНИЯ ВКЛАДОК
		local function selectTab(selectedButton)
			for _, button in ipairs(TabsContainer:GetChildren()) do
				if button:IsA("TextButton") then
					button.TextColor3 = Color3.fromRGB(180, 180, 180) -- Неактивный цвет
				end
			end
			selectedButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- Активный цвет
			
			for _, page in ipairs(PagesContainer:GetChildren()) do
				if page:IsA("Frame") then
					page.Visible = false
				end
			end
			
			if selectedButton == HomeTabButton then
				HomePage.Visible = true
			elseif selectedButton == ScriptsTabButton then
				ScriptsPage.Visible = true
            -- ================================================================= --
            -- [+] НАЧАЛО НОВОГО КОДА: ЛОГИКА ДЛЯ ВКЛАДКИ SKINS
            -- ================================================================= --
			elseif selectedButton == SkinsTabButton then
				SkinsPage.Visible = true
            -- ================================================================= --
            -- [+] КОНЕЦ НОВОГО КОДА
            -- ================================================================= --
			end
			activeTab = selectedButton
		end
		
		HomeTabButton.MouseButton1Click:Connect(function() selectTab(HomeTabButton) end)
		ScriptsTabButton.MouseButton1Click:Connect(function() selectTab(ScriptsTabButton) end)
		-- ================================================================= --
		-- [+] НАЧАЛО НОВОГО КОДА: КЛИК ДЛЯ ВКЛАДКИ SKINS
		-- ================================================================= --
		SkinsTabButton.MouseButton1Click:Connect(function() selectTab(SkinsTabButton) end)
		-- ================================================================= --
		-- [+] КОНЕЦ НОВОГО КОДА
		-- ================================================================= --
		
		selectTab(HomeTabButton) -- Выбираем первую вкладку при запуске
	end)
end)

-- 3. АНИМАЦИЯ ЗАГРУЗКИ
applyLanguage(settings.language)
local loadDuration = 3
for i = 0, 100 do
	local progress = i / 100
	local numDots = math.floor(i / 12) % 4
	if LoadingLabel and LoadingLabel.Parent then
		local langCode = languageMap[settings.language] or "en"
		local baseLoadingText = translations.loading[langCode] or translations.loading.en
		LoadingLabel.Text = baseLoadingText .. string.rep(".", numDots)
	end
	PercentageLabel.Text = i .. " %"
	ProgressBarFill.Size = UDim2.new(progress, 0, 1, 0)
	task.wait(loadDuration / 100)
end
task.wait(0.2)

-- 4. ЗАВЕРШЕНИЕ
LoadingGui:Destroy()
local WilsonHubGui = player.PlayerGui:FindFirstChild("WilsonHubGui")
if WilsonHubGui then
	WilsonHubGui.Enabled = true
end
sendTranslatedNotification("notif_welcome_title", "notif_welcome_text", 7, "notif_welcome_button")
