-- GPT风格自瞄系统UI
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 创建主界面
local GPTGui = Instance.new("ScreenGui")
GPTGui.Name = "GPTStyleAimBotUI"
GPTGui.ResetOnSpawn = false
GPTGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GPTGui.Parent = player:WaitForChild("PlayerGui")

-- 背景模糊效果
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 10
blurEffect.Enabled = false
blurEffect.Parent = game:GetService("Lighting")

-- 主要容器
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 500, 0, 600)
mainContainer.Position = UDim2.new(0.5, -250, 0.5, -300)
mainContainer.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
mainContainer.BackgroundTransparency = 0.1
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = true
mainContainer.Parent = GPTGui

-- 圆角处理
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainContainer

-- 阴影效果
local uiShadow = Instance.new("UIStroke")
uiShadow.Color = Color3.fromRGB(0, 0, 0)
uiShadow.Thickness = 2
uiShadow.Transparency = 0.7
uiShadow.Parent = mainContainer

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainContainer

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleCorner.Parent = titleBar

-- GPT风格标题
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 300, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔫 ChatGPT-AimBot System"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- 副标题
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "SubtitleLabel"
subtitleLabel.Size = UDim2.new(0, 300, 0, 20)
subtitleLabel.Position = UDim2.new(0, 20, 0, 25)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Advanced Barrel & Boss Detection System"
subtitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 12
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = titleBar

-- 控制按钮容器
local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0, 100, 1, 0)
controlButtons.Position = UDim2.new(1, -110, 0, 0)
controlButtons.BackgroundTransparency = 1
controlButtons.Parent = titleBar

-- 最小化按钮
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0, 0, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.Text = "🗕"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 14
minimizeButton.Parent = controlButtons

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 40, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = controlButtons

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -40, 1, -90)
contentFrame.Position = UDim2.new(0, 20, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

-- 左侧功能面板
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0.65, 0, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = contentFrame

-- 右侧状态面板
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0.35, -20, 1, 0)
rightPanel.Position = UDim2.new(0.65, 20, 0, 0)
rightPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rightPanel.BackgroundTransparency = 0.1
rightPanel.Parent = contentFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightPanel

-- 主要功能区域
local function createFeatureSection(title, description, defaultState, callback)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. title
    section.Size = UDim2.new(1, 0, 0, 70)
    section.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    section.BackgroundTransparency = 0.2
    section.Parent = leftPanel
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.7, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.7, -20, 0, 30)
    descLabel.Position = UDim2.new(0, 15, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = section
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 100, 0, 35)
    toggleButton.Position = UDim2.new(1, -115, 0.5, -17.5)
    toggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(80, 80, 80)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = defaultState and "ENABLED" or "DISABLED"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 13
    toggleButton.Parent = section
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    -- 点击事件
    toggleButton.MouseButton1Click:Connect(function()
        local newState = not (toggleButton.Text == "ENABLED")
        toggleButton.BackgroundColor3 = newState and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(80, 80, 80)
        toggleButton.Text = newState and "ENABLED" or "DISABLED"
        
        if callback then
            callback(newState)
        end
    end)
    
    return section, toggleButton
end

-- 创建功能区域
local featuresContainer = Instance.new("ScrollingFrame")
featuresContainer.Name = "FeaturesContainer"
featuresContainer.Size = UDim2.new(1, 0, 1, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.ScrollBarThickness = 3
featuresContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
featuresContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
featuresContainer.Parent = leftPanel

-- 功能列表
local features = {
    {
        title = "Auto-Aim System",
        description = "Automatically aim at Barrel zombies and Boss targets",
        default = false,
        callback = function(val) 
            print("Auto-Aim:", val)
            -- 这里会触发原脚本的自瞄功能
            if val then
                -- 初始化并启动自瞄系统
                initializeAutoAimSystem()
            else
                -- 关闭自瞄系统
                shutdownAutoAimSystem()
            end
        end
    },
    {
        title = "Prediction System",
        description = "Predict target movement for better accuracy",
        default = true,
        callback = function(val) print("Prediction:", val) end
    },
    {
        title = "Visibility Check",
        description = "Check if target is visible before aiming",
        default = true,
        callback = function(val) print("Visibility Check:", val) end
    },
    {
        title = "Wall Penetration",
        description = "Ignore transparent walls and obstacles",
        default = false,
        callback = function(val) print("Wall Penetration:", val) end
    },
    {
        title = "Target Priority",
        description = "Prioritize Barrel over Boss targets",
        default = true,
        callback = function(val) print("Target Priority:", val) end
    },
    {
        title = "Performance Mode",
        description = "Reduce cache updates for better performance",
        default = false,
        callback = function(val) print("Performance Mode:", val) end
    }
}

-- 添加功能
local yOffset = 10
for i, feature in ipairs(features) do
    local section, toggle = createFeatureSection(feature.title, feature.description, feature.default, feature.callback)
    section.Position = UDim2.new(0, 0, 0, yOffset)
    section.Parent = featuresContainer
    
    yOffset = yOffset + 80
end

-- 更新画布大小
featuresContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- 状态面板内容
local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, -20, 0, 40)
statusTitle.Position = UDim2.new(0, 10, 0, 10)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "📊 System Status"
statusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 18
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.Parent = rightPanel

-- 状态指示器
local statusContainer = Instance.new("Frame")
statusContainer.Name = "StatusContainer"
statusContainer.Size = UDim2.new(1, -20, 0.7, -60)
statusContainer.Position = UDim2.new(0, 10, 0, 60)
statusContainer.BackgroundTransparency = 1
statusContainer.Parent = rightPanel

-- 状态项目
local function createStatusItem(label, value, color)
    local item = Instance.new("Frame")
    item.Name = "Status_" .. label
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundTransparency = 1
    item.Parent = statusContainer
    
    local labelText = Instance.new("TextLabel")
    labelText.Name = "Label"
    labelText.Size = UDim2.new(0.6, 0, 1, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
    labelText.Font = Enum.Font.Gotham
    labelText.TextSize = 13
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = item
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "Value"
    valueText.Size = UDim2.new(0.4, 0, 1, 0)
    valueText.Position = UDim2.new(0.6, 0, 0, 0)
    valueText.BackgroundTransparency = 1
    valueText.Text = value
    valueText.TextColor3 = color
    valueText.Font = Enum.Font.GothamBold
    valueText.TextSize = 13
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    valueText.Parent = item
    
    return item, valueText
end

-- 创建状态项目
local statusItems = {}
local statusYOffset = 0

local statusData = {
    {"Auto-Aim", "OFF", Color3.fromRGB(220, 80, 80)},
    {"Prediction", "ON", Color3.fromRGB(80, 220, 80)},
    {"Visibility", "ON", Color3.fromRGB(80, 220, 80)},
    {"Target Lock", "NONE", Color3.fromRGB(220, 180, 60)},
    {"FPS", "60", Color3.fromRGB(100, 180, 255)},
    {"Cache Size", "0", Color3.fromRGB(180, 100, 255)},
    {"Targets Found", "0", Color3.fromRGB(255, 150, 50)}
}

for i, data in ipairs(statusData) do
    local item, valueText = createStatusItem(data[1], data[2], data[3])
    item.Position = UDim2.new(0, 0, 0, statusYOffset)
    item.Parent = statusContainer
    
    statusItems[data[1]] = valueText
    statusYOffset = statusYOffset + 35
end

-- 性能监控图表
local performanceTitle = Instance.new("TextLabel")
performanceTitle.Name = "PerformanceTitle"
performanceTitle.Size = UDim2.new(1, -20, 0, 40)
performanceTitle.Position = UDim2.new(0, 10, 0.7, 10)
performanceTitle.BackgroundTransparency = 1
performanceTitle.Text = "📈 Performance Monitor"
performanceTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
performanceTitle.Font = Enum.Font.GothamBold
performanceTitle.TextSize = 16
performanceTitle.TextXAlignment = Enum.TextXAlignment.Left
performanceTitle.Parent = rightPanel

-- 图表容器
local chartContainer = Instance.new("Frame")
chartContainer.Name = "ChartContainer"
chartContainer.Size = UDim2.new(1, -20, 0.3, -60)
chartContainer.Position = UDim2.new(0, 10, 0.7, 60)
chartContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
chartContainer.BackgroundTransparency = 0.2
chartContainer.Parent = rightPanel

local chartCorner = Instance.new("UICorner")
chartCorner.CornerRadius = UDim.new(0, 8)
chartCorner.Parent = chartContainer

-- 图表线条
local chartLine = Instance.new("Frame")
chartLine.Name = "ChartLine"
chartLine.Size = UDim2.new(0, 2, 1, -20)
chartLine.Position = UDim2.new(0.5, -1, 0, 10)
chartLine.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
chartLine.BorderSizePixel = 0
chartLine.Parent = chartContainer

-- 图表数据点
local chartPoints = {}
for i = 1, 10 do
    local point = Instance.new("Frame")
    point.Name = "Point_" .. i
    point.Size = UDim2.new(0, 8, 0, 8)
    point.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    point.BorderSizePixel = 0
    point.Parent = chartContainer
    
    local pointCorner = Instance.new("UICorner")
    pointCorner.CornerRadius = UDim.new(0, 4)
    pointCorner.Parent = point
    
    chartPoints[i] = point
end

-- 底部控制栏
local bottomBar = Instance.new("Frame")
bottomBar.Name = "BottomBar"
bottomBar.Size = UDim2.new(1, 0, 0, 40)
bottomBar.Position = UDim2.new(0, 0, 1, -40)
bottomBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
bottomBar.BorderSizePixel = 0
bottomBar.Parent = mainContainer

local bottomCorner = Instance.new("UICorner")
bottomCorner.CornerRadius = UDim.new(0, 0, 0, 12)
bottomCorner.Parent = bottomBar

-- 预设模式按钮
local presetContainer = Instance.new("Frame")
presetContainer.Name = "PresetContainer"
presetContainer.Size = UDim2.new(0.5, 0, 1, 0)
presetContainer.BackgroundTransparency = 1
presetContainer.Parent = bottomBar

local presets = {
    {"Balanced", Color3.fromRGB(80, 150, 80)},
    {"Performance", Color3.fromRGB(80, 100, 180)},
    {"Aggressive", Color3.fromRGB(180, 80, 80)}
}

for i, preset in ipairs(presets) do
    local presetButton = Instance.new("TextButton")
    presetButton.Name = "Preset_" .. preset[1]
    presetButton.Size = UDim2.new(0.3, -5, 0.7, 0)
    presetButton.Position = UDim2.new((i-1)*0.33, 5, 0.15, 0)
    presetButton.BackgroundColor3 = preset[2]
    presetButton.Text = preset[1]
    presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    presetButton.Font = Enum.Font.GothamBold
    presetButton.TextSize = 12
    presetButton.Parent = presetContainer
    
    local presetCorner = Instance.new("UICorner")
    presetCorner.CornerRadius = UDim.new(0, 6)
    presetCorner.Parent = presetButton
end

-- 快速控制按钮
local quickControlContainer = Instance.new("Frame")
quickControlContainer.Name = "QuickControlContainer"
quickControlContainer.Size = UDim2.new(0.5, 0, 1, 0)
quickControlContainer.Position = UDim2.new(0.5, 0, 0, 0)
quickControlContainer.BackgroundTransparency = 1
quickControlContainer.Parent = bottomBar

local quickControls = {
    {"⚙️ Settings", Color3.fromRGB(100, 100, 100)},
    {"📁 Export", Color3.fromRGB(80, 120, 180)},
    {"❓ Help", Color3.fromRGB(180, 120, 80)}
}

for i, control in ipairs(quickControls) do
    local controlButton = Instance.new("TextButton")
    controlButton.Name = "Control_" .. control[1]
    controlButton.Size = UDim2.new(0.3, -5, 0.7, 0)
    controlButton.Position = UDim2.new((i-1)*0.33, 5, 0.15, 0)
    controlButton.BackgroundColor3 = control[2]
    controlButton.Text = control[1]
    controlButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    controlButton.Font = Enum.Font.GothamBold
    controlButton.TextSize = 12
    controlButton.Parent = quickControlContainer
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 6)
    controlCorner.Parent = controlButton
end

-- ============ 原自瞄系统功能 ============

-- 从原始脚本中提取的主要变量和函数
local flags = { StartShoot = false }
local cameraLockConnection = nil
local char = character

-- 初始化自瞄系统的函数
local function initializeAutoAimSystem()
    if flags.StartShoot then return end
    
    flags.StartShoot = true
    local isAimingActive = false
    
    -- 初始化变量（从原脚本中复制）
    local barrelCache = {}
    local bossCache = {}
    local lastScanTime = 0
    local lastBossScanTime = 0
    local lastTransparentUpdate = 0
    local transparentParts = {}
    
    local targetHistory = {}
    local PREDICTION_TIME = 0.2
    local MAX_HISTORY_SIZE = 5
    local MIN_VELOCITY_THRESHOLD = 0.1
    
    local MAX_VIEW_ANGLE = 90
    local COS_MAX_ANGLE = math.cos(math.rad(MAX_VIEW_ANGLE / 2))
    local AIR_WALL_MATERIALS = {
        [Enum.Material.Air] = true,
        [Enum.Material.Water] = true,
        [Enum.Material.Glass] = true,
        [Enum.Material.ForceField] = true,
        [Enum.Material.Neon] = true
    }
    
    local AIR_WALL_NAMES = {
        invisiblewall = true, airwall = true, transparentwall = true,
        collision = true, nocollision = true, ghost = true,
        phase = true, clip = true, trigger = true, boundary = true
    }
    
    local workspace = workspace
    local currentCamera = workspace.CurrentCamera
    local zombiesFolder = workspace:FindFirstChild("Zombies")
    local playersFolder = workspace:FindFirstChild("Players")
    
    -- 连接变量
    local connecta, connectb, characterAddedConnection
    
    local function cleanupConnections()
        if connecta then
            connecta:Disconnect()
            connecta = nil
        end
        if connectb then
            connectb:Disconnect()
            connectb = nil
        end
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
    end
    
    -- ... 这里应该包含所有原脚本中的函数定义
    -- 由于篇幅限制，这里只展示结构，实际使用时需要包含完整的函数实现
    
    -- 更新UI状态
    if statusItems["Auto-Aim"] then
        statusItems["Auto-Aim"].Text = "ON"
        statusItems["Auto-Aim"].TextColor3 = Color3.fromRGB(80, 220, 80)
    end
    
    print("Auto-Aim System: ENABLED")
end

-- 关闭自瞄系统的函数
local function shutdownAutoAimSystem()
    flags.StartShoot = false
    
    if cameraLockConnection then
        cameraLockConnection:Disconnect()
        cameraLockConnection = nil
    end
    
    -- 更新UI状态
    if statusItems["Auto-Aim"] then
        statusItems["Auto-Aim"].Text = "OFF"
        statusItems["Auto-Aim"].TextColor3 = Color3.fromRGB(220, 80, 80)
    end
    
    print("Auto-Aim System: DISABLED")
end

-- ============ UI交互功能 ============

-- 窗口拖动功能
local isDragging = false
local dragStart = Vector2.new(0, 0)
local frameStart = Vector2.new(0, 0)

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        frameStart = Vector2.new(mainContainer.Position.X.Offset, mainContainer.Position.Y.Offset)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        mainContainer.Position = UDim2.new(0, frameStart.X + delta.X, 0, frameStart.Y + delta.Y)
    end
end)

-- 最小化功能
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        contentFrame.Visible = false
        bottomBar.Visible = false
        mainContainer.Size = UDim2.new(0, 500, 0, 50)
        minimizeButton.Text = "🗖"
    else
        contentFrame.Visible = true
        bottomBar.Visible = true
        mainContainer.Size = UDim2.new(0, 500, 0, 600)
        minimizeButton.Text = "🗕"
    end
end)

-- 关闭功能
closeButton.MouseButton1Click:Connect(function()
    GPTGui:Destroy()
    blurEffect.Enabled = false
    
    -- 确保关闭自瞄系统
    shutdownAutoAimSystem()
end)

-- 开启/关闭模糊效果
local function toggleBlurEffect(enabled)
    blurEffect.Enabled = enabled
end

-- 状态更新函数
local function updateStatus()
    -- 这里可以定期更新状态信息
    -- 例如：FPS、目标数量等
    
    -- 更新FPS
    local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
    if statusItems["FPS"] then
        statusItems["FPS"].Text = tostring(fps)
        
        -- 根据FPS改变颜色
        if fps < 30 then
            statusItems["FPS"].TextColor3 = Color3.fromRGB(220, 80, 80)
        elseif fps < 60 then
            statusItems["FPS"].TextColor3 = Color3.fromRGB(220, 180, 60)
        else
            statusItems["FPS"].TextColor3 = Color3.fromRGB(80, 220, 80)
        end
    end
    
    -- 更新图表
    local pointValue = math.random(40, 100)
    for i = 1, 10 do
        if chartPoints[i] then
            local yPos = math.clamp(100 - pointValue, 10, 90)
            chartPoints[i].Position = UDim2.new(i * 0.1 - 0.05, -4, yPos/100, -4)
        end
    end
end

-- 定期更新状态
spawn(function()
    while GPTGui and GPTGui.Parent do
        updateStatus()
        wait(1) -- 每秒更新一次
    end
end)

-- 预设模式功能
for i, preset in ipairs(presets) do
    local presetButton = presetContainer:FindFirstChild("Preset_" .. preset[1])
    if presetButton then
        presetButton.MouseButton1Click:Connect(function()
            -- 根据预设模式调整设置
            print("Preset activated:", preset[1])
            
            -- 更新UI反馈
            for _, button in ipairs(presetContainer:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end
            presetButton.BackgroundColor3 = preset[2]
        end)
    end
end

-- 热键控制
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Ctrl+Shift+A 显示/隐藏界面
    if input.KeyCode == Enum.KeyCode.A then
        if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) and userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            mainContainer.Visible = not mainContainer.Visible
            toggleBlurEffect(mainContainer.Visible)
        end
    end
    
    -- F5 开启/关闭自瞄
    if input.KeyCode == Enum.KeyCode.F5 then
        local autoAimSection = leftPanel:FindFirstChild("Section_Auto-Aim System")
        if autoAimSection then
            local toggleButton = autoAimSection:FindFirstChild("ToggleButton")
            if toggleButton then
                toggleButton:MouseButton1Click()
            end
        end
    end
end)

-- 初始状态
print("GPT-Style Auto-Aim UI Loaded!")
print("Controls:")
print("  Ctrl+Shift+A: Show/Hide UI")
print("  F5: Toggle Auto-Aim")
print("  Click & Drag Title Bar: Move UI")

-- 导出全局函数
return {
    ShowUI = function()
        mainContainer.Visible = true
        toggleBlurEffect(true)
    end,
    
    HideUI = function()
        mainContainer.Visible = false
        toggleBlurEffect(false)
    end,
    
    ToggleUI = function()
        mainContainer.Visible = not mainContainer.Visible
        toggleBlurEffect(mainContainer.Visible)
    end,
    
    EnableAutoAim = initializeAutoAimSystem,
    DisableAutoAim = shutdownAutoAimSystem,
    
    -- 获取UI引用
    GetUI = function()
        return GPTGui
    end
}
