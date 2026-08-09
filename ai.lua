local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình mặc định
local platformHeightOffset = -3.2 -- Khoảng cách từ RootPart xuống chân
local stepAmount = 2 -- Độ cao nâng/hạ mỗi lần bấm nút (+ / -)
local isEnabled = false
local currentPlatformY = 0

-- Khởi tạo Part làm sàn
local platform = Instance.new("Part")
platform.Name = "AirWalkPlatform"
platform.Size = Vector3.new(10, 1, 10) -- Độ rộng mặt sàn
platform.Anchored = true
platform.CanCollide = true
platform.Material = Enum.Material.Forcefield
platform.Color = Color3.fromRGB(0, 170, 255)
platform.Transparency = 0.5
platform.Parent = nil

-- Hàm lấy HumanoidRootPart
local function getRootPart()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		return char.HumanoidRootPart
	end
	return nil
end

-- Cập nhật vị trí sàn theo nhân vật
RunService.RenderStepped:Connect(function()
	if isEnabled and platform.Parent then
		local root = getRootPart()
		if root then
			-- Giữ sàn ở độ cao Y cố định, di chuyển X, Z theo người chơi
			platform.CFrame = CFrame.new(root.Position.X, currentPlatformY, root.Position.Z)
		end
	end
end)

-- Tạo GUI Điều khiển
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AirWalkGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- Có thể kéo thả menu
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Menu Nâng Sàn"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Nút Bật / Tắt
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

-- Nút Tăng (+)
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

-- Nút Giảm (-)
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

-- Xử lý sự kiện nút Bật / Tắt
toggleBtn.MouseButton1Click:Connect(function()
	local root = getRootPart()
	if not root then return end

	isEnabled = not isEnabled
	if isEnabled then
		currentPlatformY = root.Position.Y + platformHeightOffset
		platform.CFrame = CFrame.new(root.Position.X, currentPlatformY, root.Position.Z)
		platform.Parent = workspace
		toggleBtn.Text = "Trạng thái: BẬT"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		platform.Parent = nil
		toggleBtn.Text = "Trạng thái: TẮT"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

-- Xử lý sự kiện nút Nâng (+)
upBtn.MouseButton1Click:Connect(function()
	if not isEnabled then return end
	local root = getRootPart()
	
	currentPlatformY = currentPlatformY + stepAmount
	if root then
		-- Dịch chuyển nhẹ nhân vật lên theo sàn để không bị kẹt chìm dưới sàn
		root.CFrame = root.CFrame + Vector3.new(0, stepAmount, 0)
	end
end)

-- Xử lý sự kiện nút Hạ (-)
downBtn.MouseButton1Click:Connect(function()
	if not isEnabled then return end
	currentPlatformY = currentPlatformY - stepAmount
end)
