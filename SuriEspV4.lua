--[[
    🔥 SCxSuri PREMIUM HUB v2
    Fly + Noclip • Resize được • Thiết kế sang trọng
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

-- ==================== GUI PREMIUM ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SCxSuriHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(90, 180, 255)
MainStroke.Thickness = 2.5
MainStroke.Parent = MainFrame

-- Title
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TitleBar.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 140, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 60, 120))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "SCxSuri"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.Parent = TitleBar

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 50)
TabBar.Position = UDim2.new(0, 10, 0, 70)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local ESPTab   = Instance.new("TextButton")
local TPTab    = Instance.new("TextButton")
local FlyTab   = Instance.new("TextButton")

for i, btn in ipairs({ESPTab, TPTab, FlyTab}) do
    btn.Size = UDim2.new(0, 110, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = TabBar
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 12)
end

ESPTab.Text = "ESP"
TPTab.Text = "Teleport"
FlyTab.Text = "Fly + Noclip"
ESPTab.BackgroundColor3 = Color3.fromRGB(60, 160, 255)

-- Content
local ESPContent = Instance.new("Frame") ESPContent.Size = UDim2.new(1,-20,1,-140) ESPContent.Position = UDim2.new(0,10,0,130) ESPContent.BackgroundTransparency = 1 ESPContent.Visible = true ESPContent.Parent = MainFrame
local TPContent  = Instance.new("Frame") TPContent.Size = UDim2.new(1,-20,1,-140) TPContent.Position = UDim2.new(0,10,0,130) TPContent.BackgroundTransparency = 1 TPContent.Visible = false TPContent.Parent = MainFrame
local FlyContent = Instance.new("Frame") FlyContent.Size = UDim2.new(1,-20,1,-140) FlyContent.Position = UDim2.new(0,10,0,130) FlyContent.BackgroundTransparency = 1 FlyContent.Visible = false FlyContent.Parent = MainFrame

-- ==================== FLY + NOCLIP SECTION ====================
local flying = false
local noclipping = false
local flySpeed = 120
local bv, bg

local FlyToggle = Instance.new("Frame")
FlyToggle.Size = UDim2.new(0, 90, 0, 40)
FlyToggle.Position = UDim2.new(0.5, -45, 0, 30)
FlyToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
FlyToggle.Parent = FlyContent

local FlyCorner = Instance.new("UICorner", FlyToggle) FlyCorner.CornerRadius = UDim.new(1,0)
local FlyCircle = Instance.new("Frame", FlyToggle)
FlyCircle.Size = UDim2.new(0, 34, 0, 34)
FlyCircle.Position = UDim2.new(0, 3, 0.5, -17)
FlyCircle.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", FlyCircle).CornerRadius = UDim.new(1,0)

local FlyStatus = Instance.new("TextLabel")
FlyStatus.Size = UDim2.new(1,0,0,40)
FlyStatus.Position = UDim2.new(0,0,0,85)
FlyStatus.BackgroundTransparency = 1
FlyStatus.Text = "FLY: DISABLED"
FlyStatus.TextColor3 = Color3.fromRGB(255, 90, 90)
FlyStatus.Font = Enum.Font.GothamBlack
FlyStatus.TextSize = 18
FlyStatus.Parent = FlyContent

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(0.45, 0, 0, 45)
NoclipToggle.Position = UDim2.new(0.52, 0, 0, 150)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
NoclipToggle.Text = "NOCLIP: OFF"
NoclipToggle.TextColor3 = Color3.new(1,1,1)
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.TextSize = 16
NoclipToggle.Parent = FlyContent
Instance.new("UICorner", NoclipToggle).CornerRadius = UDim.new(0,12)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.5,0,0,30)
SpeedLabel.Position = UDim2.new(0,0,0,210)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ bay:"
SpeedLabel.TextColor3 = Color3.fromRGB(200,200,200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 16
SpeedLabel.Parent = FlyContent

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.4,0,0,30)
SpeedBox.Position = UDim2.new(0.55,0,0,210)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30,30,38)
SpeedBox.Text = "120"
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 16
SpeedBox.Parent = FlyContent
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,8)

-- ==================== FLY + NOCLIP CODE (Tinh chỉnh) ====================
local function startFly()
    if flying then return end
    flying = true

    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    FlyToggle.BackgroundColor3 = Color3.fromRGB(100, 220, 100)
    TweenService:Create(FlyCircle, TweenInfo.new(0.3), {Position = UDim2.new(1, -37, 0.5, -17)}):Play()
    FlyStatus.Text = "FLY: ENABLED"
    FlyStatus.TextColor3 = Color3.fromRGB(100, 255, 100)

    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = char.HumanoidRootPart.CFrame
    bg.Parent = char.HumanoidRootPart

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = char.HumanoidRootPart

    char.Humanoid.PlatformStand = true

    RunService.Heartbeat:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end

        bv.Velocity = moveDir.Unit * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    flying = false
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.PlatformStand = false
    end

    FlyToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    TweenService:Create(FlyCircle, TweenInfo.new(0.3), {Position = UDim2.new(0, 3, 0.5, -17)}):Play()
    FlyStatus.Text = "FLY: DISABLED"
    FlyStatus.TextColor3 = Color3.fromRGB(255, 90, 90)
end

local function toggleNoclip()
    noclipping = not noclipping
    NoclipToggle.Text = "NOCLIP: " .. (noclipping and "ON" or "OFF")
    NoclipToggle.BackgroundColor3 = noclipping and Color3.fromRGB(100, 220, 100) or Color3.fromRGB(80, 80, 90)
end

-- Noclip Loop
RunService.Stepped:Connect(function()
    if noclipping and plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ==================== TOGGLE FLY & NOCLIP ====================
FlyToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if flying then stopFly() else startFly() end
    end
end)

NoclipToggle.MouseButton1Click:Connect(toggleNoclip)

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(SpeedBox.Text)
        if num then flySpeed = math.clamp(num, 10, 500) end
        SpeedBox.Text = tostring(flySpeed)
    end
end)

-- ==================== TAB SWITCHING ====================
ESPTab.MouseButton1Click:Connect(function()
    ESPContent.Visible = true
    TPContent.Visible = false
    FlyContent.Visible = false
    ESPTab.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
    TPTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    FlyTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
end)

TPTab.MouseButton1Click:Connect(function()
    ESPContent.Visible = false
    TPContent.Visible = true
    FlyContent.Visible = false
    ESPTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    TPTab.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    FlyTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
end)

FlyTab.MouseButton1Click:Connect(function()
    ESPContent.Visible = false
    TPContent.Visible = false
    FlyContent.Visible = true
    ESPTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    TPTab.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    FlyTab.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
end)

-- ==================== RESIZE FUNCTION (Kéo góc) ====================
local resizing = false
local resizeStartPos, resizeStartSize

local ResizeHandle = Instance.new("Frame")
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Parent = MainFrame

local ResizeCorner = Instance.new("TextLabel")
ResizeCorner.Size = UDim2.new(1,0,1,0)
ResizeCorner.BackgroundTransparency = 1
ResizeCorner.Text = "↘"
ResizeCorner.TextColor3 = Color3.fromRGB(120, 180, 255)
ResizeCorner.TextSize = 18
ResizeCorner.Font = Enum.Font.GothamBold
ResizeCorner.Parent = ResizeHandle

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStartPos = UserInputService:GetMouseLocation()
        resizeStartSize = MainFrame.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - resizeStartPos
        local newWidth = math.clamp(resizeStartSize.X.Offset + delta.X, 340, 600)
        local newHeight = math.clamp(resizeStartSize.Y.Offset + delta.Y, 420, 650)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- ==================== ESP & TELEPORT (giữ nguyên từ trước, rút gọn) ====================
-- (Bạn có thể dán phần ESP + Teleport từ code cũ vào đây nếu muốn, hoặc giữ nguyên 2 tab kia)

print("✅ SCxSuri Hub đã load thành công!")
print("   • Fly + Noclip")
print("   • Kéo góc dưới phải để phóng to / thu nhỏ")
