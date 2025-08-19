-- Win Tower script (универсальный)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local winPart

-- WinPad, WinPart, Finish, End, т.б. атауларын іздеу
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and (
        v.Name:lower():find("win") or
        v.Name:lower():find("end") or
        v.Name:lower():find("finish")
    ) then
        winPart = v
        break
    end
end

if winPart then
    char:MoveTo(winPart.Position + Vector3.new(0, 5, 0))
    print("WinTower: Teleported to the finish!")
else
    warn("WinTower: Win part not found.")
end
