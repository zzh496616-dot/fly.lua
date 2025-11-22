-- lc之战脚本 UI
-- 作者: [AI大王]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 创建主屏幕GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GermanWarScript"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- 主框架
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "日耳曼之战 v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Size = UDim2.new(0.3, 0, 1, 0)
TimeLabel.Position = UDim2.new(0.7, 0, 0, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "06:45"
TimeLabel.TextColor3 = Color3.fromRGB(160, 200, 255)
TimeLabel.TextSize = 14
TimeLabel.Font = Enum.Font.Gotham
TimeLabel.Parent = TitleBar

-- 控制按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0, 2)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.white
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

-- 功能标签页
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
TabButtonsFrame.BorderSizePixel = 0
TabButtonsFrame.Parent = MainFrame

local Tabs = {"战斗", "玩家", "视觉", "其他"}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(0.25, 0, 1, 0)
    TabButton.Position = UDim2.new(0.25 * (i-1), 0, 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 200, 255)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = TabButtonsFrame
    table.insert(TabButtons, TabButton)
end

-- 内容区域
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -10, 1, -80)
ContentFrame.Position = UDim2.new(0, 5, 0, 75)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- 战斗标签内容
local CombatFrame = Instance.new("Frame")
CombatFrame.Name = "CombatFrame"
CombatFrame.Size = UDim2.new(1, 0, 1, 0)
CombatFrame.BackgroundTransparency = 1
CombatFrame.Visible = true
CombatFrame.Parent = ContentFrame

-- 自瞄功能
local AimLockToggle = CreateToggle("自瞄功能", 10, 10, false, CombatFrame)
local BulletTrackToggle = CreateToggle("子弹追踪", 10, 50, false, CombatFrame)
local SoftLockToggle = CreateToggle("轻量锁定", 10, 90, true, CombatFrame)
local VisualCheckToggle = CreateToggle("可视化检查", 10, 130, true, CombatFrame)

-- 快速换弹
local FastReloadToggle = CreateToggle("快速换弹", 200, 10, true, CombatFrame)
local AutoReloadToggle = CreateToggle("自动换弹", 200, 50, false, CombatFrame)

-- 建筑功能
local InstantRepairToggle = CreateToggle("瞬间修复建筑", 10, 170, false, CombatFrame)
local AutoBlockToggle = CreateToggle("自动格挡", 200, 170, true, CombatFrame)

-- 速度调节
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(0, 120, 0, 25)
SpeedLabel.Position = UDim2.new(0, 10, 0, 210)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "移动速度: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = CombatFrame

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0, 60, 0, 25)
SpeedSlider.Position = UDim2.new(0, 140, 0, 210)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
SpeedSlider.TextColor3 = Color3.white
SpeedSlider.Text = "16"
SpeedSlider.TextSize = 14
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.Parent = CombatFrame

-- 玩家标签内容
local PlayerFrame = Instance.new("Frame")
PlayerFrame.Name = "PlayerFrame"
PlayerFrame.Size = UDim2.new(1, 0, 1, 0)
PlayerFrame.BackgroundTransparency = 1
PlayerFrame.Visible = false
PlayerFrame.Parent = ContentFrame

local PlayerESP = CreateToggle("玩家透视(仅敌方)", 10, 10, false, PlayerFrame)
local PlayerNames = CreateToggle("玩家名字", 10, 50, true, PlayerFrame)
local TeamCheck = CreateToggle("队伍检查", 10, 90, true, PlayerFrame)

-- 作者留言
local AuthorFrame = Instance.new("Frame")
AuthorFrame.Name = "AuthorFrame"
AuthorFrame.Size = UDim2.new(1, 0, 0, 100)
AuthorFrame.Position = UDim2.new(0, 0, 1, -100)
AuthorFrame.BackgroundColor3 = Color3.fromRGB(30, 45, 60)
AuthorFrame.BorderSizePixel = 0
AuthorFrame.Parent = MainFrame

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Name = "AuthorLabel"
AuthorLabel.Size = UDim2.new(1, -10, 1, -10)
AuthorFrame.Position = UDim2.new(0, 5, 0, 5)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Text = "作者留言: 本脚本免费使用，请不要看源码。"
AuthorLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
AuthorLabel.TextSize = 12
AuthorLabel.TextWrapped = true
AuthorLabel.Font = Enum.Font.Gotham
AuthorLabel.Parent = AuthorFrame

-- 创建切换按钮的函数
function CreateToggle(name, x, y, defaultState, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(0, 180, 0, 30)
    ToggleFrame.Position = UDim2.new(0, x, 0, y)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(0, 30, 0, 30)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(180, 60, 60)
    ToggleButton.Text = defaultState and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.white
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0, 140, 0, 30)
    ToggleLabel.Position = UDim2.new(0, 35, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Parent = ToggleFrame
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = ToggleButton.Text == "OFF"
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(180, 60, 60)
        ToggleButton.Text = newState and "ON" or "OFF"
        
        -- 这里添加功能开关逻辑
        if name == "自瞄功能" then
            ToggleAimbot(newState)
        elseif name == "玩家透视(仅敌方)" then
            ToggleESP(newState)
        elseif name == "快速换弹" then
            ToggleFastReload(newState)
        -- 其他功能开关...
        end
    end)
    
    return ToggleFrame
end

-- 功能实现函数
function ToggleAimbot(state)
    if state then
        -- 启用自瞄逻辑
        print("自瞄功能已启用")
        -- 这里添加自瞄代码，包括轻量锁定和可视化检查
    else
        -- 禁用自瞄逻辑
        print("自瞄功能已禁用")
    end
end

function ToggleESP(state)
    if state then
        -- 启用玩家透视(仅敌方)
        print("玩家透视已启用")
        -- 这里添加透视代码，仅显示敌方玩家
    else
        -- 禁用玩家透视
        print("玩家透视已禁用")
    end
end

function ToggleFastReload(state)
    if state then
        -- 启用快速换弹
        print("快速换弹已启用")
        -- 这里添加快速换弹代码
    else
        -- 禁用快速换弹
        print("快速换弹已禁用")
    end
end

-- 速度调节功能
SpeedSlider.FocusLost:Connect(function()
    local speedValue = tonumber(SpeedSlider.Text)
    if speedValue and speedValue >= 1 and speedValue <= 100 then
        SpeedLabel.Text = "移动速度: " .. speedValue
        -- 这里添加修改速度的代码
        print("速度已设置为: " .. speedValue)
    else
        SpeedSlider.Text = "16"
        SpeedLabel.Text = "移动速度: 16"
    end
end)

-- 标签页切换逻辑
for i, button in ipairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        CombatFrame.Visible = (i == 1)
        PlayerFrame.Visible = (i == 2)
        -- 可以添加更多标签页...
    end)
end

-- 关闭和最小化按钮功能
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    local isMinimized = ContentFrame.Visible
    ContentFrame.Visible = not isMinimized
    AuthorFrame.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 400, 0, 500) or UDim2.new(0, 400, 0, 70)
end)

print("lc脚本加载完成!")
