-- ╔══════════════════════════════════════════════════════╗
-- ║       Panel Wars Menu  —  [BETA]                     ║
-- ║         Migré vers Nexonix  by FocusOnTop  2026     ║
-- ║         Version script séparé — UI Freecam/Inv       ║
-- ╚══════════════════════════════════════════════════════╝

-- Lib externe séparée : si tu héberges la lib patchée, remplace juste ce lien.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DrPurplee/TelAvivMenu/refs/heads/main/newui.lua"))()

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
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris       = game:GetService("Debris")
ReplicatedStorage  = game:GetService("ReplicatedStorage")
local LP           = Players.LocalPlayer

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

local function playLocalSound(soundId, volume, playbackSpeed)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://" .. tostring(soundId)
    s.Volume = volume or 1
    s.PlaybackSpeed = playbackSpeed or 1
    s.RollOffMaxDistance = 0
    s.Parent = SoundService
    pcall(function() s:Play() end)
    Debris:AddItem(s, 8)
end

-- ══════════════════════════════════════
--  HELPERS UI NEXONIX
-- ══════════════════════════════════════
local function nxTheme(name, fallback)
    local ok, value = pcall(function()
        return Library and Library.Theme and Library.Theme[name]
    end)

    if ok and typeof(value) == "Color3" then
        return value
    end

    return fallback or Color3.fromRGB(255, 255, 255)
end

local function nxCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function nxStroke(parent, colorName, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = nxTheme(colorName or "Outline", Color3.fromRGB(47, 49, 53))
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function nxUseFont(label, fallbackFont)
    pcall(function()
        if Library and Library.Font then
            label.FontFace = Library.Font
        end
    end)
    pcall(function()
        label.Font = fallbackFont or Enum.Font.Gotham
    end)
end

local function nxButton(parent, text, size, position, accent)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = accent and nxTheme("Accent", Color3.fromRGB(78, 95, 255)) or nxTheme("Element", Color3.fromRGB(38, 38, 50))
    b.Text = text
    b.TextColor3 = nxTheme("Text", Color3.fromRGB(255, 255, 255))
    b.TextSize = 13
    nxUseFont(b, Enum.Font.GothamBold)
    b.Parent = parent
    nxCorner(b, 8)
    return b
end

-- ══════════════════════════════════════
--  WINDOW
-- ══════════════════════════════════════
local Window = Library:Window({
    Logo = "rbxassetid://132873357116161",
})

Library.MenuKeybind = tostring(Enum.KeyCode.H)

-- ══════════════════════════════════════
--  LOGO EN BAS À GAUCHE
-- ══════════════════════════════════════
local logoGui = Instance.new("ScreenGui")
logoGui.Name = "BottomLeftLogo"
logoGui.ResetOnSpawn = false
logoGui.IgnoreGuiInset = true
logoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
logoGui.Parent = LP:WaitForChild("PlayerGui")

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.BackgroundTransparency = 1 -- pas de fond
logo.Image = "rbxassetid://124884194374035"
logo.Size = UDim2.new(0, 320, 0, 320)
logo.Position = UDim2.new(0, 15, 1, -210)
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoGui

-- ══════════════════════════════════════
--  FIX ANIMATIONS DE MARCHE
-- ══════════════════════════════════════
local function fixWalkAnim(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.PlatformStand = false
    local animate = char:FindFirstChild("Animate")
    if not animate then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
        end
    else
        animate.Disabled = true
        task.wait(0.05)
        animate.Disabled = false
    end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    fixWalkAnim(char)
end)
task.spawn(function()
    task.wait(0.5)
    if LP.Character then fixWalkAnim(LP.Character) end
end)

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
--  WALKSPEED FURTIF
-- ══════════════════════════════════════
local stealthSpeedEnabled = false
local stealthSpeedValue   = 16
local stealthSpeedConn    = nil
local stealthKeys         = { F=false, B=false, L=false, R=false }

local function startStealthSpeed()
    if stealthSpeedConn then stealthSpeedConn:Disconnect(); stealthSpeedConn = nil end
    local hum = getHum()
    if hum then hum.WalkSpeed = 0 end

    local keyDownConn = UIS.InputBegan:Connect(function(i, g)
        if g then return end
        local k = i.KeyCode
        if k == Enum.KeyCode.W then stealthKeys.F = true
        elseif k == Enum.KeyCode.S then stealthKeys.B = true
        elseif k == Enum.KeyCode.A then stealthKeys.L = true
        elseif k == Enum.KeyCode.D then stealthKeys.R = true
        end
    end)
    local keyUpConn = UIS.InputEnded:Connect(function(i, g)
        if g then return end
        local k = i.KeyCode
        if k == Enum.KeyCode.W then stealthKeys.F = false
        elseif k == Enum.KeyCode.S then stealthKeys.B = false
        elseif k == Enum.KeyCode.A then stealthKeys.L = false
        elseif k == Enum.KeyCode.D then stealthKeys.R = false
        end
    end)

    stealthSpeedConn = RunService.Heartbeat:Connect(function(dt)
        if not stealthSpeedEnabled then
            keyDownConn:Disconnect()
            keyUpConn:Disconnect()
            stealthSpeedConn:Disconnect()
            stealthSpeedConn = nil
            stealthKeys = { F=false, B=false, L=false, R=false }
            local h = getHum()
            if h then h.WalkSpeed = realWalkSpeed end
            return
        end

        local hrp = getHRP()
        local hum2 = getHum()
        if not hrp or not hum2 then return end
        if hum2.WalkSpeed ~= 0 then hum2.WalkSpeed = 0 end

        local cam = getCam()
        local camFlat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        if camFlat.Magnitude < 0.01 then return end
        camFlat = camFlat.Unit
        local rightFlat = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
        if rightFlat.Magnitude < 0.01 then rightFlat = Vector3.new(1,0,0) else rightFlat = rightFlat.Unit end

        local wishDir = Vector3.zero
        if stealthKeys.F then wishDir = wishDir + camFlat  end
        if stealthKeys.B then wishDir = wishDir - camFlat  end
        if stealthKeys.L then wishDir = wishDir - rightFlat end
        if stealthKeys.R then wishDir = wishDir + rightFlat end

        if wishDir.Magnitude < 0.01 then return end
        wishDir = wishDir.Unit

        local newPos = hrp.Position + wishDir * stealthSpeedValue * dt
        hrp.CFrame = CFrame.new(Vector3.new(newPos.X, hrp.Position.Y, newPos.Z))
            * CFrame.Angles(0, math.atan2(-wishDir.X, -wishDir.Z), 0)
    end)
end

local function stopStealthSpeed()
    stealthSpeedEnabled = false
    stealthKeys = { F=false, B=false, L=false, R=false }
end

-- ══════════════════════════════════════
--  FLY FURTIF + FLUIDE
-- ══════════════════════════════════════
local FLYING        = false
local flySpeed      = 80
local realWalkSpeed = 16
local flyKeyDown    = nil
local flyKeyUp      = nil
local flyConn       = nil
local flyJumpConn   = nil

local savedJumpPower    = nil
local savedJumpHeight   = nil
local savedUseJumpPower = nil

local function disableJumpForFly()
    local hum = getHum(); if not hum then return end
    savedUseJumpPower = hum.UseJumpPower
    savedJumpPower    = hum.JumpPower
    savedJumpHeight   = hum.JumpHeight
    hum.UseJumpPower  = true
    hum.JumpPower     = 0
    hum.JumpHeight    = 0
end

local function restoreJumpAfterFly()
    local hum = getHum(); if not hum then return end
    if savedUseJumpPower ~= nil then hum.UseJumpPower = savedUseJumpPower end
    if savedJumpPower    ~= nil then hum.JumpPower    = savedJumpPower    end
    if savedJumpHeight   ~= nil then hum.JumpHeight   = savedJumpHeight   end
    savedUseJumpPower = nil; savedJumpPower = nil; savedJumpHeight = nil
end

local flyKeys = { F=false, B=false, L=false, R=false, U=false, D=false }
local flyVel  = Vector3.zero
local FLY_ACCEL    = 18
local FLY_DECEL    = 20
local FLY_DEADZONE = 0.05

local function NOFLY()
    FLYING = false
    flyVel = Vector3.zero
    if flyKeyDown  then flyKeyDown:Disconnect();  flyKeyDown  = nil end
    if flyKeyUp    then flyKeyUp:Disconnect();    flyKeyUp    = nil end
    if flyConn     then flyConn:Disconnect();     flyConn     = nil end
    if flyJumpConn then flyJumpConn:Disconnect(); flyJumpConn = nil end
    flyKeys = { F=false, B=false, L=false, R=false, U=false, D=false }
    local hum = getHum()
    if hum then hum.WalkSpeed = realWalkSpeed end
    restoreJumpAfterFly()
    notify("Fly", "OFF", 2)
end

local function sFLY()
    if FLYING then NOFLY(); return end
    local hrp = getHRP()
    if not hrp then notify("Fly", "Personnage introuvable !", 2) return end

    FLYING = true
    disableJumpForFly()
    flyVel  = Vector3.zero
    flyKeys = { F=false, B=false, L=false, R=false, U=false, D=false }

    flyJumpConn = RunService.Heartbeat:Connect(function()
        if not FLYING then return end
        local hum = getHum()
        if hum and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    flyKeyDown = UIS.InputBegan:Connect(function(i, g)
        if g then return end
        local k = i.KeyCode
        if k == Enum.KeyCode.W then flyKeys.F = true
        elseif k == Enum.KeyCode.S then flyKeys.B = true
        elseif k == Enum.KeyCode.A then flyKeys.L = true
        elseif k == Enum.KeyCode.D then flyKeys.R = true
        elseif k == Enum.KeyCode.E then flyKeys.U = true
        elseif k == Enum.KeyCode.Q then flyKeys.D = true
        end
    end)

    flyKeyUp = UIS.InputEnded:Connect(function(i, g)
        if g then return end
        local k = i.KeyCode
        if k == Enum.KeyCode.W then flyKeys.F = false
        elseif k == Enum.KeyCode.S then flyKeys.B = false
        elseif k == Enum.KeyCode.A then flyKeys.L = false
        elseif k == Enum.KeyCode.D then flyKeys.R = false
        elseif k == Enum.KeyCode.E then flyKeys.U = false
        elseif k == Enum.KeyCode.Q then flyKeys.D = false
        end
    end)

    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not FLYING then return end
        local hrp2 = getHRP(); if not hrp2 then return end
        local cam   = getCam()
        local camCF = cam.CFrame

        local wishDir = Vector3.zero
        if flyKeys.F then wishDir = wishDir + camCF.LookVector  end
        if flyKeys.B then wishDir = wishDir - camCF.LookVector  end
        if flyKeys.L then wishDir = wishDir - camCF.RightVector end
        if flyKeys.R then wishDir = wishDir + camCF.RightVector end
        if flyKeys.U then wishDir = wishDir + Vector3.new(0,1,0) end
        if flyKeys.D then wishDir = wishDir - Vector3.new(0,1,0) end

        local anyKey = flyKeys.F or flyKeys.B or flyKeys.L or flyKeys.R or flyKeys.U or flyKeys.D

        if anyKey and wishDir.Magnitude > 0 then
            flyVel = flyVel:Lerp(wishDir.Unit * flySpeed, math.min(1, FLY_ACCEL * dt))
        else
            flyVel = flyVel:Lerp(Vector3.zero, math.min(1, FLY_DECEL * dt))
            if flyVel.Magnitude < FLY_DEADZONE then flyVel = Vector3.zero end
        end

        if flyVel.Magnitude > FLY_DEADZONE then
            local newPos  = hrp2.Position + flyVel * dt
            local flatVel = Vector3.new(flyVel.X, 0, flyVel.Z)
            if flatVel.Magnitude > 0.5 then
                local goalRot = CFrame.lookAt(newPos, newPos + flatVel)
                local currYaw = CFrame.new(newPos, newPos + Vector3.new(
                    hrp2.CFrame.LookVector.X, 0, hrp2.CFrame.LookVector.Z + 0.0001))
                hrp2.CFrame = currYaw:Lerp(goalRot, math.min(1, 10 * dt))
            else
                hrp2.CFrame = CFrame.new(newPos, newPos + Vector3.new(
                    hrp2.CFrame.LookVector.X, 0, hrp2.CFrame.LookVector.Z + 0.0001))
            end
        end
    end)

    notify("Fly", "ON — WASD + E/Q | LeftCtrl = stop/reprendre | Vitesse : " .. flySpeed, 3)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then sFLY() end
end)
LP.CharacterAdded:Connect(function()
    if FLYING then NOFLY() end
end)

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
--  AIMBOT NORMAL
-- ══════════════════════════════════════
local aimbotEnabled    = false
local aimbotSmoothing  = 0.3
local aimbotPart       = "Head"
local aimbotFOV        = 300
local aimbotShowFOV    = true
local aimbotConn       = nil

local fovCircle = Drawing.new("Circle")
fovCircle.Visible      = false
fovCircle.Color        = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness    = 1.5
fovCircle.Transparency = 1
fovCircle.NumSides     = 64
fovCircle.Filled       = false

local function updateFOVCircle()
    local cam = getCam()
    fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    fovCircle.Radius   = aimbotFOV
    fovCircle.Visible  = aimbotShowFOV and aimbotEnabled
end

local function getClosestTarget(ignoreWalls)
    local cam    = getCam()
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local best, bestD = nil, aimbotFOV
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local part = plr.Character:FindFirstChild(aimbotPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
            if part and hum and hum.Health > 0 then
                local sp, onScreen = cam:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
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
        updateFOVCircle()
        if not aimbotEnabled then return end

        local target = getClosestTarget(false)
        if not target or not target.Character then return end

        local part = target.Character:FindFirstChild(aimbotPart) or target.Character:FindFirstChild("HumanoidRootPart")
        if not part then return end

        local cam = getCam()
        local tCF = CFrame.new(cam.CFrame.Position, part.Position)
        cam.CFrame = aimbotSmoothing <= 0.01 and tCF or cam.CFrame:Lerp(tCF, 1 - aimbotSmoothing)
    end)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        aimbotEnabled = not aimbotEnabled
        notify("Aimbot", aimbotEnabled and "ON" or "OFF", 2)
        updateFOVCircle()
    end
end)
runAimbot()

-- ══════════════════════════════════════════════════════════════
--  ESP / TRACKALL  — VERSION ROBUSTE
-- ══════════════════════════════════════════════════════════════
local espOptions = { health = true, name = true, distance = true }
local espMaxDistance = 1000
local trackOn        = false
local STAFFDetectOn  = false
local playerSnapshots = {}
staffLocked     = staffLocked or {}
local espObjects      = {}
local espPending      = {}
local ensureESP       = nil

-- STAFF Detect officiel : basé uniquement sur l'Attribute serveur Permissions.
-- Dans le chat du jeu, Permissions >= 100 = STAFF.
local STAFF_PERMISSION_MIN = 100

-- Notifications STAFF proches
local staffNotificationsOn = false
local STAFF_NOTIFY_DISTANCE = 90
local STAFF_NOTIFY_COOLDOWN = 25
local STAFF_NOTIFY_SOUND_ID = 107089652181213
local staffNotifyLast = {}
local staffNotifyInside = {}

function isInfValue(v)
    return v == math.huge or v == -math.huge or v ~= v or tostring(v):lower():find("inf") ~= nil or v > 1e20
end

function isInfHumanoid(hum)
    if not hum then return false end
    return isInfValue(hum.Health) or isInfValue(hum.MaxHealth)
end

function formatHumanoidHP(hum)
    if not hum then
        return "0/0"
    end

    if isInfHumanoid(hum) then
        return "inf/inf"
    end

    return tostring(math.floor(hum.Health)) .. "/" .. tostring(math.floor(hum.MaxHealth))
end

function getStaffPermissionValue(plr)
    if not plr then return 0 end

    local raw = nil
    pcall(function()
        raw = plr:GetAttribute("Permissions")
    end)

    if typeof(raw) == "number" then
        return raw
    end

    return tonumber(raw) or 0
end

function isSuspectedSTAFF(plr)
    if not plr or not plr.Parent then
        return false
    end

    -- Nouvelle détection : uniquement avec le rank/attribute serveur.
    -- Permissions >= 100 = STAFF, comme dans le tag chat du jeu.
    local permissions = getStaffPermissionValue(plr)
    local isStaff = permissions >= STAFF_PERMISSION_MIN

    if isStaff then
        staffLocked[plr.Name] = true
        return true
    end

    staffLocked[plr.Name] = nil
    return false
end

local function tryStaffProximityNotification(plr, dist)
    if not staffNotificationsOn or not STAFFDetectOn then return end
    if not plr or plr == LP or not plr.Parent then return end

    local key = tostring(plr.UserId or plr.Name)
    local isStaff = staffLocked[plr.Name] == true or isSuspectedSTAFF(plr)

    if not isStaff then
        staffNotifyInside[key] = nil
        return
    end

    if not dist or dist <= 0 or dist > STAFF_NOTIFY_DISTANCE then
        staffNotifyInside[key] = nil
        return
    end

    if staffNotifyInside[key] then return end

    local now = tick()
    if staffNotifyLast[key] and (now - staffNotifyLast[key]) < STAFF_NOTIFY_COOLDOWN then
        staffNotifyInside[key] = true
        return
    end

    staffNotifyInside[key] = true
    staffNotifyLast[key] = now

    playLocalSound(STAFF_NOTIFY_SOUND_ID, 1)
    notify("STAFF Detect", plr.Name .. " est en train de vous surveiller", 5)
end

local function cleanESP(plr)
    local obj = espObjects[plr.Name]
    if not obj then return end

    espObjects[plr.Name] = nil

    if obj.conns then
        for _, c in pairs(obj.conns) do
            pcall(function() c:Disconnect() end)
        end
    end

    if obj.highlight then pcall(function() obj.highlight:Destroy() end) end
    if obj.billboard then pcall(function() obj.billboard:Destroy() end) end
    if obj.footBillboard then pcall(function() obj.footBillboard:Destroy() end) end
end

local function isESPValid(plr)
    local obj = espObjects[plr.Name]
    if not obj then return false end
    if not obj.highlight or not obj.highlight.Parent then return false end
    if not obj.billboard or not obj.billboard.Parent then return false end
    if not obj.footBillboard or not obj.footBillboard.Parent then return false end
    return true
end

local function setupESP(plr, char)
    cleanESP(plr)
    task.wait(0.35)

    if not char or not char.Parent then return end
    if plr.Character ~= char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")

    if not hrp or not hum or not head then
        task.wait(0.8)
        hrp = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChildOfClass("Humanoid")
        head = char:FindFirstChild("Head")
    end

    if not hrp or not hum or not head then return end
    if hum.Health <= 0 and not isInfHumanoid(hum) then return end

    local obj = { conns = {}, highlight = nil, billboard = nil, footBillboard = nil }

    -- Glow propre sur le skin, sans grosse box UI.
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.91
    hl.OutlineTransparency = 0.08
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    obj.highlight = hl

    -- Nameplate compact : STAFF + pseudo + team colorée + distance + mini HP.
    local bb = Instance.new("BillboardGui")
    bb.Name = "TrackAllInfo"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 175, 0, 70)
    bb.StudsOffset = Vector3.new(0, 1.15, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = espMaxDistance
    bb.Parent = head
    obj.billboard = bb

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 1, 0)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.Parent = bb

    local staffVisualActive = false

    local lSTAFF = Instance.new("TextLabel")
    lSTAFF.Size = UDim2.new(1, 0, 0, 22)
    lSTAFF.Position = UDim2.new(0, 0, 0, 0)
    lSTAFF.BackgroundTransparency = 1
    lSTAFF.Text = "STAFF"
    lSTAFF.TextColor3 = Color3.fromRGB(255, 45, 45)
    lSTAFF.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lSTAFF.TextStrokeTransparency = 0
    lSTAFF.TextScaled = false
    lSTAFF.TextSize = 19
    lSTAFF.Font = Enum.Font.GothamBlack
    lSTAFF.TextXAlignment = Enum.TextXAlignment.Center
    lSTAFF.Visible = false
    lSTAFF.Parent = holder

    local lName = Instance.new("TextLabel")
    lName.Size = UDim2.new(1, 0, 0, 15)
    lName.Position = UDim2.new(0, 0, 0, 0)
    lName.BackgroundTransparency = 1
    lName.Text = plr.Name
    lName.TextColor3 = Color3.fromRGB(245, 245, 245)
    lName.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lName.TextStrokeTransparency = 0
    lName.TextScaled = false
    lName.TextSize = 12
    lName.Font = Enum.Font.GothamBold
    lName.TextXAlignment = Enum.TextXAlignment.Center
    lName.Visible = espOptions.name
    lName.Parent = holder

    local lTeam = Instance.new("TextLabel")
    lTeam.Size = UDim2.new(1, 0, 0, 12)
    lTeam.Position = UDim2.new(0, 0, 0, 14)
    lTeam.BackgroundTransparency = 1
    lTeam.Text = ""
    lTeam.TextColor3 = Color3.fromRGB(190, 190, 190)
    lTeam.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lTeam.TextStrokeTransparency = 0.08
    lTeam.TextScaled = false
    lTeam.TextSize = 10
    lTeam.Font = Enum.Font.GothamBold
    lTeam.TextXAlignment = Enum.TextXAlignment.Center
    lTeam.Visible = true
    lTeam.Parent = holder

    local lDist = Instance.new("TextLabel")
    lDist.Size = UDim2.new(1, 0, 0, 11)
    lDist.Position = UDim2.new(0, 0, 0, 26)
    lDist.BackgroundTransparency = 1
    lDist.Text = "0m"
    lDist.TextColor3 = Color3.fromRGB(185, 185, 185)
    lDist.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lDist.TextStrokeTransparency = 0.12
    lDist.TextScaled = false
    lDist.TextSize = 10
    lDist.Font = Enum.Font.Gotham
    lDist.TextXAlignment = Enum.TextXAlignment.Center
    lDist.Visible = espOptions.distance
    lDist.Parent = holder

    local hpBg = Instance.new("Frame")
    hpBg.Name = "HPBackground"
    hpBg.AnchorPoint = Vector2.new(0.5, 0)
    hpBg.Position = UDim2.new(0.5, 0, 0, 40)
    hpBg.Size = UDim2.new(0, 82, 0, 4)
    hpBg.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    hpBg.BackgroundTransparency = 0.16
    hpBg.BorderSizePixel = 0
    hpBg.Visible = espOptions.health
    hpBg.Parent = holder

    local hpStroke = Instance.new("UIStroke")
    hpStroke.Color = Color3.fromRGB(0, 0, 0)
    hpStroke.Thickness = 1
    hpStroke.Transparency = 0.18
    hpStroke.Parent = hpBg

    local hpBar = Instance.new("Frame")
    hpBar.Name = "HPFill"
    hpBar.Position = UDim2.new(0, 0, 0, 0)
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.BackgroundColor3 = Color3.fromRGB(40, 210, 90)
    hpBar.BorderSizePixel = 0
    hpBar.Parent = hpBg

    -- Armes sous les pieds : uniquement pour la team Civil, et on ignore les items basiques.
    local footBb = Instance.new("BillboardGui")
    footBb.Name = "TrackAllWeapons"
    footBb.Adornee = hrp
    footBb.Size = UDim2.new(0, 170, 0, 18)
    footBb.StudsOffset = Vector3.new(0, -2.85, 0)
    footBb.AlwaysOnTop = true
    footBb.MaxDistance = espMaxDistance
    footBb.Enabled = false
    footBb.Parent = hrp
    obj.footBillboard = footBb

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Size = UDim2.new(1, 0, 1, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Text = ""
    weaponLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    weaponLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    weaponLabel.TextStrokeTransparency = 0.05
    weaponLabel.TextScaled = false
    weaponLabel.TextSize = 10
    weaponLabel.Font = Enum.Font.GothamBold
    weaponLabel.TextXAlignment = Enum.TextXAlignment.Center
    weaponLabel.Parent = footBb

    local ignoredItems = {
        ["clé de voiture"] = true,
        ["cle de voiture"] = true,
        ["papiers"] = true,
        ["phone"] = true,
        ["sac de sport"] = true,
    }

    local function cleanItemName(name)
        name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")
        return name
    end

    local function isIgnoredItem(name)
        local n = string.lower(cleanItemName(name))
        return ignoredItems[n] == true
    end

    local function isCivilTeam()
        return plr.Team and plr.Team.Name == "Civil"
    end

    local function getTeamName()
        if plr.Team and plr.Team.Name then
            return plr.Team.Name
        end
        return "Sans team"
    end

    local function getTeamColor()
        local ok, c = pcall(function()
            return plr.TeamColor.Color
        end)
        if ok and c then return c end
        return Color3.fromRGB(190, 190, 190)
    end

    local function collectWeapons()
        if not isCivilTeam() then return "" end

        local found = {}
        local seen = {}

        local function scan(container)
            if not container then return end
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local name = cleanItemName(item.Name)
                    if name ~= "" and not isIgnoredItem(name) and not seen[name] then
                        seen[name] = true
                        table.insert(found, name)
                    end
                end
            end
        end

        scan(plr:FindFirstChild("Backpack"))
        scan(plr.Character)

        if #found == 0 then return "" end
        if #found > 3 then
            return found[1] .. " • " .. found[2] .. " • " .. found[3] .. " +" .. tostring(#found - 3)
        end

        return table.concat(found, " • ")
    end

    local function updateTeamLabel()
        lTeam.Text = getTeamName()
        lTeam.TextColor3 = getTeamColor()
    end

    local function getHealthColor(ratio)
        if ratio <= 0.30 then
            return Color3.fromRGB(255, 65, 65)
        elseif ratio <= 0.60 then
            return Color3.fromRGB(255, 205, 55)
        else
            return Color3.fromRGB(45, 215, 95)
        end
    end

    local function getDistanceScale(dist)
        if not dist then return 1 end
        local t = math.clamp((dist - 25) / 520, 0, 1)
        return 1 - (t * 0.62)
    end

    local function refreshESPLayout(dist)
        local ok, size = pcall(function()
            return char:GetExtentsSize()
        end)
        if not ok or not size then return end

        local scale = getDistanceScale(dist)
        local fade = math.clamp(((dist or 0) - 120) / 650, 0, 1)
        local staffH = staffVisualActive and math.max(16, math.floor(22 * scale + 0.5)) or 0

        local width = math.max(82, math.floor((136 + size.X * 8) * scale))
        local height = math.max(34, math.floor((50 * scale) + staffH))
        local nameSize = math.max(8, math.floor(12 * scale + 0.5))
        local teamSize = math.max(7, math.floor(10 * scale + 0.5))
        local distSize = math.max(7, math.floor(10 * scale + 0.5))
        local staffSize = math.max(12, math.floor(19 * scale + 0.5))
        local hpW = math.max(34, math.floor(82 * scale))
        local hpH = math.max(2, math.floor(4 * scale + 0.5))
        local nameH = math.max(11, nameSize + 3)
        local teamH = math.max(9, teamSize + 2)
        local distH = math.max(8, distSize + 2)
        local y = staffH

        bb.Size = UDim2.new(0, width, 0, height)
        bb.StudsOffset = Vector3.new(0, math.clamp(size.Y * 0.34, 1.0, 1.55), 0)

        lSTAFF.Size = UDim2.new(1, 0, 0, staffH)
        lSTAFF.TextSize = staffSize
        lSTAFF.TextTransparency = fade * 0.08
        lSTAFF.TextStrokeTransparency = fade * 0.18

        lName.Position = UDim2.new(0, 0, 0, y)
        lName.Size = UDim2.new(1, 0, 0, nameH)
        lName.TextSize = nameSize
        lName.TextTransparency = fade * 0.18
        lName.TextStrokeTransparency = fade * 0.32
        y += nameH - 1

        lTeam.Position = UDim2.new(0, 0, 0, y)
        lTeam.Size = UDim2.new(1, 0, 0, teamH)
        lTeam.TextSize = teamSize
        lTeam.TextTransparency = fade * 0.22
        lTeam.TextStrokeTransparency = 0.08 + (fade * 0.34)
        y += teamH - 1

        lDist.Position = UDim2.new(0, 0, 0, y)
        lDist.Size = UDim2.new(1, 0, 0, distH)
        lDist.TextSize = distSize
        lDist.TextTransparency = fade * 0.26
        lDist.TextStrokeTransparency = 0.12 + (fade * 0.38)
        y += distH + 2

        hpBg.Position = UDim2.new(0.5, 0, 0, y)
        hpBg.Size = UDim2.new(0, hpW, 0, hpH)
        hpBg.BackgroundTransparency = 0.16 + (fade * 0.34)
        hpStroke.Transparency = 0.18 + (fade * 0.38)
        hpBar.BackgroundTransparency = fade * 0.18

        local footW = math.max(70, math.floor(165 * scale))
        local footH = math.max(12, math.floor(18 * scale))
        local footSize = math.max(8, math.floor(10 * scale + 0.5))
        footBb.Size = UDim2.new(0, footW, 0, footH)
        footBb.StudsOffset = Vector3.new(0, -math.clamp(size.Y * 0.58, 2.55, 4.0), 0)
        weaponLabel.TextSize = footSize
        weaponLabel.TextTransparency = fade * 0.28
        weaponLabel.TextStrokeTransparency = 0.05 + (fade * 0.45)

        if staffVisualActive then
            hl.FillTransparency = 0.66 + (fade * 0.08)
            hl.OutlineTransparency = 0.01 + (fade * 0.18)
        else
            hl.FillTransparency = 0.91 + (fade * 0.06)
            hl.OutlineTransparency = 0.08 + (fade * 0.48)
        end
    end

    local function updateHealthBar()
        if not hum or not hum.Parent or not hpBar or not hpBar.Parent then return end

        if isInfHumanoid(hum) then
            hpBar.Size = UDim2.new(1, 0, 1, 0)
            hpBar.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
            return
        end

        local maxHp = math.max(hum.MaxHealth, 1)
        local ratio = math.clamp(hum.Health / maxHp, 0, 1)

        hpBar.Size = UDim2.new(ratio, 0, 1, 0)
        hpBar.BackgroundColor3 = getHealthColor(ratio)
    end

    local function setStaffVisual(enabled)
        staffVisualActive = enabled == true
        lSTAFF.Visible = staffVisualActive

        if enabled then
            -- Aura rouge forte : visible même si le joueur a rendu son skin invisible.
            hl.Enabled = true
            hl.FillColor = Color3.fromRGB(255, 25, 25)
            hl.OutlineColor = Color3.fromRGB(255, 80, 80)
            hl.FillTransparency = 0.66
            hl.OutlineTransparency = 0.01

            lSTAFF.TextColor3 = Color3.fromRGB(255, 45, 45)
            lName.TextColor3 = Color3.fromRGB(255, 95, 95)
            lDist.TextColor3 = Color3.fromRGB(255, 155, 155)
            hpStroke.Color = Color3.fromRGB(255, 70, 70)
        else
            hl.FillColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.91
            hl.OutlineTransparency = 0.08

            lName.TextColor3 = Color3.fromRGB(245, 245, 245)
            lDist.TextColor3 = Color3.fromRGB(185, 185, 185)
            hpStroke.Color = Color3.fromRGB(0, 0, 0)
        end
    end

    table.insert(obj.conns, hum.Died:Connect(function()
        task.wait(0.1)
        cleanESP(plr)

        -- TrackAll reste actif après mort/respawn : on réattend le nouveau Character.
        if trackOn and plr.Parent then
            task.spawn(function()
                local nextChar = nil

                if plr.Character and plr.Character ~= char then
                    nextChar = plr.Character
                else
                    pcall(function()
                        nextChar = plr.CharacterAdded:Wait()
                    end)
                end

                if trackOn and nextChar and plr.Parent and ensureESP then
                    task.wait(0.35)
                    ensureESP(plr, nextChar)
                end
            end)
        end
    end))

    table.insert(obj.conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            cleanESP(plr)
        end
    end))

    table.insert(obj.conns, hum.HealthChanged:Connect(function()
        updateHealthBar()
    end))

    local frameCount = 0

    table.insert(obj.conns, RunService.RenderStepped:Connect(function()
        if not char or not char.Parent or not hrp or not hrp.Parent or not head or not head.Parent then
            cleanESP(plr)
            return
        end

        local myRoot = getHRP()
        local dist = 0

        if myRoot then
            dist = math.floor((hrp.Position - myRoot.Position).Magnitude)
        end

        local tooFar = dist > espMaxDistance

        if bb and bb.Parent then bb.Enabled = not tooFar end
        if footBb and footBb.Parent then footBb.Enabled = false end
        if hl and hl.Parent then hl.Enabled = not tooFar end

        lName.Visible = espOptions.name and not tooFar
        lTeam.Visible = not tooFar
        lDist.Visible = espOptions.distance and not tooFar
        hpBg.Visible = espOptions.health and not tooFar

        if not tooFar then
            lName.Text = plr.Name
            lDist.Text = dist .. "m"
            updateTeamLabel()

            local weaponsText = collectWeapons()
            weaponLabel.Text = weaponsText
            footBb.Enabled = weaponsText ~= ""

            refreshESPLayout(dist)
            updateHealthBar()
        end

        frameCount += 1

        if STAFFDetectOn then
            local staffNow = staffLocked[plr.Name] == true

            if frameCount % 10 == 0 then
                staffNow = isSuspectedSTAFF(plr)
            end

            setStaffVisual(staffNow)

            if staffNow and not tooFar then
                tryStaffProximityNotification(plr, dist)
            end
        else
            staffLocked[plr.Name] = nil
            staffNotifyInside[tostring(plr.UserId or plr.Name)] = nil
            setStaffVisual(false)
        end
    end))

    updateTeamLabel()
    weaponLabel.Text = collectWeapons()
    footBb.Enabled = weaponLabel.Text ~= ""
    refreshESPLayout(0)
    updateHealthBar()

    if STAFFDetectOn and isSuspectedSTAFF(plr) then
        setStaffVisual(true)
    end

    espObjects[plr.Name] = obj
end

local espCharConns = {}
local espCharRemovingConns = {}

ensureESP = function(plr, char)
    if not trackOn or not plr or plr == LP or not plr.Parent then return end
    char = char or plr.Character
    if not char or not char.Parent then return end

    if espPending[plr.Name] then return end
    espPending[plr.Name] = true

    task.spawn(function()
        pcall(function()
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 8)
            local hum = char:FindFirstChildOfClass("Humanoid")
            local timeout = tick() + 8

            while not hum and tick() < timeout do
                task.wait(0.1)
                hum = char:FindFirstChildOfClass("Humanoid")
            end

            if not trackOn or not plr.Parent or plr.Character ~= char then return end
            if not hrp or not hum then return end
            if hum.Health <= 0 and not isInfHumanoid(hum) then return end

            setupESP(plr, char)
        end)
        espPending[plr.Name] = nil
    end)
end

local function subscribeESP(plr)
    if plr == LP then return end

    if espCharConns[plr.Name] then espCharConns[plr.Name]:Disconnect() end
    if espCharRemovingConns[plr.Name] then espCharRemovingConns[plr.Name]:Disconnect() end

    espCharConns[plr.Name] = plr.CharacterAdded:Connect(function(char)
        if trackOn then ensureESP(plr, char) end
    end)

    espCharRemovingConns[plr.Name] = plr.CharacterRemoving:Connect(function()
        cleanESP(plr)
    end)

    if trackOn and plr.Character then
        ensureESP(plr, plr.Character)
    end
end

for _, p in pairs(Players:GetPlayers()) do subscribeESP(p) end
Players.PlayerAdded:Connect(function(p)
    subscribeESP(p)
    if trackOn then
        local char = p.Character
        if not char then
            local conn; conn = p.CharacterAdded:Connect(function(c)
                conn:Disconnect()
                if trackOn then ensureESP(p, c) end
            end)
        else
            ensureESP(p, char)
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    cleanESP(p)
    if espCharConns[p.Name] then espCharConns[p.Name]:Disconnect(); espCharConns[p.Name]=nil end
    if espCharRemovingConns[p.Name] then espCharRemovingConns[p.Name]:Disconnect(); espCharRemovingConns[p.Name]=nil end
    espPending[p.Name]=nil
    playerSnapshots[p.Name]=nil
    staffLocked[p.Name]=nil
end)

task.spawn(function()
    while true do
        task.wait(1.5)
        if trackOn then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local char = plr.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if not isESPValid(plr) and (not hum or hum.Health > 0 or isInfHumanoid(hum)) then
                            ensureESP(plr, char)
                        end
                    else
                        if espObjects[plr.Name] then cleanESP(plr) end
                    end
                end
            end
        end
    end
end)

-- ══════════════════════════════════════
--  ORBIT PLAYER
-- ══════════════════════════════════════
local orbitActive = false
local orbitAngle  = 0
local orbitRadius = 6
local orbitSpeed  = 1.5

local function startOrbit(target)
    if orbitActive then return end
    orbitActive=true; orbitAngle=0
    notify("Orbit","ON → "..target.Name,2)
    task.spawn(function()
        while orbitActive do
            local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local myRoot=getHRP()
            if not tRoot or not myRoot or not target.Character then
                task.wait(0.1); orbitAngle+=orbitSpeed*0.1; continue
            end
            orbitAngle=orbitAngle+orbitSpeed*0.05
            local offsetX=math.cos(orbitAngle)*orbitRadius
            local offsetZ=math.sin(orbitAngle)*orbitRadius
            local targetPos=tRoot.Position+Vector3.new(offsetX,2,offsetZ)
            myRoot.CFrame=CFrame.new(targetPos,tRoot.Position)
            task.wait(0.05)
        end
        notify("Orbit","OFF",2)
    end)
end

local function stopOrbit() orbitActive=false end

-- ══════════════════════════════════════
--  VÉHICULE — UNIVERSAL REWRITE NO-CONFLICT
-- ══════════════════════════════════════
local detectedVehicle = nil

-- Accélération / freinage façon Universal Vehicle Script, mais isolé.
local velocityEnabled = true
local vehicleSpeed = 0.025      -- slider / 1000
local vehicleBrake = 0.150      -- slider / 1000
local vehicleStopKey = Enum.KeyCode.P

-- Vehicle Fly façon Universal Vehicle Script, mais isolé.
local vehFlyActive = false
local vehFlySpeed = 1           -- slider / 100
local vehFlyConn = nil
local defaultCharacterParent = nil
local vehicleBusyUntil = 0

local function markVehicleBusy(duration)
    vehicleBusyUntil = math.max(vehicleBusyUntil, tick() + (duration or 0.55))
end

local function isVehicleBusy()
    return tick() < vehicleBusyUntil
end

local function getSeatPart()
    local char = getChar()
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    return hum and hum.SeatPart or nil
end

local function getVehicleFromDescendant(descendant)
    if not descendant then return nil end

    return descendant:FindFirstAncestor(LP.Name .. "'s Car")
        or (descendant:FindFirstAncestor("Body") and descendant:FindFirstAncestor("Body").Parent)
        or (descendant:FindFirstAncestor("Misc") and descendant:FindFirstAncestor("Misc").Parent)
        or descendant:FindFirstAncestorWhichIsA("Model")
end

local function ensureVehiclePrimaryPart(vehicle, seatPart)
    if not vehicle or not vehicle:IsA("Model") then return false end

    if vehicle.PrimaryPart and vehicle.PrimaryPart.Parent then
        return true
    end

    if seatPart and seatPart:IsA("BasePart") and seatPart:IsDescendantOf(vehicle) then
        vehicle.PrimaryPart = seatPart
        return true
    end

    local vehicleSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
    if vehicleSeat then
        vehicle.PrimaryPart = vehicleSeat
        return true
    end

    local seat = vehicle:FindFirstChildWhichIsA("Seat", true)
    if seat then
        vehicle.PrimaryPart = seat
        return true
    end

    local base = vehicle:FindFirstChildWhichIsA("BasePart", true)
    if base then
        vehicle.PrimaryPart = base
        return true
    end

    return false
end

local function zeroVehicleVelocity(vehicle, seatPart)
    if seatPart and seatPart:IsA("BasePart") then
        pcall(function()
            seatPart.AssemblyLinearVelocity = Vector3.zero
            seatPart.AssemblyAngularVelocity = Vector3.zero
            seatPart.Velocity = Vector3.zero
            seatPart.RotVelocity = Vector3.zero
        end)
    end

    if vehicle and vehicle.Parent then
        for _, p in pairs(vehicle:GetDescendants()) do
            if p:IsA("BasePart") and not p.Anchored then
                pcall(function()
                    p.AssemblyLinearVelocity = Vector3.zero
                    p.AssemblyAngularVelocity = Vector3.zero
                    p.Velocity = Vector3.zero
                    p.RotVelocity = Vector3.zero
                end)
            end
        end
    end
end

local function getCurrentVehicle()
    local seat = getSeatPart()

    if seat then
        local vehicle = getVehicleFromDescendant(seat)
        if vehicle and vehicle:IsA("Model") then
            detectedVehicle = vehicle
            ensureVehiclePrimaryPart(vehicle, seat)
            return vehicle, seat
        end
    end

    if detectedVehicle and detectedVehicle.Parent then
        ensureVehiclePrimaryPart(detectedVehicle, detectedVehicle:FindFirstChildWhichIsA("VehicleSeat", true) or detectedVehicle:FindFirstChildWhichIsA("Seat", true))
        return detectedVehicle, nil
    end

    return nil, nil
end

local function scanVehicles()
    local found = {}

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
            local model = getVehicleFromDescendant(obj)
            if model and model:IsA("Model") and not table.find(found, model) then
                table.insert(found, model)
            end
        end
    end

    return found
end

local function detectVehicle()
    local vehicle, seat = getCurrentVehicle()
    if vehicle then
        detectedVehicle = vehicle
        ensureVehiclePrimaryPart(vehicle, seat)
        return true
    end

    local username = LP.Name:lower()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(username) then
            if obj:FindFirstChildWhichIsA("VehicleSeat", true) or obj:FindFirstChildWhichIsA("Seat", true) or obj:FindFirstChild("Body") or obj:FindFirstChild("Misc") then
                detectedVehicle = obj
                ensureVehiclePrimaryPart(obj, obj:FindFirstChildWhichIsA("VehicleSeat", true) or obj:FindFirstChildWhichIsA("Seat", true))
                return true
            end
        end
    end

    local list = scanVehicles()
    if #list > 0 then
        detectedVehicle = list[1]
        ensureVehiclePrimaryPart(detectedVehicle, detectedVehicle:FindFirstChildWhichIsA("VehicleSeat", true) or detectedVehicle:FindFirstChildWhichIsA("Seat", true))
        return true
    end

    return false
end

local function bindSeatDetect()
    local hum = getHum()
    if not hum then return end

    hum:GetPropertyChangedSignal("SeatPart"):Connect(function()
        local seat = hum.SeatPart
        if seat then
            local vehicle = getVehicleFromDescendant(seat)
            if vehicle and vehicle:IsA("Model") then
                detectedVehicle = vehicle
                ensureVehiclePrimaryPart(vehicle, seat)
                notify("Véhicule", "'" .. vehicle.Name .. "' verrouillé !", 2)
            end
        end
    end)
end
bindSeatDetect()
LP.CharacterAdded:Connect(function()
    task.wait(1)
    bindSeatDetect()
end)

task.spawn(function()
    while task.wait(0.65) do
        local vehicle = getCurrentVehicle()

        if vehicle then
            detectedVehicle = vehicle
        elseif detectedVehicle and not detectedVehicle.Parent then
            detectedVehicle = nil
        end
    end
end)

local function setVehicleCFrame(vehicle, cf)
    if not vehicle or not vehicle.Parent then return false end

    local ok = pcall(function()
        if vehicle.PrimaryPart then
            vehicle:SetPrimaryPartCFrame(cf)
        else
            vehicle:PivotTo(cf)
        end
    end)

    if ok then return true end

    ok = pcall(function()
        vehicle:PivotTo(cf)
    end)

    if ok then return true end

    ok = pcall(function()
        vehicle:MoveTo(cf.Position)
    end)

    return ok == true
end

local function detachLocalCharacterFromVehicle(vehicle)
    local char = getChar()
    local hum = getHum()
    local root = getHRP()
    local rootCF = root and root.CFrame or nil
    local seat = hum and hum.SeatPart or nil

    if hum and seat and vehicle and seat:IsDescendantOf(vehicle) then
        pcall(function() hum.Sit = false end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        task.wait()
        if root and root.Parent and rootCF then
            pcall(function() root.CFrame = rootCF end)
        end
    end

    if char and defaultCharacterParent and char.Parent ~= defaultCharacterParent then
        pcall(function() char.Parent = defaultCharacterParent end)
    end
end

local stopVehFly

local function tpVehicleTo(posOrCF)
    -- Important : cette fonction est utilisée par le reste du menu.
    -- Elle déplace uniquement le véhicule, sans parent le Character au véhicule.
    markVehicleBusy(0.9)

    if vehFlyActive and stopVehFly then
        pcall(function() stopVehFly(true) end)
    end

    local vehicle, seat = getCurrentVehicle()
    if not vehicle then
        if not detectVehicle() then return false end
        vehicle, seat = getCurrentVehicle()
    end
    if not vehicle then return false end

    local cf = typeof(posOrCF) == "CFrame" and posOrCF or CFrame.new(posOrCF)

    ensureVehiclePrimaryPart(vehicle, seat)
    detachLocalCharacterFromVehicle(vehicle)

    local success = setVehicleCFrame(vehicle, cf)
    zeroVehicleVelocity(vehicle, seat)

    markVehicleBusy(0.65)
    return success
end

local function stopCurrentVehicle()
    local vehicle, seat = getCurrentVehicle()
    zeroVehicleVelocity(vehicle or detectedVehicle, seat)
end

local function applyVehicleSpeed(speed)
    vehicleSpeed = tonumber(speed) or vehicleSpeed
end

local function setVehicleBrake(force)
    vehicleBrake = tonumber(force) or vehicleBrake
end

-- Accélération / freinage : ne tourne QUE quand tu es assis dans un VehicleSeat,
-- jamais pendant les TP véhicule du reste du menu ni pendant le Vehicle Fly.
RunService.Heartbeat:Connect(function()
    if not velocityEnabled then return end
    if vehFlyActive or isVehicleBusy() then return end
    if UIS:GetFocusedTextBox() then return end

    local seat = getSeatPart()
    if not seat or not seat:IsA("VehicleSeat") then return end

    local vehicle = getVehicleFromDescendant(seat)
    if vehicle and vehicle:IsA("Model") then
        detectedVehicle = vehicle
        ensureVehiclePrimaryPart(vehicle, seat)
    end

    if UIS:IsKeyDown(Enum.KeyCode.W) then
        pcall(function()
            seat.AssemblyLinearVelocity *= Vector3.new(1 + vehicleSpeed, 1, 1 + vehicleSpeed)
        end)
    end

    if UIS:IsKeyDown(Enum.KeyCode.S) then
        local m = math.clamp(1 - vehicleBrake, 0, 1)
        pcall(function()
            seat.AssemblyLinearVelocity *= Vector3.new(m, 1, m)
        end)
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == vehicleStopKey and velocityEnabled then
        stopCurrentVehicle()
        notify("Véhicule", "Stop net !", 2)
    end
end)

local function restoreCharacterParent()
    local char = getChar()
    if char and defaultCharacterParent and defaultCharacterParent.Parent then
        pcall(function()
            char.Parent = defaultCharacterParent
        end)
    elseif char then
        pcall(function()
            char.Parent = workspace
        end)
    end
end

stopVehFly = function(silent)
    vehFlyActive = false
    if vehFlyConn then vehFlyConn:Disconnect(); vehFlyConn = nil end
    restoreCharacterParent()
    stopCurrentVehicle()
    if not silent then notify("Veh Fly", "OFF", 2) end
end

local function startVehFly()
    if vehFlyActive then
        stopVehFly()
        return
    end

    if isVehicleBusy() then
        notify("Veh Fly", "Attends la fin du TP véhicule.", 2)
        return
    end

    local char = getChar()
    local hum = getHum()
    local seat = hum and hum.SeatPart

    if not char or not hum or not seat or not seat:IsA("VehicleSeat") then
        notify("Veh Fly", "Assieds-toi dans un véhicule d'abord !", 3)
        return
    end

    local vehicle = getVehicleFromDescendant(seat)
    if not vehicle or not vehicle:IsA("Model") then
        notify("Veh Fly", "Véhicule introuvable !", 3)
        return
    end

    detectedVehicle = vehicle
    if not ensureVehiclePrimaryPart(vehicle, seat) then
        notify("Veh Fly", "Véhicule sans BasePart !", 3)
        return
    end

    defaultCharacterParent = defaultCharacterParent or char.Parent
    vehFlyActive = true

    if vehFlyConn then vehFlyConn:Disconnect(); vehFlyConn = nil end

    vehFlyConn = RunService.Stepped:Connect(function()
        if not vehFlyActive then return end
        if isVehicleBusy() then return end

        local character = getChar()
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        local seatPart = humanoid and humanoid.SeatPart

        if not character or not humanoid or not seatPart or not seatPart:IsA("VehicleSeat") then
            stopVehFly(true)
            return
        end

        local veh = getVehicleFromDescendant(seatPart)
        if not veh or not veh:IsA("Model") then
            stopVehFly(true)
            return
        end

        detectedVehicle = veh
        defaultCharacterParent = defaultCharacterParent or character.Parent

        -- Comme l'Universal original, mais seulement pendant le fly actif.
        pcall(function()
            character.Parent = veh
        end)

        if not ensureVehiclePrimaryPart(veh, seatPart) then
            stopVehFly(true)
            return
        end

        local primaryCF = veh:GetPrimaryPartCFrame()
        local camCF = workspace.CurrentCamera.CFrame
        local moveCF = CFrame.new(0, 0, 0)

        if not UIS:GetFocusedTextBox() then
            moveCF = CFrame.new(
                (UIS:IsKeyDown(Enum.KeyCode.D) and vehFlySpeed) or (UIS:IsKeyDown(Enum.KeyCode.A) and -vehFlySpeed) or 0,
                (UIS:IsKeyDown(Enum.KeyCode.E) and vehFlySpeed / 2) or (UIS:IsKeyDown(Enum.KeyCode.Q) and -vehFlySpeed / 2) or 0,
                (UIS:IsKeyDown(Enum.KeyCode.S) and vehFlySpeed) or (UIS:IsKeyDown(Enum.KeyCode.W) and -vehFlySpeed) or 0
            )
        end

        local targetCF = CFrame.new(primaryCF.Position, primaryCF.Position + camCF.LookVector) * moveCF
        setVehicleCFrame(veh, targetCF)
        zeroVehicleVelocity(veh, seatPart)
    end)

    notify("Veh Fly", "ON — WASD + E/Q | RightCtrl = stop | Vitesse : " .. tostring(math.floor(vehFlySpeed * 100)), 4)
end

-- Keybind RightCtrl → toggle Vehicle Fly
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then startVehFly() end
end)

-- ══════════════════════════════════════
--  FREECAM (Numpad 8)
-- ══════════════════════════════════════
local freecamActive = false
local FREECAM_ON_SOUND_ID = 131390520971848

-- Fermeture Freecam : touche ". / Suppr" du pavé numérique.
-- On ajoute aussi Delete en backup selon les claviers / layouts Roblox.
local FREECAM_CLOSE_KEYS = {}
local function addFreecamCloseKey(keyName)
    local ok, keyCode = pcall(function()
        return Enum.KeyCode[keyName]
    end)
    if ok and keyCode then
        FREECAM_CLOSE_KEYS[keyCode] = true
    end
end
addFreecamCloseKey("KeypadPeriod")
addFreecamCloseKey("Delete")

local function isFreecamCloseKey(keyCode)
    return FREECAM_CLOSE_KEYS[keyCode] == true
end

local function launchFreecam()
    if freecamActive then return end
    freecamActive = true
    playLocalSound(FREECAM_ON_SOUND_ID, 1)

    local cam = getCam()
    local oldCamType = cam.CameraType
    local oldCamSubject = cam.CameraSubject
    local oldMouseBehavior = UIS.MouseBehavior
    local oldMouseIcon = UIS.MouseIconEnabled

    local fc_speed = 40
    local fc_camCF = cam.CFrame
    local pitch, yaw = fc_camCF:ToOrientation()
    local fc_mouseDown = false
    local fc_keys = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}
    local fc_selectedOption = 1
    local fc_options = {
        {label = "TP Ici", desc = "Téléporte ton perso sur la caméra", key = "Entrée"},
        {label = "TP Car", desc = "Téléporte le véhicule sur la caméra", key = "Entrée"},
    }

    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = fc_camCF

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FreecamHUD_Nexonix"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999998
    screenGui.Parent = LP:WaitForChild("PlayerGui")

    local barFrame = Instance.new("Frame")
    barFrame.AnchorPoint = Vector2.new(0.5, 1)
    barFrame.Size = UDim2.new(0, 640, 0, 58)
    barFrame.Position = UDim2.new(0.5, 0, 1, -18)
    barFrame.BackgroundColor3 = nxTheme("Inline", Color3.fromRGB(29, 30, 36))
    barFrame.BackgroundTransparency = 0.03
    barFrame.BorderSizePixel = 0
    barFrame.Parent = screenGui
    nxCorner(barFrame, 14)
    nxStroke(barFrame, "Outline", 1, 0.1)

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, -24, 0, 2)
    accentLine.Position = UDim2.new(0, 12, 0, 0)
    accentLine.BackgroundColor3 = nxTheme("Accent", Color3.fromRGB(78, 95, 255))
    accentLine.BorderSizePixel = 0
    accentLine.Parent = barFrame
    nxCorner(accentLine, 2)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 150, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎥  FREECAM"
    titleLabel.TextColor3 = nxTheme("Accent", Color3.fromRGB(78, 95, 255))
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    nxUseFont(titleLabel, Enum.Font.GothamBold)
    titleLabel.Parent = barFrame

    local hintLabel = Instance.new("TextLabel")
    hintLabel.Size = UDim2.new(1, -300, 1, 0)
    hintLabel.Position = UDim2.new(0, 165, 0, 0)
    hintLabel.BackgroundTransparency = 1
    hintLabel.Text = "ZQSD ·Molette = vitesse · Numpad . / Suppr = quitter"
    hintLabel.TextColor3 = nxTheme("Dark Text", Color3.fromRGB(108, 109, 116))
    hintLabel.TextSize = 11
    hintLabel.TextXAlignment = Enum.TextXAlignment.Left
    nxUseFont(hintLabel, Enum.Font.Gotham)
    hintLabel.Parent = barFrame

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 120, 1, 0)
    speedLabel.Position = UDim2.new(1, -134, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "⚡ " .. fc_speed .. " st/s"
    speedLabel.TextColor3 = nxTheme("Text", Color3.fromRGB(255, 255, 255))
    speedLabel.TextSize = 13
    speedLabel.TextXAlignment = Enum.TextXAlignment.Right
    nxUseFont(speedLabel, Enum.Font.GothamBold)
    speedLabel.Parent = barFrame

    local optPanel = Instance.new("Frame")
    optPanel.AnchorPoint = Vector2.new(0.5, 1)
    optPanel.Position = UDim2.new(0.5, 0, 1, -88)
    optPanel.Size = UDim2.new(0, 300, 0, 132)
    optPanel.BackgroundColor3 = nxTheme("Inline", Color3.fromRGB(29, 30, 36))
    optPanel.BackgroundTransparency = 0.02
    optPanel.BorderSizePixel = 0
    optPanel.Parent = screenGui
    nxCorner(optPanel, 14)
    nxStroke(optPanel, "Outline", 1, 0.12)

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -20, 0, 28)
    panelTitle.Position = UDim2.new(0, 10, 0, 8)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "ACTIONS  ·  ↑ ↓ naviguer  ·  Entrée exécuter"
    panelTitle.TextColor3 = nxTheme("Dark Text", Color3.fromRGB(108, 109, 116))
    panelTitle.TextSize = 10
    panelTitle.TextXAlignment = Enum.TextXAlignment.Center
    nxUseFont(panelTitle, Enum.Font.Gotham)
    panelTitle.Parent = optPanel

    local optionFrames = {}
    local function rebuildOptions()
        for _, frame in ipairs(optionFrames) do
            frame:Destroy()
        end
        optionFrames = {}

        for i, opt in ipairs(fc_options) do
            local selected = i == fc_selectedOption
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, -20, 0, 40)
            f.Position = UDim2.new(0, 10, 0, 38 + ((i - 1) * 45))
            f.BackgroundColor3 = selected and nxTheme("Accent", Color3.fromRGB(78, 95, 255)) or nxTheme("Element", Color3.fromRGB(38, 38, 50))
            f.BackgroundTransparency = selected and 0 or 0.02
            f.BorderSizePixel = 0
            f.Parent = optPanel
            nxCorner(f, 9)
            table.insert(optionFrames, f)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -82, 0, 18)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = (selected and "▶  " or "   ") .. opt.label
            label.TextColor3 = nxTheme("Text", Color3.fromRGB(255, 255, 255))
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            nxUseFont(label, Enum.Font.GothamBold)
            label.Parent = f

            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -82, 0, 14)
            desc.Position = UDim2.new(0, 12, 0, 23)
            desc.BackgroundTransparency = 1
            desc.Text = opt.desc
            desc.TextColor3 = selected and nxTheme("Text", Color3.fromRGB(255, 255, 255)) or nxTheme("Dark Text", Color3.fromRGB(108, 109, 116))
            desc.TextTransparency = selected and 0.12 or 0
            desc.TextSize = 10
            desc.TextXAlignment = Enum.TextXAlignment.Left
            nxUseFont(desc, Enum.Font.Gotham)
            desc.Parent = f

            local badge = Instance.new("TextLabel")
            badge.AnchorPoint = Vector2.new(1, 0.5)
            badge.Size = UDim2.new(0, 62, 0, 20)
            badge.Position = UDim2.new(1, -10, 0.5, 0)
            badge.BackgroundColor3 = selected and nxTheme("Inline", Color3.fromRGB(29, 30, 36)) or nxTheme("Tab", Color3.fromRGB(34, 37, 57))
            badge.BackgroundTransparency = selected and 0.12 or 0
            badge.BorderSizePixel = 0
            badge.Text = opt.key
            badge.TextColor3 = nxTheme("Text", Color3.fromRGB(255, 255, 255))
            badge.TextSize = 10
            nxUseFont(badge, Enum.Font.GothamBold)
            badge.Parent = f
            nxCorner(badge, 6)
        end
    end
    rebuildOptions()

    local crosshair = Instance.new("Frame")
    crosshair.Size = UDim2.new(0, 22, 0, 22)
    crosshair.Position = UDim2.new(0.5, -11, 0.5, -11)
    crosshair.BackgroundTransparency = 1
    crosshair.Parent = screenGui

    local function crossLine(w, h, x, y)
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, w, 0, h)
        line.Position = UDim2.new(0, x, 0, y)
        line.BackgroundColor3 = nxTheme("Accent", Color3.fromRGB(78, 95, 255))
        line.BackgroundTransparency = 0.1
        line.BorderSizePixel = 0
        line.Parent = crosshair
        nxCorner(line, 2)
    end
    crossLine(2, 22, 10, 0)
    crossLine(22, 2, 0, 10)

    local conns = {}
    local function quit()
        freecamActive = false
    end

    local function executeSelectedAction()
        if fc_selectedOption == 1 then
            local root = getHRP()
            if root then
                root.CFrame = CFrame.new(fc_camCF.Position)
                notify("Freecam", "Téléporté ici", 2)
            end
        elseif fc_selectedOption == 2 then
            if not detectedVehicle or not detectedVehicle.Parent then
                if not detectVehicle() then
                    notify("Freecam", "Aucun véhicule détecté", 2)
                    return
                end
            end
            tpVehicleTo(fc_camCF.Position + Vector3.new(0, 2, 0))
            notify("Freecam", "Véhicule téléporté ici", 2)
        end
    end

    table.insert(conns, UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            fc_mouseDown = true
            UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            UIS.MouseIconEnabled = false
            return
        end

        if input.KeyCode == Enum.KeyCode.W then fc_keys.F = 1
        elseif input.KeyCode == Enum.KeyCode.S then fc_keys.B = 1
        elseif input.KeyCode == Enum.KeyCode.A then fc_keys.L = 1
        elseif input.KeyCode == Enum.KeyCode.D then fc_keys.R = 1
        elseif input.KeyCode == Enum.KeyCode.E then fc_keys.U = 1
        elseif input.KeyCode == Enum.KeyCode.Q then fc_keys.D = 1
        elseif input.KeyCode == Enum.KeyCode.Equals or input.KeyCode == Enum.KeyCode.KeypadPlus then
            fc_speed = math.min(fc_speed + 10, 300)
            speedLabel.Text = "⚡ " .. fc_speed .. " st/s"
        elseif input.KeyCode == Enum.KeyCode.Minus or input.KeyCode == Enum.KeyCode.KeypadMinus then
            fc_speed = math.max(fc_speed - 10, 5)
            speedLabel.Text = "⚡ " .. fc_speed .. " st/s"
        elseif input.KeyCode == Enum.KeyCode.Down then
            fc_selectedOption = (fc_selectedOption % #fc_options) + 1
            rebuildOptions()
        elseif input.KeyCode == Enum.KeyCode.Up then
            fc_selectedOption = ((fc_selectedOption - 2) % #fc_options) + 1
            rebuildOptions()
        elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
            executeSelectedAction()
        elseif isFreecamCloseKey(input.KeyCode) then
            quit()
        end
    end))

    table.insert(conns, UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            fc_mouseDown = false
            UIS.MouseBehavior = Enum.MouseBehavior.Default
            UIS.MouseIconEnabled = true
            return
        end

        if input.KeyCode == Enum.KeyCode.W then fc_keys.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then fc_keys.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then fc_keys.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then fc_keys.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then fc_keys.U = 0
        elseif input.KeyCode == Enum.KeyCode.Q then fc_keys.D = 0
        end
    end))

    table.insert(conns, UIS.InputChanged:Connect(function(input, gpe)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            fc_speed = math.clamp(fc_speed + input.Position.Z * 5, 5, 300)
            speedLabel.Text = "⚡ " .. fc_speed .. " st/s"
            return
        end

        if not fc_mouseDown then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local delta = input.Delta
        yaw -= delta.X * 0.0024
        pitch = math.clamp(pitch - delta.Y * 0.0024, -1.52, 1.52)
    end))

    table.insert(conns, RunService.RenderStepped:Connect(function(dt)
        if not freecamActive then return end

        local rot = CFrame.fromOrientation(pitch, yaw, 0)
        local move = Vector3.zero
        if fc_keys.F == 1 then move += rot.LookVector end
        if fc_keys.B == 1 then move -= rot.LookVector end
        if fc_keys.L == 1 then move -= rot.RightVector end
        if fc_keys.R == 1 then move += rot.RightVector end
        if fc_keys.U == 1 then move += Vector3.new(0, 1, 0) end
        if fc_keys.D == 1 then move -= Vector3.new(0, 1, 0) end

        if move.Magnitude > 0 then
            fc_camCF = CFrame.new(fc_camCF.Position + move.Unit * fc_speed * dt) * rot
        else
            fc_camCF = CFrame.new(fc_camCF.Position) * rot
        end

        cam.CFrame = fc_camCF
    end))

    task.spawn(function()
        while freecamActive do
            task.wait()
        end

        for _, conn in ipairs(conns) do
            pcall(function() conn:Disconnect() end)
        end

        pcall(function()
            cam.CameraType = oldCamType
            cam.CameraSubject = oldCamSubject
            UIS.MouseBehavior = oldMouseBehavior
            UIS.MouseIconEnabled = oldMouseIcon
        end)

        pcall(function() screenGui:Destroy() end)
        notify("Freecam", "OFF", 2)
    end)

    notify("Freecam", "ON — Numpad . / Suppr pour quitter", 5)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- Numpad8 sert à ouvrir la Freecam uniquement.
    -- La fermeture se fait avec Numpad . / Suppr.
    if input.KeyCode == Enum.KeyCode.KeypadEight then
        if not freecamActive then
            launchFreecam()
        end
    elseif freecamActive and isFreecamCloseKey(input.KeyCode) then
        freecamActive = false
    end
end)

-- ══════════════════════════════════════════════════════════════
--  PAGES NEXONIX
-- ══════════════════════════════════════════════════════════════

-- ── PAGE 1 : SELF ─────────────────────────────────────────────
local PageSelf = Window:Page({ Icon = "rbxassetid://105280638458155" })
local SecSelf  = PageSelf:Section({ Name = "Self Options", Side = 1 })

SecSelf:Slider({
    Name = "Walk Speed ", Flag = "WalkSpeed",
    Min = 0, Max = 999, Default = 16, Decimals = 1,
    Callback = function(v)
        realWalkSpeed=v; stealthSpeedValue=v
        if not stealthSpeedEnabled then
            local h=getHum(); if h and not FLYING then h.WalkSpeed=v end
        end
    end,
})

SecSelf:Button({
    Name = "Reset Speed",
    Callback = function()
        realWalkSpeed=16; stealthSpeedValue=16
        local h=getHum(); if h and not FLYING then h.WalkSpeed=16 end
        notify("Speed","Reset à 16 !",2)
    end,
})

SecSelf:Toggle({
    Name = "Walk Speed (UNDETECT SF)", Flag = "StealthSpeed", Default = false,
    Callback = function(v)
        stealthSpeedEnabled=v
        if v then startStealthSpeed(); notify("Speed Furtif","ON — CFrame, indétectable",3)
        else stopStealthSpeed(); notify("Speed Furtif","OFF",2) end
    end,
})

SecSelf:Slider({
    Name = "Jump Power", Flag = "JumpPower",
    Min = 0, Max = 500, Default = 50, Decimals = 1,
    Callback = function(v) local h=getHum(); if h then h.UseJumpPower=true; h.JumpPower=v end end,
})

SecSelf:Slider({
    Name = "Fly Speed", Flag = "FlySpeed",
    Min = 10, Max = 500, Default = 80, Decimals = 1,
    Callback = function(v) flySpeed=v; notify("Fly Speed",v.." st/s",1,0.8) end,
})

local ijConn=nil
SecSelf:Toggle({
    Name = "Infinite Jump", Flag = "IJ", Default = false,
    Callback = function(v)
        if ijConn then ijConn:Disconnect(); ijConn=nil end
        if v then ijConn=UIS.JumpRequest:Connect(function() local h=getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
        notify("Infinite Jump",v and "ON" or "OFF",2)
    end,
})

local ncConn=nil
SecSelf:Toggle({
    Name = "Noclip", Flag = "NC", Default = false,
    Callback = function(v)
        if ncConn then ncConn:Disconnect(); ncConn=nil end
        if v then ncConn=RunService.Stepped:Connect(function()
            local c=getChar(); if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
        end) end
        notify("Noclip",v and "ON" or "OFF",2)
    end,
})

local invisActive=false; local invisConns={}; local invisOriginalTransp={}

local function applyInvis(char,bool)
    if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            if p.Name=="HumanoidRootPart" then p.Transparency=1
            else if bool then invisOriginalTransp[p]=p.Transparency; p.Transparency=1
                else p.Transparency=invisOriginalTransp[p] or 0 end end
        elseif p:IsA("Decal") then
            if bool then invisOriginalTransp[p]=p.Transparency; p.Transparency=1
            else p.Transparency=invisOriginalTransp[p] or 0 end
        end
    end
    for _,acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") or acc:IsA("Hat") then
            local handle=acc:FindFirstChild("Handle")
            if handle then
                if bool then
                    invisOriginalTransp[handle]=handle.Transparency; handle.Transparency=1
                    for _,d in pairs(handle:GetDescendants()) do if d:IsA("BasePart") then invisOriginalTransp[d]=d.Transparency; d.Transparency=1 end end
                else
                    handle.Transparency=invisOriginalTransp[handle] or 0
                    for _,d in pairs(handle:GetDescendants()) do if d:IsA("BasePart") then d.Transparency=invisOriginalTransp[d] or 0 end end
                end
            end
        end
    end
end

local function setInvisible(bool)
    for _,c in pairs(invisConns) do pcall(function() c:Disconnect() end) end
    invisConns={}
    if not bool then invisOriginalTransp={} end
    local char=getChar(); if char then applyInvis(char,bool) end
    table.insert(invisConns,LP.CharacterAdded:Connect(function(c) task.wait(0.8); if invisActive then applyInvis(c,true) end end))
    if bool then
        table.insert(invisConns,RunService.Heartbeat:Connect(function()
            local c=getChar(); if not c or not invisActive then return end
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Transparency~=1 then p.Transparency=1
                elseif p:IsA("Decal") and p.Transparency~=1 then p.Transparency=1 end
            end
        end))
    end
end

SecSelf:Toggle({
    Name = "Invisible (local)", Flag = "Invisible", Default = false,
    Callback = function(v)
        invisActive=v; setInvisible(v)
        notify("Invisible",v and "ON — perso transparent localement" or "OFF",2)
    end,
})

-- ══════════════════════════════════════
--  STAFF ICON VISIBLE / INVISIBLE LOCAL
-- ══════════════════════════════════════
local staffIconVisible = false
local staffIconConns = {}

local function setStaffIconForChar(char, visible)
    if not char then return end

    local head = char:FindFirstChild("Head")
    if not head then return end

    local nameTag = head:FindFirstChild("NameTag")
    if not nameTag then return end

    local frame = nameTag:FindFirstChild("Frame")
    if not frame then return end

    local icon = frame:FindFirstChild("StaffIcon")
    if icon and icon:IsA("GuiObject") then
        icon.Visible = visible
    end
end

local function applyStaffIconToPlayer(plr)
    if not plr then return end

    if plr.Character then
        setStaffIconForChar(plr.Character, staffIconVisible)

        -- Petit retry car parfois le NameTag charge après le perso
        task.delay(0.5, function()
            if plr.Character then
                setStaffIconForChar(plr.Character, staffIconVisible)
            end
        end)

        task.delay(1.5, function()
            if plr.Character then
                setStaffIconForChar(plr.Character, staffIconVisible)
            end
        end)
    end
end

local function applyStaffIconAll()
    for _, plr in pairs(Players:GetPlayers()) do
        applyStaffIconToPlayer(plr)
    end
end

local function setupStaffIconWatcher()
    for _, c in pairs(staffIconConns) do
        pcall(function()
            c:Disconnect()
        end)
    end
    staffIconConns = {}

    for _, plr in pairs(Players:GetPlayers()) do
        table.insert(staffIconConns, plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            setStaffIconForChar(char, staffIconVisible)

            task.delay(1.5, function()
                if plr.Character == char then
                    setStaffIconForChar(char, staffIconVisible)
                end
            end)
        end))
    end

    table.insert(staffIconConns, Players.PlayerAdded:Connect(function(plr)
        table.insert(staffIconConns, plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            setStaffIconForChar(char, staffIconVisible)

            task.delay(1.5, function()
                if plr.Character == char then
                    setStaffIconForChar(char, staffIconVisible)
                end
            end)
        end))
    end))
end

setupStaffIconWatcher()

-- ══════════════════════════════════════
--  BADGES NAMETAG LOCAL
-- ══════════════════════════════════════
local localBadgesEnabled = {}
local localBadgeConns = {}

local BadgeOrder = {
    "Fondateur",
    "Admin",
    "Developer",
    "Certifie",
    "Createur",
    "VIP",
    "Fan",
    "Chefdegroupe",
    "Millionnaire",
    "Directeur",
    "Membre",
    "Computer",
    "Console",
    "Phone",
}

local function getLocalNameTagFrame(char)
    if not char then return nil end

    local head = char:FindFirstChild("Head")
    if not head then return nil end

    local nameTag = head:FindFirstChild("NameTag")
    if not nameTag then return nil end

    return nameTag:FindFirstChild("Frame")
end

local function getBadgeTemplate(frame, badgeName)
    if frame then
        local models = frame:FindFirstChild("Models")
        if models then
            local badge = models:FindFirstChild(badgeName)
            if badge then return badge end
        end
    end

    local storageModels = ReplicatedStorage:FindFirstChild("3dModels")
    local nameTagModel = storageModels and storageModels:FindFirstChild("NameTag")
    local templateFrame = nameTagModel and nameTagModel:FindFirstChild("Frame")
    local models = templateFrame and templateFrame:FindFirstChild("Models")

    return models and models:FindFirstChild(badgeName)
end

local function clearLocalBadges(frame)
    if not frame then return end

    for _, scrollName in pairs({ "ScrollingFrame1", "ScrollingFrame2" }) do
        local scroll = frame:FindFirstChild(scrollName)
        if scroll then
            for _, obj in pairs(scroll:GetChildren()) do
                if obj:GetAttribute("LocalFakeBadge") then
                    obj:Destroy()
                end
            end
        end
    end
end

local function applyLocalBadgesForChar(char)
    local frame = getLocalNameTagFrame(char)
    if not frame then return end

    local scroll1 = frame:FindFirstChild("ScrollingFrame1")
    local scroll2 = frame:FindFirstChild("ScrollingFrame2")
    if not scroll1 or not scroll2 then return end

    clearLocalBadges(frame)

    local added = 0

    for _, badgeName in ipairs(BadgeOrder) do
        if localBadgesEnabled[badgeName] then
            local template = getBadgeTemplate(frame, badgeName)

            if template then
                added += 1

                local clone = template:Clone()
                clone.Name = "Local_" .. badgeName
                clone.Visible = true
                clone:SetAttribute("LocalFakeBadge", true)

                clone.Parent = added > 6 and scroll2 or scroll1
            end
        end
    end
end

local function applyLocalBadges()
    local char = LP.Character
    if char then
        applyLocalBadgesForChar(char)

        task.delay(0.5, function()
            if LP.Character then
                applyLocalBadgesForChar(LP.Character)
            end
        end)

        task.delay(1.5, function()
            if LP.Character then
                applyLocalBadgesForChar(LP.Character)
            end
        end)
    end
end

for _, c in pairs(localBadgeConns) do
    pcall(function()
        c:Disconnect()
    end)
end

localBadgeConns = {}

table.insert(localBadgeConns, LP.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    applyLocalBadges()
end))

-- ══════════════════════════════════════
--  ROULETTE STAFF ICON / BADGES LOCAL
-- ══════════════════════════════════════
cosmeticChoice = "Staff Icon ON"

function setAllLocalBadges(enabled)
    for _, badgeName in ipairs(BadgeOrder) do
        localBadgesEnabled[badgeName] = enabled
    end

    applyLocalBadges()
end

cosmeticItems = {
    "Staff Icon ON",
    "Staff Icon OFF",
    "Tous badges ON",
    "Tous badges OFF",
}

for _, badgeName in ipairs(BadgeOrder) do
    table.insert(cosmeticItems, "Toggle " .. badgeName)
end

SecSelf:Dropdown({
    Name = "Staff / Badges",
    Flag = "CosmeticLocalChoice",
    Items = cosmeticItems,
    Default = "Staff Icon ON",
    Callback = function(v)
        cosmeticChoice = tostring(v)
    end,
})

SecSelf:Button({
    Name = "Appliquer Badges",
    Callback = function()
        local choice = cosmeticChoice

        if choice == "Staff Icon ON" then
            staffIconVisible = true
            applyStaffIconAll()
            notify("Staff Icon", "VISIBLE", 2)
            return
        end

        if choice == "Staff Icon OFF" then
            staffIconVisible = false
            applyStaffIconAll()
            notify("Staff Icon", "INVISIBLE", 2)
            return
        end

        if choice == "Tous badges ON" then
            setAllLocalBadges(true)
            notify("Badges", "Tous activés", 2)
            return
        end

        if choice == "Tous badges OFF" then
            setAllLocalBadges(false)
            notify("Badges", "Tous désactivés", 2)
            return
        end

        local badgeName = choice:match("^Toggle%s+(.+)$")
        if badgeName then
            localBadgesEnabled[badgeName] = not localBadgesEnabled[badgeName]
            applyLocalBadges()
            notify("Badge", badgeName .. (localBadgesEnabled[badgeName] and " ON" or " OFF"), 2)
            return
        end

        notify("Badges", "Choix invalide", 2)
    end,
})

local SecAurasSelf=PageSelf:Section({Name="Auras",Side=2})

SecAurasSelf:Toggle({
    Name="Touch Fling",Flag="TouchFling",Default=false,
    Callback=function(v)
        if v then startTouchFling(); notify("Touch Fling","ON",2)
        else stopTouchFling(); notify("Touch Fling","OFF",2) end
    end,
})

SecAurasSelf:Toggle({
    Name="Void Protection",Flag="VoidProt",Default=false,
    Callback=function(v) voidProtEnabled=v; setVoidProtection(v); notify("Void Prot",v and "ON" or "OFF",2) end,
})

local SecAimbotSelf=PageSelf:Section({Name="Aimbot — (Keybind = F)",Side=2})

SecAimbotSelf:Toggle({
    Name="Aimbot Normal (F)",Flag="AimbotToggle",Default=false,
    Callback=function(v) aimbotEnabled=v; notify("Aimbot",v and "ON" or "OFF",2); updateFOVCircle() end,
})

SecAimbotSelf:Toggle({Name="Afficher cercle FOV",Flag="AimbotShowFOV",Default=true,Callback=function(v) aimbotShowFOV=v; updateFOVCircle() end})
SecAimbotSelf:Slider({Name="Taille cercle FOV",Flag="AimbotFOV",Min=10,Max=800,Default=300,Decimals=1,Callback=function(v) aimbotFOV=v; fovCircle.Radius=v; updateFOVCircle() end})
SecAimbotSelf:Slider({Name="Smoothing",Flag="AimbotSmooth",Min=0,Max=90,Default=30,Decimals=1,Callback=function(v) aimbotSmoothing=v/100 end})
SecAimbotSelf:Dropdown({
    Name="Partie du corps",Flag="AimbotPart",
    Items={"Head","HumanoidRootPart","UpperTorso","LowerTorso"},Default="Head",
    Callback=function(v) aimbotPart=v or "Head"; notify("Aimbot","Vise : "..aimbotPart,2) end,
})

-- ── PAGE 2 : ONLINE ───────────────────────────────────────────
local PageOnline=Window:Page({Icon="rbxassetid://113707798651034"})
local SecTarget=PageOnline:Section({Name="Online options",Side=1})

local selectedTarget=nil; local targetDropdown=nil

local function getPlayersByDistance()
    local myRoot=getHRP(); local list={}
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP then
            local dist=math.huge
            if myRoot and p.Character then
                local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then dist=(hrp.Position-myRoot.Position).Magnitude end
            end
            table.insert(list,{name=p.Name,dist=dist})
        end
    end
    table.sort(list,function(a,b) return a.dist<b.dist end)
    local names={}; for _,e in ipairs(list) do table.insert(names,e.name) end
    return names
end

local function refreshDropdown()
    local names=getPlayersByDistance()
    local values=#names>0 and names or {"(aucun joueur)"}
    pcall(function() targetDropdown:Refresh(values) end)
end

local initNames=getPlayersByDistance()
targetDropdown=SecTarget:Dropdown({
    Name="Sélectionner un joueur",Flag="TargetPlayer",
    Items=#initNames>0 and initNames or {"(aucun joueur)"},
    Default=initNames[1] or "(aucun joueur)",
    Callback=function(v) selectedTarget=Players:FindFirstChild(v); notify("Cible",v and ("Cible : "..v) or "Aucun",2) end,
})

Players.PlayerAdded:Connect(function(p) task.wait(0.5); refreshDropdown() end)
Players.PlayerRemoving:Connect(function(p) if selectedTarget==p then selectedTarget=nil end; task.wait(0.1); refreshDropdown() end)
task.spawn(function() while true do task.wait(2); refreshDropdown() end end)

SecTarget:Button({Name="Refresh liste",Callback=function() refreshDropdown(); notify("Refresh","Liste triée par distance !",2) end})

-- ══════════════════════════════════════
--  POPUP INVENTAIRE CIBLE — DESIGN NEXONIX
-- ══════════════════════════════════════
TA_InventoryGui = nil

function TA_CloseInventoryPopup()
    if TA_InventoryGui then
        pcall(function() TA_InventoryGui:Destroy() end)
        TA_InventoryGui = nil
    end
end

function TA_SafeText(v)
    local ok, txt = pcall(function() return tostring(v) end)
    return ok and txt or "?"
end

function TA_GetItemDetails(item)
    return ""
end

function TA_GetInventoryData(plr)
    local items = {}
    local backpack = plr and plr:FindFirstChild("Backpack")

    if backpack then
        for _, obj in pairs(backpack:GetChildren()) do
            table.insert(items, obj)
        end
    end

    table.sort(items, function(a, b)
        return tostring(a.Name):lower() < tostring(b.Name):lower()
    end)

    return items
end

function TA_CreateEmptyLabel(parent)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 38)
    label.BackgroundColor3 = nxTheme("Element", Color3.fromRGB(38, 38, 50))
    label.BackgroundTransparency = 0.02
    label.BorderSizePixel = 0
    label.Text = "  Backpack vide"
    label.TextColor3 = nxTheme("Dark Text", Color3.fromRGB(108, 109, 116))
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    nxUseFont(label, Enum.Font.Gotham)
    label.Parent = parent
    nxCorner(label, 8)
end

function TA_MakeInventoryCard(parent, item)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 40)
    card.BackgroundColor3 = nxTheme("Element", Color3.fromRGB(38, 38, 50))
    card.BackgroundTransparency = 0.02
    card.BorderSizePixel = 0
    card.Parent = parent
    nxCorner(card, 8)
    nxStroke(card, "Outline", 1, 0.45)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 14, 0.5, -4)
    dot.BackgroundColor3 = nxTheme("Accent", Color3.fromRGB(78, 95, 255))
    dot.BorderSizePixel = 0
    dot.Parent = card
    nxCorner(dot, 99)

    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -42, 1, 0)
    name.Position = UDim2.new(0, 32, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = TA_SafeText(item and item.Name or "?")
    name.TextColor3 = nxTheme("Text", Color3.fromRGB(255, 255, 255))
    name.TextSize = 13
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.TextTruncate = Enum.TextTruncate.AtEnd
    nxUseFont(name, Enum.Font.GothamBold)
    name.Parent = card
end

function TA_ShowInventoryPopup(plr)
    TA_CloseInventoryPopup()

    if not plr then
        notify("Inventaire", "Aucune cible !", 2)
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TA_InventoryPopup_Nexonix"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999999
    TA_InventoryGui = gui

    local okParent = pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)
    if not okParent then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    local shadow = Instance.new("TextButton")
    shadow.AutoButtonColor = false
    shadow.Text = ""
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.55
    shadow.BorderSizePixel = 0
    shadow.Parent = gui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 440, 0, 380)
    main.Position = UDim2.new(0.5, -220, 0.5, -190)
    main.BackgroundColor3 = nxTheme("Background", Color3.fromRGB(24, 26, 30))
    main.BorderSizePixel = 0
    main.Parent = gui
    nxCorner(main, 14)
    nxStroke(main, "Outline", 1, 0.12)

    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 58)
    top.BackgroundColor3 = nxTheme("Inline", Color3.fromRGB(29, 30, 36))
    top.BorderSizePixel = 0
    top.Parent = main
    nxCorner(top, 14)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, -26, 0, 2)
    accent.Position = UDim2.new(0, 13, 1, -2)
    accent.BackgroundColor3 = nxTheme("Accent", Color3.fromRGB(78, 95, 255))
    accent.BorderSizePixel = 0
    accent.Parent = top
    nxCorner(accent, 2)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -130, 0, 24)
    title.Position = UDim2.new(0, 16, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Inventaire"
    title.TextColor3 = nxTheme("Text", Color3.fromRGB(255, 255, 255))
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    nxUseFont(title, Enum.Font.GothamBold)
    title.Parent = top

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -130, 0, 18)
    subtitle.Position = UDim2.new(0, 16, 0, 32)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = plr.Name .. "  ·  Backpack uniquement"
    subtitle.TextColor3 = nxTheme("Dark Text", Color3.fromRGB(108, 109, 116))
    subtitle.TextSize = 11
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    nxUseFont(subtitle, Enum.Font.Gotham)
    subtitle.Parent = top

    local close = nxButton(top, "×", UDim2.new(0, 32, 0, 32), UDim2.new(1, -44, 0, 13), false)
    close.TextSize = 20

    local refresh = nxButton(top, "Refresh", UDim2.new(0, 78, 0, 32), UDim2.new(1, -130, 0, 13), true)
    refresh.TextSize = 12

    local summary = Instance.new("TextLabel")
    summary.Size = UDim2.new(1, -28, 0, 34)
    summary.Position = UDim2.new(0, 14, 0, 72)
    summary.BackgroundColor3 = nxTheme("Inline", Color3.fromRGB(29, 30, 36))
    summary.BorderSizePixel = 0
    summary.TextColor3 = nxTheme("Dark Text", Color3.fromRGB(108, 109, 116))
    summary.TextSize = 12
    summary.TextXAlignment = Enum.TextXAlignment.Left
    nxUseFont(summary, Enum.Font.Gotham)
    summary.Parent = main
    nxCorner(summary, 9)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -28, 1, -124)
    scroll.Position = UDim2.new(0, 14, 0, 114)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = nxTheme("Dark Icon", Color3.fromRGB(64, 64, 73))
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    local padding = Instance.new("UIPadding")
    padding.PaddingBottom = UDim.new(0, 8)
    padding.Parent = scroll

    local function rebuild()
        for _, obj in pairs(scroll:GetChildren()) do
            if obj ~= layout and obj ~= padding then
                obj:Destroy()
            end
        end

        local items = TA_GetInventoryData(plr)
        summary.Text = "   " .. #items .. " objet(s) dans le backpack"

        if #items == 0 then
            TA_CreateEmptyLabel(scroll)
        else
            for _, item in ipairs(items) do
                TA_MakeInventoryCard(scroll, item)
            end
        end
    end

    close.MouseButton1Click:Connect(function()
        TA_CloseInventoryPopup()
    end)

    refresh.MouseButton1Click:Connect(function()
        rebuild()
        notify("Inventaire", "Refresh", 1)
    end)

    shadow.MouseButton1Click:Connect(function()
        TA_CloseInventoryPopup()
    end)

    local dragging = false
    local dragStart = nil
    local startPos = nil

    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)

    top.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and main and main.Parent and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    rebuild()
end

SecTarget:Button({
    Name = "Inventaire",
    Callback = function()
        if not selectedTarget then
            notify("Inventaire", "Aucune cible !", 2)
            return
        end

        TA_ShowInventoryPopup(selectedTarget)
    end,
})


SecTarget:Button({
    Name="TP → Joueur",
    Callback=function()
        if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
        local m=getHRP(); local r=selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if m and r then m.CFrame=r.CFrame+Vector3.new(0,3,2); notify("TP","→ "..selectedTarget.Name,2)
        else notify("Erreur",selectedTarget.Name.." introuvable !",2) end
    end,
})

local spectateConn=nil; local spectating=false
SecTarget:Toggle({
    Name="Spectate",Flag="SpectateToggle",Default=false,
    Callback=function(v)
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
        else local cam=getCam(); cam.CameraType=Enum.CameraType.Custom; notify("Spectate","OFF",2) end
    end,
})

-- ── TROLL OPTION ──────────────────────────────────────────────
local SecTroll=PageOnline:Section({Name="TROLL OPTION",Side=2})

SecTroll:Toggle({
    Name="Orbit Mode",Flag="OrbitPlayer",Default=false,
    Callback=function(v)
        if v then
            if not selectedTarget then notify("Erreur","Aucune cible !",2) return end
            startOrbit(selectedTarget)
        else
            stopOrbit()
        end
    end,
})

SecTroll:Slider({Name="Orbit Rayon",Flag="OrbitRadius",Min=2,Max=30,Default=6,Decimals=1,Callback=function(v) orbitRadius=v end})
SecTroll:Slider({Name="Orbit Vitesse",Flag="OrbitSpeed",Min=0.1,Max=10,Default=1.5,Decimals=1,Callback=function(v) orbitSpeed=v end})

local carsAttackActive=false
SecTroll:Button({
    Name="TP (car) ← Joueur",
    Callback=function()
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
SecTroll:Button({
    Name="CARFUCK !",
    Callback=function()
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
                        local targetCF = targetHRP.CFrame

-- Placement dans la longueur devant/derrière la cible
local pos1 = targetCF * CFrame.new(0, 2, -7)
local pos2 = targetCF * CFrame.new(0, 2, 7)

if not carFuckActive then break end
tpVehicleTo(pos1)
task.wait(carFuckInterval)

if not carFuckActive then break end
tpVehicleTo(pos2)
task.wait(carFuckInterval)
                    end
                end
                local myRoot=getHRP(); if myRoot then tpVehicleTo(myRoot.Position+Vector3.new(4,2,0)) end
                notify("CARFUCK","Arrêté.",2)
            end)
        else notify("CARFUCK","Arrêt en cours...",2) end
    end,
})

SecTroll:Slider({
    Name="Vitesse CARFUCK",Flag="CarFuckSpeed",Min=1,Max=20,Default=4,Decimals=1,
    Callback=function(v) carFuckInterval=v/10; notify("CARFUCK","Intervalle : "..carFuckInterval.."s",1,0.5) end,
})

local limbarActive=false
SecTroll:Button({
    Name="LIMBAR PLAYERS !",
    Callback=function()
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

SecTroll:Button({
    Name="Stop LIMBAR",
    Callback=function()
        if limbarActive then limbarActive=false; stopTouchFling(); notify("LIMBAR","Arrêté manuellement.",2)
        else notify("LIMBAR","LIMBAR n'est pas actif.",2) end
    end,
})

-- ── PAGE 3 : TELEPORT ─────────────────────────────────────────
local PageTP=Window:Page({Icon="rbxassetid://137783165137735"})
local SecTPClic=PageTP:Section({Name="TP Clic",Side=1})

local tpClicEnabled=false; local tpClicConn=nil
SecTPClic:Toggle({
    Name="TP Clic ON/OFF",Flag="TpClic",Default=false,
    Callback=function(v)
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

-- ══════════════════════════════════════
--  TP SPAWN ZONES PLAYER
-- ══════════════════════════════════════
local function tpToSpawnZone(zoneNumber)
    local myRoot = getHRP()
    if not myRoot then
        notify("Spawn "..zoneNumber, "Personnage introuvable !", 2)
        return
    end

    local systems = workspace:FindFirstChild("Systems")
    local spawnZones = systems and systems:FindFirstChild("SpawnZones")
    local zone = spawnZones and spawnZones:FindFirstChild("Zone"..zoneNumber)
    local playerFolder = zone and zone:FindFirstChild("PLAYER")

    if not playerFolder then
        notify("Spawn "..zoneNumber, "Zone"..zoneNumber..".PLAYER introuvable !", 2)
        return
    end

    local spawns = {}

    for _, obj in pairs(playerFolder:GetDescendants()) do
        if obj:IsA("SpawnLocation") or (obj:IsA("BasePart") and obj.Name == "SpawnLocation") then
            table.insert(spawns, obj)
        end
    end

    if #spawns == 0 then
        notify("Spawn "..zoneNumber, "Trop loin : spawn non chargé", 2)
        return
    end

    local chosenSpawn = spawns[math.random(1, #spawns)]
    myRoot.CFrame = chosenSpawn.CFrame + Vector3.new(0, 5, 0)

    notify("Spawn "..zoneNumber, "Téléporté !", 2)
end

-- ══════════════════════════════════════
--  CHOIX SPAWN ZONE
-- ══════════════════════════════════════
local spawnDropdownReady = false

local function tpToSpawnZone(zoneNumber)
    local myRoot = getHRP()
    if not myRoot then
        notify("Spawn "..zoneNumber, "Personnage introuvable !", 2)
        return
    end

    local systems = workspace:FindFirstChild("Systems")
    local spawnZones = systems and systems:FindFirstChild("SpawnZones")
    local zone = spawnZones and spawnZones:FindFirstChild("Zone"..zoneNumber)
    local playerFolder = zone and zone:FindFirstChild("PLAYER")

    if not playerFolder then
        notify("Spawn "..zoneNumber, "Zone"..zoneNumber..".PLAYER introuvable !", 2)
        return
    end

    local spawns = {}

    for _, obj in pairs(playerFolder:GetDescendants()) do
        if obj:IsA("SpawnLocation") or (obj:IsA("BasePart") and obj.Name == "SpawnLocation") then
            table.insert(spawns, obj)
        end
    end

    if #spawns == 0 then
        notify("Spawn "..zoneNumber, "Trop loin : spawn non chargé", 2)
        return
    end

    local chosenSpawn = spawns[math.random(1, #spawns)]
    myRoot.CFrame = chosenSpawn.CFrame + Vector3.new(0, 5, 0)

    notify("Spawn "..zoneNumber, "Téléporté !", 2)
end

local SpawnNames = {
    ["Fontaine"] = 1,
    ["PN"] = 2,
    ["DOCP"] = 3,
    ["Banque"] = 4,
    ["Musée"] = 5,
}

SecTPClic:Dropdown({
    Name = "Choisir un Spawn",
    Flag = "SpawnZoneChoice",
    Items = { "Fontaine", "PN", "DOCP", "Banque", "Musée" },
    Default = "Fontaine",
    Callback = function(v)
        if not spawnDropdownReady then return end

        local zoneNumber = SpawnNames[tostring(v)]
        if not zoneNumber then
            notify("Spawn", "Choix invalide !", 2)
            return
        end

        tpToSpawnZone(zoneNumber)
    end,
})

task.defer(function()
    spawnDropdownReady = true
end)

SecTPClic:Button({
    Name="TP Vendeur arme",
    Callback=function()
        local myRoot = getHRP()
        if not myRoot then
            notify("TP Vendeur", "Personnage introuvable !", 2)
            return
        end

        local pnjFolder = workspace:FindFirstChild("Systems")
            and workspace.Systems:FindFirstChild("PNJ")

        if not pnjFolder then
            notify("TP Vendeur", "Dossier PNJ introuvable !", 2)
            return
        end

        local closestPNJ = nil
        local closestDist = math.huge

        for _, pnj in pairs(pnjFolder:GetChildren()) do
            if pnj.Name == "PNJ Vendeur" then
                local part = nil

                if pnj:IsA("Model") then
                    part = pnj:FindFirstChild("HumanoidRootPart")
                        or pnj.PrimaryPart
                        or pnj:FindFirstChildWhichIsA("BasePart", true)
                elseif pnj:IsA("BasePart") then
                    part = pnj
                end

                if part then
                    local dist = (myRoot.Position - part.Position).Magnitude

                    if dist < closestDist then
                        closestDist = dist
                        closestPNJ = part
                    end
                end
            end
        end

        if not closestPNJ then
            notify("TP Vendeur", "Aucun PNJ Vendeur trouvé !", 2)
            return
        end

        myRoot.CFrame = CFrame.new(closestPNJ.Position + Vector3.new(0, 3, 0))
        notify("TP Vendeur", "Téléporté au vendeur arme !", 2)
    end,
})


local SecVehTP=PageTP:Section({Name="TP Véhicule au clic",Side=2})

local vehTPEnabled=false; local vehTPConn=nil
SecVehTP:Toggle({
    Name="TP Véhicule au clic",Flag="VehTP",Default=false,
    Callback=function(v)
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
local PageVisual=Window:Page({Icon="rbxassetid://85403342431888"})
local SecESPMaster=PageVisual:Section({Name="TrackAll — Master",Side=1})

SecESPMaster:Toggle({
    Name="TrackAll ON/OFF",Flag="TrackAll",Default=false,
    Callback=function(v)
        trackOn=v
        if v then
            for _,p in pairs(Players:GetPlayers()) do if p~=LP and p.Character then ensureESP(p,p.Character) end end
            notify("TrackAll","ON",2)
        else
            for _,p in pairs(Players:GetPlayers()) do cleanESP(p) end
            notify("TrackAll","OFF",2)
        end
    end,
})

SecESPMaster:Slider({Name="Distance max ESP",Flag="ESPMaxDist",Min=10,Max=5000,Default=1000,Decimals=1,Callback=function(v) espMaxDistance=v; notify("ESP Distance","Affiche jusqu'à "..v.."m",1,0.8) end})

SecESPMaster:Button({
    Name="Refresh manuel ESP",
    Callback=function()
        if not trackOn then notify("Erreur","Active TrackAll d'abord !",2) return end
        for _,p in pairs(Players:GetPlayers()) do cleanESP(p) end
        task.wait(0.3)
        for _,p in pairs(Players:GetPlayers()) do if p~=LP and p.Character then ensureESP(p,p.Character) end end
        notify("ESP","Rafraîchi !",2)
    end,
})

SecESPMaster:Toggle({Name="Health ESP",Flag="ESPHealth",Default=true,Callback=function(v) espOptions.health=v end})
SecESPMaster:Toggle({Name="Name ESP",Flag="ESPName",Default=true,Callback=function(v) espOptions.name=v end})
SecESPMaster:Toggle({Name="Distance ESP",Flag="ESPDist",Default=true,Callback=function(v) espOptions.distance=v end})

SecESPMaster:Toggle({
    Name="STAFF Detect",Flag="STAFFDetect",Default=false,
    Callback=function(v)
        STAFFDetectOn=v
        if v then
            if not trackOn then
                trackOn=true
                for _,p in pairs(Players:GetPlayers()) do if p~=LP and p.Character then ensureESP(p,p.Character) end end
                notify("TrackAll","Activé automatiquement",2)
            end
            playerSnapshots={}; notify("STAFF Detect","ON",3)
        else
            notify("STAFF Detect","OFF",2)
            for _,plr in pairs(Players:GetPlayers()) do
                local obj=espObjects[plr.Name]
                if obj and obj.highlight and obj.highlight.Parent then
                    obj.highlight.FillColor=Color3.fromRGB(255,255,255); obj.highlight.OutlineColor=Color3.fromRGB(255,255,255)
                end
            end
            playerSnapshots={}
        end
    end,
})

SecESPMaster:Toggle({
    Name="NOTIFICATIONS",Flag="StaffNotifications",Default=false,
    Callback=function(v)
        staffNotificationsOn = v
        staffNotifyLast = {}
        staffNotifyInside = {}

        if v then
            if not STAFFDetectOn then
                STAFFDetectOn = true
                notify("STAFF Detect","ON automatiquement",2)
            end

            if not trackOn then
                trackOn = true
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        ensureESP(p, p.Character)
                    end
                end
                notify("TrackAll","Activé automatiquement",2)
            end

            notify("STAFF Notifications","ON — alerte si STAFF à moins de "..STAFF_NOTIFY_DISTANCE.."m",3)
        else
            notify("STAFF Notifications","OFF",2)
        end
    end,
})

local SecLighting=PageVisual:Section({Name="Lighting",Side=2})

SecLighting:Toggle({Name="Remove Fog",Flag="NoFog",Default=false,Callback=function(v) Lighting.FogEnd=v and 1e6 or 1000; Lighting.FogStart=v and 1e6 or 0 end})
SecLighting:Toggle({
    Name="Fullbright",Flag="Fullbright",Default=false,
    Callback=function(v)
        Lighting.Brightness=v and 10 or 1; Lighting.ClockTime=v and 14 or 12
        Lighting.Ambient=v and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
    end,
})
SecLighting:Slider({Name="FOV",Flag="FOV",Min=60,Max=120,Default=70,Decimals=1,Callback=function(v) getCam().FieldOfView=v end})

local SecAnim=PageVisual:Section({Name="Animations",Side=2})

local ANIMS={{"Robot Dance","507766388"},{"Floss","5915693312"},{"Samba","507776879"},{"Wave","507770239"},
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
for _,a in ipairs(ANIMS) do table.insert(animValues,a[1]) end

SecAnim:Dropdown({Name="Choisir une animation",Flag="AnimSelect",Items=animValues,Default=animValues[1],
    Callback=function(v) for _,a in ipairs(ANIMS) do if a[1]==v then playAnim(a[2]); break end end end})
SecAnim:Button({Name="Stop l'animation",Callback=function()
    if currentAnim then pcall(function() currentAnim:Stop() end); currentAnim=nil; notify("Animation","Arrêtée",2)
    else notify("Animation","Aucune anim en cours",2) end
end})
SecAnim:Textbox({Name="ID Custom",Flag="CustomAnim",Placeholder="507766388",Finished=true,
    Callback=function(id) if id and id~="" then playAnim(id) end end})



-- ── PAGE 5 : VEHICLE OPTIONS ─────────────────────────────────
local PageVehicle=Window:Page({Icon="rbxassetid://137783165137735"})
local SecCar=PageVehicle:Section({Name="Vehicle Options",Side=1})

-- ── Accélération / freinage véhicule ─────────────────────────
SecCar:Toggle({
    Name="Keybinds Active",Flag="VehicleKeybindsActive",Default=true,
    Callback=function(v)
        velocityEnabled = v
        notify("Vehicle Speed", v and "Keybinds ON" or "Keybinds OFF", 2)
    end,
})

SecCar:Slider({
    Name="Vehicle Speed",Flag="VehicleSpeed",Min=0,Max=50,Default=25,Decimals=1,
    Callback=function(v)
        applyVehicleSpeed(v / 1000)
        notify("Vehicle Speed", tostring(v) .. "/1000 — maintiens W en voiture", 2, 0.8)
    end,
})

SecCar:Slider({
    Name="Brake Force",Flag="VehicleBrake",Min=0,Max=300,Default=150,Decimals=1,
    Callback=function(v)
        setVehicleBrake(v / 1000)
        notify("Vehicle Brake", tostring(v) .. "/1000 — maintiens S pour freiner", 2, 0.8)
    end,
})

SecCar:Button({
    Name="Stop Vehicle (P)",
    Callback=function()
        stopCurrentVehicle()
        notify("Véhicule", "Stop net appliqué !", 2)
    end,
})

-- ── Vehicle Fly ───────────────────────────────────────────────
SecCar:Toggle({
    Name="Vehicle Fly (RightCtrl)",Flag="VehFly",Default=false,
    Callback=function(v)
        if v then
            startVehFly()
        else
            if vehFlyActive then stopVehFly() end
        end
    end,
})

SecCar:Slider({
    Name="Veh Fly Speed",Flag="VehFlySpeed",
    Min=10,Max=800,Default=100,Decimals=1,
    Callback=function(v)
        vehFlySpeed = v / 100
        notify("Veh Fly Speed", tostring(v) .. "/100", 1, 0.8)
    end,
})

SecCar:Button({
    Name="Refresh Vehicle",
    Callback=function()
        if detectVehicle() and detectedVehicle then
            notify("Véhicule", "Verrouillé : " .. detectedVehicle.Name, 2)
        else
            notify("Erreur", "Aucun véhicule détecté !", 3)
        end
    end,
})



-- ── PAGE 6 : MISC ─────────────────────────────────────────────
local PageMisc=Window:Page({Icon="rbxassetid://133965452418408"})
local SecMusic=PageMisc:Section({Name="Musique",Side=1})

SecMusic:Toggle({
    Name="Musique ON/OFF",Flag="MusicToggle",Default=true,
    Callback=function(v) if v then bgMusic:Play(); notify("Musique","ON",2) else bgMusic:Stop(); notify("Musique","OFF",2) end end,
})
SecMusic:Slider({Name="Volume",Flag="MusicVolume",Min=0,Max=100,Default=50,Decimals=1,
    Callback=function(v) bgMusic.Volume=v/100; notify("Volume",v.."%",1,0.6) end})

local SecScripts=PageMisc:Section({Name="Scripts externes",Side=2})

SecScripts:Button({Name="SystemBroken",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GZSSF/script3/95a45577475502cfbf546ae9ca8fc4f00b61eb83/script3"))()
    notify("Scripts","SystemBroken exécuté !",2)
end})

SecScripts:Button({Name="Infinite Yield",Callback=function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    notify("Scripts","Infinite Yield exécuté !",2)
end})

SecScripts:Button({Name="DEX Explorer",Callback=function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-dex-explorer-fixed-for-velocity-236826"))()
    notify("Scripts","DEX exécuté !",2)
end})



-- ══════════════════════════════════════
--  INIT
-- ══════════════════════════════════════
do
    local VU=game:GetService("VirtualUser")
    LP.Idled:Connect(function() VU:Button2Down(Vector2.zero,getCam().CFrame); task.wait(1); VU:Button2Up(Vector2.zero,getCam().CFrame) end)
end

notify("Panel Wars","Menu chargé ! — By FocusOnTop | Numpad8 = Freecam | RightCtrl = Veh Fly",5)
