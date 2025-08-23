-- Visual Big Head for Everyone (GUI version)

local Players = game:GetService("Players")

-- функция: бір ойыншының басын үлкейту
local function makeBigHead(plr)
    if plr.Character then
        local head = plr.Character:FindFirstChild("Head")
        if head then
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(5,5,5)
            else
                local newMesh = Instance.new("SpecialMesh", head)
                newMesh.Scale = Vector3.new(5,5,5)
            end
        end
    end
end

-- функция: бір ойыншының басын қалпына келтіру
local function resetHead(plr)
    if plr.Character then
        local head = plr.Character:FindFirstChild("Head")
        if head then
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(1,1,1)
            end
        end
    end
end

-- барлық ойыншыларға қолдану
local function makeAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        makeBigHead(plr)
    end
end

local function resetAll()
    for _, plr in ipairs(Players:GetPlayers()) do
        resetHead(plr)
    end
end

-- кейін кіргендерге де қолдану
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        makeBigHead(plr)
    end)
end)

-- GUI ------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BigHeadGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0.5, -120, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(240,240,240)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 6
stroke.Color = Color3.new(0,0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "😆 Big Head"
title.TextColor3 = Color3.new(0,0,0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- кнопка жасау функциясы
local function makeBtn(text, posY, callback, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8,0,0,35)
    btn.Position = UDim2.new(0.1,0,0,posY)
    btn.BackgroundColor3 = color or Color3.fromRGB(30,144,255)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true

    local bcorner = Instance.new("UICorner", btn)
    bcorner.CornerRadius = UDim.new(0,10)

    btn.MouseButton1Click:Connect(callback)
end

-- кнопкалар
makeBtn("Make All Big Head", 40, makeAll, Color3.fromRGB(0,200,0))
makeBtn("Reset All Heads",   85, resetAll, Color3.fromRGB(200,0,0))
