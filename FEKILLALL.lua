local ScreenGui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local label = Instance.new("TextLabel")
local Hitbox = Instance.new("TextButton")
local UICorner = Instance.new("UICorner") -- Дөңгеленген бұрыш үшін

ScreenGui.Parent = game.CoreGui

main.Name = "main"
main.Parent = ScreenGui
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.Position = UDim2.new(0.4, 0, 0.35, 0)
main.Size = UDim2.new(0, 200, 0, 120)
main.Active = true
main.Draggable = true

-- бұрыштарды дөңгелету
UICorner.CornerRadius = UDim.new(0, 15) -- қаншалықты дөңгелек болатынын осымен өзгертесің
UICorner.Parent = main

label.Name = "label"
label.Parent = main
label.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
label.Size = UDim2.new(0, 200, 0, 30)
label.Font = Enum.Font.SourceSansBold
label.Text = "KILL ALL BY WILSON"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.TextWrapped = true

Hitbox.Name = "Hit box"
Hitbox.Parent = main
Hitbox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Hitbox.Position = UDim2.new(0.1, 0, 0.4, 0)
Hitbox.Size = UDim2.new(0, 160, 0, 50)
Hitbox.Font = Enum.Font.SourceSansBold
Hitbox.Text = "KILL ALL"
Hitbox.TextColor3 = Color3.fromRGB(255, 255, 255)
Hitbox.TextSize = 18

Hitbox.MouseButton1Down:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/asulbeknn-ship-it/WilsonHub00/main/Killall.lua"))()
end)
