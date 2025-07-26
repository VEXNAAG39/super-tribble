--[[
    Simple Fly Script with GUI & Speed Adjustment
    Feito por VEXNAAG39
    Carregue com: loadstring(game:HttpGet("LINK_DO_RAW_AQUI"))()
    GUI: Rayfield (https://github.com/shlexware/Rayfield)
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Carrega Rayfield GUI
if not game:GetService("CoreGui"):FindFirstChild("Rayfield") then
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
    end)
end
repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield")
local Rayfield = require(game:GetService("CoreGui"):FindFirstChild("Rayfield"))

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local flyEnabled = false
local flySpeed = 50
local bv = nil

local function getHRP()
    return lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
end

local function enableFly()
    if flyEnabled or not getHRP() then return end
    bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, flySpeed, 0)
    bv.Parent = getHRP()
    flyEnabled = true
end

local function disableFly()
    if bv and bv.Parent then bv:Destroy() end
    flyEnabled = false
end

local function updateFlySpeed(val)
    flySpeed = val
    if flyEnabled and bv and bv.Parent then
        bv.Velocity = Vector3.new(0, flySpeed, 0)
    end
end

local Window = Rayfield:CreateWindow({
    Name = "Simple Fly GUI",
    LoadingTitle = "Fly GUI",
    LoadingSubtitle = "By VEXNAAG39",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

local FlyTab = Window:CreateTab("Fly", 14528995720)

FlyTab:CreateToggle({
    Name = "Ativar/Desativar Fly",
    CurrentValue = false,
    Callback = function(val)
        if val then
            enableFly()
        else
            disableFly()
        end
    end,
})

FlyTab:CreateSlider({
    Name = "Velocidade do Fly",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = flySpeed,
    Callback = function(val)
        updateFlySpeed(val)
    end,
})

Players.LocalPlayer.OnTeleport:Connect(function()
    disableFly()
end)
