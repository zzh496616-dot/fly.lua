-- 修复自动追踪脚本 - 完整功能版
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

-- 追踪状态变量（源码本身就已公开）
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

-- 基础函数定义
local function Distance(target)
    local char = LocalPlayer.Character
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
        if player ~= LocalPlayer and player.Character then
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
    
    local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                     LocalPlayer.Character.HumanoidRootPart.Position
    
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
        if safetyCircle and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
    
    local localPos = LocalPlayer.Character.HumanoidRootPart.Position
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
    if not LocalPlayer.Character then
        return 0
    end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
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
    if not LocalPlayer.Character then return false end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local distance = (humanoidRootPart.Position - specialZonePosition).Magnitude
    return distance <= triggerDistance
end

-- 智能自动跳跃函数
local function startAutoJump()
    if autoJumpConnection then
        autoJumpConnection:Disconnect()
    end
    
    local Char = LocalPlayer.Character
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
    autoJumpCharAdded = LocalPlayer.CharacterAdded:Connect(function(nChar)
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
    if not LocalPlayer.Character then return false end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local distance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
    return distance <= tolerance
end

-- 异步路径计算函数
local function computePathToTargetAsync(targetPosition)
    if not LocalPlayer.Character or isCalculatingPath then return false end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local currentWaypoint = waypoints[currentWaypointIndex]
    humanoid:MoveTo(currentWaypoint.Position)
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    humanoid:MoveTo(targetPosition)
    return true
end

-- 特殊追踪移动函数
local function moveToSpecialTarget(targetCFrame, usePathfinding)
    if not LocalPlayer.Character then return false end
    
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
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
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
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
        if not specialTrackingEnabled or not LocalPlayer.Character then
            return
        end
        
        -- 检查角色状态
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
            if player ~= LocalPlayer and player.Character then
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
            if player ~= LocalPlayer and player.Character then
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
    if trackMode == "furthestFromZombies" then
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
        if not playerTrackingEnabled or not LocalPlayer.Character or specialTrackingEnabled then 
            stopAllMovement()
            return
        end
        
        -- 检查角色状态（角色死亡时停止追踪）
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
                groupInfo.changetext("状态: 躲避僵尸中 (" .. #nearbyZombies .. "只)")
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
                    if LocalPlayer.Character then
                        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
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

-- 创建简易GUI（如果library不存在）
if not library then
    -- 简易GUI实现
    library = {}
    library.window = function(title)
        local window = {}
        window.elements = {}
        
        window.toggle = function(name, default, callback)
            print("["..title.."] 切换: "..name.." = "..tostring(default))
            callback(default)
        end
        
        window.slider = function(name, min, max, step, default, callback)
            print("["..title.."] 滑块: "..name.." = "..default)
            callback(default)
        end
        
        window.button = function(name, callback)
            print("["..title.."] 按钮: "..name)
            callback()
        end
        
        window.label = function(text)
            print("["..title.."] 标签: "..text)
            return {
                changetext = function(newText)
                    print("["..title.."] 更新标签: "..newText)
                end
            }
        end
        
        return window
    end
end

-- GUI集成
local trackWindow = library.window("自动跟踪")

-- 监听角色重生（重置速度检测）
LocalPlayer.CharacterAdded:Connect(function(character)
    -- 等待角色完全加载
    character:WaitForChild("HumanoidRootPart")
    
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

-- GUI控制 - 普通追踪功能
trackWindow.toggle("启用自动跟踪", false, function(enabled)
    playerTrackingEnabled = enabled
    
    if enabled then
        if not LocalPlayer.Character then
            playerTrackingEnabled = false
            return
        end
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            playerTrackingEnabled = false
            return
        end
        
        stopAllMovement()
        task.wait(0.5)
        startPlayerTracking()
        startPositionDetection()
    else
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
end)

-- 追踪模式选择
trackWindow.toggle("远离僵尸模式", false, function(enabled)
    if enabled then
        trackMode = "avoidZombies"
        -- 创建安全区域可视化圆
        createSafetyCircle()
    else
        trackMode = "nearest"
        -- 移除安全区域可视化圆
        removeSafetyCircle()
    end
    
    if playerTrackingEnabled then
        waypoints = {}
        currentWaypointIndex = 0
        lastPathUpdate = 0
        isCalculatingPath = false
    end
end)

-- 移动方式切换
trackWindow.toggle("使用路径寻找", true, function(enabled)
    userSelectedMoveMethod = enabled
    updateMovementMethod()
end)

-- 自动跳跃开关
trackWindow.toggle("启用自动跳跃", false, function(enabled)
    autoJumpEnabled = enabled
    
    if enabled then
        startAutoJump()
    else
        stopAutoJump()
    end
end)

trackWindow.slider("追踪距离", 3, 15, 1, 8, function(value)
    viewOffset = value
end)

trackWindow.slider("速度阈值", 5, 20, 1, 10, function(value)
    SPEED_THRESHOLD = value
end)

trackWindow.slider("群体距离", 10, 25, 1, 15, function(value)
    GROUP_DISTANCE_THRESHOLD = value
end)

trackWindow.slider("单体距离", 20, 50, 5, 30, function(value)
    ISOLATED_DISTANCE_THRESHOLD = value
end)

trackWindow.slider("僵尸检测半径", 20, 100, 5, 50, function(value)
    zombieDetectionRadius = value
    if safetyCircle then
        safetyCircle:Destroy()
        createSafetyCircle()
    end
end)

-- GUI控制 - 特殊追踪功能
trackWindow.button("启动特殊追踪", function()
    if not specialTrackingEnabled then
        shouldStartSpecialTracking = true
    end
end)

trackWindow.button("停止特殊追踪", function()
    stopSpecialTracking()
end)

trackWindow.button("重置特殊追踪", function()
    specialPathCompleted = false
    specialTrackingStep = 0
    shouldStartSpecialTracking = false
end)

-- 状态显示
local targetInfo = trackWindow.label("状态: 未追踪")
local pathInfo = trackWindow.label("路径: 等待中")
local distanceInfo = trackWindow.label("距离: -")
local speedInfo = trackWindow.label("速度: 0.00")
local modeInfo = trackWindow.label("模式: 最近玩家")
local moveMethodInfo = trackWindow.label("移动方式: 路径寻找")
local specialInfo = trackWindow.label("特殊追踪: 未激活")
local groupInfo = trackWindow.label("目标类型: 无")
local jumpInfo = trackWindow.label("自动跳跃: 关闭")
local zombieInfo = trackWindow.label("僵尸状态: 安全")

-- 信息显示循环
task.spawn(function()
    while task.wait(0.5) do
        modeInfo.changetext("模式: " .. (trackMode == "avoidZombies" and "远离僵尸" or 
                                       trackMode == "furthestFromZombies" and "远离僵尸(旧)" or "最近玩家"))
        
        -- 更新速度信息
        local speed = calculateCurrentSpeed()
        speedInfo.changetext("速度: " .. string.format("%.2f", speed))
        
        -- 更新移动方式显示
        moveMethodInfo.changetext("移动方式: " .. (usePathfindingForTracking and "路径寻找" or "直接移动"))
        
        -- 更新跳跃状态
        jumpInfo.changetext("自动跳跃: " .. (autoJumpEnabled and "开启" or "关闭"))
        
        -- 更新僵尸状态
        local nearbyZombies = findNearbyZombies()
        if #nearbyZombies > 0 then
            zombieInfo.changetext("僵尸状态: 危险 (" .. #nearbyZombies .. "只)")
        else
            zombieInfo.changetext("僵尸状态: 安全")
        end
        
        if specialTrackingEnabled then
            specialInfo.changetext("特殊追踪: 步骤 " .. specialTrackingStep .. "/" .. #specialPathPoints)
        else
            if specialPathCompleted then
                specialInfo.changetext("特殊追踪: 已完成")
            else
                specialInfo.changetext("特殊追踪: 就绪")
            end
        end
        
        if playerTrackingEnabled and not specialTrackingEnabled then
            if avoidZombiesMode then
                targetInfo.changetext("状态: 躲避僵尸中")
                pathInfo.changetext("路径: 安全移动")
                distanceInfo.changetext("僵尸数量: " .. #nearbyZombies)
                groupInfo.changetext("目标类型: 安全优先")
            elseif currentTarget and currentTargetInfo and LocalPlayer.Character then
                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetCharacter = currentTarget.Character
                
                if humanoidRootPart and targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
                    local targetPos = targetCharacter.HumanoidRootPart.Position
                    local currentPos = humanoidRootPart.Position
                    local distance = (currentPos - targetPos).Magnitude
                    local moveStatus = isMoving and "移动中" or "保持位置"
                    local pathStatus = ""
                    
                    if isCalculatingPath then
                        pathStatus = "路径计算中..."
                    elseif waypoints and #waypoints > 0 then
                        pathStatus = "路径点:" .. currentWaypointIndex .. "/" .. #waypoints
                    else
                        pathStatus = "直接移动"
                    end
                    
                    targetInfo.changetext("追踪: " .. currentTarget.Name)
                    pathInfo.changetext("模式: " .. pathStatus)
                    distanceInfo.changetext("距离: " .. math.floor(distance) .. " | " .. moveStatus)
                    
                    -- 显示目标类型 - 使用 currentTargetInfo
                    if currentTargetInfo.isGroup then
                        groupInfo.changetext("目标类型: 群体(" .. currentTargetInfo.groupSize .. "人)")
                    else
                        groupInfo.changetext("目标类型: 单体玩家")
                    end
                else
                    targetInfo.changetext("状态: 目标丢失")
                    pathInfo.changetext("路径: 无")
                    distanceInfo.changetext("距离: -")
                    groupInfo.changetext("目标类型: 无")
                end
            else
                targetInfo.changetext("状态: 寻找目标中...")
                pathInfo.changetext("路径: 等待目标")
                distanceInfo.changetext("距离: -")
                groupInfo.changetext("目标类型: 无")
            end
        else
            if specialTrackingEnabled then
                targetInfo.changetext("状态: 特殊追踪中")
                pathInfo.changetext("步骤: " .. specialTrackingStep .. "/" .. #specialPathPoints)
                distanceInfo.changetext("距离: -")
                groupInfo.changetext("目标类型: 特殊路径")
            else
                targetInfo.changetext("状态: 未追踪")
                pathInfo.changetext("路径: 关闭")
                distanceInfo.changetext("距离: -")
                groupInfo.changetext("目标类型: 无")
            end
        end
    end
end)

-- 启动特殊追踪监控
startSpecialTrackingMonitor()

print("自动跟踪脚本加载完成！完整功能包括：自动追踪、远离僵尸、特殊追踪、群体检测、自动跳跃、速度自适应移动方式选择。")
print("追踪规则：")
print("- 只追踪移动中的玩家")
print("- 群体需要3人及以上")
print("- 优先追踪群体玩家")
print("- 没有群体时才追踪单体玩家")
print("- 远离僵尸模式：检测到僵尸时暂停追踪并躲避")
print("- 安全区域可视化：显示50米安全半径")
print("- 移动方式切换：默认使用PathfindingService，可切换为直接MoveTo")
