-- Roblox 移动端自动跟随队友 + 自动瞄准脚本 
-- 包含障碍物检测、路径规划和自动瞄准功能

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 配置变量
local config = {
    AutoFollow = true,
    FollowDistance = 10,
    ObstacleCheck = true,
    AutoAim = true,
    AimDistance = 50
}

-- 状态变量
local currentCharacter = nil
local isRunning = false
local connection = nil
local currentPath = nil
local aimConnection = nil

-- 创建主屏幕GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoAssistGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建主窗口（大小调整为原来的1/2）
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 140, 0, 160) -- 原来280x320的一半
mainFrame.Position = UDim2.new(0, 15, 0, 75) -- 位置也相应调整
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- 圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6) -- 圆角也相应减小
corner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 18) -- 高度减半
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
titleLabel.Text = "辅助"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- 收缩/展开按钮
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 13, 0, 13) -- 大小减半
toggleButton.Position = UDim2.new(0.02, 0, 0.14, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
toggleButton.Text = "-"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 3) -- 圆角减半
toggleCorner.Parent = toggleButton

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 13, 0, 13) -- 大小减半
closeButton.Position = UDim2.new(0.9, 0, 0.14, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 3) -- 圆角减半
closeCorner.Parent = closeButton

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -10, 1, -23) -- 内边距减半
contentFrame.Position = UDim2.new(0, 5, 0, 20) -- 位置调整
contentFrame.BackgroundTransparency = 1

-- 创建功能开关的函数
local function createToggle(name, configKey, defaultValue, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 18) -- 高度减半
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
    toggle.Size = UDim2.new(0, 25, 0, 13) -- 大小减半
    toggle.Position = UDim2.new(0.8, 0, 0.15, 0)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Name = configKey
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6) -- 圆角减半
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
local followToggle = createToggle("自动跟随", "AutoFollow", true, 0)
local obstacleToggle = createToggle("障碍物检测", "ObstacleCheck", true, 20) -- 间距减半
local aimToggle = createToggle("自动瞄准", "AutoAim", true, 40) -- 间距减半

-- 距离滑块
local distanceFrame = Instance.new("Frame")
distanceFrame.Size = UDim2.new(1, 0, 0, 30) -- 高度减半
distanceFrame.Position = UDim2.new(0, 0, 0, 60) -- 位置调整
distanceFrame.BackgroundTransparency = 1

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(1, 0, 0, 13) -- 高度减半
distanceLabel.Position = UDim2.new(0, 0, 0, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "跟随距离: " .. config.FollowDistance
distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceLabel.TextScaled = true
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Font = Enum.Font.Gotham

local distanceSlider = Instance.new("Frame")
distanceSlider.Size = UDim2.new(1, 0, 0, 8) -- 高度减半
distanceSlider.Position = UDim2.new(0, 0, 0, 15) -- 位置调整
distanceSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
distanceSlider.Name = "DistanceSlider"

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 4) -- 圆角减半
sliderCorner.Parent = distanceSlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(config.FollowDistance / 20, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(60, 150, 200)
sliderFill.Name = "SliderFill"

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4) -- 圆角减半
fillCorner.Parent = sliderFill

-- 瞄准距离滑块
local aimDistanceFrame = Instance.new("Frame")
aimDistanceFrame.Size = UDim2.new(1, 0, 0, 30) -- 高度减半
aimDistanceFrame.Position = UDim2.new(0, 0, 0, 80) -- 位置调整
aimDistanceFrame.BackgroundTransparency = 1

local aimDistanceLabel = Instance.new("TextLabel")
aimDistanceLabel.Size = UDim2.new(1, 0, 0, 13) -- 高度减半
aimDistanceLabel.Position = UDim2.new(0, 0, 0, 0)
aimDistanceLabel.BackgroundTransparency = 1
aimDistanceLabel.Text = "瞄准距离: " .. config.AimDistance
aimDistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
aimDistanceLabel.TextScaled = true
aimDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
aimDistanceLabel.Font = Enum.Font.Gotham

local aimDistanceSlider = Instance.new("Frame")
aimDistanceSlider.Size = UDim2.new(1, 0, 0, 8) -- 高度减半
aimDistanceSlider.Position = UDim2.new(0, 0, 0, 15) -- 位置调整
aimDistanceSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
aimDistanceSlider.Name = "AimDistanceSlider"

local aimSliderCorner = Instance.new("UICorner")
aimSliderCorner.CornerRadius = UDim.new(0, 4) -- 圆角减半
aimSliderCorner.Parent = aimDistanceSlider

local aimSliderFill = Instance.new("Frame")
aimSliderFill.Size = UDim2.new(config.AimDistance / 100, 0, 1, 0)
aimSliderFill.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
aimSliderFill.Name = "AimSliderFill"

local aimFillCorner = Instance.new("UICorner")
aimFillCorner.CornerRadius = UDim.new(0, 4) -- 圆角减半
aimFillCorner.Parent = aimSliderFill

-- 跟随距离滑块触摸事件
distanceSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = (input.Position.X - distanceSlider.AbsolutePosition.X) / distanceSlider.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        config.FollowDistance = math.floor(relativeX * 20) + 5
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        distanceLabel.Text = "跟随距离: " .. config.FollowDistance
        updateStatus("跟随距离: " .. config.FollowDistance)
    end
end)

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

distanceLabel.Parent = distanceFrame
distanceSlider.Parent = distanceFrame
sliderFill.Parent = distanceSlider
distanceFrame.Parent = contentFrame

aimDistanceLabel.Parent = aimDistanceFrame
aimDistanceSlider.Parent = aimDistanceFrame
aimSliderFill.Parent = aimDistanceSlider
aimDistanceFrame.Parent = contentFrame

-- 状态显示
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 25) -- 高度减半
statusFrame.Position = UDim2.new(0, 0, 0, 115) -- 位置调整
statusFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4) -- 圆角减半
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 1, -5) -- 内边距减半
statusLabel.Position = UDim2.new(0, 5, 0, 3) -- 位置调整
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
    local targetSize = isExpanded and UDim2.new(0, 140, 0, 160) or UDim2.new(0, 140, 0, 18) -- 大小减半
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

-- ==================== 跟随系统 ====================
local function getTeammates()
    local teammates = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Team == localPlayer.Team then
            table.insert(teammates, player)
        end
    end
    return teammates
end

local function getNearestTeammate()
    if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
        return nil, math.huge
    end
    
    local nearestTeammate = nil
    local nearestDistance = math.huge
    local teammates = getTeammates()
    
    for _, teammate in pairs(teammates) do
        local teammateChar = teammate.Character
        if teammateChar and teammateChar:FindFirstChild("HumanoidRootPart") then
            local distance = (currentCharacter.HumanoidRootPart.Position - teammateChar.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestTeammate = teammateChar
            end
        end
    end
    
    return nearestTeammate, nearestDistance
end

local function checkObstacles(targetPosition)
    if not config.ObstacleCheck or not currentCharacter then return true end
    
    local characterPos = currentCharacter.HumanoidRootPart.Position
    local direction = (targetPosition - characterPos).Unit
    local distance = (targetPosition - characterPos).Magnitude
    
    -- 射线检测障碍物
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {currentCharacter}
    
    local raycastResult = workspace:Raycast(characterPos, direction * distance, raycastParams)
    
    if raycastResult then
        return false, raycastResult.Position
    end
    
    return true
end

local function calculatePath(targetPosition)
    if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local humanoid = currentCharacter:FindFirstChild("Humanoid")
    if not humanoid then return nil end
    
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })
    
    path:ComputeAsync(currentCharacter.HumanoidRootPart.Position, targetPosition)
    
    if path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    else
        updateStatus("路径计算失败")
        return nil
    end
end

local function moveToPosition(targetPosition)
    if not currentCharacter or not currentCharacter:FindFirstChild("Humanoid") then
        return
    end
    
    local humanoid = currentCharacter.Humanoid
    
    -- 检查是否有障碍物
    local isClear, obstaclePos = checkObstacles(targetPosition)
    
    if isClear then
        humanoid:MoveTo(targetPosition)
        updateStatus("移动至队友")
    else
        if config.ObstacleCheck then
            local waypoints = calculatePath(targetPosition)
            if waypoints then
                updateStatus("路径规划移动")
                -- 简化路径跟随逻辑
                humanoid:MoveTo(waypoints[math.min(2, #waypoints)].Position)
            else
                humanoid:MoveTo(targetPosition)
                updateStatus("直接移动")
            end
        else
            humanoid:MoveTo(targetPosition)
            updateStatus("直接移动")
        end
    end
end

local function autoFollowTeammates()
    if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local nearestTeammate, teammateDistance = getNearestTeammate()
    if nearestTeammate and teammateDistance > config.FollowDistance then
        moveToPosition(nearestTeammate.HumanoidRootPart.Position)
        updateStatus("跟随队友 - 距离: " .. math.floor(teammateDistance))
    elseif nearestTeammate and teammateDistance <= config.FollowDistance then
        updateStatus("保持距离 - 距离: " .. math.floor(teammateDistance))
    else
        updateStatus("未找到队友")
    end
end

-- 主功能循环
local function startMainLoop()
    if connection then
        connection:Disconnect()
    end
    
    connection = RunService.Heartbeat:Connect(function()
        if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        -- 自动跟随队友
        if config.AutoFollow then
            autoFollowTeammates()
        end
    end)
end

local function stopAllFunctions()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    updateStatus("已停止")
end

-- 角色初始化
local function initializeCharacter(character)
    currentCharacter = character
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        updateStatus("角色死亡")
        stopAllFunctions()
        stopAutoAim()
    end)
    
    startMainLoop()
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
end)

-- 启动系统
updateStatus("辅助系统启动")
startMainLoop()
if config.AutoAim then
    startAutoAim()
end

print("加载成功")
warn("请注意：可能有bug！")
