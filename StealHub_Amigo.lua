-- STEAL HUB: Leve com verificação de amizade para liberar o script

if game.CoreGui:FindFirstChild("StealHubUI") then
    game.CoreGui:FindFirstChild("StealHubUI"):Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local friendUserId = 4590001234 -- UserID para checar amizade

-- Função para checar amizade
local function checkFriend()
    local success, result = pcall(function()
        local url = ("https://friends.roblox.com/v1/users/%d/friends"):format(player.UserId)
        local response = game:HttpGet(url)
        local data = HttpService:JSONDecode(response)
        for _, friend in pairs(data.data) do
            if friend.id == friendUserId then
                return true
            end
        end
        return false
    end)
    if not success then
        return false
    end
    return result
end

-- Bloquear acesso se não for amigo
if not checkFriend() then
    player:Kick("Script não foi carregado / você não é permitido")
    return
end

-- Criar GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "StealHubUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.Size = UDim2.new(0, 400, 0, 250)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Text = "STEAL HUB"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function createControlButton(symbol, pos, callback)
    local btn = Instance.new("TextButton", title)
    btn.Size = UDim2.new(0, 30, 1, 0)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = symbol
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

createControlButton("X", UDim2.new(1, -90, 0, 0), function()
    gui:Destroy()
end)

createControlButton("-", UDim2.new(1, -60, 0, 0), function()
    main.Size = UDim2.new(0, 400, 0, 30)
end)

createControlButton("🗖", UDim2.new(1, -30, 0, 0), function()
    main.Size = UDim2.new(1, -40, 1, -40)
end)

local buttonFrame = Instance.new("Frame", main)
buttonFrame.Position = UDim2.new(0, 0, 0, 30)
buttonFrame.Size = UDim2.new(1, 0, 1, -30)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Name = "ButtonContainer"

local function createHubButton(text, callback)
    local btn = Instance.new("TextButton", buttonFrame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, #buttonFrame:GetChildren() * 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
end

local function notify(text)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Steal Hub";
        Text = text;
        Duration = 3;
    })
end

-- Variáveis globais
_G.AutoSteal = false

-- Função para verificar se está segurando Brainrot
local function isHoldingBrainrot()
    local char = player.Character
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("brainrot") then
        return true
    end
    return false
end

-- Função Auto Steal ajustada
local function doAutoSteal()
    if not isHoldingBrainrot() then
        notify("Você precisa segurar um Brainrot para Auto Steal!")
        _G.AutoSteal = false
        return
    end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    -- Teleportar para entrada da base (exemplo, ajustar conforme seu mapa)
    local baseEntryPos = Vector3.new(0, 10, 0) -- Mude para a posição correta da entrada da base
    root.CFrame = CFrame.new(baseEntryPos) * CFrame.new(0, 3, 0)
end

-- Server Hopper avançado
local function advancedServerHop()
    local placeId = game.PlaceId
    local cursor = nil
    local foundServer = false

    notify("Procurando servidores com Brainrot secreto...")

    while not foundServer do
        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s"):format(
            placeId,
            cursor and ("&cursor=" .. cursor) or ""
        )
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if not success or not servers or not servers.data then
            notify("Erro ao buscar servidores.")
            break
        end

        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers then
                -- Por limitações, só teleporta no primeiro disponível
                TeleportService:TeleportToPlaceInstance(placeId, server.id, player)
                foundServer = true
                break
            end
        end

        if servers.nextPageCursor and not foundServer then
            cursor = servers.nextPageCursor
        else
            break
        end
    end

    if not foundServer then
        notify("Nenhum servidor com Brainrot secreto encontrado.")
    end
end

-- Criar botões
createHubButton("Auto Steal [ON/OFF]", function()
    _G.AutoSteal = not _G.AutoSteal
    if _G.AutoSteal then
        notify("Auto Steal ativado")
    else
        notify("Auto Steal desativado")
    end
end)

createHubButton("TP 5 Studs à frente", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        root.CFrame = root.CFrame + root.CFrame.LookVector * 5
    end
end)

createHubButton("Server Hopper (procurar secreto)", function()
    advancedServerHop()
end)

createHubButton("Ativar ESP de Brainrot Secreto", function()
    local espFolder = workspace:FindFirstChild("StealHubESP")
    if espFolder then espFolder:Destroy() end
    espFolder = Instance.new("Folder", workspace)
    espFolder.Name = "StealHubESP"

    local function createESP(obj)
        if obj:FindFirstChild("Rarity") and obj.Rarity.Value == "Secret" then
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            box.Size = box.Adornee.Size
            box.Color3 = Color3.new(1, 0, 0)
            box.Transparency = 0.5
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Parent = espFolder
        end
    end

    RunService.Heartbeat:Connect(function()
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Brainrot" then
                createESP(obj)
            end
        end
    end)
    notify("ESP ativado")
end)

-- Loop do Auto Steal
task.spawn(function()
    while task.wait(1) do
        if _G.AutoSteal then
            pcall(doAutoSteal)
        end
    end
end)

main.Visible = true
