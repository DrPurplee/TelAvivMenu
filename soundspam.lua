local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TARGET_NAME = "humaidwesam1"

local Event = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("Packet")
    :WaitForChild("RemoteEvent")

local target = Players:FindFirstChild(TARGET_NAME)

if not target then
    warn("Joueur introuvable :", TARGET_NAME)
    return
end

local character = target.Character or target.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Position actuelle du joueur
local pos = root.Position

-- Trajectoire verticale
local dir = Vector3.new(0, 1, 0)

-- Packet :
-- [1] + Position XYZ + Direction XYZ
local b = buffer.create(25)

buffer.writeu8(b, 0, 1)

buffer.writef32(b, 1, pos.X)
buffer.writef32(b, 5, pos.Y)
buffer.writef32(b, 9, pos.Z)

buffer.writef32(b, 13, dir.X)
buffer.writef32(b, 17, dir.Y)
buffer.writef32(b, 21, dir.Z)

Event:FireServer(b)

print(
    "Packet envoyé",
    "Target:", target.Name,
    "Position:", pos,
    "Direction:", dir
)
