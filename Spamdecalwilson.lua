local decalId = "rbxassetid://74363941489431"
local musicId = "rbxassetid://1839246711"
local batchSize = 50
local delayBetweenBatches = 0.1

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ignore your own character parts
local ignoreParts = {}
for _, part in ipairs(character:GetDescendants()) do
    if part:IsA("BasePart") then
        ignoreParts[part] = true
    end
end

-- Set skybox to decal
local sky = Instance.new("Sky")
sky.SkyboxBk = decalId
sky.SkyboxDn = decalId
sky.SkyboxFt = decalId
sky.SkyboxLf = decalId
sky.SkyboxRt = decalId
sky.SkyboxUp = decalId
sky.Parent = game:GetService("Lighting")

-- Play new sound immediately (full sound playback)
local sound = Instance.new("Sound")
sound.SoundId = musicId
sound.Volume = 10 -- Max volume in Studio
sound.Pitch = 1 -- Normal pitch
sound.Looped = true
sound.Parent = workspace
sound:Play()

-- Collect parts to apply decals (excluding self)
local parts = {}
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Name ~= "Terrain" and not ignoreParts[obj] then
        table.insert(parts, obj)
    end
end

-- Spam decals in batches
local index = 1
while index <= #parts do
    for i = index, math.min(index + batchSize - 1, #parts) do
        local part = parts[i]
        for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
            local decal = Instance.new("Decal")
            decal.Texture = decalId
            decal.Face = face
            decal.Parent = part
        end
    end
    index += batchSize
    task.wait(delayBetweenBatches)
end
