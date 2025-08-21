-- Spider-Man Web Shooter (Executor Script)
-- Тор атады, тартып апарады, 1 секунд жабыстырады да түсіреді

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Құрал жасау
local tool = Instance.new("Tool")
tool.Name = "Web Shooter"
tool.RequiresHandle = false
tool.Parent = player.Backpack

local currentBeam = nil
local pulling = false
local sticking = false

-- Торды атау функциясы
local function shootWeb(mouse)
	if not mouse.Target then return end
	local targetPos = mouse.Hit.Position

	-- ескі Beam болса өшіреміз
	if currentBeam then currentBeam:Destroy() end

	-- Торды визуализациялау (Beam)
	local att1 = Instance.new("Attachment", root)
	local att2 = Instance.new("Attachment", workspace.Terrain)
	att2.WorldPosition = targetPos

	local beam = Instance.new("Beam")
	beam.Attachment0 = att1
	beam.Attachment1 = att2
	beam.Width0 = 0.25
	beam.Width1 = 0.25
	beam.Color = ColorSequence.new(Color3.fromRGB(255,255,255)) -- аппақ
	beam.Texture = "rbxassetid://12221967" -- өрмек текстурасы
	beam.TextureLength = 1
	beam.TextureMode = Enum.TextureMode.Stretch
	beam.Parent = root

	currentBeam = beam
	pulling = true
	sticking = false

	-- Тарту
	spawn(function()
		while pulling and currentBeam do
			local dir = (targetPos - root.Position).Unit
			root.Velocity = dir * 120 -- тартылу күші
			-- Егер стенаға тым жақын барсақ — тоқтап жабысып тұрамыз
			if (root.Position - targetPos).Magnitude < 5 then
				pulling = false
				sticking = true
				root.Velocity = Vector3.new(0,0,0)
				-- 1 секунд жабысып тұру
				wait(1)
				sticking = false
				break
			end
			RunService.RenderStepped:Wait()
		end
		-- Торды өшіру
		if currentBeam then
			currentBeam:Destroy()
			currentBeam = nil
		end
		if att1 then att1:Destroy() end
		if att2 then att2:Destroy() end
	end)
end

-- құрал басқанда
tool.Activated:Connect(function()
	local mouse = player:GetMouse()
	shootWeb(mouse)
end)
