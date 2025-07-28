-- StealthBox.lua - UI Preta com TP Personalizado, Speed, Jump, Noclip ON/OFF, ESP

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "StealthBox"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 280)
Frame.Position = UDim2.new(0, 20, 0.5, -140)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local yOffset = 10
local function createButton(text, callback)
	local button = Instance.new("TextButton", Frame)
	button.Size = UDim2.new(1, -20, 0, 35)
	button.Position = UDim2.new(0, 10, 0, yOffset)
	yOffset += 40
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = text
	button.Font = Enum.Font.SourceSansSemibold
	button.TextSize = 16
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
	callback(button)
end

-- TP Personalizado
local distance = 50
local box = Instance.new("TextBox", Frame)
box.PlaceholderText = "Distância do TP (5-100)"
box.Text = tostring(distance)
box.Position = UDim2.new(0, 10, 0, yOffset)
box.Size = UDim2.new(1, -20, 0, 30)
box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
box.TextColor3 = Color3.new(1, 1, 1)
box.Font = Enum.Font.SourceSans
box.TextSize = 16
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
yOffset += 40

createButton("TP P/ Frente (Personalizado)", function(button)
	button.MouseButton1Click:Connect(function()
		local value = tonumber(box.Text)
		if value and value >= 5 and value <= 100 then
			distance = value
		end
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = root.CFrame + root.CFrame.LookVector * distance
		end
	end)
end)

-- Super Velocidade
createButton("Super Velocidade", function(button)
	button.MouseButton1Click:Connect(function()
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 100
		end
	end)
end)

-- Super Pulo
createButton("Super Pulo", function(button)
	button.MouseButton1Click:Connect(function()
		local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.JumpPower = 120
		end
	end)
end)

-- Noclip ON/OFF
local noclipAtivo = false
createButton("Ativar Noclip", function(button)
	button.MouseButton1Click:Connect(function()
		noclipAtivo = not noclipAtivo
		button.Text = noclipAtivo and "Desativar Noclip" or "Ativar Noclip"
	end)
end)

RunService.Stepped:Connect(function()
	if noclipAtivo and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- ESP para Times Azul/Vermelho
createButton("ESP Azul/Vermelho", function(button)
	button.MouseButton1Click:Connect(function()
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Team then
				local teamName = player.Team.Name
				if teamName == "Red" or teamName == "Blue" then
					local function criarESP(part)
						local box = Instance.new("BoxHandleAdornment")
						box.Size = Vector3.new(4, 5, 1)
						box.Adornee = part
						box.AlwaysOnTop = true
						box.ZIndex = 10
						box.Transparency = 0.5
						box.Color3 = teamName == "Red" and Color3.new(1, 0, 0) or Color3.new(0, 0, 1)
						box.Parent = part
					end
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						criarESP(char.HumanoidRootPart)
					end
				end
			end
		end
	end)
end)
