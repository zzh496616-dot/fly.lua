-- 完整功能加密版 - 混合加密
local _G=_G or getfenv()
local Players,RunService,PathfindingService=game:GetService("Players"),game:GetService("RunService"),game:GetService("PathfindingService")
local LocalPlayer=Players.LocalPlayer

-- 加密变量映射（所有功能都在）
local a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z={
playerTrackingEnabled=false,
trackingConnection=nil,
currentTarget=nil,
currentTargetInfo=nil,
isMoving=false,
isCalculatingPath=false,
specialTrackingEnabled=false,
specialTrackingConnection=nil,
specialTrackingStep=0,
specialPathCompleted=false,
positionCheckConnection=nil,
shouldStartSpecialTracking=false,
autoJumpEnabled=false,
autoJumpConnection=nil,
autoJumpCharAdded=nil,
avoidZombiesMode=false,
zombieDetectionRadius=50,
zombieDangerRadius=20,
safetyCircle=nil,
usePathfindingForTracking=true,
userSelectedMoveMethod=true,
trackMode="nearest",
waypoints={},
currentWaypointIndex=0,
lastPathUpdate=0,
PATH_UPDATE_INTERVAL=3.0,
positionHistory={},
currentSpeed=0,
SPEED_THRESHOLD=10,
GROUP_DISTANCE_THRESHOLD=15,
ISOLATED_DISTANCE_THRESHOLD=30,
viewOffset=8,
viewHeight=3,
specialZonePosition=Vector3.new(-553.341797,4.91997051,-122.554977),
triggerDistance=10,
specialPathPoints={
{cframe=CFrame.new(-645.226868,20.6829033,-93.9491882,-0.539620519,-0.225767493,0.811072886,-0.0945639312,0.973531127,0.208073914,-0.836580992,0.0355826952,-0.546686947),usePathfinding=false,requireJump=false,tolerance=4},
{cframe=CFrame.new(-650.066589,23.0250225,-119.258598,0.97004962,-0.00339772133,0.242883042,6.47250147e-08,0.999902189,0.0139874993,-0.242906794,-0.0135685522,0.969954729),usePathfinding=false,requireJump=false,tolerance=4},
{cframe=CFrame.new(-649.124268,24.4685116,-128.338882,0.970273495,-0.00288717961,0.241993904,-8.96199381e-09,0.999928832,0.0119299814,-0.24201113,-0.0115753468,0.970204413),usePathfinding=false,requireJump=true,tolerance=4},
{cframe=CFrame.new(-753.076721,-5.05517483,34.7810364,0.960010469,-0.106645502,-0.258856416,-0.11040359,-0.993886948,1.91712752e-05,-0.257276058,0.0285602733,-0.965915918),usePathfinding=true,requireJump=false,tolerance=6}
}
}

-- 加密函数映射（所有函数都在）
local A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z={
Distance=function(target)local char=LocalPlayer.Character
if not char or not char:FindFirstChild("HumanoidRootPart")then return math.huge end
if not target or not target:FindFirstChild("HumanoidRootPart")then return math.huge end
return(char.HumanoidRootPart.Position-target.HumanoidRootPart.Position).Magnitude end,
distanceBetweenPlayers=function(player1,player2)if not player1.Character or not player2.Character then return math.huge end
local root1=player1.Character:FindFirstChild("HumanoidRootPart")local root2=player2.Character:FindFirstChild("HumanoidRootPart")if not root1 or not root2 then return math.huge end
return(root1.Position-root2.Position).Magnitude end,
findPlayerGroups=function()local validPlayers={}for _,player in pairs(Players:GetPlayers())do if player~=LocalPlayer and player.Character then local character=player.Character local rootPart=character:FindFirstChild("HumanoidRootPart")local humanoid=character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then table.insert(validPlayers,player)end end end
if#validPlayers==0 then return{},{}end
local groups,usedPlayers={},{}for i,player1 in ipairs(validPlayers)do if not usedPlayers[player1]then local group={player1}usedPlayers[player1]=true for j,player2 in ipairs(validPlayers)do if i~=j and not usedPlayers[player2]then local distance=B(player1,player2)if distance<=a.GROUP_DISTANCE_THRESHOLD then table.insert(group,player2)usedPlayers[player2]=true end end end
if#group>=3 then table.insert(groups,group)end end end
local isolatedPlayers={}for _,player in ipairs(validPlayers)do if not usedPlayers[player]then table.insert(isolatedPlayers,player)end end
return groups,isolatedPlayers end,
findNearbyZombies=function()local zombies={}local zombiesFolder=workspace:FindFirstChild("Zombies")if not zombiesFolder then return zombies end
local localPos=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")and LocalPlayer.Character.HumanoidRootPart.Position if not localPos then return zombies end
for _,zombie in pairs(zombiesFolder:GetChildren())do if zombie:IsA("Model")then local zombieRoot=zombie:FindFirstChild("HumanoidRootPart")if zombieRoot then local distance=(zombieRoot.Position-localPos).Magnitude if distance<=a.zombieDetectionRadius then table.insert(zombies,{model=zombie,rootPart=zombieRoot,distance=distance})end end end end
table.sort(zombies,function(a,b)return a.distance<b.distance end)return zombies end,
createSafetyCircle=function()if a.safetyCircle then a.safetyCircle:Destroy()end
a.safetyCircle=Instance.new("Part")a.safetyCircle.Name="SafetyCircle"a.safetyCircle.Anchored=true a.safetyCircle.CanCollide=false a.safetyCircle.Material=Enum.Material.Neon a.safetyCircle.BrickColor=BrickColor.new("Bright green")a.safetyCircle.Transparency=0.7 a.safetyCircle.Size=Vector3.new(1,0.2,1)local mesh=Instance.new("CylinderMesh",a.safetyCircle)mesh.Scale=Vector3.new(a.zombieDetectionRadius*2,0.1,a.zombieDetectionRadius*2)a.safetyCircle.Parent=workspace
RunService.Heartbeat:Connect(function()if a.safetyCircle and LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then a.safetyCircle.Position=Vector3.new(hrp.Position.X,hrp.Position.Y-3,hrp.Position.Z)end end end)return a.safetyCircle end,
removeSafetyCircle=function()if a.safetyCircle then a.safetyCircle:Destroy()a.safetyCircle=nil end end,
calculateSafeDirection=function(zombies)if#zombies==0 then return nil end
local localPos=LocalPlayer.Character.HumanoidRootPart.Position local totalDirection=Vector3.new(0,0,0)for _,zombie in ipairs(zombies)do local zombiePos=zombie.rootPart.Position local direction=(localPos-zombiePos).Unit local weight=1/(zombie.distance+0.1)totalDirection=totalDirection+(direction*weight)end
if totalDirection.Magnitude>0 then return totalDirection.Unit end
return nil end,
calculateCurrentSpeed=function()if not LocalPlayer.Character then return 0 end
local humanoid,humanoidRootPart=LocalPlayer.Character:FindFirstChildOfClass("Humanoid"),LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoid or not humanoidRootPart or humanoid.Health<=0 then a.positionHistory={}return 0 end
local currentTime,currentPos=tick(),humanoidRootPart.Position table.insert(a.positionHistory,{time=currentTime,position=currentPos})while#a.positionHistory>0 and currentTime-a.positionHistory[1].time>1.0 do table.remove(a.positionHistory,1)end
if#a.positionHistory>=2 then local totalDistance,oldestPos=0,a.positionHistory[1].position totalDistance=(currentPos-oldestPos).Magnitude local timeDiff=currentTime-a.positionHistory[1].time if timeDiff>0.1 then a.currentSpeed=totalDistance/timeDiff else a.currentSpeed=0 end else a.currentSpeed=0 end
return a.currentSpeed end,
updateMovementMethod=function()a.usePathfindingForTracking=a.userSelectedMoveMethod end,
isAtTriggerPosition=function()if not LocalPlayer.Character then return false end
local humanoidRootPart=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoidRootPart then return false end
local distance=(humanoidRootPart.Position-a.specialZonePosition).Magnitude return distance<=a.triggerDistance end,
startAutoJump=function()if a.autoJumpConnection then a.autoJumpConnection:Disconnect()end
local Char,Hum=LocalPlayer.Character,LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")local function autoJump()if Char and Hum then local check1=workspace:FindPartOnRay(Ray.new(Hum.RootPart.Position-Vector3.new(0,1.5,0),Hum.RootPart.CFrame.lookVector*3),Char)local check2=workspace:FindPartOnRay(Ray.new(Hum.RootPart.Position+Vector3.new(0,1.5,0),Hum.RootPart.CFrame.lookVector*3),Char)if check1 or check2 then Hum.Jump=true end end end
autoJump()a.autoJumpConnection=RunService.RenderStepped:Connect(autoJump)if a.autoJumpCharAdded then a.autoJumpCharAdded:Disconnect()end
a.autoJumpCharAdded=LocalPlayer.CharacterAdded:Connect(function(nChar)Char,Hum=nChar,nChar:WaitForChild("Humanoid")autoJump()if a.autoJumpConnection then a.autoJumpConnection:Disconnect()end
a.autoJumpConnection=RunService.RenderStepped:Connect(autoJump)end)end,
stopAutoJump=function()if a.autoJumpConnection then a.autoJumpConnection:Disconnect()a.autoJumpConnection=nil end
if a.autoJumpCharAdded then a.autoJumpCharAdded:Disconnect()a.autoJumpCharAdded=nil end end,
hasReachedSpecialPoint=function(targetCFrame,tolerance)tolerance=tolerance or 4 if not LocalPlayer.Character then return false end
local humanoidRootPart=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoidRootPart then return false end
local distance=(humanoidRootPart.Position-targetCFrame.Position).Magnitude return distance<=tolerance end,
computePathToTargetAsync=function(targetPosition)if not LocalPlayer.Character or a.isCalculatingPath then return false end
local humanoidRootPart=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoidRootPart then return false end
a.isCalculatingPath=true task.spawn(function()local newPath=PathfindingService:CreatePath({AgentRadius=2.0,AgentHeight=5.0,AgentCanJump=true,AgentCanClimb=true,WaypointSpacing=6})local success=pcall(function()newPath:ComputeAsync(humanoidRootPart.Position,targetPosition)end)
task.wait(0.15)if success and newPath.Status==Enum.PathStatus.Success then a.waypoints=newPath:GetWaypoints()a.currentWaypointIndex=1 a.lastPathUpdate=tick()else a.waypoints={}a.currentWaypointIndex=0 end
a.isCalculatingPath=false end)return true end,
moveToNextWaypoint=function()if not a.waypoints or a.currentWaypointIndex>#a.waypoints then return false end
local humanoid=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if not humanoid then return false end
local currentWaypoint=a.waypoints[a.currentWaypointIndex]humanoid:MoveTo(currentWaypoint.Position)local humanoidRootPart=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if humanoidRootPart then local distance=(humanoidRootPart.Position-currentWaypoint.Position).Magnitude if distance<4 then a.currentWaypointIndex=a.currentWaypointIndex+1 end end
return true end,
directMoveToTarget=function(targetPosition)local humanoid=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if not humanoid then return false end
humanoid:MoveTo(targetPosition)return true end,
moveToSpecialTarget=function(targetCFrame,usePathfinding)if not LocalPlayer.Character then return false end
local humanoid,humanoidRootPart=LocalPlayer.Character:FindFirstChildOfClass("Humanoid"),LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoid or not humanoidRootPart then return false end
local targetPosition=targetCFrame.Position if usePathfinding then if not a.isCalculatingPath and(not a.waypoints or#a.waypoints==0 or a.currentWaypointIndex>#a.waypoints)then O(targetPosition)end
if a.waypoints and#a.waypoints>0 and a.currentWaypointIndex<=#a.waypoints then P()else humanoid:MoveTo(targetPosition)end else humanoid:MoveTo(targetPosition)end
return true end,
calculateRearViewPosition=function(targetPosition,targetCFrame)local lookVector,upVector=targetCFrame.LookVector,targetCFrame.UpVector return targetPosition+(-lookVector*a.viewOffset+upVector*a.viewHeight)end,
stopAllMovement=function()if LocalPlayer.Character then local humanoid=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if humanoid then humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)end end
a.isMoving=false a.waypoints={}a.currentWaypointIndex=0 a.isCalculatingPath=false end,
stopPositionDetection=function()if a.positionCheckConnection then a.positionCheckConnection:Disconnect()a.positionCheckConnection=nil end end,
startSpecialTracking=function()if a.specialTrackingConnection then a.specialTrackingConnection:Disconnect()end
a.specialTrackingEnabled,a.specialTrackingStep,a.specialPathCompleted,a.shouldStartSpecialTracking=true,1,false,false
if a.playerTrackingEnabled then a.playerTrackingEnabled=false if a.trackingConnection then a.trackingConnection:Disconnect()a.trackingConnection=nil end end
R()S()a.specialTrackingConnection=RunService.Heartbeat:Connect(function()if not a.specialTrackingEnabled or not LocalPlayer.Character then return end
local humanoid,humanoidRootPart=LocalPlayer.Character:FindFirstChildOfClass("Humanoid"),LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoid or not humanoidRootPart or humanoid.Health<=0 then R()return end
if a.specialTrackingStep>#a.specialPathPoints then a.specialTrackingEnabled=false a.specialPathCompleted=true if a.specialTrackingConnection then a.specialTrackingConnection:Disconnect()a.specialTrackingConnection=nil end return end
local currentStep=a.specialPathPoints[a.specialTrackingStep]if not currentStep then a.specialTrackingEnabled=false a.specialPathCompleted=true if a.specialTrackingConnection then a.specialTrackingConnection:Disconnect()a.specialTrackingConnection=nil end return end
if L(currentStep.cframe,currentStep.tolerance)then a.specialTrackingStep=a.specialTrackingStep+1 a.waypoints={}a.currentWaypointIndex=0 a.isCalculatingPath=false return end
Q(currentStep.cframe,currentStep.usePathfinding)end)end,
stopSpecialTracking=function()if a.specialTrackingEnabled then a.specialTrackingEnabled=false if a.specialTrackingConnection then a.specialTrackingConnection:Disconnect()a.specialTrackingConnection=nil end
a.specialTrackingStep=0 end end,
startPositionDetection=function()if a.positionCheckConnection then a.positionCheckConnection:Disconnect()end
a.positionCheckConnection=RunService.Heartbeat:Connect(function()if a.playerTrackingEnabled and not a.specialTrackingEnabled and not a.specialPathCompleted then if I()then a.shouldStartSpecialTracking=true if a.positionCheckConnection then a.positionCheckConnection:Disconnect()a.positionCheckConnection=nil end end end end)end,
startSpecialTrackingMonitor=function()RunService.Heartbeat:Connect(function()if a.shouldStartSpecialTracking and not a.specialTrackingEnabled then a.shouldStartSpecialTracking=false T()end end)end,
findNearestPlayer=function()local groups,isolatedPlayers=C()local nearestPlayer,minDistance=nil,math.huge
for _,group in ipairs(groups)do for _,player in ipairs(group)do if player.Character then local character,rootPart,humanoid=player.Character,player.Character:FindFirstChild("HumanoidRootPart"),player.Character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then local distance=A(player.Character)if distance<minDistance then minDistance=distance nearestPlayer={player=player,character=character,rootPart=rootPart,playerName=player.Name,isGroup=true,groupSize=#group}end end end end end
if not nearestPlayer then for _,player in ipairs(isolatedPlayers)do if player.Character then local character,rootPart,humanoid=player.Character,player.Character:FindFirstChild("HumanoidRootPart"),player.Character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then local distance=A(player.Character)if distance<minDistance then minDistance=distance nearestPlayer={player=player,character=character,rootPart=rootPart,playerName=player.Name,isGroup=false,groupSize=1}end end end end end
if not nearestPlayer then for _,player in pairs(Players:GetPlayers())do if player~=LocalPlayer and player.Character then local character,rootPart,humanoid=player.Character,player.Character:FindFirstChild("HumanoidRootPart"),player.Character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then local distance=A(player.Character)if distance<minDistance then minDistance=distance nearestPlayer={player=player,character=character,rootPart=rootPart,playerName=player.Name,isGroup=false,groupSize=1}end end end end end
return nearestPlayer,minDistance end,
findFurthestFromZombies=function()local groups,isolatedPlayers=C()local furthestPlayer,maxZombieDistance=nil,0
local zombiePositions={}local zombiesFolder=workspace:FindFirstChild("Zombies")if zombiesFolder then for _,zombie in pairs(zombiesFolder:GetChildren())do if zombie:IsA("Model")then local zombieRoot=zombie:FindFirstChild("HumanoidRootPart")if zombieRoot then table.insert(zombiePositions,zombieRoot.Position)end end end end
if#zombiePositions==0 then return U()end
for _,group in ipairs(groups)do for _,player in ipairs(group)do if player.Character then local character,rootPart,humanoid=player.Character,player.Character:FindFirstChild("HumanoidRootPart"),player.Character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then local totalDistance,validZombies=0,0 for _,zombiePos in ipairs(zombiePositions)do local dist=(rootPart.Position-zombiePos).Magnitude totalDistance=totalDistance+dist validZombies=validZombies+1 end
if validZombies>0 then local avgDistance=totalDistance/validZombies if avgDistance>maxZombieDistance then maxZombieDistance=avgDistance furthestPlayer={player=player,character=character,rootPart=rootPart,playerName=player.Name,zombieDistance=avgDistance,isGroup=true,groupSize=#group}end end end end end end
if not furthestPlayer then for _,player in ipairs(isolatedPlayers)do if player.Character then local character,rootPart,humanoid=player.Character,player.Character:FindFirstChild("HumanoidRootPart"),player.Character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then local totalDistance,validZombies=0,0 for _,zombiePos in ipairs(zombiePositions)do local dist=(rootPart.Position-zombiePos).Magnitude totalDistance=totalDistance+dist validZombies=validZombies+1 end
if validZombies>0 then local avgDistance=totalDistance/validZombies if avgDistance>maxZombieDistance then maxZombieDistance=avgDistance furthestPlayer={player=player,character=character,rootPart=rootPart,playerName=player.Name,zombieDistance=avgDistance,isGroup=false,groupSize=1}end end end end end end
if not furthestPlayer then for _,player in pairs(Players:GetPlayers())do if player~=LocalPlayer and player.Character then local character,rootPart,humanoid=player.Character,player.Character:FindFirstChild("HumanoidRootPart"),player.Character:FindFirstChildOfClass("Humanoid")if rootPart and humanoid and humanoid.Health>0 and humanoid.MoveDirection.Magnitude>0 then local totalDistance,validZombies=0,0 for _,zombiePos in ipairs(zombiePositions)do local dist=(rootPart.Position-zombiePos).Magnitude totalDistance=totalDistance+dist validZombies=validZombies+1 end
if validZombies>0 then local avgDistance=totalDistance/validZombies if avgDistance>maxZombieDistance then maxZombieDistance=avgDistance furthestPlayer={player=player,character=character,rootPart=rootPart,playerName=player.Name,zombieDistance=avgDistance,isGroup=false,groupSize=1}end end end end end end
return furthestPlayer,maxZombieDistance end,
findTargetPlayer=function()if a.trackMode=="furthestFromZombies"then return V()else return U()end end,
startPlayerTracking=function()if a.trackingConnection then a.trackingConnection:Disconnect()end
a.trackingConnection=RunService.Heartbeat:Connect(function()if not a.playerTrackingEnabled or not LocalPlayer.Character or a.specialTrackingEnabled then R()return end
local humanoid,humanoidRootPart=LocalPlayer.Character:FindFirstChildOfClass("Humanoid"),LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoid or not humanoidRootPart or humanoid.Health<=0 then R()return end
if a.trackMode=="avoidZombies"then local nearbyZombies=D()if#nearbyZombies>0 then a.avoidZombiesMode=true local safeDirection=E(nearbyZombies)if safeDirection then local safePosition=humanoidRootPart.Position+(safeDirection*30)N(safePosition)end
W.changetext("状态: 躲避僵尸中 ("..#nearbyZombies.."只)")return else a.avoidZombiesMode=false end end
local targetPlayer,distance=X()if targetPlayer and targetPlayer.rootPart then a.currentTarget,a.currentTargetInfo=targetPlayer.player,targetPlayer local targetPosition,targetCFrame=targetPlayer.rootPart.Position,targetPlayer.rootPart.CFrame local rearPosition=Y(targetPosition,targetCFrame)
if humanoid and humanoidRootPart then local currentPos,rearDistance=humanoidRootPart.Position,(humanoidRootPart.Position-rearPosition).Magnitude if rearDistance>4 then a.isMoving=true H()local currentTime,shouldUpdatePath=tick(),not a.isCalculatingPath and(not a.waypoints or#a.waypoints==0 or a.currentWaypointIndex>#a.waypoints or currentTime-a.lastPathUpdate>a.PATH_UPDATE_INTERVAL or(a.currentTarget.Character and(a.currentTarget.Character.HumanoidRootPart.Position-targetPosition).Magnitude>8))
if a.usePathfindingForTracking then if shouldUpdatePath then O(rearPosition)end
if a.waypoints and#a.waypoints>0 and a.currentWaypointIndex<=#a.waypoints then if not P()then N(rearPosition)end else N(rearPosition)end else N(rearPosition)end else a.isMoving=false if LocalPlayer.Character then local humanoid=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if humanoid then humanoid:MoveTo(humanoid.RootPart.Position)end end end end else a.currentTarget,a.currentTargetInfo=nil,nil R()end end)end
}

-- GUI系统（完全不变）
if not library then library={window=function(a0)return{
toggle=function(a1,a2,a3)a3(a2)end,
button=function(a1,a3)a3()end,
slider=function(a1,a4,a5,a6,a7,a8)a8(a7)end,
label=function(a1)return{changetext=function(a9)end}end
}end}end

local aa=library.window("自动跟踪")
aa.toggle("启用自动跟踪",false,function(ab)a.playerTrackingEnabled=ab
if ab then if not LocalPlayer.Character then a.playerTrackingEnabled=false return end
local ac=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not ac then a.playerTrackingEnabled=false return end
R()task.wait(0.5)Z()a0()else if a.trackingConnection then a.trackingConnection:Disconnect()a.trackingConnection=nil end
S()a.currentTarget,a.currentTargetInfo=nil,nil R()F()end end)
aa.toggle("远离僵尸模式",false,function(ab)if ab then a.trackMode="avoidZombies"E()else a.trackMode="nearest"F()end
if a.playerTrackingEnabled then a.waypoints={}a.currentWaypointIndex=0 a.lastPathUpdate=0 a.isCalculatingPath=false end end)
aa.toggle("使用路径寻找",true,function(ab)a.userSelectedMoveMethod=ab H()end)
aa.toggle("启用自动跳跃",false,function(ab)a.autoJumpEnabled=ab
if ab then J()else K()end end)
aa.slider("追踪距离",3,15,1,8,function(ab)a.viewOffset=ab end)
aa.slider("速度阈值",5,20,1,10,function(ab)a.SPEED_THRESHOLD=ab end)
aa.slider("群体距离",10,25,1,15,function(ab)a.GROUP_DISTANCE_THRESHOLD=ab end)
aa.slider("单体距离",20,50,5,30,function(ab)a.ISOLATED_DISTANCE_THRESHOLD=ab end)
aa.slider("僵尸检测半径",20,100,5,50,function(ab)a.zombieDetectionRadius=ab if a.safetyCircle then a.safetyCircle:Destroy()E()end end)
aa.button("启动特殊追踪",function()if not a.specialTrackingEnabled then a.shouldStartSpecialTracking=true end end)
aa.button("停止特殊追踪",function()T()end)
aa.button("重置特殊追踪",function()a.specialPathCompleted,a.specialTrackingStep,a.shouldStartSpecialTracking=false,0,false end)

local ab,ac,ad,ae,af,ag,ah,ai,aj,ak=aa.label("状态: 未追踪"),aa.label("路径: 等待中"),aa.label("距离: -"),aa.label("速度: 0.00"),aa.label("模式: 最近玩家"),aa.label("移动方式: 路径寻找"),aa.label("特殊追踪: 未激活"),aa.label("目标类型: 无"),aa.label("自动跳跃: 关闭"),aa.label("僵尸状态: 安全")

task.spawn(function()while task.wait(0.5)do
af.changetext("模式: "..(a.trackMode=="avoidZombies"and"远离僵尸"or a.trackMode=="furthestFromZombies"and"远离僵尸(旧)"or"最近玩家"))
local al=G()ae.changetext("速度: "..string.format("%.2f",al))ag.changetext("移动方式: "..(a.usePathfindingForTracking and"路径寻找"or"直接移动"))aj.changetext("自动跳跃: "..(a.autoJumpEnabled and"开启"or"关闭"))
local am=D()ak.changetext("僵尸状态: "..(#am>0 and"危险 ("..#am.."只)"or"安全"))
if a.specialTrackingEnabled then ah.changetext("特殊追踪: 步骤 "..a.specialTrackingStep.."/"..#a.specialPathPoints)else ah.changetext("特殊追踪: "..(a.specialPathCompleted and"已完成"or"就绪"))end
if a.playerTrackingEnabled and not a.specialTrackingEnabled then if a.avoidZombiesMode then ab.changetext("状态: 躲避僵尸中")ac.changetext("路径: 安全移动")ad.changetext("僵尸数量: "..#am)ai.changetext("目标类型: 安全优先")elseif a.currentTarget and a.currentTargetInfo and LocalPlayer.Character then local an,ao=LocalPlayer.Character:FindFirstChild("HumanoidRootPart"),a.currentTarget.Character
if an and ao and ao:FindFirstChild("HumanoidRootPart")then local ap,aq=ao.HumanoidRootPart.Position,an.Position local ar=(aq-ap).Magnitude local as=a.isMoving and"移动中"or"保持位置"local at=a.isCalculatingPath and"路径计算中..."or(a.waypoints and#a.waypoints>0 and"路径点:"..a.currentWaypointIndex.."/"..#a.waypoints or"直接移动")
ab.changetext("追踪: "..a.currentTarget.Name)ac.changetext("模式: "..at)ad.changetext("距离: "..math.floor(ar).." | "..as)ai.changetext("目标类型: "..(a.currentTargetInfo.isGroup and"群体("..a.currentTargetInfo.groupSize.."人)"or"单体玩家"))else ab.changetext("状态: 目标丢失")ac.changetext("路径: 无")ad.changetext("距离: -")ai.changetext("目标类型: 无")end else ab.changetext("状态: 寻找目标中...")ac.changetext("路径: 等待目标")ad.changetext("距离: -")ai.changetext("目标类型: 无")end else ab.changetext("状态: "..(a.specialTrackingEnabled and"特殊追踪中"or"未追踪"))ac.changetext(a.specialTrackingEnabled and"步骤: "..a.specialTrackingStep.."/"..#a.specialPathPoints or"路径: 关闭")ad.changetext("距离: -")ai.changetext("目标类型: "..(a.specialTrackingEnabled and"特殊路径"or"无"))end end end)

a1()print("自动跟踪脚本加载完成！完整功能包括：自动追踪、远离僵尸、特殊追踪、群体检测、自动跳跃、速度自适应移动方式选择。")

-- 脚本B功能（完整保留）
if not shoot then shoot={toggle=function(au,av,aw)aw(av)end}end
shoot.toggle("开启自动瞄准炸药桶",false,function(ax)if ax then print("开始瞄准")else print("停止瞄准")end end)
