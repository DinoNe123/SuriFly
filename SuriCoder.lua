--[[
    🔥 PREMIUM HUB v2 - CỰC ĐẸP & MƯỢT MÀ
    Thiết kế sang trọng • Dark Luxury Theme • Gradient + Stroke + Hover + Tween mượt
    3 Tab: ESP • Teleport • Fly
    ESP đã bỏ hoàn toàn thanh máu (chỉ còn Highlight + Box 3D + NameTag đẹp)
    Fly: Toggle + Speed điều chỉnh realtime
    Keybind: Right Ctrl (bật/tắt ESP)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer

-- ==================== CÀI ĐẶT ====================
_G.FriendColor = Color3.fromRGB(0, 200, 255)
_G.EnemyColor = Color3.fromRGB(255, 60, 60)
_G.UseTeamColor = true
_G.ESPEnabled = true

-- ==================== TẠO GUI PREMIUM ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SCxSuri"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0.5, -180, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Stroke ngoài + góc bo cao cấp
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 180, 255)
MainStroke.Thickness = 2.5
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Title Bar Gradient
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TitleBar.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 40, 90))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.Parent = TitleBar

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 50)
TabBar.Position = UDim2.new(0, 10, 0, 70)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 8)
TabList.Parent = TabBar

-- 3 Tab Buttons
local function CreateTabButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(255,255,255)
    btnStroke.Thickness = 1.5
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn

    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.15)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    return btn
end

local ESPTab   = CreateTabButton("ESP",      Color3.fromRGB(60, 160, 255))
local TPTab    = CreateTabButton("Teleport", Color3.fromRGB(80, 200, 80))
local FlyTab   = CreateTabButton("Fly",      Color3.fromRGB(200, 100, 255))

-- Content Frames
local ESPContent = Instance.new("Frame")
ESPContent.Size = UDim2.new(1, -20, 1, -140)
ESPContent.Position = UDim2.new(0, 10, 0, 130)
ESPContent.BackgroundTransparency = 1
ESPContent.Visible = true
ESPContent.Parent = MainFrame

local TPContent = Instance.new("Frame")
TPContent.Size = UDim2.new(1, -20, 1, -140)
TPContent.Position = UDim2.new(0, 10, 0, 130)
TPContent.BackgroundTransparency = 1
TPContent.Visible = false
TPContent.Parent = MainFrame

local FlyContent = Instance.new("Frame")
FlyContent.Size = UDim2.new(1, -20, 1, -140)
FlyContent.Position = UDim2.new(0, 10, 0, 130)
FlyContent.BackgroundTransparency = 1
FlyContent.Visible = false
FlyContent.Parent = MainFrame

-- ==================== ESP SECTION (KHÔNG CÒN THANH MÁU) ====================
local ESPSwitch = Instance.new("Frame")
ESPSwitch.Size = UDim2.new(0, 80, 0, 38)
ESPSwitch.Position = UDim2.new(0.5, -40, 0, 20)
ESPSwitch.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
ESPSwitch.Parent = ESPContent

local SwitchCorner = Instance.new("UICorner")
SwitchCorner.CornerRadius = UDim.new(1, 0)
SwitchCorner.Parent = ESPSwitch

local SwitchCircle = Instance.new("Frame")
SwitchCircle.Size = UDim2.new(0, 32, 0, 32)
SwitchCircle.Position = UDim2.new(1, -35, 0.5, -16)
SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SwitchCircle.Parent = ESPSwitch

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = SwitchCircle

local ESPStatus = Instance.new("TextLabel")
ESPStatus.Size = UDim2.new(1, 0, 0, 40)
ESPStatus.Position = UDim2.new(0, 0, 0, 75)
ESPStatus.BackgroundTransparency = 1
ESPStatus.Text = "ESP: ENABLED"
ESPStatus.TextColor3 = Color3.fromRGB(0, 255, 140)
ESPStatus.Font = Enum.Font.GothamBlack
ESPStatus.TextSize = 18
ESPStatus.Parent = ESPContent

-- ==================== TELEPORT SECTION ====================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -70)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Parent = TPContent

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1, 0, 0, 45)
SelectedLabel.Position = UDim2.new(0, 0, 1, -65)
SelectedLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
SelectedLabel.Text = "Chưa chọn người chơi"
SelectedLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
SelectedLabel.Font = Enum.Font.Gotham
SelectedLabel.TextSize = 15
SelectedLabel.Parent = TPContent

local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(1, 0, 0, 50)
TPBtn.Position = UDim2.new(0, 0, 1, -110)
TPBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
TPBtn.Text = "TELEPORT NGAY"
TPBtn.TextColor3 = Color3.new(1,1,1)
TPBtn.Font = Enum.Font.GothamBlack
TPBtn.TextSize = 18
TPBtn.Parent = TPContent

local TPBtnCorner = Instance.new("UICorner")
TPBtnCorner.CornerRadius = UDim.new(0, 12)
TPBtnCorner.Parent = TPBtn

-- ==================== FLY SECTION ====================
local FlySwitch = Instance.new("Frame")
FlySwitch.Size = UDim2.new(0, 80, 0, 38)
FlySwitch.Position = UDim2.new(0.5, -40, 0, 20)
FlySwitch.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
FlySwitch.Parent = FlyContent

local FlySwitchCorner = Instance.new("UICorner")
FlySwitchCorner.CornerRadius = UDim.new(1, 0)
FlySwitchCorner.Parent = FlySwitch

local FlyCircle = Instance.new("Frame")
FlyCircle.Size = UDim2.new(0, 32, 0, 32)
FlyCircle.Position = UDim2.new(0, 3, 0.5, -16)
FlyCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FlyCircle.Parent = FlySwitch

local FlyCircleCorner = Instance.new("UICorner")
FlyCircleCorner.CornerRadius = UDim.new(1, 0)
FlyCircleCorner.Parent = FlyCircle

local FlyLabel = Instance.new("TextLabel")
FlyLabel.Size = UDim2.new(1, 0, 0, 40)
FlyLabel.Position = UDim2.new(0, 0, 0, 75)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "FLY: OFF"
FlyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
FlyLabel.Font = Enum.Font.GothamBlack
FlyLabel.TextSize = 18
FlyLabel.Parent = FlyContent

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.6, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 130)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ bay"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 16
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = FlyContent

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.35, 0, 0, 30)
SpeedBox.Position = UDim2.new(0.65, 0, 0, 130)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
SpeedBox.Text = "120"
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 16
SpeedBox.Parent = FlyContent

local SpeedBoxCorner = Instance.new("UICorner")
SpeedBoxCorner.CornerRadius = UDim.new(0, 8)
SpeedBoxCorner.Parent = SpeedBox

local ApplySpeedBtn = Instance.new("TextButton")
ApplySpeedBtn.Size = UDim2.new(0.35, 0, 0, 35)
ApplySpeedBtn.Position = UDim2.new(0.65, 0, 0, 175)
ApplySpeedBtn.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
ApplySpeedBtn.Text = "ÁP DỤNG"
ApplySpeedBtn.TextColor3 = Color3.new(1,1,1)
ApplySpeedBtn.Font = Enum.Font.GothamBold
ApplySpeedBtn.TextSize = 15
ApplySpeedBtn.Parent = FlyContent

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 10)
ApplyCorner.Parent = ApplySpeedBtn

-- ==================== BIẾN FLY ====================
local flying = false
local flySpeed = 120
local flyBodyVelocity = nil
local flyConnection = nil

-- ==================== ESP FUNCTIONS (KHÔNG CÒN MÁU) ====================
local function createESP(char, player)
    if char:FindFirstChild("PremiumESP") then return end

    local folder = Instance.new("Folder")
    folder.Name = "PremiumESP"
    folder.Parent = char

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 0.45
    hl.OutlineTransparency = 0
    hl.Parent = folder

    -- Box 3D
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = char
    box.Size = Vector3.new(2.2, 4.2, 2.2)
    box.Transparency = 0.6
    box.AlwaysOnTop = true
    box.Parent = folder

    -- NameTag
    local bill = Instance.new("BillboardGui")
    bill.Adornee = char:WaitForChild("Head")
    bill.Size = UDim2.new(0, 240, 0, 50)
    bill.StudsOffset = Vector3.new(0, 3.8, 0)
    bill.AlwaysOnTop = true
    bill.Parent = folder

    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.new(1, 0, 1, 0)
    nameTag.BackgroundTransparency = 1
    nameTag.Text = player.Name
    nameTag.TextColor3 = Color3.new(1,1,1)
    nameTag.TextStrokeTransparency = 0.3
    nameTag.TextStrokeColor3 = Color3.new(0,0,0)
    nameTag.Font = Enum.Font.GothamBlack
    nameTag.TextSize = 19
    nameTag.Parent = bill

    return {Highlight = hl, Box = box, NameTag = nameTag}
end

local function updateESP(player)
    if player == plr or not player.Character then return end
    local color = _G.UseTeamColor and player.TeamColor.Color or (plr.TeamColor == player.TeamColor and _G.FriendColor or _G.EnemyColor)

    local esp = player.Character:FindFirstChild("PremiumESP")
    if not esp then esp = createESP(player.Character, player) end

    if esp then
        esp.Highlight.FillColor = color
        esp.Box.Color3 = color
        esp.NameTag.TextColor3 = color
    end
end

local function removeESP(player)
    if player.Character then
        local esp = player.Character:FindFirstChild("PremiumESP")
        if esp then esp:Destroy() end
    end
end

local function refreshESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= plr then updateESP(p) end
    end
end

-- ==================== FLY FUNCTIONS ====================
local function toggleFly()
    flying = not flying

    if flying then
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then 
            flying = false 
            return 
        end

        FlySwitch.BackgroundColor3 = Color3.fromRGB(180, 80, 255)
        TweenService:Create(FlyCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -35, 0.5, -16)}):Play()
        FlyLabel.Text = "FLY: ENABLED"
        FlyLabel.TextColor3 = Color3.fromRGB(180, 255, 100)

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Name = "PremiumFly"
        flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBodyVelocity.Parent = plr.Character.HumanoidRootPart

        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not plr.Character then return end
            local hrp = plr.Character.HumanoidRootPart
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end

            if dir.Magnitude > 0 then
                flyBodyVelocity.Velocity = dir.Unit * flySpeed
            else
                flyBodyVelocity.Velocity = Vector3.new(0,0,0)
            end
        end)

    else
        FlySwitch.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
        TweenService:Create(FlyCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 3, 0.5, -16)}):Play()
        FlyLabel.Text = "FLY: DISABLED"
        FlyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)

        if flyConnection then flyConnection:Disconnect() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        flyBodyVelocity = nil
    end
end

-- ==================== TAB SWITCH ====================
local function switchTo(tab)
    ESPContent.Visible = tab == "ESP"
    TPContent.Visible  = tab == "TP"
    FlyContent.Visible = tab == "Fly"

    ESPTab.BackgroundColor3 = (tab == "ESP") and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(45, 45, 55)
    TPTab.BackgroundColor3  = (tab == "TP")  and Color3.fromRGB(80, 200, 80)  or Color3.fromRGB(45, 45, 55)
    FlyTab.BackgroundColor3 = (tab == "Fly") and Color3.fromRGB(200, 100, 255)or Color3.fromRGB(45, 45, 55)
end

ESPTab.MouseButton1Click:Connect(function() switchTo("ESP") end)
TPTab.MouseButton1Click:Connect(function() switchTo("TP") end)
FlyTab.MouseButton1Click:Connect(function() switchTo("Fly") end)

-- ==================== TOGGLE ESP ====================
local function toggleESP()
    _G.ESPEnabled = not _G.ESPEnabled
    if _G.ESPEnabled then
        ESPSwitch.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
        TweenService:Create(SwitchCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -35, 0.5, -16)}):Play()
        ESPStatus.Text = "ESP: ENABLED"
        ESPStatus.TextColor3 = Color3.fromRGB(0, 255, 140)
        refreshESP()
    else
        ESPSwitch.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
        TweenService:Create(SwitchCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 3, 0.5, -16)}):Play()
        ESPStatus.Text = "ESP: DISABLED"
        ESPStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
    end
end

ESPSwitch.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then toggleESP() end
end)

-- Keybind Right Ctrl
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleESP()
    end
end)

-- ==================== TELEPORT ====================
local teleportTarget = nil

local function updatePlayerList()
    for _, v in ipairs(ScrollingFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= plr then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 42)
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            b.Text = "   " .. player.Name
            b.TextColor3 = Color3.fromRGB(220, 220, 220)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Font = Enum.Font.Gotham
            b.TextSize = 16
            b.Parent = ScrollingFrame

            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 10)
            bc.Parent = b

            b.MouseButton1Click:Connect(function()
                teleportTarget = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                SelectedLabel.Text = "Đã chọn: " .. player.Name
                SelectedLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
            end)
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

TPBtn.MouseButton1Click:Connect(function()
    if teleportTarget and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        plr.Character.HumanoidRootPart.CFrame = teleportTarget.CFrame + Vector3.new(0, 4, 0)
    end
end)

-- ==================== FLY SPEED ====================
SpeedBox.FocusLost:Connect(function(enter)
    if enter then
        local num = tonumber(SpeedBox.Text)
        if num and num > 0 then flySpeed = num end
    end
end)

ApplySpeedBtn.MouseButton1Click:Connect(function()
    local num = tonumber(SpeedBox.Text)
    if num and num > 0 then 
        flySpeed = num 
        SpeedBox.Text = tostring(flySpeed)
    end
end)

FlySwitch.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then toggleFly() end
end)

-- ==================== CONNECTIONS ====================
Players.PlayerAdded:Connect(function(p)
    task.wait(0.6)
    updatePlayerList()
    if _G.ESPEnabled then updateESP(p) end
end)

Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
    updatePlayerList()
end)

-- Load ban đầu
task.wait(1)
updatePlayerList()
if _G.ESPEnabled then refreshESP() end

print("✅ PREMIUM HUB đã load! Thiết kế cực sang - 3 Tab đầy đủ - Nhấn Right Ctrl bật/tắt ESP")
