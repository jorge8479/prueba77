-- ========================================================
-- PANEL DE FLY - ROBLOX (Con Sistema de Acceso)
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
    [] = true, -- Reemplaza 123456789 con tu ID de Roblox
    [] = true, -- Puedes agregar más IDs si quieres que un amigo también tenga acceso
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

-- Intentar ponerlo en CoreGui para que no desaparezca (si se usa un ejecutor)
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ==========================================
-- PANTALLA DE AUTORIZACIÓN (Login)
-- ==========================================
local AuthPanel = Instance.new("Frame")
AuthPanel.Size = UDim2.new(0, 300, 0, 150)
AuthPanel.Position = UDim2.new(0.5, -150, 0.5, -75)
AuthPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AuthPanel.BorderSizePixel = 0
AuthPanel.Parent = ScreenGui

local AuthCorner = Instance.new("UICorner")
AuthCorner.CornerRadius = UDim.new(0, 12)
AuthCorner.Parent = AuthPanel

local AuthStatus = Instance.new("TextLabel")
AuthStatus.Size = UDim2.new(1, 0, 0, 60)
AuthStatus.Position = UDim2.new(0, 0, 0, 20)
AuthStatus.BackgroundTransparency = 1
AuthStatus.Font = Enum.Font.GothamBold
AuthStatus.TextSize = 22
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
CloseButton.BackgroundColor3 = Color3.fromRGB
