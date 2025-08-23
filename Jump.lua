local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

UIS.JumpRequest:Connect(function()
	Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
end)
