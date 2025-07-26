

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer

-- Configurações do tema roxo
local PurpleTheme = {
    Main = Color3.fromRGB(94, 0, 161),
    Secondary = Color3.fromRGB(123, 44, 191),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(200, 160, 255)
}

-- Botão externo para abrir/fechar
local ExternalBtn = Instance.new("TextButton")
ExternalBtn.Name = "REDZHubBtn"
ExternalBtn.Text = "REDZ Hub"
ExternalBtn.Size = UDim2.new(0, 120, 0, 40)
ExternalBtn.Position = UDim2.new(0, 10, 0.5, -20)
ExternalBtn.BackgroundColor3 = PurpleTheme.Main
ExternalBtn.TextColor3 = Color3.new(1,1,1)
ExternalBtn.Font = Enum.Font.GothamBold
ExternalBtn.TextSize = 14
ExternalBtn.ZIndex = 1000
ExternalBtn.Parent = game:GetService("CoreGui")

-- Efeitos do botão
ExternalBtn.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(
        ExternalBtn,
        TweenInfo.new(0.3),
        {BackgroundColor3 = PurpleTheme.Secondary}
    ):Play()
end)

ExternalBtn.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        ExternalBtn,
        TweenInfo.new(0.3),
        {BackgroundColor3 = PurpleTheme.Main}
    ):Play()
end)

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
    Name = "REDZ Hub : Blox Fruits",
    LoadingTitle = "Carregando REDZ Hub Premium...",
    LoadingSubtitle = "by real_redz | Versão Roxa",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "REDZConfig",
        FileName = "REDZ_Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
    Theme = PurpleTheme -- Aplica o tema roxo
})

-- Variável para controlar visibilidade
local UIVisible = false

-- Função para alternar UI
local function ToggleUI()
    UIVisible = not UIVisible
    if UIVisible then
        Rayfield:Show()
    else
        Rayfield:Hide()
    end
end

ExternalBtn.MouseButton1Click:Connect(ToggleUI)

-- Abas principais (como no print)
local MainTab = Window:CreateTab("Principal", 7072717932) -- Ícone personalizado
local FarmTab = Window:CreateTab("Farmar", 7072717932)
local FruitTab = Window:CreateTab("Fruta/Raid", 7072717932)
local StatsTab = Window:CreateTab("Stats", 7072717932)
local VisualTab = Window:CreateTab("Visual", 7072717932)
local ShopTab = Window:CreateTab("Loja", 7072717932)

-- Seção "Selecionar Ferramenta" (MainTab)
MainTab:CreateLabel("Selecionar Ferramenta")
MainTab:CreateDropdown({
    Name = "Ferramenta Ativa",
    Options = {"Auto Farm", "Auto Boss", "Auto Raid", "Auto Quest"},
    CurrentOption = "Auto Farm",
    Callback = function(Option)
        print("Ferramenta selecionada:", Option)
    end
})

-- Controle de tamanho da UI
MainTab:CreateSlider({
    Name = "Tamanho da UI",
    Range = {70, 120},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 100,
    Callback = function(Value)
        Window:SetScale(Value/100)
    end
})

-- Seção Farmar (como no print)
FarmTab:CreateToggle({
    Name = "Level Automático",
    CurrentValue = false,
    Callback = function(Value)
        AutoLevelUp(Value)
    end
})

FarmTab:CreateToggle({
    Name = "Farmar Inimigos Próximos",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmNPCs(Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Baus [Tween]",
    CurrentValue = false,
    Callback = function(Value)
        AutoChests(Value)
    end
})

-- Seção Bosses
local BossList = {"Saber Expert", "Darkbeard", "Dough King"}
FarmTab:CreateButton({
    Name = "Atualizar Lista de Bosses",
    Callback = function()
        UpdateBossList()
    end
})

FarmTab:CreateDropdown({
    Name = "Lista de Bosses",
    Options = BossList,
    CurrentOption = BossList[1],
    Callback = function(Option)
        SelectedBoss = Option
    end
})

FarmTab:CreateToggle({
    Name = "Matar Boss Selecionado",
    CurrentValue = false,
    Callback = function(Value)
        AutoKillBoss(Value)
    end
})

-- Funções principais (simplificadas para exemplo)
function AutoLevelUp(state)
    if state then
        print("Level Automático ATIVADO")
        -- Lógica real de level up aqui
    else
        print("Level Automático DESATIVADO")
    end
end

function AutoFarmNPCs(state)
    if state then
        print("Farm de NPCs ATIVADO")
        -- Lógica real de farm aqui
    else
        print("Farm de NPCs DESATIVADO")
    end
end

function AutoChests(state)
    if state then
        print("Auto Baus ATIVADO (Tween)")
        -- Lógica real de coleta de baus aqui
    else
        print("Auto Baus DESATIVADO")
    end
end

function UpdateBossList()
    print("Lista de Bosses atualizada!")
    -- Lógica real para atualizar lista aqui
end

function AutoKillBoss(state)
    if state then
        print("Caçando boss:", SelectedBoss)
        -- Lógica real de boss farm aqui
    else
        print("Caça a boss DESATIVADA")
    end
end

-- Notificação inicial
Rayfield:Notify({
    Title = "REDZ Hub Premium",
    Content = "Interface carregada com sucesso!",
    Duration = 5,
    Image = 7072717932,
    Actions = {
        Ignore = {
            Name = "Ok",
            Callback = function()
                print("Usuário confirmou notificação")
            end
        },
    },
})

-- Esconde a UI inicialmente
Rayfield:Hide()
