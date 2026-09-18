--[[
    bgms3333 DEX FILE MANAGER & TERMINAL CONSOLE EMULATOR (STUDIO TESTING EDITION)
    - Full Preserved Engine & Logic
    - Modularized Features & Audio Systems
    - Executable Player, Map, Asset, and System Files in Dex Manager
    - Single Unified Script Architecture
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- CONFIGURATION & ASSET IDS
--------------------------------------------------------------------------------
local ASSETS = {
    FILE_LOGO = "rbxthumb://type=Asset&id=86057740398972&w=420&h=420",
    PARTICLE  = "rbxthumb://type=Asset&id=2230899832&w=420&h=420",
    DECAL     = "rbxthumb://type=Asset&id=13033901822&w=420&h=420",
    SKYBOX    = "rbxthumb://type=Asset&id=2609635738&w=420&h=420",
    MIXED     = "rbxthumb://type=Asset&id=179798724&w=420&h=420",
    OLD_ICON  = "rbxthumb://type=Asset&id=122998538&w=420&h=420",
    FACE      = "rbxthumb://type=Asset&id=631727250&w=420&h=420",
    MUSIC     = "rbxassetid://15689450026"
}

-- Responsive DPI Scaling Logic
local Camera = Workspace.CurrentCamera
local ScreenSize = Camera and Camera.ViewportSize or Vector2.new(1920, 1080)
local BaseHeight = 720
local ScaleFactor = math.clamp(ScreenSize.Y / BaseHeight, 0.55, 1.3)

local UIWidth = math.floor(540 * ScaleFactor)
local UIHeight = math.floor(360 * ScaleFactor)

--------------------------------------------------------------------------------
-- MODULAR FEATURE SUBSYSTEMS
--------------------------------------------------------------------------------
local Features = {}

-- 1. Anti-Fling Module
Features.AntiFling = {
    Apply = function(char)
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1)
                part.CanCollide = true
            end
        end
    end
}

-- 2. Jumpscare & Audio Overlay Module
Features.Jumpscare = {
    Gui = nil,
    Frame = nil,
    Sound = nil,
    Init = function(self)
        self.Gui = Instance.new("ScreenGui")
        self.Gui.Name = "JumpscareOverlay"
        self.Gui.DisplayOrder = 999
        self.Gui.ResetOnSpawn = false
        self.Gui.Parent = PlayerGui

        self.Frame = Instance.new("Frame")
        self.Frame.Size = UDim2.new(1, 0, 1, 0)
        self.Frame.BackgroundTransparency = 1
        self.Frame.Visible = false
        self.Frame.Parent = self.Gui

        local IconOverlay = Instance.new("ImageLabel")
        IconOverlay.Size = UDim2.new(0, math.floor(250 * ScaleFactor), 0, math.floor(250 * ScaleFactor))
        IconOverlay.Position = UDim2.new(0.5, -math.floor(125 * ScaleFactor), 0.5, -math.floor(125 * ScaleFactor))
        IconOverlay.Image = ASSETS.OLD_ICON
        IconOverlay.BackgroundTransparency = 1
        IconOverlay.Parent = self.Frame

        local JumpscareText = Instance.new("TextLabel")
        JumpscareText.Size = UDim2.new(1, 0, 0, math.floor(100 * ScaleFactor))
        JumpscareText.Position = UDim2.new(0, 0, 0.5, -math.floor(50 * ScaleFactor))
        JumpscareText.Text = "hacked by bigboomsme"
        JumpscareText.TextColor3 = Color3.fromRGB(255, 0, 0)
        JumpscareText.Font = Enum.Font.SourceSansBold
        JumpscareText.TextSize = math.floor(65 * ScaleFactor)
        JumpscareText.BackgroundTransparency = 1
        JumpscareText.BorderSizePixel = 0
        JumpscareText.ZIndex = 2
        JumpscareText.Parent = self.Frame

        self.Sound = Instance.new("Sound")
        self.Sound.SoundId = ASSETS.MUSIC
        self.Sound.Volume = 2
        self.Sound.Looped = true
        self.Sound.Parent = Workspace

        task.spawn(function()
            local phrases = { "hacked by bigboomsme", "cant you stop me hahaha", "allah sxk mY DCk" }
            local idx = 1
            while true do
                task.wait(0.12)
                if self.Frame.Visible then
                    IconOverlay.Visible = not IconOverlay.Visible
                    JumpscareText.Visible = not JumpscareText.Visible
                    if math.random(1, 6) == 1 then 
                        idx = (idx % #phrases) + 1 
                        JumpscareText.Text = phrases[idx] 
                    end 
                    JumpscareText.TextColor3 = (math.random(1, 2) == 1) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255) 
                end 
            end 
        end)
    end,
    Toggle = function(self)
        self.Frame.Visible = not self.Frame.Visible
        if self.Frame.Visible and not self.Sound.IsPlaying then
            self.Sound:Play()
        end
    end
}

-- 3. Advanced Fling Grab Module
Features.Grab = {
    Active = false,
    Target = nil,
    IsChoking = false,
    Btn = nil,
    Init = function(self)
        local GrabGui = Instance.new("ScreenGui")
        GrabGui.Name = "GrabControls"
        GrabGui.ResetOnSpawn = false
        GrabGui.Parent = PlayerGui

        self.Btn = Instance.new("ImageButton")
        self.Btn.Size = UDim2.new(0, math.floor(60 * ScaleFactor), 0, math.floor(60 * ScaleFactor))
        self.Btn.Position = UDim2.new(0.8, 0, 0.6, 0)
        self.Btn.Image = "rbxassetid://1095210207"
        self.Btn.Visible = false
        self.Btn.Parent = GrabGui

        task.spawn(function()
            while true do
                task.wait(0.2)
                if self.Active and not self.IsChoking then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= 12 then
                                    self.Target = plr.Character
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)

        self.Btn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if not char or not self.Target then return end
            local myRightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") 
            local myHRP = char:FindFirstChild("HumanoidRootPart") 
            local vHRP = self.Target:FindFirstChild("HumanoidRootPart") 
            
            if not self.IsChoking and vHRP and myRightArm then 
                self.IsChoking = true 
                local shoulder = char:FindFirstChild("Right Shoulder", true) 
                if shoulder then 
                    shoulder.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.rad(90), 0, 0) 
                end 
                local weld = Instance.new("Weld") 
                weld.Name = "ChokeHold" 
                weld.Part0 = myRightArm 
                weld.Part1 = vHRP 
                weld.C0 = CFrame.new(0, -1, -1) 
                weld.Parent = myRightArm 
            elseif self.IsChoking and vHRP then 
                local shoulder = char:FindFirstChild("Right Shoulder", true) 
                if shoulder then 
                    shoulder.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.rad(90), math.rad(-60), 0) 
                    task.wait(0.25) 
                    shoulder.C0 = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.rad(90), 0, 0) 
                end 
                if myRightArm:FindFirstChild("ChokeHold") then 
                    myRightArm.ChokeHold:Destroy() 
                end 
                local throwDir = myHRP.CFrame.LookVector * 9000 + Vector3.new(0, 4000, 0) 
                local bav = Instance.new("BodyAngularVelocity") 
                bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) 
                bav.AngularVelocity = Vector3.new(0, 999999, 0) 
                bav.Parent = vHRP 
                local bv = Instance.new("BodyVelocity") 
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) 
                bv.Velocity = throwDir 
                bv.Parent = vHRP 
                
                task.spawn(function() 
                    task.wait(0.2) 
                    bv:Destroy() 
                    bav:Destroy() 
                end) 
                self.IsChoking = false 
                self.Target = nil 
            end 
        end)
    end,
    Toggle = function(self)
        self.Active = not self.Active
        self.Btn.Visible = self.Active
    end
}

-- Initialize Core Services
if LocalPlayer.Character then Features.AntiFling.Apply(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(Features.AntiFling.Apply)
Features.Jumpscare:Init()
Features.Grab:Init()

--------------------------------------------------------------------------------
-- TERMINAL CONSOLE EMULATOR UI
--------------------------------------------------------------------------------
local TerminalGui = Instance.new("ScreenGui")
TerminalGui.Name = "bgms3333_Terminal"
TerminalGui.ResetOnSpawn = false
TerminalGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainTerminalFrame"
MainFrame.Size = UDim2.fromOffset(UIWidth, UIHeight)
MainFrame.Position = UDim2.new(0.5, -UIWidth/2, 0.5, -UIHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = TerminalGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, math.floor(26 * ScaleFactor))
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.Text = "Command Prompt - bgms3333"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = math.floor(13 * ScaleFactor)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, math.floor(26 * ScaleFactor), 1, 0)
CloseBtn.Position = UDim2.new(1, -math.floor(26 * ScaleFactor), 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CloseBtn.BorderSizePixel = 0
CloseBtn.Font = Enum.Font.Code
CloseBtn.TextSize = math.floor(13 * ScaleFactor)
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, -12, 1, -math.floor(58 * ScaleFactor))
ScrollContainer.Position = UDim2.new(0, 6, 0, math.floor(30 * ScaleFactor))
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollContainer.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 2)
UIList.Parent = ScrollContainer

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
    ScrollContainer.CanvasPosition = Vector2.new(0, UIList.AbsoluteContentSize.Y)
end)

local InputLine = Instance.new("Frame")
InputLine.Size = UDim2.new(1, -12, 0, math.floor(22 * ScaleFactor))
InputLine.Position = UDim2.new(0, 6, 1, -math.floor(26 * ScaleFactor))
InputLine.BackgroundTransparency = 1
InputLine.Parent = MainFrame

local PromptLabel = Instance.new("TextLabel")
PromptLabel.Size = UDim2.new(0, math.floor(85 * ScaleFactor), 1, 0)
PromptLabel.Text = "C:\\ROBLOX>"
PromptLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PromptLabel.Font = Enum.Font.Code
PromptLabel.TextSize = math.floor(12 * ScaleFactor)
PromptLabel.TextXAlignment = Enum.TextXAlignment.Left
PromptLabel.BackgroundTransparency = 1
PromptLabel.Parent = InputLine

local CommandInput = Instance.new("TextBox")
CommandInput.Size = UDim2.new(1, -math.floor(88 * ScaleFactor), 1, 0)
CommandInput.Position = UDim2.new(0, math.floor(85 * ScaleFactor), 0, 0)
CommandInput.Text = ""
CommandInput.PlaceholderText = "type /help for available commands..."
CommandInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
CommandInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CommandInput.Font = Enum.Font.Code
CommandInput.TextSize = math.floor(12 * ScaleFactor)
CommandInput.TextXAlignment = Enum.TextXAlignment.Left
CommandInput.BackgroundTransparency = 1
CommandInput.ClearTextOnFocus = false
CommandInput.Parent = InputLine

local lineOrder = 0
local function WriteLog(text, color)
    lineOrder = lineOrder + 1
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, math.floor(14 * ScaleFactor))
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Code
    label.TextSize = math.floor(11 * ScaleFactor)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.LayoutOrder = lineOrder
    label.Parent = ScrollContainer
    return label
end

local function AsyncProgressLog(taskName, assetInfo, speed, onComplete)
    task.spawn(function()
        WriteLog("[INFO] Initializing module: " .. taskName .. "...", Color3.fromRGB(200, 200, 200))
        if assetInfo then
            WriteLog("[ASSET] Target URI: " .. tostring(assetInfo), Color3.fromRGB(130, 130, 130))
        end
        local current = 0
        local logLine = WriteLog("[PROC] Progress: 0%", Color3.fromRGB(255, 255, 0))
        while current < 100 do
            local step = math.random(8, 25)
            current = math.min(100, current + step)
            logLine.Text = "[PROC] " .. taskName .. " -> Processing: " .. current .. "%"
            task.wait(speed or math.random(2, 6) / 100)
        end
        logLine.TextColor3 = Color3.fromRGB(0, 255, 0)
        logLine.Text = "[OK] " .. taskName .. " executed successfully. [0x" .. string.format("%X", math.random(0x1000, 0xFFFF)) .. "]"
        if onComplete then onComplete() end
    end)
end

local isInitialized = false
local function InitTerminalBoot()
    if isInitialized then return end
    isInitialized = true
    WriteLog("==================================================", Color3.fromRGB(100, 100, 100))
    WriteLog(" bgms3333 CONSOLE EMULATOR [Version 6.0.42]", Color3.fromRGB(255, 255, 255))
    WriteLog(" (c) 2026 bigboomsme Security System. All rights reserved.", Color3.fromRGB(150, 150, 150))
    WriteLog("==================================================", Color3.fromRGB(100, 100, 100))
    task.wait(0.15)
    WriteLog("[SYS] Connecting to place environment...", Color3.fromRGB(0, 200, 255))
    task.wait(0.1)
    local plist = {}
    for _, p in pairs(Players:GetPlayers()) do table.insert(plist, p.Name) end
    WriteLog("[ENV] Place ID: " .. tostring(game.PlaceId), Color3.fromRGB(180, 180, 180))
    WriteLog("[ENV] Local User: " .. LocalPlayer.Name .. " (" .. LocalPlayer.DisplayName .. ")", Color3.fromRGB(180, 180, 180))
    WriteLog("[ENV] Active Players (" .. #plist .. "): " .. table.concat(plist, ", "), Color3.fromRGB(180, 180, 180))
    WriteLog("[SYS] Deploying internal server modules...", Color3.fromRGB(255, 255, 0))
    
    local installSteps = { "Memory Hook Allocator", "Physics Anti-Fling Filter", "Visual Rendering Pipeline", "Network Packet Emulator" }
    for _, stepName in ipairs(installSteps) do
        local p = 0
        local lbl = WriteLog("[INSTALL] " .. stepName .. " -> 0%", Color3.fromRGB(180, 180, 180))
        while p < 100 do
            p = math.min(100, p + math.random(15, 35))
            lbl.Text = "[INSTALL] " .. stepName .. " -> " .. p .. "%"
            task.wait(0.03)
        end
        lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
        lbl.Text = "[OK] " .. stepName .. " Installed."
    end
    WriteLog("[SYS] Boot complete. Type /help to list available commands.", Color3.fromRGB(0, 255, 0))
end

LocalPlayer.Chatted:Connect(function(msg)
    if msg == ":bigboomsme:" then
        Features.Jumpscare:Toggle()
        WriteLog("[EVENT] Jumpscare triggered via local chat.", Color3.fromRGB(255, 0, 0))
    end
end)

-- Runtime States
local destructionActive = false
local spinningMap = false
local flying = false
local dislocating = false
local fogActive = false

local function ProcessCommand(cmd)
    cmd = string.lower(cmd)
    WriteLog("C:\\ROBLOX> " .. cmd, Color3.fromRGB(255, 255, 255))
    
    if cmd == "/help" then
        WriteLog("--- AVAILABLE TERMINAL COMMANDS ---", Color3.fromRGB(0, 200, 255))
        WriteLog("  /jumpscare    - Toggle Screamer overlay", Color3.fromRGB(200, 200, 200))
        WriteLog("  /music        - Play horror audio track", Color3.fromRGB(200, 200, 200))
        WriteLog("  /particle     - Inject particle & trails to parts", Color3.fromRGB(200, 200, 200))
        WriteLog("  /decal        - Apply decal & face texture spam", Color3.fromRGB(200, 200, 200))
        WriteLog("  /mixeddecal   - Apply alternate mixed decals", Color3.fromRGB(200, 200, 200))
        WriteLog("  /skybox       - Change skybox texture only", Color3.fromRGB(200, 200, 200))
        WriteLog("  /fog          - Toggle atmospheric fog effect", Color3.fromRGB(200, 200, 200))
        WriteLog("  /fire         - Spawn fire instances in map parts", Color3.fromRGB(200, 200, 200))
        WriteLog("  /destroy      - Toggle Destruction Engine mode", Color3.fromRGB(200, 200, 200))
        WriteLog("  /spin         - Toggle Map & Terrain Spin engine", Color3.fromRGB(200, 200, 200))
        WriteLog("  /fly          - Toggle Admin Fly engine", Color3.fromRGB(200, 200, 200))
        WriteLog("  /dislocate    - Toggle c00lkid Jitter effect", Color3.fromRGB(200, 200, 200))
        WriteLog("  /grab         - Toggle Grab Mode controller", Color3.fromRGB(200, 200, 200))
        WriteLog("  /r6           - Re-rig character model to R6", Color3.fromRGB(200, 200, 200))
        WriteLog("  /r15          - Re-rig character model to R15", Color3.fromRGB(200, 200, 200))
        WriteLog("  /punch        - Load FE Punch script", Color3.fromRGB(200, 200, 200))
        WriteLog("  /knife        - Load Universal Grab Knife script", Color3.fromRGB(200, 200, 200))
        WriteLog("  /rejoin       - Rejoin current game server", Color3.fromRGB(200, 200, 200))
        WriteLog("  /cls          - Clear console log screen", Color3.fromRGB(200, 200, 200))
        
    elseif cmd == "/jumpscare" then
        AsyncProgressLog("Jumpscare_Overlay", ASSETS.OLD_ICON, 0.02, function()
            Features.Jumpscare:Toggle()
            WriteLog("[SYS] Jumpscare state: " .. tostring(Features.Jumpscare.Frame.Visible), Color3.fromRGB(255, 0, 0))
        end)
        
    elseif cmd == "/music" then
        AsyncProgressLog("Horror_Audio_Stream", ASSETS.MUSIC, 0.03, function()
            if not Features.Jumpscare.Sound.IsPlaying then Features.Jumpscare.Sound:Play() end
            WriteLog("[AUDIO] Playing ID: " .. ASSETS.MUSIC, Color3.fromRGB(0, 255, 0))
        end)
        
    elseif cmd == "/particle" then
        AsyncProgressLog("Particle_Trail_Emitter", ASSETS.PARTICLE, 0.04, function()
            local count = 0
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    count = count + 1
                    local p = Instance.new("ParticleEmitter", v)
                    p.Texture = ASSETS.PARTICLE
                    p.Rate = 60
                    p.Speed = NumberRange.new(5, 12)

                    local tr = Instance.new("Trail", v) 
                    local a0 = Instance.new("Attachment", v) 
                    local a1 = Instance.new("Attachment", v) 
                    a1.Position = Vector3.new(0, 2, 0) 
                    tr.Attachment0 = a0 
                    tr.Attachment1 = a1 
                    tr.Texture = ASSETS.PARTICLE 
                    tr.Lifetime = 0.6 
                end 
            end
            WriteLog("[WARN] Injected particles into " .. count .. " BaseParts.", Color3.fromRGB(255, 150, 0))
        end)
        
    elseif cmd == "/decal" then
        AsyncProgressLog("Decal_Face_Overrider", ASSETS.DECAL, 0.03, function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                        local d = Instance.new("Decal")
                        d.Texture = ASSETS.DECAL
                        d.Face = face
                        d.Parent = obj
                    end
                end
            end
            for _, plr in pairs(Players:GetPlayers()) do 
                if plr.Character then 
                    for _, child in pairs(plr.Character:GetDescendants()) do 
                        if child:IsA("Decal") and child.Name == "face" then child:Destroy() end 
                    end 
                    local head = plr.Character:FindFirstChild("Head") 
                    if head then 
                        local f = Instance.new("Decal") 
                        f.Name = "face" 
                        f.Texture = ASSETS.FACE 
                        f.Parent = head 
                    end 
                end 
            end
            WriteLog("[SYS] Decal texture and faces updated globally.", Color3.fromRGB(0, 255, 0))
        end)
        
    elseif cmd == "/mixeddecal" then
        AsyncProgressLog("Mixed_Decal_Spam", ASSETS.MIXED, 0.03, function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                        local d = Instance.new("Decal")
                        d.Texture = ASSETS.MIXED
                        d.Face = face
                        d.Parent = obj
                    end
                end
            end
            WriteLog("[SYS] Alternate mixed decals deployed.", Color3.fromRGB(0, 255, 0))
        end)
        
    elseif cmd == "/skybox" then
        AsyncProgressLog("Skybox_Environment_Modifier", ASSETS.SKYBOX, 0.03, function()
            for _, v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
            local sky = Instance.new("Sky")
            sky.SkyboxBk = ASSETS.SKYBOX; sky.SkyboxDn = ASSETS.SKYBOX; sky.SkyboxFt = ASSETS.SKYBOX
            sky.SkyboxLf = ASSETS.SKYBOX; sky.SkyboxRt = ASSETS.SKYBOX; sky.SkyboxUp = ASSETS.SKYBOX
            sky.Parent = Lighting
            WriteLog("[WORLD] Skybox texture ID " .. ASSETS.SKYBOX .. " applied.", Color3.fromRGB(0, 255, 0))
        end)

    elseif cmd == "/fog" then
        fogActive = not fogActive
        AsyncProgressLog("Atmospheric_Fog_Engine", nil, 0.02, function()
            if fogActive then
                Lighting.FogEnd = 150
                task.spawn(function()
                    while fogActive do
                        Lighting.FogColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
                        task.wait(0.2)
                    end
                end)
                WriteLog("[WORLD] Dynamic Atmospheric Fog Enabled.", Color3.fromRGB(0, 255, 0))
            else
                Lighting.FogEnd = 100000
                WriteLog("[WORLD] Atmospheric Fog Disabled.", Color3.fromRGB(255, 100, 0))
            end
        end)
        
    elseif cmd == "/fire" then
        AsyncProgressLog("Map_Fire_Engine", nil, 0.02, function()
            local fc = 0
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    fc = fc + 1
                    local fire = Instance.new("Fire")
                    fire.Size = 10; fire.Heat = 15; fire.Parent = part
                end
            end
            WriteLog("[WORLD] Spawned fire on " .. fc .. " parts.", Color3.fromRGB(255, 100, 0))
        end)
        
    elseif cmd == "/destroy" then
        destructionActive = not destructionActive
        WriteLog("[ENGINE] Destruction Engine status: " .. tostring(destructionActive), Color3.fromRGB(255, 255, 0))
        if destructionActive then
            local char = LocalPlayer.Character
            if char and char.PrimaryPart then
                char.PrimaryPart.Touched:Connect(function(hit) 
                    if destructionActive and hit and not hit:IsDescendantOf(char) and not hit.Parent:FindFirstChildOfClass("Humanoid") then 
                        hit.Anchored = false 
                        local exp = Instance.new("Explosion") 
                        exp.Position = hit.Position; exp.BlastRadius = 10; exp.BlastPressure = 500000; exp.Parent = Workspace 
                        hit:BreakJoints(); hit.Velocity = Vector3.new(math.random(-50,50), 50, math.random(-50,50)) 
                    end 
                end) 
            end
        end
        
    elseif cmd == "/spin" then
        spinningMap = not spinningMap
        WriteLog("[ENGINE] Terrain Spin Engine: " .. tostring(spinningMap), Color3.fromRGB(255, 255, 0))
        if spinningMap then
            task.spawn(function()
                local angleX, angleZ = 0, 0
                while spinningMap do
                    task.wait(0.03)
                    angleX = angleX + math.rad(math.random(1, 3))
                    angleZ = angleZ + math.rad(math.random(-2, 2))
                    for _, part in pairs(Workspace:GetDescendants()) do 
                        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) and not part.Anchored then 
                            part.CFrame = part.CFrame * CFrame.Angles(angleX * 0.01, 0, angleZ * 0.01) 
                        end 
                    end 
                    Workspace.Gravity = math.random(10, 196) 
                end 
                Workspace.Gravity = 196.2 
            end)
        end
        
    elseif cmd == "/fly" then
        flying = not flying
        WriteLog("[PHYSICS] Admin Fly State: " .. tostring(flying), Color3.fromRGB(0, 255, 255))
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if flying then 
                local bv = Instance.new("BodyVelocity") 
                bv.Name = "FlyVelocity"; bv.MaxForce = Vector3.new(1e9, 1e9, 1e9); bv.Parent = hrp 
                task.spawn(function() 
                    while flying do 
                        task.wait() 
                        local hum = char:FindFirstChildOfClass("Humanoid") 
                        if hum then bv.Velocity = hum.MoveDirection * 50 + Vector3.new(0, 0.5, 0) end 
                    end 
                    bv:Destroy() 
                end) 
            end
        end
        
    elseif cmd == "/dislocate" then
        dislocating = not dislocating
        WriteLog("[RIG] Part Dislocation (c00lkid Jitter): " .. tostring(dislocating), Color3.fromRGB(255, 0, 255))
        local char = LocalPlayer.Character
        if char and dislocating then
            task.spawn(function() 
                while dislocating do 
                    task.wait(0.05) 
                    for _, part in pairs(char:GetChildren()) do 
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                            local joint = part:FindFirstChildOfClass("JointInstance") 
                            if joint then 
                                joint.C0 = CFrame.new(math.random(-3, 3), math.random(-2, 2), math.random(-3, 3)) * CFrame.Angles(math.rad(math.random(-45, 45)), math.rad(math.random(-45, 45)), 0) 
                            end 
                        end 
                    end 
                end 
            end)
        end
        
    elseif cmd == "/grab" then
        Features.Grab:Toggle()
        WriteLog("[SYSTEM] Fling Grab Mode: " .. tostring(Features.Grab.Active), Color3.fromRGB(0, 255, 0))
        
    elseif cmd == "/r6" then
        AsyncProgressLog("Rig_Transformer_R6", nil, 0.02, function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
            end
            WriteLog("[RIG] R6 Dead-state transformation dispatched.", Color3.fromRGB(255, 0, 0))
        end)
        
    elseif cmd == "/r15" then
        AsyncProgressLog("Rig_Transformer_R15", nil, 0.02, function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):BuildRigFromAttachments()
            end
            WriteLog("[RIG] R15 Rig built from attachments.", Color3.fromRGB(0, 255, 0))
        end)
        
    elseif cmd == "/punch" then
        AsyncProgressLog("External_FE_Punch", "raw.githubusercontent.com/0Ben1/fe", 0.04, function()
            loadstring(game:HttpGet(('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'),true))()
            WriteLog("[EXT] FE Punch script executed.", Color3.fromRGB(0, 255, 0))
        end)
        
    elseif cmd == "/knife" then
        AsyncProgressLog("External_Grab_Knife", "rawscripts.net/raw/Universal-Script", 0.04, function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Grab-knife-v4-or-v5-NOT-FE-133552"))()
            WriteLog("[EXT] Universal Grab Knife script executed.", Color3.fromRGB(0, 255, 0))
        end)
        
    elseif cmd == "/rejoin" then
        WriteLog("[SYS] Teleporting to place ID " .. game.PlaceId .. "...", Color3.fromRGB(255, 255, 0))
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
        
    elseif cmd == "/cls" then
        for _, child in pairs(ScrollContainer:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        lineOrder = 0
        
    else
        WriteLog("[ERROR] ' " .. cmd .. " ' is not recognized as an internal command.", Color3.fromRGB(255, 80, 80))
        WriteLog("Type /help for a list of valid terminal commands.", Color3.fromRGB(180, 180, 180))
    end
end

CommandInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local txt = CommandInput.Text
        if txt and #txt > 0 then
            ProcessCommand(txt)
            CommandInput.Text = ""
        end
    end
end)

--------------------------------------------------------------------------------
-- DEX FILE MANAGER SYSTEM (WINDOWS SYSTEM OVERLAY)
--------------------------------------------------------------------------------
local DexGui = Instance.new("ScreenGui")
DexGui.Name = "DexFileManager"
DexGui.ResetOnSpawn = false
DexGui.Parent = PlayerGui

local DexFrame = Instance.new("Frame")
DexFrame.Name = "DexMainFrame"
DexFrame.Size = UDim2.fromOffset(math.floor(580 * ScaleFactor), math.floor(380 * ScaleFactor))
DexFrame.Position = UDim2.new(0.5, -math.floor(290 * ScaleFactor), 0.5, -math.floor(190 * ScaleFactor))
DexFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
DexFrame.BorderSizePixel = 1
DexFrame.BorderColor3 = Color3.fromRGB(160, 160, 160)
DexFrame.Active = true
DexFrame.Draggable = true
DexFrame.Parent = DexGui

local DexTitle = Instance.new("Frame")
DexTitle.Size = UDim2.new(1, 0, 0, math.floor(28 * ScaleFactor))
DexTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DexTitle.BorderSizePixel = 0
DexTitle.Parent = DexFrame

local DexTitleText = Instance.new("TextLabel")
DexTitleText.Size = UDim2.new(1, -30, 1, 0)
DexTitleText.Position = UDim2.new(0, 10, 0, 0)
DexTitleText.Text = "Dex File Explorer - C:\\System32\\bgms3333"
DexTitleText.TextColor3 = Color3.fromRGB(40, 40, 40)
DexTitleText.Font = Enum.Font.SourceSans
DexTitleText.TextSize = math.floor(14 * ScaleFactor)
DexTitleText.TextXAlignment = Enum.TextXAlignment.Left
DexTitleText.BackgroundTransparency = 1
DexTitleText.Parent = DexTitle

local DexClose = Instance.new("TextButton")
DexClose.Size = UDim2.new(0, math.floor(28 * ScaleFactor), 1, 0)
DexClose.Position = UDim2.new(1, -math.floor(28 * ScaleFactor), 0, 0)
DexClose.Text = "X"
DexClose.TextColor3 = Color3.fromRGB(80, 80, 80)
DexClose.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
DexClose.BorderSizePixel = 0
DexClose.Font = Enum.Font.SourceSansBold
DexClose.TextSize = math.floor(14 * ScaleFactor)
DexClose.Parent = DexTitle

DexClose.MouseButton1Click:Connect(function() DexFrame.Visible = false end)

local PathBar = Instance.new("Frame")
PathBar.Size = UDim2.new(1, -16, 0, math.floor(22 * ScaleFactor))
PathBar.Position = UDim2.new(0, 8, 0, math.floor(32 * ScaleFactor))
PathBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PathBar.BorderColor3 = Color3.fromRGB(200, 200, 200)
PathBar.BorderSizePixel = 1
PathBar.Parent = DexFrame

local PathText = Instance.new("TextLabel")
PathText.Size = UDim2.new(1, -10, 1, 0)
PathText.Position = UDim2.new(0, 8, 0, 0)
PathText.Text = "C:\\bgms3333_root\\"
PathText.TextColor3 = Color3.fromRGB(60, 60, 60)
PathText.Font = Enum.Font.SourceSans
PathText.TextSize = math.floor(12 * ScaleFactor)
PathText.TextXAlignment = Enum.TextXAlignment.Left
PathText.BackgroundTransparency = 1
PathText.Parent = PathBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, math.floor(130 * ScaleFactor), 1, -math.floor(64 * ScaleFactor))
Sidebar.Position = UDim2.new(0, 8, 0, math.floor(58 * ScaleFactor))
Sidebar.BackgroundColor3 = Color3.fromRGB(248, 248, 248)
Sidebar.BorderColor3 = Color3.fromRGB(220, 220, 220)
Sidebar.BorderSizePixel = 1
Sidebar.Parent = DexFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 4)
SidebarList.Parent = Sidebar

local LoadFolderView

local function AddSidebarItem(name, targetFolder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, math.floor(22 * ScaleFactor))
    btn.Text = "  > " .. name
    btn.TextColor3 = Color3.fromRGB(50, 50, 50)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = math.floor(12 * ScaleFactor)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    btn.MouseButton1Click:Connect(function() if targetFolder then LoadFolderView(targetFolder) end end)
    return btn
end

local FileArea = Instance.new("ScrollingFrame")
FileArea.Size = UDim2.new(1, -math.floor(154 * ScaleFactor), 1, -math.floor(64 * ScaleFactor))
FileArea.Position = UDim2.new(0, math.floor(144 * ScaleFactor), 0, math.floor(58 * ScaleFactor))
FileArea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FileArea.BorderColor3 = Color3.fromRGB(220, 220, 220)
FileArea.BorderSizePixel = 1
FileArea.ScrollBarThickness = 5
FileArea.CanvasSize = UDim2.new(0, 0, 0, 0)
FileArea.Parent = DexFrame

local UIGrid = Instance.new("UIGridLayout")
UIGrid.CellSize = UDim2.new(0, math.floor(100 * ScaleFactor), 0, math.floor(80 * ScaleFactor))
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UIGrid.SortOrder = Enum.SortOrder.LayoutOrder
UIGrid.Parent = FileArea

UIGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FileArea.CanvasSize = UDim2.new(0, 0, 0, UIGrid.AbsoluteContentSize.Y + 15)
end)

local function ShowInstallPopup(fileName, fileFormat, onFinish)
    local instGui = Instance.new("Frame")
    instGui.Size = UDim2.new(0, math.floor(340 * ScaleFactor), 0, math.floor(180 * ScaleFactor))
    instGui.Position = UDim2.new(0.5, -math.floor(170 * ScaleFactor), 0.5, -math.floor(90 * ScaleFactor))
    instGui.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    instGui.BorderColor3 = Color3.fromRGB(160, 160, 160)
    instGui.BorderSizePixel = 1
    instGui.ZIndex = 20
    instGui.Parent = DexFrame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, math.floor(24 * ScaleFactor))
    topBar.BackgroundColor3 = Color3.fromRGB(0, 102, 204)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 21
    topBar.Parent = instGui

    local topTitle = Instance.new("TextLabel")
    topTitle.Size = UDim2.new(1, -10, 1, 0)
    topTitle.Position = UDim2.new(0, 8, 0, 0)
    topTitle.Text = "System Executable Setup - " .. fileName
    topTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    topTitle.Font = Enum.Font.SourceSansBold
    topTitle.TextSize = math.floor(12 * ScaleFactor)
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.BackgroundTransparency = 1
    topTitle.ZIndex = 22
    topTitle.Parent = topBar

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -20, 0, math.floor(18 * ScaleFactor))
    nameLbl.Position = UDim2.new(0, 10, 0, math.floor(32 * ScaleFactor))
    nameLbl.Text = "File Name: " .. fileName
    nameLbl.TextColor3 = Color3.fromRGB(30, 30, 30)
    nameLbl.Font = Enum.Font.SourceSansBold
    nameLbl.TextSize = math.floor(12 * ScaleFactor)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.BackgroundTransparency = 1
    nameLbl.ZIndex = 21
    nameLbl.Parent = instGui

    local formatLbl = Instance.new("TextLabel")
    formatLbl.Size = UDim2.new(1, -20, 0, math.floor(18 * ScaleFactor))
    formatLbl.Position = UDim2.new(0, 10, 0, math.floor(50 * ScaleFactor))
    formatLbl.Text = "File Format: " .. fileFormat
    formatLbl.TextColor3 = Color3.fromRGB(100, 100, 100)
    formatLbl.Font = Enum.Font.SourceSans
    formatLbl.TextSize = math.floor(11 * ScaleFactor)
    formatLbl.TextXAlignment = Enum.TextXAlignment.Left
    formatLbl.BackgroundTransparency = 1
    formatLbl.ZIndex = 21
    formatLbl.Parent = instGui

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, math.floor(18 * ScaleFactor))
    barBg.Position = UDim2.new(0, 10, 0, math.floor(78 * ScaleFactor))
    barBg.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
    barBg.BorderColor3 = Color3.fromRGB(160, 160, 160)
    barBg.BorderSizePixel = 1
    barBg.ZIndex = 21
    barBg.Parent = instGui

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 22
    barFill.Parent = barBg

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -20, 0, math.floor(18 * ScaleFactor))
    statusLbl.Position = UDim2.new(0, 10, 0, math.floor(102 * ScaleFactor))
    statusLbl.Text = "Status: Preparing installation..."
    statusLbl.TextColor3 = Color3.fromRGB(60, 60, 60)
    statusLbl.Font = Enum.Font.SourceSansItalic
    statusLbl.TextSize = math.floor(11 * ScaleFactor)
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.BackgroundTransparency = 1
    statusLbl.ZIndex = 21
    statusLbl.Parent = instGui

    local toXXXBtn = Instance.new("TextButton")
    toXXXBtn.Size = UDim2.new(0, math.floor(100 * ScaleFactor), 0, math.floor(26 * ScaleFactor))
    toXXXBtn.Position = UDim2.new(0.5, -math.floor(50 * ScaleFactor), 1, -math.floor(34 * ScaleFactor))
    toXXXBtn.Text = "To XXX"
    toXXXBtn.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
    toXXXBtn.BorderColor3 = Color3.fromRGB(150, 150, 150)
    toXXXBtn.Font = Enum.Font.SourceSansBold
    toXXXBtn.TextSize = math.floor(12 * ScaleFactor)
    toXXXBtn.ZIndex = 22
    toXXXBtn.Parent = instGui

    local isFinished = false
    local function TriggerFinish()
        if isFinished then return end
        isFinished = true
        instGui:Destroy()
        if onFinish then onFinish() end
    end

    toXXXBtn.MouseButton1Click:Connect(TriggerFinish)

    task.spawn(function()
        local pct = 0
        while pct < 100 do
            task.wait(math.random(2, 5) / 50)
            pct = math.min(100, pct + math.random(5, 15))
            barFill.Size = UDim2.new(pct / 100, 0, 1, 0)
            statusLbl.Text = "Status: Installing (" .. pct .. "%)..."
        end
        statusLbl.Text = "Status: Installation Complete."
        statusLbl.TextColor3 = Color3.fromRGB(0, 150, 0)
        task.wait(0.3)
        TriggerFinish()
    end)
end

--------------------------------------------------------------------------------
-- VIRTUAL DEX FILE SYSTEM STRUCTURE (UPDATED WITH ALL EXECUTABLE COMMANDS)
--------------------------------------------------------------------------------
local FileTree = {
    ["Root"] = {
        Path = "C:\\bgms3333_root\\",
        Items = {
            {name = "command prompt.lua", icon = ASSETS.FILE_LOGO, isExe = true, isFolder = false, format = "LUA Executable Script", cmd = nil},
            {name = "/skybox.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/skybox"},
            {name = "/fog.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/fog"},
            {name = "/jumpscare.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/jumpscare"},
            {name = "/music.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/music"},
            {name = "/particle.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/particle"},
            {name = "/fly.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/fly"},
            {name = "/decal.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/decal"},
            {name = "/mixeddecal.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/mixeddecal"},
            {name = "/fire.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/fire"},
            {name = "/destroy.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/destroy"},
            {name = "/spin.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/spin"},
            {name = "/grab.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/grab"},
            {name = "/dislocate.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/dislocate"},
            {name = "/punch.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/punch"},
            {name = "/knife.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/knife"},
            {name = "/r6.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/r6"},
            {name = "/r15.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/r15"},
            {name = "/rejoin.sh", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Shell Script (.sh)", cmd = "/rejoin"},
            {name = "Assets", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Assets"},
            {name = "PlaceData", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "PlaceData"},
            {name = "Players", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Players"},
            {name = "System32", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "System32"}
        }
    },
    ["Assets"] = {
        Path = "C:\\bgms3333_root\\Assets\\",
        Items = {
            {name = ".. [Back]", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Root"},
            {name = "particle_id.dat", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Data File (.dat)", assetAction = function() ProcessCommand("/particle") end},
            {name = "skybox_id.dat", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Data File (.dat)", assetAction = function() ProcessCommand("/skybox") end},
            {name = "music_track.dat", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Audio File (.dat)", assetAction = function() ProcessCommand("/music") end}
        }
    },
    ["PlaceData"] = {
        Path = "C:\\bgms3333_root\\PlaceData\\",
        Items = {
            {name = ".. [Back]", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Root"},
            {name = "place_id.info", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Info File (.info)", assetAction = function()
                MainFrame.Visible = true
                InitTerminalBoot()
                WriteLog("[INFO] Current Place ID: " .. tostring(game.PlaceId), Color3.fromRGB(0, 255, 255))
            end}
        }
    },
    ["Players"] = {
        Path = "C:\\bgms3333_root\\Players\\",
        Items = {
            {name = ".. [Back]", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Root"}
        }
    },
    ["System32"] = {
        Path = "C:\\bgms3333_root\\System32\\",
        Items = {
            {name = ".. [Back]", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Root"},
            {name = "kernel.sys", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "System File (.sys)", assetAction = function()
                MainFrame.Visible = true
                InitTerminalBoot()
                WriteLog("[KERNEL] bgms3333 Core System Operating Normally.", Color3.fromRGB(0, 255, 0))
            end},
            {name = "net_driver.dll", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = false, format = "Dynamic Link Library (.dll)", assetAction = function()
                MainFrame.Visible = true
                InitTerminalBoot()
                WriteLog("[DLL] Hooked network driver successfully.", Color3.fromRGB(0, 255, 0))
            end}
        }
    }
}

-- Populate Player files dynamically with full execution capability
local function RefreshPlayerFiles()
    FileTree["Players"].Items = {
        {name = ".. [Back]", icon = ASSETS.FILE_LOGO, isExe = false, isFolder = true, target = "Root"}
    }
    for _, p in pairs(Players:GetPlayers()) do
        table.insert(FileTree["Players"].Items, {
            name = p.Name .. ".usr",
            icon = ASSETS.FILE_LOGO,
            isExe = false,
            isFolder = false,
            format = "User Account Profile (.usr)",
            assetAction = function()
                MainFrame.Visible = true
                InitTerminalBoot()
                WriteLog("[USER EXEC] Target Player: " .. p.Name .. " | UserId: " .. p.UserId .. " | AccountAge: " .. p.AccountAge .. " days", Color3.fromRGB(255, 255, 0))
            end
        })
    end
end

RefreshPlayerFiles()
Players.PlayerAdded:Connect(RefreshPlayerFiles)
Players.PlayerRemoving:Connect(RefreshPlayerFiles)

local function CreateFileItem(name, iconId, isExe, isFolder, targetFolder, fileFormat, boundCmd, assetAction)
    local item = Instance.new("TextButton")
    item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    item.BorderSizePixel = 0
    item.Text = ""
    item.Parent = FileArea
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, math.floor(36 * ScaleFactor), 0, math.floor(36 * ScaleFactor))
    icon.Position = UDim2.new(0.5, -math.floor(18 * ScaleFactor), 0, math.floor(6 * ScaleFactor))
    icon.Image = iconId
    icon.BackgroundTransparency = 1
    icon.Parent = item
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -4, 0, math.floor(30 * ScaleFactor))
    lbl.Position = UDim2.new(0, 2, 0, math.floor(44 * ScaleFactor))
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(30, 30, 30)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = math.floor(11 * ScaleFactor)
    lbl.TextWrapped = true
    lbl.BackgroundTransparency = 1
    lbl.Parent = item
    
    item.MouseButton1Click:Connect(function()
        if isFolder and targetFolder then
            LoadFolderView(targetFolder)
        elseif isExe then
            ShowInstallPopup(name, fileFormat or "LUA Script Executable", function()
                MainFrame.Visible = true
                InitTerminalBoot()
            end)
        elseif boundCmd then
            ShowInstallPopup(name, fileFormat or "Shell Executable Script", function()
                MainFrame.Visible = true
                InitTerminalBoot()
                ProcessCommand(boundCmd)
            end)
        elseif assetAction then
            ShowInstallPopup(name, fileFormat or "Data Stream File", function()
                assetAction()
            end)
        end
    end)
end

LoadFolderView = function(folderKey)
    local folderData = FileTree[folderKey]
    if not folderData then return end
    for _, child in pairs(FileArea:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    PathText.Text = folderData.Path
    for _, itemData in ipairs(folderData.Items) do
        CreateFileItem(
            itemData.name, 
            itemData.icon, 
            itemData.isExe, 
            itemData.isFolder, 
            itemData.target, 
            itemData.format, 
            itemData.cmd,
            itemData.assetAction
        )
    end
end

-- POPULATE DEX FILE SYSTEM SIDEBAR ITEMS
AddSidebarItem("Quick Access", "Root")
AddSidebarItem("System32", "System32")
AddSidebarItem("Assets", "Assets")
AddSidebarItem("PlaceData", "PlaceData")
AddSidebarItem("Players", "Players")

-- INITIALIZE ROOT DIRECTORY VIEW
LoadFolderView("Root")
