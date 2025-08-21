-- [ DANCE SCRIPT ] | Auto Execute Edition
-- Автор: Nurgazy_21
-- Бұл скриптті Executor-ға тастаған кезде автоматты түрде персонаж би билейді

local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Анимация
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://27789359" -- Сенің танец анимацияң

-- Ескі анимацияларды тоқтату
for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
	track:Stop()
end

-- Жаңа анимацияны жүктеу
local danceTrack = humanoid:LoadAnimation(anim)
danceTrack.Priority = Enum.AnimationPriority.Action
danceTrack.Looped = true
danceTrack:Play()

-- Авто-респавн кезінде де би жалғасады
player.CharacterAdded:Connect(function(newChar)
	local hum = newChar:WaitForChild("Humanoid")
	local anim2 = Instance.new("Animation")
	anim2.AnimationId = anim.AnimationId
	local track = hum:LoadAnimation(anim2)
	track.Priority = Enum.AnimationPriority.Action
	track.Looped = true
	track:Play()
end)
