-- Roblox 移动端自动辅助完整脚本 (教育用途)
-- 包含UI和功能逻辑的完整实现

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 配置变量
local config = {
    AutoFollow = true,
    AvoidZombies = true,
    FastReload = true,
    FollowDistance = 10,
    AvoidDistance = 15
}

-- 状态变量
local currentCharacter = nil
local isRunning = false
local connection = nil

-- 创建主屏幕GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoAssistGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 创建主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 50, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- 圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- 标题文字
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0.15, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "自动辅助系统"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- 收缩/展开按钮
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(0.02, 0, 0.12, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
toggleButton.Text = "-"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.9, 0, 0.12, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- 内容区域
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1

-- 创建功能开关的函数
local function createToggle(name, configKey, defaultValue, yPosition)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 50)
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
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Position = UDim2.new(0.8, 0, 0.2, 0)
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.Name = configKey
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggle
    
    toggle.MouseButton1Click:Connect(function()
        local newValue = not (toggle.Text == "ON")
        config[configKey] = newValue
        toggle.Text = newValue and "ON" or "OFF"
        toggle.BackgroundColor3 = newValue and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(120, 120, 120)
        updateStatus(newValue and name.." 已启用" or name.." 已禁用")
    end)
    
    label.Parent = toggleFrame
    toggle.Parent = toggleFrame
    toggleFrame.Parent = contentFrame
    
    return toggle
end

-- 创建功能开关
local followToggle = createToggle("自动跟随队友", "AutoFollow", true, 0)
local avoidToggle = createToggle("自动躲避僵尸", "AvoidZombies", true, 60)
local reloadToggle = createToggle("快速换弹", "FastReload", true, 120)

-- 距离滑块
local distanceFrame = Instance.new("Frame")
distanceFrame.Size = UDim2.new(1, 0, 0, 80)
distanceFrame.Position = UDim2.new(0, 0, 0, 200)
distanceFrame.BackgroundTransparency = 1

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(1, 0, 0, 30)
distanceLabel.Position = UDim2.new(0, 0, 0, 0)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "跟随距离: " .. config.FollowDistance
distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceLabel.TextScaled = true
distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
distanceLabel.Font = Enum.Font.Gotham

local distanceSlider = Instance.new("Frame")
distanceSlider.Size = UDim2.new(1, 0, 0, 20)
distanceSlider.Position = UDim2.new(0, 0, 0, 40)
distanceSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
distanceSlider.Name = "DistanceSlider"

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = distanceSlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(config.FollowDistance / 20, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(60, 150, 200)
sliderFill.Name = "SliderFill"

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = sliderFill

-- 滑块触摸事件
distanceSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local relativeX = (input.Position.X - distanceSlider.AbsolutePosition.X) / distanceSlider.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        config.FollowDistance = math.floor(relativeX * 20) + 5
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        distanceLabel.Text = "跟随距离: " .. config.FollowDistance
        updateStatus("跟随距离设置为: " .. config.FollowDistance)
    end
end)

distanceLabel.Parent = distanceFrame
distanceSlider.Parent = distanceFrame
sliderFill.Parent = distanceSlider
distanceFrame.Parent = contentFrame

-- 状态显示
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, 0, 0, 60)
statusFrame.Position = UDim2.new(0, 0, 0, 300)
statusFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 1, -10)
statusLabel.Position = UDim2.new(0, 10, 0, 5)
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
    local targetSize = isExpanded and UDim2.new(0, 300, 0, 400) or UDim2.new(0, 300, 0, 40)
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
    screenGui:Destroy()
end)

-- 状态更新函数
local function updateStatus(message)
    statusLabel.Text = "状态: " .. message
    print("辅助系统: " .. message)
end

-- 游戏功能函数
local function getTeammates()
    local teammates = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Team == localPlayer.Team then
            table.insert(teammates, player)
        end
    end
    return teammates
end

local function getNearestZombie()
    local nearestZombie = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Team and (player.Team.Name:lower():find("zombie") or player.Team.Name:lower():find("infected")) then
            local zombieChar = player.Character
            if zombieChar and zombieChar:FindFirstChild("HumanoidRootPart") then
                local distance = (currentCharacter.HumanoidRootPart.Position - zombieChar.HumanoidRootPart.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestZombie = zombieChar
                end
            end
        end
    end
    
    return nearestZombie, nearestDistance
end

local function getNearestTeammate()
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

local function moveToPosition(targetPosition)
    if currentCharacter and currentCharacter:FindFirstChild("Humanoid") then
        currentCharacter.Humanoid:MoveTo(targetPosition)
    end
end

local function moveAwayFromPosition(dangerPosition)
    if currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart") then
        local direction = (currentCharacter.HumanoidRootPart.Position - dangerPosition).Unit
        local safePosition = currentCharacter.HumanoidRootPart.Position + direction * config.AvoidDistance
        moveToPosition(safePosition)
    end
end

local function autoFollowTeammates()
    if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local nearestTeammate, teammateDistance = getNearestTeammate()
    if nearestTeammate and teammateDistance > config.FollowDistance then
        moveToPosition(nearestTeammate.HumanoidRootPart.Position)
        updateStatus("跟随队友中 - 距离: " .. math.floor(teammateDistance))
    end
end

local function avoidZombies()
    if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local nearestZombie, zombieDistance = getNearestZombie()
    if nearestZombie and zombieDistance < config.AvoidDistance then
        moveAwayFromPosition(nearestZombie.HumanoidRootPart.Position)
        updateStatus("躲避僵尸中 - 距离: " .. math.floor(zombieDistance))
    end
end

local function fastReload()
    -- 模拟快速换弹功能
    -- 注意：实际游戏中需要根据具体武器系统调整
    if currentCharacter then
        -- 这里可以添加检测武器和换弹的逻辑
        updateStatus("快速换弹就绪")
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
        
        -- 自动躲避僵尸
        if config.AvoidZombies then
            avoidZombies()
        end
        
        -- 快速换弹检测
        if config.FastReload then
            -- 这里可以添加换弹条件检测
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
    end)
    
    startMainLoop()
    updateStatus("系统就绪")
end

-- 初始角色设置
if localPlayer.Character then
    initializeCharacter(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(function(character)
    initializeCharacter(character)
end)

-- 快速换弹热键 (移动端触摸按钮)
local reloadButton = Instance.new("TextButton")
reloadButton.Name = "ReloadButton"
reloadButton.Size = UDim2.new(0, 80, 0, 80)
reloadButton.Position = UDim2.new(1, -100, 1, -100)
reloadButton.BackgroundColor3 = Color3.fromRGB(60, 150, 200)
reloadButton.Text = "换弹"
reloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reloadButton.TextScaled = true
reloadButton.Font = Enum.Font.GothamBold
reloadButton.Visible = config.FastReload

local reloadCorner = Instance.new("UICorner")
reloadCorner.CornerRadius = UDim.new(0, 20)
reloadCorner.Parent = reloadButton

reloadButton.MouseButton1Click:Connect(function()
    if config.FastReload then
        fastReload()
    end
end)

reloadButton.Parent = screenGui

-- 更新快速换弹按钮可见性
reloadToggle:GetPropertyChangedSignal("Text"):Connect(function()
    reloadButton.Visible = (reloadToggle.Text == "ON")
end)

-- 启动系统
updateStatus("系统启动完成")
startMainLoop()

print("移动端自动辅助系统已完全加载 - 仅用于教育目的")
warn("请注意：在多人游戏中使用自动化功能可能违反游戏规则！")
