-- ========================================================
-- PANEL DE FLY - ROBLOX (Whitelist, Webhook, Video y Música)
-- ========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ==========================================
-- 🔒 SISTEMA DE WHITELIST Y WEBHOOK
-- ==========================================
local AllowedIDs = {
    [123456789] = true, -- ⚠️ PON TU ID REAL AQUÍ
}

local isAuthorized = AllowedIDs[player.UserId] or false
local WebhookURL = "https://discord.com/api/webhooks/1557490882201124976/vbbuui5cjlafKns_IpffyJSGfqef6SA95uGSdOaLpqWxsupe6PiWrV0RBdgDSJQlqS45"

local function SendWebhook(status)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if requestFunc then
        local color = status == "Autorizado" and tonumber(0x00FF00) or tonumber(0xFF0000)
        local success, gameInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        local gameName = success and gameInfo.Name or "Juego Desconocido (ID: "..game.PlaceId..")"

        local data = {
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = "🚨 Nuevo Acceso al Script",
                ["description"] = "**Estado:** " .. status .. "\n**Jugador:** " .. player.Name .. "\n**ID:** " .. player.UserId .. "\n**Juego:** " .. gameName,
                ["type"] = "rich",
                ["color"] = color,
                ["thumbnail"] = {
                    ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=150&height=150&format=png"
                }
            }}
        }
        
        requestFunc({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- ==========================================
-- VARIABLES DE VUELO
-- ==========================================
local flying = false
local speed = 200
local bg, bv

-- ==========================================
-- CREACIÓN DE LA INTERFAZ BASE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyPanelUI"
ScreenGui.ResetOnSpawn = false

local successUI = pcall(function() ScreenGui.Parent = CoreGui end)
if not successUI then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ==========================================
-- PANTALLA DE AUTORIZACIÓN (Login)
-- ==========================================
local AuthPanel = Instance.new("Frame")
AuthPanel.Size = UDim2.new(0, 300, 0, 160)
AuthPanel.Position = UDim2.new(0.5, -150, 0.5, -80)
AuthPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AuthPanel.BorderSizePixel = 0
AuthPanel.Parent = ScreenGui
Instance.new("UICorner", AuthPanel).CornerRadius = UDim.new(0, 12)

local AuthTitle = Instance.new("TextLabel")
AuthTitle.Size = UDim2.new(1, 0, 0, 30)
AuthTitle.Position = UDim2.new(0, 0, 0, 10)
AuthTitle.BackgroundTransparency = 1
AuthTitle.Text = "Seguridad del Panel"
AuthTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
AuthTitle.Font = Enum.Font.Gotham
AuthTitle.TextSize = 14
AuthTitle.Parent = AuthPanel

local AuthStatus = Instance.new("TextLabel")
AuthStatus.Size = UDim2.new(1, 0, 0, 50)
AuthStatus.Position = UDim2.new(0, 0, 0, 40)
AuthStatus.BackgroundTransparency = 1
AuthStatus.Text = "Verificando..."
AuthStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AuthStatus.Font = Enum.Font.GothamBold
AuthStatus.TextSize = 20
AuthStatus.Parent = AuthPanel

-- ==========================================
-- BOLITA NEGRA (Botón de abrir)
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0, 20, 0.5, -22)
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenButton.Text = "✈️"
OpenButton.TextSize = 20
OpenButton.Visible = false 
OpenButton.Parent = ScreenGui
Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0) 

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-- ==========================================
-- PANEL PRINCIPAL 
-- ==========================================
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 250, 0, 310) 
MainPanel.Position = UDim2.new(0.5, -125, 0.5, -155)
MainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Draggable = true 
MainPanel.Visible = false
MainPanel.Parent = ScreenGui
Instance.new("UICorner", MainPanel).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Fly Panel ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainPanel

-- Botón Cerrar (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainPanel
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

-- ==========================================
-- 🎵 MÚSICA DE FONDO Y BOTÓN PARA PARARLA
-- ==========================================
local BackgroundMusic = Instance.new("Sound")
BackgroundMusic.SoundId = "rbxassetid://129825897352810" -- Tu ID de Sonido
BackgroundMusic.Volume = 0.8
BackgroundMusic.Looped = true
BackgroundMusic.Parent = MainPanel

-- Botón para Pausar/Reanudar Música
local MusicButton = Instance.new("TextButton")
MusicButton.Size = UDim2.new(0, 30, 0, 30)
MusicButton.Position = UDim2.new(1, -70, 0, 5) -- Al lado de la X
MusicButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
MusicButton.Text = "🔊"
MusicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MusicButton.TextSize = 16
MusicButton.Parent = MainPanel
Instance.new("UICorner", MusicButton).CornerRadius = UDim.new(1, 0)

MusicButton.MouseButton1Click:Connect(function()
    if BackgroundMusic.IsPlaying then
        BackgroundMusic:Pause()
        MusicButton.Text = "🔇"
        MusicButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    else
        BackgroundMusic:Resume()
        MusicButton.Text = "🔊"
        MusicButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    end
end)

-- ==========================================
-- 🎥 VIDEO DE FONDO (Roblox Asset)
-- ==========================================
local VideoPlayer = Instance.new("VideoFrame")
VideoPlayer.Size = UDim2.new(1, -20, 0, 110) 
VideoPlayer.Position = UDim2.new(0, 10, 0, 45)
VideoPlayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VideoPlayer.Video = "rbxassetid://5608327482" 
VideoPlayer.Playing = true
VideoPlayer.Looped = true
VideoPlayer.Parent = MainPanel
Instance.new("UICorner", VideoPlayer).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- ⚙️ CONTROLES DE VELOCIDAD (+ y -)
-- ==========================================
local SpeedMinus = Instance.new("TextButton")
SpeedMinus.Size = UDim2.new(0, 40, 0, 35)
SpeedMinus.Position = UDim2.new(0, 15, 0, 165)
SpeedMinus.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpeedMinus.Text = "-"
SpeedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedMinus.Font = Enum.Font.GothamBold
SpeedMinus.TextSize = 22
SpeedMinus.Parent = MainPanel
Instance.new("UICorner", SpeedMinus).CornerRadius = UDim.new(0, 6)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 100, 0, 35)
SpeedLabel.Position = UDim2.new(0, 75, 0, 165)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
SpeedLabel.Text = "Velocidad:\n" .. speed
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 12
SpeedLabel.Parent = MainPanel
Instance.new("UICorner", SpeedLabel).CornerRadius = UDim.new(0, 6)

local SpeedPlus = Instance.new("TextButton")
SpeedPlus.Size = UDim2.new(0, 40, 0, 35)
SpeedPlus.Position = UDim2.new(0, 195, 0, 165)
SpeedPlus.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpeedPlus.Text = "+"
SpeedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedPlus.Font = Enum.Font.GothamBold
SpeedPlus.TextSize = 22
SpeedPlus.Parent = MainPanel
Instance.new("UICorner", SpeedPlus).CornerRadius = UDim.new(0, 6)

SpeedMinus.MouseButton1Click:Connect(function()
    if speed > 10 then 
        speed = speed - 10
        SpeedLabel.Text = "Velocidad:\n" .. speed
    end
end)

SpeedPlus.MouseButton1Click:Connect(function()
    if speed < 1000 then 
        speed = speed + 10
        SpeedLabel.Text = "Velocidad:\n" .. speed
    end
end)

-- ==========================================
-- BOTÓN DE FLY
-- ==========================================
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 180, 0, 50)
FlyButton.Position = UDim2.new(0.5, -90, 1, -65) 
FlyButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) 
FlyButton.Text = "Activar Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 18
FlyButton.Parent = MainPanel
Instance.new("UICorner", FlyButton).CornerRadius = UDim.new(0, 8)

-- ==========================================
-- LÓGICA DE AUTORIZACIÓN Y BOTONES
-- ==========================================
task.wait(0.2) 

if isAuthorized then
    AuthStatus.Text = "Acceso Autorizado ✅"
    AuthStatus.TextColor3 = Color3.fromRGB(50, 200, 80)
    
    SendWebhook("Autorizado")
    
    local EnterButton = Instance.new("TextButton")
    EnterButton.Size = UDim2.new(0, 200, 0, 45)
    EnterButton.Position = UDim2.new(0.5, -100, 0.6, 10)
    EnterButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    EnterButton.Text = "Entrar al Panel"
    EnterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnterButton.Font = Enum.Font.GothamBold
    EnterButton.TextSize = 16
    EnterButton.Parent = AuthPanel
    Instance.new("UICorner", EnterButton).CornerRadius = UDim.new(0, 8)
    
    EnterButton.MouseButton1Down:Connect(function()
        AuthPanel:Destroy()
        MainPanel.Visible = true
        BackgroundMusic:Play() -- INICIA TU AUDIO AL ENTRAR AL PANEL
    end)
else
    AuthStatus.Text = "Acceso Denegado ❌"
    AuthStatus.TextColor3 = Color3.fromRGB(220, 50, 50)
    
    SendWebhook("Denegado (Intruso)")
    
    task.delay(3, function()
        if ScreenGui then ScreenGui:Destroy() end
    end)
end

-- Minimizar panel
CloseButton.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
    OpenButton.Visible = true
    -- No pausamos la música para que siga sonando mientras vuelas con el panel oculto
end)

-- Abrir panel
OpenButton.MouseButton1Click:Connect(function()
    MainPanel.Visible = true
    OpenButton.Visible = false
end)

-- Lógica del Vuelo
FlyButton.MouseButton1Click:Connect(function()
    flying = not flying
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    if flying then
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
        FlyButton.Text = "Desactivar Fly"

        humanoid.PlatformStand = true
        
        bg = Instance.new("BodyGyro", rootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        
        bv = Instance.new("BodyVelocity", rootPart)
        bv.velocity = Vector3.new(0,0,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

        RunService:BindToRenderStep("FlyLoop", Enum.RenderPriority.Camera.Value, function()
            local moveDir = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            bg.cframe = camera.CFrame
            
            if moveDir.Magnitude > 0 then
                bv.velocity = moveDir.Unit * speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
        end)
    else
        FlyButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        FlyButton.Text = "Activar Fly"

        humanoid.PlatformStand = false
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
        RunService:UnbindFromRenderStep("FlyLoop")
    end
end)
