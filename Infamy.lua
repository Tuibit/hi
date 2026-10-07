local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Cấu hình
local speedStep = 10         -- Khoảng tăng/giảm mỗi lần bấm nút +/-
local defaultSpeed = 16      -- Tốc độ mặc định của Roblox
local currentSpeed = 50      -- Tốc độ muốn đặt khi BẬT
local isEnabled = false

-- Hàm lấy Humanoid an toàn
local function getHumanoid()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	return char:WaitForChild("Humanoid", 5)
end

-- Vòng lặp duy trì tốc độ (Tránh bị game tự động đè lại WalkSpeed)
RunService.Stepped:Connect(function()
	local hum = getHumanoid()
	if hum then
		if isEnabled then
			hum.WalkSpeed = currentSpeed
		end
	end
end)

-- Tạo GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGui_Fixed"
screenGui.ResetOnSpawn = false

pcall(function()
	screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 110)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Hàm hỗ trợ Kéo/Thả Menu
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end
makeDraggable(mainFrame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Menu Speed (" .. currentSpeed .. ")"
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
upBtn.Text = "+ Speed"
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.Font = Enum.Font.SourceSansBold
upBtn.TextSize = 14
upBtn.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0.425, 0, 0, 30)
downBtn.Position = UDim2.new(0.525, 0, 0.65, 0)
downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
downBtn.Text = "- Speed"
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.Font = Enum.Font.SourceSansBold
downBtn.TextSize = 14
downBtn.Parent = mainFrame

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 6)
btnCorner3.Parent = downBtn

-- Cập nhật tiêu đề hiển thị tốc độ
local function updateTitle()
	title.Text = "Menu Speed (" .. currentSpeed .. ")"
end

-- Sự kiện Bật / Tắt
toggleBtn.MouseButton1Click:Connect(function()
	local hum = getHumanoid()
	isEnabled = not isEnabled
	
	if isEnabled then
		toggleBtn.Text = "Trạng thái: BẬT"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		if hum then hum.WalkSpeed = currentSpeed end
	else
		toggleBtn.Text = "Trạng thái: TẮT"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		if hum then hum.WalkSpeed = defaultSpeed end
	end
end)

-- Sự kiện Tăng Tốc (+)
upBtn.MouseButton1Click:Connect(function()
	currentSpeed = currentSpeed + speedStep
	updateTitle()
	if isEnabled then
		local hum = getHumanoid()
		if hum then hum.WalkSpeed = currentSpeed end
	end
end)

-- Sự kiện Giảm Tốc (-)
downBtn.MouseButton1Click:Connect(function()
	if currentSpeed - speedStep >= 0 then
		currentSpeed = currentSpeed - speedStep
	else
		currentSpeed = 0
	end
	updateTitle()
	if isEnabled then
		local hum = getHumanoid()
		if hum then hum.WalkSpeed = currentSpeed end
	end
end)

-- Khi hồi sinh, nếu đang BẬT thì tự áp dụng lại tốc độ
LocalPlayer.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum and isEnabled then
		hum.WalkSpeed = currentSpeed
	end
end)
