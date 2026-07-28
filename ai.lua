-- OverkillDamageHandler (ServerScript trong ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- ==== CONFIG ====
local ADMIN_USER_IDS = {
	123456789, -- <-- Thay bằng UserId của bạn
}

local settings = {
	Enabled = true,
	Threshold = 20,
}

-- ==== REMOTES ====
local overkillEvent = Instance.new("RemoteEvent")
overkillEvent.Name = "OverkillDamageEvent"
overkillEvent.Parent = ReplicatedStorage

local settingsUpdateEvent = Instance.new("RemoteEvent")
settingsUpdateEvent.Name = "OverkillSettingsUpdate"
settingsUpdateEvent.Parent = ReplicatedStorage

local settingsRequestFunction = Instance.new("RemoteFunction")
settingsRequestFunction.Name = "OverkillSettingsRequest"
settingsRequestFunction.Parent = ReplicatedStorage

local function isAdmin(player: Player)
	for _, id in ipairs(ADMIN_USER_IDS) do
		if player.UserId == id then return true end
	end
	return false
end

-- Client (admin) gửi thay đổi settings lên server
settingsUpdateEvent.OnServerEvent:Connect(function(player, newEnabled, newThreshold)
	if not isAdmin(player) then return end -- chặn người không phải admin

	if type(newEnabled) == "boolean" then
		settings.Enabled = newEnabled
	end
	if type(newThreshold) == "number" then
		settings.Threshold = math.clamp(newThreshold, 0, 500)
	end
end)

-- Client gọi để lấy settings hiện tại + biết mình có phải admin không
settingsRequestFunction.OnServerInvoke = function(player)
	return {
		IsAdmin = isAdmin(player),
		Enabled = settings.Enabled,
		Threshold = settings.Threshold,
	}
end

-- ==== HÀM GÂY DAMAGE ====
local function dealDamage(humanoid: Humanoid, damageAmount: number)
	if not humanoid or humanoid.Health <= 0 then return end

	local currentHealth = humanoid.Health
	local overkillAmount = damageAmount - currentHealth

	humanoid:TakeDamage(damageAmount)

	if settings.Enabled and overkillAmount >= settings.Threshold then
		local character = humanoid.Parent
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")

		if rootPart then
			overkillEvent:FireAllClients(rootPart.Position, math.floor(overkillAmount))
		end
	end
end

_G.DealDamageWithOverkill = dealDamage
