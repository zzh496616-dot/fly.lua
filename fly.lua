--== 自动控制台整合版 ==--
-- 功能：自动追踪 / 自动跳跃 / 避开僵尸 / 移动方式切换 / 自动瞄准炸药桶和Boss
-- 支持UI收缩 & 完全关闭

-- 服务
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- 状态表
local Flags = {
    AutoTrack = false,
    AutoJump = false,
    AvoidZombie = false,
    MoveSwitch = false,
    AutoAim = false,
    Running = true
}

--== UI 创建 ==--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoConsoleUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 320)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.Text = "自动控制台"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Frame

-- 收缩按钮
local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
CollapseBtn.Position = UDim2.new(1, -60, 0, 0)
CollapseBtn.Text = "-"
CollapseBtn.Parent = Frame

-- 关闭按钮
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.Parent = Frame

-- 按钮生成函数
local function createButton(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.Position = UDim2.new(0, 10, 0, 40 + (order-1)*50)
    Btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Text = name.." [OFF]"
    Btn.Parent = Frame
    return Btn
end

-- 功能按钮
local Btns = {
    AutoTrack = createButton("自动追踪", 1),
    AutoJump = createButton("自动跳跃", 2),
    AvoidZombie = createButton("避开僵尸", 3),
    MoveSwitch = createButton("切换移动", 4),
    AutoAim = createButton("自动瞄准", 5),
}

--== 功能逻辑 ==--

-- 自动追踪
local function AutoTrackFunc()
    if not Flags.AutoTrack then return end
    local target = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            target = p.Character.HumanoidRootPart
            break
        end
    end
    if target then
        HRP.CFrame = HRP.CFrame:Lerp(target.CFrame * CFrame.new(0,0,-5), 0.1)
    end
end

-- 自动跳跃
local JumpCooldown = 0
local function AutoJumpFunc()
    if not Flags.AutoJump then return end
    if tick() - JumpCooldown > 1 then
        Humanoid.Jump = true
        JumpCooldown = tick()
    end
end

-- 避开僵尸
local function AvoidZombieFunc()
    if not Flags.AvoidZombie then return end
    for _, m in ipairs(workspace:GetChildren()) do
        if m:FindFirstChild("ZombieTag") and m:FindFirstChild("HumanoidRootPart") then
            local dist = (HRP.Position - m.HumanoidRootPart.Position).magnitude
            if dist < 15 then
                HRP.CFrame = HRP.CFrame + (HRP.Position - m.HumanoidRootPart.Position).Unit * 2
            end
        end
    end
end

-- 移动方式切换
local function MoveSwitchFunc()
    if Flags.MoveSwitch then
        Humanoid.WalkSpeed = 32
    else
        Humanoid.WalkSpeed = 16
    end
end

-- 自动瞄准炸药桶 / Boss
local function AutoAimFunc()
    if not Flags.AutoAim then return end
    local target = nil
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "ExplosiveBarrel" or obj.Name == "Boss" then
            if obj:FindFirstChild("HumanoidRootPart") then
                target = obj.HumanoidRootPart
                break
            end
        end
    end
    if target then
        local dir = (target.Position - HRP.Position).Unit
        HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + dir)
    end
end

--== RunService 循环 ==--
local Loop = RunService.Heartbeat:Connect(function()
    if not Flags.Running then return end
    AutoTrackFunc()
    AutoJumpFunc()
    AvoidZombieFunc()
    MoveSwitchFunc()
    AutoAimFunc()
end)

--== UI 按钮功能绑定 ==--
for flag, Btn in pairs(Btns) do
    Btn.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        Btn.Text = Btn.Text:gsub("%[ON%]", "[OFF]"):gsub("%[OFF%]", "[ON]")
    end)
end

-- 收缩
local Collapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    Collapsed = not Collapsed
    for _, btn in pairs(Btns) do
        btn.Visible = not Collapsed
    end
    Frame.Size = Collapsed and UDim2.new(0,260,0,30) or UDim2.new(0,260,0,320)
end)

-- 关闭
CloseBtn.MouseButton1Click:Connect(function()
    Flags.Running = false
    Loop:Disconnect()
    ScreenGui:Destroy()
    script:Destroy()
end)
