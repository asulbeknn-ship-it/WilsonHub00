local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function CreateGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AttachGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 220, 0, 140)
    frame.Position = UDim2.new(0.4, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.Active = true
    frame.Draggable = true

    local textbox = Instance.new("TextBox", frame)
    textbox.Size = UDim2.new(1, -20, 0, 30)
    textbox.Position = UDim2.new(0,10,0,10)
    textbox.PlaceholderText = "Player Name"
    textbox.Text = ""
    textbox.ClearTextOnFocus = false
    textbox.BackgroundColor3 = Color3.fromRGB(45,45,45)
    textbox.TextColor3 = Color3.new(1,1,1)

    textbox.FocusLost:Connect(function()
        local input = textbox.Text:lower()
        if input ~= "" then
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr.Name:lower():sub(1,#input) == input then
                    textbox.Text = plr.Name
                    break
                end
            end
        end
    end)

    local onButton = Instance.new("TextButton", frame)
    onButton.Size = UDim2.new(0.45, 0, 0, 30)
    onButton.Position = UDim2.new(0.05, 0, 0, 50)
    onButton.Text = "ON"
    onButton.BackgroundColor3 = Color3.fromRGB(0,200,0)
    onButton.TextColor3 = Color3.new(1,1,1)

    local offButton = Instance.new("TextButton", frame)
    offButton.Size = UDim2.new(0.45, 0, 0, 30)
    offButton.Position = UDim2.new(0.5, 0, 0, 50)
    offButton.Text = "OFF"
    offButton.BackgroundColor3 = Color3.fromRGB(200,0,0)
    offButton.TextColor3 = Color3.new(1,1,1)

    local closeButton = Instance.new("TextButton", frame)
    closeButton.Size = UDim2.new(0,25,0,25)
    closeButton.Position = UDim2.new(1,-30,0,5)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    closeButton.TextColor3 = Color3.new(1,1,1)

    local iconButton = Instance.new("TextButton", screenGui)
    iconButton.Size = UDim2.new(0,40,0,40)
    iconButton.Position = UDim2.new(0.9,0,0.1,0)
    iconButton.BackgroundColor3 = Color3.fromRGB(50,100,200)
    iconButton.Text = "☰"
    iconButton.Visible = false
    iconButton.Active = true
    iconButton.Draggable = true

    local attached = false
    local targetPlayer = nil
    local loopConnection

    onButton.MouseButton1Click:Connect(function()
        local input = textbox.Text:lower()
        local found = nil

        if input ~= "" then
            for _,plr in ipairs(Players:GetPlayers()) do
                if string.find(plr.Name:lower(), input) then
                    found = plr
                    break
                end
            end
        end

        if found then
            targetPlayer = found
            attached = true

            if loopConnection then
                loopConnection:Disconnect()
            end

            loopConnection = RunService.RenderStepped:Connect(function()
                if attached and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        -- Артынан жабысып жүру (Z артқа 2 бірлік)
                        local targetCF = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1)
                        myChar:PivotTo(targetCF)
                    end
                end
            end)
        end
    end)

    offButton.MouseButton1Click:Connect(function()
        attached = false
        targetPlayer = nil
        if loopConnection then
            loopConnection:Disconnect()
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        frame.Visible = false
        iconButton.Visible = true
    end)

    iconButton.MouseButton1Click:Connect(function()
        frame.Visible = true
        iconButton.Visible = false
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if not LocalPlayer.PlayerGui:FindFirstChild("AttachGui") then
        CreateGUI()
    end
end)

CreateGUI()
