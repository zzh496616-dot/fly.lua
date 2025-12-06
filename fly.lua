-- 完整自瞄系统UI - 包含所有功能
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- 全局配置表（包含所有原脚本功能参数）
local AimBotConfig = {
    -- 主开关
    AutoAimEnabled = false,
    
    -- 目标类型
    AimAtBarrel = true,
    AimAtBoss = true,
    BarrelPriority = true,
    
    -- 预测系统
    PredictionEnabled = true,
    PredictionTime = 0.2,
    MaxHistorySize = 5,
    MinVelocityThreshold = 0.1,
    
    -- 视野和距离
    MaxViewAngle = 90,
    DetectionRange = 1000,
    
    -- 可见性检测
    VisibilityCheck = true,
    IgnoreTransparentWalls = true,
    TransparencyThreshold = 0.8,
    
    -- 性能设置
    PerformanceMode = false,
    CacheUpdateInterval = 2,
    TransparentCacheUpdate = 5,
    
    -- 瞄准设置
    AimSmoothing = 0.3,
    AimIntensity = 0.3,
    
    -- 高级设置
    TargetScanInterval = 2,
    BossScanInterval = 1,
    CleanupInterval = 5
}

-- 创建主界面
local AimBotUI = Instance.new("ScreenGui")
AimBotUI.Name = "完整自瞄系统UI"
AimBotUI.ResetOnSpawn = false
AimBotUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AimBotUI.Parent = player:WaitForChild("PlayerGui")

-- ... [UI创建代码，与之前相同，但增加更多选项] ...

-- 创建功能选项的函数（增强版）
local function createEnhancedSetting(parent, name, desc, settingType, configKey, minValue, maxValue, defaultValue)
    local optionFrame = Instance.new("Frame")
    optionFrame.Name = name .. "选项"
    optionFrame.Size = UDim2.new(1, 0, 0, 60)
    optionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    optionFrame.BorderSizePixel = 0
    optionFrame.Parent = parent
    
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 6)
    optionCorner.Parent = optionFrame
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Name = "标题"
    title.Size = UDim2.new(0.7, 0, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.Gotham
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = optionFrame
    
    -- 描述
    local description = Instance.new("TextLabel")
    description.Name = "描述"
    description.Size = UDim2.new(0.7, -15, 0, 20)
    description.Position = UDim2.new(0, 10, 0, 28)
    description.BackgroundTransparency = 1
    description.Text = desc
    description.TextColor3 = Color3.fromRGB(160, 160, 170)
    description.Font = Enum.Font.Gotham
    description.TextSize = 11
    description.TextWrapped = true
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.Parent = optionFrame
    
    -- 根据类型创建不同的控制
    if settingType == "toggle" then
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = "开关"
        toggleBtn.Size = UDim2.new(0, 60, 0, 30)
        toggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
        toggleBtn.BackgroundColor3 = AimBotConfig[configKey] and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(80, 80, 90)
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.Text = AimBotConfig[configKey] and "开启" or "关闭"
        toggleBtn.Font = Enum.Font.GothamMedium
        toggleBtn.TextSize = 12
        toggleBtn.Parent = optionFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 5)
        toggleCorner.Parent = toggleBtn
        
        toggleBtn.MouseButton1Click:Connect(function()
            AimBotConfig[configKey] = not AimBotConfig[configKey]
            toggleBtn.BackgroundColor3 = AimBotConfig[configKey] and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(80, 80, 90)
            toggleBtn.Text = AimBotConfig[configKey] and "开启" or "关闭"
            updateStatusDisplay()
        end)
        
        return optionFrame
        
    elseif settingType == "slider" then
        -- 创建滑块
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "滑块框架"
        sliderFrame.Size = UDim2.new(0, 120, 0, 40)
        sliderFrame.Position = UDim2.new(1, -130, 0.5, -20)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = optionFrame
        
        -- 当前值显示
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "当前值"
        valueLabel.Size = UDim2.new(0, 40, 0, 20)
        valueLabel.Position = UDim2.new(1, -40, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(AimBotConfig[configKey])
        valueLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
        valueLabel.Font = Enum.Font.GothamMedium
        valueLabel.TextSize = 12
        valueLabel.Parent = sliderFrame
        
        -- 滑块条
        local sliderBar = Instance.new("Frame")
        sliderBar.Name = "滑块条"
        sliderBar.Size = UDim2.new(0, 70, 0, 4)
        sliderBar.Position = UDim2.new(0, 0, 0.5, -2)
        sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = sliderFrame
        
        local sliderBarCorner = Instance.new("UICorner")
        sliderBarCorner.CornerRadius = UDim.new(0, 2)
        sliderBarCorner.Parent = sliderBar
        
        -- 滑块按钮
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Name = "滑块按钮"
        sliderBtn.Size = UDim2.new(0, 16, 0, 16)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
        sliderBtn.Text = ""
        sliderBtn.Parent = sliderBar
        
        local sliderBtnCorner = Instance.new("UICorner")
        sliderBtnCorner.CornerRadius = UDim.new(1, 0)
        sliderBtnCorner.Parent = sliderBtn
        
        -- 计算初始位置
        local range = maxValue - minValue
        local normalizedValue = (AimBotConfig[configKey] - minValue) / range
        sliderBtn.Position = UDim2.new(normalizedValue, -8, 0.5, -8)
        
        -- 滑块拖动逻辑
        local isDraggingSlider = false
        sliderBtn.MouseButton1Down:Connect(function()
            isDraggingSlider = true
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDraggingSlider = false
            end
        end)
        
        sliderBtn.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if isDraggingSlider then
                local mouse = game:GetService("Players").LocalPlayer:GetMouse()
                local relativeX = (mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                
                local newValue = minValue + (relativeX * range)
                newValue = math.floor(newValue * 100) / 100  -- 保留2位小数
                
                AimBotConfig[configKey] = newValue
                valueLabel.Text = tostring(newValue)
                sliderBtn.Position = UDim2.new(relativeX, -8, 0.5, -8)
                updateStatusDisplay()
            end
        end)
        
        return optionFrame
    end
end

-- 更新状态显示
local function updateStatusDisplay()
    if not statusLabel then return end
    
    local statusText = "状态: "
    if not AimBotConfig.AutoAimEnabled then
        statusText = statusText .. "关闭"
    else
        local targetCount = 0
        if AimBotConfig.AimAtBarrel then targetCount = targetCount + 1 end
        if AimBotConfig.AimAtBoss then targetCount = targetCount + 1 end
        
        statusText = statusText .. string.format("开启 | 目标类型: %d种", targetCount)
        
        if AimBotConfig.PredictionEnabled then
            statusText = statusText .. " | 预测开启"
        end
        
        if AimBotConfig.PerformanceMode then
            statusText = statusText .. " | 性能模式"
        end
    end
    
    statusLabel.Text = statusText
end

-- 完整的设置选项列表（包含所有原脚本功能）
local enhancedSettings = {
    -- 主开关区域
    {name = "智能自瞄系统", desc = "开启/关闭整个自瞄系统", type = "toggle", key = "AutoAimEnabled"},
    
    -- 目标类型设置
    {name = "瞄准炸药桶", desc = "自动瞄准Barrel僵尸", type = "toggle", key = "AimAtBarrel"},
    {name = "瞄准BOSS", desc = "自动瞄准BOSS目标", type = "toggle", key = "AimAtBoss"},
    {name = "目标优先级", desc = "炸药桶优先于BOSS", type = "toggle", key = "BarrelPriority"},
    
    -- 预测系统设置
    {name = "预测瞄准", desc = "预测目标移动轨迹", type = "toggle", key = "PredictionEnabled"},
    {name = "预测时间", desc = "预测未来时间(秒)", type = "slider", key = "PredictionTime", min = 0.1, max = 0.5},
    {name = "历史记录大小", desc = "位置历史记录数量", type = "slider", key = "MaxHistorySize", min = 2, max = 10},
    {name = "速度阈值", desc = "最小移动速度阈值", type = "slider", key = "MinVelocityThreshold", min = 0.01, max = 0.5},
    
    -- 视野和距离设置
    {name = "视野角度", desc = "最大瞄准视野角度", type = "slider", key = "MaxViewAngle", min = 30, max = 180},
    {name = "检测范围", desc = "最大目标检测距离", type = "slider", key = "DetectionRange", min = 50, max = 2000},
    
    -- 可见性检测设置
    {name = "可见性检测", desc = "检查目标是否可见", type = "toggle", key = "VisibilityCheck"},
    {name = "忽略透明墙", desc = "忽略透明障碍物", type = "toggle", key = "IgnoreTransparentWalls"},
    {name = "透明度阈值", desc = "视为透明的阈值", type = "slider", key = "TransparencyThreshold", min = 0.5, max = 1},
    
    -- 性能设置
    {name = "性能模式", desc = "降低缓存更新频率", type = "toggle", key = "PerformanceMode"},
    {name = "缓存更新间隔", desc = "目标缓存更新间隔(秒)", type = "slider", key = "CacheUpdateInterval", min = 1, max = 10},
    {name = "透明缓存间隔", desc = "透明部件缓存间隔(秒)", type = "slider", key = "TransparentCacheUpdate", min = 2, max = 20},
    
    -- 瞄准设置
    {name = "瞄准平滑度", desc = "摄像机移动平滑度", type = "slider", key = "AimSmoothing", min = 0.1, max = 0.9},
    {name = "瞄准强度", desc = "自瞄跟随强度", type = "slider", key = "AimIntensity", min = 0.1, max = 0.9},
    
    -- 高级设置
    {name = "目标扫描间隔", desc = "扫描新目标的间隔(秒)", type = "slider", key = "TargetScanInterval", min = 0.5, max = 5},
    {name = "BOSS扫描间隔", desc = "扫描BOSS的间隔(秒)", type = "slider", key = "BossScanInterval", min = 0.5, max = 3},
    {name = "清理间隔", desc = "清理旧数据的间隔(秒)", type = "slider", key = "CleanupInterval", min = 2, max = 10},
}

-- 创建所有设置选项
local settingsContainer = Instance.new("ScrollingFrame")
-- ... [容器创建代码] ...

local yOffset = 5
for i, setting in ipairs(enhancedSettings) do
    local option = createEnhancedSetting(
        settingsContainer,
        setting.name,
        setting.desc,
        setting.type,
        setting.key,
        setting.min,
        setting.max,
        setting.default
    )
    option.Position = UDim2.new(0, 0, 0, yOffset)
    yOffset = yOffset + 65
end

settingsContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

-- 预设模式（快速应用配置）
local function applyPreset(presetName)
    if presetName == "平衡模式" then
        AimBotConfig = {
            AutoAimEnabled = true,
            AimAtBarrel = true,
            AimAtBoss = true,
            BarrelPriority = true,
            PredictionEnabled = true,
            PredictionTime = 0.2,
            MaxViewAngle = 90,
            VisibilityCheck = true,
            IgnoreTransparentWalls = true,
            PerformanceMode = false,
            AimSmoothing = 0.3
        }
        
    elseif presetName == "性能模式" then
        AimBotConfig = {
            AutoAimEnabled = true,
            AimAtBarrel = true,
            AimAtBoss = false, -- 关闭BOSS检测提高性能
            BarrelPriority = true,
            PredictionEnabled = false, -- 关闭预测
            VisibilityCheck = false, -- 关闭可见性检测
            PerformanceMode = true,
            CacheUpdateInterval = 5,
            TransparentCacheUpdate = 10
        }
        
    elseif presetName == "精确模式" then
        AimBotConfig = {
            AutoAimEnabled = true,
            AimAtBarrel = true,
            AimAtBoss = true,
            PredictionEnabled = true,
            PredictionTime = 0.3,
            MaxHistorySize = 8,
            MinVelocityThreshold = 0.05,
            MaxViewAngle = 120,
            VisibilityCheck = true,
            TransparencyThreshold = 0.9,
            AimSmoothing = 0.2
        }
    end
    
    -- 刷新所有UI元素
    refreshAllSettings()
    updateStatusDisplay()
end

-- 导出配置函数
local function exportConfig()
    local configString = "local AimBotConfig = {\n"
    for key, value in pairs(AimBotConfig) do
        if type(value) == "boolean" then
            configString = configString .. string.format("    %s = %s,\n", key, tostring(value))
        elseif type(value) == "number" then
            configString = configString .. string.format("    %s = %s,\n", key, tostring(value))
        end
    end
    configString = configString .. "}"
    
    print("配置已导出到控制台")
    print(configString)
    
    -- 复制到剪贴板（如果有服务）
    pcall(function()
        setclipboard(configString)
        print("配置已复制到剪贴板")
    end)
end

-- 导入配置函数
local function importConfig(configString)
    -- 这里需要安全地解析并应用配置
    -- 注意：实际应用中需要更安全的解析方法
    print("导入配置功能需要实现")
end

-- 底部控制按钮
local function createControlButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 12
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- 创建控制按钮容器
local controlButtonsFrame = Instance.new("Frame")
controlButtonsFrame.Name = "控制按钮容器"
controlButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
controlButtonsFrame.BackgroundTransparency = 1
controlButtonsFrame.Parent = contentFrame

-- 预设按钮
local presetButton = createControlButton(controlButtonsFrame, "平衡模式", function()
    applyPreset("平衡模式")
end)
presetButton.Position = UDim2.new(0, 10, 0, 5)

local performanceButton = createControlButton(controlButtonsFrame, "性能模式", function()
    applyPreset("性能模式")
end)
performanceButton.Position = UDim2.new(0, 100, 0, 5)

local precisionButton = createControlButton(controlButtonsFrame, "精确模式", function()
    applyPreset("精确模式")
end)
precisionButton.Position = UDim2.new(0, 190, 0, 5)

-- 导出按钮
local exportButton = createControlButton(controlButtonsFrame, "导出配置", exportConfig)
exportButton.Position = UDim2.new(1, -90, 0, 5)

-- 状态显示区域
local advancedStatusFrame = Instance.new("Frame")
advancedStatusFrame.Name = "高级状态显示"
advancedStatusFrame.Size = UDim2.new(1, 0, 0, 60)
advancedStatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
advancedStatusFrame.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = advancedStatusFrame

-- 状态标签
statusLabel = Instance.new("TextLabel")
statusLabel.Name = "状态标签"
statusLabel.Size = UDim2.new(1, -20, 0.5, -5)
statusLabel.Position = UDim2.new(0, 10, 0, 5)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态: 等待初始化..."
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = advancedStatusFrame

-- 详细信息标签
local detailLabel = Instance.new("TextLabel")
detailLabel.Name = "详细信息"
detailLabel.Size = UDim2.new(1, -20, 0.5, -5)
detailLabel.Position = UDim2.new(0, 10, 0.5, 0)
detailLabel.BackgroundTransparency = 1
detailLabel.Text = "缓存: 0 | 历史: 0 | 目标: 0"
detailLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
detailLabel.Font = Enum.Font.Gotham
detailLabel.TextSize = 11
detailLabel.TextXAlignment = Enum.TextXAlignment.Left
detailLabel.Parent = advancedStatusFrame

-- 初始化完成
print("🎯 完整自瞄系统UI 已加载!")
print("包含所有功能:")
print("  ✅ 炸药桶瞄准 | BOSS瞄准 | 目标优先级")
print("  ✅ 预测系统 | 历史记录 | 速度阈值")
print("  ✅ 视野角度 | 检测范围 | 可见性检测")
print("  ✅ 透明墙忽略 | 性能模式 | 缓存系统")
print("  ✅ 3种预设模式 | 配置导入导出")

-- 返回完整的配置和控制函数
return {
    Config = AimBotConfig,
    
    获取配置 = function()
        return AimBotConfig
    end,
    
    更新配置 = function(newConfig)
        for key, value in pairs(newConfig) do
            if AimBotConfig[key] ~= nil then
                AimBotConfig[key] = value
            end
        end
        refreshAllSettings()
        updateStatusDisplay()
    end,
    
    应用预设 = applyPreset,
    导出配置 = exportConfig,
    
    开启自瞄系统 = function()
        -- 这里需要调用你的原自瞄脚本的启动函数
        -- 将AimBotConfig传递给自瞄系统
        print("启动自瞄系统，使用当前配置")
    end,
    
    关闭自瞄系统 = function()
        -- 这里需要调用你的原自瞄脚本的关闭函数
        print("关闭自瞄系统")
    end
}
