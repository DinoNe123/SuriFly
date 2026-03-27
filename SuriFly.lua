-- =============================================
-- SURI - Fly & Invisible (Modern Draggable GUI)
-- Menu nhỏ - Kéo được - Toggle Switch - Slider Speed - Add Speed - Jump
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flying = false
local invisible = false
local flySpeed = 60

local bodyVelocity = nil
local bodyGyro = nil

-- Đợi character
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local character = player.Character
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ================== TẠO GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuriGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 240)
mainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- Title Bar (kéo được)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.Text = "SURI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Làm cho GUI kéo được
local dragging = false
local dragInput
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Fly Toggle Switch
local flyToggleFrame = Instance.new("Frame")
flyToggleFrame.Size = UDim2.new(0, 50, 0, 26)
flyToggleFrame.Position = UDim2.new(0.75, 0, 0.12, 0)
flyToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyToggleFrame.Parent = mainFrame
Instance.new("UICorner", flyToggleFrame).CornerRadius = UDim.new(1, 0)

local flyKnob = Instance.new("Frame")
flyKnob.Size = UDim2.new(0, 22, 0, 22)
flyKnob.Position = UDim2.new(0, 2, 0.5, -11)
flyKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flyKnob.Parent = flyToggleFrame
Instance.new("UICorner", flyKnob).CornerRadius = UDim.new(1, 0)

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(0.6, 0, 0, 30)
flyLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly"
flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyLabel.TextScaled = true
flyLabel.Font = Enum.Font.GothamSemibold
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.Parent = mainFrame

-- Invisible Toggle Switch
local invisToggleFrame = flyToggleFrame:Clone()
invisToggleFrame.Position = UDim2.new(0.75, 0, 0.28, 0)
invisToggleFrame.Parent = mainFrame
local invisKnob = invisToggleFrame:FindFirstChildWhichIsA("Frame")
local invisLabel = flyLabel:Clone()
invisLabel.Text = "Invisible"
invisLabel.Position = UDim2.new(0.05, 0, 0.26, 0)
invisLabel.Parent = mainFrame

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0.48, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.85, 0, 0, 8)
sliderBar.Position = UDim2.new(0.075, 0, 0.58, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBar.Parent = mainFrame
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new((flySpeed-30)/170, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
sliderFill.Parent = sliderBar
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 16, 0, 16)
sliderKnob.Position = UDim2.new((flySpeed-30)/170, -8, 0.5, -8)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Parent = sliderBar
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

-- Buttons
local addSpeedBtn = Instance.new("TextButton")
addSpeedBtn.Size = UDim2.new(0.4, 0, 0, 35)
addSpeedBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
addSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
addSpeedBtn.Text = "+10 Speed"
addSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addSpeedBtn.TextScaled = true
addSpeedBtn.Font = Enum.Font.GothamSemibold
addSpeedBtn.Parent = mainFrame
Instance.new("UICorner", addSpeedBtn).CornerRadius = UDim.new(0, 10)

local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0.4, 0, 0, 35)
jumpBtn.Position = UDim2.new(0.55, 0, 0.72, 0)
jumpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
jumpBtn.Text = "Jump Boost"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextScaled = true
jumpBtn.Font = Enum.Font.GothamSemibold
jumpBtn.Parent = mainFrame
Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0, 10)

-- ================== FUNCTIONS ==================
local function updateFlyToggle()
    if flying then
        flyToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        flyKnob.Position = UDim2.new(1, -24, 0.5, -11)
    else
        flyToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        flyKnob.Position = UDim2.new(0, 2, 0.5, -11)
    end
end

local function updateInvisToggle()
    if invisible then
        invisToggleFrame.BackgroundColor3 = Color3.fromRGB(170, 40, 80)
        invisKnob.Position = UDim2.new(1, -24, 0.5, -11)
    else
        invisToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        invisKnob.Position = UDim2.new(0, 2, 0.5, -11)
    end
end

local function toggleFly()
    flying = not flying
    updateFlyToggle()

    if flying then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity", rootPart)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro = Instance.new("BodyGyro", rootPart)
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 12000

        task.spawn(function()
            while flying and character.Parent do
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

                bodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.new()
                bodyGyro.CFrame = camera.CFrame
                RunService.Heartbeat:Wait()
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        humanoid.PlatformStand = false
    end
end

local function toggleInvisible()
    invisible = not invisible
    updateInvisToggle()

    for _, v in pairs(character:GetDescendants()) do
        if (v:IsA("BasePart") and v.Name ~= "HumanoidRootPart") or v:IsA("Decal") then
            v.Transparency = invisible and 1 or 0
        end
    end
end

-- Slider logic (đơn giản)
sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = UserInputService.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = inp.Position.X
                local barPos = sliderBar.AbsolutePosition.X
                local barSize = sliderBar.AbsoluteSize.X
                local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
                flySpeed = math.floor(30 + percent * 170)
                speedLabel.Text = "Speed: " .. flySpeed
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderKnob.Position = UDim2.new(percent, -8, 0.5, -8)
            end
        end)
        UserInputService.InputEnded:Connect(function() connection:Disconnect() end)
    end
end)

addSpeedBtn.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 10
    if flySpeed > 200 then flySpeed = 200 end
    local percent = (flySpeed - 30) / 170
    speedLabel.Text = "Speed: " .. flySpeed
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    sliderKnob.Position = UDim2.new(percent, -8, 0.5, -8)
end)

jumpBtn.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.JumpPower = 100
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.1)
        humanoid.JumpPower = 50  -- reset về mặc định
    end
end)

-- Toggle Click
flyToggleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then toggleFly() end
end)

invisToggleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then toggleInvisible() end
end)

-- Hotkey
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then toggleFly()
    elseif input.KeyCode == Enum.KeyCode.X then toggleInvisible()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

print("SURI loaded | E = Fly | X = Invisible | RightShift = Ẩn GUI")
