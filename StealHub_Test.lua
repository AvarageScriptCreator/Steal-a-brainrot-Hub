-- Teste sem bloqueio por ID
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local RayfieldLoaded = false
repeat task.wait() until Rayfield ~= nil
RayfieldLoaded = true

local Window = Rayfield:CreateWindow({
   Name = "STEAL HUB: Teste",
   LoadingTitle = "STEAL HUB",
   LoadingSubtitle = "Carregando interface...",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {Enabled = false},
   KeySystem = false
})

Window:CreateButton({
    Name = "Teste de botão",
    Callback = function()
        print("Botão funcionando!")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "STEAL HUB",
            Text = "Botão pressionado!",
            Duration = 5
        })
    end
})
