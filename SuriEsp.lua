--[[
    Modern ESP with Toggle GUI - 2026 Version
    Bật/Tắt bằng nút gạt (Switch)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local plr = Players.LocalPlayer

-- Cài đặt
_G.FriendColor = Color3.fromRGB(0, 170, 255)
_G.EnemyColor = Color3.fromRGB(255, 50, 50)
_G.UseTeamColor = true
_G.ESPEnabled = true  -- Bắt đầu ở trạng thái bật

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ModernESP"
ESPFolder.Parent = game.CoreGui

-- ==================== GUI TOGGLE ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPControl"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 80)
MainFrame.Position = UDim2.new(0, 20, 0.5, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "ESP Player"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0, 50, 0, 26)
ToggleFrame.Position = UDim2.new(1, -70, 0.5, -13)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleFrame.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleFrame

local ToggleCircle = Instance.new("Frame")
ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
ToggleCircle.Position = UDim2.new(0, 2, 0.5, -11)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleCircle.Parent = ToggleFrame

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleCircle

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0, 60, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "ON"
StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
StatusText.TextSize = 14
StatusText.Font = Enum.Font.GothamSemibold
StatusText.Parent = MainFrame

-- ==================== ESP FUNCTION ====================
local function createHighlight(character, color)
    if not character or character:FindFirstChild("ESP_Highlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = character
end

local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= plr and v.Character then
            local color = _G.UseTeamColor and v.TeamColor.Color or 
                         ((plr.TeamColor == v.TeamColor) and _G.FriendColor or _G.EnemyColor)
            
            createHighlight(v.Character, color)
            
            -- Cập nhật màu nếu đã có highlight
            local hl = v.Character:FindFirstChild("ESP_Highlight")
            if hl then
                hl.FillColor = color
            end
        end
    end
end

local function removeAllESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local hl = v.Character:FindFirstChild("ESP_Highlight")
            if hl then hl:Destroy() end
        end
    end
end

-- ==================== TOGGLE LOGIC ====================
local isOn = true

local function toggleESP()
    isOn = not isOn
    _G.ESPEnabled = isOn
    
    if isOn then
        -- Bật ESP
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
        TweenService:Create(ToggleCircle, TweenInfo.new(0.25), {Position = UDim2.new(1, -24, 0.5, -11)}):Play()
        StatusText.Text = "ON"
        StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
        updateESP()
    else
        -- Tắt ESP
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        TweenService:Create(ToggleCircle, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
        StatusText.Text = "OFF"
        StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        removeAllESP()
    end
end

-- Click vào ToggleFrame hoặc ToggleCircle đều bật/tắt
ToggleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleESP()
    end
end)

-- ==================== AUTO UPDATE ====================
Players.PlayerAdded:Connect(function(v)
    v.CharacterAdded:Connect(function()
        if isOn then
            task.wait(0.5)
            updateESP()
        end
    end)
end)

-- Update khi team thay đổi hoặc character load
Players.PlayerRemoving:Connect(function(v)
    if v.Character then
        local hl = v.Character:FindFirstChild("ESP_Highlight")
        if hl then hl:Destroy() end
    end
end)

-- Loop cập nhật liên tục (mượt mà)
task.spawn(function()
    while task.wait(0.8) do
        if isOn then
            updateESP()
        end
    end
end)

-- Load ESP cho những người đang có trong game
task.wait(1)
if isOn then
    updateESP()
end

print("Modern ESP + Toggle GUI đã load thành công!")
