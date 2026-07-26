local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lấy nút bấm từ Gui
local screenGui = playerGui:WaitForChild("AutoCollectGui")
local toggleBtn = screenGui:WaitForChild("ToggleButton")

-- Cấu hình Nhặt Năng Lượng
local isAutoCollectEnabled = false
local COLLECT_RADIUS = 80       -- Bán kính phát hiện ngọc (studs)
local TWEEN_SPEED = 0.15        -- Thời gian ngọc bay về người (càng nhỏ nhặt càng nhanh)

-- Xử lý bấm nút Bật/Tắt Menu
toggleBtn.MouseButton1Click:Connect(function()
	isAutoCollectEnabled = not isAutoCollectEnabled

	if isAutoCollectEnabled then
		toggleBtn.Text = "Auto-Collect: ON"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Màu xanh
	else
		toggleBtn.Text = "Auto-Collect: OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)   -- Màu đỏ
	end
end)

-- Vòng lặp quét ngọc và hút về phía người chơi (RenderStepped)
RunService.RenderStepped:Connect(function()
	if not isAutoCollectEnabled then return end

	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Lấy Folder chứa ngọc
	local energyFolder = Workspace:FindFirstChild("EnergyFolder")
	if not energyFolder then return end

	-- Duyệt qua tất cả các viên ngọc trên map
	for _, orb in ipairs(energyFolder:GetChildren()) do
		if orb:IsA("BasePart") and not orb:GetAttribute("BeingCollected") then
			local distance = (orb.Position - hrp.Position).Magnitude

			-- Nếu ngọc nằm trong phạm vi nhặt
			if distance <= COLLECT_RADIUS then
				-- Đánh dấu ngọc đang được hút để tránh trùng lặp
				orb:SetAttribute("BeingCollected", true)

				-- Tạo hiệu ứng ngọc bay siêu nhanh về phía nhân vật (Tween)
				local tweenInfo = TweenInfo.new(
					TWEEN_SPEED, 
					Enum.EasingStyle.Quad, 
					Enum.EasingDirection.In
				)
				local tween = TweenService:Create(orb, tweenInfo, {Position = hrp.Position})
				tween:Play()
			end
		end
	end
end)
