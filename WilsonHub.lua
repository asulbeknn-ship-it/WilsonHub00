-- [[ МУЗЫКАНЫ БАСҚАРУ ЖҮЙЕСІ (ТЕК HOME БЕТІНДЕ) ]]
-- Бастапқы айнымалылар
local soundId = "72089843969979"
local playbackSpeed = 0.19
local soundVolume = 6
local soundOnIcon = "rbxassetid://96768815002144" -- Музыка қосулы иконкасы
local soundOffIcon = "rbxassetid://125331517259500" -- Музыка өшірулі иконкасы

-- Музыканы құру
local audio = Instance.new("Sound", game.SoundService)
audio.SoundId = "rbxassetid://" .. soundId
audio.PlaybackSpeed = playbackSpeed
audio.Volume = soundVolume
audio.Looped = true -- Музыкa қайталанып ойнайды
audio:Play()

-- Басқару батырмасын (кнопкасын) құру
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local WilsonHubGui = playerGui:FindFirstChild("WilsonHubGui")

if WilsonHubGui then
    -- Батырманы орналастыратын HomePage-ді табамыз
    local HomePage = WilsonHubGui:FindFirstChild("MainFrame"):FindFirstChild("ContentContainer"):FindFirstChild("HomePage")
    if HomePage then
        local MuteButton = Instance.new("ImageButton")
        MuteButton.Name = "MuteButton"
        MuteButton.Parent = HomePage -- <<-- МАҢЫЗДЫ ӨЗГЕРІС ОСЫ ЖЕРДЕ
        MuteButton.BackgroundTransparency = 1
        MuteButton.AnchorPoint = Vector2.new(1, 1) -- Оң жақ төменгі бұрышқа орнату
        MuteButton.Position = UDim2.new(1, -15, 1, -15) -- Шегіністерді реттеу
        MuteButton.Size = UDim2.new(0, 40, 0, 40) -- Өлшемін реттеу
        MuteButton.Image = soundOnIcon -- Бастапқыда музыка қосулы тұрады

        -- Батырманы басқанда не болатынын анықтайтын функция
        MuteButton.MouseButton1Click:Connect(function()
            if audio.IsPlaying then
                -- Егер музыка ойнап тұрса, оны тоқтатып, иконканы өзгертеміз
                audio:Pause()
                MuteButton.Image = soundOffIcon
            else
                -- Егер музыка тоқтап тұрса, оны жалғастырып, иконканы қайтарамыз
                audio:Resume()
                MuteButton.Image = soundOnIcon
            end
        end)
    end
end
