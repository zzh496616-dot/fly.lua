-- 义和团自动瞄准UI（完整功能版 + 注入动画 + 可输入）
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TextService = game:GetService("TextService")

-- 检查是否在客户端运行
if not RunService:IsClient() then
    error("这个脚本必须在客户端运行！请放在StarterPlayerScripts中。")
    return
end

-- 等待玩家加载
local player = Players.LocalPlayer
if not player then
    player = Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    player = Players.LocalPlayer
end

-- 等待PlayerGui加载
local playerGui = player:WaitForChild("PlayerGui")
print("PlayerGui已加载")

-- 创建注入动画背景
local injectionOverlay = Instance.new("Frame")
injectionOverlay.Name = "InjectionOverlay"
injectionOverlay.Size = UDim2.new(1, 0, 1, 0)
injectionOverlay.Position = UDim2.new(0, 0, 0, 0)
injectionOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
injectionOverlay.BackgroundTransparency = 0.8
injectionOverlay.ZIndex = 999
injectionOverlay.Visible = false
injectionOverlay.Parent = playerGui

-- 创建注入动画文本
local injectionText = Instance.new("TextLabel")
injectionText.Name = "InjectionText"
injectionText.Size = UDim2.new(1, 0, 0, 100)
injectionText.Position = UDim2.new(0, 0, 0.5, -50)
injectionText.BackgroundTransparency = 1
injectionText.Text = "义和团自动瞄准注入中..."
injectionText.Font = Enum.Font.GothamBold
injectionText.TextSize = 36
injectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
injectionText.TextStrokeTransparency = 0.5
injectionText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
injectionText.ZIndex = 1000
injectionText.Visible = false
injectionText.Parent = injectionOverlay

-- 创建进度条容器
local progressContainer = Instance.new("Frame")
progressContainer.Name = "ProgressContainer"
progressContainer.Size = UDim2.new(0.4, 0, 0, 20)
progressContainer.Position = UDim2.new(0.3, 0, 0.5, 30)
progressContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressContainer.BorderSizePixel = 0
progressContainer.ZIndex = 1000
progressContainer.Visible = false

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(1, 0)
progressCorner.Parent = progressContainer

-- 创建进度条
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromHSV(0.3, 0.8, 1)
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 1001

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(1, 0)
progressBarCorner.Parent = progressBar

progressBar.Parent = progressContainer
progressContainer.Parent = injectionOverlay

-- 显示注入动画
local function showInjectionAnimation()
    injectionOverlay.Visible = true
    injectionText.Visible = true
    progressContainer.Visible = true
    
    -- 重置进度条
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    
    -- 彩虹文本效果
    local hue = 0
    local rainbowConnection
    rainbowConnection = RunService.Heartbeat:Connect(function()
        hue = (hue + 0.02) % 1
        injectionText.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end)
    
    -- 进度条动画
    local progressTweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Linear)
    local progressTween = TweenService:Create(progressBar, progressTweenInfo, {
        Size = UDim2.new(1, 0, 1, 0)
    })
    
    -- 加载步骤文本
    local loadSteps = {
        "初始化UI系统...",
        "加载瞄准模块...",
        "设置缓存系统...",
        "连接事件处理器...",
        "注入完成！"
    }
    
    local stepIndex = 1
    local totalSteps = #loadSteps
    local stepDuration = 1.5 / totalSteps
    
    local function updateStepText()
        if stepIndex <= totalSteps then
            injectionText.Text = "义和团自动瞄准\n" .. loadSteps[stepIndex]
            stepIndex = stepIndex + 1
            
            -- 改变进度条颜色
            progressBar.BackgroundColor3 = Color3.fromHSV(stepIndex * 0.15, 0.8, 1)
        end
    end
    
    -- 开始动画
    progressTween:Play()
    
    -- 定时更新步骤
    local stepTimer = 0
    local lastTime = tick()
    
    local updateConnection
    updateConnection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        local delta = currentTime - lastTime
        lastTime = currentTime
        
        stepTimer = stepTimer + delta
        if stepTimer >= stepDuration then
            stepTimer = 0
            updateStepText()
        end
    end)
    
    -- 动画完成后隐藏
    progressTween.Completed:Connect(function()
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        if updateConnection then
            updateConnection:Disconnect()
            updateConnection = nil
        end
        
        -- 完成动画
        local completionTween = TweenService:Create(injectionOverlay, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        })
        
        completionTween:Play()
        
        completionTween.Completed:Connect(function()
            injectionOverlay:Destroy()
            print("注入动画完成！")
        end)
    end)
end

-- 创建主屏幕GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "义和团UI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = true

print("创建ScreenGui")

-- 创建正方形主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 420)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = true

print("创建MainFrame")

-- 圆角效果
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleBar.BackgroundTransparency = 0.1
titleBar.BorderSizePixel = 0
titleBar.Visible = true

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12, 0, 0)
titleBarCorner.Parent = titleBar

-- 标题文本（彩虹效果）
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "义和团自动瞄准"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextStrokeTransparency = 0.7
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.Visible = true

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0.5, -14)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Visible = true

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(1, 0)
closeButtonCorner.Parent = closeButton

-- 缩放按钮
local scaleButton = Instance.new("TextButton")
scaleButton.Name = "ScaleButton"
scaleButton.Size = UDim2.new(0, 28, 0, 28)
scaleButton.Position = UDim2.new(1, -65, 0.5, -14)
scaleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
scaleButton.BackgroundTransparency = 0.3
scaleButton.Text = "↔"
scaleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleButton.TextScaled = true
scaleButton.Font = Enum.Font.GothamBold
scaleButton.AutoButtonColor = false
scaleButton.Visible = true

local scaleButtonCorner = Instance.new("UICorner")
scaleButtonCorner.CornerRadius = UDim.new(1, 0)
scaleButtonCorner.Parent = scaleButton

-- 创建内容区域
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -10, 1, -50)
contentArea.Position = UDim2.new(0, 5, 0, 45)
contentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Visible = true

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

-- 创建滚动容器
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollingFrame.ScrollBarImageTransparency = 0.5
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Visible = true

print("创建滚动容器")

-- 创建功能列表容器
local functionsContainer = Instance.new("Frame")
functionsContainer.Name = "FunctionsContainer"
functionsContainer.Size = UDim2.new(1, 0, 0, 0)
functionsContainer.Position = UDim2.new(0, 0, 0, 0)
functionsContainer.BackgroundTransparency = 1
functionsContainer.Visible = true

-- 创建全局变量和标志
local flags = {
    StartShoot = false,
    MaxDistance = 1000,
    SmoothAim = 0.3,
    PredictionTime = 0.2,
    ScanInterval = 2,
    ViewAngle = 90,
    AimBarrel = true,
    AimBoss = true,
    UsePrediction = true,
    UseRaycast = true,
    AutoUpdateCache = true,
    OnlyWhenArmed = true
}

-- 自动瞄准系统变量
local cameraLockConnection = nil
local barrelCache = {}
local bossCache = {}
local transparentParts = {}
local targetHistory = {}
local char = nil
local currentCamera = Workspace.CurrentCamera
local zombiesFolder = nil
local playersFolder = nil

print("创建全局变量")

-- 创建简单的切换按钮（修复版）
local function createSimpleToggle(name, text, description, icon, color, defaultState, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -8, 0, 55)
    button.Position = UDim2.new(0, 4, 0, 0)
    button.BackgroundColor3 = color
    button.BackgroundTransparency = 0.2
    button.Text = ""
    button.AutoButtonColor = false
    button.Visible = true
    
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
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 18
    iconLabel.Visible = true
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.6, 0, 0.5, -2)
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Visible = true
    
    -- 描述
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.6, 0, 0.5, -2)
    descLabel.Position = UDim2.new(0, 50, 0.5, 0)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Visible = true
    
    -- 切换开关
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(0, 35, 0, 18)
    toggleFrame.Position = UDim2.new(1, -40, 0.5, -9)
    toggleFrame.BackgroundColor3 = defaultState and Color3.fromRGB(60, 220, 60) or Color3.fromRGB(120, 120, 120)
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Visible = true
    
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
    toggleCircle.Visible = true
    
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
    
    return button, toggleState
end

-- 创建数值输入框（带滑块和输入框）
local function createValueInputWithSlider(name, text, description, icon, color, minValue, maxValue, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -8, 0, 70)
    container.Position = UDim2.new(0, 4, 0, 0)
    container.BackgroundTransparency = 1
    container.Visible = true
    
    -- 背景框
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = color
    backgroundFrame.BackgroundTransparency = 0.2
    backgroundFrame.Visible = true
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = backgroundFrame
    
    -- 图标
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 32, 0, 32)
    iconLabel.Position = UDim2.new(0, 8, 0, 10)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Visible = true
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.5, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 48, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Visible = true
    
    -- 描述
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.5, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 48, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description .. " (最大值: " .. maxValue .. ")"
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Visible = true
    
    -- 输入框
    local valueInput = Instance.new("TextBox")
    valueInput.Name = "ValueInput"
    valueInput.Size = UDim2.new(0.25, 0, 0, 28)
    valueInput.Position = UDim2.new(0.7, 0, 0, 10)
    valueInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    valueInput.BackgroundTransparency = 0.3
    valueInput.Text = tostring(defaultValue)
    valueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueInput.PlaceholderText = "输入数值"
    valueInput.Font = Enum.Font.Gotham
    valueInput.TextSize = 14
    valueInput.ClearTextOnFocus = false
    valueInput.Visible = true
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = valueInput
    
    -- 滑块背景
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(0.8, 0, 0, 6)
    sliderBackground.Position = UDim2.new(0.1, 0, 1, -16)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Visible = true
    
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
    sliderFill.Visible = true
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    -- 滑块按钮
    local sliderButton = Instance.new("Frame")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 14, 0, 14)
    sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7, 0.5, -7)
    sliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    sliderButton.BorderSizePixel = 0
    sliderButton.Visible = true
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(1, 0)
    sliderButtonCorner.Parent = sliderButton
    
    -- 当前值
    local currentValue = defaultValue
    
    -- 更新值函数
    local function updateValue(newValue)
        local clampedValue = math.clamp(newValue, minValue, maxValue)
        local normalized = (clampedValue - minValue) / (maxValue - minValue)
        local roundedValue = math.floor(clampedValue * 100) / 100
        
        -- 更新滑块
        sliderFill.Size = UDim2.new(normalized, 0, 1, 0)
        sliderButton.Position = UDim2.new(normalized, -7, 0.5, -7)
        
        -- 更新输入框
        valueInput.Text = tostring(roundedValue)
        
        -- 更新当前值
        currentValue = roundedValue
        
        -- 执行回调
        if callback then
            callback(roundedValue)
        end
    end
    
    -- 输入框事件
    valueInput.FocusLost:Connect(function(enterPressed)
        local newValue = tonumber(valueInput.Text)
        if newValue then
            updateValue(newValue)
        else
            -- 输入无效，恢复原值
            valueInput.Text = tostring(currentValue)
        end
    end)
    
    -- 滑块拖拽逻辑
    local isDragging = false
    local dragStartX = 0
    local sliderStartPos = 0
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStartX = input.Position.X
            sliderStartPos = sliderButton.Position.X.Scale
        end
    end)
    
    sliderBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            local mouseX = input.Position.X
            local sliderPos = sliderBackground.AbsolutePosition
            local sliderSize = sliderBackground.AbsoluteSize
            
            local relativeX = (mouseX - sliderPos.X) / sliderSize.X
            local newValue = minValue + (maxValue - minValue) * relativeX
            updateValue(newValue)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local sliderPos = sliderBackground.AbsolutePosition
            local sliderSize = sliderBackground.AbsoluteSize
            
            local relativeX = (mouseX - sliderPos.X) / sliderSize.X
            local newValue = minValue + (maxValue - minValue) * relativeX
            updateValue(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    -- 组装
    sliderFill.Parent = sliderBackground
    sliderButton.Parent = sliderBackground
    iconLabel.Parent = backgroundFrame
    titleLabel.Parent = backgroundFrame
    descLabel.Parent = backgroundFrame
    valueInput.Parent = backgroundFrame
    sliderBackground.Parent = backgroundFrame
    backgroundFrame.Parent = container
    
    -- 初始化值
    updateValue(defaultValue)
    
    return container
end

-- 创建数值输入框（带输入框）
local function createValueInput(name, text, description, icon, color, minValue, maxValue, defaultValue, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -8, 0, 60)
    container.Position = UDim2.new(0, 4, 0, 0)
    container.BackgroundTransparency = 1
    container.Visible = true
    
    -- 背景框
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundColor3 = color
    backgroundFrame.BackgroundTransparency = 0.2
    backgroundFrame.Visible = true
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = backgroundFrame
    
    -- 图标
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 32, 0, 32)
    iconLabel.Position = UDim2.new(0, 8, 0.5, -16)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Visible = true
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.5, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 48, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Visible = true
    
    -- 描述
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.5, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 48, 0, 28)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description .. " (最大值: " .. maxValue .. ")"
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Visible = true
    
    -- 输入框
    local valueInput = Instance.new("TextBox")
    valueInput.Name = "ValueInput"
    valueInput.Size = UDim2.new(0.3, 0, 0, 28)
    valueInput.Position = UDim2.new(0.65, 0, 0.5, -14)
    valueInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    valueInput.BackgroundTransparency = 0.3
    valueInput.Text = tostring(defaultValue)
    valueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueInput.PlaceholderText = "输入数值"
    valueInput.Font = Enum.Font.Gotham
    valueInput.TextSize = 14
    valueInput.ClearTextOnFocus = false
    valueInput.Visible = true
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = valueInput
    
    -- 当前值
    local currentValue = defaultValue
    
    -- 更新值函数
    local function updateValue(newValue)
        local clampedValue = math.clamp(newValue, minValue, maxValue)
        local roundedValue = math.floor(clampedValue * 100) / 100
        
        -- 更新输入框
        valueInput.Text = tostring(roundedValue)
        
        -- 更新当前值
        currentValue = roundedValue
        
        -- 执行回调
        if callback then
            callback(roundedValue)
        end
    end
    
    -- 输入框事件
    valueInput.FocusLost:Connect(function(enterPressed)
        local newValue = tonumber(valueInput.Text)
        if newValue then
            updateValue(newValue)
        else
            -- 输入无效，恢复原值
            valueInput.Text = tostring(currentValue)
        end
    end)
    
    -- 组装
    iconLabel.Parent = backgroundFrame
    titleLabel.Parent = backgroundFrame
    descLabel.Parent = backgroundFrame
    valueInput.Parent = backgroundFrame
    backgroundFrame.Parent = container
    
    -- 初始化值
    updateValue(defaultValue)
    
    return container
end

-- ==================== 自动瞄准系统核心功能 ====================

-- 检查Boss是否存在
local function checkBossExists()
    local sleepyHollow = Workspace:FindFirstChild("Sleepy Hollow")
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

-- 获取Boss目标部件
local function getBossTargetParts()
    local targetParts = {}
    
    local sleepyHollow = Workspace:FindFirstChild("Sleepy Hollow")
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

-- 更新目标缓存
local lastScanTime = 0
local lastBossScanTime = 0
local lastTransparentUpdate = 0

local function updateTargetCache()
    table.clear(barrelCache)
    table.clear(bossCache)
    
    -- 更新炸药桶缓存
    if flags.AimBarrel then
        zombiesFolder = Workspace:FindFirstChild("Zombies")
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
                        end
                    end
                end
            end
        end
    end
    
    -- 更新Boss缓存
    if flags.AimBoss and checkBossExists() then
        local bossParts = getBossTargetParts()
        for _, bossPart in ipairs(bossParts) do
            bossCache[#bossCache + 1] = {
                model = bossPart.part,
                rootPart = bossPart.part,
                type = "boss",
                name = bossPart.name
            }
        end
    end
    
    lastScanTime = tick()
    lastBossScanTime = tick()
end

-- 更新透明部件缓存
local function updateTransparentPartsCache()
    table.clear(transparentParts)
    local descendants = Workspace:GetDescendants()
    for i = 1, #descendants do
        local v = descendants[i]
        if v:IsA("BasePart") and v.Transparency == 1 then
            transparentParts[#transparentParts + 1] = v
        end
    end
    lastTransparentUpdate = tick()
end

-- 检查目标是否在视角范围内
local function isWithinViewAngle(targetPosition, cameraCFrame)
    local COS_MAX_ANGLE = math.cos(math.rad(flags.ViewAngle / 2))
    local cameraLookVector = cameraCFrame.LookVector
    local toTarget = (targetPosition - cameraCFrame.Position).Unit
    return cameraLookVector:Dot(toTarget) > COS_MAX_ANGLE
end

-- 检查是否为透明或空气墙
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

local function isTransparentOrAirWall(part)
    -- 检查透明度为1的部件（完全透明）
    if part.Transparency == 1 then
        return true
    end
    
    -- 检查高透明度
    if part.Transparency > 0.8 then
        return true
    end
    
    -- 检查材质
    if AIR_WALL_MATERIALS[part.Material] then
        return true
    end
    
    -- 检查名称
    if AIR_WALL_NAMES[part.Name:lower()] then
        return true
    end
    
    return false
end

-- 检查目标是否可见
local function isTargetVisible(targetPart, cameraCFrame)
    if not char or not targetPart or not currentCamera then 
        return false 
    end
    
    local rayOrigin = cameraCFrame.Position
    local targetPosition = targetPart.Position
    local rayDirection = (targetPosition - rayOrigin)
    local rayDistance = rayDirection.Magnitude
    
    -- 安全检查
    if rayDistance ~= rayDistance then
        return false
    end
    
    -- 首先检查目标是否在视角范围内
    if not isWithinViewAngle(targetPosition, cameraCFrame) then
        return false
    end
    
    -- 构建忽略列表
    local ignoreList = {char, currentCamera}
    
    -- 忽略所有玩家
    playersFolder = Workspace:FindFirstChild("Players")
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
    
    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
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

-- 查找最近可见目标
local function findNearestVisibleTarget(cameraCFrame)
    local currentTime = tick()
    
    -- 定期更新缓存
    if currentTime - lastScanTime > flags.ScanInterval or currentTime - lastBossScanTime > 1 then
        updateTargetCache()
    end
    
    -- 定期更新透明部件缓存
    if currentTime - lastTransparentUpdate > 5 then
        updateTransparentPartsCache()
    end
    
    if (#barrelCache == 0 and #bossCache == 0) or not char then
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
            local isVisible = true
            if flags.UseRaycast then
                isVisible = isTargetVisible(target.rootPart, cameraCFrame)
            end
            
            if isVisible then
                local distance = (playerPos - target.rootPart.Position).Magnitude
                
                if distance < minDistance and distance < flags.MaxDistance then
                    minDistance = distance
                    nearestTarget = target
                end
            end
        end
    end
    
    -- 检查Boss目标
    for i = 1, #bossCache do
        local target = bossCache[i]
        if target.model and target.model.Parent and target.rootPart and target.rootPart.Parent then
            local isVisible = true
            if flags.UseRaycast then
                isVisible = isTargetVisible(target.rootPart, cameraCFrame)
            end
            
            if isVisible then
                local distance = (playerPos - target.rootPart.Position).Magnitude
                
                if distance < minDistance and distance < flags.MaxDistance then
                    minDistance = distance
                    nearestTarget = target
                end
            end
        end
    end
    
    return nearestTarget, minDistance
end

-- 检查是否持有枪支
local function isArmed()
    if not char then return false end
    
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") and child:GetAttribute("IsGun") == true then
            return true
        end
    end
    
    return false
end

-- 初始化自动瞄准系统
local function initAimingSystem()
    char = player.Character
    currentCamera = Workspace.CurrentCamera
    
    if not char then
        player.CharacterAdded:Wait()
        char = player.Character
    end
    
    -- 初始缓存更新
    updateTransparentPartsCache()
    updateTargetCache()
    
    -- 清理现有连接
    if cameraLockConnection then
        cameraLockConnection:Disconnect()
        cameraLockConnection = nil
    end
    
    -- 主瞄准循环
    cameraLockConnection = RunService.Heartbeat:Connect(function()
        if not flags.StartShoot then
            return
        end
        
        -- 检查是否只在持枪时瞄准
        if flags.OnlyWhenArmed and not isArmed() then
            return
        end
        
        -- 安全检查
        if not char or not char.Parent or not currentCamera then
            currentCamera = Workspace.CurrentCamera
            if not currentCamera then return end
        end
        
        local cameraCFrame = currentCamera.CFrame
        local nearestTarget, distance = findNearestVisibleTarget(cameraCFrame)
        
        if nearestTarget and nearestTarget.rootPart then
            local targetPosition = nearestTarget.rootPart.Position
            
            -- 使用预测瞄准
            if flags.UsePrediction then
                -- 简单的线性预测
                local targetVelocity = Vector3.new(0, 0, 0)
                -- 这里可以添加更复杂的预测逻辑
                targetPosition = targetPosition + targetVelocity * flags.PredictionTime
            end
            
            local cameraPosition = cameraCFrame.Position
            local lookCFrame = CFrame.lookAt(cameraPosition, targetPosition)
            currentCamera.CFrame = cameraCFrame:Lerp(lookCFrame, flags.SmoothAim)
        end
    end)
end

-- ==================== 创建UI功能按钮 ====================

print("创建UI组件函数")

-- 创建功能按钮
local totalHeight = 0
local buttons = {}

-- 1. 主开关 - 自动瞄准
local mainToggleBtn, toggleMain = createSimpleToggle(
    "MainToggle",
    "自动瞄准",
    "开启/关闭自动瞄准系统",
    "🎯",
    Color3.fromRGB(60, 150, 220),
    flags.StartShoot,
    function(val)
        flags.StartShoot = val
        print("自动瞄准:", val and "开启" or "关闭")
        
        if val then
            -- 初始化瞄准系统
            initAimingSystem()
        else
            -- 关闭瞄准系统
            if cameraLockConnection then
                cameraLockConnection:Disconnect()
                cameraLockConnection = nil
            end
            print("自动瞄准已关闭")
        end
    end
)
mainToggleBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
mainToggleBtn.Parent = functionsContainer
table.insert(buttons, mainToggleBtn)
totalHeight = totalHeight + 55 + 5

-- 2. 炸药桶瞄准开关
local barrelBtn, toggleBarrel = createSimpleToggle(
    "BarrelAim",
    "瞄准炸药桶",
    "瞄准游戏中的炸药桶",
    "💣",
    Color3.fromRGB(220, 120, 60),
    flags.AimBarrel,
    function(val)
        flags.AimBarrel = val
        print("炸药桶瞄准:", val and "开启" or "关闭")
        updateTargetCache()
    end
)
barrelBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
barrelBtn.Parent = functionsContainer
table.insert(buttons, barrelBtn)
totalHeight = totalHeight + 55 + 5

-- 3. Boss瞄准开关
local bossBtn, toggleBoss = createSimpleToggle(
    "BossAim",
    "瞄准Boss",
    "瞄准游戏中的Boss",
    "👹",
    Color3.fromRGB(180, 60, 220),
    flags.AimBoss,
    function(val)
        flags.AimBoss = val
        print("Boss瞄准:", val and "开启" or "关闭")
        updateTargetCache()
    end
)
bossBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
bossBtn.Parent = functionsContainer
table.insert(buttons, bossBtn)
totalHeight = totalHeight + 55 + 5

-- 4. 预测瞄准开关
local predictionBtn, togglePrediction = createSimpleToggle(
    "Prediction",
    "预测瞄准",
    "预测目标移动位置",
    "🔮",
    Color3.fromRGB(150, 220, 60),
    flags.UsePrediction,
    function(val)
        flags.UsePrediction = val
        print("预测瞄准:", val and "开启" or "关闭")
    end
)
predictionBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
predictionBtn.Parent = functionsContainer
table.insert(buttons, predictionBtn)
totalHeight = totalHeight + 55 + 5

-- 5. 射线检测开关
local raycastBtn, toggleRaycast = createSimpleToggle(
    "Raycast",
    "射线检测",
    "检测障碍物可见性",
    "🔍",
    Color3.fromRGB(60, 220, 180),
    flags.UseRaycast,
    function(val)
        flags.UseRaycast = val
        print("射线检测:", val and "开启" or "关闭")
    end
)
raycastBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
raycastBtn.Parent = functionsContainer
table.insert(buttons, raycastBtn)
totalHeight = totalHeight + 55 + 5

-- 6. 仅持枪时瞄准开关
local armedOnlyBtn, toggleArmedOnly = createSimpleToggle(
    "ArmedOnly",
    "仅持枪瞄准",
    "只有在持有枪支时瞄准",
    "🔫",
    Color3.fromRGB(220, 60, 120),
    flags.OnlyWhenArmed,
    function(val)
        flags.OnlyWhenArmed = val
        print("仅持枪时瞄准:", val and "开启" or "关闭")
    end
)
armedOnlyBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
armedOnlyBtn.Parent = functionsContainer
table.insert(buttons, armedOnlyBtn)
totalHeight = totalHeight + 55 + 5

-- 7. 自动更新缓存开关
local autoUpdateBtn, toggleAutoUpdate = createSimpleToggle(
    "AutoUpdate",
    "自动更新缓存",
    "自动更新目标缓存",
    "🔄",
    Color3.fromRGB(120, 60, 220),
    flags.AutoUpdateCache,
    function(val)
        flags.AutoUpdateCache = val
        print("自动更新缓存:", val and "开启" or "关闭")
    end
)
autoUpdateBtn.Position = UDim2.new(0, 4, 0, totalHeight + 5)
autoUpdateBtn.Parent = functionsContainer
table.insert(buttons, autoUpdateBtn)
totalHeight = totalHeight + 55 + 5

-- 8. 最大距离滑块+输入框
local distanceSlider = createValueInputWithSlider(
    "MaxDistance",
    "最大距离",
    "瞄准最大距离(米)",
    "📏",
    Color3.fromRGB(220, 200, 60),
    100,
    2000,
    flags.MaxDistance,
    function(val)
        flags.MaxDistance = val
        print("最大距离:", val)
    end
)
distanceSlider.Position = UDim2.new(0, 4, 0, totalHeight + 5)
distanceSlider.Parent = functionsContainer
table.insert(buttons, distanceSlider)
totalHeight = totalHeight + 70 + 5

-- 9. 平滑度滑块+输入框
local smoothSlider = createValueInputWithSlider(
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
        print("平滑度:", val)
    end
)
smoothSlider.Position = UDim2.new(0, 4, 0, totalHeight + 5)
smoothSlider.Parent = functionsContainer
table.insert(buttons, smoothSlider)
totalHeight = totalHeight + 70 + 5

-- 10. 预测时间输入框
local predictionTimeInput = createValueInput(
    "PredictionTime",
    "预测时间",
    "瞄准预测时间(秒)",
    "⏱️",
    Color3.fromRGB(60, 180, 220),
    0.1,
    1.0,
    flags.PredictionTime,
    function(val)
        flags.PredictionTime = val
        print("预测时间:", val)
    end
)
predictionTimeInput.Position = UDim2.new(0, 4, 0, totalHeight + 5)
predictionTimeInput.Parent = functionsContainer
table.insert(buttons, predictionTimeInput)
totalHeight = totalHeight + 60 + 5

-- 11. 扫描间隔输入框
local scanIntervalInput = createValueInput(
    "ScanInterval",
    "扫描间隔",
    "目标扫描间隔(秒)",
    "📡",
    Color3.fromRGB(220, 100, 60),
    1,
    10,
    flags.ScanInterval,
    function(val)
        flags.ScanInterval = val
        print("扫描间隔:", val)
    end
)
scanIntervalInput.Position = UDim2.new(0, 4, 0, totalHeight + 5)
scanIntervalInput.Parent = functionsContainer
table.insert(buttons, scanIntervalInput)
totalHeight = totalHeight + 60 + 5

-- 12. 视角角度输入框
local viewAngleInput = createValueInput(
    "ViewAngle",
    "视角角度",
    "瞄准视角角度(度)",
    "📐",
    Color3.fromRGB(60, 220, 120),
    30,
    180,
    flags.ViewAngle,
    function(val)
        flags.ViewAngle = val
        print("视角角度:", val)
    end
)
viewAngleInput.Position = UDim2.new(0, 4, 0, totalHeight + 5)
viewAngleInput.Parent = functionsContainer
table.insert(buttons, viewAngleInput)
totalHeight = totalHeight + 60 + 5

print("创建功能按钮完成，总高度:", totalHeight)

-- 设置容器高度
functionsContainer.Size = UDim2.new(1, 0, 0, totalHeight)

-- 设置滚动区域大小
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

-- 组装UI
print("开始组装UI...")

functionsContainer.Parent = scrollingFrame
scrollingFrame.Parent = contentArea
titleLabel.Parent = titleBar
closeButton.Parent = titleBar
scaleButton.Parent = titleBar
titleBar.Parent = mainFrame
contentArea.Parent = mainFrame

-- 添加边框
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(1, 2, 1, 2)
border.Position = UDim2.new(0, -1, 0, -1)
border.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
border.BackgroundTransparency = 0.7
border.BorderSizePixel = 0
border.ZIndex = -1
border.Visible = true

local borderCorner = Instance.new("UICorner")
borderCorner.CornerRadius = UDim.new(0, 13)
borderCorner.Parent = border
border.Parent = mainFrame

print("UI组装完成，添加到ScreenGui...")

mainFrame.Parent = screenGui

-- 最后将ScreenGui添加到PlayerGui
screenGui.Parent = playerGui

print("UI已成功添加到PlayerGui")

-- ==================== UI动画和交互 ====================

-- 彩虹颜色变换函数
local hue = 0
local function updateRainbowText()
    hue = (hue + 0.005) % 1
    local color = Color3.fromHSV(hue, 0.8, 1)
    titleLabel.TextColor3 = color
end

-- 窗口入场动画
local function showWindowAnimation()
    -- 初始位置：屏幕右侧外部
    mainFrame.Position = UDim2.new(1.5, -170, 0.5, -210)
    mainFrame.Visible = true
    
    -- 入场动画
    local entryTween = TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -170, 0.5, -210)
    })
    
    entryTween:Play()
    entryTween.Completed:Connect(function()
        print("UI入场动画完成")
    end)
end

-- 关闭功能
closeButton.MouseButton1Click:Connect(function()
    print("关闭按钮被点击")
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
        local minimizedSize = UDim2.new(0, 140, 0, 35)
        local minimizedPosition = UDim2.new(0.5, -70, 0, 10)
        
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = minimizedSize,
            Position = minimizedPosition,
            BackgroundTransparency = 0.4
        })
        tween:Play()
        
        contentArea.Visible = false
        titleLabel.Text = "神仙下山把道传"
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
        titleLabel.Text = "义和团扶清灭洋"
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
    print("缩放按钮被点击")
    toggleMinimize()
    
    if isMinimized then
        minimizedClicker.Size = UDim2.new(0, 140, 0, 35)
        minimizedClicker.Position = UDim2.new(0.5, -70, 0, 10)
        minimizedClicker.Visible = true
    else
        minimizedClicker.Visible = false
    end
end)

minimizedClicker.MouseButton1Click:Connect(function()
    if isMinimized then
        print("小长方形被点击")
        toggleMinimize()
        minimizedClicker.Visible = false
    end
end)

-- 按钮悬停效果
local function setupButtonHover(button)
    local originalColor = button.BackgroundColor3
    local originalTransparency = button.BackgroundTransparency
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Color3.fromRGB(
                math.min(255, originalColor.R * 255 * 1.2),
                math.min(255, originalColor.G * 255 * 1.2),
                math.min(255, originalColor.B * 255 * 1.2)
            )
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundTransparency = originalTransparency,
            BackgroundColor3 = originalColor
        })
        tween:Play()
    end)
end

-- 为所有按钮添加悬停效果
for _, button in ipairs(buttons) do
    setupButtonHover(button)
end

closeButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(closeButton, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    })
    tween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(closeButton, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    })
    tween:Play()
end)

scaleButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(scaleButton, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(80, 150, 255)
    })
    tween:Play()
end)

scaleButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(scaleButton, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.fromRGB(60, 120, 220)
    })
    tween:Play()
end)

-- 运行彩虹文本更新
local rainbowConnection
rainbowConnection = RunService.RenderStepped:Connect(updateRainbowText)

print("=== 义和团自动瞄准UI加载完成 ===")
print("UI位置: 屏幕中央")
print("UI尺寸: 340x420 正方形")
print("包含功能:")
print("1. 自动瞄准主开关")
print("2. 炸药桶瞄准开关")
print("3. Boss瞄准开关")
print("4. 预测瞄准开关")
print("5. 射线检测开关")
print("6. 仅持枪时瞄准开关")
print("7. 自动更新缓存开关")
print("8. 最大距离滑块+输入框 (100-2000)")
print("9. 平滑度滑块+输入框 (0.1-1.0)")
print("10. 预测时间输入框 (0.1-1.0)")
print("11. 扫描间隔输入框 (1-10)")
print("12. 视角角度输入框 (30-180)")
print("=============================")

-- 添加显示/隐藏快捷键
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            print("按下了RightControl键，显示/隐藏UI")
            screenGui.Enabled = not screenGui.Enabled
        elseif input.KeyCode == Enum.KeyCode.F1 then
            print("按下了F1键，切换UI显示")
            screenGui.Enabled = not screenGui.Enabled
        end
    end
end)

-- 确保UI可见
screenGui.Enabled = true
mainFrame.Visible = false -- 先隐藏，等动画显示

-- 初始缓存更新
task.spawn(function()
    task.wait(1)
    updateTransparentPartsCache()
    updateTargetCache()
    print("初始缓存更新完成")
end)

-- 角色变化处理
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    print("角色已更新")
    
    if flags.StartShoot then
        task.wait(1)
        initAimingSystem()
        print("瞄准系统已重新初始化")
    end
end)

-- 启动UI显示序列
task.spawn(function()
    -- 显示注入动画
    showInjectionAnimation()
    
    -- 等待注入动画完成
    task.wait(2.5)
    
    -- 显示UI窗口
    showWindowAnimation()
    
    print("UI初始化完成，应该在屏幕上可见")
end)
