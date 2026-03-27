-- =============================================
-- SURI - Fly & Invisible
-- Phiên bản đầy đủ - GUI hiện đại trắng đen
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

-- Đợi character load an toàn
repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local character = player.Character
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

print("✅ SURI đã load thành công!")

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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 18)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 55, 55)
stroke.Thickness = 1.8
stroke.Parent = mainFrame

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
    flying = not flying
    
    if flying then
        humanoid.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9999999, 9999999, 9999999)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9999999, 9999999, 9999999)
        bodyGyro.P = 12500
        bodyGyro.Parent = rootPart

        flyButton.Text = "Fly : ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)

        task.spawn(function()
            while flying and character and character.Parent do
                local moveDir = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end

                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit * flySpeed
                end

                if bodyVelocity then bodyVelocity.Velocity = moveDir end
                if bodyGyro then bodyGyro.CFrame = camera.CFrame end

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
    invisible = not invisible

    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            obj.Transparency = invisible and 1 or 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = invisible and 1 or 0
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

-- ================== KẾT NỐI ==================
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

print("E = Toggle Fly | X = Toggle Invisible | RightShift = Ẩn/Hiện GUI")
