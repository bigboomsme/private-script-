--[[
BOOMSME ALL-IN-ONE SCRIPT (FLING GRAB ENGINE) - ARABIC NOSTALGIA EDITION
- Asset ID updates (Decal, Particle, Skybox, Wallpaper, Mixed Decal)
- Fully Translated Executor UI (Old-School Arabic style with standard Latin script text)
- Screamer / Jumpscare Block Screen (Flashes, center text changing, icon overlay)
- Corrected Victim Fling Engine (Target launches, LocalPlayer stays grounded)
- Map Spin / Terrain Gravity Rotation Engine
- Classic c00lkid Body Dislocation / Glitch Motion
- 2x2 Grid Button Layout Engine
- Custom Loadstring Integrations (Punch & Knife)
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ASSETS CONFIGURATION

local ID_WALLPAPER = "rbxthumb://type=Asset&id=104586069215296&w=420&h=420"
local ID_PARTICLE = "rbxthumb://type=Asset&id=7147513&w=420&h=420"
local ID_DECAL = "rbxthumb://type=Asset&id=97766949589075&w=420&h=420"
local ID_SKYBOX = "rbxthumb://type=Asset&id=104586069215296&w=420&h=420"
local ID_MIXED = "rbxthumb://type=Asset&id=14069750105&w=420&h=420"
local ID_OLD_ICON = "rbxthumb://type=Asset&id=122998538&w=420&h=420"
local ID_FACE = "rbxthumb://type=Asset&id=631727250&w=420&h=420"
local ID_MUSIC = "rbxassetid://15689450026"

-- 1. ANTI-FLING SYSTEM (SELF PROTECTION)

local function ApplyAntiFling(char)
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1)
            part.CanCollide = true
        end
    end
end

if LocalPlayer.Character then ApplyAntiFling(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(ApplyAntiFling)

-- 2. RC7 EXECUTOR GUI BUILDER (OLD ARABIC STYLE)

local Rc7ScreenGui = Instance.new("ScreenGui")
Rc7ScreenGui.Name = "RC7_Executor_Arabic"
Rc7ScreenGui.ResetOnSpawn = false
Rc7ScreenGui.Parent = PlayerGui

local Rc7Main = Instance.new("ImageLabel")
Rc7Main.Name = "MainFrame"
Rc7Main.Size = UDim2.new(0, 350, 0, 250)
Rc7Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Rc7Main.Image = ID_WALLPAPER
Rc7Main.Active = true
Rc7Main.Draggable = true
Rc7Main.Parent = Rc7ScreenGui

local Rc7Title = Instance.new("TextLabel")
Rc7Title.Size = UDim2.new(1, 0, 0, 25)
Rc7Title.Text = "مُشَغِّلُ الْأَكْوَادِ (RC7 Old Arabic)"
Rc7Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Rc7Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Rc7Title.BackgroundTransparency = 0.3
Rc7Title.Font = Enum.Font.SourceSansBold
Rc7Title.TextSize = 16
Rc7Title.Parent = Rc7Main

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(0.68, 0, 0.6, 0)
InputBox.Position = UDim2.new(0.04, 0, 0.15, 0)
InputBox.Text = ""
InputBox.PlaceholderText = "تَنْفِيذُ الْأَمْرِ هُنَا..."
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InputBox.MultiLine = true
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.TextYAlignment = Enum.TextYAlignment.Top
InputBox.Parent = Rc7Main

local function CreateButton(name, text, pos, size, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = text
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = parent
    return btn
end

local BtnExecute = CreateButton("Execute", "تَنْفِيذ (Execute)", UDim2.new(0.75, 0, 0.15, 0), UDim2.new(0.23, 0, 0.1, 0), Rc7Main)
local BtnClear = CreateButton("Clear", "مَسْح (Clear)", UDim2.new(0.75, 0, 0.27, 0), UDim2.new(0.23, 0, 0.1, 0), Rc7Main)
local BtnR6 = CreateButton("R6", "R6", UDim2.new(0.75, 0, 0.39, 0), UDim2.new(0.23, 0, 0.1, 0), Rc7Main)
local BtnR15 = CreateButton("R15", "R15", UDim2.new(0.75, 0, 0.51, 0), UDim2.new(0.23, 0, 0.1, 0), Rc7Main)
local BtnRJ = CreateButton("RJ", "إِعَادَة (Rejoin)", UDim2.new(0.75, 0, 0.63, 0), UDim2.new(0.23, 0, 0.1, 0), Rc7Main)
local BtnDelete = CreateButton("Delete", "حَذْفُ (Delete GUI)", UDim2.new(0.04, 0, 0.8, 0), UDim2.new(0.43, 0, 0.12, 0), Rc7Main)
local BtnNewSession= CreateButton("NewSession", "جَلْسَةٌ جَدِيدَة", UDim2.new(0.5, 0, 0.8, 0), UDim2.new(0.48, 0, 0.12, 0), Rc7Main)

-- 3. MAIN GUI (c00lkid STYLE - EXTENDED 2x2 GRID SYSTEM)

local CoolGui = Instance.new("ScreenGui")
CoolGui.Name = "boomsme_c00lkid"
CoolGui.Enabled = false
CoolGui.ResetOnSpawn = false
CoolGui.Parent = PlayerGui

local CoolMain = Instance.new("ImageLabel")
CoolMain.Name = "MainFrame"
CoolMain.Size = UDim2.new(0, 280, 0, 280)
CoolMain.Position = UDim2.new(0.05, 0, 0.15, 0)
CoolMain.Image = ID_WALLPAPER
CoolMain.Active = true
CoolMain.Draggable = true
CoolMain.Parent = CoolGui

local ProfileIcon = Instance.new("ImageLabel")
ProfileIcon.Size = UDim2.new(0, 30, 0, 30)
ProfileIcon.Position = UDim2.new(0.04, 0, 0.02, 0)
ProfileIcon.Image = ID_OLD_ICON
ProfileIcon.BackgroundTransparency = 1
ProfileIcon.Parent = CoolMain

local CoolTitle = Instance.new("TextLabel")
CoolTitle.Size = UDim2.new(0, 200, 0, 15)
CoolTitle.Position = UDim2.new(0.18, 0, 0.02, 0)
CoolTitle.Text = "boomsme GUI [v6.0]"
CoolTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
CoolTitle.Font = Enum.Font.SourceSansBold
CoolTitle.TextSize = 14
CoolTitle.TextXAlignment = Enum.TextXAlignment.Left
CoolTitle.BackgroundTransparency = 1
CoolTitle.Parent = CoolMain

local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(0, 200, 0, 15)
UserLabel.Position = UDim2.new(0.18, 0, 0.07, 0)
UserLabel.Text = "User: " .. LocalPlayer.Name
UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
UserLabel.Font = Enum.Font.SourceSans
UserLabel.TextSize = 12
UserLabel.TextXAlignment = Enum.TextXAlignment.Left
UserLabel.BackgroundTransparency = 1
UserLabel.Parent = CoolMain

-- 2x2 Grid Helper System
local buttonIndex = 0
local function CreateCoolBtn2x2(text)
    local col = buttonIndex % 2
    local row = math.floor(buttonIndex / 2)
    
    local xPos = (col == 0) and 0.04 or 0.52
    local yPos = 45 + (row * 30)
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.44, 0, 0, 26)
    btn.Position = UDim2.new(xPos, 0, 0, yPos)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.5
    btn.Parent = CoolMain
    
    buttonIndex = buttonIndex + 1
    return btn
end

-- 2x2 Button Grid Initialization
local BtnParticel = CreateCoolBtn2x2("Particle & Trails")
local BtnDecalSpam = CreateCoolBtn2x2("Decal & Face Spam")
local BtnMixedDecal = CreateCoolBtn2x2("Mixed Decal Spam")
local BtnSkybox = CreateCoolBtn2x2("Horror Skybox")
local BtnMusic = CreateCoolBtn2x2("Play Horror Music")
local BtnDislocate = CreateCoolBtn2x2("Dislocate Parts")
local BtnDestruction = CreateCoolBtn2x2("Destruction Engine")
local BtnFire = CreateCoolBtn2x2("Full Map Fire")
local BtnFly = CreateCoolBtn2x2("Admin Fly Engine")
local BtnSpinMap = CreateCoolBtn2x2("Spin Map/Terrain")
local BtnGrabMode = CreateCoolBtn2x2("Enable Grab Mode")
local BtnJumpscare = CreateCoolBtn2x2("Toggle Jumpscare")
local BtnPunch = CreateCoolBtn2x2("punch")
local BtnKnife = CreateCoolBtn2x2("Knife")

-- Adjust Frame Height to fit grid dynamically
CoolMain.Size = UDim2.new(0, 280, 0, 55 + (math.ceil(buttonIndex / 2) * 30))

-- 4. BORDERLESS JUMPSCARE & BANNER SCREEN

local JumpscareGui = Instance.new("ScreenGui")
JumpscareGui.Name = "JumpscareOverlay"
JumpscareGui.DisplayOrder = 999
JumpscareGui.ResetOnSpawn = false
JumpscareGui.Parent = PlayerGui

local JumpscareFrame = Instance.new("Frame")
JumpscareFrame.Size = UDim2.new(1, 0, 1, 0)
JumpscareFrame.BackgroundTransparency = 1
JumpscareFrame.Visible = false
JumpscareFrame.Parent = JumpscareGui

local IconOverlay = Instance.new("ImageLabel")
IconOverlay.Size = UDim2.new(0, 250, 0, 250)
IconOverlay.Position = UDim2.new(0.5, -125, 0.5, -125)
IconOverlay.Image = ID_OLD_ICON
IconOverlay.BackgroundTransparency = 1
IconOverlay.Parent = JumpscareFrame

local JumpscareText = Instance.new("TextLabel")
JumpscareText.Size = UDim2.new(1, 0, 0, 100)
JumpscareText.Position = UDim2.new(0, 0, 0.5, -50)
JumpscareText.Text = "hacked by bigboomsme"
JumpscareText.TextColor3 = Color3.fromRGB(255, 0, 0)
JumpscareText.Font = Enum.Font.SourceSansBold
JumpscareText.TextSize = 65
JumpscareText.BackgroundTransparency = 1
JumpscareText.BorderSizePixel = 0
JumpscareText.ZIndex = 2
JumpscareText.Parent = JumpscareFrame

local Sound = Instance.new("Sound")
Sound.SoundId = ID_MUSIC
Sound.Volume = 2
Sound.Looped = true
Sound.Parent = Workspace

-- Jumpscare Flashing & Text Switcher Loop
task.spawn(function()
    local phrases = {
        "hacked by bigboomsme",
        "cant you stop me hahaha",
        "allah sxk mY DCk"
    }
    local idx = 1
    while true do
        task.wait(0.12)
        if JumpscareFrame.Visible then
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

-- 5. FUNCTIONALITIES IMPLEMENTATION

local function OnChat(msg)
    if InputBox.Text == ":bigboomsme:" or msg == ":bigboomsme:" then
        CoolGui.Enabled = true
        JumpscareFrame.Visible = true
        if not Sound.IsPlaying then Sound:Play() end
    end
end

LocalPlayer.Chatted:Connect(OnChat)

BtnExecute.MouseButton1Click:Connect(function() OnChat(InputBox.Text) end)
BtnClear.MouseButton1Click:Connect(function() InputBox.Text = "" end)
BtnDelete.MouseButton1Click:Connect(function() Rc7ScreenGui:Destroy() end)
BtnNewSession.MouseButton1Click:Connect(function() InputBox.Text = "" CoolGui.Enabled = false end)
BtnRJ.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
BtnJumpscare.MouseButton1Click:Connect(function() JumpscareFrame.Visible = not JumpscareFrame.Visible end)

local function RigTransform(targetType)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if targetType == "R6" then
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        else
            hum:BuildRigFromAttachments()
        end
    end
end
BtnR6.MouseButton1Click:Connect(function() RigTransform("R6") end)
BtnR15.MouseButton1Click:Connect(function() RigTransform("R15") end)

-- Punch Loadstring Integration
BtnPunch.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/0Ben1/fe/main/obf_rf6iQURzu1fqrytcnLBAvW34C9N55kS9g9G3CKz086rC47M6632sEd4ZZYB0AYgV.lua.txt'),true))()
end)

-- Knife Loadstring Integration
BtnKnife.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Grab-knife-v4-or-v5-NOT-FE-133552"))()
end)

-- Particle Engine
BtnParticel.MouseButton1Click:Connect(function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local p = Instance.new("ParticleEmitter", v)
            p.Texture = ID_PARTICLE
            p.Rate = 60
            p.Speed = NumberRange.new(5, 12)

            local tr = Instance.new("Trail", v) 
            local a0 = Instance.new("Attachment", v) 
            local a1 = Instance.new("Attachment", v) 
            a1.Position = Vector3.new(0, 2, 0) 
            tr.Attachment0 = a0 
            tr.Attachment1 = a1 
            tr.Texture = ID_PARTICLE 
            tr.Lifetime = 0.6 
        end 
    end 
end)

-- Decal & Face Spam
BtnDecalSpam.MouseButton1Click:Connect(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                local d = Instance.new("Decal")
                d.Texture = ID_DECAL
                d.Face = face
                d.Parent = obj
            end
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do 
        if plr.Character then 
            for _, child in pairs(plr.Character:GetDescendants()) do 
                if child:IsA("Decal") and child.Name == "face" then 
                    child:Destroy() 
                end 
            end 
            local head = plr.Character:FindFirstChild("Head") 
            if head then 
                local f = Instance.new("Decal") 
                f.Name = "face" 
                f.Texture = ID_FACE 
                f.Parent = head 
            end 
        end 
    end 
end)

-- Mixed Decal Spam
BtnMixedDecal.MouseButton1Click:Connect(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                local d = Instance.new("Decal")
                d.Texture = ID_MIXED
                d.Face = face
                d.Parent = obj
            end
        end
    end
end)

-- Horror Skybox
BtnSkybox.MouseButton1Click:Connect(function()
    for _, v in pairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
    local sky = Instance.new("Sky")
    sky.SkyboxBk = ID_SKYBOX
    sky.SkyboxDn = ID_SKYBOX
    sky.SkyboxFt = ID_SKYBOX
    sky.SkyboxLf = ID_SKYBOX
    sky.SkyboxRt = ID_SKYBOX
    sky.SkyboxUp = ID_SKYBOX
    sky.Parent = Lighting

    task.spawn(function() 
        Lighting.FogEnd = 150 
        while task.wait(0.2) do 
            Lighting.FogColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)) 
        end 
    end) 
end)

BtnMusic.MouseButton1Click:Connect(function()
    if not Sound.IsPlaying then Sound:Play() end
end)

-- c00lkid Body Dislocation / Jitter Engine
local dislocating = false
BtnDislocate.MouseButton1Click:Connect(function()
    dislocating = not dislocating
    local char = LocalPlayer.Character
    if not char then return end

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
end)

-- Destruction Engine
local destructionActive = false
BtnDestruction.MouseButton1Click:Connect(function()
    destructionActive = not destructionActive
    if destructionActive then
        local char = LocalPlayer.Character
        if not char then return end

        char.PrimaryPart.Touched:Connect(function(hit) 
            if destructionActive and hit and not hit:IsDescendantOf(char) and not hit.Parent:FindFirstChildOfClass("Humanoid") then 
                hit.Anchored = false 
                local exp = Instance.new("Explosion") 
                exp.Position = hit.Position 
                exp.BlastRadius = 10 
                exp.BlastPressure = 500000 
                exp.Parent = Workspace 
                hit:BreakJoints() 
                hit.Velocity = Vector3.new(math.random(-50,50), 50, math.random(-50,50)) 
            end 
        end) 
    end 
end)

-- Map Fire
BtnFire.MouseButton1Click:Connect(function()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local fire = Instance.new("Fire")
            fire.Size = 10
            fire.Heat = 15
            fire.Parent = part
        end
    end
end)

-- Fly Engine
local flying = false
BtnFly.MouseButton1Click:Connect(function()
    flying = not flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flying then 
        local bv = Instance.new("BodyVelocity") 
        bv.Name = "FlyVelocity" 
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9) 
        bv.Parent = hrp 
        task.spawn(function() 
            while flying do 
                task.wait() 
                local hum = char:FindFirstChildOfClass("Humanoid") 
                if hum then 
                    bv.Velocity = hum.MoveDirection * 50 + Vector3.new(0, 0.5, 0) 
                end 
            end 
            bv:Destroy() 
        end) 
    end 
end)

-- Map Spin & Gravity Rotation Engine
local spinningMap = false
BtnSpinMap.MouseButton1Click:Connect(function()
    spinningMap = not spinningMap
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
end)

-- 6. ADVANCED FLING GRAB SYSTEM (FIXED VICTIM FLING)

local grabModeActive = false
local GrabGui = Instance.new("ScreenGui")
GrabGui.Name = "GrabControls"
GrabGui.Parent = PlayerGui

local GrabActionBtn = Instance.new("ImageButton")
GrabActionBtn.Size = UDim2.new(0, 60, 0, 60)
GrabActionBtn.Position = UDim2.new(0.8, 0, 0.6, 0)
GrabActionBtn.Image = "rbxassetid://1095210207"
GrabActionBtn.Visible = false
GrabActionBtn.Parent = GrabGui

local targetVictim = nil
local isChoking = false

BtnGrabMode.MouseButton1Click:Connect(function()
    grabModeActive = not grabModeActive
    GrabActionBtn.Visible = grabModeActive
end)

-- Target Detection System
task.spawn(function()
    while true do
        task.wait(0.2)
        if grabModeActive and not isChoking then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= 12 then
                            targetVictim = plr.Character
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Execute Grab & Target Fling
GrabActionBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not targetVictim then return end

    local myRightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") 
    local myHRP = char:FindFirstChild("HumanoidRootPart") 
    local vHRP = targetVictim:FindFirstChild("HumanoidRootPart") 
    
    if not isChoking and vHRP and myRightArm then 
        isChoking = true 
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
    elseif isChoking and vHRP then 
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
        isChoking = false 
        targetVictim = nil 
    end 
end)