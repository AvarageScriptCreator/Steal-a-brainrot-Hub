-- STEAL HUB (versão leve) – UI simples compatível com celular

-- Remove UI anterior se já existir
if game.CoreGui:FindFirstChild("StealHubUI") then
    game.CoreGui:FindFirstChild("StealHubUI"):Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Criar ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "StealHubUI"
gui.ResetOnSpawn = false

-- Main Frame (caixa preta)
local main = Instance.new("Frame", gui)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.Size = UDim2.new(0, 400, 0, 250)
main.Name = "Main"
main.Active = true
main.Draggable = true

-- Título
local title = Instance.new("TextLabel", main)
title.Text = "STEAL HUB"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Name = "Title"

-- Botões: X (fechar), - (minimizar), 🗖 (tela cheia)
local function createControlButton(symbol, position, callback)
    local btn = Instance.new("TextButton", title)
    btn.Size = UDim2.new(0, 30, 1, 0)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = symbol
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Fechar
createControlButton("X", UDim2.new(1, -90, 0, 0), function()
    gui:Destroy()
end)

-- Minimizar
createControlButton("-", UDim2.new(1, -60, 0, 0), function()
    main.Size = UDim2.new(0, 400, 0, 30)
end)

-- Tela cheia
createControlButton("🗖", UDim2.new(1, -30, 0, 0), function()
    main.Size = UDim2.new(1, -40, 1, -40)
end)
-- Container de botões
local buttonFrame = Instance.new("Frame", main)
buttonFrame.Position = UDim2.new(0, 0, 0, 30)
buttonFrame.Size = UDim2.new(1, 0, 1, -30)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Name = "ButtonContainer"

-- Função para criar botões
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

-- Auto Steal
_G.AutoSteal = false
createHubButton("Auto Steal [ON/OFF]", function()
    _G.AutoSteal = not _G.AutoSteal
end)

-- Teleportar 5 studs para frente
createHubButton("TP 5 Studs à frente", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        root.CFrame = root.CFrame + root.CFrame.LookVector * 5
    end
end)

-- Server Hopper (requer teleport público ativado)
createHubButton("Server Hopper (procurar secreto)", function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceID = game.PlaceId

    local function hop()
        local servers = HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
        for _, server in ipairs(servers.data) do
            if server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PlaceID, server.id, player)
                break
            end
        end
    end

    hop()
end)

-- Ativar ESP de secreto
createHubButton("Ativar ESP de Brainrot Secreto", function()
    local RunService = game:GetService("RunService")
    local espFolder = Instance.new("Folder", workspace)
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
end)
-- Função Auto Steal
local function doAutoSteal()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    for _, brainrot in pairs(workspace:GetChildren()) do
        if brainrot.Name == "Brainrot" and brainrot:FindFirstChild("Rarity") then
            local rarity = brainrot.Rarity.Value
            if rarity == "Common" or rarity == "Rare" or rarity == "Secret" then
                if brainrot:FindFirstChild("PrimaryPart") or brainrot:IsA("Model") then
                    local part = brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart")
                    if part then
                        root.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
end

-- Loop do Auto Steal
task.spawn(function()
    while task.wait(1) do
        if _G.AutoSteal then
            pcall(doAutoSteal)
        end
    end
end)
-- Sistema de Key simples
local correctKey = "Tripa tropa TRALALA liririla Tung Tung Sahur boneca Tung Tung tralalelo tripa tropa crocodina"
local input = ""

-- Caixa para digitar a key
local keyPrompt = Instance.new("Frame", gui)
keyPrompt.Size = UDim2.new(0, 300, 0, 150)
keyPrompt.Position = UDim2.new(0.5, -150, 0.5, -75)
keyPrompt.BackgroundColor3 = Color3.new(0, 0, 0)
keyPrompt.BorderSizePixel = 0
keyPrompt.Name = "KeyPrompt"

local titleKey = Instance.new("TextLabel", keyPrompt)
titleKey.Size = UDim2.new(1, 0, 0, 30)
titleKey.Text = "Insira a Key para usar o STEAL HUB"
titleKey.TextColor3 = Color3.new(1, 1, 1)
titleKey.BackgroundTransparency = 1
titleKey.Font = Enum.Font.GothamBold
titleKey.TextSize = 14

local textbox = Instance.new("TextBox", keyPrompt)
textbox.Size = UDim2.new(1, -20, 0, 40)
textbox.Position = UDim2.new(0, 10, 0, 40)
textbox.PlaceholderText = "Digite a Key aqui"
textbox.Text = ""
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.ClearTextOnFocus = false

local confirm = Instance.new("TextButton", keyPrompt)
confirm.Size = UDim2.new(0.5, -15, 0, 30)
confirm.Position = UDim2.new(0, 10, 0, 100)
confirm.Text = "Confirmar"
confirm.TextColor3 = Color3.new(1, 1, 1)
confirm.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
confirm.Font = Enum.Font.Gotham
confirm.TextSize = 14

local cancel = Instance.new("TextButton", keyPrompt)
cancel.Size = UDim2.new(0.5, -15, 0, 30)
cancel.Position = UDim2.new(0.5, 5, 0, 100)
cancel.Text = "Cancelar"
cancel.TextColor3 = Color3.new(1, 1, 1)
cancel.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
cancel.Font = Enum.Font.Gotham
cancel.TextSize = 14

confirm.MouseButton1Click:Connect(function()
    if textbox.Text == correctKey then
        keyPrompt:Destroy()
        main.Visible = true
    else
        textbox.Text = "Key incorreta!"
    end
end)

cancel.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Esconde a UI até a key ser digitada
main.Visible = false
