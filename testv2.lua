local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- GUI
local sg = Instance.new("ScreenGui", plr.PlayerGui)
sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 180, 0, 250)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.2

local function makeBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, -10, 0, 35)
	b.Position = UDim2.new(0, 5, 0, y)
	b.Text = text .. ": OFF"
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local b1 = makeBtn("Đạn vô hạn", 5)
local b2 = makeBtn("Tự bắn", 45)
local b3 = makeBtn("Bất tử", 85)
local b4 = makeBtn("Chạy nhanh", 125)
local b5 = makeBtn("Bay", 165)
local b6 = makeBtn("Gom quái", 205)

local ammo, shoot, god, speed, fly, pull = false,false,false,false,false,false
local bv

-- ĐẠN VÔ HẠN
b1.MouseButton1Click:Connect(function()
	ammo = not ammo
	b1.Text = "Đạn vô hạn: "..(ammo and "ON" or "OFF")
	while ammo do
		for _, v in pairs(plr.Backpack:GetDescendants()) do
			if v:IsA("Tool") and v:FindFirstChild("Ammo") then v.Ammo.Value = 9999 end
		end
		task.wait(0.5)
	end
end)

-- TỰ BẮN
b2.MouseButton1Click:Connect(function()
	shoot = not shoot
	b2.Text = "Tự bắn: "..(shoot and "ON" or "OFF")
end)
rs.Stepped:Connect(function()
	if shoot then
		for _, mob in pairs(workspace.Enemies:GetChildren()) do
			if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
				local gun = plr.Character:FindFirstChildOfClass("Tool")
				if gun and gun:FindFirstChild("Fire") then
					gun.Fire:FireServer(mob.HumanoidRootPart.Position)
				end
			end
		end
	end
end)

-- BẤT TỬ
b3.MouseButton1Click:Connect(function()
	god = not god
	b3.Text = "Bất tử: "..(god and "ON" or "OFF")
end)
hum.HealthChanged:Connect(function()
	if god and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
end)

-- CHẠY NHANH
b4.MouseButton1Click:Connect(function()
	speed = not speed
	b4.Text = "Chạy nhanh: "..(speed and "ON" or "OFF")
	hum.WalkSpeed = speed and 100 or 16
	hum.JumpPower = speed and 120 or 50
end)

-- BAY
b5.MouseButton1Click:Connect(function()
	fly = not fly
	b5.Text = "Bay: "..(fly and "ON" or "OFF")
	if fly then
		bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
		bv.MaxForce = Vector3.new(400000,400000,400000)
		rs.RenderStepped:Connect(function()
			if fly then bv.Velocity = game.Players.LocalPlayer:GetMouse().Hit.LookVector*80 + Vector3.new(0,10,0) end
		end)
	else
		if bv then bv:Destroy() end
	end
end)

-- GOM QUÁI
b6.MouseButton1Click:Connect(function()
	for _, mob in pairs(workspace.Enemies:GetChildren()) do
		if mob:FindFirstChild("HumanoidRootPart") then
			mob.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,-3)
		end
	end
end)

-- Bắn không giật
rs.RenderStepped:Connect(function()
	workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame
end)
