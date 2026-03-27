-- =============================================
-- SURI | Fly + Invisible - Phiên bản hoàn thiện 2026
-- GUI hiện đại trắng-đen, bo góc
-- E = Toggle Fly | X = Toggle Invisible | RightShift = Ẩn/Hiện GUI
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

-- Đợi character load đầy đủ
player.CharacterAdded:Wait()
local character = player.Character or player.CharacterAdded:Wait()
wait(0.5)  -- Đợi một chút để tránh nil

-- ================== TẠO GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuriGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 290, 0, 190)
mainFrame.Position = UDim2.new(0.5, -145, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 18)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(55, 55, 55)
uiStroke.Thickness = 1.8
uiStroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "SURI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 18)
titleCorner.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Fly & Invisible"
subtitle.TextColor3 = Color3.fromRGB(170, 170, 170)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.88, 0, 0, 48)
flyButton.Position = UDim2.new(0.06, 0, 0.40, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
flyButton.Text = "Fly : OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamSemibold
flyButton.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 14)
flyCorner.Parent = flyButton

-- Invisible Button
local invisButton = Instance.new("TextButton")
invisButton.Size = UDim2.new(0.88, 0, 0, 48)
invisButton.Position = UDim2.new(0.06, 0, 0.68, 0)
invisButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
invisButton.Text = "Invisible : OFF"
invisButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisButton.TextScaled = true
invisButton.Font = Enum.Font.GothamSemibold
invisButton.Parent = mainFrame

local invisCorner = Instance.new("UICorner")
invisCorner.CornerRadius = UDim.new(0, 14)
invisCorner.Parent = invisButton

-- ================== FUNCTION FLY ==================
local function toggleFly()
    character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not root or not humanoid then return end

    flying = not flying

    if flying then
        humanoid.PlatformStand = true

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(999999, 999999, 999999)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = root

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(999999, 999999, 999999)
        bodyGyro.P = 12000
        bodyGyro.Parent = root

        flyButton.Text = "Fly : ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)

        spawn(function()
            while flying and character.Parent do
                local moveDirection = Vector3.new(0,0,0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection -= Vector3.new(0,1,0) end

                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit * flySpeed
                end

                bodyVelocity.Velocity = moveDirection
                bodyGyro.CFrame = camera.CFrame

                RunService.Heartbeat:Wait()
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if humanoid then humanoid.PlatformStand = false end

        flyButton.Text = "Fly : OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end

-- ================== FUNCTION INVISIBLE ==================
local function toggleInvisible()
    character = player.Character
    if not character then return end

    invisible = not invisible

    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = invisible and 1 or 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = invisible and 1 or 0
        end
    end

    -- Ẩn tool nếu đang cầm
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            for _, part in pairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = invisible and 1 or 0
                end
            end
        end
    end

    invisButton.Text = invisible and "Invisible : ON" or "Invisible : OFF"
    invisButton.BackgroundColor3 = invisible and Color3.fromRGB(170, 40, 80) or Color3.fromRGB(35, 35, 35)
end

-- ================== KẾT NỐI BUTTON & HOTKEY ==================
flyButton.MouseButton1Click:Connect(toggleFly)
invisButton.MouseButton1Click:Connect(toggleInvisible)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.X then
        toggleInvisible()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

print("✅ SURI đã load thành công!")
print("Nhấn E = Fly | X = Invisible | RightShift = Ẩn/Hiện menu")
