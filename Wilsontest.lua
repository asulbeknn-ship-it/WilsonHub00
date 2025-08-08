-- Этот script создан с хакером Hacker_Wilson00

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- ScreenGui
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "WilsonHubMenu"

-- Domalaq fiolet icon
local icon = Instance.new("Frame", gui)
icon.Name = "WilsonIcon"
icon.Size = UDim2.new(0, 72, 0, 72)
icon.Position = UDim2.new(0, 30, 0, 120)
icon.BackgroundColor3 = Color3.fromRGB(130, 0, 255)
icon.BackgroundTransparency = 0
icon.BorderSizePixel = 0
icon.Active = true

-- Domalaq форма беру
local uicorner = Instance.new("UICorner", icon)
uicorner.CornerRadius = UDim.new(1,0)

-- Найзағай (⚡️) белгісі
local thunder = Instance.new("TextLabel", icon)
thunder.Size = UDim2.new(1, 0, 0.45, 0)
thunder.Position = UDim2.new(0, 0, 0.07, 0)
thunder.BackgroundTransparency = 1
thunder.Text = "⚡️"
thunder.TextColor3 = Color3.new(1,1,0.2)
thunder.Font = Enum.Font.Arcade
thunder.TextScaled = true

-- WILSONHUB жазуы
local hubText = Instance.new("TextLabel", icon)
hubText.Size = UDim2.new(1, 0, 0.35, 0)
hubText.Position = UDim2.new(0, 0, 0.55, 0)
hubText.BackgroundTransparency = 1
hubText.Text = "WILSONHUB"
hubText.TextColor3 = Color3.fromRGB(255,255,255)
hubText.Font = Enum.Font.SourceSansBold
hubText.TextScaled = true

-- Иконканы жылжыту
icon.Active = true
icon.Draggable = true

-- Ашылатын меню (қызық түс)
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 320, 0, 400)
menu.Position = UDim2.new(0, 120, 0, 80)
menu.BackgroundColor3 = Color3.fromRGB(255, 92, 172) -- Қызық түс (қызғылт)
menu.Visible = false
menu.Active = true
menu.Draggable = true

local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0.12,0)

-- Title
local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 48)
title.BackgroundTransparency = 1
title.Text = "Этот script создан с хакером Hacker_Wilson00"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Fire Block кнопка
local fireBtn = Instance.new("TextButton", menu)
fireBtn.Text = "Fire Block FE: OFF"
fireBtn.Size = UDim2.new(1, -40, 0, 50)
fireBtn.Position = UDim2.new(0, 20, 0, 60)
fireBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
fireBtn.TextColor3 = Color3.new(1,1,1)
fireBtn.Font = Enum.Font.SourceSans
fireBtn.TextSize = 18

-- Fly кнопка
local flyBtn = Instance.new("TextButton", menu)
flyBtn.Text = "Fly: OFF"
flyBtn.Size = UDim2.new(1, -40, 0, 50)
flyBtn.Position = UDim2.new(0, 20, 0, 130)
flyBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.SourceSans
flyBtn.TextSize = 18

-- Ашып-жабу логикасы
icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        menu.Visible = not menu.Visible
    end
end)

-- Fire Block FE логикасы (өзінен-өзі жоғалып тұратын блок)
local fireEnabled = false
local fireBlock

local function spawnGhostBlock()
    while fireEnabled do
        if fireBlock then fireBlock:Destroy() end
        fireBlock = Instance.new("Part", workspace)
        fireBlock.Size = Vector3.new(4,1,4)
        fireBlock.Position = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, -3, 0) or Vector3.new(0,0,0)
        fireBlock.Anchored = true
        fireBlock.Name = "GhostBlock"
        fireBlock.BrickColor = BrickColor.new("Royal purple")
        fireBlock.Transparency = 0.2
        fireBlock.CanCollide = true
        wait(1)
        if fireBlock then fireBlock:Destroy() end
    end
    if fireBlock then fireBlock:Destroy() end
end

fireBtn.MouseButton1Click:Connect(function()
    fireEnabled = not fireEnabled
    fireBtn.Text = "Fire Block FE: " .. (fireEnabled and "ON" or "OFF")
    if fireEnabled then
        spawnGhostBlock()
    else
        if fireBlock then fireBlock:Destroy() end
    end
end)

-- Fly функциясы
local flyEnabled = false
local flySpeed = 60
local flyConn

local function flyFunc()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    flyConn = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Space then
            if flyEnabled then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, flySpeed, hrp.Velocity.Z)
            end
        end
    end)
    while flyEnabled and char and char:FindFirstChild("HumanoidRootPart") do
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
        wait()
    end
    if flyConn then flyConn:Disconnect() end
end

flyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyBtn.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    if flyEnabled then
        flyFunc()
    elseif flyConn then
        flyConn:Disconnect()
    end
end)

-- Скрипт дайын! Домалақ иконка, найзағай, "WILSONHUB" жазуы, ерекше түсті меню, барлық функциялар бар.
