--[[
    Redz Hub - Blox Fruits | Auto-Farm, Teleport & Misc System
    Feito por VEXNAAG39
    Carregue: loadstring(game:HttpGet("LINK_DO_RAW_AQUI"))()
    Estilo inspirado no Redz Hub. Uso modular, seguro e otimizado.

    Requer Rayfield GUI: https://github.com/shlexware/Rayfield
]]

if not game:IsLoaded() then game.Loaded:Wait() end

--[[
    ########### SEGURANÇA E OTIMIZAÇÃO ###########
]]
local Players, Workspace, ReplicatedStorage = game:GetService("Players"), game:GetService("Workspace"), game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local function validChar() return lp and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") and lp.Character:FindFirstChild("HumanoidRootPart") end

-- Anti-Kick básico (simples)
local function antiKick()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        if getnamecallmethod() == "Kick" then
            return
        end
        return old(self, unpack(args))
    end)
    setreadonly(mt, true)
end
pcall(antiKick)

--[[
    ########### GUI AVANÇADA ###########
]]
local RayfieldLoaded = game:GetService("CoreGui"):FindFirstChild("Rayfield")
if not RayfieldLoaded then
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()
    end)
end
repeat task.wait() until game:GetService("CoreGui"):FindFirstChild("Rayfield")
local Rayfield = require(game:GetService("CoreGui"):FindFirstChild("Rayfield"))

local Window = Rayfield:CreateWindow({
    Name = "Redz Hub - Blox Fruits",
    LoadingTitle = "Iniciando...",
    LoadingSubtitle = "By VEXNAAG39",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false,
    Icon = "rbxassetid://14528995720" -- Substitua por AssetId desejado
})

local FarmTab = Window:CreateTab("Farm", 14528995720)
local TeleportTab = Window:CreateTab("Teleport", 14528995720)
local MiscTab = Window:CreateTab("Misc", 14528995720)

--[[
    ########### DADOS DE MOBS, ILHAS, FRUTAS ###########
]]
local mobList = {
    "Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer",
    "Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando",
    "God's Guard","Shanda","Royal Squad","Galley Pirate","Galley Captain","Raider","Mercenary","Swan Pirate","Factory Staff",
    "Marine Lieutenant","Marine Captain","Zombie","Vampire","Ghost","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer",
    "Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter","Magma Ninja","Lava Pirate","Island Boy","Forest Pirate",
    "Mythological Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Peanut Scout","Peanut President",
    "Candy Rebel","Candy Pirate","Apple Bandit","Apple Emperor","Dragon Crew Warrior","Dragon Crew Archer","Female Islander",
    "Giant Islander","Kitsune","Turtle Bandit","Pirate Millionaire","Elite Pirate","Cursed Ship Engineer","Cursed Ship Officer",
    "Cursed Ship Steward","Cursed Ship Deckhand","Cursed Ship Captain","Cursed Ship Sailor"
}
local bossList = {
    "The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord",
    "Thunder God","Cyborg","Don Swan","Smoke Admiral","Awakened Ice Admiral","Dark Beard","Cake Queen","rip_indra","Soul Reaper",
    "Captain Elephant","Beautiful Pirate","Stone","Kilo Admiral","Cursed Captain"
}
local islandList = {
    "Starter Island","Pirate Village","Desert","Frozen Village","Marine Fortress","Skylands","Prison","Colosseum","Magma Village",
    "Underwater City","Fountain City","Kingdom of Rose","Green Zone","Graveyard","Snow Mountain","Hot and Cold","Cursed Ship",
    "Ice Castle","Forgotten Island","UFO","Haunted Castle","Hydra Island","Turtle Island","Castle on the Sea"
}

--[[
    ########### VARIÁVEIS E SLIDERS ###########
]]
local selectedMob = mobList[1]
local selectedBoss = bossList[1]
local selectedIsland = islandList[1]
local farmDistance = 3

--[[
    ########### FUNÇÕES MODULARES ###########
]]
-- Notificação estilo Discord
local function notify(title, text, time)
    Rayfield:Notify({Title = title, Content = text, Duration = time or 2})
end

-- Auto-Farm NPC/Bosses
local autoFarmEnabled = false
local autoFarmType = "Mob" -- Mob|Boss|Fruit
local autoFarmThread = nil

local function findNearestMob(mobType)
    local mobs = {}
    local mobParent = Workspace:FindFirstChild("Enemies")
    if not mobParent then return nil end
    for _,v in pairs(mobParent:GetChildren()) do
        if v.Name == mobType and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            table.insert(mobs, v)
        end
    end
    table.sort(mobs, function(a, b)
        return (getHRP().Position - a.HumanoidRootPart.Position).Magnitude <
            (getHRP().Position - b.HumanoidRootPart.Position).Magnitude
    end)
    return mobs[1]
end

local function findNearestBoss(bossType)
    local mobs = {}
    local mobParent = Workspace:FindFirstChild("Enemies")
    if not mobParent then return nil end
    for _,v in pairs(mobParent:GetChildren()) do
        if v.Name == bossType and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            table.insert(mobs, v)
        end
    end
    table.sort(mobs, function(a, b)
        return (getHRP().Position - a.HumanoidRootPart.Position).Magnitude <
            (getHRP().Position - b.HumanoidRootPart.Position).Magnitude
    end)
    return mobs[1]
end

local function findNearestFruit()
    for _,v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("fruit") then
            return v
        end
    end
    return nil
end

local function getHRP()
    return lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
end

local function farmLoop()
    autoFarmThread = coroutine.create(function()
        while autoFarmEnabled and validChar() do
            pcall(function()
                if autoFarmType == "Mob" then
                    local mob = findNearestMob(selectedMob)
                    if mob and getHRP() then
                        getHRP().CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, farmDistance, 0)
                        for i=1,3 do
                            ReplicatedStorage:FindFirstChild("RemoteEvent"):FireServer("Attack", mob)
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                            task.wait(0.15)
                        end
                    end
                elseif autoFarmType == "Boss" then
                    local boss = findNearestBoss(selectedBoss)
                    if boss and getHRP() then
                        getHRP().CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, farmDistance, 0)
                        for i=1,3 do
                            ReplicatedStorage:FindFirstChild("RemoteEvent"):FireServer("Attack", boss)
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                            task.wait(0.15)
                        end
                    end
                elseif autoFarmType == "Fruit" then
                    local fruit = findNearestFruit()
                    if fruit and getHRP() then
                        getHRP().CFrame = fruit.Handle.CFrame + Vector3.new(0, 2, 0)
                        firetouchinterest(getHRP(), fruit.Handle, 0)
                        task.wait(0.1)
                        firetouchinterest(getHRP(), fruit.Handle, 1)
                    end
                end
            end)
            task.wait(0.25)
        end
    end)
    coroutine.resume(autoFarmThread)
end

local function stopFarm()
    autoFarmEnabled = false
end

-- Auto Chest Collect
local autoChestEnabled = false
local autoChestThread = nil
local function findNearestChest()
    for _,v in pairs(Workspace:GetChildren()) do
        if v.Name:lower():find("chest") and v:IsA("Part") then
            return v
        end
    end
    return nil
end
local function chestLoop()
    autoChestThread = coroutine.create(function()
        while autoChestEnabled and validChar() do
            pcall(function()
                local chest = findNearestChest()
                if chest and getHRP() then
                    getHRP().CFrame = chest.CFrame + Vector3.new(0, 2, 0)
                    firetouchinterest(getHRP(), chest, 0)
                    task.wait(0.1)
                    firetouchinterest(getHRP(), chest, 1)
                end
            end)
            task.wait(2)
        end
    end)
    coroutine.resume(autoChestThread)
end
local function stopChest()
    autoChestEnabled = false
end

-- Auto Fruit Sniper (busca pelo mapa)
local autoFruitEnabled = false
local autoFruitThread = nil
local function fruitLoop()
    autoFruitThread = coroutine.create(function()
        while autoFruitEnabled and validChar() do
            pcall(function()
                local fruit = findNearestFruit()
                if fruit and getHRP() then
                    getHRP().CFrame = fruit.Handle.CFrame + Vector3.new(0, 2, 0)
                    firetouchinterest(getHRP(), fruit.Handle, 0)
                    task.wait(0.1)
                    firetouchinterest(getHRP(), fruit.Handle, 1)
                end
            end)
            task.wait(2)
        end
    end)
    coroutine.resume(autoFruitThread)
end
local function stopFruit()
    autoFruitEnabled = false
end

-- Teleporte
local function teleportToIsland(island)
    local locations = {
        ["Starter Island"] = Vector3.new(1040, 142, 1655),
        ["Pirate Village"] = Vector3.new(-1120, 65, 3825),
        ["Desert"] = Vector3.new(1080, 13, 4350),
        ["Frozen Village"] = Vector3.new(1405, 38, -1325),
        ["Marine Fortress"] = Vector3.new(-4800, 400, 1045),
        ["Skylands"] = Vector3.new(-2800, 1000, 4000),
        ["Prison"] = Vector3.new(4300, 340, 480),
        ["Colosseum"] = Vector3.new(-1500, 70, -2875),
        ["Magma Village"] = Vector3.new(-5250, 77, -3900),
        ["Underwater City"] = Vector3.new(3875, 10, 1300),
        ["Fountain City"] = Vector3.new(5250, 75, 3700),
        ["Kingdom of Rose"] = Vector3.new(-740, 200, -4500),
        ["Green Zone"] = Vector3.new(-3835, 77, -2975),
        ["Graveyard"] = Vector3.new(-5350, 7, -712),
        ["Snow Mountain"] = Vector3.new(-5600, 340, -4800),
        ["Hot and Cold"] = Vector3.new(-550, 15, -6850),
        ["Cursed Ship"] = Vector3.new(916, 123, 32944),
        ["Ice Castle"] = Vector3.new(-6238, 56, -5360),
        ["Forgotten Island"] = Vector3.new(-3050, 238, -10160),
        ["UFO"] = Vector3.new(0, 0, 0), -- Update with real coords if available
        ["Haunted Castle"] = Vector3.new(-9515, 100, 6064),
        ["Hydra Island"] = Vector3.new(5227, 560, -1136),
        ["Turtle Island"] = Vector3.new(-11048, 331, -8636),
        ["Castle on the Sea"] = Vector3.new(-5078, 317, -3159)
    }
    if locations[island] and validChar() then
        getHRP().CFrame = CFrame.new(locations[island])
    end
end

--[[
    ########### GUI: ABAS E COMPONENTES ###########
]]

FarmTab:CreateDropdown({
    Name = "Selecionar Mob para Auto-Farm",
    Options = mobList,
    CurrentOption = selectedMob,
    Callback = function(value)
        selectedMob = value
        autoFarmType = "Mob"
        notify("Mob Selecionado", value, 1)
    end,
})

FarmTab:CreateDropdown({
    Name = "Selecionar Boss para Auto-Farm",
    Options = bossList,
    CurrentOption = selectedBoss,
    Callback = function(value)
        selectedBoss = value
        autoFarmType = "Boss"
        notify("Boss Selecionado", value, 1)
    end,
})

FarmTab:CreateToggle({
    Name = "Auto-Farm (Mob/Boss)",
    CurrentValue = false,
    Callback = function(value)
        autoFarmEnabled = value
        if value then
            farmLoop()
            notify("Auto-Farm", "Ativado!", 2)
        else
            stopFarm()
            notify("Auto-Farm", "Desativado!", 2)
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Auto-Farm Frutas",
    CurrentValue = false,
    Callback = function(value)
        autoFarmType = "Fruit"
        autoFarmEnabled = value
        if value then
            farmLoop()
            notify("Auto-Farm Frutas", "Ativado!", 2)
        else
            stopFarm()
            notify("Auto-Farm Frutas", "Desativado!", 2)
        end
    end,
})

FarmTab:CreateSlider({
    Name = "Distância de Farm",
    Range = {2, 10},
    Increment = 1,
    CurrentValue = farmDistance,
    Callback = function(val)
        farmDistance = val
    end
})

TeleportTab:CreateDropdown({
    Name = "Selecionar Ilha para Teleport",
    Options = islandList,
    CurrentOption = selectedIsland,
    Callback = function(val)
        selectedIsland = val
        teleportToIsland(val)
        notify("Teleport", "Teleportado para " .. val, 2)
    end,
})

MiscTab:CreateToggle({
    Name = "Auto Coletar Chests",
    CurrentValue = false,
    Callback = function(val)
        autoChestEnabled = val
        if val then
            chestLoop()
            notify("Chest", "Auto Chest ON", 2)
        else
            stopChest()
            notify("Chest", "Auto Chest OFF", 2)
        end
    end,
})

MiscTab:CreateToggle({
    Name = "Auto Buscar Frutas",
    CurrentValue = false,
    Callback = function(val)
        autoFruitEnabled = val
        if val then
            fruitLoop()
            notify("Frutas", "Auto Fruit ON", 2)
        else
            stopFruit()
            notify("Frutas", "Auto Fruit OFF", 2)
        end
    end,
})

MiscTab:CreateButton({
    Name = "Recarregar Personagem",
    Callback = function()
        if validChar() then
            lp.Character:BreakJoints()
        end
    end
})

Players.LocalPlayer.OnTeleport:Connect(function()
    stopFarm(); stopChest(); stopFruit()
end)
