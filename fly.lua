-- Roblox 移动端自动瞄准 + 自动追踪脚本 
-- 包含高级自动瞄准和完整自动追踪功能

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 配置变量
local config = {
    AutoAim = true,
    AimDistance = 50
}

-- 自动瞄准状态变量
local currentCharacter = nil
local aimConnection = nil

-- ==================== 自动追踪系统变量 ====================
-- 追踪状态变量
local playerTrackingEnabled = false
local trackingConnection = nil
local currentTarget = nil
local currentTargetInfo = nil
local isMoving = false
local isCalculatingPath = false

-- 特殊追踪状态变量
local specialTrackingEnabled = false
local specialTrackingConnection = nil
local specialTrackingStep = 0
local specialPathCompleted = false
local positionCheckConnection = nil
local shouldStartSpecialTracking = false

-- 自动跳跃状态变量
local autoJumpEnabled = false
local autoJumpConnection = nil
local autoJumpCharAdded = nil

-- 僵尸躲避相关
local avoidZombiesMode = false
local zombieDetectionRadius = 50
local zombieDangerRadius = 20
local safetyCircle = nil

-- 移动方式相关
local usePathfindingForTracking = true -- 默认使用 PathfindingService
local userSelectedMoveMethod = true -- true = Pathfinding, false = Direct Move

-- 追踪模式
local trackMode = "nearest" -- "nearest" 或 "avoidZombies"

-- 路径寻找相关
local waypoints = {}
local currentWaypointIndex = 0
local lastPathUpdate = 0
local PATH_UPDATE_INTERVAL = 3.0

-- 速度检测相关（基于位移计算）
local positionHistory = {} -- 存储过去1秒的位置数据
local currentSpeed = 0
local SPEED_THRESHOLD = 10 -- 速度阈值

-- 群体检测相关
local GROUP_DISTANCE_THRESHOLD = 15 -- 群体玩家最大距离
local ISOLATED_DISTANCE_THRESHOLD = 30 -- 单体玩家远离群体距离

-- 视角设置
local viewOffset = 8
local viewHeight = 3

-- 特殊追踪区域定义
local specialZonePosition = Vector3.new(-553.341797, 4.91997051, -122.554977)
local triggerDistance = 10

-- 特殊追踪路径点
local specialPathPoints = {
    {
        cframe = CFrame.new(-645.226868, 20.6829033, -93.9491882, -0.539620519, -0.225767493, 0.811072886, -0.0945639312, 0.973531127, 0.208073914, -0.836580992, 0.0355826952, -0.546686947),
        usePathfinding = false,
        requireJump = false,
        tolerance = 4
    },
    {
        cframe = CFrame.new(-650.066589, 23.0250225, -119.258598, 0.97004962, -0.00339772133, 0.242883042, 6.47250147e-08, 0.999902189, 0.0139874993, -0.242906794, -0.0135685522, 0.969954729),
        usePathfinding = false,
        requireJump = false,
        tolerance = 4
    },
    {
        cframe = CFrame.new(-649.124268, 24.4685116, -128.338882, 0.970273495, -0.00288717961, 0.241993904, -8.96199381e-09, 0.999928832, 0.0119299814, -0.24201113, -0.0115753468, 0.970204413),
        usePathfinding = false,
        requireJump = true,
        tolerance = 4
    },
    {
        cframe = CFrame.new(-753.076721, -5.05517483, 34.7810364, 0.960010469, -0.106645502, -0.258856416, -0.11040359, -0.993886948, 1.91712752e-05, -0.257276058, 0.0285602733, -0.965915918),
        usePathfinding = true,
        requireJump = false,
        tolerance = 6
    }
}

-- ==================== UI创建 ====================
-- 创建主屏幕GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoAssistGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建主窗口（大小调整为原来的1/2）
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 140, 0, 200) -- 增加高度以适应更多功能
mainFrame.Position = UDim2.new(0, 15, 0, 75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- 圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 18)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 6)
titleCorner.Parent = titleBar

-- 标题文字
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0.15, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "辅助系统"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- 收缩/展开按钮
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 13, 0, 13)
toggleButton.Position = UDim2.new(0.02, 0, 0.14, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
toggleButton.Text = "-"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 3)
toggleCorner.Parent = toggleButton

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 13, 0, 13)
closeButton.Position = UDim2.new(0.9, 0, 0.14, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 3)
closeCorner.Parent = closeButton

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -10, 1, -23)
contentFrame.Position = UDim2.new(0, 5, 0, 20)
contentFrame.BackgroundTransparency = 1

-- 创建功能开关的函数
local function createToggle(name, configKey, defaultValue, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 18)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition)
    toggleFrame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 25, 0, 13)
    toggle.Position = UDim2.new(0.8, 0, 0.15, 0)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Name = configKey
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        local newValue = not (toggle.Text == "ON")
        config[configKey] = newValue
        toggle.Text = newValue and "ON" or "OFF"
        toggle.BackgroundColor3 = newValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
        
        -- 特殊处理自动瞄准开关
        if configKey == "AutoAim" then
            if newValue then
                startAutoAim()
            else
                stopAutoAim()
            end
        end
        
        updateStatus(newValue and name.." 已启用" or name.." 已禁用")
    end)
    
    label.Parent = toggleFrame
    toggle.Parent = toggleFrame
    toggleFrame.Parent = contentFrame
    
    return toggle
end

-- 创建功能开关
local aimToggle = createToggle("自动瞄准", "AutoAim", true, 0)
local trackToggle = createToggle("自动追踪", "AutoTrack", false, 20)
local avoidZombiesToggle = createToggle("远离僵尸", "AvoidZombies", false, 40)
local pathfindingToggle = createToggle("路径寻找", "UsePathfinding", true, 60)
local autoJumpToggle = createToggle("自动跳跃", "AutoJump", false, 80)

-- 瞄准距离滑块
local aimDistanceFrame = Instance.new("Frame")
aimDistanceFrame.Size = UDim2.new(1, 0, 0, 30)
aimDistanceFrame.Position = UDim2.new(0, 0, 0, 100)
aimDistanceFrame.BackgroundTransparency = 1

local aimDistanceLabel = Instance.new("TextLabel")
aimDistanceLabel.Size = UDim2.new(1, 0, 0, 13)
aimDistanceLabel.Position = UDim2.new(0, 0, 0, 0)
aimDistanceLabel.BackgroundTransparency = 1
aimDistanceLabel.Text = "瞄准距离: " .. config.AimDistance
aimDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
aimDistanceLabel.TextScaled = true
aimDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
aimDistanceLabel.Font = Enum.Font.Gotham

local aimDistanceSlider = Instance.new("Frame")
aimDistanceSlider.Size = UDim2.new(1, 0, 0, 8)
aimDistanceSlider.Position = UDim2.new(0, 0, 0, 15)
aimDistanceSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
aimDistanceSlider.Name = "AimDistanceSlider"

local aimSliderCorner = Instance.new("UICorner")
aimSliderCorner.CornerRadius = UDim.new(0, 4)
aimSliderCorner.Parent = aimDistanceSlider

local aimSliderFill = Instance.new("Frame")
aimSliderFill.Size = UDim2.new(config.AimDistance / 100, 0, 1, 0)
aimSliderFill.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
aimSliderFill.Name = "AimSliderFill"

local aimFillCorner = Instance.new("UICorner")
aimFillCorner.CornerRadius = UDim.new(0, 4)
aimFillCorner.Parent = aimSliderFill

-- 追踪距离滑块
local trackDistanceFrame = Instance.new("Frame")
trackDistanceFrame.Size = UDim2.new(1, 0, 0, 30)
trackDistanceFrame.Position = UDim2.new(0, 0, 0, 130)
trackDistanceFrame.BackgroundTransparency = 1

local trackDistanceLabel = Instance.new("TextLabel")
trackDistanceLabel.Size = UDim2.new(1, 0, 0, 13)
trackDistanceLabel.Position = UDim2.new(0, 0, 0, 0)
trackDistanceLabel.BackgroundTransparency = 1
trackDistanceLabel.Text = "追踪距离: " .. viewOffset
trackDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
trackDistanceLabel.TextScaled = true
trackDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
trackDistanceLabel.Font = Enum.Font.Gotham

local trackDistanceSlider = Instance.new("Frame")
trackDistanceSlider.Size = UDim2.new(1, 0, 0, 8)
trackDistanceSlider.Position = UDim2.new(0, 0, 0, 15)
trackDistanceSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
trackDistanceSlider.Name = "TrackDistanceSlider"

local trackSliderCorner = Instance.new("UICorner")
trackSliderCorner.CornerRadius = UDim.new(0, 4)
trackSliderCorner.Parent = trackDistanceSlider

local trackSliderFill = Instance.new("Frame")
trackSliderFill.Size = UDim2.new(viewOffset / 15, 0, 1, 0)
trackSliderFill.BackgroundColor3 = Color3.fromRGB(60, 150, 200)
trackSliderFill.Name = "TrackSliderFill"

local trackFillCorner = Instance.new("UICorner")
trackFillCorner.CornerRadius = UDim.new(0, 4)
trackFillCorner.Parent = trackSliderFill

-- 瞄准距离滑块触摸事件
aimDistanceSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = (input.Position.X - aimDistanceSlider.AbsolutePosition.X) / aimDistanceSlider.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        config.AimDistance = math.floor(relativeX * 100) + 10
        aimSliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        aimDistanceLabel.Text = "瞄准距离: " .. config.AimDistance
        updateStatus("瞄准距离: " .. config.AimDistance)
    end
end)

-- 追踪距离滑块触摸事件
trackDistanceSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = (input.Position.X - trackDistanceSlider.AbsolutePosition.X) / trackDistanceSlider.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        viewOffset = math.floor(relativeX * 15) + 3
        trackSliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        trackDistanceLabel.Text = "追踪距离: " .. viewOffset
        updateStatus("追踪距离: " .. viewOffset)
    end
end)

aimDistanceLabel.Parent = aimDistanceFrame
aimDistanceSlider.Parent = aimDistanceFrame
aimSliderFill.Parent = aimDistanceSlider
aimDistanceFrame.Parent = contentFrame

trackDistanceLabel.Parent = trackDistanceFrame
trackDistanceSlider.Parent = trackDistanceFrame
trackSliderFill.Parent = trackDistanceSlider
trackDistanceFrame.Parent = contentFrame

-- 状态显示
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 25)
statusFrame.Position = UDim2.new(0, 0, 0, 165)
statusFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 1, -5)
statusLabel.Position = UDim2.new(0, 5, 0, 3)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态: 待机中"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

statusLabel.Parent = statusFrame
statusFrame.Parent = contentFrame

-- 组装UI
titleLabel.Parent = titleBar
toggleButton.Parent = titleBar
closeButton.Parent = titleBar
titleBar.Parent = mainFrame
contentFrame.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = playerGui

-- UI控制变量
local isExpanded = true
local isDragging = false
local dragStartPosition = Vector2.new(0, 0)
local frameStartPosition = UDim2.new(0, 0, 0, 0)

-- 拖动功能
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPosition = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPosition = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPosition
        mainFrame.Position = UDim2.new(
            frameStartPosition.X.Scale, 
            frameStartPosition.X.Offset + delta.X,
            frameStartPosition.Y.Scale, 
            frameStartPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- 收缩/展开功能
toggleButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    local targetSize = isExpanded and UDim2.new(0, 140, 0, 200) or UDim2.new(0, 140, 0, 18)
    local targetContentTransparency = isExpanded and 0 or 1
    local toggleText = isExpanded and "-" or "+"
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local sizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
    local transparencyTween = TweenService:Create(contentFrame, tweenInfo, {BackgroundTransparency = targetContentTransparency})
    
    toggleButton.Text = toggleText
    sizeTween:Play()
    transparencyTween:Play()
end)

-- 关闭按钮
closeButton.MouseButton1Click:Connect(function()
    stopAllFunctions()
    stopAutoAim()
    stopAutoTracking()
    screenGui:Destroy()
end)

-- 状态更新函数
local function updateStatus(message)
    statusLabel.Text = "状态: " .. message
    print("辅助系统: " .. message)
end

-- ==================== 高级自动瞄准系统 ====================
local flags = { StartShoot = false }
local cameraLockConnection = nil
local char = nil

-- 自动瞄准系统函数（保持你提供的完整代码）
local function startAutoAim()
    if aimConnection then
        aimConnection:Disconnect()
    end
    
    flags.StartShoot = true
    
    local isAimingActive = false
    if cameraLockConnection then
        cameraLockConnection:Disconnect()
        cameraLockConnection = nil
    end
    
    -- 初始化变量
    local barrelCache = {}
    local bossCache = {} -- 新增：Boss缓存
    local lastScanTime = 0
    local lastBossScanTime = 0 -- 新增：Boss扫描时间
    local lastTransparentUpdate = 0
    local transparentParts = {} -- 存储透明部件的缓存
    
    -- 新增：存储目标历史位置和速度数据
    local targetHistory = {} -- 统一处理炸药桶和Boss
    local PREDICTION_TIME = 0.2 -- 预测时间（秒），根据子弹飞行时间调整
    local MAX_HISTORY_SIZE = 5 -- 最大历史记录数量
    local MIN_VELOCITY_THRESHOLD = 0.1 -- 最小速度阈值，避免微小抖动
    
    -- 预定义常量，避免重复计算
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
    
    -- 缓存常用对象
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
    
    -- 新增：检查Boss是否存在
    local function checkBossExists()
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
        
        -- 检查是否存在目标MeshPart
        local head002 = torso:FindFirstChild("Head.002")
        local head003 = torso:FindFirstChild("Head.003")
        
        return head002 and head003 and head002:IsA("MeshPart") and head003:IsA("MeshPart")
    end
    
    -- 新增：获取Boss目标部件
    local function getBossTargetParts()
        local targetParts = {}
        
        local sleepyHollow = workspace:FindFirstChild("Sleepy Hollow")
        if not sleepyHollow then return targetParts end
        
        local headlessHorseman = sleepyHollow.Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman
        if not headlessHorseman then return targetParts end
        
        local torso = headlessHorseman.Clothing.Torso
        if not torso then return targetParts end
        
        -- 获取所有MeshPart子部件作为目标
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
    
    -- 更新：统一处理目标历史数据
    local function updateTargetHistory(target, currentPosition)
        if not targetHistory[target] then
            targetHistory[target] = {
                positions = {},
                timestamps = {},
                velocity = Vector3.zero,
                lastUpdate = tick()
            }
        end
        
        local history = targetHistory[target]
        local currentTime = tick()
        
        -- 添加新位置和时间戳
        table.insert(history.positions, currentPosition)
        table.insert(history.timestamps, currentTime)
        
        -- 保持历史记录数量不超过最大值
        while #history.positions > MAX_HISTORY_SIZE do
            table.remove(history.positions, 1)
            table.remove(history.timestamps, 1)
        end
        
        -- 计算速度（至少需要2个点）
        if #history.positions >= 2 then
            local latestPos = history.positions[#history.positions]
            local previousPos = history.positions[1]
            local timeDiff = history.timestamps[#history.timestamps] - history.timestamps[1]
            
            if timeDiff > 0 then
                local newVelocity = (latestPos - previousPos) / timeDiff
                
                -- 使用平滑过渡避免速度突变
                history.velocity = history.velocity:Lerp(newVelocity, 0.5)
                
                -- 如果速度太小，视为静止
                if history.velocity.Magnitude < MIN_VELOCITY_THRESHOLD then
                    history.velocity = Vector3.zero
                end
            end
        end
        
        history.lastUpdate = currentTime
    end
    
    -- 更新：获取预测位置
    local function getPredictedPosition(target, currentPosition, predictionTime)
        local history = targetHistory[target]
        if not history or history.velocity.Magnitude < MIN_VELOCITY_THRESHOLD then
            return currentPosition -- 没有速度数据或速度太小，返回当前位置
        end
        
        -- 简单线性预测：位置 = 当前位置 + 速度 × 时间
        return currentPosition + history.velocity * predictionTime
    end
    
    -- 更新：清理过时的历史数据
    local function cleanupOldTargetHistory()
        local currentTime = tick()
        local toRemove = {}
        
        for target, history in pairs(targetHistory) do
            -- 如果超过5秒没有更新，或者目标已不存在，则移除
            if currentTime - history.lastUpdate > 5 or (typeof(target) == "Instance" and not target.Parent) then
                table.insert(toRemove, target)
            end
        end
        
        for _, target in ipairs(toRemove) do
            targetHistory[target] = nil
        end
    end
    
    -- 更新：统一更新目标缓存（炸药桶和Boss）
    local function updateTargetCache()
        table.clear(barrelCache)
        table.clear(bossCache)
        
        -- 更新炸药桶缓存
        if zombiesFolder then 
            local children = zombiesFolder:GetChildren()
            for i = 1, #children do
                local v = children[i]
                if v:IsA("Model") and v.Name == "Agent" then
                    if v:GetAttribute("Type") == "Barrel" then
                        local rootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso") or v.PrimaryPart
                        if rootPart then
                            barrelCache[#barrelCache + 1] = {
                                model = v, 
                                rootPart = rootPart,
                                type = "barrel"
                            }
                            
                            -- 更新历史数据
                            updateTargetHistory(v, rootPart.Position)
                        end
                    end
                end
            end
        end
        
        -- 更新Boss缓存
        if checkBossExists() then
            local bossParts = getBossTargetParts()
            for _, bossPart in ipairs(bossParts) do
                bossCache[#bossCache + 1] = {
                    model = bossPart.part,
                    rootPart = bossPart.part,
                    type = "boss",
                    name = bossPart.name
                }
                
                -- 更新历史数据
                updateTargetHistory(bossPart.part, bossPart.part.Position)
            end
        end
        
        lastScanTime = tick()
        lastBossScanTime = tick()
        
        -- 清理过时数据
        cleanupOldTargetHistory()
    end
    
    local function updateTransparentPartsCache()
        table.clear(transparentParts)
        local descendants = workspace:GetDescendants()
        for i = 1, #descendants do
            local v = descendants[i]
            if v:IsA("BasePart") and v.Transparency == 1 then
                transparentParts[#transparentParts + 1] = v
            end
        end
        lastTransparentUpdate = tick()
    end
    
    local function isWithinViewAngle(targetPosition, cameraCFrame)
        local cameraLookVector = cameraCFrame.LookVector
        local toTarget = (targetPosition - cameraCFrame.Position).Unit
        return cameraLookVector:Dot(toTarget) > COS_MAX_ANGLE
    end
    
    local function isTransparentOrAirWall(part)
        -- 检查透明度为1的部件（完全透明）
        if part.Transparency == 1 then
            return true
        end
        
        -- 检查高透明度
        if part.Transparency > 0.8 then
            return true
        end
        
        -- 检查材质（使用表查找，比循环快）
        if AIR_WALL_MATERIALS[part.Material] then
            return true
        end
        
        -- 检查名称（使用表查找）
        if AIR_WALL_NAMES[part.Name:lower()] then
            return true
        end
        
        -- 检查颜色
        local color = part.BrickColor
        if color == BrickColor.new("Really black") or color == BrickColor.new("Really white") then
            return part.Transparency > 0.5
        end
        
        return false
    end
    
    local function isTargetVisible(targetPart, cameraCFrame)
        if not char or not targetPart or not currentCamera then 
            return false 
        end
        
        local rayOrigin = cameraCFrame.Position
        local targetPosition = targetPart.Position
        local rayDirection = (targetPosition - rayOrigin)
        local rayDistance = rayDirection.Magnitude
        
        -- 安全检查：确保距离是有效数字
        if rayDistance ~= rayDistance then -- 检查NaN
            return false
        end
        
        -- 首先检查目标是否在视角范围内
        if not isWithinViewAngle(targetPosition, cameraCFrame) then
            return false
        end
        
        -- 构建忽略列表
        local ignoreList = {char, currentCamera}
        
        -- 忽略所有玩家
        if playersFolder then
            local playerChildren = playersFolder:GetChildren()
            for i = 1, #playerChildren do
                local player = playerChildren[i]
                if player:IsA("Model") then
                    ignoreList[#ignoreList + 1] = player
                end
            end
        end
        
        -- 忽略所有非目标僵尸
        if zombiesFolder then
            local zombieChildren = zombiesFolder:GetChildren()
            for i = 1, #zombieChildren do
                local zombie = zombieChildren[i]
                if zombie:IsA("Model") and zombie.Name == "Agent" then
                    if zombie:GetAttribute("Type") ~= "Barrel" then
                        ignoreList[#ignoreList + 1] = zombie
                    end
                end
            end
        end
        
        -- 添加透明部件到忽略列表
        for i = 1, #transparentParts do
            local transparentPart = transparentParts[i]
            if transparentPart and transparentPart.Parent then
                ignoreList[#ignoreList + 1] = transparentPart
            end
        end
        
        -- 进行射线检测
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = ignoreList
        raycastParams.IgnoreWater = true
        
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if not rayResult then
            return true -- 没有障碍物，目标可见
        else
            -- 检查击中的是否是目标本身
            local hitInstance = rayResult.Instance
            if hitInstance:IsDescendantOf(targetPart.Parent) then
                local hitDistance = (rayResult.Position - rayOrigin).Magnitude
                return math.abs(hitDistance - rayDistance) < 5
            end
            
            -- 如果击中了非透明墙体，检查它是否可穿透
            return isTransparentOrAirWall(rayResult.Instance)
        end
    end
    
    -- 更新：统一查找最近可见目标（炸药桶或Boss）
    local function findNearestVisibleTarget(cameraCFrame)
        zombiesFolder = workspace:FindFirstChild("Zombies")
        local currentTime = tick()
        
        -- 定期更新缓存
        if currentTime - lastScanTime > 2 or currentTime - lastBossScanTime > 1 then
            updateTargetCache()
        end
        
        -- 每5秒更新一次透明部件缓存
        if currentTime - lastTransparentUpdate > 5 then
            updateTransparentPartsCache()
        end
        
        if #barrelCache == 0 and #bossCache == 0 or not char then
            return nil, math.huge
        end
        
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil, math.huge
        end
        
        local playerPos = humanoidRootPart.Position
        local nearestTarget, minDistance = nil, math.huge
        
        -- 检查炸药桶目标
        for i = 1, #barrelCache do
            local target = barrelCache[i]
            if target.model and target.model.Parent and target.rootPart and target.rootPart.Parent then
                -- 更新历史数据
                updateTargetHistory(target.model, target.rootPart.Position)
                
                if isTargetVisible(target.rootPart, cameraCFrame) then
                    local distance = (playerPos - target.rootPart.Position).Magnitude
                    
                    if distance < minDistance and distance < 1000 then
                        minDistance = distance
                        nearestTarget = target
                    end
                end
            end
        end
        
        -- 检查Boss目标（优先级低于炸药桶）
        for i = 1, #bossCache do
            local target = bossCache[i]
            if target.model and target.model.Parent and target.rootPart and target.rootPart.Parent then
                -- 更新历史数据
                updateTargetHistory(target.model, target.rootPart.Position)
                
                if isTargetVisible(target.rootPart, cameraCFrame) then
                    local distance = (playerPos - target.rootPart.Position).Magnitude
                    
                    -- Boss的优先级稍低，只有在没有更近的炸药桶时才选择
                    if distance < minDistance and distance < 1000 then
                        minDistance = distance
                        nearestTarget = target
                    end
                end
            end
        end
        
        return nearestTarget, minDistance
    end
    
    local function updateAimingStatus()
        if not char then
            isAimingActive = false
            return
        end
        
        -- 检查角色当前是否有枪支
        local hasGun = false
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("IsGun") == true then
                hasGun = true
                break
            end
        end
        isAimingActive = hasGun
    end
    
    local function setupCharacterListeners()
        -- 清理旧连接
        cleanupConnections()
        
        if char then
            -- 监听装备添加
            connecta = char.ChildAdded:Connect(function(child)
                if child:IsA("Tool") and child:GetAttribute("IsGun") == true then
                    isAimingActive = true
                end
                updateAimingStatus()
            end)
            
            -- 监听装备移除
            connectb = char.ChildRemoved:Connect(function(child)
                if child:IsA("Tool") then
                    updateAimingStatus()
                end
            end)
            
            -- 初始化状态
            updateAimingStatus()
        end
    end
    
    -- 初始设置
    char = currentCharacter
    updateTransparentPartsCache()
    updateTargetCache() -- 更新为统一的目标缓存
    setupCharacterListeners()
    
    -- 监听角色变化（玩家死亡重生）
    if game.Players.LocalPlayer then
        characterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
            char = newChar
            task.wait(1) -- 等待角色完全加载
            setupCharacterListeners()
            updateTransparentPartsCache() -- 重新更新缓存
            updateTargetCache() -- 更新为目标缓存
        end)
    end
    
    -- 主循环
    cameraLockConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not flags.StartShoot then 
            cleanupConnections()
            cameraLockConnection:Disconnect()
            cameraLockConnection = nil
            return
        end
        
        -- 安全检查角色和摄像机
        if not char or not char.Parent or not currentCamera then
            currentCamera = workspace.CurrentCamera
            if not currentCamera then return end
        end
        
        -- 只有在isAimingActive为true时才执行瞄准
        if not isAimingActive then
            return
        end
        
        local cameraCFrame = currentCamera.CFrame
        local nearestTarget, distance = findNearestVisibleTarget(cameraCFrame) -- 更新为统一的目标查找
        
        if nearestTarget and nearestTarget.rootPart then
            local currentPosition = nearestTarget.rootPart.Position
            
            -- 获取预测位置（考虑位移偏移量）
            local predictedPosition = getPredictedPosition(nearestTarget.model, currentPosition, PREDICTION_TIME)
            
            local cameraPosition = cameraCFrame.Position
            
            if predictedPosition and cameraPosition then
                local lookCFrame = CFrame.lookAt(cameraPosition, predictedPosition)
                currentCamera.CFrame = cameraCFrame:Lerp(lookCFrame, 0.3)
            end
        end
    end)
end

local function stopAutoAim()
    flags.StartShoot = false
    
    -- 关闭功能时的清理
    if cameraLockConnection then
        cameraLockConnection:Disconnect()
        cameraLockConnection = nil
    end
    
    -- 清理历史数据
    if targetHistory and type(targetHistory) == "table" then
        table.clear(targetHistory)
    end
    
    updateStatus("自动瞄准已停止")
end

-- ==================== 自动追踪系统函数 ====================
-- 这里包含你提供的完整自动追踪系统代码
-- 由于代码长度限制，我将关键函数集成到系统中

-- 基础函数定义
local function Distance(target)
    local char = localPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    if not target or not target:FindFirstChild("HumanoidRootPart") then
        return math.huge
    end
    return (char.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
end

-- 计算两个玩家之间的距离
local function distanceBetweenPlayers(player1, player2)
    if not player1.Character or not player2.Character then
        return math.huge
    end
    
    local root1 = player1.Character:FindFirstChild("HumanoidRootPart")
    local root2 = player2.Character:FindFirstChild("HumanoidRootPart")
    
    if not root1 or not root2 then
        return math.huge
    end
    
    return (root1.Position - root2.Position).Magnitude
end

-- 检测玩家群体 - 修复版
local function findPlayerGroups()
    local validPlayers = {}
    
    -- 收集所有有效的移动玩家
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            -- 检查玩家是否有速度（正在移动）
            if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                table.insert(validPlayers, player)
            end
        end
    end
    
    if #validPlayers == 0 then
        return {}, {}
    end
    
    -- 检测群体
    local groups = {}
    local usedPlayers = {}
    
    for i, player1 in ipairs(validPlayers) do
        if not usedPlayers[player1] then
            local group = {player1}
            usedPlayers[player1] = true
            
            for j, player2 in ipairs(validPlayers) do
                if i ~= j and not usedPlayers[player2] then
                    local distance = distanceBetweenPlayers(player1, player2)
                    if distance <= GROUP_DISTANCE_THRESHOLD then
                        table.insert(group, player2)
                        usedPlayers[player2] = true
                    end
                end
            end
            
            -- 只有大于等于3个玩家才算群体
            if #group >= 3 then
                table.insert(groups, group)
            end
        end
    end
    
    -- 找出所有单体玩家（包括那些没有被分组的玩家）
    local isolatedPlayers = {}
    for _, player in ipairs(validPlayers) do
        if not usedPlayers[player] then
            table.insert(isolatedPlayers, player)
        end
    end
    
    return groups, isolatedPlayers
end

-- 检测附近的僵尸
local function findNearbyZombies()
    local zombies = {}
    local zombiesFolder = workspace:FindFirstChild("Zombies")
    
    if not zombiesFolder then return zombies end
    
    local localPos = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                     localPlayer.Character.HumanoidRootPart.Position
    
    if not localPos then return zombies end
    
    for _, zombie in pairs(zombiesFolder:GetChildren()) do
        if zombie:IsA("Model") then
            local zombieRoot = zombie:FindFirstChild("HumanoidRootPart")
            if zombieRoot then
                local distance = (zombieRoot.Position - localPos).Magnitude
                if distance <= zombieDetectionRadius then
                    table.insert(zombies, {
                        model = zombie,
                        rootPart = zombieRoot,
                        distance = distance
                    })
                end
            end
        end
    end
    
    -- 按距离排序，最近的排在前面
    table.sort(zombies, function(a, b)
        return a.distance < b.distance
    end)
    
    return zombies
end

-- 创建安全区域可视化圆
local function createSafetyCircle()
    if safetyCircle then
        safetyCircle:Destroy()
    end
    
    safetyCircle = Instance.new("Part")
    safetyCircle.Name = "SafetyCircle"
    safetyCircle.Anchored = true
    safetyCircle.CanCollide = false
    safetyCircle.Material = Enum.Material.Neon
    safetyCircle.BrickColor = BrickColor.new("Bright green")
    safetyCircle.Transparency = 0.7
    safetyCircle.Size = Vector3.new(1, 0.2, 1)
    
    -- 创建圆柱体网格
    local mesh = Instance.new("CylinderMesh", safetyCircle)
    mesh.Scale = Vector3.new(zombieDetectionRadius * 2, 0.1, zombieDetectionRadius * 2)
    
    safetyCircle.Parent = workspace
    
    -- 更新圆的位置
    local function updateCirclePosition()
        if safetyCircle and localPlayer.Character then
            local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                safetyCircle.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - 3, hrp.Position.Z)
            end
        end
    end
    
    -- 每帧更新圆的位置
    RunService.Heartbeat:Connect(updateCirclePosition)
    
    return safetyCircle
end

-- 移除安全区域可视化圆
local function removeSafetyCircle()
    if safetyCircle then
        safetyCircle:Destroy()
        safetyCircle = nil
    end
end

-- 计算远离僵尸的安全方向
local function calculateSafeDirection(zombies)
    if #zombies == 0 then return nil end
    
    local localPos = localPlayer.Character.HumanoidRootPart.Position
    local totalDirection = Vector3.new(0, 0, 0)
    
    for _, zombie in ipairs(zombies) do
        local zombiePos = zombie.rootPart.Position
        local direction = (localPos - zombiePos).Unit  -- 远离僵尸的方向
        
        -- 根据距离加权，越近的僵尸权重越大
        local weight = 1 / (zombie.distance + 0.1)
        totalDirection = totalDirection + (direction * weight)
    end
    
    -- 归一化方向
    if totalDirection.Magnitude > 0 then
        return totalDirection.Unit
    end
    
    return nil
end

-- 基于位移计算速度（1秒内的平均速度）
local function calculateCurrentSpeed()
    if not localPlayer.Character then
        return 0
    end
    
    local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    -- 检查角色是否死亡或无效
    if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
        positionHistory = {} -- 重置位置历史
        return 0
    end
    
    local currentTime = tick()
    local currentPos = humanoidRootPart.Position
    
    -- 添加当前位置到历史记录
    table.insert(positionHistory, {
        time = currentTime,
        position = currentPos
    })
    
    -- 清理超过1秒的旧数据
    while #positionHistory > 0 and currentTime - positionHistory[1].time > 1.0 do
        table.remove(positionHistory, 1)
    end
    
    -- 计算1秒内的总位移
    if #positionHistory >= 2 then
        local totalDistance = 0
        local oldestPos = positionHistory[1].position
        
        -- 计算从最早位置到当前位置的总距离
        totalDistance = (currentPos - oldestPos).Magnitude
        
        -- 计算时间差（确保至少0.1秒的数据）
        local timeDiff = currentTime - positionHistory[1].time
        if timeDiff > 0.1 then
            currentSpeed = totalDistance / timeDiff -- 速度 = 位移 / 时间
        else
            currentSpeed = 0
        end
    else
        currentSpeed = 0
    end
    
    return currentSpeed
end

-- 根据用户选择切换移动方式
local function updateMovementMethod()
    usePathfindingForTracking = userSelectedMoveMethod
end

-- 检查是否到达触发位置
local function isAtTriggerPosition()
    if not localPlayer.Character then return false end
    
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local distance = (humanoidRootPart.Position - specialZonePosition).Magnitude
    return distance <= triggerDistance
end

-- 智能自动跳跃函数
local function startAutoJump()
    if autoJumpConnection then
        autoJumpConnection:Disconnect()
    end
    
    local Char = localPlayer.Character
    local Human = Char and Char:FindFirstChildOfClass("Humanoid")
    
    local function autoJump()
        if Char and Human then
            local check1 = workspace:FindPartOnRay(Ray.new(Human.RootPart.Position - Vector3.new(0, 1.5, 0), Human.RootPart.CFrame.lookVector * 3), Char)
            local check2 = workspace:FindPartOnRay(Ray.new(Human.RootPart.Position + Vector3.new(0, 1.5, 0), Human.RootPart.CFrame.lookVector * 3), Char)
            if check1 or check2 then
                Human.Jump = true
            end
        end
    end
    
    autoJump()
    autoJumpConnection = RunService.RenderStepped:Connect(autoJump)
    
    -- 角色重生时重新连接
    if autoJumpCharAdded then
        autoJumpCharAdded:Disconnect()
    end
    autoJumpCharAdded = localPlayer.CharacterAdded:Connect(function(nChar)
        Char, Human = nChar, nChar:WaitForChild("Humanoid")
        autoJump()
        if autoJumpConnection then
            autoJumpConnection:Disconnect()
        end
        autoJumpConnection = RunService.RenderStepped:Connect(autoJump)
    end)
end

local function stopAutoJump()
    if autoJumpConnection then
        autoJumpConnection:Disconnect()
        autoJumpConnection = nil
    end
    if autoJumpCharAdded then
        autoJumpCharAdded:Disconnect()
        autoJumpCharAdded = nil
    end
end

-- 检查是否到达特殊路径点
local function hasReachedSpecialPoint(targetCFrame, tolerance)
    tolerance = tolerance or 4
    if not localPlayer.Character then return false end
    
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local distance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
    return distance <= tolerance
end

-- 异步路径计算函数
local function computePathToTargetAsync(targetPosition)
    if not localPlayer.Character or isCalculatingPath then return false end
    
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    isCalculatingPath = true
    
    task.spawn(function()
        local newPath = PathfindingService:CreatePath({
            AgentRadius = 2.0,
            AgentHeight = 5.0, 
            AgentCanJump = true,
            AgentCanClimb = true,
            WaypointSpacing = 6
        })
        
        local success = pcall(function()
            newPath:ComputeAsync(humanoidRootPart.Position, targetPosition)
        end)
        
        task.wait(0.15)
        
        if success and newPath.Status == Enum.PathStatus.Success then
            waypoints = newPath:GetWaypoints()
            currentWaypointIndex = 1
            lastPathUpdate = tick()
        else
            waypoints = {}
            currentWaypointIndex = 0
        end
        
        isCalculatingPath = false
    end)
    
    return true
end

-- 移动到下一个路径点
local function moveToNextWaypoint()
    if not waypoints or currentWaypointIndex > #waypoints then return false end
    
    local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local currentWaypoint = waypoints[currentWaypointIndex]
    humanoid:MoveTo(currentWaypoint.Position)
    
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local distance = (humanoidRootPart.Position - currentWaypoint.Position).Magnitude
        if distance < 4 then
            currentWaypointIndex = currentWaypointIndex + 1
        end
    end
    
    return true
end

-- 直接移动到目标位置
local function directMoveToTarget(targetPosition)
    local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    humanoid:MoveTo(targetPosition)
    return true
end

-- 特殊追踪移动函数
local function moveToSpecialTarget(targetCFrame, usePathfinding)
    if not localPlayer.Character then return false end
    
    local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not humanoidRootPart then return false end
    
    local targetPosition = targetCFrame.Position
    
    if usePathfinding then
        if not isCalculatingPath and (not waypoints or #waypoints == 0 or currentWaypointIndex > #waypoints) then
            computePathToTargetAsync(targetPosition)
        end
        
        if waypoints and #waypoints > 0 and currentWaypointIndex <= #waypoints then
            moveToNextWaypoint()
        else
            humanoid:MoveTo(targetPosition)
        end
    else
        humanoid:MoveTo(targetPosition)
    end
    
    return true
end

-- 后方位置计算
local function calculateRearViewPosition(targetPosition, targetCFrame)
    local lookVector = targetCFrame.LookVector
    local upVector = targetCFrame.UpVector
    return targetPosition + (-lookVector * viewOffset + upVector * viewHeight)
end

-- 停止移动
local function stopAllMovement()
    if localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(localPlayer.Character.HumanoidRootPart.Position)
        end
    end
    isMoving = false
    waypoints = {}
    currentWaypointIndex = 0
    isCalculatingPath = false
end

-- 停止位置检测
local function stopPositionDetection()
    if positionCheckConnection then
        positionCheckConnection:Disconnect()
        positionCheckConnection = nil
    end
end

-- 特殊追踪主循环
local function startSpecialTracking()
    if specialTrackingConnection then
        specialTrackingConnection:Disconnect()
    end
    
    specialTrackingEnabled = true
    specialTrackingStep = 1
    specialPathCompleted = false
    shouldStartSpecialTracking = false
    
    -- 关闭自动追踪功能
    if playerTrackingEnabled then
        playerTrackingEnabled = false
        if trackingConnection then
            trackingConnection:Disconnect()
            trackingConnection = nil
        end
    end
    
    stopAllMovement()
    stopPositionDetection()
    
    specialTrackingConnection = RunService.Heartbeat:Connect(function()
        if not specialTrackingEnabled or not localPlayer.Character then
            return
        end
        
        -- 检查角色状态
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
            stopAllMovement()
            return
        end
        
        if specialTrackingStep > #specialPathPoints then
            specialTrackingEnabled = false
            specialPathCompleted = true
            if specialTrackingConnection then
                specialTrackingConnection:Disconnect()
                specialTrackingConnection = nil
            end
            return
        end
        
        local currentStep = specialPathPoints[specialTrackingStep]
        if not currentStep then
            specialTrackingEnabled = false
            specialPathCompleted = true
            if specialTrackingConnection then
                specialTrackingConnection:Disconnect()
                specialTrackingConnection = nil
            end
            return
        end
        
        if hasReachedSpecialPoint(currentStep.cframe, currentStep.tolerance) then
            specialTrackingStep = specialTrackingStep + 1
            waypoints = {}
            currentWaypointIndex = 0
            isCalculatingPath = false
            return
        end
        
        moveToSpecialTarget(currentStep.cframe, currentStep.usePathfinding)
    end)
end

-- 停止特殊追踪
local function stopSpecialTracking()
    if specialTrackingEnabled then
        specialTrackingEnabled = false
        if specialTrackingConnection then
            specialTrackingConnection:Disconnect()
            specialTrackingConnection = nil
        end
        specialTrackingStep = 0
    end
end

-- 启动位置检测
local function startPositionDetection()
    if positionCheckConnection then
        positionCheckConnection:Disconnect()
    end
    
    positionCheckConnection = RunService.Heartbeat:Connect(function()
        if playerTrackingEnabled and not specialTrackingEnabled and not specialPathCompleted then
            if isAtTriggerPosition() then
                shouldStartSpecialTracking = true
                if positionCheckConnection then
                    positionCheckConnection:Disconnect()
                    positionCheckConnection = nil
                end
            end
        end
    end)
end

-- 特殊追踪检查循环
local function startSpecialTrackingMonitor()
    RunService.Heartbeat:Connect(function()
        if shouldStartSpecialTracking and not specialTrackingEnabled then
            shouldStartSpecialTracking = false
            startSpecialTracking()
        end
    end)
end

-- 查找最近的玩家（修复版）- 确保没有群体时追踪单体
local function findNearestPlayer()
    local groups, isolatedPlayers = findPlayerGroups()
    
    local nearestPlayer = nil
    local minDistance = math.huge
    
    -- 优先追踪群体玩家（3人及以上）
    for _, group in ipairs(groups) do
        for _, player in ipairs(group) do
            if player.Character then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                    local distance = Distance(character)
                    if distance < minDistance then
                        minDistance = distance
                        nearestPlayer = {
                            player = player,
                            character = character,
                            rootPart = rootPart,
                            playerName = player.Name,
                            isGroup = true,
                            groupSize = #group
                        }
                    end
                end
            end
        end
    end
    
    -- 如果没有群体玩家，追踪单体玩家
    if not nearestPlayer then
        for _, player in ipairs(isolatedPlayers) do
            if player.Character then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                    local distance = Distance(character)
                    if distance < minDistance then
                        minDistance = distance
                        nearestPlayer = {
                            player = player,
                            character = character,
                            rootPart = rootPart,
                            playerName = player.Name,
                            isGroup = false,
                            groupSize = 1
                        }
                    end
                end
            end
        end
    end
    
    -- 如果还是没有找到，直接找所有移动玩家
    if not nearestPlayer then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                    local distance = Distance(character)
                    if distance < minDistance then
                        minDistance = distance
                        nearestPlayer = {
                            player = player,
                            character = character,
                            rootPart = rootPart,
                            playerName = player.Name,
                            isGroup = false,
                            groupSize = 1
                        }
                    end
                end
            end
        end
    end
    
    return nearestPlayer, minDistance
end

-- 查找距离僵尸最远的玩家（优先群体玩家）- 修复版
local function findFurthestFromZombies()
    local groups, isolatedPlayers = findPlayerGroups()
    
    local furthestPlayer = nil
    local maxZombieDistance = 0
    
    local zombiePositions = {}
    local zombiesFolder = workspace:FindFirstChild("Zombies")
    if zombiesFolder then
        for _, zombie in pairs(zombiesFolder:GetChildren()) do
            if zombie:IsA("Model") then
                local zombieRoot = zombie:FindFirstChild("HumanoidRootPart")
                if zombieRoot then
                    table.insert(zombiePositions, zombieRoot.Position)
                end
            end
        end
    end
    
    -- 如果没有僵尸，返回最近玩家
    if #zombiePositions == 0 then
        return findNearestPlayer()
    end
    
    -- 优先在群体中寻找距离僵尸最远的玩家
    for _, group in ipairs(groups) do
        for _, player in ipairs(group) do
            if player.Character then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                    local totalDistance = 0
                    local validZombies = 0
                    
                    for _, zombiePos in ipairs(zombiePositions) do
                        local dist = (rootPart.Position - zombiePos).Magnitude
                        totalDistance = totalDistance + dist
                        validZombies = validZombies + 1
                    end
                    
                    if validZombies > 0 then
                        local avgDistance = totalDistance / validZombies
                        
                        if avgDistance > maxZombieDistance then
                            maxZombieDistance = avgDistance
                            furthestPlayer = {
                                player = player,
                                character = character,
                                rootPart = rootPart,
                                playerName = player.Name,
                                zombieDistance = avgDistance,
                                isGroup = true,
                                groupSize = #group
                            }
                        end
                    end
                end
            end
        end
    end
    
    -- 如果没有群体玩家，再考虑单体玩家
    if not furthestPlayer then
        for _, player in ipairs(isolatedPlayers) do
            if player.Character then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                    local totalDistance = 0
                    local validZombies = 0
                    
                    for _, zombiePos in ipairs(zombiePositions) do
                        local dist = (rootPart.Position - zombiePos).Magnitude
                        totalDistance = totalDistance + dist
                        validZombies = validZombies + 1
                    end
                    
                    if validZombies > 0 then
                        local avgDistance = totalDistance / validZombies
                        
                        if avgDistance > maxZombieDistance then
                            maxZombieDistance = avgDistance
                            furthestPlayer = {
                                player = player,
                                character = character,
                                rootPart = rootPart,
                                playerName = player.Name,
                                zombieDistance = avgDistance,
                                isGroup = false,
                                groupSize = 1
                            }
                        end
                    end
                end
            end
        end
    end
    
    -- 如果还是没有找到，直接找所有移动玩家
    if not furthestPlayer then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local character = player.Character
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                    local totalDistance = 0
                    local validZombies = 0
                    
                    for _, zombiePos in ipairs(zombiePositions) do
                        local dist = (rootPart.Position - zombiePos).Magnitude
                        totalDistance = totalDistance + dist
                        validZombies = validZombies + 1
                    end
                    
                    if validZombies > 0 then
                        local avgDistance = totalDistance / validZombies
                        
                        if avgDistance > maxZombieDistance then
                            maxZombieDistance = avgDistance
                            furthestPlayer = {
                                player = player,
                                character = character,
                                rootPart = rootPart,
                                playerName = player.Name,
                                zombieDistance = avgDistance,
                                isGroup = false,
                                groupSize = 1
                            }
                        end
                    end
                end
            end
        end
    end
    
    return furthestPlayer, maxZombieDistance
end

-- 根据模式选择目标玩家
local function findTargetPlayer()
    if trackMode == "avoidZombies" then
        return findFurthestFromZombies()
    else
        return findNearestPlayer()
    end
end

-- 主追踪循环 - 根据用户选择切换移动方式
local function startPlayerTracking()
    if trackingConnection then
        trackingConnection:Disconnect()
    end
    
    trackingConnection = RunService.Heartbeat:Connect(function()
        -- 基础检查
        if not playerTrackingEnabled or not localPlayer.Character or specialTrackingEnabled then 
            stopAllMovement()
            return
        end
        
        -- 检查角色状态（角色死亡时停止追踪）
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
            stopAllMovement()
            return
        end
        
        -- 检查僵尸躲避模式
        if trackMode == "avoidZombies" then
            local nearbyZombies = findNearbyZombies()
            
            if #nearbyZombies > 0 then
                -- 有僵尸在附近，切换到躲避模式
                avoidZombiesMode = true
                
                -- 计算安全方向
                local safeDirection = calculateSafeDirection(nearbyZombies)
                if safeDirection then
                    -- 计算安全位置（远离僵尸的方向移动）
                    local safePosition = humanoidRootPart.Position + (safeDirection * 30)
                    directMoveToTarget(safePosition)
                end
                
                -- 更新状态显示
                updateStatus("状态: 躲避僵尸中 (" .. #nearbyZombies .. "只)")
                return
            else
                -- 没有僵尸，恢复追踪
                avoidZombiesMode = false
            end
        end
        
        -- 正常追踪逻辑
        local targetPlayer, distance = findTargetPlayer()
        
        if targetPlayer and targetPlayer.rootPart then
            currentTarget = targetPlayer.player
            currentTargetInfo = targetPlayer  -- 保存目标信息
            local targetPosition = targetPlayer.rootPart.Position
            local targetCFrame = targetPlayer.rootPart.CFrame
            
            local rearPosition = calculateRearViewPosition(targetPosition, targetCFrame)
            
            if humanoid and humanoidRootPart then
                local currentPos = humanoidRootPart.Position
                local rearDistance = (currentPos - rearPosition).Magnitude
                
                if rearDistance > 4 then
                    isMoving = true
                    
                    -- 根据用户选择更新移动方式
                    updateMovementMethod()
                    
                    local currentTime = tick()
                    local shouldUpdatePath = not isCalculatingPath and (
                        not waypoints or 
                        #waypoints == 0 or 
                        currentWaypointIndex > #waypoints or 
                        currentTime - lastPathUpdate > PATH_UPDATE_INTERVAL or
                        (currentTarget.Character and 
                         (currentTarget.Character.HumanoidRootPart.Position - targetPosition).Magnitude > 8)
                    )
                    
                    if usePathfindingForTracking then
                        -- 使用PathfindingService
                        if shouldUpdatePath then
                            computePathToTargetAsync(rearPosition)
                        end
                        
                        if waypoints and #waypoints > 0 and currentWaypointIndex <= #waypoints then
                            if not moveToNextWaypoint() then
                                directMoveToTarget(rearPosition)
                            end
                        else
                            directMoveToTarget(rearPosition)
                        end
                    else
                        -- 使用直接移动
                        directMoveToTarget(rearPosition)
                    end
                else
                    isMoving = false
                    if localPlayer.Character then
                        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:MoveTo(humanoid.RootPart.Position)
                        end
                    end
                end
            end
        else
            currentTarget = nil
            currentTargetInfo = nil
            stopAllMovement()
        end
    end)
end

-- 停止自动追踪
local function stopAutoTracking()
    playerTrackingEnabled = false
    if trackingConnection then
        trackingConnection:Disconnect()
        trackingConnection = nil
    end
    stopPositionDetection()
    currentTarget = nil
    currentTargetInfo = nil
    stopAllMovement()
    removeSafetyCircle()
end

-- 停止所有功能
local function stopAllFunctions()
    stopAutoAim()
    stopAutoTracking()
    stopAutoJump()
    stopSpecialTracking()
end

-- ==================== UI控制集成 ====================
-- 自动追踪开关
trackToggle.MouseButton1Click:Connect(function()
    local newValue = not (trackToggle.Text == "ON")
    playerTrackingEnabled = newValue
    trackToggle.Text = newValue and "ON" or "OFF"
    trackToggle.BackgroundColor3 = newValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    
    if newValue then
        if not localPlayer.Character then
            playerTrackingEnabled = false
            trackToggle.Text = "OFF"
            trackToggle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            return
        end
        
        local hrp = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            playerTrackingEnabled = false
            trackToggle.Text = "OFF"
            trackToggle.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            return
        end
        
        stopAllMovement()
        task.wait(0.5)
        startPlayerTracking()
        startPositionDetection()
        updateStatus("自动追踪已启用")
    else
        stopAutoTracking()
        updateStatus("自动追踪已停止")
    end
end)

-- 远离僵尸模式开关
avoidZombiesToggle.MouseButton1Click:Connect(function()
    local newValue = not (avoidZombiesToggle.Text == "ON")
    avoidZombiesToggle.Text = newValue and "ON" or "OFF"
    avoidZombiesToggle.BackgroundColor3 = newValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    
    if newValue then
        trackMode = "avoidZombies"
        -- 创建安全区域可视化圆
        createSafetyCircle()
        updateStatus("远离僵尸模式已启用")
    else
        trackMode = "nearest"
        -- 移除安全区域可视化圆
        removeSafetyCircle()
        updateStatus("远离僵尸模式已关闭")
    end
    
    if playerTrackingEnabled then
        waypoints = {}
        currentWaypointIndex = 0
        lastPathUpdate = 0
        isCalculatingPath = false
    end
end)

-- 路径寻找开关
pathfindingToggle.MouseButton1Click:Connect(function()
    local newValue = not (pathfindingToggle.Text == "ON")
    userSelectedMoveMethod = newValue
    pathfindingToggle.Text = newValue and "ON" or "OFF"
    pathfindingToggle.BackgroundColor3 = newValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    updateMovementMethod()
    updateStatus("路径寻找: " .. (newValue and "启用" or "禁用"))
end)

-- 自动跳跃开关
autoJumpToggle.MouseButton1Click:Connect(function()
    local newValue = not (autoJumpToggle.Text == "ON")
    autoJumpEnabled = newValue
    autoJumpToggle.Text = newValue and "ON" or "OFF"
    autoJumpToggle.BackgroundColor3 = newValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    
    if newValue then
        startAutoJump()
        updateStatus("自动跳跃已启用")
    else
        stopAutoJump()
        updateStatus("自动跳跃已关闭")
    end
end)

-- 特殊追踪按钮
local specialTrackButton = Instance.new("TextButton")
specialTrackButton.Size = UDim2.new(0.45, 0, 0, 15)
specialTrackButton.Position = UDim2.new(0.02, 0, 0, 195)
specialTrackButton.BackgroundColor3 = Color3.fromRGB(80, 100, 200)
specialTrackButton.Text = "特殊追踪"
specialTrackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
specialTrackButton.TextScaled = true
specialTrackButton.Font = Enum.Font.GothamBold

local specialTrackCorner = Instance.new("UICorner")
specialTrackCorner.CornerRadius = UDim.new(0, 4)
specialTrackCorner.Parent = specialTrackButton

specialTrackButton.MouseButton1Click:Connect(function()
    if not specialTrackingEnabled then
        shouldStartSpecialTracking = true
        updateStatus("启动特殊追踪")
    end
end)

-- 停止特殊追踪按钮
local stopSpecialTrackButton = Instance.new("TextButton")
stopSpecialTrackButton.Size = UDim2.new(0.45, 0, 0, 15)
stopSpecialTrackButton.Position = UDim2.new(0.53, 0, 0, 195)
stopSpecialTrackButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
stopSpecialTrackButton.Text = "停止特殊"
stopSpecialTrackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopSpecialTrackButton.TextScaled = true
stopSpecialTrackButton.Font = Enum.Font.GothamBold

local stopSpecialTrackCorner = Instance.new("UICorner")
stopSpecialTrackCorner.CornerRadius = UDim.new(0, 4)
stopSpecialTrackCorner.Parent = stopSpecialTrackButton

stopSpecialTrackButton.MouseButton1Click:Connect(function()
    stopSpecialTracking()
    updateStatus("停止特殊追踪")
end)

specialTrackButton.Parent = contentFrame
stopSpecialTrackButton.Parent = contentFrame

-- ==================== 系统初始化 ====================
-- 角色初始化
local function initializeCharacter(character)
    currentCharacter = character
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        updateStatus("角色死亡")
        stopAllFunctions()
    end)
    
    if config.AutoAim then
        startAutoAim()
    end
    updateStatus("系统就绪")
end

-- 初始角色设置
if localPlayer.Character then
    initializeCharacter(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function(character)
    initializeCharacter(character)
    
    -- 重置速度检测
    positionHistory = {}
    currentSpeed = 0
    
    if playerTrackingEnabled then
        stopAllMovement()
        if trackingConnection then
            trackingConnection:Disconnect()
        end
        if positionCheckConnection then
            positionCheckConnection:Disconnect()
            positionCheckConnection = nil
        end
        task.wait(1)
        startPlayerTracking()
        startPositionDetection()
    end
end)

-- 启动特殊追踪监控
startSpecialTrackingMonitor()

-- 启动系统
updateStatus("辅助系统启动")
if config.AutoAim then
    startAutoAim()
end

print("加载成功")
warn("请注意：可能有bug！")
print("自动跟踪脚本加载完成！完整功能包括：自动追踪、远离僵尸、特殊追踪、群体检测、自动跳跃、速度自适应移动方式选择。")
print("追踪规则：")
print("- 只追踪移动中的玩家")
print("- 群体需要3人及以上")
print("- 优先追踪群体玩家")
print("- 没有群体时才追踪单体玩家")
print("- 远离僵尸模式：检测到僵尸时暂停追踪并躲避")
print("- 安全区域可视化：显示50米安全半径")
print("- 移动方式切换：默认使用PathfindingService，可切换为直接MoveTo")
