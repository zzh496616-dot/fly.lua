-- 简约大气UI设计 - 完整自动瞄准 + 自动追踪系统
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 系统状态
local systemEnabled = false
local aimEnabled = false
local trackEnabled = false
local connections = {}

-- ==================== 自动瞄准系统变量 ====================
local flags = { StartShoot = false }
local cameraLockConnection = nil
local char = nil
local currentCamera = workspace.CurrentCamera

-- ==================== 自动追踪系统变量 ====================
local playerTrackingEnabled = false
local trackingConnection = nil
local currentTarget = nil
local currentTargetInfo = nil
local isMoving = false
local isCalculatingPath = false
local usePathfindingForTracking = true
local waypoints = {}
local currentWaypointIndex = 0
local lastPathUpdate = 0
local PATH_UPDATE_INTERVAL = 3.0
local viewOffset = 8
local viewHeight = 3

-- 创建主UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteAssist"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 主容器
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 200, 0, 280)
mainContainer.Position = UDim2.new(0, 20, 0, 20)
mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainContainer.BorderSizePixel = 0

-- 现代圆角
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = mainContainer

-- 容器阴影
local containerShadow = Instance.new("ImageLabel")
containerShadow.Name = "Shadow"
containerShadow.Size = UDim2.new(1, 10, 1, 10)
containerShadow.Position = UDim2.new(0, -5, 0, -5)
containerShadow.BackgroundTransparency = 1
containerShadow.Image = "rbxassetid://5554236805"
containerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
containerShadow.ImageTransparency = 0.8
containerShadow.ScaleType = Enum.ScaleType.Slice
containerShadow.SliceCenter = Rect.new(23, 23, 277, 277)
containerShadow.Parent = mainContainer

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- 标题文字
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.2, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ELITE ASSIST"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- 主开关
local mainToggle = Instance.new("TextButton")
mainToggle.Name = "MainToggle"
mainToggle.Size = UDim2.new(0, 60, 0, 26)
mainToggle.Position = UDim2.new(0.75, 0, 0.18, 0)
mainToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
mainToggle.Text = "OFF"
mainToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggle.TextSize = 12
mainToggle.Font = Enum.Font.GothamBold
mainToggle.AutoButtonColor = false

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 13)
toggleCorner.Parent = mainToggle

local toggleSlider = Instance.new("Frame")
toggleSlider.Name = "Slider"
toggleSlider.Size = UDim2.new(0, 22, 0, 22)
toggleSlider.Position = UDim2.new(0.02, 0, 0.08, 0)
toggleSlider.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
toggleSlider.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 11)
sliderCorner.Parent = toggleSlider
toggleSlider.Parent = mainToggle
mainToggle.Parent = titleBar

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

-- 功能卡片容器
local function createFeatureCard(name, yPosition, configKey)
    local card = Instance.new("Frame")
    card.Name = name .. "Card"
    card.Size = UDim2.new(1, 0, 0, 50)
    card.Position = UDim2.new(0, 0, 0, yPosition)
    card.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    card.BorderSizePixel = 0
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    
    -- 功能图标
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = configKey == "aim" and "🎯" or "🔄"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 16
    icon.Font = Enum.Font.GothamBold
    icon.Parent = card
    
    -- 功能名称
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 50, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card
    
    -- 状态显示
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(0.5, 0, 0, 15)
    status.Position = UDim2.new(0, 50, 0, 28)
    status.BackgroundTransparency = 1
    status.Text = "未启用"
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
    status.TextSize = 11
    status.Font = Enum.Font.Gotham
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = card
    
    -- 开关按钮
    local toggle = Instance.new("TextButton")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 50, 0, 24)
    toggle.Position = UDim2.new(0.8, 0, 0.26, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 12)
    toggleBtnCorner.Parent = toggle
    
    local toggleDot = Instance.new("Frame")
    toggleDot.Name = "Dot"
    toggleDot.Size = UDim2.new(0, 18, 0, 18)
    toggleDot.Position = UDim2.new(0.04, 0, 0.125, 0)
    toggleDot.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    toggleDot.BorderSizePixel = 0
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 9)
    dotCorner.Parent = toggleDot
    toggleDot.Parent = toggle
    toggle.Parent = card
    
    return card
end

-- 创建功能卡片
local aimCard = createFeatureCard("自动瞄准", 0, "aim")
local trackCard = createFeatureCard("自动追踪", 60, "track")
aimCard.Parent = contentFrame
trackCard.Parent = contentFrame

-- 状态显示区域
local statusPanel = Instance.new("Frame")
statusPanel.Name = "StatusPanel"
statusPanel.Size = UDim2.new(1, 0, 0, 80)
statusPanel.Position = UDim2.new(0, 0, 0, 130)
statusPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
statusPanel.BorderSizePixel = 0

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusPanel

-- 状态标题
local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, 0, 0, 25)
statusTitle.Position = UDim2.new(0, 0, 0, 0)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "系统状态"
statusTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
statusTitle.TextSize = 12
statusTitle.Font = Enum.Font.GothamBold
statusTitle.Parent = statusPanel

-- 状态信息
local statusInfo = Instance.new("TextLabel")
statusInfo.Name = "StatusInfo"
statusInfo.Size = UDim2.new(1, -20, 0, 50)
statusInfo.Position = UDim2.new(0, 10, 0, 25)
statusInfo.BackgroundTransparency = 1
statusInfo.Text = "系统已关闭\n点击主开关启用"
statusInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
statusInfo.TextSize = 11
statusInfo.Font = Enum.Font.Gotham
statusInfo.TextWrapped = true
statusInfo.TextXAlignment = Enum.TextXAlignment.Left
statusInfo.TextYAlignment = Enum.TextYAlignment.Top
statusInfo.Parent = statusPanel

statusPanel.Parent = contentFrame

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 80, 0, 28)
closeBtn.Position = UDim2.new(0.5, -40, 0, 220)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
closeBtn.Text = "关闭面板"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.Gotham

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn
closeBtn.Parent = contentFrame

-- ==================== 自动瞄准系统函数 ====================
local function startAimSystem()
    if not systemEnabled then return end
    
    flags.StartShoot = true
    local isAimingActive = false
    
    -- 初始化变量
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
    
    -- 预定义常量
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
    
    local function updateTargetCache()
        table.clear(barrelCache)
        table.clear(bossCache)
        
        -- 更新炸药桶缓存
        if zombiesFolder then 
            for _, v in pairs(zombiesFolder:GetChildren()) do
                if v:IsA("Model") and v.Name == "Agent" then
                    if v:GetAttribute("Type") == "Barrel" then
                        local rootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso") or v.PrimaryPart
                        if rootPart then
                            barrelCache[#barrelCache + 1] = {
                                model = v, 
                                rootPart = rootPart,
                                type = "barrel"
                            }
                        end
                    end
                end
            end
        end
        
        lastScanTime = tick()
    end
    
    local function updateTransparentPartsCache()
        table.clear(transparentParts)
        for _, v in pairs(workspace:GetDescendants()) do
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
        if part.Transparency == 1 then
            return true
        end
        
        if part.Transparency > 0.8 then
            return true
        end
        
        if AIR_WALL_MATERIALS[part.Material] then
            return true
        end
        
        if AIR_WALL_NAMES[part.Name:lower()] then
            return true
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
        
        if rayDistance ~= rayDistance then
            return false
        end
        
        if not isWithinViewAngle(targetPosition, cameraCFrame) then
            return false
        end
        
        local ignoreList = {char, currentCamera}
        
        if playersFolder then
            for _, player in pairs(playersFolder:GetChildren()) do
                if player:IsA("Model") then
                    table.insert(ignoreList, player)
                end
            end
        end
        
        if zombiesFolder then
            for _, zombie in pairs(zombiesFolder:GetChildren()) do
                if zombie:IsA("Model") and zombie.Name == "Agent" then
                    if zombie:GetAttribute("Type") ~= "Barrel" then
                        table.insert(ignoreList, zombie)
                    end
                end
            end
        end
        
        for _, transparentPart in pairs(transparentParts) do
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
            
            return isTransparentOrAirWall(rayResult.Instance)
        end
    end
    
    local function findNearestVisibleTarget(cameraCFrame)
        zombiesFolder = workspace:FindFirstChild("Zombies")
        local currentTime = tick()
        
        if currentTime - lastScanTime > 2 then
            updateTargetCache()
        end
        
        if currentTime - lastTransparentUpdate > 5 then
            updateTransparentPartsCache()
        end
        
        if #barrelCache == 0 or not char then
            return nil, math.huge
        end
        
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil, math.huge
        end
        
        local playerPos = humanoidRootPart.Position
        local nearestTarget, minDistance = nil, math.huge
        
        for i = 1, #barrelCache do
            local target = barrelCache[i]
            if target.model and target.model.Parent and target.rootPart and target.rootPart.Parent then
                if isTargetVisible(target.rootPart, cameraCFrame) then
                    local distance = (playerPos - target.rootPart.Position).Magnitude
                    
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
        
        local hasGun = false
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("IsGun") == true then
                hasGun = true
                break
            end
        end
        isAimingActive = hasGun
    end
    
    -- 初始设置
    char = localPlayer.Character
    updateTransparentPartsCache()
    updateTargetCache()
    
    -- 主循环
    cameraLockConnection = RunService.Heartbeat:Connect(function()
        if not flags.StartShoot or not aimEnabled or not systemEnabled then 
            return
        end
        
        if not char or not char.Parent or not currentCamera then
            currentCamera = workspace.CurrentCamera
            if not currentCamera then return end
        end
        
        updateAimingStatus()
        
        if not isAimingActive then
            return
        end
        
        local cameraCFrame = currentCamera.CFrame
        local nearestTarget, distance = findNearestVisibleTarget(cameraCFrame)
        
        if nearestTarget and nearestTarget.rootPart then
            local targetPosition = nearestTarget.rootPart.Position
            local cameraPosition = cameraCFrame.Position
            
            local lookCFrame = CFrame.lookAt(cameraPosition, targetPosition)
            currentCamera.CFrame = cameraCFrame:Lerp(lookCFrame, 0.3)
        end
    end)
    
    print("自动瞄准系统已启动")
end

local function stopAimSystem()
    flags.StartShoot = false
    if cameraLockConnection then
        cameraLockConnection:Disconnect()
        cameraLockConnection = nil
    end
    print("自动瞄准系统已停止")
end

-- ==================== 自动追踪系统函数 ====================
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

local function findNearestPlayer()
    local nearestPlayer = nil
    local minDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local distance = Distance(character)
                if distance < minDistance then
                    minDistance = distance
                    nearestPlayer = {
                        player = player,
                        character = character,
                        rootPart = rootPart,
                        playerName = player.Name
                    }
                end
            end
        end
    end
    
    return nearestPlayer, minDistance
end

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

local function directMoveToTarget(targetPosition)
    local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    humanoid:MoveTo(targetPosition)
    return true
end

local function calculateRearViewPosition(targetPosition, targetCFrame)
    local lookVector = targetCFrame.LookVector
    local upVector = targetCFrame.UpVector
    return targetPosition + (-lookVector * viewOffset + upVector * viewHeight)
end

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

local function startTrackSystem()
    if not systemEnabled then return end
    
    if trackingConnection then
        trackingConnection:Disconnect()
    end
    
    trackingConnection = RunService.Heartbeat:Connect(function()
        if not trackEnabled or not systemEnabled or not localPlayer.Character then 
            stopAllMovement()
            return
        end
        
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then
            stopAllMovement()
            return
        end
        
        local targetPlayer, distance = findNearestPlayer()
        
        if targetPlayer and targetPlayer.rootPart then
            currentTarget = targetPlayer.player
            currentTargetInfo = targetPlayer
            local targetPosition = targetPlayer.rootPart.Position
            local targetCFrame = targetPlayer.rootPart.CFrame
            
            local rearPosition = calculateRearViewPosition(targetPosition, targetCFrame)
            
            if humanoid and humanoidRootPart then
                local currentPos = humanoidRootPart.Position
                local rearDistance = (currentPos - rearPosition).Magnitude
                
                if rearDistance > 4 then
                    isMoving = true
                    
                    local currentTime = tick()
                    local shouldUpdatePath = not isCalculatingPath and (
                        not waypoints or 
                        #waypoints == 0 or 
                        currentWaypointIndex > #waypoints or 
                        currentTime - lastPathUpdate > PATH_UPDATE_INTERVAL
                    )
                    
                    if usePathfindingForTracking then
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
    
    print("自动追踪系统已启动")
end

local function stopTrackSystem()
    if trackingConnection then
        trackingConnection:Disconnect()
        trackingConnection = nil
    end
    currentTarget = nil
    currentTargetInfo = nil
    stopAllMovement()
    print("自动追踪系统已停止")
end

-- ==================== UI控制函数 ====================
local function updateToggleState(toggleButton, enabled)
    local dot = toggleButton:FindFirstChild("Dot")
    if dot then
        if enabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
            dot.Position = UDim2.new(0.52, 0, 0.125, 0)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            dot.Position = UDim2.new(0.04, 0, 0.125, 0)
        end
    end
end

local function updateMainToggleState()
    if systemEnabled then
        mainToggle.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
        toggleSlider.Position = UDim2.new(0.62, 0, 0.08, 0)
        mainToggle.Text = "ON"
        statusInfo.Text = "系统运行中\n所有功能就绪"
        statusInfo.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        mainToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        toggleSlider.Position = UDim2.new(0.02, 0, 0.08, 0)
        mainToggle.Text = "OFF"
        statusInfo.Text = "系统已关闭\n点击主开关启用"
        statusInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
        
        -- 关闭所有功能
        aimEnabled = false
        trackEnabled = false
        stopAimSystem()
        stopTrackSystem()
        
        -- 更新卡片状态
        for _, card in pairs(contentFrame:GetChildren()) do
            if card:IsA("Frame") and card:FindFirstChild("Status") then
                card.Status.Text = "未启用"
                card.Status.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            if card:FindFirstChild("Toggle") then
                updateToggleState(card.Toggle, false)
            end
        end
    end
end

-- 主开关点击事件
mainToggle.MouseButton1Click:Connect(function()
    systemEnabled = not systemEnabled
    updateMainToggleState()
end)

-- 功能开关点击事件
aimCard.Toggle.MouseButton1Click:Connect(function()
    if not systemEnabled then return end
    
    aimEnabled = not aimEnabled
    updateToggleState(aimCard.Toggle, aimEnabled)
    aimCard.Status.Text = aimEnabled and "已启用" or "未启用"
    aimCard.Status.TextColor3 = aimEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(150, 150, 150)
    
    if aimEnabled then
        startAimSystem()
    else
        stopAimSystem()
    end
end)

trackCard.Toggle.MouseButton1Click:Connect(function()
    if not systemEnabled then return end
    
    trackEnabled = not trackEnabled
    updateToggleState(trackCard.Toggle, trackEnabled)
    trackCard.Status.Text = trackEnabled and "已启用" or "未启用"
    trackCard.Status.TextColor3 = trackEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(150, 150, 150)
    
    if trackEnabled then
        startTrackSystem()
    else
        stopTrackSystem()
    end
end)

-- 关闭按钮事件
closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

local function stopAllSystems()
    stopAimSystem()
    stopTrackSystem()
end

-- 拖动功能
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- 角色初始化
local function initializeCharacter(character)
    char = character
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        stopAllSystems()
    end)
end

-- 初始角色设置
if localPlayer.Character then
    initializeCharacter(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function(character)
    initializeCharacter(character)
end)

-- 初始化UI状态
updateMainToggleState()

-- 添加到游戏
mainContainer.Parent = screenGui
screenGui.Parent = playerGui

print("精英辅助系统加载完成")
warn("系统默认关闭，请点击主开关启用功能")
