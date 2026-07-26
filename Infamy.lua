-- POTASSIUM EXECUTOR - INFAMY FULL WEAPON & GOD MENU
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

if game.CoreGui:FindFirstChild("PotassiumInfamyFullUI") then
    game.CoreGui.PotassiumInfamyFullUI:Destroy()
end

ScreenGui.Name = "PotassiumInfamyFullUI"
ScreenGui.Parent = game.CoreGui

-- Khung Menu Chính (Được mở rộng chiều cao để chứa thêm nút)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
MainFrame.BorderColor3 = Color3.fromRGB(255, 85, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 290, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "INFAMY - AMMO & NO RECOIL MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000

CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Size = UDim2.new(0.15, 0, 0, 35)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Hàm tạo Nút bấm nhanh
local function CreateButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Position = UDim2.new(0.06, 0, posY, 0)
    btn.Size = UDim2.new(0.88, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14.000
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- 1. CHỨC NĂNG ĐẠN VÔ HẠN (INFINITE AMMO)
local infAmmo = false
CreateButton("Đạn Vô Hạn (Infinite Ammo): OFF", 0.11, function(btn)
    infAmmo = not infAmmo
    if infAmmo then
        btn.Text = "Đạn Vô Hạn (Infinite Ammo): ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        btn.Text = "Đạn Vô Hạn (Infinite Ammo): OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    end
end)

task.spawn(function()
    while true do
        if infAmmo then
            pcall(function()
                -- Can thiệp vào thuộc tính súng trong Backpack và trên tay (Character)
                local player = game.Players.LocalPlayer
                local targets = {player.Backpack, player.Character}
                for _, container in pairs(targets) do
                    if container then
                        for _, item in pairs(container:GetChildren()) do
                            if item:IsA("Tool") then
                                -- Khôi phục chỉ số đạn đối với các module súng phổ biến
                                for _, child in pairs(item:GetDescendants()) do
                                    if child:IsA("IntValue") or child:IsA("NumberValue") then
                                        local name = child.Name:lower()
                                        if name:find("ammo") or name:find("clip") or name:find("stored") then
                                            child.Value = 999
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.2)
    end
end)

-- 2. CHỨC NĂNG BẮN KHÔNG GIẬT (NO RECOIL & NO SPREAD)
local noRecoil = false
CreateButton("Bắn Không Giật (No Recoil): OFF", 0.21, function(btn)
    noRecoil = not noRecoil
    if noRecoil then
        btn.Text = "Bắn Không Giật (No Recoil): ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        btn.Text = "Bắn Không Giật (No Recoil): OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    end
end)

task.spawn(function()
    while true do
        if noRecoil then
            pcall(function()
                local player = game.Players.LocalPlayer
                local targets = {player.Backpack, player.Character}
                for _, container in pairs(targets) do
                    if container then
                        for _, item in pairs(container:GetChildren()) do
                            if item:IsA("Tool") then
                                -- Triệt tiêu độ giật và độ nở tâm ngắm
                                for _, child in pairs(item:GetDescendants()) do
                                    if child:IsA("NumberValue") or child:IsA("IntValue") then
                                        local name = child.Name:lower()
                                        if name:find("recoil") or name:find("spread") or name:find("kick") then
                                            child.Value = 0
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.3)
    end
end)

-- 3. CHỨC NĂNG CẦM TẤT CẢ SÚNG CÙNG LÚC (EQUIP ALL)
CreateButton(" Trang Bị Tất Cả Súng (Equip All)", 0.31, function(btn)
    pcall(function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and player:FindFirstChild("Backpack") then
            for _, tool in pairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = char
                end
            end
        end
    end)
end)

-- 4. CHỨC NĂNG BẤT TỬ (GOD MODE)
local godMode = false
CreateButton("God Mode (Bất Tử): OFF", 0.41, function(btn)
    godMode = not godMode
    if godMode then
        btn.Text = "God Mode (Bất Tử): ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        btn.Text = "God Mode (Bất Tử): OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    end
end)

task.spawn(function()
    while true do
        if godMode then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                    char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- 5. CHỨC NĂNG AUTO FARM INFAMY
local autoFarm = false
CreateButton("Auto Farm Infamy: OFF", 0.51, function(btn)
    autoFarm = not autoFarm
    if autoFarm then
        btn.Text = "Auto Farm Infamy: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        btn.Text = "Auto Farm Infamy: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    end
end)

task.spawn(function()
    while true do
        if autoFarm then
            pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                for _, v in pairs(RS:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("infamy") or v.Name:lower():find("rob")) then
                        v:FireServer()
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- 6. CHỨC NĂNG TỰ ĐỘNG XÓA TRUY NÃ
local autoHeat = false
CreateButton("Auto Clear Heat (Xóa Truy Nã): OFF", 0.61, function(btn)
    autoHeat = not autoHeat
    if autoHeat then
        btn.Text = "Auto Clear Heat: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        btn.Text = "Auto Clear Heat: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    end
end)

task.spawn(function()
    while true do
        if autoHeat then
            pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                for _, v in pairs(RS:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("heat") or v.Name:lower():find("bribe") or v.Name:lower():find("clear")) then
                        v:FireServer()
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

-- 7. CHỨC NĂNG ĐỔI TỐC ĐỘ CHẠY (SUPER SPEED)
local speedActive = false
CreateButton("Tốc Độ Chạy (Super Speed): OFF", 0.71, function(btn)
    speedActive = not speedActive
    if speedActive then
        btn.Text = "Super Speed: ON (120)"
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
    else
        btn.Text = "Super Speed: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        pcall(function()
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end)
    end
end)

task.spawn(function()
    while true do
        if speedActive then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 120
            end)
        end
        task.wait(0.2)
    end
end)
