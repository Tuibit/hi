local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình
local stepAmount = 2.5 -- Khoảng cách nâng/hạ mỗi lần bấm
local isEnabled = false
local currentPlatformY = 0

-- Khởi tạo sàn
local platform = Instance.new("Part")
platform.Name = "AirWalkPlatform_Fixed"
platform.Size = Vector3.new(12, 1, 12)
platform.Anchored = true
platform.CanCollide = true
platform.Material = Enum.Material.SmoothPlastic
platform.Color = Color3.fromRGB(0, 170, 255)
platform.Transparency = 0.4
platform.Parent = nil

-- Hàm lấy vị trí chân nhân vật chính xác
local function getFeetPositionY()
	local char = LocalPlayer.Character
	if not char then return nil end
	
	local root = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	
	if root and humanoid then
		-- Tự động tính khoảng cách từ tâm đến bàn chân dựa trên chiều cao Avatar
		local hipHeight = humanoid.HipHeight
		if hipHeight == 0 then hipHeight = 2 end -- Mặc định cho R6
		return root.Position.Y - (hipHeight + (root.Size.Y / 2))
	end
	return nil
end

-- Hàm lấy HumanoidRootPart
local function getRootPart()
	local char = LocalPlayer.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

-- Cập nhật sàn theo người chơi
RunService.RenderStepped:Connect(function()
	if isEnabled and platform.Parent then
		local root = getRootPart()
		if root then
			-- Đặt mặt trên của sàn ngay chạm lòng bàn chân
			platform.CFrame = CFrame.new(root.Position.X, currentPlatformY - (platform.Size.Y / 2), root.Position.Z)
		end
	end
end)

-- Tạo GUI
local parentGui = LocalPlayer:WaitForChild("PlayerGui")
-- Bỏ comment dòng dưới nếu bạn dùng Executor bị ẩn UI:
-- parentGui = game:GetService("CoreGui") 

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AirWalkGui_Fixed"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Menu Nâng Sàn (Sửa Lỗi)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "Trạng thái: TẮT"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.TextSize = 14
toggleBtn.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 6)
btnCorner1.Parent = toggleBtn

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0.425, 0, 0, 30)
upBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
upBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
upBtn.Text = "+"
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.Font = Enum.Font.SourceSansBold
upBtn.TextSize = 20
upBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0.425, 0, 0, 30)
downBtn.Position = UDim2.new(0.525, 0, 0.65, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
downBtn.Text = "-"
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.Font = Enum.Font.SourceSansBold
downBtn.TextSize = 20
downBtn.Parent = mainFrame

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 6)
btnCorner3.Parent = downBtn

-- Sự kiện Bật / Tắt
toggleBtn.MouseButton1Click:Connect(function()
	local feetY = getFeetPositionY()
	if not feetY then return end

	isEnabled = not isEnabled
	if isEnabled then
		currentPlatformY = feetY
		platform.Parent = workspace
		toggleBtn.Text = "Trạng thái: BẬT"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		platform.Parent = nil
		toggleBtn.Text = "Trạng thái: TẮT"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

-- Sự kiện Nâng (+)
upBtn.MouseButton1Click:Connect(function()
	if not isEnabled then return end
	local root = getRootPart()
	
	currentPlatformY = currentPlatformY + stepAmount
	if root then
		root.CFrame = root.CFrame + Vector3.new(0, stepAmount, 0)
	end
end)

-- Sự kiện Hạ (-)
downBtn.MouseButton1Click:Connect(function()
	if not isEnabled then return end
	currentPlatformY = currentPlatformY - stepAmount
end)
