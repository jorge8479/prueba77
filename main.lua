-- ========================================================
-- PANEL DE FLY - ROBLOX (Sistema de Acceso Corregido)
-- ========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ==========================================
-- 🔒 SISTEMA DE WHITELIST (PON TU ID AQUÍ)
-- ==========================================
local AllowedIDs = {
    [8415572355] = true, -- Reemplaza esto con tu ID de Roblox (solo números)
}

local isAuthorized = AllowedIDs[player.UserId] or false

-- Variables de vuelo
local flying = false
local speed = 200
local bg, bv

-- ==========================================
-- CREACIÓN DE LA INTERFAZ BASE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyPanelUI"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then
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

local AuthCorner = Instance.new("UICorner")
AuthCorner.CornerRadius = UDim.new(0, 12)
AuthCorner.Parent = AuthPanel

-- Título decorativo del Login
local AuthTitle = Instance.new("TextLabel")
AuthTitle.Size = UDim2.new(1, 0, 0, 30)
AuthTitle.Position = UDim2.new(0, 0, 0, 10)
AuthTitle.BackgroundTransparency = 1
AuthTitle.Text = "Seguridad del Panel"
AuthTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
AuthTitle.Font = Enum.Font.Gotham
AuthTitle.TextSize = 14
AuthTitle.Parent = AuthPanel

-- Estado (Donde antes decía "Label")
local AuthStatus = Instance.new("TextLabel")
AuthStatus.Size = UDim2.new(1, 0, 0, 50)
AuthStatus.Position = UDim2.new(0, 0, 0, 40)
AuthStatus.BackgroundTransparency = 1
AuthStatus.Text = "Verificando..." -- Texto por defecto corregido
AuthStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AuthStatus.Font = Enum.Font.GothamBold
AuthStatus.TextSize = 20
AuthStatus.Parent = AuthPanel

-- ==========================================
-- BOLITA NEGRA (Botón de abrir) - Oculto al inicio
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0, 20, 0.5, -22)
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenButton.Text = "✈️"
OpenButton.TextSize = 20
OpenButton.Visible = false 
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0) 
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-- ==========================================
-- PANEL PRINCIPAL DE VUELO - Oculto al inicio
-- ==========================================
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 250, 0, 160)
MainPanel.Position = UDim2.new(0.5, -125, 0.5, -80)
MainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Draggable = true 
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 12)
PanelCorner.Parent = MainPanel

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Fly Panel ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainPanel

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainPanel

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 180, 0, 50)
FlyButton.Position = UDim2.new(0.5, -90, 0.6, -15)
FlyButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) 
FlyButton.Text = "Activar Fly"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 18
FlyButton.Parent = MainPanel

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 8)
FlyCorner.Parent = FlyButton

-- ==========================================
-- LÓGICA DE AUTORIZACIÓN Y BOTONES
-- ==========================================

-- Pequeña pausa para que se vea la ventana de verificación un instante
task.wait(0.2) 

if isAuthorized then
    AuthStatus.Text = "Acceso Autorizado ✅"
    AuthStatus.TextColor3 = Color3.fromRGB(50, 200, 80)
    
    local EnterButton = Instance.new("TextButton")
    EnterButton.Size = UDim2.new(0, 200, 0, 45)
    EnterButton.Position = UDim2.new(0.5, -100, 0.6, 10)
    EnterButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    EnterButton.Text = "Entrar al Panel"
    EnterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnterButton.Font = Enum.Font.GothamBold
    EnterButton.TextSize = 16
    EnterButton.Parent = AuthPanel
    
    local EnterCorner = Instance.new("UICorner")
    EnterCorner.CornerRadius = UDim.new(0, 8)
    EnterCorner.Parent = EnterButton
    
    -- Acción instantánea al presionar
    EnterButton.MouseButton1Down:Connect(function()
        AuthPanel:Destroy()
        MainPanel.Visible = true
    end)
else
    AuthStatus.Text = "Acceso Denegado ❌"
    AuthStatus.TextColor3 = Color3.fromRGB(220, 50, 50)
    
    -- Si no está en la Whitelist, la UI se destruye en 3 segundos
    task.delay(3, function()
        if ScreenGui then ScreenGui:Destroy() end
    end)
end

-- Minimizar panel
CloseButton.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
    OpenButton.Visible = true
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
