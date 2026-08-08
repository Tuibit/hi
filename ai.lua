local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Trạng thái mặc định
local instantInteractEnabled = false
local speedEnabled = false
local customSpeed = 50
local maxSpeed = 300
local defaultSpeed = 16

---------------------------------------------------------
-- 1. XỬ LÝ NHẶT ĐỒ TỨC THÌ (INSTANT E)
---------------------------------------------------------
local originalDurations = {}

local function applyPromptFix(prompt)
    if not originalDurations[prompt] then
        originalDurations[prompt] = prompt.HoldDuration
    end
    
    if instantInteractEnabled then
        prompt.HoldDuration = 0
    else
        prompt.HoldDuration = originalDurations[prompt] or 0.5
    end
end

ProximityPromptService.PromptShown:Connect(function(prompt)
    applyPromptFix(prompt)
end)

---------------------------------------------------------
-- 2. XỬ LÝ TỐC ĐỘ (SPEED)
---------------------------------------------------------
RunService.Stepped:Connect(function()
    if speedEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = customSpeed
        end
    end
end)

local function resetSpeed()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = defaultSpeed
        end
    end
end

---------------------------------------------------------
-- 3. GIAO DIỆN MENU (GUI)
---------------------------------------------------------
if PlayerGui:FindFirstChild("ModMenuGui") then
    PlayerGui.ModMenuGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Khung chứa Menu lớn hơn để vừa thanh chỉnh tốc độ
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 220)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Control Menu (Max Speed: 300)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Nút Instant E
local InstantBtn = Instance.new("TextButton")
InstantBtn.Size = UDim2.new(0.9, 0, 0, 35)
InstantBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
InstantBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
InstantBtn.Text = "Instant E: OFF"
InstantBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InstantBtn.TextSize = 14
InstantBtn.Font = Enum.Font.SourceSans
InstantBtn.Parent = Frame

InstantBtn.MouseButton1Click:Connect(function()
    instantInteractEnabled = not instantInteractEnabled
    if instantInteractEnabled then
        InstantBtn.Text = "Instant E: ON"
        InstantBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        InstantBtn.Text = "Instant E: OFF"
        InstantBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
    
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            applyPromptFix(prompt)
        end
    end
end)

-- Nút Bật/Tắt Speed Boost
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 35)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.38, 0)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
SpeedBtn.Text = "Speed Boost: OFF"
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.TextSize = 14
SpeedBtn.Font = Enum.Font.SourceSans
SpeedBtn.Parent = Frame

SpeedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedBtn.Text = "Speed Boost: ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        SpeedBtn.Text = "Speed Boost: OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        resetSpeed()
    end
end)

-- Ô nhập số tốc độ thủ công (TextBox)
local SpeedInputLabel = Instance.new("TextLabel")
SpeedInputLabel.Size = UDim2.new(0.45, 0, 0, 25)
SpeedInputLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
SpeedInputLabel.BackgroundTransparency = 1
SpeedInputLabel.Text = "Speed (1-300):"
SpeedInputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedInputLabel.TextSize = 13
SpeedInputLabel.Font = Enum.Font.SourceSans
SpeedInputLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedInputLabel.Parent = Frame

local SpeedTextBox = Instance.new("TextBox")
SpeedTextBox.Size = UDim2.new(0.4, 0, 0, 25)
SpeedTextBox.Position = UDim2.new(0.55, 0, 0.6, 0)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedTextBox.BorderSizePixel = 0
SpeedTextBox.Text = tostring(customSpeed)
SpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.TextSize = 13
SpeedTextBox.Font = Enum.Font.SourceSansBold
SpeedTextBox.Parent = Frame

-- Thanh trượt điều chỉnh tốc độ (Slider Background)
local SliderBg = Instance.new("Frame")
SliderBg.Size = UDim2.new(0.9, 0, 0, 10)
SliderBg.Position = UDim2.new(0.05, 0, 0.8, 0)
SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = Frame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(customSpeed / maxSpeed, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBg

-- Cập nhật tốc độ dựa trên con số nhập vào hoặc kéo thanh slider
local function setSpeed(val)
    val = math.clamp(math.floor(val), 1, maxSpeed)
    customSpeed = val
    SpeedTextBox.Text = tostring(val)
    SliderFill.Size = UDim2.new(val / maxSpeed, 0, 1, 0)
end

-- Khi người dùng gõ số vào ô TextBox
SpeedTextBox.FocusLost:Connect(function()
    local num = tonumber(SpeedTextBox.Text)
    if num then
        setSpeed(num)
    else
        SpeedTextBox.Text = tostring(customSpeed)
    end
end)

-- Lắng nghe sự kiện kéo thanh slider
local UserInputService = game:GetService("UserInputService")
local dragging = false

SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local bgPos = SliderBg.AbsolutePosition.X
        local bgSize = SliderBg.AbsoluteSize.X
        
        local scale = math.clamp((mousePos - bgPos) / bgSize, 0, 1)
        local calculatedSpeed = scale * maxSpeed
        if calculatedSpeed < 1 then calculatedSpeed = 1 end
        
        setSpeed(calculatedSpeed)
    end
end)
