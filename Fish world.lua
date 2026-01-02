--// Rod Throw Controller (FIXED UI)
--// Claude 9.9 Stable Version

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = require(ReplicatedStorage.client.Modules.RemoteEventClient)

local vector3_zero = Vector3.zero

-- =========================
-- GUI SETUP
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "RodThrowGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 260) -- FIX HEIGHT
frame.Position = UDim2.new(0.5, -130, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = false
frame.ZIndex = 10

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Fish World - Dupe Fish🐟 - Rey_Script Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.ZIndex = 11

-- Speed Box
local speedBox = Instance.new("TextBox")
speedBox.Parent = frame
speedBox.Position = UDim2.new(0.1, 0, 0, 45)
speedBox.Size = UDim2.new(0.8, 0, 0, 35)
speedBox.PlaceholderText = "Delay (contoh: 0.3)"
speedBox.Text = "0.3"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.ZIndex = 11
Instance.new("UICorner", speedBox)

-- Manual Button
local manualBtn = Instance.new("TextButton")
manualBtn.Parent = frame
manualBtn.Position = UDim2.new(0.1, 0, 0, 90)
manualBtn.Size = UDim2.new(0.8, 0, 0, 40)
manualBtn.Text = "MANUAL FIRE"
manualBtn.Font = Enum.Font.GothamBold
manualBtn.TextSize = 14
manualBtn.TextColor3 = Color3.fromRGB(255,255,255)
manualBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 220)
manualBtn.ZIndex = 11
Instance.new("UICorner", manualBtn)

-- Loop Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = frame
toggleBtn.Position = UDim2.new(0.1, 0, 0, 140)
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Text = "START LOOP"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 170, 60)
toggleBtn.ZIndex = 11
Instance.new("UICorner", toggleBtn)

-- =========================
-- LOGIC
-- =========================
local looping = false

local function fireOnce()
    remotes:GetRemoteEvent("RodThrow").dispatch:FireServer({
        vector3_zero,
        vector3_zero,
        9e9,
        false
    })

    remotes:GetRemoteEvent("EndStruggle").dispatch:FireServer({
        true,
        vector3_zero
    })
end

manualBtn.MouseButton1Click:Connect(function()
    fireOnce()
end)

toggleBtn.MouseButton1Click:Connect(function()
    looping = not looping

    if looping then
        toggleBtn.Text = "STOP LOOP"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)

        task.spawn(function()
            while looping do
                local delayTime = tonumber(speedBox.Text) or 0.3
                delayTime = math.clamp(delayTime, 0.05, 5)

                fireOnce()
                task.wait(delayTime)
            end
        end)
    else
        toggleBtn.Text = "START LOOP"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 170, 60)
    end
end)
