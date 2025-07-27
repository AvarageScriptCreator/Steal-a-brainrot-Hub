-- STEAL HUB: Made by ShedlteskySword
-- Script privado para LO_ANTONELLA e Noobers95Lindin
-- Bloqueia outros usuários
local allowedIds = {
    [4590001234] = true,
    [8042101806] = true
}

if not allowedIds[game.Players.LocalPlayer.UserId] then
    game.Players.LocalPlayer:Kick("Script não foi carregado / você não é permitido")
    return
end

-- Rayfield UI Loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
local Window = Rayfield:CreateWindow({
   Name = "STEAL HUB: Made by ShedlteskySword",
   LoadingTitle = "STEAL HUB",
   LoadingSubtitle = "Feito por ShedlteskySword",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "StealHubData",
      FileName = "stealhub"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = true,
   KeySettings = {
      Title = "STEAL HUB KEY",
      Subtitle = "Sistema de Key Privado",
      Note = "Key: Tripa tropa TRALALA liririla Tung Tung Sahur boneca Tung Tung tralalelo tripa tropa crocodina",
      FileName = "StealHubKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Tripa tropa TRALALA liririla Tung Tung Sahur boneca Tung Tung tralalelo tripa tropa crocodina"}
   }
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Função para auto steal Brainrots
local function AutoSteal()
    for _, brainrot in pairs(workspace:GetChildren()) do
        if brainrot.Name == "Brainrot" and brainrot:FindFirstChild("Rarity") then
            if brainrot.Rarity.Value == "Common" or brainrot.Rarity.Value == "Rare" or brainrot.Rarity.Value == "Secret" then
                -- Teleporta para o Brainrot e coleta (exemplo, depende do jogo)
                local targetPos = brainrot.PrimaryPart.Position + (HumanoidRootPart.CFrame.LookVector * 5)
                HumanoidRootPart.CFrame = CFrame.new(targetPos)
                wait(0.3)
                -- Aqui pode colocar o código de coleta, por exemplo: tocar no objeto, etc
            end
        end
    end
end

-- Botão no Rayfield para Auto Steal
Window:CreateToggle({
    Name = "Auto Steal",
    Flag = "AutoSteal",
    Callback = function(state)
        if state then
            _G.AutoStealActive = true
            while _G.AutoStealActive do
                AutoSteal()
                wait(1)
            end
        else
            _G.AutoStealActive = false
        end
    end
})
-- Função para achar Brainrot secreto no servidor atual
local function HasSecretBrainrot()
    for _, brainrot in pairs(workspace:GetChildren()) do
        if brainrot.Name == "Brainrot" and brainrot:FindFirstChild("Rarity") then
            if brainrot.Rarity.Value == "Secret" then
                return true
            end
        end
    end
    return false
end

-- Botão para checar se tem Brainrot secreto
Window:CreateButton({
    Name = "Checar Brainrot Secreto",
    Callback = function()
        if HasSecretBrainrot() then
            print("Brainrot secreto encontrado neste servidor!")
        else
            print("Nenhum Brainrot secreto neste servidor.")
        end
    end
})

-- Server Hopper: troca de servidor até achar um com Brainrot secreto
Window:CreateButton({
    Name = "Server Hopper (Procurar Secret)",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceID = game.PlaceId
        local Servers = {}
        local NextCursor

        repeat
            local URL = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(PlaceID)
            if NextCursor then
                URL = URL .. "&cursor=" .. NextCursor
            end
            local response = game:HttpGet(URL)
            local data = HttpService:JSONDecode(response)
            Servers = data.data
            NextCursor = data.nextPageCursor

            for _, server in pairs(Servers) do
                if server.playing > 0 and server.maxPlayers > server.playing then
                    TeleportService:TeleportToPlaceInstance(PlaceID, server.id)
                    wait(5)
                    if HasSecretBrainrot() then
                        print("Servidor com Brainrot secreto encontrado! Teleportando...")
                        return
                    end
                end
            end
        until not NextCursor
        print("Nenhum servidor com Brainrot secreto encontrado.")
    end
})
-- ESP simples para Brainrot secreto
local RunService = game:GetService("RunService")
local ESPFolder = Instance.new("Folder", workspace)
ESPFolder.Name = "StealHubESP"

local function CreateESP(brainrot)
    if brainrot:FindFirstChild("Rarity") and brainrot.Rarity.Value == "Secret" then
        if not ESPFolder:FindFirstChild(brainrot.Name .. "_" .. brainrot:GetDebugId()) then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = brainrot.Name .. "_" .. brainrot:GetDebugId()
            box.Adornee = brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart")
            box.Size = box.Adornee.Size
            box.Color3 = Color3.new(1, 0, 0) -- vermelho
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Parent = ESPFolder
        end
    end
end

RunService.Heartbeat:Connect(function()
    for _, brainrot in pairs(workspace:GetChildren()) do
        if brainrot.Name == "Brainrot" then
            CreateESP(brainrot)
        end
    end
end)

print("STEAL HUB carregado com sucesso!")
