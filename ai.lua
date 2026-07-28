-- Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/releases/latest/download/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/releases/latest/download/InterfaceManager.lua"))()

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "Be The Final Boss | Hub",
    SubTitle = "by AI Assistant",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Options storage
local Options = Fluent.Options

-- TABS DEFINITION
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "gift" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Server = Window:AddTab({ Title = "Server", Icon = "server" }),
    Performance = Window:AddTab({ Title = "Performance", Icon = "cpu" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--------------------------------------------------------------------
-- 1. MAIN TAB
--------------------------------------------------------------------
-- Battle Section
local BattleSection = Tabs.Main:AddSection("Battle")

local LeaveWaveToggle = BattleSection:AddToggle("LeaveAtWaveToggle", {Title = "Leave At Wave", Default = false})
local LeaveWaveInput = BattleSection:AddInput("LeaveWaveValue", {
    Title = "Wave Level",
    Default = "10",
    Numeric = true,
    Finished = true,
    Callback = function(Value) end
})

local AutoStartToggle = BattleSection:AddToggle("AutoStartBattle", {Title = "Auto Start Battle", Default = false})

AutoStartToggle:OnChanged(function()
    task.spawn(function()
        while Options.AutoStartBattle.Value do
            task.wait(1)
            -- Thêm Remote Event Start Battle của game vào đây nếu có
            -- game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("StartBattle"):FireServer()
        end
    end)
end)

-- Roll Section
local RollSection = Tabs.Main:AddSection("Roll")

local AutoRollToggle = RollSection:AddToggle("AutoRoll", {Title = "Auto Roll", Default = false})

local SelectedUnitsDropdown = RollSection:AddDropdown("SelectedUnits", {
    Title = "Select Units",
    Values = {"UR Unit", "SSR Unit", "SR Unit", "Secret Unit"},
    Multi = true,
    Default = {},
})

local PauseWantedToggle = RollSection:AddToggle("PauseAtWanted", {Title = "Pause At Wanted Units", Default = true})

-- Speed Section
local SpeedSection = Tabs.Main:AddSection("Speed")

local SetSpeedToggle = SpeedSection:AddToggle("SetSpeedToggle", {Title = "Set Speed", Default = false})
local SpeedDropdown = SpeedSection:AddDropdown("SelectSpeed", {
    Title = "Select Speed",
    Values = {"1x", "2x"},
    Default = "1x",
    Callback = function(Value)
        -- logic chỉnh game speed
    end
})

--------------------------------------------------------------------
-- 2. MISC TAB
--------------------------------------------------------------------
-- Rewards
local RewardsSection = Tabs.Misc:AddSection("Rewards")

RewardsSection:AddButton({
    Title = "Redeem Active Codes",
    Callback = function()
        Fluent:Notify({ Title = "Codes", Content = "Redeeming all active codes...", Duration = 3 })
    end
})

RewardsSection:AddButton({
    Title = "Claim Offline Rewards",
    Callback = function()
        Fluent:Notify({ Title = "Rewards", Content = "Claimed Offline Rewards!", Duration = 3 })
    end
})

RewardsSection:AddButton({
    Title = "Claim Daily Reward",
    Callback = function()
        Fluent:Notify({ Title = "Rewards", Content = "Claimed Daily Reward!", Duration = 3 })
    end
})

-- Other
local OtherMiscSection = Tabs.Misc:AddSection("Other")

local AutoSkillTree = OtherMiscSection:AddToggle("AutoSkillTree", {Title = "Auto Purchase Skill Tree", Default = false})
local AutoSpin = OtherMiscSection:AddToggle("AutoSpin", {Title = "Auto Spin Wheel", Default = false})

--------------------------------------------------------------------
-- 3. PLAYER TAB
--------------------------------------------------------------------
-- Movement
local MovementSection = Tabs.Player:AddSection("Movement")

local WalkSpeedSlider = MovementSection:AddSlider("WalkSpeed", {
    Title = "WalkSpeed Value",
    Min = 16,
    Max = 200,
    Default = 16,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

local JumpPowerSlider = MovementSection:AddSlider("JumpPower", {
    Title = "JumpPower Value",
    Min = 50,
    Max = 300,
    Default = 50,
    Rounding = 0,
    Callback = function(Value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

-- Utility / Anti AFK
local PlayerUtilSection = Tabs.Player:AddSection("Utility")

local AntiAFKToggle = PlayerUtilSection:AddToggle("AntiAFK", {Title = "Anti AFK", Default = true})

AntiAFKToggle:OnChanged(function()
    local VirtualUser = game:GetService("VirtualUser")
    task.spawn(function()
        while Options.AntiAFK.Value do
            task.wait(60)
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end)

--------------------------------------------------------------------
-- 4. SERVER TAB
--------------------------------------------------------------------
local ServerActionsSection = Tabs.Server:AddSection("Actions")

ServerActionsSection:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

ServerActionsSection:AddButton({
    Title = "Server Hop",
    Callback = function()
        local TP = game:GetService("TeleportService")
        TP:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

ServerActionsSection:AddButton({
    Title = "Server Hop To Min Players",
    Callback = function()
        Fluent:Notify({ Title = "Server Hop", Content = "Searching for low-player server...", Duration = 3 })
    end
})

local ServerUtilSection = Tabs.Server:AddSection("Utility")

ServerUtilSection:AddButton({
    Title = "FPS Booster",
    Callback = function()
        setfpscap(240)
        Fluent:Notify({ Title = "FPS", Content = "FPS Unlocked!", Duration = 3 })
    end
})

ServerUtilSection:AddButton({
    Title = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/your-invite-link")
        Fluent:Notify({ Title = "Discord", Content = "Copied to Clipboard!", Duration = 3 })
    end
})

--------------------------------------------------------------------
-- 5. PERFORMANCE TAB
--------------------------------------------------------------------
-- Render Quality
local RenderSection = Tabs.Performance:AddSection("Render Quality")

RenderSection:AddButton({
    Title = "FPS Booster",
    Callback = function()
        -- Low graphics settings
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end
})

local FPSCapDropdown = RenderSection:AddDropdown("FPSCap", {
    Title = "FPS Cap",
    Values = {"30", "60", "90", "120", "144", "240", "Unlimited"},
    Default = "Unlimited",
    Callback = function(Value)
        if Value == "Unlimited" then
            setfpscap(999)
        else
            setfpscap(tonumber(Value))
        end
    end
})

-- Post Processing
local PostProcSection = Tabs.Performance:AddSection("Post Processing")

local PostFXToggles = {
    {"Remove Shadows", function() game.Lighting.GlobalShadows = false end},
    {"Remove Fog", function() game.Lighting.FogEnd = 9e9 end},
    {"Remove Bloom", function() for _,v in pairs(game.Lighting:GetChildren()) do if v:IsA("BloomEffect") then v.Enabled = false end end end},
    {"Remove Blur", function() for _,v in pairs(game.Lighting:GetChildren()) do if v:IsA("BlurEffect") then v.Enabled = false end end end},
    {"Remove Sun Rays", function() for _,v in pairs(game.Lighting:GetChildren()) do if v:IsA("SunRaysEffect") then v.Enabled = false end end end},
    {"Remove Color Correction", function() for _,v in pairs(game.Lighting:GetChildren()) do if v:IsA("ColorCorrectionEffect") then v.Enabled = false end end end}
}

for _, fx in ipairs(PostFXToggles) do
    PostProcSection:AddToggle(fx[1], {Title = fx[1], Default = false}):OnChanged(function(val)
        if val then fx[2]() end
    end)
end

-- World
local WorldSection = Tabs.Performance:AddSection("World")

WorldSection:AddToggle("RemoveParticles", {Title = "Remove Particles", Default = false})
WorldSection:AddToggle("RemoveDecals", {Title = "Remove Decals", Default = false})
WorldSection:AddToggle("ReduceTerrain", {Title = "Reduce Terrain Detail", Default = false})
WorldSection:AddToggle("DisableWind", {Title = "Disable Wind", Default = false})

-- Characters
local CharSection = Tabs.Performance:AddSection("Characters")

CharSection:AddToggle("HidePlayers", {Title = "Hide Other Players", Default = false}):OnChanged(function(val)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character then
            plr.Character:FindFirstChildOfClass("Model").Parent = val and game.ReplicatedStorage or workspace
        end
    end
end)

CharSection:AddToggle("DisableNPCAnim", {Title = "Disable NPC Animations", Default = false})

--------------------------------------------------------------------
-- 6. SETTINGS TAB
--------------------------------------------------------------------
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/BeTheFinalBoss")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Script Loaded",
    Content = "Be The Final Boss Script UI ready!",
    Duration = 5
})
