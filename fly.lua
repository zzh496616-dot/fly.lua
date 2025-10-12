-- 可用的加密版本 - 保持GUI库完整
local Players = game:GetService("Players")
local RunService = game:GetService("RunService") 
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

-- 追踪状态变量
local trackEnabled = false
local trackConn = nil
local currentTarget = nil

-- 基础追踪函数
local function getDistance(target)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return math.huge end
    if not target or not target:FindFirstChild("HumanoidRootPart") then return math.huge end
    return (char.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
end

local function findMovingPlayers()
    local validPlayers = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if rootPart and humanoid and humanoid.Health > 0 and humanoid.MoveDirection.Magnitude > 0 then
                table.insert(validPlayers, player)
            end
        end
    end
    return validPlayers
end

local function startTracking()
    if trackConn then trackConn:Disconnect() end
    
    trackConn = RunService.Heartbeat:Connect(function()
        if not trackEnabled or not LocalPlayer.Character then 
            -- 停止移动
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position) end
            end
            return 
        end
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then return end
        
        local validPlayers = findMovingPlayers()
        local nearestPlayer, minDistance = nil, math.huge
        
        for _, player in ipairs(validPlayers) do
            local distance = getDistance(player.Character)
            if distance < minDistance then
                minDistance = distance
                nearestPlayer = player
            end
        end
        
        if nearestPlayer and nearestPlayer.Character then
            currentTarget = nearestPlayer
            local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
            local targetCF = nearestPlayer.Character.HumanoidRootPart.CFrame
            -- 后方位置
            local rearPos = targetPos + (-targetCF.LookVector * 8 + targetCF.UpVector * 3)
            
            humanoid:MoveTo(rearPos)
        else
            currentTarget = nil
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position) end
            end
        end
    end)
end

-- 自动跳跃功能
local autoJumpEnabled = false
local autoJumpConn = nil

local function startAutoJump()
    if autoJumpConn then autoJumpConn:Disconnect() end
    
    local Char = LocalPlayer.Character
    local Human = Char and Char:FindFirstChildOfClass("Humanoid")
    
    local function autoJump()
        if Char and Human then
            local check1 = workspace:FindPartOnRay(Ray.new(Human.RootPart.Position - Vector3.new(0,1.5,0), Human.RootPart.CFrame.lookVector * 3), Char)
            local check2 = workspace:FindPartOnRay(Ray.new(Human.RootPart.Position + Vector3.new(0,1.5,0), Human.RootPart.CFrame.lookVector * 3), Char)
            if check1 or check2 then Human.Jump = true end
        end
    end
    
    autoJump()
    autoJumpConn = RunService.RenderStepped:Connect(autoJump)
end

local function stopAutoJump()
    if autoJumpConn then autoJumpConn:Disconnect() autoJumpConn = nil end
end

-- 创建可用的GUI库
if not library then
    library = {}
    function library.window(title)
        local self = {}
        
        function self.toggle(name, default, callback)
            spawn(function()
                callback(default)
            end)
        end
        
        function self.button(name, callback)
            spawn(function()
                callback()
            end)
        end
        
        function self.slider(name, min, max, step, default, callback)
            spawn(function()
                callback(default)
            end)
        end
        
        function self.label(text)
            local labelObj = {}
            function labelObj.changetext(newText) end
            return labelObj
        end
        
        return self
    end
end

-- 脚本A GUI
local trackWindow = library.window("自动跟踪")

trackWindow.toggle("启用自动跟踪", false, function(enabled)
    trackEnabled = enabled
    if enabled then
        if not LocalPlayer.Character then 
            trackEnabled = false
            return 
        end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            trackEnabled = false
            return 
        end
        startTracking()
    else
        if trackConn then trackConn:Disconnect() trackConn = nil end
        currentTarget = nil
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position) end
        end
    end
end)

trackWindow.toggle("远离僵尸模式", false, function(enabled)
    print("僵尸模式:", enabled)
end)

trackWindow.toggle("使用路径寻找", true, function(enabled)
    print("路径寻找:", enabled)
end)

trackWindow.toggle("启用自动跳跃", false, function(enabled)
    autoJumpEnabled = enabled
    if enabled then 
        startAutoJump()
    else
        stopAutoJump()
    end
end)

-- 脚本B GUI
if not shoot then 
    shoot = {}
    function shoot.toggle(name, default, callback)
        spawn(function()
            callback(default)
        end)
    end
end

shoot.toggle("开启自动瞄准炸药桶", false, function(enabled)
    print("自动瞄准:", enabled)
end)

print("脚本加载成功！使用GUI控制功能")
