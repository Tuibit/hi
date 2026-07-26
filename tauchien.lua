-- Global Variables
getgenv().AutoAimConfig = {
    Enabled = false,
    FOV = 1000,
    BulletSpeed = 2000, -- Tốc độ đạn dự đoán
    TargetName = "Plane", -- Tìm model có tên chứa từ này hoặc máy bay
    TeamCheck = true
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. TẠO GUI MENU SẮC NÉT
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Name = "CheatMenu_AA"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 180, 0, 90)
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo thả Menu

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Text = "AA AIMBOT V1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "AUTO AIM: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold

-- 2. HÀM TÌM MÁY BAY / MỤC TIÊU GẦN NHẤT
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = getgenv().AutoAimConfig.FOV

    for _, obj in ipairs(workspace:GetChildren()) do
        -- Kiểm tra nếu là Model máy bay / Xe / Player khác
        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
            local root = obj.PrimaryPart or obj:FindFirstChild("Engine") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("BasePart")
            
            if root then
                -- Tính khoảng cách màn hình hoặc khoảng cách 3D
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestTarget = root
                    end
                end
            end
        end
    end
    return closestTarget
end

-- 3. HÀM TÍNH TOÁN ĐÓN ĐẦU (LEAD TARGET MATH)
local function GetPredictedPosition(targetPart)
    local pos = targetPart.Position
    local vel = targetPart.AssemblyLinearVelocity or Vector3.zero
    local dist = (pos - Camera.CFrame.Position).Magnitude
    local timeToHit = dist / getgenv().AutoAimConfig.BulletSpeed

    return pos + (vel * timeToHit)
end

-- 4. BẬT / TẮT MENU
ToggleBtn.MouseButton1Click:Connect(function()
    getgenv().AutoAimConfig.Enabled = not getgenv().AutoAimConfig.Enabled
    if getgenv().AutoAimConfig.Enabled then
        ToggleBtn.Text = "AUTO AIM: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleBtn.Text = "AUTO AIM: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- 5. VÒNG LẶP KHÓA CAMERA VÀO ĐIỂM ĐÓN ĐẦU
RunService.RenderStepped:Connect(function()
    if getgenv().AutoAimConfig.Enabled then
        local target = GetClosestTarget()
        if target then
            local aimPoint = GetPredictedPosition(target)
            -- Khóa Camera trực tiếp vào tọa độ đón đầu
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, aimPoint)
        end
    end
end)
