--[[
    Modern Hub - ESP Full + Teleport Player
    Keybind: Right Ctrl (bật/tắt ESP)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer

-- ==================== CÀI ĐẶT ====================
_G.FriendColor = Color3.fromRGB(0, 170, 255)
_G.EnemyColor = Color3.fromRGB(255, 50, 50)
_G.UseTeamColor = true
_G.ESPEnabled = true

-- ==================== TẠO GUI CHÍNH ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Modern Hub - ESP & TP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

-- Tab Buttons
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, -20, 0, 40)
TabFrame.Position = UDim2.new(0, 10, 0, 55)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local ESPTab = Instance.new("TextButton")
ESPTab.Size = UDim2.new(0.5, -5, 1, 0)
ESPTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
ESPTab.Text = "ESP"
ESPTab.TextColor3 = Color3.new(1,1,1)
ESPTab.Font = Enum.Font.GothamBold
ESPTab.TextSize = 15
ESPTab.Parent = TabFrame

local TPTab = Instance.new("TextButton")
TPTab.Size = UDim2.new(0.5, -5, 1, 0)
TPTab.Position = UDim2.new(0.5, 5, 0, 0)
TPTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
TPTab.Text = "Teleport"
TPTab.TextColor3 = Color3.new(1,1,1)
TPTab.Font = Enum.Font.GothamBold
TPTab.TextSize = 15
TPTab.Parent = TabFrame

-- Content Frames
local ESPContent = Instance.new("Frame")
ESPContent.Size = UDim2.new(1, -20, 1, -110)
ESPContent.Position = UDim2.new(0, 10, 0, 105)
ESPContent.BackgroundTransparency = 1
ESPContent.Visible = true
ESPContent.Parent = MainFrame

local TPContent = Instance.new("Frame")
TPContent.Size = UDim2.new(1, -20, 1, -110)
TPContent.Position = UDim2.new(0, 10, 0, 105)
TPContent.BackgroundTransparency = 1
TPContent.Visible = false
TPContent.Parent = MainFrame

-- ==================== ESP SECTION ====================
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0, 70, 0, 35)
ToggleFrame.Position = UDim2.new(0.5, -35, 0, 20)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
ToggleFrame.Parent = ESPContent

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleFrame

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 29, 0, 29)
ToggleCircle.Position = UDim2.new(1, -32, 0.5, -14.5)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleCircle.Parent = ToggleFrame

local ToggleCircleCorner = Instance.new("UICorner")
ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
ToggleCircleCorner.Parent = ToggleCircle

local ESPStatus = Instance.new("TextLabel")
ESPStatus.Size = UDim2.new(1, 0, 0, 30)
ESPStatus.Position = UDim2.new(0, 0, 0, 70)
ESPStatus.BackgroundTransparency = 1
ESPStatus.Text = "ESP: ENABLED"
ESPStatus.TextColor3 = Color3.fromRGB(0, 255, 120)
ESPStatus.Font = Enum.Font.GothamBold
ESPStatus.TextSize = 16
ESPStatus.Parent = ESPContent

-- ==================== TELEPORT SECTION ====================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = TPContent

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ScrollingFrame

local teleportTarget = nil
local SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Size = UDim2.new(1, 0, 0, 40)
SelectedPlayerLabel.Position = UDim2.new(0, 0, 1, -45)
SelectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SelectedPlayerLabel.Text = "Chưa chọn người chơi"
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SelectedPlayerLabel.Font = Enum.Font.Gotham
SelectedPlayerLabel.TextSize = 14
SelectedPlayerLabel.Parent = TPContent

local TPButton = Instance.new("TextButton")
TPButton.Size = UDim2.new(1, 0, 0, 40)
TPButton.Position = UDim2.new(0, 0, 1, -90)
TPButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
TPButton.Text = "TELEPORT NGAY"
TPButton.TextColor3 = Color3.new(1,1,1)
TPButton.Font = Enum.Font.GothamBold
TPButton.TextSize = 16
TPButton.Parent = TPContent

-- ==================== ESP FUNCTIONS ====================
local function createESP(character, player)
    if character:FindFirstChild("ModernESP") then return end

    local folder = Instance.new("Folder")
    folder.Name = "ModernESP"
    folder.Parent = character

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Adornee = character
    hl.FillColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = folder

    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = character
    box.Size = Vector3.new(2, 4, 2)
    box.Transparency = 0.65
    box.AlwaysOnTop = true
    box.Parent = folder

    -- Billboard
    local bill = Instance.new("BillboardGui")
    bill.Adornee = character:WaitForChild("Head")
    bill.Size = UDim2.new(0, 220, 0, 80)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.AlwaysOnTop = true
    bill.Parent = folder

    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1,0,0,25)
    name.BackgroundTransparency = 1
    name.Text = player.Name
    name.TextColor3 = Color3.new(1,1,1)
    name.TextStrokeTransparency = 0.5
    name.Font = Enum.Font.GothamBold
    name.TextSize = 17
    name.Parent = bill

    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1,0,0,10)
    healthBg.Position = UDim2.new(0,0,0,30)
    healthBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    healthBg.Parent = bill

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1,0,1,0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0,255,100)
    healthFill.Parent = healthBg

    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1,0,0,20)
    healthText.Position = UDim2.new(0,0,0,45)
    healthText.BackgroundTransparency = 1
    healthText.Text = "100"
    healthText.TextColor3 = Color3.new(1,1,1)
    healthText.Font = Enum.Font.Gotham
    healthText.TextSize = 14
    healthText.Parent = bill

    return {Highlight = hl, Box = box, HealthFill = healthFill, HealthText = healthText, Name = name}
end

local function updateESP(player)
    if player == plr or not player.Character then return end
    local color = _G.UseTeamColor and player.TeamColor.Color or (plr.TeamColor == player.TeamColor and _G.FriendColor or _G.EnemyColor)

    local esp = player.Character:FindFirstChild("ModernESP")
    if not esp then
        esp = createESP(player.Character, player)
    end

    if esp then
        esp.Highlight.FillColor = color
        esp.Box.Color3 = color
        esp.Name.TextColor3 = color

        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            local percent = hum.Health / hum.MaxHealth
            esp.HealthFill.Size = UDim2.new(percent, 0, 1, 0)
            esp.HealthText.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
            
            if percent > 0.6 then esp.HealthFill.BackgroundColor3 = Color3.fromRGB(0,255,100)
            elseif percent > 0.3 then esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255,200,0)
            else esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255,60,60) end
        end
    end
end

local function removeESP(player)
    if player.Character then
        local esp = player.Character:FindFirstChild("ModernESP")
        if esp then esp:Destroy() end
    end
end

local function refreshESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr then updateESP(p) end
    end
end

-- ==================== TAB SWITCHING ====================
local function switchTab(tab)
    if tab == "ESP" then
        ESPContent.Visible = true
        TPContent.Visible = false
        ESPTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        TPTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    else
        ESPContent.Visible = false
        TPContent.Visible = true
        ESPTab.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        TPTab.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    end
end

ESPTab.MouseButton1Click:Connect(function() switchTab("ESP") end)
TPTab.MouseButton1Click:Connect(function() switchTab("TP") end)

-- ==================== TOGGLE ESP ====================
local function toggleESP()
    _G.ESPEnabled = not _G.ESPEnabled
    if _G.ESPEnabled then
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        TweenService:Create(ToggleCircle, TweenInfo.new(0.25), {Position = UDim2.new(1, -32, 0.5, -14.5)}):Play()
        ESPStatus.Text = "ESP: ENABLED"
        ESPStatus.TextColor3 = Color3.fromRGB(0, 255, 120)
        refreshESP()
    else
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        TweenService:Create(ToggleCircle, TweenInfo.new(0.25), {Position = UDim2.new(0, 3, 0.5, -14.5)}):Play()
        ESPStatus.Text = "ESP: DISABLED"
        ESPStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        for _, p in pairs(Players:GetPlayers()) do removeESP(p) end
    end
end

ToggleFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleESP()
    end
end)

-- Keybind Right Ctrl
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleESP()
    end
end)

-- ==================== TELEPORT FUNCTIONS ====================
local function updatePlayerList()
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= plr then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.Text = "  " .. player.Name
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 15
            btn.Parent = ScrollingFrame

            btn.MouseButton1Click:Connect(function()
                teleportTarget = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                SelectedPlayerLabel.Text = "Đã chọn: " .. player.Name
                SelectedPlayerLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end)
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

TPButton.MouseButton1Click:Connect(function()
    if teleportTarget and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = teleportTarget.CFrame + Vector3.new(0, 4, 0)
    end
end)

-- ==================== CONNECTIONS ====================
Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    updatePlayerList()
    if _G.ESPEnabled then refreshESP() end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    updatePlayerList()
end)

-- Update health realtime
RunService.Heartbeat:Connect(function()
    if not _G.ESPEnabled then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character then
            updateESP(p)
        end
    end
end)

-- Load ban đầu
task.wait(1)
updatePlayerList()
refreshESP()

print("Modern Hub (ESP + Teleport) loaded successfully! Nhấn Right Ctrl để bật/tắt ESP.")
