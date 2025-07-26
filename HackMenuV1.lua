--[[
    Basic GUI Script for Roblox (Rayfield)
    Feito por VEXNAAG39
    Carregue com: loadstring(game:HttpGet("https://raw.githubusercontent.com/VEXNAAG39/super-tribble/main/HackMenuV1.lua"))()
    Apenas GUI, sem funções extras.
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

local Window = Rayfield:CreateWindow({
    Name = "Basic GUI",
    LoadingTitle = "Abrindo...",
    LoadingSubtitle = "By VEXNAAG39",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Principal", 14528995720)

MainTab:CreateButton({
    Name = "Clique aqui!",
    Callback = function()
        Rayfield:Notify({Title = "Notificação", Content = "Você clicou no botão!", Duration = 2})
    end,
})

MainTab:CreateLabel("Exemplo de GUI básica.")
