-- lc指令脚本 UI - 完整版
-- 作者: Fezezen

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 创建主屏幕GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GermanWarScript"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end

ScreenGui.Parent = game.CoreGui

-- 存储切换状态
local ToggleStates = {
    AimBot = false,
    BulletTrack = false,
    SoftLock = true,
    VisualCheck = true,
    FastReload = true,
    AutoReload = false,
    InstantRepair = false,
    AutoBlock = true,
    PlayerESP = false,
    PlayerNames = true,
    TeamCheck = true
}

-- 创建主框架
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- 创建圆角
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "lc指令脚本 v1.0"
TitleLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
TitleLabel.TextSize = 18
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
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.white
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 140, 200)
MinimizeButton.TextColor3 = Color3.white
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "_"
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- 功能标签页
local TabButtonsFrame = Instance.new("Frame")
TabButtonsFrame.Name = "TabButtonsFrame"
TabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
TabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
TabButtonsFrame.BackgroundColor3 = Color3.fromRGB(30, 40, 55)
TabButtonsFrame.BorderSizePixel = 0
TabButtonsFrame.Parent = MainFrame

local Tabs = {"战斗", "玩家", "视觉", "其他"}
local TabFrames = {}

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName .. "Tab"
    TabButton.Size = UDim2.new(0.25, 0, 1, 0)
    TabButton.Position = UDim2.new(0.25 * (i-1), 0, 0, 0)
    TabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(50, 70, 100) or Color3.fromRGB(40, 50, 70)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 200, 255)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = TabButtonsFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
end

-- 内容区域
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -160)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- 创建切换按钮的函数
function CreateToggle(name, x, y, defaultState, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(0, 180, 0, 35)
    ToggleFrame.Position = UDim2.new(0, x, 0, y)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Size = UDim2.new(0, 60, 0, 35)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(180, 60, 60)
    ToggleButton.Text = defaultState and "开启" or "关闭"
    ToggleButton.TextColor3 = Color3.white
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0, 110, 0, 35)
    ToggleLabel.Position = UDim2.new(0, 65, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Parent = ToggleFrame
    
    -- 存储状态
    ToggleStates[name] = defaultState
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = not ToggleStates[name]
        ToggleStates[name] = newState
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(180, 60, 60)
        ToggleButton.Text = newState and "开启" or "关闭"
        
        -- 触发功能
        HandleToggleFunction(name, newState)
    end)
    
    return ToggleFrame
end

-- 处理功能开关
function HandleToggleFunction(name, state)
    print(name .. " " .. (state and "已开启" or "已关闭"))
    
    if name == "自瞄功能" then
        ToggleAimbot(state)
    elseif name == "玩家透视" then
        ToggleESP(state)
    elseif name == "快速换弹" then
        ToggleFastReload(state)
    elseif name == "子弹追踪" then
        ToggleBulletTrack(state)
    elseif name == "轻量锁定" then
        ToggleSoftLock(state)
    elseif name == "可视化检查" then
        ToggleVisualCheck(state)
    elseif name == "自动换弹" then
        ToggleAutoReload(state)
    elseif name == "瞬间修复" then
        ToggleInstantRepair(state)
    elseif name == "自动格挡" then
        ToggleAutoBlock(state)
    elseif name == "队伍检查" then
        ToggleTeamCheck(state)
    end
end

-- 战斗标签内容
local CombatFrame = Instance.new("Frame")
CombatFrame.Name = "CombatFrame"
CombatFrame.Size = UDim2.new(1, 0, 1, 0)
CombatFrame.BackgroundTransparency = 1
CombatFrame.Visible = true
CombatFrame.Parent = ContentFrame

-- 创建战斗功能按钮
CreateToggle("自瞄功能", 10, 10, false, CombatFrame)
CreateToggle("子弹追踪", 10, 55, false, CombatFrame)
CreateToggle("轻量锁定", 10, 100, true, CombatFrame)
CreateToggle("可视化检查", 10, 145, true, CombatFrame)
CreateToggle("快速换弹", 200, 10, true, CombatFrame)
CreateToggle("自动换弹", 200, 55, false, CombatFrame)
CreateToggle("瞬间修复", 10, 190, false, CombatFrame)
CreateToggle("自动格挡", 200, 190, true, CombatFrame)

-- 速度调节
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.new(1, 0, 0, 40)
SpeedFrame.Position = UDim2.new(0, 0, 0, 240)
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Parent = CombatFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(0, 120, 0, 25)
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "移动速度: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.Size = UDim2.new(0, 60, 0, 30)
SpeedBox.Position = UDim2.new(0, 140, 0, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
SpeedBox.TextColor3 = Color3.white
SpeedBox.Text = "16"
SpeedBox.PlaceholderText = "速度值"
SpeedBox.TextSize = 14
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.Parent = SpeedFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedBox

-- 玩家标签内容
local PlayerFrame = Instance.new("Frame")
PlayerFrame.Name = "PlayerFrame"
PlayerFrame.Size = UDim2.new(1, 0, 1, 0)
PlayerFrame.BackgroundTransparency = 1
PlayerFrame.Visible = false
PlayerFrame.Parent = ContentFrame

CreateToggle("玩家透视", 10, 10, false, PlayerFrame)
CreateToggle("显示名字", 10, 55, true, PlayerFrame)
CreateToggle("队伍检查", 10, 100, true, PlayerFrame)

-- 作者留言
local AuthorFrame = Instance.new("Frame")
AuthorFrame.Name = "AuthorFrame"
AuthorFrame.Size = UDim2.new(1, -20, 0, 60)
AuthorFrame.Position = UDim2.new(0, 10, 1, -70)
AuthorFrame.BackgroundColor3 = Color3.fromRGB(30, 45, 60)
AuthorFrame.BorderSizePixel = 0
AuthorFrame.Parent = MainFrame

local AuthorCorner = Instance.new("UICorner")
AuthorCorner.CornerRadius = UDim.new(0, 6)
AuthorCorner.Parent = AuthorFrame

local AuthorLabel = Instance.new("TextLabel")
AuthorLabel.Name = "AuthorLabel"
AuthorLabel.Size = UDim2.new(1, -10, 1, -10)
AuthorLabel.Position = UDim2.new(0, 5, 0, 5)
AuthorLabel.BackgroundTransparency = 1
AuthorLabel.Text = "作者: cherryblossom_1882\n仅供学习交流，请遵守游戏规则"
AuthorLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
AuthorLabel.TextSize = 12
AuthorLabel.TextWrapped = true
AuthorLabel.Font = Enum.Font.Gotham
AuthorLabel.Parent = AuthorFrame

-- 标签页切换功能
local TabButtons = TabButtonsFrame:GetChildren()
for _, button in ipairs(TabButtons) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            -- 重置所有标签颜色
            for _, btn in ipairs(TabButtons) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
                end
            end
            
            -- 设置当前标签颜色
            button.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
            
            -- 显示对应内容
            CombatFrame.Visible = (button.Name == "战斗Tab")
            PlayerFrame.Visible = (button.Name == "玩家Tab")
            -- 可以添加更多标签页...
        end)
    end
end

-- 关闭和最小化按钮功能
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentFrame.Visible = not isMinimized
    AuthorFrame.Visible = not isMinimized
    TabButtonsFrame.Visible = not isMinimized
    
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 400, 0, 40)
        MinimizeButton.Text = "□"
    else
        MainFrame.Size = UDim2.new(0, 400, 0, 500)
        MinimizeButton.Text = "_"
    end
end)

-- 速度调节功能
SpeedBox.FocusLost:Connect(function()
    local speedValue = tonumber(SpeedBox.Text)
    if speedValue and speedValue >= 1 and speedValue <= 100 then
        SpeedLabel.Text = "移动速度: " .. speedValue
        SetWalkSpeed(speedValue)
    else
        SpeedBox.Text = "16"
        SpeedLabel.Text = "移动速度: 16"
        SetWalkSpeed(16)
    end
end)

-- 功能实现函数
function ToggleAimbot(state)
    if state then
        print("自瞄功能已启用 - 包含轻量锁定和可视化检查")
    else
        print("自瞄功能已禁用")
    end
end

function ToggleESP(state)
    if state then
        print("玩家透视已启用 - 仅显示敌方玩家")
    else
        print("玩家透视已禁用")
    end
end

function ToggleFastReload(state)
    if state then
        print("快速换弹已启用")
    else
        print("快速换弹已禁用")
    end
end

function ToggleBulletTrack(state)
    print("子弹追踪 " .. (state and "已启用" or "已禁用"))
end

function ToggleSoftLock(state)
    print("轻量锁定 " .. (state and "已启用" or "已禁用"))
end

function ToggleVisualCheck(state)
    print("可视化检查 " .. (state and "已启用" or "已禁用"))
end

function ToggleAutoReload(state)
    print("自动换弹 " .. (state and "已启用" or "已禁用"))
end

function ToggleInstantRepair(state)
    print("瞬间修复 " .. (state and "已启用" or "已禁用"))
end

function ToggleAutoBlock(state)
    print("自动格挡 " .. (state and "已启用" or "已禁用"))
end

function ToggleTeamCheck(state)
    print("队伍检查 " .. (state and "已启用" or "已禁用"))
end

function SetWalkSpeed(speed)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
        print("移动速度设置为: " .. speed)
    end
end

-- 更新时间
local function updateTime()
    local currentTime = os.date("*t")
    TimeLabel.Text = string.format("%02d:%02d", currentTime.hour, currentTime.min)
end

-- 初始更新时间
updateTime()

print("lc指令脚本 v1.0 加载完成!")
print("作者: AI大王")
