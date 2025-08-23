local p = game.Players.LocalPlayer
local Tool = Instance.new("Tool")
Tool.Name = "Fire Parts"
Tool.RequiresHandle = false

local function keepToolEnabled()
    if not p.Backpack:FindFirstChild("Fire Parts") then
        Tool.Parent = p.Backpack
    end

    Tool.Parent = p.Backpack
    Tool.Activated:Connect(function()
        local mouse = p:GetMouse()
        local target = mouse.Target
        if target and target:IsA("Part") then
            local touchInterest = target:FindFirstChildOfClass("TouchTransmitter")
            
            if touchInterest then
                firetouchinterest(p.Character.PrimaryPart, target, 0)
                firetouchinterest(p.Character.PrimaryPart, target, 1)
            end
        end
    end)
end

p.CharacterAdded:Connect(function()
    task.wait(0.1)
    keepToolEnabled()
end)

keepToolEnabled()
