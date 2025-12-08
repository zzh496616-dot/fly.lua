local _={}
_.__={}
_.__._={}
_.__.__={}
function _.__._.__(a)
return game:GetService(a)
end
local b=_.__._.__
local c=b("Players")
local d=b("TweenService")
local e=b("RunService")
local f=b("UserInputService")
local g=b("Workspace")
local h=b("TextService")
if not e:IsClient()then
error("脚本必须在客户端运行")
return
end
local i=c.LocalPlayer
if not i then
i=c:GetPropertyChangedSignal("LocalPlayer"):Wait()
i=c.LocalPlayer
end
local j=i:WaitForChild("PlayerGui")
print("PlayerGui加载成功")
local k=Instance.new("Frame")
k.Name="InjectionOverlay"
k.Size=UDim2.new(1,0,1,0)
k.Position=UDim2.new(0,0,0,0)
k.BackgroundColor3=Color3.fromRGB(0,0,0)
k.BackgroundTransparency=0.8
k.ZIndex=999
k.Visible=false
local l=Instance.new("TextLabel")
l.Name="InjectionText"
l.Size=UDim2.new(1,0,0,100)
l.Position=UDim2.new(0,0,0.5,-50)
l.BackgroundTransparency=1
l.Text="义和团自动瞄准注入中..."
l.Font=Enum.Font.GothamBold
l.TextSize=36
l.TextColor3=Color3.fromRGB(255,255,255)
l.TextStrokeTransparency=0.5
l.TextStrokeColor3=Color3.fromRGB(0,0,0)
l.ZIndex=1000
l.Visible=false
local m=Instance.new("Frame")
m.Name="ProgressContainer"
m.Size=UDim2.new(0.4,0,0,20)
m.Position=UDim2.new(0.3,0,0.5,30)
m.BackgroundColor3=Color3.fromRGB(50,50,50)
m.BorderSizePixel=0
m.ZIndex=1000
m.Visible=false
local n=Instance.new("UICorner")
n.CornerRadius=UDim.new(1,0)
n.Parent=m
local o=Instance.new("Frame")
o.Name="ProgressBar"
o.Size=UDim2.new(0,0,1,0)
o.Position=UDim2.new(0,0,0,0)
o.BackgroundColor3=Color3.fromHSV(0.3,0.8,1)
o.BorderSizePixel=0
o.ZIndex=1001
local p=Instance.new("UICorner")
p.CornerRadius=UDim.new(1,0)
p.Parent=o
o.Parent=m
m.Parent=k
l.Parent=k
function _.showAnim()
k.Visible=true
l.Visible=true
m.Visible=true
o.Size=UDim2.new(0,0,1,0)
local q=0
local r
r=e.Heartbeat:Connect(function()
q=(q+0.02)%1
l.TextColor3=Color3.fromHSV(q,0.8,1)
end)
local s=TweenInfo.new(1.5,Enum.EasingStyle.Linear)
local t=d:Create(o,s,{Size=UDim2.new(1,0,1,0)})
local u={"初始化UI系统...","加载瞄准模块...","设置缓存系统...","连接事件处理器...","注入完成!"}
local v=1
local w=#u
local x=1.5/w
function _.updateStep()
if v<=w then
l.Text="义和团自动瞄准\n"..u[v]
v=v+1
o.BackgroundColor3=Color3.fromHSV(v*0.15,0.8,1)
end
end
local y=0
local z=tick()
local A
A=e.Heartbeat:Connect(function()
local B=tick()
local C=B-z
z=B
y=y+C
if y>=x then
y=0
_.updateStep()
end
end)
t:Play()
t.Completed:Connect(function()
if r then
r:Disconnect()
r=nil
end
if A then
A:Disconnect()
A=nil
end
local D=d:Create(k,TweenInfo.new(0.5),{BackgroundTransparency=1})
D:Play()
D.Completed:Connect(function()
k:Destroy()
print("注入完成")
end)
end)
end
local E=Instance.new("ScreenGui")
E.Name="义和团UI"
E.ResetOnSpawn=false
E.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
E.Enabled=true
local F=Instance.new("Frame")
F.Name="MainFrame"
F.Size=UDim2.new(0,340,0,420)
F.Position=UDim2.new(0.5,-170,0.5,-210)
F.BackgroundColor3=Color3.fromRGB(30,30,40)
F.BackgroundTransparency=0.2
F.BorderSizePixel=0
F.ClipsDescendants=true
F.Visible=true
local G=Instance.new("UICorner")
G.CornerRadius=UDim.new(0,12)
G.Parent=F
local H=Instance.new("Frame")
H.Name="TitleBar"
H.Size=UDim2.new(1,0,0,40)
H.Position=UDim2.new(0,0,0,0)
H.BackgroundColor3=Color3.fromRGB(40,40,50)
H.BackgroundTransparency=0.1
H.BorderSizePixel=0
local I=Instance.new("UICorner")
I.CornerRadius=UDim.new(0,12,0,0)
I.Parent=H
local J=Instance.new("TextLabel")
J.Name="TitleLabel"
J.Size=UDim2.new(0.6,0,1,0)
J.Position=UDim2.new(0.05,0,0,0)
J.BackgroundTransparency=1
J.Text="义和团刀枪不入"
J.Font=Enum.Font.GothamBold
J.TextSize=18
J.TextColor3=Color3.fromRGB(255,255,255)
J.TextStrokeTransparency=0.7
J.TextStrokeColor3=Color3.fromRGB(0,0,0)
local K=Instance.new("TextButton")
K.Name="CloseButton"
K.Size=UDim2.new(0,28,0,28)
K.Position=UDim2.new(1,-32,0.5,-14)
K.BackgroundColor3=Color3.fromRGB(220,60,60)
K.BackgroundTransparency=0.3
K.Text="×"
K.TextColor3=Color3.fromRGB(255,255,255)
K.TextScaled=true
K.Font=Enum.Font.GothamBold
K.AutoButtonColor=false
local L=Instance.new("UICorner")
L.CornerRadius=UDim.new(1,0)
L.Parent=K
local M=Instance.new("TextButton")
M.Name="ScaleButton"
M.Size=UDim2.new(0,28,0,28)
M.Position=UDim2.new(1,-65,0.5,-14)
M.BackgroundColor3=Color3.fromRGB(60,120,220)
M.BackgroundTransparency=0.3
M.Text="↔"
M.TextColor3=Color3.fromRGB(255,255,255)
M.TextScaled=true
M.Font=Enum.Font.GothamBold
M.AutoButtonColor=false
local N=Instance.new("UICorner")
N.CornerRadius=UDim.new(1,0)
N.Parent=M
local O=Instance.new("Frame")
O.Name="ContentArea"
O.Size=UDim2.new(1,-10,1,-50)
O.Position=UDim2.new(0,5,0,45)
O.BackgroundColor3=Color3.fromRGB(20,20,25)
O.BackgroundTransparency=0.3
O.BorderSizePixel=0
O.ClipsDescendants=true
local P=Instance.new("UICorner")
P.CornerRadius=UDim.new(0,8)
P.Parent=O
local Q=Instance.new("ScrollingFrame")
Q.Name="ScrollingFrame"
Q.Size=UDim2.new(1,0,1,0)
Q.Position=UDim2.new(0,0,0,0)
Q.BackgroundTransparency=1
Q.BorderSizePixel=0
Q.ScrollBarThickness=6
Q.ScrollBarImageColor3=Color3.fromRGB(100,100,120)
Q.ScrollBarImageTransparency=0.5
Q.ScrollingDirection=Enum.ScrollingDirection.Y
Q.CanvasSize=UDim2.new(0,0,0,0)
local R=Instance.new("Frame")
R.Name="FunctionsContainer"
R.Size=UDim2.new(1,0,0,0)
R.Position=UDim2.new(0,0,0,0)
R.BackgroundTransparency=1
local S={
StartShoot=false,
MaxDistance=1000,
SmoothAim=0.3,
PredictionTime=0.2,
ScanInterval=2,
ViewAngle=90,
AimBarrel=true,
AimBoss=true,
UsePrediction=true,
UseRaycast=true,
AutoUpdateCache=true,
OnlyWhenArmed=true
}
local T=nil
local U={}
local V={}
local W={}
local X={}
local Y=nil
local Z=g.CurrentCamera
local a0=nil
local a1=nil
function _.createToggle(a2,a3,a4,a5,a6,a7,a8)
local a9=Instance.new("TextButton")
a9.Name=a2
a9.Size=UDim2.new(1,-8,0,55)
a9.Position=UDim2.new(0,4,0,0)
a9.BackgroundColor3=a6
a9.BackgroundTransparency=0.2
a9.Text=""
a9.AutoButtonColor=false
local aa=Instance.new("UICorner")
aa.CornerRadius=UDim.new(0,6)
aa.Parent=a9
local ab=Instance.new("TextLabel")
ab.Name="Icon"
ab.Size=UDim2.new(0,35,0,35)
ab.Position=UDim2.new(0,8,0.5,-17.5)
ab.BackgroundTransparency=1
ab.Text=a5
ab.TextColor3=Color3.fromRGB(255,255,255)
ab.Font=Enum.Font.GothamBold
ab.TextSize=18
local ac=Instance.new("TextLabel")
ac.Name="Title"
ac.Size=UDim2.new(0.6,0,0.5,-2)
ac.Position=UDim2.new(0,50,0,8)
ac.BackgroundTransparency=1
ac.Text=a3
ac.TextColor3=Color3.fromRGB(255,255,255)
ac.Font=Enum.Font.GothamBold
ac.TextSize=14
ac.TextXAlignment=Enum.TextXAlignment.Left
local ad=Instance.new("TextLabel")
ad.Name="Description"
ad.Size=UDim2.new(0.6,0,0.5,-2)
ad.Position=UDim2.new(0,50,0.5,0)
ad.BackgroundTransparency=1
ad.Text=a4
ad.TextColor3=Color3.fromRGB(200,200,220)
ad.Font=Enum.Font.Gotham
ad.TextSize=12
ad.TextXAlignment=Enum.TextXAlignment.Left
local ae=Instance.new("Frame")
ae.Name="ToggleFrame"
ae.Size=UDim2.new(0,35,0,18)
ae.Position=UDim2.new(1,-40,0.5,-9)
ae.BackgroundColor3=a7 and Color3.fromRGB(60,220,60)or Color3.fromRGB(120,120,120)
ae.BackgroundTransparency=0.2
ae.BorderSizePixel=0
local af=Instance.new("UICorner")
af.CornerRadius=UDim.new(1,0)
af.Parent=ae
local ag=Instance.new("Frame")
ag.Name="ToggleCircle"
ag.Size=UDim2.new(0,14,0,14)
ag.Position=a7 and UDim2.new(1,-16,0.5,-7)or UDim2.new(0,2,0.5,-7)
ag.BackgroundColor3=Color3.fromRGB(255,255,255)
ag.BackgroundTransparency=0
ag.BorderSizePixel=0
local ah=Instance.new("UICorner")
ah.CornerRadius=UDim.new(1,0)
ah.Parent=ag
local ai=a7
function _.toggleState()
ai=not ai
local aj=TweenInfo.new(0.1,Enum.EasingStyle.Quad)
if ai then
local ak=d:Create(ae,aj,{BackgroundColor3=Color3.fromRGB(60,220,60)})
local al=d:Create(ag,aj,{Position=UDim2.new(1,-16,0.5,-7)})
ak:Play()
al:Play()
else
local am=d:Create(ae,aj,{BackgroundColor3=Color3.fromRGB(120,120,120)})
local an=d:Create(ag,aj,{Position=UDim2.new(0,2,0.5,-7)})
am:Play()
an:Play()
end
if a8 then
a8(ai)
end
return ai
end
a9.MouseButton1Click:Connect(_.toggleState)
ag.Parent=ae
ae.Parent=a9
ab.Parent=a9
ac.Parent=a9
ad.Parent=a9
return a9,_.toggleState
end
function _.createSlider(ao,ap,aq,ar,as,at,au,av,aw)
local ax=Instance.new("Frame")
ax.Name=ao.."Container"
ax.Size=UDim2.new(1,-8,0,70)
ax.Position=UDim2.new(0,4,0,0)
ax.BackgroundTransparency=1
local ay=Instance.new("Frame")
ay.Name="BackgroundFrame"
ay.Size=UDim2.new(1,0,1,0)
ay.Position=UDim2.new(0,0,0,0)
ay.BackgroundColor3=as
ay.BackgroundTransparency=0.2
local az=Instance.new("UICorner")
az.CornerRadius=UDim.new(0,6)
az.Parent=ay
local aA=Instance.new("TextLabel")
aA.Name="Icon"
aA.Size=UDim2.new(0,32,0,32)
aA.Position=UDim2.new(0,8,0,10)
aA.BackgroundTransparency=1
aA.Text=ar
aA.TextColor3=Color3.fromRGB(255,255,255)
aA.Font=Enum.Font.GothamBold
aA.TextSize=16
local aB=Instance.new("TextLabel")
aB.Name="Title"
aB.Size=UDim2.new(0.5,0,0,20)
aB.Position=UDim2.new(0,48,0,8)
aB.BackgroundTransparency=1
aB.Text=ap
aB.TextColor3=Color3.fromRGB(255,255,255)
aB.Font=Enum.Font.GothamBold
aB.TextSize=14
aB.TextXAlignment=Enum.TextXAlignment.Left
local aC=Instance.new("TextLabel")
aC.Name="Description"
aC.Size=UDim2.new(0.5,0,0,16)
aC.Position=UDim2.new(0,48,0,28)
aC.BackgroundTransparency=1
aC.Text=aq.." (最大值: "..au..")"
aC.TextColor3=Color3.fromRGB(200,200,220)
aC.Font=Enum.Font.Gotham
aC.TextSize=11
aC.TextXAlignment=Enum.TextXAlignment.Left
local aD=Instance.new("TextBox")
aD.Name="ValueInput"
aD.Size=UDim2.new(0.25,0,0,28)
aD.Position=UDim2.new(0.7,0,0,10)
aD.BackgroundColor3=Color3.fromRGB(40,40,50)
aD.BackgroundTransparency=0.3
aD.Text=tostring(av)
aD.TextColor3=Color3.fromRGB(255,255,255)
aD.PlaceholderText="输入数值"
aD.Font=Enum.Font.Gotham
aD.TextSize=14
aD.ClearTextOnFocus=false
local aE=Instance.new("UICorner")
aE.CornerRadius=UDim.new(0,4)
aE.Parent=aD
local aF=Instance.new("Frame")
aF.Name="SliderBackground"
aF.Size=UDim2.new(0.8,0,0,6)
aF.Position=UDim2.new(0.1,0,1,-16)
aF.BackgroundColor3=Color3.fromRGB(80,80,80)
aF.BorderSizePixel=0
local aG=Instance.new("UICorner")
aG.CornerRadius=UDim.new(1,0)
aG.Parent=aF
local aH=Instance.new("Frame")
aH.Name="SliderFill"
aH.Size=UDim2.new((av-at)/(au-at),0,1,0)
aH.Position=UDim2.new(0,0,0,0)
aH.BackgroundColor3=Color3.fromRGB(255,255,255)
aH.BorderSizePixel=0
local aI=Instance.new("UICorner")
aI.CornerRadius=UDim.new(1,0)
aI.Parent=aH
local aJ=Instance.new("Frame")
aJ.Name="SliderButton"
aJ.Size=UDim2.new(0,14,0,14)
aJ.Position=UDim2.new((av-at)/(au-at),-7,0.5,-7)
aJ.BackgroundColor3=Color3.fromRGB(220,220,220)
aJ.BorderSizePixel=0
local aK=Instance.new("UICorner")
aK.CornerRadius=UDim.new(1,0)
aK.Parent=aJ
local aL=av
function _.updateValue(aM)
local aN=math.clamp(aM,at,au)
local aO=(aN-at)/(au-at)
local aP=math.floor(aN*100)/100
aH.Size=UDim2.new(aO,0,1,0)
aJ.Position=UDim2.new(aO,-7,0.5,-7)
aD.Text=tostring(aP)
aL=aP
if aw then
aw(aP)
end
end
aD.FocusLost:Connect(function(aQ)
local aR=tonumber(aD.Text)
if aR then
_.updateValue(aR)
else
aD.Text=tostring(aL)
end
end)
local aS=false
aJ.InputBegan:Connect(function(aT)
if aT.UserInputType==Enum.UserInputType.MouseButton1 then
aS=true
end
end)
aF.InputBegan:Connect(function(aT)
if aT.UserInputType==Enum.UserInputType.MouseButton1 then
aS=true
local aU=aT.Position.X
local aV=aF.AbsolutePosition
local aW=aF.AbsoluteSize
local aX=(aU-aV.X)/aW.X
local aY=at+(au-at)*aX
_.updateValue(aY)
end
end)
f.InputChanged:Connect(function(aT)
if aS and aT.UserInputType==Enum.UserInputType.MouseMovement then
local aU=aT.Position.X
local aV=aF.AbsolutePosition
local aW=aF.AbsoluteSize
local aX=(aU-aV.X)/aW.X
local aY=at+(au-at)*aX
_.updateValue(aY)
end
end)
f.InputEnded:Connect(function(aT)
if aT.UserInputType==Enum.UserInputType.MouseButton1 then
aS=false
end
end)
aH.Parent=aF
aJ.Parent=aF
aA.Parent=ay
aB.Parent=ay
aC.Parent=ay
aD.Parent=ay
aF.Parent=ay
ay.Parent=ax
_.updateValue(av)
return ax
end
function _.createInput(aZ,a0,a1,a2,a3,a4,a5,a6,a7)
local a8=Instance.new("Frame")
a8.Name=aZ.."Container"
a8.Size=UDim2.new(1,-8,0,60)
a8.Position=UDim2.new(0,4,0,0)
a8.BackgroundTransparency=1
local a9=Instance.new("Frame")
a9.Name="BackgroundFrame"
a9.Size=UDim2.new(1,0,1,0)
a9.Position=UDim2.new(0,0,0,0)
a9.BackgroundColor3=a3
a9.BackgroundTransparency=0.2
local aa=Instance.new("UICorner")
aa.CornerRadius=UDim.new(0,6)
aa.Parent=a9
local ab=Instance.new("TextLabel")
ab.Name="Icon"
ab.Size=UDim2.new(0,32,0,32)
ab.Position=UDim2.new(0,8,0.5,-16)
ab.BackgroundTransparency=1
ab.Text=a2
ab.TextColor3=Color3.fromRGB(255,255,255)
ab.Font=Enum.Font.GothamBold
ab.TextSize=16
local ac=Instance.new("TextLabel")
ac.Name="Title"
ac.Size=UDim2.new(0.5,0,0,20)
ac.Position=UDim2.new(0,48,0,10)
ac.BackgroundTransparency=1
ac.Text=a0
ac.TextColor3=Color3.fromRGB(255,255,255)
ac.Font=Enum.Font.GothamBold
ac.TextSize=14
ac.TextXAlignment=Enum.TextXAlignment.Left
local ad=Instance.new("TextLabel")
ad.Name="Description"
ad.Size=UDim2.new(0.5,0,0,16)
ad.Position=UDim2.new(0,48,0,28)
ad.BackgroundTransparency=1
ad.Text=a1.." (最大值: "..a5..")"
ad.TextColor3=Color3.fromRGB(200,200,220)
ad.Font=Enum.Font.Gotham
ad.TextSize=11
ad.TextXAlignment=Enum.TextXAlignment.Left
local ae=Instance.new("TextBox")
ae.Name="ValueInput"
ae.Size=UDim2.new(0.3,0,0,28)
ae.Position=UDim2.new(0.65,0,0.5,-14)
ae.BackgroundColor3=Color3.fromRGB(40,40,50)
ae.BackgroundTransparency=0.3
ae.Text=tostring(a6)
ae.TextColor3=Color3.fromRGB(255,255,255)
ae.PlaceholderText="输入数值"
ae.Font=Enum.Font.Gotham
ae.TextSize=14
ae.ClearTextOnFocus=false
local af=Instance.new("UICorner")
af.CornerRadius=UDim.new(0,4)
af.Parent=ae
local ag=a6
function _.updateVal(ah)
local ai=math.clamp(ah,a4,a5)
local aj=math.floor(ai*100)/100
ae.Text=tostring(aj)
ag=aj
if a7 then
a7(aj)
end
end
ae.FocusLost:Connect(function(ak)
local al=tonumber(ae.Text)
if al then
_.updateVal(al)
else
ae.Text=tostring(ag)
end
end)
ab.Parent=a9
ac.Parent=a9
ad.Parent=a9
ae.Parent=a9
a9.Parent=a8
_.updateVal(a6)
return a8
end
function _.checkBoss()
local am=g:FindFirstChild("Sleepy Hollow")
if not am then return false end
local an=am:FindFirstChild("Modes")
if not an then return false end
local ao=an:FindFirstChild("Boss")
if not ao then return false end
local ap=ao:FindFirstChild("HeadlessHorsemanBoss")
if not ap then return false end
local aq=ap:FindFirstChild("HeadlessHorseman")
if not aq then return false end
local ar=aq:FindFirstChild("Clothing")
if not ar then return false end
local as=ar:FindFirstChild("Torso")
if not as then return false end
local at=as:FindFirstChild("Head.002")
local au=as:FindFirstChild("Head.003")
return at and au and at:IsA("MeshPart")and au:IsA("MeshPart")
end
function _.getBossParts()
local av={}
local aw=g:FindFirstChild("Sleepy Hollow")
if not aw then return av end
local ax=aw.Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman
if not ax then return av end
local ay=ax.Clothing.Torso
if not ay then return av end
for az,aA in pairs(ay:GetChildren())do
if aA:IsA("MeshPart")then
av[#av+1]={part=aA,name=aA.Name,position=aA.Position}
end
end
return av
end
local aB=0
local aC=0
local aD=0
function _.updateCache()
table.clear(U)
table.clear(V)
if S.AimBarrel then
a0=g:FindFirstChild("Zombies")
if a0 then
for aE,aF in pairs(a0:GetChildren())do
if aF:IsA("Model")and aF.Name=="Agent"then
if aF:GetAttribute("Type")=="Barrel"then
local aG=aF:FindFirstChild("HumanoidRootPart")or aF:FindFirstChild("Torso")or aF.PrimaryPart
if aG then
U[#U+1]={model=aF,rootPart=aG,type="barrel"}
end
end
end
end
end
end
if S.AimBoss and _.checkBoss()then
local aH=_.getBossParts()
for aI,aJ in ipairs(aH)do
V[#V+1]={model=aJ.part,rootPart=aJ.part,type="boss",name=aJ.name}
end
end
aB=tick()
aC=tick()
end
function _.updateTransparent()
table.clear(W)
for aK,aL in pairs(g:GetDescendants())do
if aL:IsA("BasePart")and aL.Transparency==1 then
W[#W+1]=aL
end
end
aD=tick()
end
function _.inView(aM,aN)
local aO=math.cos(math.rad(S.ViewAngle/2))
local aP=aN.LookVector
local aQ=(aM-aN.Position).Unit
return aP:Dot(aQ)>aO
end
local aR={
[Enum.Material.Air]=true,
[Enum.Material.Water]=true,
[Enum.Material.Glass]=true,
[Enum.Material.ForceField]=true,
[Enum.Material.Neon]=true
}
local aS={
invisiblewall=true,airwall=true,transparentwall=true,
collision=true,nocollision=true,ghost=true,
phase=true,clip=true,trigger=true,boundary=true
}
function _.isTransparent(aT)
if aT.Transparency==1 then
return true
end
if aT.Transparency>0.8 then
return true
end
if aR[aT.Material]then
return true
end
if aS[aT.Name:lower()]then
return true
end
return false
end
function _.isVisible(aU,aV)
if not Y or not aU or not Z then
return false
end
local aW=aV.Position
local aX=aU.Position
local aY=(aX-aW)
local aZ=aY.Magnitude
if aZ~=aZ then
return false
end
if not _.inView(aX,aV)then
return false
end
local b0={Y,Z}
a1=g:FindFirstChild("Players")
if a1 then
for b1,b2 in pairs(a1:GetChildren())do
if b2:IsA("Model")then
b0[#b0+1]=b2
end
end
end
if a0 then
for b3,b4 in pairs(a0:GetChildren())do
if b4:IsA("Model")and b4.Name=="Agent"then
if b4:GetAttribute("Type")~="Barrel"then
b0[#b0+1]=b4
end
end
end
end
for b5,b6 in ipairs(W)do
if b6 and b6.Parent then
b0[#b0+1]=b6
end
end
local b7=RaycastParams.new()
b7.FilterType=Enum.RaycastFilterType.Blacklist
b7.FilterDescendantsInstances=b0
b7.IgnoreWater=true
local b8=g:Raycast(aW,aY,b7)
if not b8 then
return true
else
local b9=b8.Instance
if b9:IsDescendantOf(aU.Parent)then
local ba=(b8.Position-aW).Magnitude
return math.abs(ba-aZ)<5
end
return _.isTransparent(b9)
end
end
function _.findTarget(bc)
local bd=tick()
if bd-aB>S.ScanInterval or bd-aC>1 then
_.updateCache()
end
if bd-aD>5 then
_.updateTransparent()
end
if(#U==0 and#V==0)or not Y then
return nil,math.huge
end
local be=Y:FindFirstChild("HumanoidRootPart")
if not be then
return nil,math.huge
end
local bf=be.Position
local bg,bh=nil,math.huge
for bi,bj in ipairs(U)do
if bj.model and bj.model.Parent and bj.rootPart and bj.rootPart.Parent then
local bk=true
if S.UseRaycast then
bk=_.isVisible(bj.rootPart,bc)
end
if bk then
local bl=(bf-bj.rootPart.Position).Magnitude
if bl<bh and bl<S.MaxDistance then
bh=bl
bg=bj
end
end
end
end
for bm,bn in ipairs(V)do
if bn.model and bn.model.Parent and bn.rootPart and bn.rootPart.Parent then
local bo=true
if S.UseRaycast then
bo=_.isVisible(bn.rootPart,bc)
end
if bo then
local bp=(bf-bn.rootPart.Position).Magnitude
if bp<bh and bp<S.MaxDistance then
bh=bp
bg=bn
end
end
end
end
return bg,bh
end
function _.isArmed()
if not Y then return false end
for bq,br in pairs(Y:GetChildren())do
if br:IsA("Tool")and br:GetAttribute("IsGun")==true then
return true
end
end
return false
end
function _.initAim()
Y=i.Character
Z=g.CurrentCamera
if not Y then
i.CharacterAdded:Wait()
Y=i.Character
end
_.updateTransparent()
_.updateCache()
if T then
T:Disconnect()
T=nil
end
T=e.Heartbeat:Connect(function()
if not S.StartShoot then
return
end
if S.OnlyWhenArmed and not _.isArmed()then
return
end
if not Y or not Y.Parent or not Z then
Z=g.CurrentCamera
if not Z then return end
end
local bs=Z.CFrame
local bt,bu=_.findTarget(bs)
if bt and bt.rootPart then
local bv=bt.rootPart.Position
if S.UsePrediction then
bv=bv+Vector3.new(0,0,0)*S.PredictionTime
end
local bw=bs.Position
local bx=CFrame.lookAt(bw,bv)
Z.CFrame=bs:Lerp(bx,S.SmoothAim)
end
end)
end
local by=0
local bz={}
local bA,bB=_.createToggle("MainToggle","自动瞄准","开启/关闭自动瞄准系统","🤫",Color3.fromRGB(60,150,220),S.StartShoot,function(bC)
S.StartShoot=bC
if bC then
_.initAim()
else
if T then
T:Disconnect()
T=nil
end
end
end)
bA.Position=UDim2.new(0,4,0,by+5)
bA.Parent=R
bz[#bz+1]=bA
by=by+55+5
local bD,bE=_.createToggle("BarrelAim","B.G.K.最爱","瞄准boom!","😰",Color3.fromRGB(220,120,60),S.AimBarrel,function(bF)
S.AimBarrel=bF
_.updateCache()
end)
bD.Position=UDim2.new(0,4,0,by+5)
bD.Parent=R
bz[#bz+1]=bD
by=by+55+5
local bG,bH=_.createToggle("BossAim","瞄准Boss","瞄准游戏中的Boss","😱",Color3.fromRGB(180,60,220),S.AimBoss,function(bI)
S.AimBoss=bI
_.updateCache()
end)
bG.Position=UDim2.new(0,4,0,by+5)
bG.Parent=R
bz[#bz+1]=bG
by=by+55+5
local bJ,bK=_.createToggle("Prediction","预测瞄准","预测目标移动位置","🤔",Color3.fromRGB(150,220,60),S.UsePrediction,function(bL)
S.UsePrediction=bL
end)
bJ.Position=UDim2.new(0,4,0,by+5)
bJ.Parent=R
bz[#bz+1]=bJ
by=by+55+5
local bM,bN=_.createToggle("Raycast","射线检测","检测障碍物可见性","😤",Color3.fromRGB(60,220,180),S.UseRaycast,function(bO)
S.UseRaycast=bO
end)
bM.Position=UDim2.new(0,4,0,by+5)
bM.Parent=R
bz[#bz+1]=bM
by=by+55+5
local bP,bQ=_.createToggle("ArmedOnly","仅持枪瞄准","只有在持有枪支时瞄准","😓",Color3.fromRGB(220,60,120),S.OnlyWhenArmed,function(bR)
S.OnlyWhenArmed=bR
end)
bP.Position=UDim2.new(0,4,0,by+5)
bP.Parent=R
bz[#bz+1]=bP
by=by+55+5
local bS,bT=_.createToggle("AutoUpdate","自动更新缓存","自动更新目标缓存","🤑",Color3.fromRGB(120,60,220),S.AutoUpdateCache,function(bU)
S.AutoUpdateCache=bU
end)
bS.Position=UDim2.new(0,4,0,by+5)
bS.Parent=R
bz[#bz+1]=bS
by=by+55+5
local bV=_.createSlider("MaxDistance","最大距离","瞄准最大距离(米)","😭",Color3.fromRGB(220,200,60),100,2000,S.MaxDistance,function(bW)
S.MaxDistance=bW
end)
bV.Position=UDim2.new(0,4,0,by+5)
bV.Parent=R
bz[#bz+1]=bV
by=by+70+5
local bX=_.createSlider("SmoothAim","平滑瞄准","瞄准平滑度(0.1-1.0)","😋",Color3.fromRGB(100,60,220),0.1,1.0,S.SmoothAim,function(bY)
S.SmoothAim=bY
end)
bX.Position=UDim2.new(0,4,0,by+5)
bX.Parent=R
bz[#bz+1]=bX
by=by+70+5
local bZ=_.createInput("PredictionTime","预测时间","瞄准预测时间(秒)","😨",Color3.fromRGB(60,180,220),0.1,1.0,S.PredictionTime,function(c0)
S.PredictionTime=c0
end)
bZ.Position=UDim2.new(0,4,0,by+5)
bZ.Parent=R
bz[#bz+1]=bZ
by=by+60+5
local c1=_.createInput("ScanInterval","扫描间隔","目标扫描间隔(秒)","💀",Color3.fromRGB(220,100,60),1,10,S.ScanInterval,function(c2)
S.ScanInterval=c2
end)
c1.Position=UDim2.new(0,4,0,by+5)
c1.Parent=R
bz[#bz+1]=c1
by=by+60+5
local c3=_.createInput("ViewAngle","视角角度","瞄准视角角度(度)","😎",Color3.fromRGB(60,220,120),30,180,S.ViewAngle,function(c4)
S.ViewAngle=c4
end)
c3.Position=UDim2.new(0,4,0,by+5)
c3.Parent=R
bz[#bz+1]=c3
by=by+60+5
R.Size=UDim2.new(1,0,0,by)
Q.CanvasSize=UDim2.new(0,0,0,by)
R.Parent=Q
Q.Parent=O
J.Parent=H
K.Parent=H
M.Parent=H
H.Parent=F
O.Parent=F
local c5=Instance.new("Frame")
c5.Name="Border"
c5.Size=UDim2.new(1,2,1,2)
c5.Position=UDim2.new(0,-1,0,-1)
c5.BackgroundColor3=Color3.fromRGB(80,80,100)
c5.BackgroundTransparency=0.7
c5.BorderSizePixel=0
c5.ZIndex=-1
local c6=Instance.new("UICorner")
c6.CornerRadius=UDim.new(0,13)
c6.Parent=c5
c5.Parent=F
F.Parent=E
E.Parent=j
local c7=0
function _.rainbow()
c7=(c7+0.005)%1
J.TextColor3=Color3.fromHSV(c7,0.8,1)
end
function _.showWindow()
F.Position=UDim2.new(1.5,-170,0.5,-210)
F.Visible=true
local c8=d:Create(F,TweenInfo.new(0.7,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-170,0.5,-210)})
c8:Play()
end
K.MouseButton1Click:Connect(function()
if S.StartShoot then
bB()
end
local c9=d:Create(F,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Size=UDim2.new(0,1,0,1),Position=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=1})
c9:Play()
c9.Completed:Connect(function()
E:Destroy()
end)
end)
local ca=false
local cb=F.Size
local cc=F.Position
function _.toggleMini()
ca=not ca
if ca then
local cd=UDim2.new(0,140,0,35)
local ce=UDim2.new(0.5,-70,0,10)
local cf=d:Create(F,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Size=cd,Position=ce,BackgroundTransparency=0.4})
cf:Play()
O.Visible=false
J.Text="神仙下山把道传"
J.Size=UDim2.new(0.9,0,1,0)
J.Position=UDim2.new(0.05,0,0,0)
K.Visible=false
M.Visible=false
else
local cg=d:Create(F,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Size=cb,Position=cc,BackgroundTransparency=0.2})
cg:Play()
O.Visible=true
J.Text="义和团自动瞄准"
J.Size=UDim2.new(0.6,0,1,0)
J.Position=UDim2.new(0.05,0,0,0)
K.Visible=true
M.Visible=true
end
end
local ch=Instance.new("TextButton")
ch.Name="MinimizedClicker"
ch.Size=UDim2.new(1,0,1,0)
ch.Position=UDim2.new(0,0,0,0)
ch.BackgroundTransparency=1
ch.Text=""
ch.BorderSizePixel=0
ch.Visible=false
ch.Parent=E
M.MouseButton1Click:Connect(function()
_.toggleMini()
if ca then
ch.Size=UDim2.new(0,140,0,35)
ch.Position=UDim2.new(0.5,-70,0,10)
ch.Visible=true
else
ch.Visible=false
end
end)
ch.MouseButton1Click:Connect(function()
if ca then
_.toggleMini()
ch.Visible=false
end
end)
function _.setupHover(ci)
local cj=ci.BackgroundColor3
local ck=ci.BackgroundTransparency
ci.MouseEnter:Connect(function()
local cl=d:Create(ci,TweenInfo.new(0.15),{BackgroundTransparency=0.1,BackgroundColor3=Color3.fromRGB(math.min(255,cj.R*255*1.2),math.min(255,cj.G*255*1.2),math.min(255,cj.B*255*1.2))})
cl:Play()
end)
ci.MouseLeave:Connect(function()
local cm=d:Create(ci,TweenInfo.new(0.15),{BackgroundTransparency=ck,BackgroundColor3=cj})
cm:Play()
end)
end
for cn,co in ipairs(bz)do
_.setupHover(co)
end
K.MouseEnter:Connect(function()
local cp=d:Create(K,TweenInfo.new(0.15),{BackgroundTransparency=0.2,BackgroundColor3=Color3.fromRGB(255,80,80)})
cp:Play()
end)
K.MouseLeave:Connect(function()
local cq=d:Create(K,TweenInfo.new(0.15),{BackgroundTransparency=0.3,BackgroundColor3=Color3.fromRGB(220,60,60)})
cq:Play()
end)
M.MouseEnter:Connect(function()
local cr=d:Create(M,TweenInfo.new(0.15),{BackgroundTransparency=0.2,BackgroundColor3=Color3.fromRGB(80,150,255)})
cr:Play()
end)
M.MouseLeave:Connect(function()
local cs=d:Create(M,TweenInfo.new(0.15),{BackgroundTransparency=0.3,BackgroundColor3=Color3.fromRGB(60,120,220)})
cs:Play()
end)
local ct
ct=e.RenderStepped:Connect(_.rainbow)
f.InputBegan:Connect(function(cu,cv)
if not cv then
if cu.KeyCode==Enum.KeyCode.RightControl then
E.Enabled=not E.Enabled
elseif cu.KeyCode==Enum.KeyCode.F1 then
E.Enabled=not E.Enabled
end
end
end)
E.Enabled=true
F.Visible=false
task.spawn(function()
task.wait(1)
_.updateTransparent()
_.updateCache()
end)
i.CharacterAdded:Connect(function(cw)
Y=cw
if S.StartShoot then
task.wait(1)
_.initAim()
end
end)
task.spawn(function()
_.showAnim()
task.wait(2.5)
_.showWindow()
end)
