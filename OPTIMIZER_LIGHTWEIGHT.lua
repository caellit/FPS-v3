-- =========================================================
-- ALEX + BROKENSFR
-- ULTRA LIGHTWEIGHT FPS OPTIMIZER
-- =========================================================

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local GUI_NAME = "YoshiFX_CombinedOptimizer"
local LocalPlayer = Players.LocalPlayer

-- =========================================================
-- ELIMINAR VERSION ANTERIOR
-- =========================================================

pcall(function()
    local old = CoreGui:FindFirstChild(GUI_NAME)

    if old then
        old:Destroy()
    end
end)

-- =========================================================
-- OPTIMIZACIONES DE LIGHTING
-- =========================================================

pcall(function()

    -- ALEX
    -- Calidad grafica minima
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    -- ALEX + BROKENSFR
    -- Sombras globales desactivadas
    Lighting.GlobalShadows = false

    -- BROKENSFR
    -- Elimina la niebla a distancia
    Lighting.FogEnd = 9e9

    -- =====================================================
    -- EFECTOS DE LIGHTING
    -- =====================================================

    for _, effect in ipairs(Lighting:GetChildren()) do

        -- ALEX
        if effect:IsA("BlurEffect")
        or effect:IsA("SunRaysEffect")
        or effect:IsA("ColorCorrectionEffect")
        or effect:IsA("BloomEffect")
        or effect:IsA("DepthOfFieldEffect") then

            effect.Enabled = false
        end

        -- BROKENSFR
        -- Eliminar Atmosphere
        if effect:IsA("Atmosphere") then
            effect:Destroy()
        end

        -- BROKENSFR
        -- Eliminar Sky
        if effect:IsA("Sky") then
            effect:Destroy()
        end

    end

end)

-- =========================================================
-- SOMBRAS DEL PERSONAJE
-- =========================================================

local function removeCharacterShadows(character)

    pcall(function()

        for _, part in ipairs(character:GetDescendants()) do

            if part:IsA("BasePart") then
                part.CastShadow = false
            end

        end

    end)

end

if LocalPlayer.Character then
    removeCharacterShadows(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)

    task.wait(0.5)

    removeCharacterShadows(character)

end)

-- =========================================================
-- OPTIMIZACION DE MESHES
-- =========================================================

pcall(function()

    -- Se ejecuta UNA SOLA VEZ
    -- No se ejecuta cada frame.

    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("MeshPart") then

            pcall(function()
                obj.RenderFidelity = Enum.RenderFidelity.Performance
            end)

        end

    end

end)

-- =========================================================
-- FPS DISPLAY
-- =========================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()

    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end

end)

ScreenGui.Parent = CoreGui

-- =========================================================
-- FPS LABEL
-- =========================================================

local FPSLabel = Instance.new("TextLabel")

FPSLabel.Name = "FPSDisplay"
FPSLabel.Parent = ScreenGui

FPSLabel.Position = UDim2.new(0, 18, 0, 8)
FPSLabel.Size = UDim2.new(0, 145, 0, 22)

FPSLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FPSLabel.BackgroundTransparency = 0.25
FPSLabel.BorderSizePixel = 0

FPSLabel.Font = Enum.Font.GothamBold

FPSLabel.Text = "FPS: -- | Optimized"
FPSLabel.TextSize = 10

FPSLabel.TextColor3 =
    Color3.fromRGB(60, 255, 90)

FPSLabel.TextXAlignment =
    Enum.TextXAlignment.Center

FPSLabel.TextYAlignment =
    Enum.TextYAlignment.Center

-- =========================================================
-- GUI CORNER
-- =========================================================

local Corner = Instance.new("UICorner")

Corner.CornerRadius = UDim.new(0, 3)
Corner.Parent = FPSLabel

-- =========================================================
-- FPS MONITOR
-- =========================================================

local frames = 0
local elapsed = 0
local displayedFPS = 60

local UPDATE_TIME = 0.5

local connection

connection = RunService.Heartbeat:Connect(function(dt)

    -- Si la GUI deja de existir,
    -- desconectar el Heartbeat.

    if not ScreenGui.Parent then

        connection:Disconnect()

        return

    end

    frames += 1
    elapsed += dt

    if elapsed >= UPDATE_TIME then

        local fps = frames / elapsed

        -- Suavizado del FPS
        displayedFPS =
            displayedFPS * 0.75 +
            fps * 0.25

        local currentFPS =
            math.floor(displayedFPS + 0.5)

        FPSLabel.Text =
            "FPS: " ..
            currentFPS ..
            " | Optimized"

        -- =================================================
        -- COLOR SEGUN FPS
        -- =================================================

        if currentFPS < 30 then

            FPSLabel.TextColor3 =
                Color3.fromRGB(255, 80, 80)

        elseif currentFPS < 50 then

            FPSLabel.TextColor3 =
                Color3.fromRGB(255, 220, 60)

        else

            FPSLabel.TextColor3 =
                Color3.fromRGB(60, 255, 90)

        end

        frames = 0
        elapsed = 0

    end

end)