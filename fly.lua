-- GB_Console_Obf_light.lua (light-obfuscated, runs in Roblox)
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local LocalPlayer=Players.LocalPlayer
local MODULE_RUNNING=true
local activeConns={}
local function _t(c) if c and type(c)=="RBXScriptConnection" then table.insert(activeConns,c) end return c end
local function _cAll() for _,v in ipairs(activeConns) do pcall(function() v:Disconnect() end) end activeConns={} end
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local screenGui=Instance.new("ScreenGui");screenGui.Name="CustomGBConsole";screenGui.ResetOnSpawn=false;screenGui.Parent=PlayerGui
local main=Instance.new("Frame");main.Name="Main";main.Size=UDim2.new(0,576,0,324);main.Position=UDim2.new(0.05,0,0.12,0);main.BackgroundColor3=Color3.fromRGB(200,203,216);main.BorderSizePixel=0;main.Parent=screenGui
Instance.new("UICorner",main).CornerRadius=UDim.new(0,26)
local inner=Instance.new("Frame");inner.Name="Inner";inner.Size=UDim2.new(0.72,0,0.78,0);inner.Position=UDim2.new(0.24,0,0.1,0);inner.BackgroundColor3=Color3.fromRGB(190,190,190);inner.BorderSizePixel=0;inner.Parent=main
Instance.new("UICorner",inner).CornerRadius=UDim.new(0,20)
local leftPanel=Instance.new("Frame");leftPanel.Name="LeftPanel";leftPanel.Size=UDim2.new(0.22,0,0.78,0);leftPanel.Position=UDim2.new(0.02,0,0.1,0);leftPanel.BackgroundTransparency=1;leftPanel.Parent=main
local title=Instance.new("TextLabel");title.Size=UDim2.new(0.7,-12,0,48);title.Position=UDim2.new(0.02,12,0.01,0);title.BackgroundTransparency=1;title.Text="拉脚本 - g&b - 纯缝合";title.Font=Enum.Font.SourceSansBold;title.TextSize=20;title.TextColor3=Color3.fromRGB(25,25,25);title.TextXAlignment=Enum.TextXAlignment.Left;title.Parent=main
local closeLabelFrame=Instance.new("Frame",main);closeLabelFrame.Size=UDim2.new(0,90,0,42);closeLabelFrame.Position=UDim2.new(1,-110,0.02,0);closeLabelFrame.BackgroundColor3=Color3.fromRGB(220,0,0);closeLabelFrame.BorderSizePixel=0;Instance.new("UICorner",closeLabelFrame).CornerRadius=UDim.new(0,12)
local closeLabel=Instance.new("TextLabel",closeLabelFrame);closeLabel.Size=UDim2.new(1,0,1,0);closeLabel.Text="关闭脚本- 91";closeLabel.BackgroundTransparency=1;closeLabel.Font=Enum.Font.GothamBold;closeLabel.TextColor3=Color3.fromRGB(10,10,10);closeLabel.TextSize=16
local function mkB(txt,y)
 local b=Instance.new("TextButton");b.Size=UDim2.new(0.9,0,0,64);b.Position=UDim2.new(0.05,0,y,0);b.BackgroundColor3=Color3.fromRGB(130,130,130);b.Text=txt;b.Font=Enum.Font.GothamBold;b.TextSize=18;b.TextColor3=Color3.fromRGB(20,20,20);b.Parent=leftPanel;Instance.new("UICorner",b).CornerRadius=UDim.new(0,18);return b
end
local infoBtn=mkB("信息介绍",0.03);local gbBtn=mkB("gb功能",0.22)
local collapseBtn=Instance.new("TextButton",main);collapseBtn.Size=UDim2.new(0,90,0,40);collapseBtn.Position=UDim2.new(0.55,0,0.02,0);collapseBtn.BackgroundColor3=Color3.fromRGB(235,160,165);collapseBtn.Text="收缩";collapseBtn.Font=Enum.Font.GothamBold;collapseBtn.TextSize=16;collapseBtn.TextColor3=Color3.fromRGB(30,30,30);Instance.new("UICorner",collapseBtn).CornerRadius=UDim.new(0,12)
local miniBtn=Instance.new("TextButton");miniBtn.Name="Mini";miniBtn.Size=UDim2.new(0,48,0,48);miniBtn.Position=UDim2.new(0,8,0.5,-24);miniBtn.BackgroundColor3=Color3.fromRGB(130,130,130);miniBtn.Visible=false;miniBtn.Parent=PlayerGui;Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,24)
local contentArea=Instance.new("Frame",inner);contentArea.Size=UDim2.new(1,-40,1,-40);contentArea.Position=UDim2.new(0,20,0,20);contentArea.BackgroundColor3=Color3.fromRGB(210,210,210);Instance.new("UICorner",contentArea).CornerRadius=UDim.new(0,14)
local pageInfo=Instance.new("Frame",contentArea);pageInfo.Size=UDim2.new(1,-20,1,-20);pageInfo.Position=UDim2.new(0.01,0,0.01,0);pageInfo.BackgroundTransparency=1
local infoLabel=Instance.new("TextLabel",pageInfo);infoLabel.Size=UDim2.new(1,-40,1,-40);infoLabel.Position=UDim2.new(0,20,0,20);infoLabel.BackgroundTransparency=1;infoLabel.Text="欢迎使用此脚本\n免费的\n纯缝合\n就这样了";infoLabel.Font=Enum.Font.Gotham;infoLabel.TextSize=18;infoLabel.TextColor3=Color3.fromRGB(20,20,20);infoLabel.TextWrapped=true;infoLabel.TextYAlignment=Enum.TextYAlignment.Top
local pageGB=Instance.new("Frame",contentArea);pageGB.Size=UDim2.new(1,-20,1,-20);pageGB.Position=UDim2.new(0.01,0,0.01,0);pageGB.BackgroundTransparency=1;pageGB.Visible=false
local function makeFeat(parent,txt,y)
 local r=Instance.new("Frame",parent);r.Size=UDim2.new(1,-40,0,64);r.Position=UDim2.new(0,20,0,y);r.BackgroundTransparency=1
 local lb=Instance.new("Frame",r);lb.Size=UDim2.new(0.85,0,1,0);lb.Position=UDim2.new(0,0,0,0);lb.BackgroundColor3=Color3.fromRGB(230,235,245);lb.BorderSizePixel=0;Instance.new("UICorner",lb).CornerRadius=UDim.new(0,12)
 local label=Instance.new("TextLabel",lb);label.Size=UDim2.new(1,-120,1,0);label.Position=UDim2.new(0,18,0,0);label.BackgroundTransparency=1;label.Text=txt;label.Font=Enum.Font.GothamBold;label.TextSize=18;label.TextColor3=Color3.fromRGB(25,25,25);label.TextXAlignment=Enum.TextXAlignment.Left
 local toggle=Instance.new("TextButton",lb);toggle.Size=UDim2.new(0,80,0,44);toggle.Position=UDim2.new(1,-94,0.5,-22);toggle.BackgroundColor3=Color3.fromRGB(120,120,120);toggle.Text="off";toggle.Font=Enum.Font.GothamItalic;toggle.TextSize=16;toggle.TextColor3=Color3.fromRGB(20,20,20);Instance.new("UICorner",toggle).CornerRadius=UDim.new(0,12)
 return {row=r,labelBg=lb,label=label,toggle=toggle}
end
local feat1=makeFeat(pageGB,"自动瞄准",24)
local feat2=makeFeat(pageGB,"跟踪队友",110)
do
 local dragging=false;local startPos;local dragStart
 main.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=inp.Position;startPos=main.Position;inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
 main.InputChanged:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseMovement and dragging and dragStart and startPos then local delta=inp.Position-dragStart; main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y) end end)
end
miniBtn.MouseButton1Click:Connect(function() main.Visible=true;miniBtn.Visible=false end)
infoBtn.MouseButton1Click:Connect(function() pageInfo.Visible=true;pageGB.Visible=false end)
gbBtn.MouseButton1Click:Connect(function() pageInfo.Visible=false;pageGB.Visible=true end)
collapseBtn.MouseButton1Click:Connect(function() main.Visible=false;miniBtn.Position=UDim2.new(0,8,0.5,-24);miniBtn.Visible=true end)
local aimbot={running=false,Stop=function() end}
local function startAimbot()
 if aimbot.running then return end
 aimbot.running=true
 local flags={StartShoot=true}
 local cameraLockConnection; local barrelCache={}; local bossCache={}; local lastScanTime=0; local lastBossScanTime=0; local lastTransparentUpdate=0; local transparentParts={}; local targetHistory={}; local PREDICTION_TIME=0.2; local MAX_HISTORY_SIZE=5; local MIN_VELOCITY_THRESHOLD=0.1; local MAX_VIEW_ANGLE=90; local COS_MAX_ANGLE=math.cos(math.rad(MAX_VIEW_ANGLE/2))
 local AIR_WALL_MATERIALS={[Enum.Material.Air]=true,[Enum.Material.Water]=true,[Enum.Material.Glass]=true,[Enum.Material.ForceField]=true,[Enum.Material.Neon]=true}
 local AIR_WALL_NAMES={invisiblewall=true,airwall=true,transparentwall=true,collision=true,nocollision=true,ghost=true,phase=true,clip=true,trigger=true,boundary=true}
 local function updateTargetHistory(target,currentPosition)
  if not targetHistory[target] then targetHistory[target]={positions={},timestamps={},velocity=Vector3.new(0,0,0),lastUpdate=tick()} end
  local hist=targetHistory[target];local ct=tick()
  table.insert(hist.positions,currentPosition);table.insert(hist.timestamps,ct)
  while #hist.positions>MAX_HISTORY_SIZE do table.remove(hist.positions,1);table.remove(hist.timestamps,1) end
  if #hist.positions>=2 then local latest=hist.positions[#hist.positions];local prev=hist.positions[1];local dt=hist.timestamps[#hist.timestamps]-hist.timestamps[1]; if dt>0 then local nv=(latest-prev)/dt; hist.velocity=hist.velocity:Lerp(nv,0.5); if hist.velocity.Magnitude<MIN_VELOCITY_THRESHOLD then hist.velocity=Vector3.new(0,0,0) end end end
  hist.lastUpdate=tick()
 end
 local function getPredictedPosition(target,currentPosition,predTime) local h=targetHistory[target] if not h or h.velocity.Magnitude<MIN_VELOCITY_THRESHOLD then return currentPosition end return currentPosition + h.velocity*predTime end
 local function cleanupOldTargetHistory() local now=tick(); local rem={} for t,h in pairs(targetHistory) do if now-h.lastUpdate>5 or (typeof(t)=="Instance" and not t.Parent) then table.insert(rem,t) end end for _,r in ipairs(rem) do targetHistory[r]=nil end end
 local function updateTargetCache()
  table.clear(barrelCache);table.clear(bossCache)
  local zf=workspace:FindFirstChild("Zombies")
  if zf then for _,v in ipairs(zf:GetChildren()) do if v:IsA("Model") and v.Name=="Agent" and v.GetAttribute and v:GetAttribute("Type")=="Barrel" then local rp=v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso") or v.PrimaryPart if rp then table.insert(barrelCache,{model=v,rootPart=rp,type="barrel"}); updateTargetHistory(v,rp.Position) end end end end
  local sleepy=workspace:FindFirstChild("Sleepy Hollow")
  if sleepy and sleepy:FindFirstChild("Modes") and sleepy.Modes:FindFirstChild("Boss") then local bossFolder=sleepy.Modes.Boss; local hh=bossFolder:FindFirstChild("HeadlessHorsemanBoss") if hh and hh:FindFirstChild("HeadlessHorseman") then local humano=hh.HeadlessHorseman local clothing=humano:FindFirstChild("Clothing") if clothing and clothing:FindFirstChild("Torso") then for _,child in ipairs(clothing.Torso:GetChildren()) do if child:IsA("MeshPart") then table.insert(bossCache,{model=child,rootPart=child,type="boss",name=child.Name}); updateTargetHistory(child,child.Position) end end end end end
  lastScanTime=tick(); lastBossScanTime=tick(); cleanupOldTargetHistory()
 end
 local function updateTransparentPartsCache() table.clear(transparentParts); for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Transparency>=0.999 then table.insert(transparentParts,v) end end lastTransparentUpdate=tick() end
 local function isWithinViewAngle(tp,camC) local cv=camC.LookVector; local to=(tp-camC.Position) if to.Magnitude==0 then return true end; local u=to.Unit; return cv:Dot(u)>COS_MAX_ANGLE end
 local function isTransparentOrAirWall(p) if not p then return false end if p.Transparency>=0.999 then return true end if p.Transparency>0.8 then return true end if AIR_WALL_MATERIALS[p.Material] then return true end if AIR_WALL_NAMES[p.Name:lower()] then return true end local c=p.BrickColor if (c==BrickColor.new("Really black") or c==BrickColor.new("Really white")) and p.Transparency>0.5 then return true end return false end
 local function isTargetVisible(tp,camC)
  if not tp or not camC then return false end
  local ro=camC.Position; local tpos=tp.Position; local dir=tpos-ro; local dist=dir.Magnitude if dist~=dist then return false end
  if not isWithinViewAngle(tpos,camC) then return false end
  local ign={workspace.CurrentCamera}
  local pf=workspace:FindFirstChild("Players")
  if pf then for _,pm in ipairs(pf:GetChildren()) do if pm:IsA("Model") then table.insert(ign,pm) end end end
  local zf=workspace:FindFirstChild("Zombies")
  if zf then for _,z in ipairs(zf:GetChildren()) do if z:IsA("Model") and z.Name=="Agent" and z.GetAttribute and z:GetAttribute("Type")~="Barrel" then table.insert(ign,z) end end end
  for _,p in ipairs(transparentParts) do if p and p.Parent then table.insert(ign,p) end end
  local rp=RaycastParams.new(); rp.FilterType=Enum.RaycastFilterType.Blacklist; rp.FilterDescendantsInstances=ign; rp.IgnoreWater=true
  local res=workspace:Raycast(ro,dir,rp)
  if not res then return true end
  local hit=res.Instance
  if hit and hit:IsDescendantOf(tp.Parent) then local hd=(res.Position-ro).Magnitude; return math.abs(hd-dist)<5 end
  return isTransparentOrAirWall(res.Instance)
 end
 local function findNearestVisibleTarget(camC)
  local now=tick()
  if now-lastScanTime>2 or now-lastBossScanTime>1 then updateTargetCache() end
  if now-lastTransparentUpdate>5 then updateTransparentPartsCache() end
  if #barrelCache==0 and #bossCache==0 then return nil,math.huge end
  local char=LocalPlayer.Character if not char then return nil,math.huge end
  local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return nil,math.huge end
  local playerPos=hrp.Position; local nearest=nil; local md=math.huge
  for i=1,#barrelCache do local t=barrelCache[i] if t.model and t.rootPart and t.rootPart.Parent then updateTargetHistory(t.model,t.rootPart.Position) if isTargetVisible(t.rootPart,camC) then local d=(playerPos-t.rootPart.Position).Magnitude if d<md and d<1000 then md=d; nearest=t end end end end
  for i=1,#bossCache do local t=bossCache[i] if t.model and t.rootPart and t.rootPart.Parent then updateTargetHistory(t.model,t.rootPart.Position) if isTargetVisible(t.rootPart,camC) then local d=(playerPos-t.rootPart.Position).Magnitude if d<md and d<1000 then md=d; nearest=t end end end end
  return nearest,md
 end
 updateTransparentPartsCache(); updateTargetCache()
 local char=LocalPlayer.Character
 local charConn=_t(LocalPlayer.CharacterAdded:Connect(function(nc) char=nc; task.wait(0.8); updateTransparentPartsCache(); updateTargetCache() end))
 local camConn=_t(RunService.Heartbeat:Connect(function()
  if not MODULE_RUNNING or not flags.StartShoot then if camConn then pcall(function() camConn:Disconnect() end) camConn=nil end return end
  if not char or not char.Parent then char=LocalPlayer.Character if not char then return end end
  local cam=workspace.CurrentCamera if not cam then return end
  local hasGun=false
  for _,ch in ipairs(char:GetChildren()) do if ch:IsA("Tool") and ch.GetAttribute and ch:GetAttribute("IsGun")==true then hasGun=true;break end end
  if not hasGun then return end
  local ccf=cam.CFrame
  local nt,d=findNearestVisibleTarget(ccf)
  if nt and nt.rootPart then local cur=nt.rootPart.Position; local pred=getPredictedPosition(nt.model,cur,PREDICTION_TIME); local cp=ccf.Position if pred and cp then local look=CFrame.lookAt(cp,pred) cam.CFrame=ccf:Lerp(look,0.3) end end
 end))
 table.insert(activeConns,camConn)
 aimbot.Stop=function() flags.StartShoot=false; pcall(function() if camConn then camConn:Disconnect(); camConn=nil end end); barrelCache={};bossCache={};targetHistory={}; aimbot.running=false end
end
local tracker={running=false,Stop=function() end}
local function startTracker()
 if tracker.running then return end
 tracker.running=true
 local playerTrackingEnabled=true
 local mainConn=_t(RunService.Heartbeat:Connect(function()
  if not playerTrackingEnabled or not MODULE_RUNNING then return end
  if not LocalPlayer.Character then return end
  local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end
  local target=nil; local md=math.huge
  for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local r=p.Character:FindFirstChild("HumanoidRootPart"); local hum=p.Character:FindFirstChildOfClass("Humanoid"); if r and hum and hum.Health>0 and hum.MoveDirection.Magnitude>0 then local d=(hrp.Position-r.Position).Magnitude if d<md then md=d; target=p end end end end
  if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local tp=target.Character.HumanoidRootPart; local rear=tp.Position - (tp.CFrame.LookVector * 8) + (tp.CFrame.UpVector * 3); if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):MoveTo(rear) end end
 end))
 tracker.Stop=function() playerTrackingEnabled=false; if mainConn then pcall(function() mainConn:Disconnect() end) end; tracker.running=false end
end
local function setOn(b) b.BackgroundColor3=Color3.fromRGB(24,160,100) b.Text="on" end
local function setOff(b) b.BackgroundColor3=Color3.fromRGB(120,120,120) b.Text="off" end
feat1.toggle.MouseButton1Click:Connect(function()
 if not aimbot.running then startAimbot(); setOn(feat1.toggle) else pcall(function() aimbot.Stop() end); setOff(feat1.toggle) end
end)
feat2.toggle.MouseButton1Click:Connect(function()
 if not tracker.running then startTracker(); setOn(feat2.toggle) else pcall(function() tracker.Stop() end); setOff(feat2.toggle) end
end)
local function fullShutdown()
 MODULE_RUNNING=false
 pcall(function() if aimbot and aimbot.Stop then aimbot.Stop() end end)
 pcall(function() if tracker and tracker.Stop then tracker.Stop() end end)
 _cAll()
 if screenGui and screenGui.Parent then screenGui:Destroy() end
 pcall(function() script:Destroy() end)
end
collapseBtn.MouseButton1Click:Connect(function() main.Visible=false; miniBtn.Position=UDim2.new(0,8,0.5,-24); miniBtn.Visible=true end)
closeLabelFrame.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then fullShutdown() end end)
UserInputService.InputBegan:Connect(function(inp,g) if g then return end if inp.KeyCode==Enum.KeyCode.F4 then if screenGui and screenGui.Parent then screenGui.Enabled=not screenGui.Enabled end end end)
pageInfo.Visible=true;pageGB.Visible=false
print("[GB Console] loaded")
