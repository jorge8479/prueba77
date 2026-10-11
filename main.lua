local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ========================================================
-- 📍 CONFIGURACIÓN DE LA ZONA SEGURA
-- ========================================================
-- Aquí debes poner las coordenadas (X, Y, Z) de tu zona segura.
-- Puedes sacar estas coordenadas usando un script de "Get Position" en tu ejecutor Xeno.
local safeZoneCFrame = CFrame.new(150, 50, -200) -- Cambia estos números por los de tu zona segura

-- Función para teletransportarse instantáneamente
local function escaparAZonaSegura()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    if rootPart then
        -- Teletransporte instantáneo (CFrame es mejor que Position para evitar bugs)
        rootPart.CFrame = safeZoneCFrame
        print("🥚 ¡Huevo robado! Escapando a la zona segura...")
    end
end

-- ========================================================
-- 🕵️ DETECTOR DE ROBO (Inventario y Personaje)
-- ========================================================

-- Opción 1: Detectar si el huevo entra a tu mochila (Backpack)
player.Backpack.ChildAdded:Connect(function(item)
    -- Si el nombre del objeto contiene "Egg" o "Huevo"
    if string.find(string.lower(item.Name), "egg") or string.find(string.lower(item.Name), "huevo") then
        escaparAZonaSegura()
    end
end)

-- Opción 2: Detectar si el huevo se equipa directamente en tu personaje
player.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(item)
        if item:IsA("Tool") and (string.find(string.lower(item.Name), "egg") or string.find(string.lower(item.Name), "huevo")) then
            escaparAZonaSegura()
        end
    end)
end)

-- Activar para el personaje actual si ya estás vivo
if player.Character then
    player.Character.ChildAdded:Connect(function(item)
        if item:IsA("Tool") and (string.find(string.lower(item.Name), "egg") or string.find(string.lower(item.Name), "huevo")) then
            escaparAZonaSegura()
        end
    end)
end
