--[[
    Basic GUI Script for Roblox (Rayfield)
    Feito por VEXNAAG39
    Carregue com: loadstring(game:HttpGet("https://raw.githubusercontent.com/VEXNAAG39/super-tribble/main/HackMenuV1.lua"))()
    Apenas GUI, sem funções extras.
    Inclui efeito de abertura bonito e leve.
    Compatível com a maioria dos executores.
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Corrige para evitar problemas de duplicidade no CoreGui
local CG = game:GetService("CoreGui")
local rayfield = CG:FindFirstChild("Rayfield")
if rayfield then rayfield:Destroy() end

-- Carrega Rayfield GUI
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua", true))()
end)
if not success then
    warn("Erro ao carregar Rayfield:", err)
    return
end

repeat task.wait() until CG:FindFirstChild("Rayfield")
local Rayfield = require(CG:FindFirstChild("Rayfield"))

local Window = Rayfield:CreateWindow({
    Name = "Basic GUI",
    LoadingTitle = "Carregando interface...",
    LoadingSubtitle = "Bem-vindo!",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
    Icon = "rbxassetid://14528995720"
})

local MainTab = Window:CreateTab("Principal", 14528995720)

MainTab:CreateLabel("Exemplo de GUI básica.")

MainTab:CreateButton({
    Name = "Clique aqui!",
    Callback = function()
        Rayfield:Notify({
            Title = "Sucesso!",
            Content = "Você clicou no botão!",
            Duration = 2,
            Image = "rbxassetid://14528995720"
        })
    end,
})

MainTab:CreateLabel("Interface leve e rápida.")
