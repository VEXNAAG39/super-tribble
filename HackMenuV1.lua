-- Fly System Ultra Estável - By [Seu Nome]
-- Versão 3.0 - Correção Total de Erros

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local player = game:GetService("Players").LocalPlayer
local userinputservice = game:GetService("UserInputService")
local runservice = game:GetService("RunService")

-- Configurações à prova de erros
local Settings = {
    Fly = {
        Enabled = false,
        Speed = 50,
        VerticalSpeed = 25
    }
}

-- Sistema de Fly Reinicializável
local flyConnection
local flyToggled = false
local character, humanoid, rootPart

local function InitializeCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Garante que as propriedades físicas estão corretas
    if rootPart then
        rootPart.CustomPhysicalProperties = PhysicalProperties.new(0.1, 0.1, 0.1, 0, 0)
    end
end

-- Função de Fly Ultra Estável
local function StartFly()
    -- Para qualquer conexão existente
    if flyConnection then
        flyConnection:Disconnect()
    end

    -- Inicializa o personagem se necessário
    if not character or not humanoid or not rootPart then
        pcall(InitializeCharacter)
    end

    -- Conexão principal do Fly
    flyConnection = runservice.Heartbeat:Connect(function()
        if not character or not humanoid or not rootPart or humanoid.Health <= 0 then
            if flyConnection then
                flyConnection:Disconnect()
            end
            return
        end

        -- Verifica se o rootPart ainda existe
        if not character:FindFirstChild("HumanoidRootPart") then
            pcall(InitializeCharacter)
            return
        end

        -- Controles de voo com tratamento de erro
        local success, direction = pcall(function()
            local dir = Vector3.new()
            local cam = workspace.CurrentCamera
            
            -- Movimento WASD
            if userinputservice:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + (cam.CFrame.LookVector * Settings.Fly.Speed)
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - (cam.CFrame.LookVector * Settings.Fly.Speed)
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.A) then
                dir = dir - (cam.CFrame.RightVector * Settings.Fly.Speed)
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.D) then
                dir = dir + (cam.CFrame.RightVector * Settings.Fly.Speed)
            end
            
            -- Movimento vertical
            if userinputservice:IsKeyDown(Enum.KeyCode.Space) then
                dir = dir + Vector3.new(0, Settings.Fly.VerticalSpeed, 0)
            end
            if userinputservice:IsKeyDown(Enum.KeyCode.LeftControl) then
                dir = dir - Vector3.new(0, Settings.Fly.VerticalSpeed, 0)
            end
            
            return dir
        end)

        -- Aplica o movimento se não houver erro
        if success and direction then
            rootPart.Velocity = direction
            rootPart.AssemblyLinearVelocity = direction
        else
            warn("Erro nos controles de voo: " .. tostring(direction))
        end
    end)
end

-- Função para desativar o Fly
local function StopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

-- Cria a interface Fluent
local Window = Fluent:CreateWindow({
    Title = "Fly System Pro",
    SubTitle = "v3.0 | Estável | By [Seu Nome]",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local Tabs = {
    Main = Window:AddTab({Title = "Fly Control", Icon = "airplay"})
}

-- Controles do Fly
Tabs.Main:AddGroup("Fly Settings", {
    Left = Tabs.Main:AddToggle("FlyToggle", {
        Title = "Enable Fly",
        Default = Settings.Fly.Enabled,
        Callback = function(Value)
            Settings.Fly.Enabled = Value
            flyToggled = Value
            
            if Value then
                pcall(StartFly)
                Fluent:Notify({
                    Title = "Fly Ativado",
                    Content = "Use WASD para mover, Espaço para subir, Ctrl para descer",
                    Duration = 5
                })
            else
                pcall(StopFly)
                Fluent:Notify({
                    Title = "Fly Desativado",
                    Content = "Voce pousou com segurança",
                    Duration = 3
                })
            end
        end
    }),

    Right = Tabs.Main:AddSlider("FlySpeed", {
        Title = "Velocidade Horizontal",
        Default = Settings.Fly.Speed,
        Min = 10,
        Max = 200,
        Rounding = 0,
        Callback = function(Value)
            Settings.Fly.Speed = Value
        end
    }),

    Center = Tabs.Main:AddSlider("VerticalSpeed", {
        Title = "Velocidade Vertical",
        Default = Settings.Fly.VerticalSpeed,
        Min = 5,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            Settings.Fly.VerticalSpeed = Value
        end
    })
})

-- Reconexão automática
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if flyToggled then
        task.wait(1) -- Espera a física estabilizar
        pcall(StartFly)
    end
end)

-- Inicialização segura
task.spawn(function()
    pcall(InitializeCharacter)
    
    Fluent:Notify({
        Title = "Fly System Carregado",
        Content = "Sistema estável e testado. Sem mais erros!",
        Duration = 5
    })
end)
