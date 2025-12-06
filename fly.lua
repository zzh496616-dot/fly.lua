-- 义和团自动瞄准完整UI（修复滑块，保持完整功能）
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 创建主屏幕GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "义和团UI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建正方形主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true

-- 圆角效果
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Active = true

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10, 0, 0)
titleBarCorner.Parent = titleBar

-- 标题文本（彩虹效果）
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "义和团"
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextStrokeTransparency = 0.7
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(1, 0)
closeButtonCorner.Parent = closeButton

-- 缩放按钮
local scaleButton = Instance.new("TextButton")
scaleButton.Name = "ScaleButton"
scaleButton.Size = UDim2.new(0, 25, 0, 25)
scaleButton.Position = UDim2.new(1, -60, 0.5, -12.5)
scaleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
scaleButton.BackgroundTransparency = 0.3
scaleButton.Text = "↔"
scaleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleButton.TextScaled = true
scaleButton.Font = Enum.Font.GothamBold
scaleButton.AutoButtonColor = false

local scaleButtonCorner = Instance.new("UICorner")
scaleButtonCorner.CornerRadius = UDim.new(1, 0)
scaleButtonCorner.Parent = scaleButton

-- 创建内容区域
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -10, 1, -45)
contentArea.Position = UDim2.new(0, 5, 0, 40)
contentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 6)
contentCorner.Parent = contentArea

-- 创建滚动容器
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollingFrame.ScrollBarImageTransparency = 0.5
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

-- 创建功能列表容器
local functionsContainer = Instance.new("Frame")
functionsContainer.Name = "FunctionsContainer"
functionsContainer.Size = UDim2.new(1, 0, 0, 0)
functionsContainer.Position = UDim2.new(0, 0, 0, 0)
functionsContainer.BackgroundTransparency = 1

-- ============================================
-- 根据您的原始脚本，这是一个完整的自动瞄准系统
-- 包含了以下所有子功能和复杂逻辑：
-- 1. 主开关功能
-- 2. 炸药桶检测和瞄准
-- 3. Boss检测和瞄准  
-- 4. 预测瞄准系统
-- 5. 射线检测系统
-- 6. 透明墙检测系统
-- 7. 视角限制系统
-- 8. 武器检测系统
-- 9. 历史位置跟踪系统
-- 10. 缓存优化系统
-- ============================================

-- 全局变量
local flags = {
    StartShoot = false,  -- 主开关
    MaxDistance = 1000,  -- 最大距离
    SmoothAim = 0.3,     -- 平滑度
    PredictionTime = 0.2, -- 预测时间
    ScanInterval = 2,    -- 扫描间隔
    ViewAngle = 90       -- 视角角度
}

-- 创建开关按钮
local function createToggleButton(name, text, description, icon, color, defaultState, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -8, 0, 55)
    button.Position = UDim2.new(0, 4, 0, 0)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.2
    button.Text = ""
    button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- 图标
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 8, 0.5, -17.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.GothamBold
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.6, 0, 0.5, -2)
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 描述
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.6, 0, 0.5, -2)
    descLabel.Position = UDim2.new(0, 50, 0.5, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    descLabel.TextScaled = true
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 切换开关
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(0, 35, 0, 18)
    toggleFrame.Position = UDim2.new(1, -40, 0.5, -9)
    toggleFrame.BackgroundColor3 = defaultState and Color3.fromRGB(60, 220, 60) or Color3.fromRGB(120, 120, 120)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleFrame
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0, 14, 0, 14)
    toggleCircle.Position = defaultState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BackgroundTransparency = 0
    toggleCircle.BorderSizePixel = 0
    
    local toggleCircleCorner = Instance.new("UICorner")
    toggleCircleCorner.CornerRadius = UDim.new(1, 0)
    toggleCircleCorner.Parent = toggleCircle
    
    -- 状态变量
    local isEnabled = defaultState
    
    -- 切换函数
    local function toggleState()
        isEnabled = not isEnabled
        
        -- 动画效果
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad)
        
        if isEnabled then
            local tween1 = TweenService:Create(toggleFrame, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(60, 220, 60)
            })
            local tween2 = TweenService:Create(toggleCircle, tweenInfo, {
                Position = UDim2.new(1, -16, 0.5, -7)
            })
            tween1:Play()
            tween2:Play()
        else
            local tween1 = TweenService:Create(toggleFrame, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            })
            local tween2 = TweenService:Create(toggleCircle, tweenInfo, {
                Position = UDim2.new(0, 2, 0.5, -7)
            })
            tween1:Play()
            tween2:Play()
        end
        
        -- 执行回调函数
        if callback then
            callback(isEnabled)
        end
        
        return isEnabled
    end
    
    -- 按钮点击事件
    button.MouseButton1Click:Connect(toggleState)
    
    -- 组装按钮
    iconLabel.Parent = button
    titleLabel.Parent = button
    descLabel.Parent = button
    toggleCircle.Parent = toggleFrame
    toggleFrame.Parent = button
    
    return button, toggleState, function() return isEnabled end
end

-- 修复的滑块控件（简单版本，更容易滑动）
local function createSimpleSlider(name, text, description, icon, color, minValue, maxValue, defaultValue, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -8, 0, 65)
    button.Position = UDim2.new(0, 4, 0, 0)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.2
    button.Text = ""
    button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- 图标
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 8, 0, 10)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextScaled = true
    iconLabel.Font = Enum.Font.GothamBold
    
    -- 标题和值显示
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.7, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text .. ": " .. defaultValue
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 描述
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.7, 0, 0, 20)
    descLabel.Position = UDim2.new(0, 50, 0, 32)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    descLabel.TextScaled = true
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 滑块背景
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(0.8, 0, 0, 6)
    sliderBackground.Position = UDim2.new(0.1, 0, 1, -20)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBackground.BorderSizePixel = 0
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBackground
    
    -- 滑块填充
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFill.BorderSizePixel = 0
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    -- 当前值
    local currentValue = defaultValue
    
    -- 简单滑块逻辑：点击滑块设置值
    local function updateSlider(value)
        local normalized = math.clamp((value - minValue) / (maxValue - minValue), 0, 1)
        local roundedValue = math.floor(value * 10) / 10
        
        sliderFill.Size = UDim2.new(normalized, 0, 1, 0)
        titleLabel.Text = text .. ": " .. roundedValue
        currentValue = roundedValue
        
        if callback then
            callback(roundedValue)
        end
    end
    
    -- 点击滑块设置值
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouseX = input.Position.X
            local sliderPos = sliderBackground.AbsolutePosition
            local sliderSize = sliderBackground.AbsoluteSize
            
            local relativeX = (mouseX - sliderPos.X) / sliderSize.X
            local value = minValue + (maxValue - minValue) * relativeX
            updateSlider(value)
        end
    end)
    
    -- 拖拽滑块
    sliderBackground.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if input.UserInputState == Enum.UserInputState.Begin or input.UserInputState == Enum.UserInputState.Change then
                local mouseX = input.Position.X
                local sliderPos = sliderBackground.AbsolutePosition
                local sliderSize = sliderBackground.AbsoluteSize
                
                local relativeX = (mouseX - sliderPos.X) / sliderSize.X
                local value = minValue + (maxValue - minValue) * relativeX
                updateSlider(value)
            end
        end
    end)
    
    -- 组装
    iconLabel.Parent = button
    titleLabel.Parent = button
    descLabel.Parent = button
    sliderFill.Parent = sliderBackground
    sliderBackground.Parent = button
    
    return button, function() return currentValue end
end

-- ============================================
-- 完整的自动瞄准系统（您的原始脚本）
-- ============================================
local autoAimSystem = {
    enabled = false,
    cameraLockConnection = nil,
    isAimingActive = false,
    
    -- 缓存系统
    barrelCache = {},
    bossCache = {},
    lastScanTime = 0,
    lastBossScanTime = 0,
    lastTransparentUpdate = 0,
    transparentParts = {},
    targetHistory = {},
    
    -- 常量
    PREDICTION_TIME = 0.2,
    MAX_HISTORY_SIZE = 5,
    MIN_VELOCITY_THRESHOLD = 0.1,
    MAX_VIEW_ANGLE = 90,
    COS_MAX_ANGLE = math.cos(math.rad(90 / 2)),
    
    AIR_WALL_MATERIALS = {
        [Enum.Material.Air] = true,
        [Enum.Material.Water] = true,
        [Enum.Material.Glass] = true,
        [Enum.Material.ForceField] = true,
        [Enum.Material.Neon] = true
    },
    
    AIR_WALL_NAMES = {
        invisiblewall = true, airwall = true, transparentwall = true,
        collision = true, nocollision = true, ghost = true,
        phase = true, clip = true, trigger = true, boundary = true
    },
    
    -- 子功能开关
    AimBarrels = true,
    AimBoss = true,
    UsePrediction = true,
    CheckVisibility = true,
    
    -- 连接变量
    connecta = nil,
    connectb = nil,
    characterAddedConnection = nil
}

-- 清理连接
function autoAimSystem:cleanupConnections()
    if self.connecta then
        self.connecta:Disconnect()
        self.connecta = nil
    end
    if self.connectb then
        self.connectb:Disconnect()
        self.connectb = nil
    end
    if self.characterAddedConnection then
        self.characterAddedConnection:Disconnect()
        self.characterAddedConnection = nil
    end
end

-- 检查Boss是否存在
function autoAimSystem:checkBossExists()
    local sleepyHollow = workspace:FindFirstChild("Sleepy Hollow")
    if not sleepyHollow then return false end
    
    local modes = sleepyHollow:FindFirstChild("Modes")
    if not modes then return false end
    
    local bossFolder = modes:FindFirstChild("Boss")
    if not bossFolder then return false end
    
    local headlessHorsemanBoss = bossFolder:FindFirstChild("HeadlessHorsemanBoss")
    if not headlessHorsemanBoss then return false end
    
    local headlessHorseman = headlessHorsemanBoss:FindFirstChild("HeadlessHorseman")
    if not headlessHorseman then return false end
    
    local clothing = headlessHorseman:FindFirstChild("Clothing")
    if not clothing then return false end
    
    local torso = clothing:FindFirstChild("Torso")
    if not torso then return false end
    
    local head002 = torso:FindFirstChild("Head.002")
    local head003 = torso:FindFirstChild("Head.003")
    
    return head002 and head003 and head002:IsA("MeshPart") and head003:IsA("MeshPart")
end

-- 获取Boss目标部件
function autoAimSystem:getBossTargetParts()
    local targetParts = {}
    
    local sleepyHollow = workspace:FindFirstChild("Sleepy Hollow")
    if not sleepyHollow then return targetParts end
    
    local headlessHorseman = sleepyHollow.Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman
    if not headlessHorseman then return targetParts end
    
    local torso = headlessHorseman.Clothing.Torso
    if not torso then return targetParts end
    
    for _, child in pairs(torso:GetChildren()) do
        if child:IsA("MeshPart") then
            table.insert(targetParts, {
                part = child,
                name = child.Name,
                position = child.Position
            })
        end
    end
    
    return targetParts
end

-- 更新目标历史数据
function autoAimSystem:updateTargetHistory(target, currentPosition)
    if not self.targetHistory[target] then
        self.targetHistory[target] = {
            positions = {},
            timestamps = {},
            velocity = Vector3.zero,
            lastUpdate = tick()
        }
    end
    
    local history = self.targetHistory[target]
    local currentTime = tick()
    
    table.insert(history.positions, currentPosition)
    table.insert(history.timestamps, currentTime)
    
    while #history.positions > self.MAX_HISTORY_SIZE do
        table.remove(history.positions, 1)
        table.remove(history.timestamps, 1)
    end
    
    if #history.positions >= 2 then
        local latestPos = history.positions[#history.positions]
        local previousPos = history.positions[1]
        local timeDiff = history.timestamps[#history.timestamps] - history.timestamps[1]
        
        if timeDiff > 0 then
            local newVelocity = (latestPos - previousPos) / timeDiff
            history.velocity = history.velocity:Lerp(newVelocity, 0.5)
            
            if history.velocity.Magnitude < self.MIN_VELOCITY_THRESHOLD then
                history.velocity = Vector3.zero
            end
        end
    end
    
    history.lastUpdate = currentTime
end

-- 获取预测位置
function autoAimSystem:getPredictedPosition(target, currentPosition, predictionTime)
    local history = self.targetHistory[target]
    if not history or history.velocity.Magnitude < self.MIN_VELOCITY_THRESHOLD then
        return currentPosition
    end
    
    return currentPosition + history.velocity * predictionTime
end

-- 清理过时的历史数据
function autoAimSystem:cleanupOldTargetHistory()
    local currentTime = tick()
    local toRemove = {}
    
    for target, history in pairs(self.targetHistory) do
        if currentTime - history.lastUpdate > 5 or (typeof(target) == "Instance" and not target.Parent) then
            table.insert(toRemove, target)
        end
    end
    
    for _, target in ipairs(toRemove) do
        self.targetHistory[target] = nil
    end
end

-- 更新目标缓存
function autoAimSystem:updateTargetCache()
    table.clear(self.barrelCache)
    table.clear(self.bossCache)
    
    local zombiesFolder = workspace:FindFirstChild("Zombies")
    if zombiesFolder then 
        local children = zombiesFolder:GetChildren()
        for i = 1, #children do
            local v = children[i]
            if v:IsA("Model") and v.Name == "Agent" then
                if v:GetAttribute("Type") == "Barrel" then
                    local rootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso") or v.PrimaryPart
                    if rootPart then
                        table.insert(self.barrelCache, {
                            model = v, 
                            rootPart = rootPart,
                            type = "barrel"
                        })
                        self:updateTargetHistory(v, rootPart.Position)
                    end
                end
            end
        end
    end
    
    if self:checkBossExists() then
        local bossParts = self:getBossTargetParts()
        for _, bossPart in ipairs(bossParts) do
            table.insert(self.bossCache, {
                model = bossPart.part,
                rootPart = bossPart.part,
                type = "boss",
                name = bossPart.name
            })
            self:updateTargetHistory(bossPart.part, bossPart.part.Position)
        end
    end
    
    self.lastScanTime = tick()
    self.lastBossScanTime = tick()
    self:cleanupOldTargetHistory()
end

-- 更新透明部件缓存
function autoAimSystem:updateTransparentPartsCache()
    table.clear(self.transparentParts)
    local descendants = workspace:GetDescendants()
    for i = 1, #descendants do
        local v = descendants[i]
        if v:IsA("BasePart") and v.Transparency == 1 then
            table.insert(self.transparentParts, v)
        end
    end
    self.lastTransparentUpdate = tick()
end

-- 是否在视角范围内
function autoAimSystem:isWithinViewAngle(targetPosition, cameraCFrame)
    local cameraLookVector = cameraCFrame.LookVector
    local toTarget = (targetPosition - cameraCFrame.Position).Unit
    return cameraLookVector:Dot(toTarget) > self.COS_MAX_ANGLE
end

-- 是否透明或空气墙
function autoAimSystem:isTransparentOrAirWall(part)
    if part.Transparency == 1 then
        return true
    end
    
    if part.Transparency > 0.8 then
        return true
    end
    
    if self.AIR_WALL_MATERIALS[part.Material] then
        return true
    end
    
    if self.AIR_WALL_NAMES[part.Name:lower()] then
        return true
    end
    
    local color = part.BrickColor
    if color == BrickColor.new("Really black") or color == BrickColor.new("Really white") then
        return part.Transparency > 0.5
    end
    
    return false
end

-- 目标是否可见
function autoAimSystem:isTargetVisible(targetPart, cameraCFrame, char)
    if not char or not targetPart or not workspace.CurrentCamera then 
        return false 
    end
    
    local currentCamera = workspace.CurrentCamera
    local rayOrigin = cameraCFrame.Position
    local targetPosition = targetPart.Position
    local rayDirection = (targetPosition - rayOrigin)
    local rayDistance = rayDirection.Magnitude
    
    if rayDistance ~= rayDistance then
        return false
    end
    
    if not self:isWithinViewAngle(targetPosition, cameraCFrame) then
        return false
    end
    
    local ignoreList = {char, currentCamera}
    local playersFolder = workspace:FindFirstChild("Players")
    local zombiesFolder = workspace:FindFirstChild("Zombies")
    
    if playersFolder then
        local playerChildren = playersFolder:GetChildren()
        for i = 1, #playerChildren do
            local playerModel = playerChildren[i]
            if playerModel:IsA("Model") then
                table.insert(ignoreList, playerModel)
            end
        end
    end
    
    if zombiesFolder then
        local zombieChildren = zombiesFolder:GetChildren()
        for i = 1, #zombieChildren do
            local zombie = zombieChildren[i]
            if zombie:IsA("Model") and zombie.Name == "Agent" then
                if zombie:GetAttribute("Type") ~= "Barrel" then
                    table.insert(ignoreList, zombie)
                end
            end
        end
    end
    
    for i = 1, #self.transparentParts do
        local transparentPart = self.transparentParts[i]
        if transparentPart and transparentPart.Parent then
            table.insert(ignoreList, transparentPart)
        end
    end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if not rayResult then
        return true
    else
        local hitInstance = rayResult.Instance
        if hitInstance:IsDescendantOf(targetPart.Parent) then
            local hitDistance = (rayResult.Position - rayOrigin).Magnitude
            return math.abs(hitDistance - rayDistance) < 5
        end
        
        return self:isTransparentOrAirWall(rayResult.Instance)
    end
end

-- 查找最近可见目标
function autoAimSystem:findNearestVisibleTarget(cameraCFrame, char)
    local zombiesFolder = workspace:FindFirstChild("Zombies")
    local currentTime = tick()
    
    if currentTime - self.lastScanTime > flags.ScanInterval then
        self:updateTargetCache()
    end
    
    if currentTime - self.lastTransparentUpdate > 5 then
        self:updateTransparentPartsCache()
    end
    
    if (#self.barrelCache == 0 and #self.bossCache == 0) or not char then
        return nil, math.huge
    end
    
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return nil, math.huge
    end
    
    local playerPos = humanoidRootPart.Position
    local nearestTarget, minDistance = nil, math.huge
    
    -- 检查炸药桶目标（如果启用）
    if self.AimBarrels then
        for i = 1, #self.barrelCache do
            local target = self.barrelCache[i]
            if target.model and target.model.Parent and target.rootPart and target.rootPart.Parent then
                self:updateTargetHistory(target.model, target.rootPart.Position)
                
                if (not self.CheckVisibility) or self:isTargetVisible(target.rootPart, cameraCFrame, char) then
                    local distance = (playerPos - target.rootPart.Position).Magnitude
                    
                    if distance < minDistance and distance < flags.MaxDistance then
                        minDistance = distance
                        nearestTarget = target
                    end
                end
            end
        end
    end
    
    -- 检查Boss目标（如果启用）
    if self.AimBoss then
        for i = 1, #self.bossCache do
            local target = self.bossCache[i]
            if target.model and target.model.Parent and target.rootPart and target.rootPart.Parent then
                self:updateTargetHistory(target.model, target.rootPart.Position)
                
                if (not self.CheckVisibility) or self:isTargetVisible(target.rootPart, cameraCFrame, char) then
                    local distance = (playerPos - target.rootPart.Position).Magnitude
                    
                    if distance < minDistance and distance < flags.MaxDistance then
                        minDistance = distance
                        nearestTarget = target
                    end
                end
            end
        end
    end
    
    return nearestTarget, minDistance
end

-- 更新瞄准状态（检查是否有枪）
function autoAimSystem:updateAimingStatus(char)
    if not char then
        self.isAimingActive = false
        return
    end
    
    local hasGun = false
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("IsGun") == true then
            hasGun = true
            break
        end
    end
    self.isAimingActive = hasGun
end

-- 设置角色监听器
function autoAimSystem:setupCharacterListeners(char)
    self:cleanupConnections()
    
    if char then
        self.connecta = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and child:GetAttribute("IsGun") == true then
                self.isAimingActive = true
            end
            self:updateAimingStatus(char)
        end)
        
        self.connectb = char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                self:updateAimingStatus(char)
            end
        end)
        
        self:updateAimingStatus(char)
    end
end

-- 启动瞄准循环
function autoAimSystem:start()
    if self.enabled then return end
    self.enabled = true
    
    local char = player.Character
    self:updateTransparentPartsCache()
    self:updateTargetCache()
    self:setupCharacterListeners(char)
    
    -- 监听角色变化
    self.characterAddedConnection = player.CharacterAdded:Connect(function(newChar)
        char = newChar
        task.wait(1)
        self:setupCharacterListeners(char)
        self:updateTransparentPartsCache()
        self:updateTargetCache()
    end)
    
    -- 主循环
    self.cameraLockConnection = RunService.Heartbeat:Connect(function()
        if not flags.StartShoot or not self.enabled then 
            self:cleanupConnections()
            if self.cameraLockConnection then
                self.cameraLockConnection:Disconnect()
                self.cameraLockConnection = nil
            end
            return
        end
        
        if not char or not char.Parent or not workspace.CurrentCamera then
            return
        end
        
        if not self.isAimingActive then
            return
        end
        
        local cameraCFrame = workspace.CurrentCamera.CFrame
        local nearestTarget, distance = self:findNearestVisibleTarget(cameraCFrame, char)
        
        if nearestTarget and nearestTarget.rootPart then
            local currentPosition = nearestTarget.rootPart.Position
            local predictedPosition = self.UsePrediction and 
                self:getPredictedPosition(nearestTarget.model, currentPosition, flags.PredictionTime) or currentPosition
            local cameraPosition = cameraCFrame.Position
            
            if predictedPosition and cameraPosition then
                local lookCFrame = CFrame.lookAt(cameraPosition, predictedPosition)
                workspace.CurrentCamera.CFrame = cameraCFrame:Lerp(lookCFrame, flags.SmoothAim)
            end
        end
    end)
end

-- 停止瞄准
function autoAimSystem:stop()
    if not self.enabled then return end
    self.enabled = false
    
    if self.cameraLockConnection then
        self.cameraLockConnection:Disconnect()
        self.cameraLockConnection = nil
    end
    
    if self.targetHistory then
        table.clear(self.targetHistory)
    end
    
    self:cleanupConnections()
end

-- ============================================
-- 创建UI功能按钮（包含所有子功能）
-- ============================================

local totalHeight = 0
local buttons = {}

-- 1. 主开关 - 自动瞄准
local mainToggleBtn, toggleMain = createToggleButton(
    "MainToggle",
    "自动瞄准",
    "开启/关闭完整自动瞄准系统",
    "🎯",
    Color3.fromRGB(60, 150, 220),
    flags.StartShoot,
    function(val)
        flags.StartShoot = val
        if val then
            autoAimSystem:start()
            print("自动瞄准系统已开启")
        else
            autoAimSystem:stop()
            print("自动瞄准系统已关闭")
        end
    end
)
mainToggleBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
mainToggleBtn.Parent = functionsContainer
table.insert(buttons, mainToggleBtn)
totalHeight = totalHeight + 55 + 5

-- 2. 炸药桶瞄准开关
local barrelBtn, toggleBarrel = createToggleButton(
    "BarrelAim",
    "瞄准炸药桶",
    "开启/关闭炸药桶瞄准",
    "💣",
    Color3.fromRGB(220, 120, 60),
    autoAimSystem.AimBarrels,
    function(val)
        autoAimSystem.AimBarrels = val
        print("炸药桶瞄准:", val and "开启" or "关闭")
    end
)
barrelBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
barrelBtn.Parent = functionsContainer
table.insert(buttons, barrelBtn)
totalHeight = totalHeight + 55 + 5

-- 3. Boss瞄准开关
local bossBtn, toggleBoss = createToggleButton(
    "BossAim",
    "瞄准Boss",
    "开启/关闭Boss瞄准",
    "👹",
    Color3.fromRGB(180, 60, 220),
    autoAimSystem.AimBoss,
    function(val)
        autoAimSystem.AimBoss = val
        print("Boss瞄准:", val and "开启"或 "关闭")
    end
)
bossBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
bossBtn.Parent = functionsContainer
table.insert(buttons, bossBtn)
totalHeight = totalHeight + 55 + 5

-- 4. 预测瞄准开关
local predictionBtn, togglePrediction = createToggleButton(
    "Prediction",
    "预测瞄准",
    "开启/关闭预测瞄准",
    "🔮",
    Color3.fromRGB(150, 220, 60),
    autoAimSystem.UsePrediction,
    function(val)
        autoAimSystem.UsePrediction = val
        print("预测瞄准:", val and "开启" or "关闭")
    end
)
predictionBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
predictionBtn.Parent = functionsContainer
table.insert(buttons, predictionBtn)
totalHeight = totalHeight + 55 + 5

-- 5. 射线检测开关
local raycastBtn, toggleRaycast = createToggleButton(
    "Raycast",
    "射线检测",
    "开启/关闭障碍物检测",
    "🔍",
    Color3.fromRGB(60, 220, 180),
    autoAimSystem.CheckVisibility,
    function(val)
        autoAimSystem.CheckVisibility = val
        print("射线检测:", val and "开启" or "关闭")
    end
)
raycastBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
raycastBtn.Parent = functionsContainer
table.insert(buttons, raycastBtn)
totalHeight = totalHeight + 55 + 5

-- 6. 最大距离滑块
local distanceSlider = createSimpleSlider(
    "MaxDistance",
    "最大距离",
    "瞄准最大有效距离",
    "📏",
    Color3.fromRGB(220, 200, 60),
    100,
    2000,
    flags.MaxDistance,
    function(val)
        flags.MaxDistance = val
        print("最大距离设置为:", val)
    end
)
distanceSlider.Position = UDim2.new(0, 4, 0, totalHeight + 5)
distanceSlider.Parent = functionsContainer
table.insert(buttons, distanceSlider)
totalHeight = totalHeight + 65 + 5

-- 7. 平滑度滑块
local smoothSlider = createSimpleSlider(
    "SmoothAim",
    "平滑瞄准",
    "瞄准平滑度(0.1-1.0)",
    "🎛️",
    Color3.fromRGB(100, 60, 220),
    0.1,
    1.0,
    flags.SmoothAim,
    function(val)
        flags.SmoothAim = val
        print("平滑度设置为:", val)
    end
)
smoothSlider.Position = UDim2.new(0, 4, 0, totalHeight + 5)
smoothSlider.Parent = functionsContainer
table.insert(buttons, smoothSlider)
totalHeight = totalHeight + 65 + 5

-- 设置容器高度
functionsContainer.Size = UDim2.new(1, 0, 0, totalHeight)

-- 设置滚动区域大小
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

-- 组装UI
functionsContainer.Parent = scrollingFrame
scrollingFrame.Parent = contentArea
titleLabel.Parent = titleBar
closeButton.Parent = titleBar
scaleButton.Parent = titleBar
titleBar.Parent = mainFrame
contentArea.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = playerGui

-- 添加边框
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(1, 2, 1, 2)
border.Position = UDim2.new(0, -1, 0, -1)
border.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
border.BackgroundTransparency = 0.7
border.BorderSizePixel = 0
border.ZIndex = -1

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 11)
borderCorner.Parent = border
border.Parent = mainFrame

-- 彩虹颜色变换函数
local hue = 0
local function updateRainbowText()
    hue = (hue + 0.005) % 1
    local color = Color3.fromHSV(hue, 0.8, 1)
    titleLabel.TextColor3 = color
end

-- 关闭功能
closeButton.MouseButton1Click:Connect(function()
    -- 先关闭自动瞄准
    if flags.StartShoot then
        toggleMain()
    end
    
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
    local closeTween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 1, 0, 1),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
        print("UI已关闭！")
    end)
end)

-- 缩放功能
local isMinimized = false
local originalSize = mainFrame.Size
local originalPosition = mainFrame.Position

local function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        local minimizedSize = UDim2.new(0, 120, 0, 30)
        local minimizedPosition = UDim2.new(0.5, -60, 0, 10)
        
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = minimizedSize,
            Position = minimizedPosition,
            BackgroundTransparency = 0.4
        })
        tween:Play()
        
        contentArea.Visible = false
        titleLabel.Text = "义和团"
        titleLabel.Size = UDim2.new(0.9, 0, 1, 0)
        titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
        closeButton.Visible = false
        scaleButton.Visible = false
        
        print("UI已缩小为长方形")
        
    else
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = originalSize,
            Position = originalPosition,
            BackgroundTransparency = 0.2
        })
        tween:Play()
        
        contentArea.Visible = true
        titleLabel.Text = "义和团"
        titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
        closeButton.Visible = true
        scaleButton.Visible = true
        
        print("UI已展开为正方形")
    end
end

-- 修复点击检测器
local minimizedClicker = Instance.new("TextButton")
minimizedClicker.Name = "MinimizedClicker"
minimizedClicker.Size = UDim2.new(1, 0, 1, 0)
minimizedClicker.Position = UDim2.new(0, 0, 0, 0)
minimizedClicker.BackgroundTransparency = 1
minimizedClicker.Text = ""
minimizedClicker.BorderSizePixel = 0
minimizedClicker.Visible = false
minimizedClicker.Parent = screenGui

scaleButton.MouseButton1Click:Connect(function()
    toggleMinimize()
    
    if isMinimized then
        minimizedClicker.Size = UDim2.new(0, 120, 0, 30)
        minimizedClicker.Position = UDim2.new(0.5, -60, 0, 10)
        minimizedClicker.Visible = true
    else
        minimizedClicker.Visible = false
    end
end)

minimizedClicker.MouseButton1Click:Connect(function()
    if isMinimized then
        toggleMinimize()
        minimizedClicker.Visible = false
    end
end)

-- 按钮悬停效果
local function setupButtonHover(button)
    local originalColor = button.BackgroundColor3
    local originalTransparency = button.BackgroundTransparency
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0.1
        button.BackgroundColor3 = Color3.fromRGB(
            math.min(255, originalColor.R * 255 * 1.2),
            math.min(255, originalColor.G * 255 * 1.2),
            math.min(255, originalColor.B * 255 * 1.2)
        )
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = originalTransparency
        button.BackgroundColor3 = originalColor
    end)
end

-- 为所有按钮添加悬停效果
for _, button in ipairs(buttons) do
    setupButtonHover(button)
end

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundTransparency = 0.2
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundTransparency = 0.3
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
end)

scaleButton.MouseEnter:Connect(function()
    scaleButton.BackgroundTransparency = 0.2
    scaleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
end)

scaleButton.MouseLeave:Connect(function()
    scaleButton.BackgroundTransparency = 0.3
    scaleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
end)

-- 运行彩虹文本更新
RunService.RenderStepped:Connect(updateRainbowText)

print("=== 义和团自动瞄准完整系统已加载 ===")
print("包含所有子功能:")
print("1. 主开关 - 自动瞄准系统")
print("2. 炸药桶瞄准 - 可单独开关")
print("3. Boss瞄准 - 可单独开关")
print("4. 预测瞄准 - 可单独开关")
print("5. 射线检测 - 可单独开关")
print("6. 最大距离 - 滑块调节")
print("7. 平滑瞄准 - 滑块调节")
print("8. 透明墙检测系统")
print("9. 视角限制系统")
print("10. 武器检测系统")
print("11. 历史位置跟踪")
print("12. 缓存优化系统")
print("=================================")
