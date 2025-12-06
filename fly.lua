-- 自动瞄准系统 UI
-- 作者: GPT UI Designer
-- 版本: 1.2.0 (支持炸药桶和Boss双重目标)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 创建主屏幕GUI
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoAimSystemUI"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- 主容器
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 550)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- 圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 阴影效果
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0.5, -210, 0.5, -285)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236803"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.ZIndex = -1

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleCorner.Parent = titleBar

-- 标题
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 AUTO AIM SYSTEM"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- 版本标签
local version = Instance.new("TextLabel")
version.Name = "Version"
version.Size = UDim2.new(0.2, 0, 1, 0)
version.Position = UDim2.new(0.75, 0, 0, 0)
version.BackgroundTransparency = 1
version.Text = "v1.2.0"
version.TextColor3 = Color3.fromRGB(150, 150, 150)
version.TextSize = 12
version.Font = Enum.Font.GothamMedium
version.TextXAlignment = Enum.TextXAlignment.Right

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.95, -30, 0.5, -15)
closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.white
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- 状态指示器
local statusIndicator = Instance.new("Frame")
statusIndicator.Name = "StatusIndicator"
statusIndicator.Size = UDim2.new(0, 12, 0, 12)
statusIndicator.Position = UDim2.new(0.02, 0, 0.5, -6)
statusIndicator.AnchorPoint = Vector2.new(0, 0.5)
statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(1, 0)
statusCorner.Parent = statusIndicator

-- 内容容器
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1

-- 创建可滚动区域
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- 主开关卡片
local mainToggleCard = Instance.new("Frame")
mainToggleCard.Name = "MainToggleCard"
mainToggleCard.Size = UDim2.new(1, 0, 0, 120)
mainToggleCard.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
mainToggleCard.BorderSizePixel = 0

local mainCardCorner = Instance.new("UICorner")
mainCardCorner.CornerRadius = UDim.new(0, 8)
mainCardCorner.Parent = mainToggleCard

-- 主开关标题
local mainToggleTitle = Instance.new("TextLabel")
mainToggleTitle.Name = "MainToggleTitle"
mainToggleTitle.Size = UDim2.new(1, -20, 0, 30)
mainToggleTitle.Position = UDim2.new(0, 10, 0, 10)
mainToggleTitle.BackgroundTransparency = 1
mainToggleTitle.Text = "🔫 自动瞄准系统"
mainToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
mainToggleTitle.TextSize = 16
mainToggleTitle.Font = Enum.Font.GothamBold
mainToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

-- 主开关描述
local mainToggleDesc = Instance.new("TextLabel")
mainToggleDesc.Name = "MainToggleDesc"
mainToggleDesc.Size = UDim2.new(1, -20, 0, 40)
mainToggleDesc.Position = UDim2.new(0, 10, 0, 40)
mainToggleDesc.BackgroundTransparency = 1
mainToggleDesc.Text = "自动瞄准最近的炸药桶或Boss目标。系统会预测目标移动轨迹并忽略透明障碍物。"
mainToggleDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
mainToggleDesc.TextSize = 13
mainToggleDesc.Font = Enum.Font.GothamMedium
mainToggleDesc.TextWrapped = true
mainToggleDesc.TextXAlignment = Enum.TextXAlignment.Left

-- 主开关按钮
local mainToggleButton = Instance.new("TextButton")
mainToggleButton.Name = "MainToggleButton"
mainToggleButton.Size = UDim2.new(0, 100, 0, 36)
mainToggleButton.Position = UDim2.new(0.5, -50, 1, -50)
mainToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
mainToggleButton.Text = "启用"
mainToggleButton.TextColor3 = Color3.white
mainToggleButton.TextSize = 14
mainToggleButton.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = mainToggleButton

-- 设置卡片
local settingsCard = Instance.new("Frame")
settingsCard.Name = "SettingsCard"
settingsCard.Size = UDim2.new(1, 0, 0, 180)
settingsCard.Position = UDim2.new(0, 0, 0, 130)
settingsCard.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
settingsCard.BorderSizePixel = 0

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsCard

-- 设置标题
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, -20, 0, 30)
settingsTitle.Position = UDim2.new(0, 10, 0, 10)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "⚙️ 高级设置"
settingsTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
settingsTitle.TextSize = 16
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

-- 目标类型选择
local targetTypeFrame = Instance.new("Frame")
targetTypeFrame.Name = "TargetTypeFrame"
targetTypeFrame.Size = UDim2.new(1, -20, 0, 40)
targetTypeFrame.Position = UDim2.new(0, 10, 0, 40)
targetTypeFrame.BackgroundTransparency = 1

local targetTypeLabel = Instance.new("TextLabel")
targetTypeLabel.Name = "TargetTypeLabel"
targetTypeLabel.Size = UDim2.new(0.6, 0, 1, 0)
targetTypeLabel.BackgroundTransparency = 1
targetTypeLabel.Text = "优先目标类型:"
targetTypeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetTypeLabel.TextSize = 14
targetTypeLabel.Font = Enum.Font.GothamMedium
targetTypeLabel.TextXAlignment = Enum.TextXAlignment.Left

local targetTypeDropdown = Instance.new("TextButton")
targetTypeDropdown.Name = "TargetTypeDropdown"
targetTypeDropdown.Size = UDim2.new(0.35, 0, 0.7, 0)
targetTypeDropdown.Position = UDim2.new(0.65, 0, 0.15, 0)
targetTypeDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
targetTypeDropdown.Text = "炸药桶优先"
targetTypeDropdown.TextColor3 = Color3.fromRGB(220, 220, 220)
targetTypeDropdown.TextSize = 12
targetTypeDropdown.Font = Enum.Font.GothamMedium

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = targetTypeDropdown

-- 预测时间滑块
local predictionFrame = Instance.new("Frame")
predictionFrame.Name = "PredictionFrame"
predictionFrame.Size = UDim2.new(1, -20, 0, 50)
predictionFrame.Position = UDim2.new(0, 10, 0, 90)
predictionFrame.BackgroundTransparency = 1

local predictionLabel = Instance.new("TextLabel")
predictionLabel.Name = "PredictionLabel"
predictionLabel.Size = UDim2.new(1, 0, 0, 20)
predictionLabel.BackgroundTransparency = 1
predictionLabel.Text = "子弹预测时间: 0.2s"
predictionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
predictionLabel.TextSize = 14
predictionLabel.Font = Enum.Font.GothamMedium
predictionLabel.TextXAlignment = Enum.TextXAlignment.Left

local predictionSlider = Instance.new("Frame")
predictionSlider.Name = "PredictionSlider"
predictionSlider.Size = UDim2.new(1, 0, 0, 6)
predictionSlider.Position = UDim2.new(0, 0, 0, 25)
predictionSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
predictionSlider.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = predictionSlider

local predictionFill = Instance.new("Frame")
predictionFill.Name = "PredictionFill"
predictionFill.Size = UDim2.new(0.4, 0, 1, 0)
predictionFill.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
predictionFill.BorderSizePixel = 0

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = predictionFill

local predictionKnob = Instance.new("TextButton")
predictionKnob.Name = "PredictionKnob"
predictionKnob.Size = UDim2.new(0, 16, 0, 16)
predictionKnob.Position = UDim2.new(0.4, -8, 0.5, -8)
predictionKnob.AnchorPoint = Vector2.new(0.5, 0.5)
predictionKnob.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
predictionKnob.Text = ""
predictionKnob.AutoButtonColor = false

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = predictionKnob

-- 状态监控卡片
local statusCard = Instance.new("Frame")
statusCard.Name = "StatusCard"
statusCard.Size = UDim2.new(1, 0, 0, 160)
statusCard.Position = UDim2.new(0, 0, 0, 320)
statusCard.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
statusCard.BorderSizePixel = 0

local statusCardCorner = Instance.new("UICorner")
statusCardCorner.CornerRadius = UDim.new(0, 8)
statusCardCorner.Parent = statusCard

-- 状态标题
local statusCardTitle = Instance.new("TextLabel")
statusCardTitle.Name = "StatusCardTitle"
statusCardTitle.Size = UDim2.new(1, -20, 0, 30)
statusCardTitle.Position = UDim2.new(0, 10, 0, 10)
statusCardTitle.BackgroundTransparency = 1
statusCardTitle.Text = "📊 系统状态"
statusCardTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
statusCardTitle.TextSize = 16
statusCardTitle.Font = Enum.Font.GothamBold
statusCardTitle.TextXAlignment = Enum.TextXAlignment.Left

-- 目标计数器
local targetCountFrame = Instance.new("Frame")
targetCountFrame.Name = "TargetCountFrame"
targetCountFrame.Size = UDim2.new(1, -20, 0, 25)
targetCountFrame.Position = UDim2.new(0, 10, 0, 45)
targetCountFrame.BackgroundTransparency = 1

local barrelCountLabel = Instance.new("TextLabel")
barrelCountLabel.Name = "BarrelCountLabel"
barrelCountLabel.Size = UDim2.new(0.5, -5, 1, 0)
barrelCountLabel.BackgroundTransparency = 1
barrelCountLabel.Text = "炸药桶: 0"
barrelCountLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
barrelCountLabel.TextSize = 13
barrelCountLabel.Font = Enum.Font.GothamMedium
barrelCountLabel.TextXAlignment = Enum.TextXAlignment.Left

local bossCountLabel = Instance.new("TextLabel")
bossCountLabel.Name = "BossCountLabel"
bossCountLabel.Size = UDim2.new(0.5, -5, 1, 0)
bossCountLabel.Position = UDim2.new(0.5, 5, 0, 0)
bossCountLabel.BackgroundTransparency = 1
bossCountLabel.Text = "Boss部件: 0"
bossCountLabel.TextColor3 = Color3.fromRGB(255, 50, 100)
bossCountLabel.TextSize = 13
bossCountLabel.Font = Enum.Font.GothamMedium
bossCountLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 距离指示器
local distanceFrame = Instance.new("Frame")
distanceFrame.Name = "DistanceFrame"
distanceFrame.Size = UDim2.new(1, -20, 0, 25)
distanceFrame.Position = UDim2.new(0, 10, 0, 75)
distanceFrame.BackgroundTransparency = 1

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Name = "DistanceLabel"
distanceLabel.Size = UDim2.new(1, 0, 1, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "最近目标: 无"
distanceLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
distanceLabel.TextSize = 13
distanceLabel.Font = Enum.Font.GothamMedium
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 视野角度指示器
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVFrame"
fovFrame.Size = UDim2.new(1, -20, 0, 25)
fovFrame.Position = UDim2.new(0, 10, 0, 105)
fovFrame.BackgroundTransparency = 1

local fovLabel = Instance.new("TextLabel")
fovLabel.Name = "FOVLabel"
fovLabel.Size = UDim2.new(1, 0, 1, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "视野角度: 90°"
fovLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
fovLabel.TextSize = 13
fovLabel.Font = Enum.Font.GothamMedium
fovLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 性能监控
local performanceFrame = Instance.new("Frame")
performanceFrame.Name = "PerformanceFrame"
performanceFrame.Size = UDim2.new(1, -20, 0, 25)
performanceFrame.Position = UDim2.new(0, 10, 0, 135)
performanceFrame.BackgroundTransparency = 1

local performanceLabel = Instance.new("TextLabel")
performanceLabel.Name = "PerformanceLabel"
performanceLabel.Size = UDim2.new(1, 0, 1, 0)
performanceLabel.BackgroundTransparency = 1
performanceLabel.Text = "响应延迟: 0ms"
performanceLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
performanceLabel.TextSize = 13
performanceLabel.Font = Enum.Font.GothamMedium
performanceLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 信息卡片
local infoCard = Instance.new("Frame")
infoCard.Name = "InfoCard"
infoCard.Size = UDim2.new(1, 0, 0, 100)
infoCard.Position = UDim2.new(0, 0, 0, 490)
infoCard.BackgroundColor3 = Color3.fromRGB(35, 40, 45)
infoCard.BorderSizePixel = 0

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoCard

local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, -20, 1, -20)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "💡 提示: 系统会自动扫描炸药桶和Boss目标，预测移动轨迹并自动瞄准。仅在装备枪支时激活。"
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- 折叠按钮
local collapseButton = Instance.new("TextButton")
collapseButton.Name = "CollapseButton"
collapseButton.Size = UDim2.new(0, 40, 0, 40)
collapseButton.Position = UDim2.new(1, -45, 0, 10)
collapseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
collapseButton.Text = "«"
collapseButton.TextColor3 = Color3.white
collapseButton.TextSize = 18
collapseButton.Font = Enum.Font.GothamBold

local collapseCorner = Instance.new("UICorner")
collapseCorner.CornerRadius = UDim.new(0, 8)
collapseCorner.Parent = collapseButton

-- 组装UI
predictionFill.Parent = predictionSlider
predictionKnob.Parent = predictionSlider

barrelCountLabel.Parent = targetCountFrame
bossCountLabel.Parent = targetCountFrame

distanceLabel.Parent = distanceFrame
fovLabel.Parent = fovFrame
performanceLabel.Parent = performanceFrame

targetCountFrame.Parent = statusCard
distanceFrame.Parent = statusCard
fovFrame.Parent = statusCard
performanceFrame.Parent = statusCard

targetTypeLabel.Parent = targetTypeFrame
targetTypeDropdown.Parent = targetTypeFrame

predictionLabel.Parent = predictionFrame
predictionSlider.Parent = predictionFrame

targetTypeFrame.Parent = settingsCard
predictionFrame.Parent = settingsCard

mainToggleTitle.Parent = mainToggleCard
mainToggleDesc.Parent = mainToggleCard
mainToggleButton.Parent = mainToggleCard

statusIndicator.Parent = titleBar
title.Parent = titleBar
version.Parent = titleBar
closeButton.Parent = titleBar

mainToggleCard.Parent = scrollFrame
settingsCard.Parent = scrollFrame
statusCard.Parent = scrollFrame
infoCard.Parent = scrollFrame

scrollFrame.Parent = contentFrame
titleBar.Parent = mainFrame
contentFrame.Parent = mainFrame
collapseButton.Parent = mainFrame

shadow.Parent = screenGui
mainFrame.Parent = screenGui
screenGui.Parent = player:WaitForChild("PlayerGui")

-- UI 动画函数
local function animateButton(button, targetColor)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = targetColor})
    tween:Play()
end

local function updateStatusIndicator(color)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(statusIndicator, tweenInfo, {BackgroundColor3 = color})
    tween:Play()
end

-- 初始化状态
local isEnabled = false
local isCollapsed = false
local lastUpdateTime = tick()

-- 主开关功能
mainToggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    
    if isEnabled then
        mainToggleButton.Text = "关闭"
        mainToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        updateStatusIndicator(Color3.fromRGB(50, 255, 50))
        
        -- 这里应该调用你的自动瞄准系统的启用函数
        -- shoot.toggle("开启自动瞄准炸药桶", true)
    else
        mainToggleButton.Text = "启用"
        mainToggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        statusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        updateStatusIndicator(Color3.fromRGB(255, 50, 50))
        
        -- 这里应该调用你的自动瞄准系统的关闭函数
        -- shoot.toggle("开启自动瞄准炸药桶", false)
    end
end)

-- 鼠标悬停效果
mainToggleButton.MouseEnter:Connect(function()
    animateButton(mainToggleButton, isEnabled and Color3.fromRGB(220, 70, 70) or Color3.fromRGB(70, 170, 70))
end)

mainToggleButton.MouseLeave:Connect(function()
    animateButton(mainToggleButton, isEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 150, 50))
end)

closeButton.MouseEnter:Connect(function()
    animateButton(closeButton, Color3.fromRGB(220, 70, 70))
end)

closeButton.MouseLeave:Connect(function()
    animateButton(closeButton, Color3.fromRGB(200, 50, 50))
end)

targetTypeDropdown.MouseEnter:Connect(function()
    animateButton(targetTypeDropdown, Color3.fromRGB(70, 70, 80))
end)

targetTypeDropdown.MouseLeave:Connect(function()
    animateButton(targetTypeDropdown, Color3.fromRGB(60, 60, 70))
end)

-- 关闭按钮
closeButton.MouseButton1Click:Connect(function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 550)})
    tween:Play()
    
    tween.Completed:Wait()
    screenGui:Destroy()
end)

-- 折叠/展开功能
collapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    
    if isCollapsed then
        collapseButton.Text = "»"
        mainFrame.Size = UDim2.new(0, 60, 0, 550)
        contentFrame.Visible = false
    else
        collapseButton.Text = "«"
        mainFrame.Size = UDim2.new(0, 420, 0, 550)
        contentFrame.Visible = true
    end
end)

-- 滑块功能
local isSliding = false
local sliderMin = 0.05
local sliderMax = 0.5

local function updatePredictionSlider(value)
    local percentage = (value - sliderMin) / (sliderMax - sliderMin)
    predictionFill.Size = UDim2.new(percentage, 0, 1, 0)
    predictionKnob.Position = UDim2.new(percentage, -8, 0.5, -8)
    predictionLabel.Text = string.format("子弹预测时间: %.2fs", value)
    
    -- 这里应该更新你的脚本中的 PREDICTION_TIME 变量
    -- PREDICTION_TIME = value
end

predictionKnob.MouseButton1Down:Connect(function()
    isSliding = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position
        local sliderPos = predictionSlider.AbsolutePosition
        local sliderSize = predictionSlider.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        local value = sliderMin + relativeX * (sliderMax - sliderMin)
        
        updatePredictionSlider(value)
    end
end)

-- 目标类型选择
targetTypeDropdown.MouseButton1Click:Connect(function()
    local options = {"炸药桶优先", "Boss优先", "最近目标"}
    local currentIndex = 1
    
    for i, option in ipairs(options) do
        if option == targetTypeDropdown.Text then
            currentIndex = i
            break
        end
    end
    
    local nextIndex = (currentIndex % #options) + 1
    targetTypeDropdown.Text = options[nextIndex]
    
    -- 这里应该更新你的脚本中的目标优先级逻辑
end)

-- 状态更新函数（这里需要与你实际的脚本数据连接）
local function updateStatusDisplay()
    local currentTime = tick()
    
    -- 模拟状态更新（实际使用时需要连接到你的脚本变量）
    if isEnabled then
        local mockBarrelCount = math.random(0, 5)
        local mockBossCount = math.random(0, 3)
        local mockDistance = math.random(0, 1000)
        local mockPerformance = math.random(1, 30)
        
        barrelCountLabel.Text = string.format("炸药桶: %d", mockBarrelCount)
        bossCountLabel.Text = string.format("Boss部件: %d", mockBossCount)
        
        if mockBarrelCount + mockBossCount > 0 then
            distanceLabel.Text = string.format("最近目标: %.1f studs", mockDistance)
        else
            distanceLabel.Text = "最近目标: 无"
        end
        
        performanceLabel.Text = string.format("响应延迟: %dms", mockPerformance)
    else
        barrelCountLabel.Text = "炸药桶: 0"
        bossCountLabel.Text = "Boss部件: 0"
        distanceLabel.Text = "最近目标: 无"
        performanceLabel.Text = "响应延迟: 0ms"
    end
    
    -- 更新最后更新时间
    lastUpdateTime = currentTime
end

-- 定期更新状态
local statusUpdateConnection
statusUpdateConnection = RunService.Heartbeat:Connect(function()
    if tick() - lastUpdateTime > 0.5 then -- 每0.5秒更新一次
        updateStatusDisplay()
    end
end)

-- 拖拽功能
local isDragging = false
local dragStart, frameStart

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if isDragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                frameStart.X.Scale,
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale,
                frameStart.Y.Offset + delta.Y
            )
        end
    end
end)

-- 键盘快捷键
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            isEnabled = not isEnabled
            mainToggleButton:Fire("MouseButton1Click")
        elseif input.KeyCode == Enum.KeyCode.RightShift then
            isCollapsed = not isCollapsed
            collapseButton:Fire("MouseButton1Click")
        end
    end
end)

-- 初始化滑块
updatePredictionSlider(0.2)

-- 清理连接
screenGui.Destroying:Connect(function()
    if statusUpdateConnection then
        statusUpdateConnection:Disconnect()
    end
end)

print("🎯 自动瞄准系统 UI 已加载!")
print("快捷键:")
print("  Right Ctrl - 切换启用/关闭")
print("  Right Shift - 折叠/展开面板")
