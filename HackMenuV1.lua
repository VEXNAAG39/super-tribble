--[[
    GUI Básica para Roblox (Rayfield) - Versão Corrigida
    Feito por VEXNAAG39
    Carregue com: loadstring(game:HttpGet("LINK_DO_RAW_AQUI"))()
]]

-- Espera o jogo carregar
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Carrega a biblioteca Rayfield
local Rayfield = nil
local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end)

if not success then
    warn("Falha ao carregar Rayfield: "..tostring(err))
    return
end

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
    Name = "Basic GUI",
    LoadingTitle = "Carregando interface...",
    LoadingSubtitle = "Bem-vindo!",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Configurações da GUI"
    },
    Discord = {
        Enabled = false,
        Invite = "semconvite",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Cria a aba principal
local MainTab = Window:CreateTab("Principal", 14528995720) -- Ícone opcional

-- Adiciona elementos
MainTab:CreateLabel("Exemplo de GUI básica.")

MainTab:CreateButton({
    Name = "Clique aqui!",
    Callback = function()
        Rayfield:Notify({
            Title = "Sucesso!",
            Content = "Você clicou no botão!",
            Duration = 6.5,
            Image = 14528995720,
            Actions = {
                Ignore = {
                    Name = "Ok",
                    Callback = function()
                        print("Usuário clicou em Ok")
                    end
                },
            },
        })
    end,
})

MainTab:CreateLabel("Interface leve e rápida.")

print("GUI carregada com sucesso!")
