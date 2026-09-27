-- Peppine Executor
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Asset ID
local LOGO_ID = "rbxthumb://type=Asset&id=280367934&w=150&h=150"

-- ScreenGui Main Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PeppineExecutorGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

---------------------------------------------------------
-- MAIN FRAME
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 540, 0, 320)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(160, 160, 160)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210))
})
UIGradient.Rotation = 90
UIGradient.Parent = MainFrame

---------------------------------------------------------
-- HEADER & LOGO
---------------------------------------------------------
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
Header.BorderSizePixel = 1
Header.BorderColor3 = Color3.fromRGB(180, 180, 180)
Header.Parent = MainFrame

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 245, 245)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
})
HeaderGradient.Rotation = 90
HeaderGradient.Parent = Header

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 28, 0, 28)
Logo.Position = UDim2.new(0, 5, 0, 3.5)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_ID
Logo.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "peppine executor"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(40, 40, 40)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -55, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
MinimizeBtn.BorderColor3 = Color3.fromRGB(150, 150, 150)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 18
MinimizeBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 100, 100)
CloseBtn.BorderColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header

---------------------------------------------------------
-- LEFT NAVIGATION BAR
---------------------------------------------------------
local LeftSpaceFrame = Instance.new("Frame")
LeftSpaceFrame.Name = "LeftSpaceFrame"
LeftSpaceFrame.Size = UDim2.new(0, 35, 0, 270)
LeftSpaceFrame.Position = UDim2.new(0, 8, 0, 42)
LeftSpaceFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
LeftSpaceFrame.BorderColor3 = Color3.fromRGB(180, 180, 180)
LeftSpaceFrame.Parent = MainFrame

local NavList = Instance.new("UIListLayout")
NavList.Parent = LeftSpaceFrame
NavList.SortOrder = Enum.SortOrder.LayoutOrder
NavList.Padding = UDim.new(0, 5)

local ExecNavBtn = Instance.new("TextButton")
ExecNavBtn.Name = "ExecNavBtn"
ExecNavBtn.Size = UDim2.new(1, 0, 0, 35)
ExecNavBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
ExecNavBtn.BorderColor3 = Color3.fromRGB(180, 180, 180)
ExecNavBtn.Text = "EXE"
ExecNavBtn.Font = Enum.Font.SourceSansBold
ExecNavBtn.TextSize = 11
ExecNavBtn.TextColor3 = Color3.fromRGB(40, 40, 40)
ExecNavBtn.Parent = LeftSpaceFrame

local ScriptNavBtn = Instance.new("TextButton")
ScriptNavBtn.Name = "ScriptNavBtn"
ScriptNavBtn.Size = UDim2.new(1, 0, 0, 35)
ScriptNavBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
ScriptNavBtn.BorderColor3 = Color3.fromRGB(180, 180, 180)
ScriptNavBtn.Text = "HUB"
ScriptNavBtn.Font = Enum.Font.SourceSansBold
ScriptNavBtn.TextSize = 11
ScriptNavBtn.TextColor3 = Color3.fromRGB(40, 40, 40)
ScriptNavBtn.Parent = LeftSpaceFrame

---------------------------------------------------------
-- EXECUTOR PAGE
---------------------------------------------------------
local ExecutorPage = Instance.new("Frame")
ExecutorPage.Name = "ExecutorPage"
ExecutorPage.Size = UDim2.new(0, 485, 0, 270)
ExecutorPage.Position = UDim2.new(0, 48, 0, 42)
ExecutorPage.BackgroundTransparency = 1
ExecutorPage.Parent = MainFrame

local ExecutorLabel = Instance.new("TextLabel")
ExecutorLabel.Name = "ExecutorLabel"
ExecutorLabel.Size = UDim2.new(0, 75, 0, 18)
ExecutorLabel.Position = UDim2.new(0, 0, 0, 0)
ExecutorLabel.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
ExecutorLabel.BorderColor3 = Color3.fromRGB(180, 180, 180)
ExecutorLabel.Text = "executor"
ExecutorLabel.Font = Enum.Font.SourceSans
ExecutorLabel.TextSize = 13
ExecutorLabel.TextColor3 = Color3.fromRGB(50, 50, 50)
ExecutorLabel.Parent = ExecutorPage

local CodeContainer = Instance.new("Frame")
CodeContainer.Name = "CodeContainer"
CodeContainer.Size = UDim2.new(0, 305, 0, 205)
CodeContainer.Position = UDim2.new(0, 0, 0, 23)
CodeContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CodeContainer.BorderColor3 = Color3.fromRGB(170, 170, 170)
CodeContainer.ClipsDescendants = true
CodeContainer.Parent = ExecutorPage

local CodeBox = Instance.new("TextBox")
CodeBox.Name = "CodeBox"
CodeBox.Size = UDim2.new(1, -10, 1, -10)
CodeBox.Position = UDim2.new(0, 5, 0, 5)
CodeBox.BackgroundTransparency = 1
CodeBox.Text = "-- Enter Lua script here\nprint('Hello Peppine Executor!')"
CodeBox.TextColor3 = Color3.fromRGB(0, 0, 0)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 14
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.Parent = CodeContainer

local ButtonFrame = Instance.new("Frame")
ButtonFrame.Name = "ButtonFrame"
ButtonFrame.Size = UDim2.new(0, 305, 0, 35)
ButtonFrame.Position = UDim2.new(0, 0, 0, 233)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = ExecutorPage

local function createClassicButton(name, text, pos, size, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    btn.BorderColor3 = Color3.fromRGB(150, 150, 150)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(30, 30, 30)
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210))
    })
    grad.Rotation = 90
    grad.Parent = btn
    
    btn.Parent = parent
    return btn
end

local ExecuteBtn = createClassicButton("ExecuteBtn", "Execute", UDim2.new(0, 0, 0, 0), UDim2.new(0, 70, 0, 30), ButtonFrame)
local ClearBtn   = createClassicButton("ClearBtn", "Clear", UDim2.new(0, 75, 0, 0), UDim2.new(0, 70, 0, 30), ButtonFrame)
local R6Btn      = createClassicButton("R6Btn", "R6", UDim2.new(0, 150, 0, 0), UDim2.new(0, 70, 0, 30), ButtonFrame)
local ReBtn      = createClassicButton("ReBtn", "Rejoin", UDim2.new(0, 225, 0, 0), UDim2.new(0, 80, 0, 30), ButtonFrame)

-- Right Side Panel for Popular Scripts
local ScriptListFrame = Instance.new("ScrollingFrame")
ScriptListFrame.Name = "ScriptListFrame"
ScriptListFrame.Size = UDim2.new(0, 172, 0, 245)
ScriptListFrame.Position = UDim2.new(0, 313, 0, 23)
ScriptListFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
ScriptListFrame.BorderColor3 = Color3.fromRGB(170, 170, 170)
ScriptListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScriptListFrame.ScrollBarThickness = 6
ScriptListFrame.Parent = ExecutorPage

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScriptListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

---------------------------------------------------------
-- SCRIPTS HUB PAGE (ScriptBlox API & Search)
---------------------------------------------------------
local HubPage = Instance.new("Frame")
HubPage.Name = "HubPage"
HubPage.Size = UDim2.new(0, 485, 0, 270)
HubPage.Position = UDim2.new(0, 48, 0, 42)
HubPage.BackgroundTransparency = 1
HubPage.Visible = false
HubPage.Parent = MainFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(0, 395, 0, 25)
SearchBox.Position = UDim2.new(0, 0, 0, 0)
SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.BorderColor3 = Color3.fromRGB(170, 170, 170)
SearchBox.PlaceholderText = "Search scripts on ScriptBlox..."
SearchBox.Text = ""
SearchBox.Font = Enum.Font.SourceSans
SearchBox.TextSize = 14
SearchBox.TextColor3 = Color3.fromRGB(0, 0, 0)
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = HubPage

local SearchBtn = createClassicButton("SearchBtn", "Search", UDim2.new(0, 400, 0, 0), UDim2.new(0, 85, 0, 25), HubPage)

local HubScroll = Instance.new("ScrollingFrame")
HubScroll.Name = "HubScroll"
HubScroll.Size = UDim2.new(1, 0, 0, 235)
HubScroll.Position = UDim2.new(0, 0, 0, 32)
HubScroll.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
HubScroll.BorderColor3 = Color3.fromRGB(170, 170, 170)
HubScroll.ScrollBarThickness = 6
HubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
HubScroll.Parent = HubPage

local UIGridLayout = Instance.new("UIGridLayout")
UIGridLayout.Parent = HubScroll
UIGridLayout.CellSize = UDim2.new(0, 232, 0, 105)
UIGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

---------------------------------------------------------
-- CIRCLE TOGGLE BUTTON
---------------------------------------------------------
local CircleContainer = Instance.new("Frame")
CircleContainer.Name = "CircleContainer"
CircleContainer.Size = UDim2.new(0, 100, 0, 100)
CircleContainer.Position = UDim2.new(0.1, 0, 0.1, 0)
CircleContainer.BackgroundTransparency = 1
CircleContainer.Visible = false
CircleContainer.Parent = ScreenGui

local OuterDashedRing = Instance.new("Frame")
OuterDashedRing.Name = "OuterDashedRing"
OuterDashedRing.Size = UDim2.new(1, 0, 1, 0)
OuterDashedRing.Position = UDim2.new(0, 0, 0, 0)
OuterDashedRing.BackgroundTransparency = 1
OuterDashedRing.Parent = CircleContainer

local segmentCount = 12
for i = 1, segmentCount do
    local angle = (i - 1) * (360 / segmentCount)
    local rad = math.rad(angle)
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 8, 0, 3)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.new(0.5 + math.cos(rad) * 0.46, 0, 0.5 + math.sin(rad) * 0.46, 0)
    line.Rotation = angle
    line.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    line.BorderSizePixel = 0
    line.Parent = OuterDashedRing
end

local CircleIcon = Instance.new("ImageButton")
CircleIcon.Name = "CircleIcon"
CircleIcon.Size = UDim2.new(0, 80, 0, 80)
CircleIcon.Position = UDim2.new(0.5, -40, 0.5, -40)
CircleIcon.BackgroundTransparency = 1
CircleIcon.Image = LOGO_ID
CircleIcon.Parent = CircleContainer

RunService.RenderStepped:Connect(function(dt)
    if CircleContainer.Visible then
        OuterDashedRing.Rotation = (OuterDashedRing.Rotation + 100 * dt) % 360
    end
end)

---------------------------------------------------------
-- NAVIGATION SYSTEM
---------------------------------------------------------
ExecNavBtn.MouseButton1Click:Connect(function()
    ExecutorPage.Visible = true
    HubPage.Visible = false
    ExecNavBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    ScriptNavBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
end)

ScriptNavBtn.MouseButton1Click:Connect(function()
    ExecutorPage.Visible = false
    HubPage.Visible = true
    ScriptNavBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    ExecNavBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
end)

---------------------------------------------------------
-- SCRIPTBLOX API FUNCTIONALITY
---------------------------------------------------------
local function fetchScriptBloxData(query, isRightPanel)
    local targetContainer = isRightPanel and ScriptListFrame or HubScroll
    for _, child in ipairs(targetContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end

    task.spawn(function()
        local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query)
        local response
        pcall(function()
            response = game:HttpGet(url)
        end)

        if not response then return end
        local success, data = pcall(function() return HttpService:JSONDecode(response) end)
        if not success or not data or not data.result or not data.result.scripts then return end

        for _, scriptData in ipairs(data.result.scripts) do
            local scriptTitle = scriptData.title or "Untitled"
            local rawScript = scriptData.script or ""
            local gameName = (scriptData.game and scriptData.game.name) or "Universal"
            local scriptType = scriptData.isKeySystem and "Key System" or "Free"

            if isRightPanel then
                local btn = Instance.new("TextButton")
                btn.Name = scriptTitle
                btn.Size = UDim2.new(1, -8, 0, 25)
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.BorderColor3 = Color3.fromRGB(180, 180, 180)
                btn.Text = scriptTitle
                btn.Font = Enum.Font.SourceSans
                btn.TextSize = 13
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                btn.Parent = ScriptListFrame

                btn.MouseButton1Click:Connect(function()
                    CodeBox.Text = rawScript
                end)
            else
                local card = Instance.new("Frame")
                card.Name = "ScriptCard"
                card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                card.BorderColor3 = Color3.fromRGB(180, 180, 180)
                card.Parent = HubScroll

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -10, 0, 18)
                titleLbl.Position = UDim2.new(0, 5, 0, 4)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Text = scriptTitle
                titleLbl.Font = Enum.Font.SourceSansBold
                titleLbl.TextSize = 13
                titleLbl.TextColor3 = Color3.fromRGB(30, 30, 30)
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Parent = card

                local gameLbl = Instance.new("TextLabel")
                gameLbl.Size = UDim2.new(1, -10, 0, 15)
                gameLbl.Position = UDim2.new(0, 5, 0, 22)
                gameLbl.BackgroundTransparency = 1
                gameLbl.Text = "Game: " .. gameName
                gameLbl.Font = Enum.Font.SourceSans
                gameLbl.TextSize = 11
                gameLbl.TextColor3 = Color3.fromRGB(90, 90, 90)
                gameLbl.TextXAlignment = Enum.TextXAlignment.Left
                gameLbl.Parent = card

                local typeLbl = Instance.new("TextLabel")
                typeLbl.Size = UDim2.new(1, -10, 0, 15)
                typeLbl.Position = UDim2.new(0, 5, 0, 37)
                typeLbl.BackgroundTransparency = 1
                typeLbl.Text = "Type: " .. scriptType
                typeLbl.Font = Enum.Font.SourceSans
                typeLbl.TextSize = 11
                typeLbl.TextColor3 = Color3.fromRGB(90, 90, 90)
                typeLbl.TextXAlignment = Enum.TextXAlignment.Left
                typeLbl.Parent = card

                local execBtn = createClassicButton("ExecBtn", "Execute", UDim2.new(0, 5, 0, 58), UDim2.new(0, 105, 0, 22), card)
                local copyBtn = createClassicButton("CopyBtn", "Copy", UDim2.new(0, 118, 0, 58), UDim2.new(0, 105, 0, 22), card)

                execBtn.MouseButton1Click:Connect(function()
                    local func, err = loadstring(rawScript)
                    if func then
                        task.spawn(func)
                    else
                        warn("Execution Error: " .. tostring(err))
                    end
                end)

                copyBtn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        setclipboard(rawScript)
                    else
                        CodeBox.Text = rawScript
                    end
                end)
            end
        end
    end)
end

-- Search Events
SearchBtn.MouseButton1Click:Connect(function()
    fetchScriptBloxData(SearchBox.Text, false)
end)

SearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        fetchScriptBloxData(SearchBox.Text, false)
    end
end)

-- Initial Searches
task.spawn(function()
    fetchScriptBloxData("c00lkidd gui", true)
    fetchScriptBloxData("k00pkidd", true)
    fetchScriptBloxData("tubers93", true)
    fetchScriptBloxData("FE", false)
end)

---------------------------------------------------------
-- UI INTERACTION EVENTS
---------------------------------------------------------
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local cDragging, cDragStart, cStartPos
CircleIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        cDragging = true
        cDragStart = input.Position
        cStartPos = CircleContainer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                cDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if cDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - cDragStart
        local newPos = UDim2.new(cStartPos.X.Scale, cStartPos.X.Offset + delta.X, cStartPos.Y.Scale, cStartPos.Y.Offset + delta.Y)
        local moveDeltaX = delta.X
        local targetRotation = CircleIcon.Rotation + (moveDeltaX > 0 and 15 or -15)
        
        CircleContainer.Position = newPos
        TweenService:Create(CircleIcon, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Rotation = targetRotation}):Play()
    end
end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 540, 0, 35)
    else
        MainFrame.Size = UDim2.new(0, 540, 0, 320)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    CircleContainer.Visible = true
end)

CircleIcon.MouseButton1Click:Connect(function()
    if not cDragging then
        MainFrame.Visible = true
        CircleContainer.Visible = false
    end
end)

ExecuteBtn.MouseButton1Click:Connect(function()
    local code = CodeBox.Text
    local func, err = loadstring(code)
    if func then
        task.spawn(func)
    else
        warn("Execution Error: " .. tostring(err))
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    CodeBox.Text = ""
end)

R6Btn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/roblox-scripts/r6-converter/main/script.lua", true))()
    end
end)

ReBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
