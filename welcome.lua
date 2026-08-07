local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local MESSAGE = "Bienvenue " .. player.Name
local SIGNATURE = "TelAviv Menu - Staff"

local DISPLAY_TIME = 5
local FADE_TIME = 0.45

-- Plus la valeur est basse, plus le fond est sombre
-- 0 = totalement opaque
-- 1 = totalement transparent
local FINAL_BACKGROUND_TRANSPARENCY = 0.35

-- Supprime une ancienne annonce si le script est relancé
local oldGui = playerGui:FindFirstChild("ANNOUCEMENT_STAFF")

if oldGui then
	oldGui:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ANNOUCEMENT_STAFF"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = true
screenGui.DisplayOrder = 10000
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principal
local frame = Instance.new("Frame")
frame.Name = "Frame"

frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(1, 0, 1, 0)

frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Invisible au début
frame.BackgroundTransparency = 1

frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
frame.BorderSizePixel = 0

frame.Visible = true
frame.ZIndex = 1
frame.Parent = screenGui

-- "Annonce du staff"
local staffTitle = Instance.new("TextLabel")
staffTitle.Name = "TextLabel1"

staffTitle.Position = UDim2.new(
	0.284, 0,
	0.042, 0
)

staffTitle.Size = UDim2.new(
	0.433, 0,
	0.102, 0
)

staffTitle.BackgroundTransparency = 1
staffTitle.Text = "Annonce du staff"
staffTitle.TextColor3 = Color3.fromRGB(255, 0, 0)

staffTitle.FontFace = Font.new(
	"rbxasset://fonts/families/Arial.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)

staffTitle.TextScaled = true
staffTitle.TextWrapped = true

staffTitle.TextXAlignment = Enum.TextXAlignment.Center
staffTitle.TextYAlignment = Enum.TextYAlignment.Center

staffTitle.TextTransparency = 1
staffTitle.TextStrokeTransparency = 1

staffTitle.ZIndex = 2
staffTitle.Parent = frame

-- Description
local description = Instance.new("TextLabel")
description.Name = "TextLabel"

description.Position = UDim2.new(
	0.284, 0,
	0.136, 0
)

description.Size = UDim2.new(
	0.433, 0,
	0.045, 0
)

description.BackgroundTransparency = 1

description.Text =
	"Il s'agit d'une annonce officielle concernant tous les joueurs"

description.TextColor3 = Color3.fromRGB(255, 0, 0)

description.FontFace = Font.new(
	"rbxasset://fonts/families/Arial.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Italic
)

description.TextScaled = true
description.TextWrapped = true

description.TextXAlignment = Enum.TextXAlignment.Center
description.TextYAlignment = Enum.TextYAlignment.Center

description.TextTransparency = 1
description.TextStrokeTransparency = 1

description.ZIndex = 2
description.Parent = frame

-- Message principal
local announce = Instance.new("TextLabel")
announce.Name = "Announce"

announce.Position = UDim2.new(
	0.219, 0,
	0.213, 0
)

announce.Size = UDim2.new(
	0.561, 0,
	0.621, 0
)

announce.BackgroundTransparency = 1
announce.Text = MESSAGE
announce.TextColor3 = Color3.fromRGB(255, 255, 255)

announce.FontFace = Font.new(
	"rbxasset://fonts/families/Arial.json",
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal
)

announce.TextSize = 30
announce.TextScaled = false
announce.TextWrapped = true

announce.TextXAlignment = Enum.TextXAlignment.Center
announce.TextYAlignment = Enum.TextYAlignment.Center

announce.TextTransparency = 1
announce.TextStrokeTransparency = 1

announce.ZIndex = 2
announce.Parent = frame

-- Signature
local signature = Instance.new("TextLabel")
signature.Name = "Signature"

signature.Position = UDim2.new(
	0.284, 0,
	0.914, 0
)

signature.Size = UDim2.new(
	0.433, 0,
	0.032, 0
)

signature.BackgroundTransparency = 1

signature.Text = SIGNATURE
signature.TextColor3 = Color3.fromRGB(255, 0, 0)

signature.FontFace = Font.new(
	"rbxasset://fonts/families/Arial.json",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Italic
)

signature.TextScaled = true
signature.TextWrapped = true

signature.TextXAlignment = Enum.TextXAlignment.Center
signature.TextYAlignment = Enum.TextYAlignment.Center

signature.TextTransparency = 1
signature.TextStrokeTransparency = 1

signature.ZIndex = 2
signature.Parent = frame

-- Image
local image = Instance.new("ImageLabel")
image.Name = "ImageLabel"

image.Position = UDim2.new(
	0.896, 0,
	0.882, 0
)

image.Size = UDim2.new(
	0.092, 0,
	0.1, 0
)

image.BackgroundTransparency = 1
image.Image = "rbxassetid://11209953879"

image.ImageColor3 = Color3.fromRGB(255, 255, 255)
image.ImageTransparency = 1

image.ScaleType = Enum.ScaleType.Fit

image.ZIndex = 2
image.Parent = frame

-- Animation
local tweenInInfo = TweenInfo.new(
	FADE_TIME,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local tweenOutInfo = TweenInfo.new(
	FADE_TIME,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In
)

local textObjects = {
	staffTitle,
	description,
	announce,
	signature
}

-- Apparition du fond
TweenService:Create(
	frame,
	tweenInInfo,
	{
		BackgroundTransparency = FINAL_BACKGROUND_TRANSPARENCY
	}
):Play()

-- Apparition des textes
for _, object in ipairs(textObjects) do
	TweenService:Create(
		object,
		tweenInInfo,
		{
			TextTransparency = 0
		}
	):Play()
end

-- Apparition de l'image
TweenService:Create(
	image,
	tweenInInfo,
	{
		ImageTransparency = 0
	}
):Play()

-- Temps d'affichage
task.wait(DISPLAY_TIME)

-- Disparition du fond
TweenService:Create(
	frame,
	tweenOutInfo,
	{
		BackgroundTransparency = 1
	}
):Play()

-- Disparition des textes
for _, object in ipairs(textObjects) do
	TweenService:Create(
		object,
		tweenOutInfo,
		{
			TextTransparency = 1
		}
	):Play()
end

-- Disparition de l'image
local imageOut = TweenService:Create(
	image,
	tweenOutInfo,
	{
		ImageTransparency = 1
	}
)

imageOut:Play()
imageOut.Completed:Wait()

-- Nettoyage
screenGui:Destroy()
