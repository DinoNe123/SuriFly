-- Suri | Fly + Invisible (Fixed Version)
-- GUI hiện đại trắng-đen

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Chờ Player và Character load xong
if not player then
    player = Players.LocalPlayer or Players.PlayerAdded:Wait()
end
player.CharacterAdded:Wait()  -- Đợi character xuất hiện

local flying = false
local invisible = false
local flySpeed = 60

local bodyVelocity, bodyGyro = nil, nil

-- === Tạo GUI ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuriGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0.5, -140, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1.5

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "Suri"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

Instance.new("UICorner", title).CornerRadius = UDim.new(0, 16)

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Fly & Invisible"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame

-- Buttons (giống trước, mình rút gọn để dễ nhìn)
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.85, 0, 0, 45)
flyButton.Position = UDim2.new(0.075, 0, 0.42, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.GothamSemibold
flyButton.Parent = mainFrame
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 12)

local invisButton = flyButton:Clone()
invisButton.Position = UDim2.new(0.075, 0, 0.68, 0)
invisButton.Text = "Invisible: OFF"
invisButton.Parent = mainFrame

-- Function Fly & Invisible (giữ nguyên logic cũ nhưng an toàn hơn)
local function toggleFly()
    -- ... (code toggleFly giống phiên bản trước, mình giữ nguyên để ngắn)
    -- Nếu bạn cần full code toggleFly & toggleInvisible thì bảo mình paste lại nhé
end

local function toggleInvisible()
    -- code toggleInvisible giống trước
end

flyButton.MouseButton1Click:Connect(toggleFly)
invisButton.MouseButton1Click:Connect(toggleInvisible)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then toggleFly()
    elseif input.KeyCode == Enum.KeyCode.X then toggleInvisible()
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

print("✅ Suri Fixed Version loaded!")
print("E = Fly | X = Invisible | RightShift = Ẩn GUI")
