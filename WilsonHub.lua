-- Основные сервисы
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


-- [[ THEMES, LANGUAGES & SETTINGS ]]
local Themes = {
    Red = { main = Color3.fromRGB(200, 0, 0), accent = Color3.fromRGB(255, 0, 0), text = Color3.fromRGB(255, 255, 255) },
    Yellow = { main = Color3.fromRGB(255, 190, 0), accent = Color3.fromRGB(255, 220, 50), text = Color3.fromRGB(0,0,0) },
    Blue = { main = Color3.fromRGB(0, 120, 255), accent = Color3.fromRGB(50, 150, 255), text = Color3.fromRGB(255,255,255) },
    Green = { main = Color3.fromRGB(0, 180, 0), accent = Color3.fromRGB(50, 220, 50), text = Color3.fromRGB(255,255,255) },
    White = { main = Color3.fromRGB(240, 240, 240), accent = Color3.fromRGB(200, 200, 200), text = Color3.fromRGB(0, 0, 0) }
}
local settings = { theme = "Red", language = "English" }

-- ЗАГРУЗКА НАСТРОЕК
if isfile and isfile("WilsonHubSettings.json") then
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
local languageMap = { English = "en", Russian = "ru", Kazakh = "kz", Chinese = "zh", French = "fr" }
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
    tab_scripts = { en = "SCRIPTS", ru = "СКРИПТЫ", kz = "СКРИПТТЕР", zh = "脚本", fr = "SCRIPTS" },
    tab_info = { en = "INFO", ru = "ИНФО", kz = "АҚПАРАТ", zh = "信息", fr = "INFOS" },
    tab_guimods = { en = "GUI MODS", ru = "МОДЫ GUI", kz = "GUI МОДТАРЫ", zh = "界面模组", fr = "MODS GUI" },
    tab_players = { en = "PLAYERS", ru = "ИГРОКИ", kz = "ОЙЫНШЫЛАР", zh = "玩家", fr = "JOUEURS" },
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
    info_bio = { ru = "Приветствую, меня зовут Нургазы, и я разработчик этого скрипта.\nЭтот скрипт называется WILSONHUB и был\nвыпущен 10.07.2025. В наших скриптах есть\nвсё необходимое, и они качественные.\nПрисоединяйтесь к нашим каналам в Discord и Telegram.", kz = "Сәлем, менің атым Нұрғазы, мен осы скриптің әзірлеушісімін.\nБұл скриптің аты WILSONHUB, ол 2025 жылдың 10 шілдесінде шығарылды.\nБіздің скриптерде барлық қажетті нәрсе бар және олар сапалы.\nБіздің Discord және Telegram арналарымызға қосылыңыз.", en = "Greetings, my name is Nurgazy, and I am the developer of this script.\nThis script is called WILSONHUB and was released on 10.07.2025.\nOur scripts have everything you need, and they are high-quality.\nJoin our channels on Discord and Telegram.", zh = "大家好, 我叫 Nurgazy，是这个脚本的开发者。\n这个脚本名为 WILSONHUB，发布于 2025年7月10日。\n我们的脚本包含您所需的一切，并且质量上乘。\n欢迎加入我们的 Discord 和 Telegram 频道。", fr = "Salutations, je m'appelle Nurgazy, et je suis le développeur de ce script.\nCe script s'appelle WILSONHUB et a été publié le 10.07.2025.\nNos scripts contiennent tout ce dont vous avez besoin et sont de haute qualité.\nRejoignez nos canaux sur Discord et Telegram." },
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
    script_fly = { en = "Fly gui ☑︎", ru = "Летать гуи ☑︎", kz = "Ұшу гуи ☑︎", zh = "飞行界面 ☑︎", fr = "Fly gui ☑︎" },
    script_fireblock = { en = "Fire Block ☑︎", ru = "Огненный Блок ☑︎", kz = "Отты Блок ☑︎", zh = "火焰方块 ☑︎", fr = "Bloc de feu ☑︎" },
    script_speed = { en = "Speed Hack ☑︎", ru = "Спидхак ☑︎", kz = "Жылдамдық хагы ☑︎", zh = "速度破解 ☑︎", fr = "Hack de vitesse ☑︎" },
    script_wallhop = { en = "Wallhop ☑︎", ru = "Прыжки с стеном ☑︎", kz = "Қабырғада секіру ☑︎", zh = "爬墙 ☑︎", fr = "Wallhop ☑︎" },
    script_clicktp = { en = "Click Teleport", ru = "Телепорт по клику ☑︎", kz = "Басу арқылы телепорт ☑︎", zh = "点击传送 ☑︎", fr = "Téléportation par clic ☑︎" },
    script_grav = { en = "Gravity", ru = "Гравитация", kz = "Гравитация", zh = "重力", fr = "Pesanteur" },
    script_afk = { en = "Anti afk", ru = "Анти афк", kz = "Анти афк", zh = "反afk", fr = "Anti-afk" },
    script_infiniteyield= { en = "infiniteyield", ru = "infiniteyield", kz = "infiniteyield", zh = "無限收益", fr = "rendement infini" },
    script_antislap = { en = "Anti slap", ru = "Анти шлепок", kz = "Анти ұру", zh = "防拍擊", fr = "Anti claque" },
    script_autoslap = { en = "Auto slap", ru = "Авто шлепок", kz = "Авто ұру", zh = "自動拍打", fr = "Gifle automatique" },
    script_win = { en = "Win", ru = "Победа", kz = "Жеңіс", zh = "勝利", fr = "Victoire" },
    script_god = { en = "God mode ☑︎", ru = "Режим Бога ☑︎", kz = "Құдай режимі ☑︎", zh = "上帝模式 ☑︎", fr = "Mode Dieu ☑︎" },
    script_spamdecal = { en = "WilsonSpam ☑︎", ru = "УилсонСпам ☑︎", kz = "WilsonSpam ☑︎", zh = "威爾遜垃圾郵件 ☑︎", fr = "WilsonSpam ☑︎" },
    script_skybox = { en = "WilsonSpamDecal ☑︎", ru = "УилсонСпамДетал ☑︎", kz = "WilsonSpamDecal ☑︎", zh = "威爾遜垃圾郵件貼紙 ☑︎", fr = "WilsonSpamDecal ☑︎" },
    script_ak47 = { en = "AK-47 ☑︎", ru = "Автомат АК-47 ☑︎", kz = "АК-47 ☑︎", zh = "AK-47 ☑︎", fr = "AK-47 ☑︎" },
    script_lasergun = { en = "Laser gun ☑︎", ru = "Лазерное оружие ☑︎", kz = "Лазерлі қару ☑︎", zh = "雷射武器 ☑︎", fr = "armes laser ☑︎" },
    script_johndoe = { en = "AVATAR JOHNDOE", ru = "Аватар JOHNDOE", kz = "Аватар JOHNDOE", zh = "阿凡達約翰多", fr = "AVATAR JOHNDOE" },
    script_avatarcopy = { en = "COPY SKIN R6 ☑︎", ru = "Копировать аватар ☑︎", kz = "Аватарды көшіру ☑︎", zh = "複製頭像 ☑︎", fr = "COPIER L'AVATAR ☑︎" },
    script_jerk = { en = "Jerk ☑︎", ru = "Jerk ☑︎", kz = "Jerk ☑︎", zh = "混蛋 ☑︎", fr = "Abruti ☑︎" },
    script_spamchat = { en = "Spamchat", ru = "Спамчат", kz = "Спам чат", zh = "垃圾聊天", fr = "Spamchat" },
    script_dance = { en = "Dance", ru = "Танец", kz = "Би", zh = "舞蹈", fr = "Danse" },
    script_hummer = { en = "Ban hummer", ru = "Запретить Хаммер", kz = "Хаммерді бұғаттау", zh = "禁止悍馬", fr = "Interdire le Hummer" },
    script_snake = { en = "Snake", ru = "Змея", kz = "Жылан", zh = "蛇", fr = "Serpent " },
    script_r6 = { en = "R7", ru = "R7 ☑︎", kz = "R7 ☑︎", zh = "R7 ☑︎", fr = "R7 ☑︎" },
    script_metiorid = { en = "Meteor tool", ru = "Метеоритный инструмент", kz = "Метеор құралы", zh = "流星工具", fr = "Outil Météore" },
    script_thomas = { en = "Thomas", ru = "Томас", kz = "Томас", zh = "湯瑪斯", fr = "Thomas " },
    script_spider = { en = "Spiderman ☑︎", ru = "Человек паук ☑︎", kz = "Өрмекші адам ☑︎", zh = "蜘蛛人 ☑︎", fr = "Spider-Man ☑︎" },
    script_playertp = { en = "Player tp", ru = "Тп на игрок", kz = "Ойыншыға тп", zh = "玩家傳送", fr = "Player teleport " },
    script_board = { en = "Keyboard ☑︎", ru = "Клавиатура ☑︎", kz = "Пернетақта ☑︎", zh = "鍵盤 ☑︎", fr = "Clavier ☑︎" },
    script_xester = { en = "Xester ☑︎", ru = "Xester ☑︎", kz = "Xester ☑︎", zh = "克斯特 ☑︎", fr = "Xester ☑︎" },
    script_rpg = { en = "Rocket", ru = "Ракета", kz = "Зымыран", zh = "火箭", fr = "Fusée" },
    script_object = { en = "BTool ☑︎", ru = "Btool ☑︎", kz = "Btool ☑︎", zh = "工具 ☑︎", fr = "Btool ☑︎" },
    script_killall = { en = "Kill all ☑︎", ru = "Убить всех ☑︎", kz = "Барлығын өлтіру ☑︎", zh = "全部殺死 ☑︎", fr = "Tuez tout le monde ☑︎" },
    script_head = { en = "Big head", ru = "Большой голова", kz = "Үлкен бас", zh = "大頭", fr = "Grosse tête " },
    script_jump = { en = "Infinite jump", ru = "Большой прыжок", kz = "Ұзын секіру", zh = "無限跳躍", fr = "Saut infini " },
    script_firepart = { en = "Fireparts tool", ru = "Fireparts tool ☑︎", kz = "Fireparts tool ☑︎", zh = "Fireparts 工具 ☑︎", fr = "Outil Fireparts ☑︎" },
    script_invisible = { en = "invisible", ru = "Невидимка", kz = "Көрінбейтін", zh = "無形的", fr = "Invisible " },
    script_invisible2 = { en = "invisible 2", ru = "Невидимка 2", kz = "Көрінбейтін 2", zh = "隱形2", fr = "Invisible 2" },
    -- PLAYERS PAGE
    player_ping = { en = "Ping: %s", ru = "Пинг: %s", kz = "Пинг: %s", zh = "延迟: %s", fr = "Ping: %s" },
    player_ip = { en = "IP Address: %s", ru = "IP-адрес: %s", kz = "IP-мекенжайы: %s", zh = "IP地址: %s", fr = "Adresse IP: %s" },
    player_country = { en = "Country: %s", ru = "Страна: %s", kz = "Ел: %s", zh = "国家: %s", fr = "Pays: %s" },
    player_ip_private = { en = "IP Address: Private", ru = "IP-адрес: Приватный", kz = "IP-мекенжайы: Жабық", zh = "IP地址：私人的", fr = "Adresse IP: privé" },
    player_country_private = { en = "Country: Private", ru = "Страна: Приватный", kz = "Ел: Жабық", zh = "国家：私人的", fr = "Pays: privé" },
    player_tp = { en = "TP", ru = "ТП", kz = "ТП", zh = "传送", fr = "TP" },
    player_observe = { en = "Observe", ru = "Наблюдать", kz = "Бақылау", zh = "观察", fr = "Observer" },
    -- SETTINGS PAGE
    settings_themes_title = { en = "Themes", ru = "Темы", kz = "Тақырыптар", zh = "主题", fr = "Thèmes" },
    theme_red = { en = "Red (Default)", ru = "Красная (По умолч.)", kz = "Қызыл (Стандартты)", zh = "红色（默认）", fr = "Rouge (Défaut)" },
    theme_yellow = { en = "Yellow", ru = "Желтая", kz = "Сары", zh = "黄色", fr = "Jaune" },
    theme_blue = { en = "Blue", ru = "Синяя", kz = "Көк", zh = "蓝色", fr = "Bleu" },
    theme_green = { en = "Green", ru = "Зеленая", kz = "Жасыл", zh = "绿色", fr = "Vert" },
    theme_white = { en = "White", ru = "Белая", kz = "Ақ", zh = "白色", fr = "Blanc" },
    theme_rainbow = { en = "Rainbow", ru = "Радуга", kz = "Кемпірқосақ", zh = "彩虹", fr = "Arc-en-ciel" },
    settings_language_title = { en = "Type languages", ru = "Выберите язык", kz = "Тілдерді таңдаңыз", zh = "选择语言", fr = "Choisir la langue" },
    lang_en = { en = "English", ru = "Английский", kz = "Ағылшынша", zh = "英語", fr = "Anglais " },
    lang_ru = { en = "Russian", ru = "Русский", kz = "Орысша", zh = "俄文", fr = "Russe " },
    lang_kz = { en = "Kazakh", ru = "Казахский", kz = "Қазақша", zh = "哈薩克", fr = "Kazakh " },
    lang_zh = { en = "Chinese", ru = "Китайский", kz = "Қытайша", zh = "中文", fr = "Chinois " },
    lang_fr = { en = "French", ru = "Французский", kz = "Французша", zh = "法語", fr = "Français" },
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
    if not languageMap[langName] then langName = "English" end
    settings.language = langName
    pcall(function() if writefile then writefile("WilsonHubSettings.json", HttpService:JSONEncode(settings)) end end)
    
    local langCode = languageMap[settings.language] or "en"
    
    for _, item in ipairs(translatableObjects) do
        if item.object and item.object.Parent then
            local translationData = translations[item.key]
            if translationData then
                local translatedText = translationData[langCode] or translationData.en -- Fallback to English
                if item.dynamic_args then
                     pcall(function() item.object[item.property] = string.format(translatedText, unpack(item.dynamic_args)) end)
                else
                     item.object[item.property] = translatedText
                end
            end
        end
    end
end

local function sendTranslatedNotification(titleKey, textKey, duration, button1Key, textArgs)
    local langCode = languageMap[settings.language] or "en"
    local title = (translations[titleKey] and translations[titleKey][langCode]) or (translations[titleKey] and translations[titleKey].en) or titleKey
    local text_format = (translations[textKey] and translations[textKey][langCode]) or (translations[textKey] and translations[textKey].en) or textKey
    local text = text_format
    if textArgs then
        pcall(function() text = string.format(text_format, unpack(textArgs)) end)
    end
    
    local button1 = nil
    if button1Key then
         button1 = (translations[button1Key] and translations[button1Key][langCode]) or (translations[button1Key] and translations[button1Key].en) or button1Key
    end
    
    local notificationInfo = { Title = title, Text = text, Duration = duration }
    if button1 then notificationInfo.Button1 = button1 end
    
    pcall(StarterGui.SetCore, StarterGui, "SendNotification", notificationInfo)
end

-- [[ END LANGUAGE SYSTEM ]]


-- [[ THEME SYSTEM ]]
local rainbowThemeActive = false
local rainbowThemeConnection = nil
local activeTab = nil -- Will be set after GUI creation

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
-- [[ END THEME SYSTEM ]]


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
function togglePlayerEsp(state) espData.enabled=state; if espData.enabled then cleanupAllEsp(); for _,p in ipairs(Players:GetPlayers())do createEspForPlayer(p)end; espData.connections.playerAdded=Players.PlayerAdded:Connect(createEspForPlayer); espData.connections.playerRemoving=Players.PlayerRemoving:Connect(cleanupEspForPlayer); sendTranslatedNotification("notif_esp_title", "notif_esp_enabled_text", 5) else cleanupAllEsp(); sendTranslatedNotification("notif_esp_title", "notif_esp_disabled_text", 5) end end

-- ================================================================= --
-- [[ ЖАҢА КІРІСПЕ АНИМАЦИЯСЫ ]]
-- ================================================================= --
pcall(function()
    -- Керекті сервистерді алу
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- Негізгі UI элементтерін құру
    local PreLoadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    PreLoadingGui.Name = "WilsonHubIntroGui"
    PreLoadingGui.ResetOnSpawn = false
    PreLoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    PreLoadingGui.IgnoreGuiInset = true

    -- Қара фон
    local Background = Instance.new("Frame", PreLoadingGui)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BorderSizePixel = 0

    -- Ортадағы сурет (логотип)
    local Logo = Instance.new("ImageLabel", Background)
    Logo.Size = UDim2.new(0, 220, 0, 220) -- Сурет өлшемі
    Logo.Position = UDim2.new(0.5, 0, 0.5, -30)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    -- !!! МАҢЫЗДЫ: ОСЫ ЖЕРГЕ ӨЗІҢ ЖҮКТЕГЕН СУРЕТТІҢ ID КОДЫН ҚОЙ !!!
    Logo.Image = "rbxassetid://89264639082468" 
    Logo.ScaleType = Enum.ScaleType.Crop

    -- Суретті домалақ қылу үшін
    local corner = Instance.new("UICorner", Logo)
    corner.CornerRadius = UDim.new(0.5, 0)

    -- Астындағы жазу
    local PresentsText = Instance.new("TextLabel", Background)
    PresentsText.Size = UDim2.new(1, -40, 0, 30)
    PresentsText.Position = UDim2.new(0.5, 0, 0.5, 115)
    PresentsText.AnchorPoint = Vector2.new(0.5, 0.5)
    PresentsText.BackgroundTransparency = 1
    PresentsText.Font = Enum.Font.SourceSansBold
    PresentsText.TextSize = 26
    PresentsText.TextColor3 = Color3.fromRGB(200, 0, 0) -- Қызыл түс
    PresentsText.Text = "" -- Анимация үшін басында бос

    -- --- АНИМАЦИЯЛАР ---
    -- 1. Элементтерді бастапқы күйге келтіру (көрінбейтін)
    Background.BackgroundTransparency = 1
    Logo.ImageTransparency = 1
    Logo.Size = UDim2.new(0, 0, 0, 0)

    -- 2. Анимацияны бастау
    -- Фонның біртіндеп пайда болуы
    TweenService:Create(Background, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    task.wait(0.3)

    -- Логотиптің ортадан үлкейіп пайда болуы ("фото анимациясы")
    local logoTweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(Logo, logoTweenInfo, {
        Size = UDim2.new(0, 220, 0, 220),
        ImageTransparency = 0
    }):Play()
    task.wait(0.6)

    -- Тексттің әріптеп жазылу анимациясы (1 секунд)
    local fullText = "WILSONHUB games presents"
    for i = 1, #fullText do
        PresentsText.Text = string.sub(fullText, 1, i)
        task.wait(1.0 / #fullText)
    end

    -- 3. Анимацияның соңы (жалпы 2 секундтан кейін жоғалады)
    task.wait(0.5) -- Анимация біткен соң сәл күту

    -- Барлығының біртіндеп жоғалуы
    TweenService:Create(Background, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)

    -- Бұл экранды толықтай жою
    PreLoadingGui:Destroy()
end)

-- ================================================================= --
-- [[ ЖАҢА КІРІСПЕ АНИМАЦИЯСЫНЫҢ СОҢЫ ]]
-- ================================================================= --

-- 1. ЭКРАН ЗАГРУЗКИ
local LoadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")); LoadingGui.Name = "LoadingGui"; LoadingGui.ResetOnSpawn = false; LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
LoadingGui.IgnoreGuiInset = true
local Background = Instance.new("Frame", LoadingGui); Background.Size = UDim2.new(1, 0, 1, 0); Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Background.BorderSizePixel = 0
local LoadingLabel = Instance.new("TextLabel", Background); LoadingLabel.Size = UDim2.new(1, 0, 0, 50); LoadingLabel.Position = UDim2.new(0, 0, 0.5, -60); LoadingLabel.BackgroundTransparency = 1; LoadingLabel.TextColor3 = currentTheme.accent; LoadingLabel.Font = Enum.Font.SourceSansBold; LoadingLabel.TextSize = 42; table.insert(translatableObjects, {object=LoadingLabel, property="Text", key="loading"})
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
        WilsonHubGui.IgnoreGuiInset = true
        local BackgroundOverlay = Instance.new("Frame", WilsonHubGui) BackgroundOverlay.Name = "BackgroundOverlay" BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0) BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0) BackgroundOverlay.BackgroundTransparency = 0.5 BackgroundOverlay.BorderSizePixel = 0 BackgroundOverlay.ZIndex = 1 BackgroundOverlay.Visible = true

        local MainFrame = Instance.new("Frame", WilsonHubGui); MainFrame.Name = "MainFrame"; MainFrame.ZIndex = 2 
        
        MainFrame.Size = UDim2.new(0, 550, 0, 300); 
        MainFrame.Position = UDim2.new(0.5, -275, 0.5, -150);
        
        MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35); MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true; Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
        local IconFrame = Instance.new("ImageButton", WilsonHubGui); IconFrame.Name = "IconFrame"; IconFrame.Size = UDim2.new(0, 60, 0, 60); IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0); IconFrame.AnchorPoint = Vector2.new(0.5, 0.5); IconFrame.Image = "rbxassetid://121928953984347"; IconFrame.BackgroundTransparency = 1; IconFrame.Visible = false; IconFrame.Active = true; IconFrame.Draggable = true; Instance.new("UICorner", IconFrame).CornerRadius = UDim.new(0, 10);
        local IconStroke = Instance.new("UIStroke", IconFrame) IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border IconStroke.Color = currentTheme.main IconStroke.Thickness = 2 table.insert(themableObjects, {object = IconStroke, property = "Color", colorType = "main"})
        local Header = Instance.new("Frame", MainFrame); Header.Size = UDim2.new(1, 0, 0, 40); Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)  
        local TitleLabel = Instance.new("TextLabel", Header); TitleLabel.Size = UDim2.new(1, 0, 1, 0); TitleLabel.BackgroundTransparency = 1; TitleLabel.Font = Enum.Font.SourceSansBold; TitleLabel.TextSize = 20; table.insert(translatableObjects, {object=TitleLabel, property="Text", key="main_title"})
        local CloseButton = Instance.new("TextButton", Header); CloseButton.Size = UDim2.new(0, 40, 1, 0); CloseButton.Position = UDim2.new(1, -40, 0, 0); CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45); CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255); CloseButton.Font = Enum.Font.SourceSansBold; CloseButton.TextSize = 20; table.insert(translatableObjects, {object=CloseButton, property="Text", key="close_button"})
        
        local TabsContainer = Instance.new("ScrollingFrame", MainFrame); TabsContainer.Name = "TabsContainer"; TabsContainer.Size = UDim2.new(0, 120, 1, -40); TabsContainer.Position = UDim2.new(0, 0, 0, 40); TabsContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabsContainer.BorderSizePixel = 0; 
        TabsContainer.ScrollBarThickness = 8; TabsContainer.ScrollBarImageColor3 = currentTheme.main; TabsContainer.ScrollBarImageTransparency = 0.4
        table.insert(themableObjects, {object = TabsContainer, property = "ScrollBarImageColor3", colorType = "main"})

        local ContentContainer = Instance.new("Frame", MainFrame); ContentContainer.Name = "ContentContainer"; ContentContainer.Size = UDim2.new(1, -120, 1, -40); ContentContainer.Position = UDim2.new(0, 120, 0, 40); ContentContainer.BackgroundTransparency = 1
        
        local TabsList = Instance.new("UIListLayout", TabsContainer); TabsList.Padding = UDim.new(0, 10); TabsList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local function createTabButton(textKey) local button = Instance.new("TextButton", TabsContainer); button.Size = UDim2.new(1, -10, 0, 40); button.BackgroundColor3 = Color3.fromRGB(60, 60, 60); button.TextColor3 = Color3.fromRGB(255, 255, 255); button.Font = Enum.Font.SourceSansBold; button.TextSize = 18; table.insert(translatableObjects, {object=button, property="Text", key=textKey}); return button end  
        local HomeButton=createTabButton("tab_home"); local MainButton=createTabButton("tab_scripts"); local InfoButton=createTabButton("tab_info"); local GuiModsButton=createTabButton("tab_guimods"); local PlayersButton=createTabButton("tab_players"); local SettingsButton=createTabButton("tab_settings"); local ExecutorButton=createTabButton("tab_executor")

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
        local SettingsPage=Instance.new("Frame",ContentContainer); SettingsPage.Size=UDim2.new(1,0,1,0); SettingsPage.BackgroundTransparency=1; SettingsPage.Visible=false
        local ExecutorPage=Instance.new("Frame",ContentContainer); ExecutorPage.Size=UDim2.new(1,0,1,0); ExecutorPage.BackgroundTransparency=1; ExecutorPage.Visible=false

        local function createFunctionButton(textKey, parent, callback) 
            local b = Instance.new("TextButton",parent)
            local theme = (not rainbowThemeActive) and currentTheme or Themes.Red
            b.BackgroundColor3=theme.main
            b.TextColor3=theme.text
            b.Font=Enum.Font.SourceSansBold
            b.TextSize=16
            
            -- FIX: Set initial text on creation to prevent "Button" text on dynamic elements
            local langCode = languageMap[settings.language] or "en"
            local initialText = (translations[textKey] and translations[textKey][langCode]) or (translations[textKey] and translations[textKey].en) or textKey
            b.Text = initialText

            b.TextScaled = false
            b.RichText = false
            b.TextYAlignment = Enum.TextYAlignment.Center
            b.Size = UDim2.new(0, 120, 0, 35)
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
            if callback then b.MouseButton1Click:Connect(function() pcall(callback) end) end
            table.insert(themableObjects, {object=b, property="BackgroundColor3", colorType="main"})
            table.insert(themableObjects, {object=b, property="TextColor3", colorType="text"})
            table.insert(translatableObjects, {object=b, property="Text", key=textKey})
            return b 
        end
        local function createInfoLabel(text, parent) local label = Instance.new("TextLabel", parent); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Font = Enum.Font.SourceSans; label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left; label.Text = text; return label end;
        
        -- #region HOME PAGE
local PlayerImage = Instance.new("ImageLabel", HomePage);
PlayerImage.Size = UDim2.new(0, 128, 0, 128);
PlayerImage.Position = UDim2.new(0, 15, 0, 15);
PlayerImage.BackgroundTransparency = 1;
task.spawn(function()
    pcall(function()
        PlayerImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
end);
local playerImageBorder = Instance.new("UIStroke", PlayerImage);
playerImageBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
playerImageBorder.Color = currentTheme.main;
playerImageBorder.Thickness = 2;
table.insert(themableObjects, {object = playerImageBorder, property = "Color", colorType = "main"})

local WelcomeLabel = createInfoLabel("", HomePage);
WelcomeLabel.Position = UDim2.new(0, 150, 0, 35);
WelcomeLabel.TextColor3 = currentTheme.accent;
WelcomeLabel.Font = Enum.Font.SourceSansBold;
WelcomeLabel.TextSize = 22;
table.insert(translatableObjects, {object = WelcomeLabel, property = "Text", key = "home_welcome", dynamic_args = {player.Name}})

local NickLabel = createInfoLabel("", HomePage);
NickLabel.Position = UDim2.new(0, 150, 0, 60);
table.insert(translatableObjects, {object = NickLabel, property = "Text", key = "home_nickname", dynamic_args = {player.Name}})

local IdLabel = createInfoLabel("", HomePage);
IdLabel.Position = UDim2.new(0, 150, 0, 85);
table.insert(translatableObjects, {object = IdLabel, property = "Text", key = "home_userid", dynamic_args = {player.UserId}})

local AgeLabel = createInfoLabel("", HomePage);
AgeLabel.Position = UDim2.new(0, 150, 0, 110);
table.insert(translatableObjects, {object = AgeLabel, property = "Text", key = "home_userage", dynamic_args = {player.AccountAge}})

-- Жаңа ақпараттарды осы жерге қосамыз
local GameNameLabel = createInfoLabel("", HomePage);
GameNameLabel.Position = UDim2.new(0, 150, 0, 135);
GameNameLabel.Text = "Game Name: " .. game.Name;

local ExecutorLabel = createInfoLabel("", HomePage);
ExecutorLabel.Position = UDim2.new(0, 150, 0, 160);
ExecutorLabel.Text = "Executor: ";

local UserCountLabel = createInfoLabel("", HomePage);
UserCountLabel.Position = UDim2.new(0, 150, 0, 185);
UserCountLabel.Text = "Total users: Loading...";

-- Орындаушы атауын анықтау
local Executor = "Unknown";
pcall(function()
    if is_synapse_x then
        Executor = "Synapse X";
    elseif is_krnl then
        Executor = "KRNL";
    elseif is_fluxus then
        Executor = "Fluxus";
    elseif getgenv then
        Executor = "Delta";
    end
end)
ExecutorLabel.Text = "Executor: " .. Executor;

-- Қолданушы санын жүктеу (онлайн API қажет)
task.spawn(function()
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://your-api-url.com/user_count"))
    end)
    if success and response and response.users then
        UserCountLabel.Text = "Total users: " .. response.users;
    else
        UserCountLabel.Text = "Total users: 168 users";
    end
end)

local creationDateLabel = createInfoLabel("", HomePage);
creationDateLabel.Position = UDim2.new(0, 15, 0, 150);
table.insert(translatableObjects, {object = creationDateLabel, property = "Text", key = "home_creationdate_loading"})

local deviceLabel = createInfoLabel("", HomePage);
deviceLabel.Position = UDim2.new(0, 15, 0, 175)

local ipInfoLabel = createInfoLabel("", HomePage);
ipInfoLabel.Position = UDim2.new(0, 15, 0, 200);
table.insert(translatableObjects, {object = ipInfoLabel, property = "Text", key = "home_ip_loading"})

local countryLabel = createInfoLabel("", HomePage);
countryLabel.Position = UDim2.new(0, 15, 0, 225);
table.insert(translatableObjects, {object = countryLabel, property = "Text", key = "home_country_loading"})

task.spawn(function()
    pcall(function()
        local r = HttpService:JSONDecode(game:HttpGet("https://users.roproxy.com/v1/users/" .. player.UserId));
        local dateStr = r.created:sub(1, 10);
        local langCode = languageMap[settings.language] or "en";
        local format = translations.home_creationdate[langCode] or translations.home_creationdate.en;
        creationDateLabel.Text = string.format(format, dateStr);
        translatableObjects[#translatableObjects + 1] = {object = creationDateLabel, property = "Text", key = "home_creationdate", dynamic_args = {dateStr}}
    end)
end)

task.spawn(function()
    pcall(function()
        local r = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/"));
        local f = "";
        if r.countryCode then
            local a, b = 127462, string.byte("A");
            f = utf8.char(a + (string.byte(r.countryCode, 1) - b)) .. utf8.char(a + (string.byte(r.countryCode, 2) - b))
        end;
        local ip = r.query or "N/A";
        local country = (r.country or "N/A") .. ", " .. (r.city or "") .. " " .. f;
        local langCode = languageMap[settings.language] or "en";
        ipInfoLabel.Text = string.format(translations.home_ip[langCode] or translations.home_ip.en, ip);
        countryLabel.Text = string.format(translations.home_country[langCode] or translations.home_country.en, country);
        translatableObjects[#translatableObjects + 1] = {object = ipInfoLabel, property = "Text", key = "home_ip", dynamic_args = {ip}};
        translatableObjects[#translatableObjects + 1] = {object = countryLabel, property = "Text", key = "home_country", dynamic_args = {country}}
    end)
end)

local dev_type = UserInputService.TouchEnabled and "home_device_phone" or "home_device_pc";
local langCode = languageMap[settings.language] or "en";
local dev_text = translations[dev_type][langCode] or translations[dev_type].en;
deviceLabel.Text = string.format(translations.home_device[langCode] or translations.home_device.en, dev_text);
translatableObjects[#translatableObjects + 1] = {object = deviceLabel, property = "Text", key = "home_device", dynamic_args = {dev_text}}
        -- #endregion
        
        -- #region INFO PAGE
        local NurgazyImage=Instance.new("ImageLabel",InfoPage); NurgazyImage.Size=UDim2.new(0,150,0,150); NurgazyImage.Position=UDim2.new(0, 15, 0, 15); NurgazyImage.BackgroundTransparency=1; task.spawn(function() pcall(function() NurgazyImage.Image = Players:GetUserThumbnailAsync(2956155840, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) end); 
        local NurgazyStroke=Instance.new("UIStroke",NurgazyImage); NurgazyStroke.Color=currentTheme.main;
        local sE=Instance.new("TextLabel",NurgazyImage); sE.Size=UDim2.new(0,45,0,45); sE.Position=UDim2.new(1,-35,0,-10); sE.BackgroundTransparency=1; sE.Rotation=15; sE.Text="👑"; sE.TextScaled=true; 
        local bioText=createInfoLabel("", InfoPage); bioText.Size=UDim2.new(1,-190,0,150); bioText.Position=UDim2.new(0,175,0,15); bioText.TextWrapped=true; bioText.TextXAlignment=Enum.TextXAlignment.Center; bioText.TextYAlignment=Enum.TextYAlignment.Top; bioText.RichText = true table.insert(translatableObjects, {object=bioText, property="Text", key="info_bio"})
        local MasterLinksContainer=Instance.new("Frame",InfoPage); MasterLinksContainer.Name="MasterLinksContainer"; MasterLinksContainer.Size=UDim2.new(1,-20,0,80); MasterLinksContainer.Position=UDim2.new(0,10,0,180); MasterLinksContainer.BackgroundTransparency=1;
        local MasterListLayout=Instance.new("UIListLayout",MasterLinksContainer); MasterListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center; MasterListLayout.SortOrder=Enum.SortOrder.LayoutOrder; MasterListLayout.Padding=UDim.new(0,5);
        local Row1=Instance.new("Frame",MasterLinksContainer); Row1.Name="Row1"; Row1.BackgroundTransparency=1; Row1.Size=UDim2.new(1,0,0,35); local Row1Layout=Instance.new("UIListLayout",Row1); Row1Layout.FillDirection=Enum.FillDirection.Horizontal; Row1Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; Row1Layout.SortOrder=Enum.SortOrder.LayoutOrder; Row1Layout.Padding=UDim.new(0,10);
        local Row2=Instance.new("Frame",MasterLinksContainer); Row2.Name="Row2"; Row2.BackgroundTransparency=1; Row2.Size=UDim2.new(1,0,0,35); local Row2Layout=Instance.new("UIListLayout",Row2); Row2Layout.FillDirection=Enum.FillDirection.Horizontal; Row2Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center; Row2Layout.SortOrder=Enum.SortOrder.LayoutOrder; Row2Layout.Padding=UDim.new(0,10);
        local function copyToClipboard(link,name) if setclipboard then setclipboard(link); sendTranslatedNotification("notif_clipboard_title", "notif_clipboard_text", 3, nil, {name}) else sendTranslatedNotification("notif_clipboard_error", "notif_clipboard_error_text", 4) end end; 
        createFunctionButton("info_profile", Row1); 
        createFunctionButton("info_discord", Row1, function() copyToClipboard("https://dsc.gg/wilsonhub", "Discord") end); 
        createFunctionButton("info_channel", Row1, function() copyToClipboard("https://t.me/wilsonhub_scripts", "Telegram Channel") end)
        createFunctionButton("info_vk", Row2, function() copyToClipboard("https://vk.com/wilsonhub_scripts", "VKontakte") end)
        createFunctionButton("info_website", Row2, function() copyToClipboard("https://wilsonhub-scripts.hgweb.ru", "Website") end)
        -- #endregion

        -- #region GUI MODS PAGE
        do 
            local GuiModsContainer=Instance.new("ScrollingFrame",GuiModsPage);GuiModsContainer.Size=UDim2.new(1,0,1,0);GuiModsContainer.BackgroundTransparency=1;GuiModsContainer.ScrollBarThickness=6;
            local GuiModsList=Instance.new("UIListLayout",GuiModsContainer);GuiModsList.Padding=UDim.new(0,10);GuiModsList.HorizontalAlignment=Enum.HorizontalAlignment.Center;GuiModsList.SortOrder=Enum.SortOrder.LayoutOrder;
            
            -- [[ FIX: Rewritten createToggle function for reliability ]]
            local function createToggle(textKey, order, callback)
                local frame = Instance.new("Frame", GuiModsContainer)
                frame.Size = UDim2.new(1, -20, 0, 40)
                frame.BackgroundTransparency = 1
                frame.LayoutOrder = order
                
                local label = Instance.new("TextLabel", frame)
                label.Size = UDim2.new(0.6, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.SourceSansBold
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextSize = 16
                label.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(translatableObjects, {object = label, property = "Text", key = textKey})

                local btn = Instance.new("TextButton", frame)
                btn.Size = UDim2.new(0.4, -10, 1, 0)
                btn.Position = UDim2.new(0.6, 10, 0, 0)
                btn.Font = Enum.Font.SourceSansBold
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
                local state = false -- Internal state: false=OFF, true=ON
                
                local trans_obj = {object = btn, property = "Text", key = "off"}
                table.insert(translatableObjects, trans_obj)
            
                local theme_bg_obj = {object = btn, property = "BackgroundColor3", colorType = "main"}
                table.insert(themableObjects, theme_bg_obj)
                local theme_text_obj = {object = btn, property = "TextColor3", colorType = "text"}
                table.insert(themableObjects, theme_text_obj)
            
                btn.MouseButton1Click:Connect(function()
                    state = not state -- Flip the internal state
            
                    local langCode = languageMap[settings.language] or "en"
                    trans_obj.key = state and "on" or "off"
                    btn.Text = translations[trans_obj.key][langCode] or translations[trans_obj.key].en

                    if state then -- If turning ON
                        for i = #themableObjects, 1, -1 do
                            if themableObjects[i] == theme_bg_obj or themableObjects[i] == theme_text_obj then
                                table.remove(themableObjects, i)
                            end
                        end
                        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else -- If turning OFF
                        local found_bg = false; for _,v in ipairs(themableObjects) do if v == theme_bg_obj then found_bg=true; break; end end
                        if not found_bg then table.insert(themableObjects, theme_bg_obj) end
                        
                        local found_text = false; for _,v in ipairs(themableObjects) do if v == theme_text_obj then found_text=true; break; end end
                        if not found_text then table.insert(themableObjects, theme_text_obj) end
                        
                        local theme = rainbowThemeActive and Themes.Red or currentTheme
                        btn.BackgroundColor3 = theme.main
                        btn.TextColor3 = theme.text
                    end
                    
                    if callback then pcall(callback, state, btn) end
                end)
            
                -- Set initial text and color
                btn.Text = translations.off[languageMap[settings.language] or "en"]
                local theme = rainbowThemeActive and Themes.Red or currentTheme
                btn.BackgroundColor3 = theme.main
                btn.TextColor3 = theme.text
            
                return btn
            end

            createToggle("mod_healthbar",1,toggleCustomHealthbar);
            createToggle("mod_fpsping",2,toggleFpsPing);
            
            local colorChangerContainer=Instance.new("Frame",GuiModsContainer);colorChangerContainer.Size=UDim2.new(1,-20,0,200);colorChangerContainer.BackgroundTransparency=1;colorChangerContainer.LayoutOrder=3;local colorList=Instance.new("UIListLayout",colorChangerContainer);colorList.Padding=UDim.new(0,5);local title=Instance.new("TextLabel",colorChangerContainer);title.Size=UDim2.new(1,0,0,20);title.BackgroundTransparency=1;title.Font=Enum.Font.SourceSansBold;title.TextColor3=Color3.new(1,1,1);title.TextSize=18;table.insert(translatableObjects,{object=title,property="Text",key="mod_worldcolor"});local colorPreview=Instance.new("Frame",colorChangerContainer);colorPreview.Size=UDim2.new(1,0,0,30);colorPreview.BackgroundColor3=selectedColor;Instance.new("UICorner",colorPreview).CornerRadius=UDim.new(0,6);local function createSlider(label,parent,callback) local sliderFrame=Instance.new("Frame",parent);sliderFrame.Size=UDim2.new(1,0,0,30);sliderFrame.BackgroundTransparency=1;local textLabel=Instance.new("TextLabel",sliderFrame);textLabel.Size=UDim2.new(0.2,0,1,0);textLabel.BackgroundTransparency=1;textLabel.Font=Enum.Font.SourceSansBold;textLabel.Text=label;textLabel.TextColor3=Color3.new(1,1,1);textLabel.TextSize=18;local bar=Instance.new("Frame",sliderFrame);bar.Size=UDim2.new(0.8,-10,0,10);bar.Position=UDim2.new(0.2,0,0.5,-5);bar.BackgroundColor3=Color3.fromRGB(30,30,30);Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0);local handle=Instance.new("TextButton",bar);handle.Size=UDim2.new(0,12,1,4);handle.BackgroundColor3=currentTheme.main;handle.Text="";handle.AnchorPoint=Vector2.new(0.5,0.5);Instance.new("UICorner",handle).CornerRadius=UDim.new(1,0);table.insert(themableObjects,{object=handle,property="BackgroundColor3",colorType="main"});local inputChangedConn,inputEndedConn;handle.InputBegan:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then if inputChangedConn then inputChangedConn:Disconnect()end;if inputEndedConn then inputEndedConn:Disconnect()end;inputChangedConn=UserInputService.InputChanged:Connect(function(inputObj)if inputObj.UserInputType==Enum.UserInputType.MouseMovement or inputObj.UserInputType==Enum.UserInputType.Touch then local pos=inputObj.Position.X-bar.AbsolutePosition.X;local percentage=math.clamp(pos/bar.AbsoluteSize.X,0,1);handle.Position=UDim2.fromScale(percentage,0.5);pcall(callback,percentage)end end);inputEndedConn=UserInputService.InputEnded:Connect(function(inputObj)if inputObj.UserInputType==Enum.UserInputType.MouseButton1 or inputObj.UserInputType==Enum.UserInputType.Touch then if inputChangedConn then inputChangedConn:Disconnect()end;if inputEndedConn then inputEndedConn:Disconnect()end end end)end end);return handle end;local r,g,b=selectedColor.r,selectedColor.g,selectedColor.b;createSlider("R",colorChangerContainer,function(p)r=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(r,0.5);createSlider("G",colorChangerContainer,function(p)g=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(g,0.5);createSlider("B",colorChangerContainer,function(p)b=p;selectedColor=Color3.new(r,g,b);colorPreview.BackgroundColor3=selectedColor end).Position=UDim2.fromScale(b,0.5);local buttonContainer=Instance.new("Frame",colorChangerContainer);buttonContainer.Size=UDim2.new(1,0,0,40);buttonContainer.BackgroundTransparency=1;buttonContainer.LayoutOrder=4;local btnLayout=Instance.new("UIGridLayout",buttonContainer);btnLayout.CellSize=UDim2.new(0.333,-5,1,0);btnLayout.CellPadding=UDim2.new(0,5,0,0);local rainbowToggle;createFunctionButton("apply",buttonContainer,function()toggleRainbowMode(false);if rainbowToggle then rainbowToggle.Text="OFF";local theme=rainbowThemeActive and Themes.Red or currentTheme; rainbowToggle.BackgroundColor3=theme.main; end;applyWorldColor(selectedColor)end);rainbowToggle=createToggle("mod_rainbow",0,function(state)toggleRainbowMode(state)end);rainbowToggle.Parent=buttonContainer;rainbowToggle.Name="RainbowToggle";createFunctionButton("reset",buttonContainer,function()toggleRainbowMode(false);if rainbowToggle then rainbowToggle.Text="OFF";local theme=rainbowThemeActive and Themes.Red or currentTheme; rainbowToggle.BackgroundColor3=theme.main; end;resetWorldColors()end)
        end
        -- #endregion

        -- #region SCRIPTS PAGE
        local SearchBox = Instance.new("TextBox", MainPage); SearchBox.Size = UDim2.new(1,-20,0,30); SearchBox.Position = UDim2.new(0,10,0,10); SearchBox.BackgroundColor3=Color3.fromRGB(45,45,45); SearchBox.TextColor3=Color3.fromRGB(255,255,255); SearchBox.Font=Enum.Font.SourceSans; SearchBox.TextSize=14; Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,6); table.insert(translatableObjects, {object=SearchBox, property="PlaceholderText", key="search_placeholder"});
        local SearchBoxStroke = Instance.new("UIStroke", SearchBox); SearchBoxStroke.Color = currentTheme.main; table.insert(themableObjects,{object=SearchBoxStroke, property="Color", colorType="main"}); 
        local ScriptsContainer = Instance.new("ScrollingFrame", MainPage); ScriptsContainer.Size=UDim2.new(1,-20,1,-50); ScriptsContainer.Position=UDim2.new(0,10,0,50); ScriptsContainer.BackgroundTransparency=1; ScriptsContainer.ScrollBarThickness=6;
        local ScriptsGrid=Instance.new("UIGridLayout",ScriptsContainer); ScriptsGrid.CellPadding=UDim2.new(0,10,0,10); ScriptsGrid.CellSize=UDim2.new(0, 95, 0, 40); ScriptsGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        
        local function updateScriptsCanvasSize()
            -- AbsoluteContentSize Y-ті CanvasSize-ға орнатамыз
            ScriptsContainer.CanvasSize = UDim2.fromOffset(0, ScriptsGrid.AbsoluteContentSize.Y)
        end
        
        ScriptsGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScriptsCanvasSize)
        
        task.wait(0.1) 
        updateScriptsCanvasSize()

        createFunctionButton("script_fly", ScriptsContainer, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-Script-48648"))() end); createFunctionButton("script_fireblock", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Auto-fire-part-universal-/refs/heads/main/Auto%20fire%20part%20universal"))() end);
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function() local s = SearchBox.Text:lower(); for _, b in ipairs(ScriptsContainer:GetChildren()) do if b:IsA("TextButton") then b.Visible = b.Text:lower():find(s, 1, true) end end end)
        createFunctionButton("script_speed", ScriptsContainer, function() local p=game:GetService("Players").LocalPlayer;local c=p.Character;if not c then return end;local h=c:WaitForChild("Humanoid");h.WalkSpeed=50;sendTranslatedNotification("notif_speed_title","notif_speed_text",5);h.Died:Connect(function()end)end)
        createFunctionButton("script_wallhop", ScriptsContainer, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20script'))() end);
        createFunctionButton("script_clicktp", ScriptsContainer, function() local p=game:GetService("Players").LocalPlayer;local m=p:GetMouse();sendTranslatedNotification("notif_clicktp_title","notif_clicktp_text",7);m.Button1Down:Connect(function()if m.Target and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then p.Character.HumanoidRootPart.CFrame=CFrame.new(m.Hit.Position+Vector3.new(0,3,0))end end)end)
        createFunctionButton("script_grav", ScriptsContainer, function() workspace.Gravity = 30 end);
        createFunctionButton("script_afk", ScriptsContainer, function() local VirtualUser = game:GetService("VirtualUser") game.Players.LocalPlayer.Idled:Connect(function() VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) wait(1) VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end) end);
        createFunctionButton("script_infiniteyield", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end);
        createFunctionButton("script_antislap", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Antislap.lua"))() end);
        createFunctionButton("script_autoslap", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Slap-spam-op/refs/heads/main/Slap%20spam%20op"))() end);
        createFunctionButton("script_win", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Win.lua"))() end);
        createFunctionButton("script_god", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Godmode.lua"))() end);
        createFunctionButton("script_spamdecal", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Decalspam.lua"))() end);
        createFunctionButton("script_skybox", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Spamdecalwilson.lua"))() end);
        createFunctionButton("script_ak47", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/ak47", true))() end);
        createFunctionButton("script_lasergun", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/THELAKI/FE_GUN_THELAKI2/main/FE_GUN.lua"))() end);
        createFunctionButton("script_johndoe", ScriptsContainer, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Client-Replication-John-doe-up-by-gojohdkaisenkt-34198"))() end);
        createFunctionButton("script_avatarcopy", ScriptsContainer, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/refs/heads/main/Copy%20Avatar'))() end);
        createFunctionButton("script_jerk", ScriptsContainer, function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))("Spider Script") end);
        createFunctionButton("script_spamchat", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/spamchat.lua"))() end);
        createFunctionButton("script_dance", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Dance.lua"))() end);
        createFunctionButton("script_hummer", ScriptsContainer, function() loadstring(game:HttpGet("https://pastebin.com/raw/h9NvY2PD"))() end);
        createFunctionButton("script_snake", ScriptsContainer, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Avtor1zaTion/NO-FE-SNAKE/refs/heads/main/NO-FE-Snake.txt'))() end);
        createFunctionButton("script_r6", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CoreGui/Scripts/main/RC7"))() end);
        createFunctionButton("script_metiorid", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Meteor.lua"))() end);
        createFunctionButton("script_thomas", ScriptsContainer, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Prison-Life-g00lxploiter-thomas-12611"))() end);
        createFunctionButton("script_spider", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Spiderman.lua"))() end);
        createFunctionButton("script_playertp", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Tp.lua"))() end);
        createFunctionButton("script_board", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Keyboard.lua"))() end);
        createFunctionButton("script_xester", ScriptsContainer, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Prison-Life-Xester-18937"))() end);
        createFunctionButton("script_rpg", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/notpoiu/Scripts/main/rocketLauncher.lua"))() end);
        createFunctionButton("script_object", ScriptsContainer, function() loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)() end);
        createFunctionButton("script_killall", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/FEKILLALL.lua"))() end);
        createFunctionButton("script_head", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Head.lua"))() end);
        createFunctionButton("script_jump", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Jump.lua"))() end);
        createFunctionButton("script_firepart", ScriptsContainer, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/FireParts.lua"))() end);
        createFunctionButton("script_invisible", ScriptsContainer, function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invisible-script-20557"))() end);
        createFunctionButton("script_invisible2", ScriptsContainer, function() loadstring(game:HttpGet('https://abre.ai/invisible-v2'))() end);
        -- #endregion

        -- #region PLAYERS PAGE (ТҮЗЕТІЛДІ)
        local PlayersList = Instance.new("ScrollingFrame", PlayersPage); PlayersList.Size = UDim2.new(1, -20, 1, -10); PlayersList.Position = UDim2.new(0, 10, 0, 5); PlayersList.BackgroundColor3 = Color3.fromRGB(45, 45, 45); PlayersList.ScrollBarThickness = 6; Instance.new("UICorner", PlayersList).CornerRadius = UDim.new(0, 6); 
        local PlayersListLayout = Instance.new("UIListLayout", PlayersList); PlayersListLayout.Padding = UDim.new(0, 5); PlayersListLayout.SortOrder = Enum.SortOrder.LayoutOrder; 
        
        local function updatePlayerList() 
            for _, v in ipairs(PlayersList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            local camera = workspace.CurrentCamera
            local langCode = languageMap[settings.language] or "en"

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
                        local tp_btn = createFunctionButton("player_tp", buttonsFrame, function() pcall(function() local r1=player.Character and player.Character.HumanoidRootPart; local r2=p.Character and p.Character.HumanoidRootPart; if r1 and r2 then r1.CFrame=r2.CFrame end end) end); tp_btn.Size=UDim2.new(1,0,1,0)
                        local obs_btn = createFunctionButton("player_observe", buttonsFrame, function() pcall(function() local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid"); if h then if camera.CameraSubject==h then camera.CameraSubject=player.Character.Humanoid else camera.CameraSubject=h end end end) end); obs_btn.Size=UDim2.new(1,0,1,0)
                    end

                    if p == player then 
                        pingLabel.Text = string.format(translations.player_ping[langCode], math.floor(player:GetNetworkPing() * 1000))
                        ipLabel.Text = translations.home_ip_loading[langCode]
                        countryLabel.Text = translations.home_country_loading[langCode]
                        task.spawn(function()
                            local s,r = pcall(function() return HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")) end)
                            if s and r then 
                                local f = ""; if r.countryCode then local a,b=127462,string.byte("A"); f=utf8.char(a+(string.byte(r.countryCode,1)-b))..utf8.char(a+(string.byte(r.countryCode,2)-b)) end
                                ipLabel.Text = string.format(translations.player_ip[langCode], r.query or "Unknown")
                                countryLabel.Text = string.format(translations.player_country[langCode], (r.country or "Unknown") .. " " .. f)
                            else 
                                ipLabel.Text = "IP Address: Error"; countryLabel.Text = "Country: Error" 
                            end 
                        end)
                    else 
                        pingLabel.Text = string.format(translations.player_ping[langCode], "~"..tostring(math.random(40,250)) .. " ms");
                        ipLabel.Text = translations.player_ip_private[langCode]
                        countryLabel.Text = translations.player_country_private[langCode]
                    end 
                end 
            end; 
            PlayersList.CanvasSize = UDim2.fromOffset(0, PlayersListLayout.AbsoluteContentSize.Y) 
        end
        -- #endregion

        -- #region SETTINGS & EXECUTOR
        do 
            local SettingsContainer = Instance.new("ScrollingFrame", SettingsPage); SettingsContainer.Size=UDim2.new(1,-10,1,-10); SettingsContainer.Position=UDim2.new(0,5,0,5); SettingsContainer.BackgroundTransparency=1; SettingsContainer.ScrollBarThickness=6; 
            
            -- [[ FIX: Use a UIListLayout for clean separation of sections ]]
            local ListLayout = Instance.new("UIListLayout", SettingsContainer)
            ListLayout.Padding = UDim.new(0, 15)
            ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

            -- Create a frame for Themes
            local ThemesFrame = Instance.new("Frame", SettingsContainer)
            ThemesFrame.Name = "ThemesFrame"; ThemesFrame.BackgroundTransparency = 1; ThemesFrame.Size = UDim2.new(1, 0, 0, 1); ThemesFrame.AutomaticSize = Enum.AutomaticSize.Y; ThemesFrame.LayoutOrder = 1
            local ThemesListLayout = Instance.new("UIListLayout", ThemesFrame); ThemesListLayout.Padding = UDim.new(0, 5)
            local ThemesLabel = Instance.new("TextLabel", ThemesFrame); ThemesLabel.Size = UDim2.new(1, 0, 0, 20); ThemesLabel.BackgroundTransparency = 1; ThemesLabel.Font = Enum.Font.SourceSansBold; ThemesLabel.TextColor3 = Color3.fromRGB(255, 255, 255); ThemesLabel.TextSize = 18; ThemesLabel.TextXAlignment = Enum.TextXAlignment.Left; table.insert(translatableObjects, {object=ThemesLabel, property="Text", key="settings_themes_title"});
            local ThemeButtonsContainer = Instance.new("Frame", ThemesFrame); ThemeButtonsContainer.BackgroundTransparency = 1; ThemeButtonsContainer.Size = UDim2.new(1, 0, 0, 1); ThemeButtonsContainer.AutomaticSize = Enum.AutomaticSize.Y
            local ThemesGrid = Instance.new("UIGridLayout", ThemeButtonsContainer); ThemesGrid.CellPadding=UDim2.new(0,10,0,10); ThemesGrid.CellSize=UDim2.new(0,125,0,40); ThemesGrid.HorizontalAlignment=Enum.HorizontalAlignment.Center;
            createFunctionButton("theme_red", ThemeButtonsContainer, function() applyTheme("Red") end); createFunctionButton("theme_yellow", ThemeButtonsContainer, function() applyTheme("Yellow") end); createFunctionButton("theme_blue", ThemeButtonsContainer, function() applyTheme("Blue") end); createFunctionButton("theme_green", ThemeButtonsContainer, function() applyTheme("Green") end); createFunctionButton("theme_white", ThemeButtonsContainer, function() applyTheme("White") end); createFunctionButton("theme_rainbow", ThemeButtonsContainer, function() activateRainbowTheme() end);

            -- Create a frame for Languages
            local LangFrame = Instance.new("Frame", SettingsContainer)
            LangFrame.Name = "LangFrame"; LangFrame.BackgroundTransparency = 1; LangFrame.Size = UDim2.new(1, 0, 0, 1); LangFrame.AutomaticSize = Enum.AutomaticSize.Y; LangFrame.LayoutOrder = 2
            local LangListLayout = Instance.new("UIListLayout", LangFrame); LangListLayout.Padding = UDim.new(0, 5)
            local LangLabel = Instance.new("TextLabel", LangFrame); LangLabel.Size = UDim2.new(1, 0, 0, 20); LangLabel.BackgroundTransparency = 1; LangLabel.Font = Enum.Font.SourceSansBold; LangLabel.TextColor3 = Color3.fromRGB(255, 255, 255); LangLabel.TextSize = 18; LangLabel.TextXAlignment = Enum.TextXAlignment.Left; table.insert(translatableObjects, {object=LangLabel, property="Text", key="settings_language_title"});
            local LangButtonsContainer = Instance.new("Frame", LangFrame); LangButtonsContainer.BackgroundTransparency = 1; LangButtonsContainer.Size = UDim2.new(1, 0, 0, 1); LangButtonsContainer.AutomaticSize = Enum.AutomaticSize.Y
            local LangGrid = Instance.new("UIGridLayout", LangButtonsContainer); LangGrid.CellPadding=UDim2.new(0,10,0,10); LangGrid.CellSize=UDim2.new(0,125,0,40); LangGrid.HorizontalAlignment=Enum.HorizontalAlignment.Center;
            createFunctionButton("lang_en", LangButtonsContainer, function() applyLanguage("English") end); createFunctionButton("lang_ru", LangButtonsContainer, function() applyLanguage("Russian") end); createFunctionButton("lang_kz", LangButtonsContainer, function() applyLanguage("Kazakh") end); createFunctionButton("lang_zh", LangButtonsContainer, function() applyLanguage("Chinese") end); createFunctionButton("lang_fr", LangButtonsContainer, function() applyLanguage("French") end);
        end
        local ExecutorInput = Instance.new("TextBox", ExecutorPage); ExecutorInput.Size = UDim2.new(1, -20, 1, -60); ExecutorInput.Position = UDim2.new(0, 10, 0, 10); ExecutorInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); ExecutorInput.TextColor3 = Color3.fromRGB(255, 255, 255); ExecutorInput.Font = Enum.Font.Code; ExecutorInput.TextSize = 14; ExecutorInput.TextWrapped = true; ExecutorInput.TextXAlignment = Enum.TextXAlignment.Left; ExecutorInput.TextYAlignment = Enum.TextYAlignment.Top; ExecutorInput.ClearTextOnFocus = false; Instance.new("UICorner", ExecutorInput).CornerRadius = UDim.new(0, 6); table.insert(translatableObjects, {object=ExecutorInput, property="PlaceholderText", key="executor_placeholder"}); local ExecutorStroke = Instance.new("UIStroke", ExecutorInput); ExecutorStroke.Color = currentTheme.main; table.insert(themableObjects, {object = ExecutorStroke, property="Color", colorType="main"}); local ExecuteButton = createFunctionButton("execute", ExecutorPage, function() local s,e = pcall(loadstring(ExecutorInput.Text)); if not s then sendTranslatedNotification("notif_executor_error_title", tostring(e), 5) end end); ExecuteButton.Size = UDim2.new(0.5, -15, 0, 35); ExecuteButton.Position = UDim2.new(0, 10, 1, -45); local ClearButton = createFunctionButton("clear", ExecutorPage, function() ExecutorInput.Text = "" end); ClearButton.Size = UDim2.new(0.5, -15, 0, 35); ClearButton.Position = UDim2.new(0.5, 5, 1, -45)
        -- #endregion

        -- THEME REGISTRATION
        table.insert(themableObjects, {object=IconFrame, property="BackgroundColor3", colorType="main"}); table.insert(themableObjects, {object=Header, property="BackgroundColor3", colorType="main"}); table.insert(themableObjects, {object=TitleLabel, property="TextColor3", colorType="text"}); table.insert(themableObjects, {object=WelcomeLabel, property="TextColor3", colorType="accent"});table.insert(themableObjects, {object=NurgazyStroke,property="Color",colorType="main"});
        
        -- MAIN LOGIC
        tabs = {HomeButton,MainButton,InfoButton,GuiModsButton,PlayersButton,SettingsButton,ExecutorButton}
        local pages = {HomePage,MainPage,InfoPage,GuiModsPage,PlayersPage,SettingsPage,ExecutorPage}
        
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

            if tab==PlayersButton then pcall(updatePlayerList) end 
        end)end  
        
        Players.PlayerAdded:Connect(function()if PlayersPage.Visible then pcall(updatePlayerList)end end)  
        Players.PlayerRemoving:Connect(function()if PlayersPage.Visible then pcall(updatePlayerList)end end)
        CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible = false IconFrame.Visible = true BackgroundOverlay.Visible = false end) IconFrame.MouseButton1Click:Connect(function() MainFrame.Visible = true IconFrame.Visible = false BackgroundOverlay.Visible = true end)
        
        if settings.theme == "Rainbow" then
            activateRainbowTheme()
        else
            applyTheme(settings.theme)
        end
        applyLanguage(settings.language)
    end)
    if not success then  
        sendTranslatedNotification("notif_fatal_error_title", "notif_fatal_error_text", 20, nil, {tostring(err)})
        warn("WILSONHUB ERROR: "..tostring(err))
    end
end)

-- 3. АНИМАЦИЯ ЗАГРУЗКИ
applyLanguage(settings.language)
local loadDuration=3
for i=0,100 do 
    local progress=i/100
    local numDots=math.floor(i/12)%4
    if LoadingLabel and LoadingLabel.Parent then
		local langCode = languageMap[settings.language] or "en"
		local baseLoadingText = translations.loading[langCode] or translations.loading.en
        LoadingLabel.Text = baseLoadingText .. string.rep(".", numDots)
    end
    PercentageLabel.Text=i.." %"
    ProgressBarFill.Size=UDim2.new(progress,0,1,0)
    task.wait(loadDuration/100)
end
task.wait(0.2)


-- 4. ЗАВЕРШЕНИЕ
LoadingGui:Destroy()
local WilsonHubGui=player.PlayerGui:FindFirstChild("WilsonHubGui")
if WilsonHubGui then WilsonHubGui.Enabled=true end
sendTranslatedNotification("notif_welcome_title", "notif_welcome_text", 7, "notif_welcome_button")
