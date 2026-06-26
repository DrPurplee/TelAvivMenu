-- ╔══════════════════════════════════════════════════════╗
-- ║       Panel Wars Menu  —  [BETA]                     ║
-- ║         Migré vers Nexonix  by FocusOnTop  2026     ║
-- ╚══════════════════════════════════════════════════════╝

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DrPurplee/PurpleAimbot/refs/heads/main/wiw.lua"))()

-- ══════════════════════════════════════
--  MUSIQUE AU LANCEMENT
-- ══════════════════════════════════════
local bgMusic = Instance.new("Sound")
bgMusic.SoundId            = "rbxassetid://1845924914"
bgMusic.Volume             = 0.5
bgMusic.Looped             = true
bgMusic.RollOffMaxDistance = 0
bgMusic.Parent             = workspace
bgMusic:Play()

-- ══════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Lighting   = game:GetService("Lighting")
local LP         = Players.LocalPlayer

local function getChar() return LP.Character end
local function getHRP()  local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum()  local c = getChar() return c and c:FindFirstChildOfClass("Humanoid")  end
local function getCam()  return workspace.CurrentCamera end

-- ══════════════════════════════════════
--  NOTIF
-- ══════════════════════════════════════
local notifCooldowns = {}
local function notify(title, content, dur, cooldown)
    cooldown = cooldown or 0
    if cooldown > 0 then
        local key = title
        local now = tick()
        if notifCooldowns[key] and (now - notifCooldowns[key]) < cooldown then return end
        notifCooldowns[key] = now
    end
    Library:Notification((title or "") .. (content and (" — " .. content) or ""), dur or 3, Color3.fromRGB(78, 95, 255))
end

-- ══════════════════════════════════════
--  WINDOW
-- ══════════════════════════════════════
local Window = Library:Window({
    Logo = "rbxassetid://132873357116161",
})

Library.MenuKeybind = tostring(Enum.KeyCode.H)

-- ══════════════════════════════════════════════════════════════
--  SKIN LOCAL
-- ══════════════════════════════════════════════════════════════
local skinTargetId    = 8069446587
local skinTargetName  = "cutieinaria"
local skinAutoReapply = true

local function clearVisuals(char)
    for _, inst in ipairs(char:GetChildren()) do
        if inst:IsA("Accessory") or inst:IsA("Hat") or inst:IsA("Shirt")
        or inst:IsA("Pants") or inst:IsA("ShirtGraphic") or inst:IsA("CharacterMesh") then
            inst:Destroy()
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        for _, d in ipairs(head:GetChildren()) do
            if d:IsA("Decal") and d.Name:lower() == "face" then d:Destroy() end
        end
    end
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then bc:Destroy() end
end

local function attachAccessory(char, accessory)
    local handle = accessory:FindFirstChild("Handle")
    if not handle then return end
    local targetAttachment, accAttachment
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            for _, att in ipairs(part:GetChildren()) do
                if att:IsA("Attachment") then
                    local match = handle:FindFirstChild(att.Name)
                    if match and match:IsA("Attachment") then
                        targetAttachment = att; accAttachment = match; break
                    end
                end
            end
        end
        if targetAttachment then break end
    end
    if targetAttachment and accAttachment then
        handle.CFrame = targetAttachment.WorldCFrame * accAttachment.CFrame:Inverse()
    else
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then handle.CFrame = root.CFrame end
    end
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = (targetAttachment and targetAttachment.Parent) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    weld.Parent = handle
    accessory.Parent = char
end

local function applySkinById(id, char)
    if not id or not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local desc = nil
    pcall(function() desc = Players:GetHumanoidDescriptionFromUserId(id) end)
    if desc then
        pcall(function() sethiddenproperty(hum, "RigType", Enum.HumanoidRigType.R15) end)
        pcall(function() hum:ApplyDescription(desc) end)
        task.wait(0.15)
        pcall(function() hum:ApplyDescription(desc) end)
    end
    local ok, model = pcall(function() return Players:GetCharacterAppearanceAsync(id) end)
    if ok and model then
        clearVisuals(char); task.wait(0.05)
        local bc = model:FindFirstChildOfClass("BodyColors")
        if bc then pcall(function() bc:Clone().Parent = char end) end
        for _, item in ipairs(model:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
                pcall(function() item:Clone().Parent = char end)
            end
        end
        for _, acc in ipairs(model:GetChildren()) do
            if acc:IsA("Accessory") or acc:IsA("Hat") then
                pcall(function() attachAccessory(char, acc:Clone()) end)
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            local face = model:FindFirstChild("face", true)
            if face and face:IsA("Decal") then
                pcall(function() face:Clone().Parent = head end)
            end
        end
    end
    if desc then
        pcall(function()
            hum.BodyDepthScale.Value      = desc.DepthScale
            hum.BodyHeightScale.Value     = desc.HeightScale
            hum.BodyWidthScale.Value      = desc.WidthScale
            hum.HeadScale.Value           = desc.HeadScale
            hum.BodyProportionScale.Value = desc.ProportionScale
        end)
    end
    return true
end

task.spawn(function()
    local char = LP.Character or LP.CharacterAdded:Wait()
    task.wait(1.5)
    pcall(function() sethiddenproperty(LP, "CharacterAppearanceId", skinTargetId) end)
    if applySkinById(skinTargetId, char) then
        notify("Skin", "Skin de "..skinTargetName.." appliqué !", 3)
    else
        notify("Skin", "Échec — retry...", 3)
        task.wait(2)
        local char2 = LP.Character
        if char2 then applySkinById(skinTargetId, char2) end
    end
end)
LP.CharacterAdded:Connect(function(char)
    if skinAutoReapply then
        task.wait(1.5)
        pcall(function() sethiddenproperty(LP, "CharacterAppearanceId", skinTargetId) end)
        applySkinById(skinTargetId, char)
    end
end)

-- ══════════════════════════════════════
--  FLY
-- ══════════════════════════════════════
local FLYING = false; local flySpeed = 80; local realWalkSpeed = 16
local flyKeyDown = nil; local flyKeyUp = nil
local CTRL = {F=0,B=0,L=0,R=0,U=0,D=0}

local function NOFLY()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect(); flyKeyDown = nil end
    if flyKeyUp   then flyKeyUp:Disconnect();   flyKeyUp   = nil end
    local hum = getHum()
    if hum then hum.PlatformStand = false; hum.WalkSpeed = realWalkSpeed end
    local char = getChar()
    if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
    notify("Fly", "OFF", 2)
end

local function sFLY()
    if FLYING then NOFLY() end
    local hrp = getHRP(); if not hrp then notify("Fly", "Personnage introuvable !", 2) return end
    FLYING = true; CTRL = {F=0,B=0,L=0,R=0,U=0,D=0}
    local BG = Instance.new("BodyGyro"); BG.P = 9e4; BG.MaxTorque = Vector3.new(9e9,9e9,9e9); BG.CFrame = hrp.CFrame; BG.Parent = hrp
    local BV = Instance.new("BodyVelocity"); BV.Velocity = Vector3.zero; BV.MaxForce = Vector3.new(9e9,9e9,9e9); BV.Parent = hrp
    task.spawn(function()
        repeat task.wait()
            local cam = workspace.CurrentCamera; local hum = getHum()
            if hum then hum.PlatformStand = true; if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end end
            local char = getChar()
            if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
            local dir = Vector3.zero
            if CTRL.F ~= 0 then dir += cam.CFrame.LookVector  end; if CTRL.B ~= 0 then dir -= cam.CFrame.LookVector  end
            if CTRL.L ~= 0 then dir -= cam.CFrame.RightVector end; if CTRL.R ~= 0 then dir += cam.CFrame.RightVector end
            if CTRL.U ~= 0 then dir += Vector3.new(0,1,0) end;     if CTRL.D ~= 0 then dir -= Vector3.new(0,1,0) end
            BV.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero; BG.CFrame = cam.CFrame
        until not FLYING
        CTRL = {F=0,B=0,L=0,R=0,U=0,D=0}
        pcall(function() BG:Destroy() end); pcall(function() BV:Destroy() end)
        local hum2 = getHum(); if hum2 then hum2.PlatformStand = false; hum2.WalkSpeed = realWalkSpeed end
    end)
    flyKeyDown = UIS.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode==Enum.KeyCode.W then CTRL.F=1 elseif i.KeyCode==Enum.KeyCode.S then CTRL.B=1
        elseif i.KeyCode==Enum.KeyCode.A then CTRL.L=1 elseif i.KeyCode==Enum.KeyCode.D then CTRL.R=1
        elseif i.KeyCode==Enum.KeyCode.E then CTRL.U=1 elseif i.KeyCode==Enum.KeyCode.Q then CTRL.D=1 end
    end)
    flyKeyUp = UIS.InputEnded:Connect(function(i,g)
        if g then return end
        if i.KeyCode==Enum.KeyCode.W then CTRL.F=0 elseif i.KeyCode==Enum.KeyCode.S then CTRL.B=0
        elseif i.KeyCode==Enum.KeyCode.A then CTRL.L=0 elseif i.KeyCode==Enum.KeyCode.D then CTRL.R=0
        elseif i.KeyCode==Enum.KeyCode.E then CTRL.U=0 elseif i.KeyCode==Enum.KeyCode.Q then CTRL.D=0 end
    end)
    notify("Fly", "ON — WASD | E monter | Q descendre | Vitesse : "..flySpeed, 3)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then if FLYING then NOFLY() else sFLY() end end
end)
LP.CharacterAdded:Connect(function() NOFLY() end)

-- ══════════════════════════════════════
--  PUSH / FLING
-- ══════════════════════════════════════
local function safeGetPing()
    local ok, v = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()/1000 end)
    return ok and v or 0.05
end
local function getTargetRoot(plr) if plr and plr.Character then return plr.Character:FindFirstChild("HumanoidRootPart") end end
local function predTP(plr)
    local root = getTargetRoot(plr); local myRoot = getHRP()
    if not root or not myRoot then return end
    myRoot.CFrame = CFrame.new(root.Position + (root.Velocity or Vector3.zero) * safeGetPing() * 3.5 + Vector3.new(0,2,0))
end
local function findPushTool()
    for _, container in ipairs({ LP.Backpack, getChar() or {} }) do
        for _, v in pairs(container:GetChildren()) do if v:IsA("Tool") and v.Name:lower():find("push") then return v end end
    end
end
local function doServerPush(plr)
    pcall(function()
        local tool = findPushTool(); if not tool or not plr.Character then return end
        tool.Parent = getChar(); pcall(function() tool.PushTool:FireServer(plr.Character) end)
        task.wait(0.1); tool.Parent = LP.Backpack
    end)
end
local function doPowerPush(plr)
    pcall(function()
        if not plr.Character then return end
        local targetRoot = getTargetRoot(plr); local myRoot = getHRP()
        if not targetRoot or not myRoot then return end
        local pushDir = (targetRoot.Position - myRoot.Position)
        if pushDir.Magnitude < 0.1 then pushDir = Vector3.new(0,1,0) end
        pushDir = pushDir.Unit
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Velocity = pushDir * 400 + Vector3.new(0,150,0); bv.Parent = targetRoot
        game:GetService("Debris"):AddItem(bv, 0.2)
        task.spawn(function()
            task.wait(0.05)
            pcall(function() targetRoot.Velocity = pushDir * 600 + Vector3.new(math.random(-100,100), 200, math.random(-100,100)) end)
        end)
    end)
end
local function doPush(plr) predTP(plr); task.wait(safeGetPing() + 0.03); doServerPush(plr); doPowerPush(plr) end

-- ══════════════════════════════════════
--  TOUCH FLING
-- ══════════════════════════════════════
local touchFlingActive = false
local voidProtEnabled  = false

local function setVoidProtection(bool)
    if bool then workspace.FallenPartsDestroyHeight = 0/0 else workspace.FallenPartsDestroyHeight = -500 end
end

local function startTouchFling()
    if touchFlingActive then return end
    touchFlingActive = true
    setVoidProtection(true)
    task.spawn(function()
        while touchFlingActive do
            if not FLYING then
                pcall(function()
                    local myRoot = getHRP()
                    if myRoot then
                        local RV = myRoot.Velocity
                        myRoot.Velocity = Vector3.new(math.random(-150,150), -25000, math.random(-150,150))
                        RunService.RenderStepped:Wait()
                        myRoot.Velocity = RV
                    end
                end)
            end
            RunService.Heartbeat:Wait()
        end
        if not voidProtEnabled then setVoidProtection(false) end
    end)
end

local function stopTouchFling()
    touchFlingActive = false
    if not voidProtEnabled then setVoidProtection(false) end
end

-- ══════════════════════════════════════
--  AIMBOT
-- ══════════════════════════════════════
local aimbotEnabled = false; local aimbotSmoothing = 0.3
local aimbotPart = "Head"; local aimbotFOV = 300; local aimbotConn = nil

local function getClosestTarget()
    local cam = getCam(); local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local best, bestD = nil, aimbotFOV
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local part = plr.Character:FindFirstChild(aimbotPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
            if part and hum and hum.Health > 0 then
                local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X,sp.Y) - center).Magnitude
                    if d < bestD then bestD = d; best = plr end
                end
            end
        end
    end
    return best
end

local function runAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn = nil end
    aimbotConn = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        local target = getClosestTarget(); if not target or not target.Character then return end
        local part = target.Character:FindFirstChild(aimbotPart) or target.Character:FindFirstChild("HumanoidRootPart")
        if not part then return end
        local cam = getCam(); local tCF = CFrame.new(cam.CFrame.Position, part.Position)
        cam.CFrame = aimbotSmoothing <= 0.01 and tCF or cam.CFrame:Lerp(tCF, 1 - aimbotSmoothing)
    end)
end
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then aimbotEnabled = not aimbotEnabled; notify("Aimbot", aimbotEnabled and "ON" or "OFF", 2) end
end)
runAimbot()

-- ══════════════════════════════════════════════════════════════
--  ESP / TRACKALL
-- ══════════════════════════════════════════════════════════════
local espOptions = { skeleton = true, box = true, health = true, name = true, distance = true }
local espMaxDistance  = 1000
local trackOn         = false
local STAFFDetectOn   = false
local playerSnapshots = {}
local espObjects      = {}

local SKELETON_BONES = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
    {"LowerTorso","RightUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"RightUpperLeg","RightLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
    {"UpperTorso","RightUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"RightUpperArm","RightLowerArm"},
    {"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},
}

local function newLine()
    local l = Drawing.new("Line"); l.Visible=false; l.Color=Color3.fromRGB(255,255,255)
    l.Thickness=1.5; l.Transparency=1; l.ZIndex=5; return l
end
local function newBox()
    local b = Drawing.new("Square"); b.Visible=false; b.Color=Color3.fromRGB(255,255,255)
    b.Thickness=1.5; b.Filled=false; b.Transparency=1; b.ZIndex=4; return b
end

local function isSuspectedSTAFF(plr)
    if not plr.Character then return false end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    local snap = playerSnapshots[plr.Name]
    if not snap then
        playerSnapshots[plr.Name] = {lastPos=hrp.Position,lastHP=hum.Health,highSpeedFrames=0,godmodFrames=0,totalFrames=0}
        return false
    end
    snap.totalFrames += 1
    local dist = (hrp.Position - snap.lastPos).Magnitude
    if dist > 80 then snap.highSpeedFrames += 1 else snap.highSpeedFrames = math.max(0, snap.highSpeedFrames - 1) end
    local isSTAFF = snap.highSpeedFrames >= 5
    if snap.lastHP < hum.MaxHealth * 0.5 and hum.Health == hum.MaxHealth then snap.godmodFrames += 1 else snap.godmodFrames = math.max(0, snap.godmodFrames - 0.5) end
    if snap.godmodFrames >= 3 then isSTAFF = true end
    snap.lastPos = hrp.Position; snap.lastHP = hum.Health
    return isSTAFF
end

local function cleanESP(plr)
    local obj = espObjects[plr.Name]; if not obj then return end
    -- Marquer comme nettoyé AVANT de tout détruire pour éviter les double-calls dans RenderStepped
    espObjects[plr.Name] = nil
    if obj.conns then for _, c in pairs(obj.conns) do pcall(function() c:Disconnect() end) end end
    if obj.highlight then pcall(function() obj.highlight:Destroy() end) end
    if obj.billboard then pcall(function() obj.billboard:Destroy() end) end
    if obj.skeletonLines then
        for _, l in pairs(obj.skeletonLines) do
            pcall(function() l.Visible = false; l:Remove() end)
        end
    end
    if obj.boxDrawing then pcall(function() obj.boxDrawing.Visible = false; obj.boxDrawing:Remove() end) end
end

local function setupESP(plr, char)
    cleanESP(plr); task.wait(0.5)
    if not char or not char.Parent then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then task.wait(1); hrp = char:FindFirstChild("HumanoidRootPart"); hum = char:FindFirstChildOfClass("Humanoid") end
    if not hrp or not hum then return end

    local obj = { conns={}, skeletonLines={}, boxDrawing=nil, highlight=nil, billboard=nil }

    local hl = Instance.new("Highlight")
    hl.FillColor=Color3.fromRGB(255,255,255); hl.OutlineColor=Color3.fromRGB(255,255,255)
    hl.FillTransparency=0.85; hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
    obj.highlight=hl

    local bb = Instance.new("BillboardGui")
    bb.Adornee=hrp; bb.Size=UDim2.new(0,200,0,60); bb.StudsOffset=Vector3.new(0,3.2,0)
    bb.AlwaysOnTop=true; bb.Parent=hrp; obj.billboard=bb

    local bg = Instance.new("Frame"); bg.Size=UDim2.new(1,0,1,0); bg.BackgroundTransparency=1; bg.BorderSizePixel=0; bg.Parent=bb

    local lName = Instance.new("TextLabel"); lName.Size=UDim2.new(1,0,0,22); lName.Position=UDim2.new(0,0,0,0)
    lName.BackgroundTransparency=1; lName.Text=plr.Name; lName.TextColor3=Color3.fromRGB(255,255,255)
    lName.TextStrokeColor3=Color3.fromRGB(0,0,0); lName.TextStrokeTransparency=0
    lName.TextScaled=false; lName.TextSize=14; lName.Font=Enum.Font.GothamBold
    lName.TextXAlignment=Enum.TextXAlignment.Center; lName.Visible=espOptions.name; lName.Parent=bg

    local hpBg = Instance.new("Frame"); hpBg.Size=UDim2.new(0.85,0,0,5); hpBg.Position=UDim2.new(0.075,0,0,26)
    hpBg.BackgroundColor3=Color3.fromRGB(40,40,40); hpBg.BackgroundTransparency=0.2; hpBg.BorderSizePixel=0
    hpBg.Visible=espOptions.health; hpBg.Parent=bg; Instance.new("UICorner",hpBg).CornerRadius=UDim.new(1,0)

    local hpBar = Instance.new("Frame"); hpBar.Size=UDim2.new(1,0,1,0); hpBar.BackgroundColor3=Color3.fromRGB(50,220,80)
    hpBar.BorderSizePixel=0; hpBar.Parent=hpBg; Instance.new("UICorner",hpBar).CornerRadius=UDim.new(1,0)

    local lHP = Instance.new("TextLabel"); lHP.Size=UDim2.new(1,0,0,14); lHP.Position=UDim2.new(0,0,0,33)
    lHP.BackgroundTransparency=1; lHP.Text=math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
    lHP.TextColor3=Color3.fromRGB(255,255,255); lHP.TextStrokeColor3=Color3.fromRGB(0,0,0)
    lHP.TextStrokeTransparency=0; lHP.TextScaled=false; lHP.TextSize=11; lHP.Font=Enum.Font.Gotham
    lHP.TextXAlignment=Enum.TextXAlignment.Center; lHP.Visible=espOptions.health; lHP.Parent=bg

    local lDist = Instance.new("TextLabel"); lDist.Size=UDim2.new(1,0,0,14); lDist.Position=UDim2.new(0,0,0,47)
    lDist.BackgroundTransparency=1; lDist.Text="0m"; lDist.TextColor3=Color3.fromRGB(255,255,255)
    lDist.TextStrokeColor3=Color3.fromRGB(0,0,0); lDist.TextStrokeTransparency=0; lDist.TextScaled=false
    lDist.TextSize=11; lDist.Font=Enum.Font.Gotham; lDist.TextXAlignment=Enum.TextXAlignment.Center
    lDist.Visible=espOptions.distance; lDist.Parent=bg

    for _, bone in ipairs(SKELETON_BONES) do table.insert(obj.skeletonLines, newLine()) end
    local boxD = newBox(); obj.boxDrawing = boxD

    -- Fix mort : cacher les drawings immédiatement puis nettoyer
    table.insert(obj.conns, hum.Died:Connect(function()
        for _, l in pairs(obj.skeletonLines) do pcall(function() l.Visible = false end) end
        if obj.boxDrawing then pcall(function() obj.boxDrawing.Visible = false end) end
        task.wait(0.05)
        cleanESP(plr)
    end))

    -- Fix déco : si le character quitte workspace
    table.insert(obj.conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            for _, l in pairs(obj.skeletonLines) do pcall(function() l.Visible = false end) end
            if obj.boxDrawing then pcall(function() obj.boxDrawing.Visible = false end) end
            cleanESP(plr)
        end
    end))

    table.insert(obj.conns, hum.HealthChanged:Connect(function(hp)
        if not hpBar or not hpBar.Parent then return end
        local ratio = math.clamp(hp / hum.MaxHealth, 0, 1)
        hpBar.Size = UDim2.new(ratio, 0, 1, 0)
        -- Vert pur pour les PV, on garde blanc pour le reste
        hpBar.BackgroundColor3 = Color3.fromRGB(math.floor((1-ratio)*80), math.floor(50 + ratio*170), math.floor(ratio*80))
        lHP.Text = math.floor(hp).."/"..math.floor(hum.MaxHealth)
    end))

    local frameCount = 0
    table.insert(obj.conns, RunService.RenderStepped:Connect(function()
        -- Nettoyage si char ou HRP disparu (mort/déco/reset)
        if not char or not char.Parent or not hrp or not hrp.Parent then
            for _, l in pairs(obj.skeletonLines) do pcall(function() l.Visible = false end) end
            if obj.boxDrawing then pcall(function() obj.boxDrawing.Visible = false end) end
            cleanESP(plr)
            return
        end
        local myRoot = getHRP(); local cam = getCam()
        local dist = 0
        if myRoot then dist = math.floor((hrp.Position - myRoot.Position).Magnitude) end
        local tooFar = dist > espMaxDistance
        if bb and bb.Parent then bb.Enabled = not tooFar end
        if hl and hl.Parent then hl.Enabled = not tooFar end
        lName.Visible=espOptions.name and not tooFar
        lHP.Visible=espOptions.health and not tooFar
        hpBg.Visible=espOptions.health and not tooFar
        lDist.Visible=espOptions.distance and not tooFar
        if not tooFar then lDist.Text=dist.."m" end
        frameCount += 1
        if STAFFDetectOn and frameCount % 15 == 0 then
            local isS = isSuspectedSTAFF(plr)
            if isS then
                hl.FillColor=Color3.fromRGB(220,20,20); hl.OutlineColor=Color3.fromRGB(255,80,80); lName.TextColor3=Color3.fromRGB(255,80,80)
            else
                hl.FillColor=Color3.fromRGB(255,255,255); hl.OutlineColor=Color3.fromRGB(255,255,255); lName.TextColor3=Color3.fromRGB(255,255,255)
            end
        end
        local showSkel = espOptions.skeleton and not tooFar
        for i, bone in ipairs(SKELETON_BONES) do
            local line = obj.skeletonLines[i]
            if line then
                if showSkel then
                    local p0=char:FindFirstChild(bone[1]); local p1=char:FindFirstChild(bone[2])
                    if p0 and p1 then
                        local s0,on0=cam:WorldToViewportPoint(p0.Position); local s1,on1=cam:WorldToViewportPoint(p1.Position)
                        if on0 and on1 and s0.Z>0 and s1.Z>0 then
                            line.From=Vector2.new(s0.X,s0.Y); line.To=Vector2.new(s1.X,s1.Y); line.Visible=true
                        else line.Visible=false end
                    else line.Visible=false end
                else line.Visible=false end
            end
        end
        local showBox = espOptions.box and not tooFar
        if boxD then
            if showBox then
                local minX,minY,maxX,maxY = math.huge,math.huge,-math.huge,-math.huge; local anyOnScreen=false
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local sp,onScreen=cam:WorldToViewportPoint(part.Position)
                        if onScreen and sp.Z>0 then
                            anyOnScreen=true
                            if sp.X<minX then minX=sp.X end; if sp.Y<minY then minY=sp.Y end
                            if sp.X>maxX then maxX=sp.X end; if sp.Y>maxY then maxY=sp.Y end
                        end
                    end
                end
                if anyOnScreen then
                    local pad=4; boxD.Position=Vector2.new(minX-pad,minY-pad); boxD.Size=Vector2.new((maxX-minX)+pad*2,(maxY-minY)+pad*2); boxD.Visible=true
                    boxD.Color=Color3.fromRGB(255,255,255)
                else boxD.Visible=false end
            else boxD.Visible=false end
        end
    end))

    espObjects[plr.Name] = obj
end

local espCharConns = {}
local function addESP(plr)
    if plr == LP then return end
    cleanESP(plr)
    if plr.Character then task.spawn(setupESP, plr, plr.Character) end
    if espCharConns[plr.Name] then espCharConns[plr.Name]:Disconnect() end
    espCharConns[plr.Name] = plr.CharacterAdded:Connect(function(char)
        if trackOn then task.spawn(setupESP, plr, char) end
    end)
end

-- Refresh ESP toutes les 2s pour rattraper les respawn
task.spawn(function()
    while true do task.wait(2)
        if trackOn then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local obj = espObjects[plr.Name]
                    if (not obj or not obj.highlight or not obj.highlight.Parent) and plr.Character then
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            task.spawn(setupESP, plr, plr.Character)
                        end
                    end
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(p) task.wait(1); if trackOn then addESP(p) end end)
Players.PlayerRemoving:Connect(function(p)
    cleanESP(p)
    if espCharConns[p.Name] then espCharConns[p.Name]:Disconnect(); espCharConns[p.Name]=nil end
    playerSnapshots[p.Name]=nil
end)

-- ══════════════════════════════════════
--  VÉHICULE
-- ══════════════════════════════════════
local detectedVehicle = nil
local vehicleSpeed = 100
local function scanVehicles()
    local found={}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
            local model=obj:FindFirstAncestorOfClass("Model")
            if model and not table.find(found,model) then table.insert(found,model) end
        end
    end
    return found
end
local function detectVehicle()
    local hum=getHum(); if hum and hum.SeatPart then local model=hum.SeatPart:FindFirstAncestorOfClass("Model"); if model then detectedVehicle=model; return true end end
    local username=LP.Name:lower()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(username) then
            if obj:FindFirstChildOfClass("VehicleSeat") or obj:FindFirstChildOfClass("Seat") then detectedVehicle=obj; return true end
        end
    end
    local list=scanVehicles(); if #list>0 then detectedVehicle=list[1]; return true end
    return false
end
local function bindSeatDetect()
    local hum=getHum(); if not hum then return end
    hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
        local seat=hum.SeatPart
        if seat then local model=seat:FindFirstAncestorOfClass("Model"); if model then detectedVehicle=model; notify("Véhicule","'"..model.Name.."' verrouillé !",2) end end
    end)
end
bindSeatDetect()
LP.CharacterAdded:Connect(function() task.wait(1); bindSeatDetect() end)
task.spawn(function()
    while task.wait(0.5) do
        if not detectedVehicle then if detectVehicle() then notify("Véhicule","'"..detectedVehicle.Name.."' détecté !",3) end
        else if not detectedVehicle.Parent then detectedVehicle=nil end end
    end
end)

local function tpVehicleTo(pos)
    if not detectedVehicle or not detectedVehicle.Parent then return false end
    if detectedVehicle.PrimaryPart then
        detectedVehicle:SetPrimaryPartCFrame(CFrame.new(pos))
    else
        local root=nil
        for _, p in pairs(detectedVehicle:GetDescendants()) do if p:IsA("BasePart") and not p.Anchored then root=p; break end end
        if root then local offset=pos-root.Position; for _, p in pairs(detectedVehicle:GetDescendants()) do if p:IsA("BasePart") then p.CFrame=p.CFrame+offset end end end
    end
    return true
end

-- ══════════════════════════════════════════════════════════════
--  PAGES NEXONIX
-- ══════════════════════════════════════════════════════════════

-- ── PAGE 1 : SELF ─────────────────────────────────────────────
local PageSelf = Window:Page({ Icon = "rbxassetid://105280638458155" })

local SecSelf = PageSelf:Section({ Name = "Self Options", Side = 1 })

SecSelf:Slider({
    Name = "Walk Speed", Flag = "WalkSpeed",
    Min = 0, Max = 999, Default = 16, Decimals = 1,
    Callback = function(v) realWalkSpeed=v; local h=getHum(); if h and not FLYING then h.WalkSpeed=v end end,
})

SecSelf:Slider({
    Name = "Jump Power", Flag = "JumpPower",
    Min = 0, Max = 500, Default = 50, Decimals = 1,
    Callback = function(v) local h=getHum(); if h then h.UseJumpPower=true; h.JumpPower=v end end,
})

SecSelf:Slider({
    Name = "Fly Speed", Flag = "FlySpeed",
    Min = 10, Max = 500, Default = 80, Decimals = 1,
    Callback = function(v) flySpeed=v; notify("Fly Speed", v.." st/s", 1, 0.8) end,
})

local ijConn = nil
SecSelf:Toggle({
    Name = "Infinite Jump", Flag = "IJ", Default = false,
    Callback = function(v)
        if ijConn then ijConn:Disconnect(); ijConn=nil end
        if v then ijConn=UIS.JumpRequest:Connect(function() local h=getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
        notify("Infinite Jump", v and "ON" or "OFF", 2)
    end,
})

local ncConn = nil
SecSelf:Toggle({
    Name = "Noclip", Flag = "NC", Default = false,
    Callback = function(v)
        if ncConn then ncConn:Disconnect(); ncConn=nil end
        if v then ncConn=RunService.Stepped:Connect(function() local c=getChar(); if c then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end) end
        notify("Noclip", v and "ON" or "OFF", 2)
    end,
})

-- Section Auras (droite)
local SecAurasSelf = PageSelf:Section({ Name = "Auras", Side = 2 })

SecAurasSelf:Toggle({
    Name = "Touch Fling", Flag = "TouchFling", Default = false,
    Callback = function(v)
        if v then startTouchFling(); notify("Touch Fling","ON",2)
        else stopTouchFling(); notify("Touch Fling","OFF",2) end
    end,
})

SecAurasSelf:Toggle({
    Name = "Void Protection", Flag = "VoidProt", Default = false,
    Callback = function(v)
        voidProtEnabled=v; setVoidProtection(v)
        notify("Void Prot", v and "ON" or "OFF",2)
    end,
})

-- Section Aimbot (droite)
local SecAimbotSelf = PageSelf:Section({ Name = "Aimbot — F = ON/OFF", Side = 2 })

SecAimbotSelf:Toggle({
    Name = "Aimbot ON/OFF", Flag = "AimbotToggle", Default = false,
    Callback = function(v) aimbotEnabled=v; notify("Aimbot",v and"ON"or"OFF",2) end,
})

SecAimbotSelf:Slider({
    Name = "FOV détection", Flag = "AimbotFOV",
    Min = 50, Max = 800, Default = 300, Decimals = 1,
    Callback = function(v) aimbotFOV=v end,
})

SecAimbotSelf:Slider({
    Name = "Smoothing (0=snap 90=fluide)", Flag = "AimbotSmooth",
    Min = 0, Max = 90, Default = 30, Decimals = 1,
    Callback = function(v) aimbotSmoothing=v/100 end,
})

SecAimbotSelf:Dropdown({
    Name = "Partie du corps", Flag = "AimbotPart",
    Items = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
    Default = "Head",
    Callback = function(v) aimbotPart=v or "Head"; notify("Aimbot","Vise : "..aimbotPart,2) end,
})

-- ── PAGE 2 : ONLINE ───────────────────────────────────────────
local PageOnline = Window:Page({ Icon = "rbxassetid://113707798651034" })

local SecTarget = PageOnline:Section({ Name = "Cible & Actions", Side = 1 })

local selectedTarget = nil
local targetDropdown = nil

local function getSortedPlayerNames()
    local names={}
    for _, p in pairs(Players:GetPlayers()) do if p~=LP then table.insert(names,p.Name) end end
    table.sort(names,function(a,b) return a:lower()<b:lower() end)
    return names
end

local function refreshDropdown()
    local newNames=getSortedPlayerNames()
    local values=#newNames>0 and newNames or {"(aucun joueur)"}
    pcall(function() targetDropdown:Refresh(values) end)
end

local initNames=getSortedPlayerNames()
targetDropdown = SecTarget:Dropdown({
    Name = "Sélectionner un joueur", Flag = "TargetPlayer",
    Items = #initNames>0 and initNames or {"(aucun joueur)"},
    Default = initNames[1] or "(aucun joueur)",
    Callback = function(v)
        selectedTarget=Players:FindFirstChild(v)
        notify("Cible", v and ("Cible : "..v) or "Aucun", 2)
    end,
})

Players.PlayerAdded:Connect(function(p) task.wait(0.5); refreshDropdown() end)
Players.PlayerRemoving:Connect(function(p)
    if selectedTarget==p then selectedTarget=nil end
    task.wait(0.1); refreshDropdown()
end)
task.spawn(function() while true do task.wait(3); refreshDropdown() end end)

SecTarget:Button({
    Name = "Refresh joueurs",
    Callback = function() refreshDropdown(); notify("Refresh","Liste mise à jour !",2) end,
})

SecTarget:Button({
    Name = "TP → Joueur sélectionné",
    Callback = function()
        if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
        local m=getHRP(); local r=selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if m and r then m.CFrame=r.CFrame+Vector3.new(0,3,2); notify("TP","→ "..selectedTarget.Name,2)
        else notify("Erreur",selectedTarget.Name.." introuvable !",2) end
    end,
})

SecTarget:Button({
    Name = "KILL joueur",
    Callback = function()
        if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
        local ok, remote = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("Locker",3):WaitForChild("Civil",3):WaitForChild("Bat",3):WaitForChild("ExtraScripts",3):WaitForChild("DamageEvent",3)
        end)
        if not ok or not remote then notify("Erreur","DamageEvent introuvable !",3) return end
        local char=selectedTarget.Character
        if not char then notify("Erreur",selectedTarget.Name.." pas de perso !",2) return end
        pcall(function() remote:FireServer(char,99999) end)
        pcall(function() remote:FireServer(selectedTarget,99999) end)
        pcall(function() remote:FireServer(char.HumanoidRootPart,99999) end)
        notify("KILL",selectedTarget.Name.." visé !",2)
    end,
})

local spectateConn=nil; local spectating=false
SecTarget:Toggle({
    Name = "Spectate joueur", Flag = "SpectateToggle", Default = false,
    Callback = function(v)
        spectating=v
        if spectateConn then spectateConn:Disconnect(); spectateConn=nil end
        if v then
            if not selectedTarget then notify("Erreur","Aucune cible !",2); spectating=false; return end
            local cam=getCam(); cam.CameraType=Enum.CameraType.Scriptable
            notify("Spectate","ON → "..selectedTarget.Name,2)
            spectateConn=RunService.RenderStepped:Connect(function()
                if not spectating then return end
                local target=selectedTarget; if not target or not target.Character then return end
                local hrp=target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then cam.CFrame=CFrame.new(hrp.Position+Vector3.new(0,5,-10),hrp.Position) end
            end)
        else
            local cam=getCam(); cam.CameraType=Enum.CameraType.Custom; notify("Spectate","OFF",2)
        end
    end,
})

-- Section TP Car & CarFuck (droite)
local SecCar = PageOnline:Section({ Name = "TP Car & CarFuck", Side = 2 })

local carsAttackActive=false
SecCar:Button({
    Name = "TP (car) sur la cible !",
    Callback = function()
        if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
        if not detectedVehicle or not detectedVehicle.Parent then if not detectVehicle() then notify("Erreur","Aucun véhicule détecté !",3) return end end
        carsAttackActive=not carsAttackActive
        if carsAttackActive then
            notify("TP Car","LANCÉ ! Retour dans 2s...",3)
            local targetHRP=selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
            if not targetHRP then notify("Erreur","Cible introuvable !",2); carsAttackActive=false; return end
            tpVehicleTo(targetHRP.Position+Vector3.new(0,2,0))
            task.spawn(function()
                task.wait(2); if not carsAttackActive then return end
                local myRoot=getHRP(); if myRoot then tpVehicleTo(myRoot.Position+Vector3.new(4,2,0)) end
                carsAttackActive=false; notify("Véhicule","Voiture de retour !",2)
            end)
        else notify("TP Car","Annulé.",2) end
    end,
})

local carFuckActive=false; local carFuckInterval=0.4
SecCar:Button({
    Name = "CARFUCK !",
    Callback = function()
        if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
        if not detectedVehicle or not detectedVehicle.Parent then if not detectVehicle() then notify("Erreur","Aucun véhicule !",3) return end end
        carFuckActive=not carFuckActive
        if carFuckActive then
            notify("CARFUCK","Va-et-viens lancés ! Stop via le bouton.",3)
            task.spawn(function()
                while carFuckActive do
                    local targetHRP=selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
                    if not targetHRP then task.wait(0.3)
                    else
                        local targetPos=targetHRP.Position
                        if not carFuckActive then break end
                        tpVehicleTo(targetPos+Vector3.new(0,2,0)); task.wait(carFuckInterval)
                        if not carFuckActive then break end
                        tpVehicleTo(targetPos+Vector3.new(0,2,5)); task.wait(carFuckInterval)
                    end
                end
                local myRoot=getHRP(); if myRoot then tpVehicleTo(myRoot.Position+Vector3.new(4,2,0)) end
                notify("CARFUCK","Arrêté.",2)
            end)
        else notify("CARFUCK","Arrêt en cours...",2) end
    end,
})

SecCar:Slider({
    Name = "Vitesse CARFUCK", Flag = "CarFuckSpeed",
    Min = 1, Max = 20, Default = 4, Decimals = 1,
    Callback = function(v) carFuckInterval=v/10; notify("CARFUCK","Intervalle : "..carFuckInterval.."s",1,0.5) end,
})

-- Section LIMBAR (droite)
local SecLimbar = PageOnline:Section({ Name = "LIMBAR PLAYERS", Side = 2 })

local limbarActive=false
SecLimbar:Button({
    Name = "LIMBAR PLAYERS !",
    Callback = function()
        if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
        if limbarActive then notify("Erreur","LIMBAR déjà en cours !",2) return end
        local target=selectedTarget; limbarActive=true
        notify("LIMBAR","LANCÉ sur "..target.Name.." — 10 secondes !",3)
        startTouchFling()
        task.spawn(function()
            local startTime=tick()
            while limbarActive and (tick()-startTime)<10 do
                pcall(function()
                    local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart"); local myRoot=getHRP()
                    if tRoot and myRoot then myRoot.CFrame=CFrame.new(tRoot.Position+Vector3.new(0,1,0)) end
                end); task.wait(0.05)
            end
            limbarActive=false; stopTouchFling()
            notify("LIMBAR","Terminé sur "..target.Name.." !",3)
        end)
    end,
})

SecLimbar:Button({
    Name = "Stop LIMBAR",
    Callback = function()
        if limbarActive then limbarActive=false; stopTouchFling(); notify("LIMBAR","Arrêté manuellement.",2)
        else notify("LIMBAR","LIMBAR n'est pas actif.",2) end
    end,
})

-- ── PAGE 3 : TELEPORT ─────────────────────────────────────────
local PageTP = Window:Page({ Icon = "rbxassetid://137783165137735" })

local SecTPClic = PageTP:Section({ Name = "TP Clic", Side = 1 })

local tpClicEnabled=false; local tpClicConn=nil
SecTPClic:Toggle({
    Name = "TP Clic ON/OFF", Flag = "TpClic", Default = false,
    Callback = function(v)
        tpClicEnabled=v
        if tpClicConn then tpClicConn:Disconnect(); tpClicConn=nil end
        if v then
            notify("TP Clic","ON",2)
            tpClicConn=UIS.InputBegan:Connect(function(input,gpe)
                if gpe or not tpClicEnabled then return end
                if input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
                local mouse=LP:GetMouse(); local m=getHRP()
                if m then m.CFrame=CFrame.new(mouse.Hit.Position+Vector3.new(0,3,0)); notify("TP","OK",1) end
            end)
        else notify("TP Clic","OFF",2) end
    end,
})

SecTPClic:Button({
    Name = "TP au Spawn",
    Callback = function()
        local m=getHRP(); local s=workspace:FindFirstChildOfClass("SpawnLocation")
        if m and s then m.CFrame=s.CFrame+Vector3.new(0,5,0); notify("Spawn","Téléporté au spawn !",2)
        else notify("Spawn","Spawn introuvable !",2) end
    end,
})

-- Section TP Véhicule (droite)
local SecVehTP = PageTP:Section({ Name = "TP Véhicule au clic", Side = 2 })

local vehTPEnabled=false; local vehTPConn=nil
SecVehTP:Toggle({
    Name = "TP Véhicule au clic", Flag = "VehTP", Default = false,
    Callback = function(v)
        vehTPEnabled=v
        if vehTPConn then vehTPConn:Disconnect(); vehTPConn=nil end
        if v then
            if not detectedVehicle or not detectedVehicle.Parent then
                if not detectVehicle() then notify("Erreur","Aucun véhicule !",3); vehTPEnabled=false; return end
            end
            notify("Veh TP","ON",2)
            vehTPConn=UIS.InputBegan:Connect(function(input,gpe)
                if gpe or not vehTPEnabled then return end
                if input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
                if not detectedVehicle or not detectedVehicle.Parent then notify("Erreur","Véhicule disparu !",2); vehTPEnabled=false; return end
                local mouse=LP:GetMouse(); local cam=getCam()
                local origin=cam.CFrame.Position; local target=mouse.Hit.Position; local dir=(target-origin)
                if dir.Magnitude<0.5 then return end
                local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
                local excl={detectedVehicle}; if getChar() then table.insert(excl,getChar()) end
                params.FilterDescendantsInstances=excl
                local result=workspace:Raycast(origin,dir.Unit*2000,params); local hitPos=result and result.Position or target
                tpVehicleTo(hitPos+Vector3.new(0,4,0)); notify("Véhicule","Téléporté !",1)
            end)
        else notify("Veh TP","OFF",2) end
    end,
})

-- ── PAGE 4 : VISUAL ───────────────────────────────────────────
local PageVisual = Window:Page({ Icon = "rbxassetid://85403342431888" })

-- Section TrackAll (gauche)
local SecESPMaster = PageVisual:Section({ Name = "TrackAll — Master", Side = 1 })

SecESPMaster:Toggle({
    Name = "TrackAll ON/OFF", Flag = "TrackAll", Default = false,
    Callback = function(v)
        trackOn=v
        if v then for _, p in pairs(Players:GetPlayers()) do addESP(p) end; notify("TrackAll","ON",2)
        else for _, p in pairs(Players:GetPlayers()) do cleanESP(p) end; notify("TrackAll","OFF",2) end
    end,
})

SecESPMaster:Slider({
    Name = "Distance max ESP", Flag = "ESPMaxDist",
    Min = 10, Max = 5000, Default = 1000, Decimals = 1,
    Callback = function(v) espMaxDistance=v; notify("ESP Distance","Affiche jusqu'à "..v.."m",1,0.8) end,
})

SecESPMaster:Button({
    Name = "Refresh manuel",
    Callback = function()
        if not trackOn then notify("Erreur","Active TrackAll d'abord !",2) return end
        for _, p in pairs(Players:GetPlayers()) do cleanESP(p) end
        task.wait(0.3); for _, p in pairs(Players:GetPlayers()) do addESP(p) end
        notify("ESP","Rafraîchi !",2)
    end,
})

SecESPMaster:Toggle({ Name="Skeleton ESP", Flag="ESPSkeleton", Default=true, Callback=function(v) espOptions.skeleton=v; notify("Skeleton",v and"ON"or"OFF",2) end })
SecESPMaster:Toggle({ Name="Box ESP", Flag="ESPBox", Default=true, Callback=function(v) espOptions.box=v; if not v then for _,obj in pairs(espObjects) do if obj.boxDrawing then obj.boxDrawing.Visible=false end end end; notify("Box ESP",v and"ON"or"OFF",2) end })
SecESPMaster:Toggle({ Name="Health ESP", Flag="ESPHealth", Default=true, Callback=function(v) espOptions.health=v; notify("Health",v and"ON"or"OFF",2) end })
SecESPMaster:Toggle({ Name="Name ESP", Flag="ESPName", Default=true, Callback=function(v) espOptions.name=v; notify("Name",v and"ON"or"OFF",2) end })
SecESPMaster:Toggle({ Name="Distance ESP", Flag="ESPDist", Default=true, Callback=function(v) espOptions.distance=v; notify("Distance",v and"ON"or"OFF",2) end })

SecESPMaster:Toggle({
    Name = "STAFF Detect", Flag = "STAFFDetect", Default = false,
    Callback = function(v)
        STAFFDetectOn=v
        if v then
            if not trackOn then trackOn=true; for _, p in pairs(Players:GetPlayers()) do addESP(p) end; notify("TrackAll","Activé automatiquement",2) end
            playerSnapshots={}; notify("STAFF Detect","ON",3)
        else
            notify("STAFF Detect","OFF",2)
            for _, plr in pairs(Players:GetPlayers()) do
                local obj=espObjects[plr.Name]
                if obj and obj.highlight and obj.highlight.Parent then
                    obj.highlight.FillColor=Color3.fromRGB(255,255,255); obj.highlight.OutlineColor=Color3.fromRGB(255,255,255)
                end
            end
            playerSnapshots={}
        end
    end,
})

-- Section Lighting (droite)
local SecLighting = PageVisual:Section({ Name = "Lighting", Side = 2 })

SecLighting:Toggle({
    Name = "Remove Fog", Flag = "NoFog", Default = false,
    Callback = function(v) Lighting.FogEnd=v and 1e6 or 1000; Lighting.FogStart=v and 1e6 or 0 end,
})

SecLighting:Toggle({
    Name = "Fullbright", Flag = "Fullbright", Default = false,
    Callback = function(v)
        Lighting.Brightness=v and 10 or 1; Lighting.ClockTime=v and 14 or 12
        Lighting.Ambient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
    end,
})

SecLighting:Slider({
    Name = "FOV", Flag = "FOV",
    Min = 60, Max = 120, Default = 70, Decimals = 1,
    Callback = function(v) getCam().FieldOfView=v end,
})

-- Section Animations (droite)
local SecAnim = PageVisual:Section({ Name = "Animations", Side = 2 })

local ANIMS = {{"Robot Dance","507766388"},{"Floss","5915693312"},{"Samba","507776879"},{"Wave","507770239"},
    {"Laugh","507770818"},{"Cheer","507770677"},{"Sleep","507771019"},{"Air Guitar","182453160"},
    {"Too Cool","507769051"},{"Roar","507761307"}}

local currentAnim=nil
local function playAnim(id)
    local hum=getHum(); if not hum then return end
    if currentAnim then pcall(function() currentAnim:Stop() end); currentAnim=nil end
    local anim=Instance.new("Animation"); anim.AnimationId="rbxassetid://"..id
    local animator=hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator",3)
    if animator then
        local track=animator:LoadAnimation(anim); track.Priority=Enum.AnimationPriority.Action; track:Play()
        currentAnim=track; notify("Animation","Lancée !",2)
    end
end

local animValues={}
for _, a in ipairs(ANIMS) do table.insert(animValues,a[1]) end

SecAnim:Dropdown({
    Name = "Choisir une animation", Flag = "AnimSelect",
    Items = animValues, Default = animValues[1],
    Callback = function(v) for _, a in ipairs(ANIMS) do if a[1]==v then playAnim(a[2]); break end end end,
})

SecAnim:Button({
    Name = "Stop l'animation",
    Callback = function()
        if currentAnim then pcall(function() currentAnim:Stop() end); currentAnim=nil; notify("Animation","Arrêtée",2)
        else notify("Animation","Aucune anim en cours",2) end
    end,
})

SecAnim:Textbox({
    Name = "ID Custom", Flag = "CustomAnim",
    Placeholder = "507766388", Finished = true,
    Callback = function(id) if id and id~="" then playAnim(id) end end,
})

-- ── PAGE 5 : MISC ─────────────────────────────────────────────
local PageMisc = Window:Page({ Icon = "rbxassetid://129245697782918" })

local SecMusic = PageMisc:Section({ Name = "Musique", Side = 1 })

SecMusic:Toggle({
    Name = "Musique ON/OFF", Flag = "MusicToggle", Default = true,
    Callback = function(v)
        if v then bgMusic:Play(); notify("Musique","ON",2) else bgMusic:Stop(); notify("Musique","OFF",2) end
    end,
})

SecMusic:Slider({
    Name = "Volume", Flag = "MusicVolume",
    Min = 0, Max = 100, Default = 50, Decimals = 1,
    Callback = function(v) bgMusic.Volume=v/100; notify("Volume",v.."%",1,0.6) end,
})

-- Section Scripts (droite)
local SecScripts = PageMisc:Section({ Name = "Scripts externes", Side = 2 })

SecScripts:Button({
    Name = "SystemBroken",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GZSSF/script3/95a45577475502cfbf546ae9ca8fc4f00b61eb83/script3"))()
        notify("Scripts","SystemBroken exécuté !",2)
    end,
})

SecScripts:Button({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        notify("Scripts","Infinite Yield exécuté !",2)
    end,
})

SecScripts:Button({
    Name = "Anti blacklist (re-exec)",
    Callback = function()
        pcall(function()
            local old
            old=hookmetamethod(game,"__namecall",function(self,...)
                local method=getnamecallmethod(); local args={...}
                if method=="InvokeServer" then
                    local blockedTexts={"added blacklisted","Anticheat","SF Treason","banni",""}
                    for _, v in ipairs(args) do
                        if typeof(v)=="string" then
                            local lower=v:lower()
                            for _, word in ipairs(blockedTexts) do
                                if string.find(lower,word) then warn("Blocked call:",v); return nil end
                            end
                        end
                    end
                    return old(self,unpack(args))
                end
                return old(self,...)
            end)
        end)
        notify("Scripts","Anti-Blacklist re-exécuté !",2)
    end,
})

-- ══════════════════════════════════════
--  INIT
-- ══════════════════════════════════════
do
    local VU=game:GetService("VirtualUser")
    LP.Idled:Connect(function() VU:Button2Down(Vector2.zero,getCam().CFrame); task.wait(1); VU:Button2Up(Vector2.zero,getCam().CFrame) end)
end

notify("Panel Wars", "Menu chargé ! — By FocusOnTop", 5)
