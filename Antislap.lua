local localplr = game.Players.LocalPlayer
local drag = nil
pcall(function()
    drag = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Drag-UI-SUPPORTS-MOBILE-22790"))()
end)
if drag == nil then -- your executor actually sucks if the script has to do this
    drag = function(f) -- the drag loadstring is way longer than this function, this one is just a crappy replacement
        if f then
            f.Active = true
            f.Draggable = true
        end
    end
end
gui2 = Instance.new("ScreenGui")
gui2.Name = ""
for i=1,50 do
    gui2.Name = gui2.Name..tostring(math.random(1,9))
end
gui2.ResetOnSpawn = false
gui2.Parent = game.CoreGui
local mainframe2 = Instance.new("TextLabel")
mainframe2.BackgroundColor3 = Color3.fromRGB(255,0,0)
mainframe2.BorderColor3 = Color3.fromRGB(255,0,0)
mainframe2.Size = UDim2.new(.1,0,.05,0)
mainframe2.Position = UDim2.new(.45,0,.475,0)
drag(mainframe2)
mainframe2.Text = "MADE BY WILSONHUB"
mainframe2.TextScaled = true
mainframe2.TextColor3 = Color3.fromRGB(255,255,255)
local textbutton = Instance.new("TextButton")
textbutton.Position = UDim2.new(0,0,1,0)
textbutton.Size = UDim2.new(1,0,2,0)
textbutton.Text = "Anti-Slap: OFF"
textbutton.TextScaled = true
textbutton.TextColor3 = Color3.fromRGB(255,255,255)
textbutton.BackgroundColor3 = Color3.fromRGB(50,50,50)
textbutton.BorderColor3 = Color3.fromRGB(255,255,255)
textbutton.Parent = mainframe2
local as = false
function dobv(v,char)
	local undo = false
	if as then
		if v:IsA("BodyAngularVelocity") then
			undo = true
			v:Destroy()
		elseif v:IsA("BodyGyro") and v.MaxTorque ~= Vector3.new(8999999488, 8999999488, 8999999488) and v.D ~= 500 and v.D ~= 50 and v.P ~= 90000 then
			undo = true
			v:Destroy()
		elseif v:IsA("BodyVelocity") and v.MaxForce ~= Vector3.new(8999999488, 8999999488, 8999999488) and v.Velocity ~= Vector3.new(0,0,0) then
			undo = true
			v:Destroy()
		elseif v:IsA("BasePart") then
			v.ChildAdded:Connect(function(v2)
				dobv(v2,char)
			end)
		end
		if undo and char and char:FindFirstChild("Humanoid") then
			char.Humanoid.Sit = false
			char.Humanoid.PlatformStand = false
		end
	end
end
textbutton.MouseButton1Click:Connect(function()
	as = not as
	if as then
		textbutton.Text = "Anti-Slap: ON"
		if localplr.Character then
			for i,v in pairs(localplr.Character:GetChildren()) do
				dobv(v,localplr.Character)
				for i,v in pairs(v:GetChildren()) do
					dobv(v,localplr.Character)
				end
			end
		end
	else
		textbutton.Text = "Anti-Slap: OFF"
	end
end)
mainframe2.Parent = gui2
