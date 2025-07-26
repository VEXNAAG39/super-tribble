--[[ 
    Hack Menu v1.0 - Script para executores Roblox
    Feito com Rayfield GUI
    Créditos: github.com/VEXNAAG39
    Para carregar remotamente: 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VEXNAAG39/super-tribble/main/HackMenuV1.lua"))()
]]

-- [ SEÇÃO 1 - CARREGAR RAYFIELD ]
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local RayfieldLoaded = false
if not game:GetService("CoreGui"):FindFirstChild("Rayfield") then
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
        RayfieldLoaded = true
    end)
else
    RayfieldLoaded = true
end

-- [ SEÇÃO 2 - CHECAR LOCALPLAYER ]
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
if not lp or not lp.Character then
    return warn("LocalPlayer não encontrado! Reinicie o script.")
end

-- [ SEÇÃO 3 - VARIÁVEIS DE HACKS ]
local originalWalkSpeed = lp.Character.Humanoid.WalkSpeed
local flyEnabled = false
local autoFarmEnabled = false
local autoFarmThread = nil

-- [ SEÇÃO 4 - FUNÇÕES DOS HACKS ]
local function setWalkSpeed(speed)
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = speed
    end
end

local function resetWalkSpeed()
    setWalkSpeed(originalWalkSpeed)
end

local function flyFunc()
    local UIS = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local flySpeed = 2
    local bodyGyro, bodyVelocity

    local function startFlying()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = char.HumanoidRootPart.CFrame
        bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        Rayfield:Notify({Title = "Fly", Content = "Fly ON!", Duration = 2})
        flyEnabled = true
    end

    local function stopFlying()
        flyEnabled = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        Rayfield:Notify({Title = "Fly", Content = "Fly OFF!", Duration = 2})
    end

    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F then
            if flyEnabled then
                stopFlying()
            else
                startFlying()
            end
        end
    end)

    runService.RenderStepped:Connect(function()
        if flyEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local direction = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0,1,0) end
            if bodyVelocity then
                bodyVelocity.Velocity = direction.Unit * flySpeed * 50
            end
            if bodyGyro then
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        end
    end)
end

local function autoFarmFunc()
    autoFarmThread = coroutine.create(function()
        while autoFarmEnabled do
            pcall(function()
                -- [ADAPTE PARA O JOGO:] Exemplo genérico para coletar itens
                for _,v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("item") and v:IsA("Part") then
                        lp.Character.HumanoidRootPart.CFrame = v.CFrame
                        wait(0.2)
                    end
                end
            end)
            wait(1)
        end
    end)
    coroutine.resume(autoFarmThread)
end

local function stopAutoFarm()
    autoFarmEnabled = false
    Rayfield:Notify({Title = "Auto-Farm", Content = "Auto-Farm OFF!", Duration = 2})
end

-- [ SEÇÃO 5 - GUI RAYFIELD ]
local Rayfield = require(game:GetService("CoreGui"):FindFirstChild("Rayfield"))
local Window = Rayfield:CreateWindow({
    Name = "Hack Menu v1.0",
    LoadingTitle = "Iniciando Hack Menu...",
    LoadingSubtitle = "By VEXNAAG39",
    ConfigurationSaving = {Enabled = true, FolderName = "HackMenu"},
    Discord = {Enabled = false},
    KeySystem = false,
    Icon = "rbxassetid://0" -- Substitua por ID de ícone se quiser
})

local MainTab = Window:CreateTab("Hacks", 4483362458)
MainTab:CreateButton({
    Name = "Speed Hack",
    Callback = function()
        setWalkSpeed(100)
        Rayfield:Notify({Title = "Speed", Content = "Speed Hack ON!", Duration = 2})
    end,
})

MainTab:CreateButton({
    Name = "Reset Speed",
    Callback = function()
        resetWalkSpeed()
        Rayfield:Notify({Title = "Speed", Content = "Speed Hack OFF!", Duration = 2})
    end,
})

MainTab:CreateButton({
    Name = "Fly Hack (Tecla F)",
    Callback = function()
        flyFunc()
    end,
})

MainTab:CreateToggle({
    Name = "Auto-Farm",
    CurrentValue = false,
    Callback = function(v)
        autoFarmEnabled = v
        if v then
            Rayfield:Notify({Title = "Auto-Farm", Content = "Auto-Farm ON!", Duration = 2})
            autoFarmFunc()
        else
            stopAutoFarm()
        end
    end,
})

-- [ SEÇÃO 6 - LIMPAR HACKS AO REINICIAR ]
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    resetWalkSpeed()
    stopAutoFarm()
    flyEnabled = false
end)
