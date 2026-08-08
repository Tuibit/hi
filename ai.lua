local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Biến trạng thái
local instantInteractEnabled = false
local speedEnabled = false
local customSpeed = 50
local defaultSpeed = 16

-- Hàm xử lý ProximityPrompt (Bấm E tức thì)
ProximityPromptService.PromptShown:Connect(function(prompt)
    if instantInteractEnabled then
        prompt.HoldDuration = 0
    end
end)

-- Hàm cập nhật tốc độ chạy
local function updateSpeed()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedEnabled and customSpeed or defaultSpeed
        end
    end
end

-- Tự động áp dụng tốc độ khi hồi sinh
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    updateSpeed()
end)

---------------------------------------------------------
-- GIAO DIỆN MENU (GUI)
---------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Khung Menu
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- Cho phép kéo menu di chuyển
Frame.Parent = ScreenGui

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Control Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Nút Bật/Tắt Nhặt Tức Thì (Instant E)
local InstantBtn = Instance.new("TextButton")
InstantBtn.Size = UDim2.new(0.9, 0, 0, 35)
InstantBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
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
        -- Áp dụng ngay cho các prompt đang hiển thị
        for _, prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end
    else
        InstantBtn.Text = "Instant E: OFF"
        InstantBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Nút Bật/Tắt Speed
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 35)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
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
    end
    updateSpeed()
end)
