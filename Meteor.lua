-- // Meteor Tool Script
-- executor-ға қойсаң қолыңа "Meteor" деген зат береді
-- сонымен игроктың үстін басқанда оның төбесінен метеор түседі

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local localPlayer = Players.LocalPlayer
local backpack = localPlayer:WaitForChild("Backpack")

-- Tool жасау
local tool = Instance.new("Tool")
tool.Name = "Meteor"
tool.RequiresHandle = false
tool.Parent = backpack

-- Өртеу функциясы
local function burnCharacter(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local fire = Instance.new("Fire")
	fire.Size = 10
	fire.Heat = 20
	fire.Parent = hrp
	Debris:AddItem(fire,3)
end

-- Метеор spawn
local function spawnMeteor(targetHumanoid)
	if not targetHumanoid or targetHumanoid.Health <= 0 then return end
	local char = targetHumanoid.Parent
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local meteor = Instance.new("Part")
	meteor.Shape = Enum.PartType.Ball
	meteor.Size = Vector3.new(12,12,12)
	meteor.Material = Enum.Material.Slate
	meteor.Color = Color3.fromRGB(70,70,70)
	meteor.Anchored = true
	meteor.CanCollide = false
	meteor.Position = hrp.Position + Vector3.new(0,120,0)
	meteor.Parent = workspace

	-- Артынан от trail
	local fireTrail = Instance.new("ParticleEmitter")
	fireTrail.Texture = "rbxassetid://243660364"
	fireTrail.Rate = 150
	fireTrail.Lifetime = NumberRange.new(0.3,0.6)
	fireTrail.Speed = NumberRange.new(8,18)
	fireTrail.SpreadAngle = Vector2.new(20,20)
	fireTrail.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0,5),
		NumberSequenceKeypoint.new(1,0)
	})
	fireTrail.Parent = meteor

	-- Light
	local light = Instance.new("PointLight")
	light.Brightness = 2
	light.Range = 30
	light.Color = Color3.fromRGB(255,120,40)
	light.Parent = meteor

	-- Sound
	local whoosh = Instance.new("Sound")
	whoosh.SoundId = "rbxassetid://12222005"
	whoosh.Volume = 1
	whoosh.Parent = meteor
	whoosh:Play()

	-- Қуу
	local heartbeat
	heartbeat = RunService.Heartbeat:Connect(function()
		if not meteor or not meteor.Parent then heartbeat:Disconnect() return end
		if not hrp or not hrp.Parent then heartbeat:Disconnect() return end

		local targetPos = hrp.Position + Vector3.new(0,3,0)
		meteor.CFrame = meteor.CFrame:Lerp(CFrame.new(targetPos), 0.15)

		if (meteor.Position - targetPos).Magnitude < 6 then
			heartbeat:Disconnect()

			-- Impact effect
			local burst = Instance.new("ParticleEmitter")
			burst.Texture = "rbxassetid://241594440"
			burst.Lifetime = NumberRange.new(0.5,1)
			burst.Speed = NumberRange.new(25,45)
			burst.RotSpeed = NumberRange.new(-200,200)
			burst.Size = NumberSequence.new(4)
			burst.Parent = meteor
			burst:Emit(50)

			local flame = Instance.new("Fire")
			flame.Size = 15
			flame.Heat = 25
			flame.Parent = meteor
			Debris:AddItem(flame,3)

			-- Burn victim
			burnCharacter(char)

			task.delay(0.2, function()
				if targetHumanoid and targetHumanoid.Health > 0 then
					targetHumanoid.Health = 0
				end
				Debris:AddItem(char,0.5)
			end)

			Debris:AddItem(meteor,2)
		end
	end)
end

-- Tool қолдану
tool.Activated:Connect(function()
	local mouse = localPlayer:GetMouse()
	local target = mouse.Target
	if target and target.Parent then
		local humanoid = target.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			spawnMeteor(humanoid)
		end
	end
end)
