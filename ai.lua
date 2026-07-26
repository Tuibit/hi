local NPCFolder = workspace.Enemies -- đổi tên folder NPC của bạn

local function oneShotGun(npc)
	for _, tool in pairs(npc:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Damage") then
			tool.Damage.Value = 9999 -- chỉnh damage cao ngất
		end
		if tool:FindFirstChild("FireRate") then
			tool.FireRate.Value = 0.1 -- bắn nhanh hơn tí
		end
	end
end

-- áp dụng cho NPC có sẵn
for _, npc in pairs(NPCFolder:GetChildren()) do
	if npc:FindFirstChildOfClass("Humanoid") then
		oneShotGun(npc)
	end
end

-- áp dụng cho NPC spawn mới
NPCFolder.ChildAdded:Connect(function(npc)
	npc.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then task.wait(0.1) oneShotGun(npc) end
	end)
end)
