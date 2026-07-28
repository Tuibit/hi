-- OverkillAdminMenu (LocalScript trong StarterPlayerScripts)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local settingsUpdateEvent = ReplicatedStorage:WaitForChild("OverkillSettingsUpdate")
local settingsRequestFunction = ReplicatedStorage:WaitForChild("OverkillSettingsRequest")

-- Hỏi server: mình có phải admin không, settings hiện tại là gì
local result = settingsRequestFunction:InvokeServer()

if not result.IsAdmin then
	return -- không phải admin thì không tạo menu, script dừng luôn
end

-- ==== TẠO GUI ====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OverkillAdminMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0, 20, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Overkill Admin"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Nút bật/tắt
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 36)
toggleButton.Position = UDim2.new(0, 10, 0, 36)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 15
toggleButton.Parent = frame

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 6)
uiCorner2.Parent = toggleButton

local currentEnabled = result.Enabled
local currentThreshold = result.Threshold

local function refreshToggleUI()
	if currentEnabled then
		toggleButton.Text = "Overkill: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(60, 170, 90)
	else
		toggleButton.Text = "Overkill: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(170, 60, 60)
	end
end
refreshToggleUI()

toggleButton.MouseButton1Click:Connect(function()
	currentEnabled = not currentEnabled
	refreshToggleUI()
	settingsUpdateEvent:FireServer(currentEnabled, currentThreshold)
end)

-- Thanh trượt (Slider) chỉnh Threshold
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -20, 0, 20)
sliderLabel.Position = UDim2.new(0, 10, 0, 80)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Threshold: " .. currentThreshold
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 13
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Parent = frame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, -20, 0, 10)
sliderBar.Position = UDim2.new(0, 10, 0, 105)
sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBar.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBar

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(currentThreshold / 500, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(80, 150, 220)
sliderFill.Parent = sliderBar

local sliderFillCorner = Instance.new("UICorner")
sliderFillCorner.CornerRadius = UDim.new(1, 0)
sliderFillCorner.Parent = sliderFill

local dragging = false

local function updateSliderFromInput(inputPosition)
	local relativeX = math.clamp((inputPosition.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
	sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
	currentThreshold = math.floor(relativeX * 500)
	sliderLabel.Text = "Threshold: " .. currentThreshold
end

sliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		updateSliderFromInput(input.Position)
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateSliderFromInput(input.Position)
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			dragging = false
			settingsUpdateEvent:FireServer(currentEnabled, currentThreshold)
		end
	end
end)
