-- ==========================================
-- JDEV ULTIMATE LUNAR UI - VERSÃO CORRIGIDA E MELHORADA
-- Estilo inspirado no Garnet Hub
-- ==========================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- ==========================================
-- CONFIGURAÇÕES DO PAINEL
-- ==========================================
local Config = {
    Width = 380,
    Height = 450,
    MinimizedHeight = 40,
    XPos = 10,
    YPos = 10,
    ColorPrimary = Color3.fromRGB(20, 20, 25),
    ColorSecondary = Color3.fromRGB(30, 30, 38),
    ColorAccent = Color3.fromRGB(90, 120, 255),
    ColorText = Color3.fromRGB(220, 220, 230),
    ColorTextDim = Color3.fromRGB(140, 140, 150),
    ColorHover = Color3.fromRGB(45, 45, 60),
    Font = Enum.Font.Gotham,
}

-- ==========================================
-- GUI PRINCIPAL
-- ==========================================
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "JDevLunarUI"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, Config.Width, 0, Config.Height)
MainFrame.Position = UDim2.new(0, Config.XPos, 0, Config.YPos)
MainFrame.BackgroundColor3 = Config.ColorPrimary
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim2.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.Parent = MainFrame

-- ==========================================
-- HEADER / TITLE BAR
-- ==========================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.Text = "⚡ JDev Lunar Ultimate"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextColor3 = Config.ColorText
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Parent = TitleBar

-- Botão Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Text = "─"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 20
MinimizeBtn.TextColor3 = Config.ColorTextDim
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Size = UDim2.new(0, 30, 1, -5)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2)
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeBtn

MinimizeBtn.MouseEnter:Connect(function()
    MinimizeBtn.BackgroundColor3 = Config.ColorSecondary
    MinimizeBtn.TextColor3 = Config.ColorText
end)

MinimizeBtn.MouseLeave:Connect(function()
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.TextColor3 = Config.ColorTextDim
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    local isMinimized = MainFrame.Size == UDim2.new(0, Config.Width, 0, Config.MinimizedHeight)
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, Config.Width, 0, Config.Height)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, Config.Width, 0, Config.MinimizedHeight)}):Play()
    end
end)

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 30, 1, -5)
CloseBtn.Position = UDim2.new(1, -5, 0, 2)
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainGui:Destroy()
end)

-- Drag Logic
local Dragging = false
local DragStart = nil
local StartPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragStart = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragStart and Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- SISTEMA DE ABAS
-- ==========================================
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, 0, 0, 35)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = TitleBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.Padding = UDim.new(0, 3)
TabLayout.Parent = TabsContainer

local Tabs = {"Teleport", "Frutas", "Player", "Admin", "ESP"}
local TabButtons = {}
local CurrentTab = "Teleport"

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Config.ColorTextDim
    btn.BackgroundColor3 = Config.ColorSecondary
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Parent = TabsContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    TabButtons[tabName] = btn
    
    btn.MouseEnter:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(0, 0, 0) then
            btn.BackgroundColor3 = Config.ColorHover
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(0, 0, 0) then
            btn.BackgroundColor3 = Config.ColorSecondary
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for _, tBtn in pairs(TabButtons) do
            tBtn.BackgroundColor3 = Config.ColorSecondary
            tBtn.TextColor3 = Config.ColorTextDim
        end
        
        -- Set active tab
        btn.BackgroundColor3 = Config.ColorAccent
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        CurrentTab = tabName
        LoadTab(tabName)
    end)
end

-- ==========================================
-- CONTAINER DE CONTEÚDO
-- ==========================================
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -10, 1, -45)
ContentContainer.Position = UDim2.new(0, 5, 0, 40)
ContentContainer.BackgroundColor3 = Config.ColorPrimary
ContentContainer.BorderSizePixel = 0
ContentContainer.BackgroundTransparency = 0.3
ContentContainer.ScrollBarThickness = 4
ContentContainer.ScrollBarImageColor3 = Config.ColorAccent
ContentContainer.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentContainer

function ClearContent()
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
            child:Destroy()
        end
    end
end

-- ==========================================
-- FUNÇÕES DE CRIAÇÃO DE UI
-- ==========================================
function CreateButton(text, icon, action, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Name = "ActionBtn"
    btn.Text = ""
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Config.ColorSecondary
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = ContentContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Text = icon or ""
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.TextColor3 = Config.ColorAccent
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.Parent = btn
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 13
    textLabel.TextColor3 = Config.ColorText
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, -45, 1, 0)
    textLabel.Position = UDim2.new(0, 38, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.ColorHover}):Play()
        textLabel.TextColor3 = Config.ColorText
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.ColorSecondary}):Play()
        textLabel.TextColor3 = Config.ColorText
    end)
    
    btn.MouseButton1Click:Connect(function()
        if action then action() end
    end)
    
    return btn
end

function CreateHeader(text)
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Text = text
    header.Font = Enum.Font.GothamBold
    header.TextSize = 12
    header.TextColor3 = Config.ColorAccent
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 20)
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = ContentContainer
    return header
end

-- ==========================================
--- CONTEÚDOS DAS ABAS
-- ==========================================

function LoadTab(tab)
    ClearContent()
    
    if tab == "Teleport" then
        CreateHeader("🌊 PRIME SEA")
        CreateButton("Marineford", "⚓", function() Teleport(Vector3.new(1000, 5, 2500)) end)
        CreateButton("Amazon Lily", "🌺", function() Teleport(Vector3.new(-3000, 5, 2500)) end)
        CreateButton("Sky Island", "☁️", function() Teleport(Vector3.new(0, 1500, 0)) end)
        CreateButton("Holy Tower", "🗼", function() Teleport(Vector3.new(0, 2000, 4500)) end)

        CreateHeader("🏴‍☠️ SECOND SEA")
        CreateButton("Colosseum", "🏟️", function() Teleport(Vector3.new(-5000, 5, 0)) end)
        CreateButton("Cursed Ship", "🚢", function() Teleport(Vector3.new(0, 5, -4000)) end)
        CreateButton("Haunted Castle", "👻", function() Teleport(Vector3.new(-3000, 5, -4000)) end)

        CreateHeader("🔥 THIRD SEA")
        CreateButton("Egghead", "🥚", function() Teleport(Vector3.new(6000, 5, 6000)) end)
        CreateButton("Mansion", "🏚️", function() Teleport(Vector3.new(6000, 5, -6000)) end)
        CreateButton("Hydra", "🐍", function() Teleport(Vector3.new(-8000, 5, 0)) end)

        CreateHeader("🛠️ ADMIN / DEV")
        CreateButton("Admin Island", "🛠️", function() Teleport(Vector3.new(0, 5, -10000)) end)
        CreateButton("Dev Room", "🔧", function() Teleport(Vector3.new(0, 1000, -15000)) end)

    elseif tab == "Frutas" then
        CreateHeader("🍎 FRUTAS BÁSICAS")
        CreateButton("Buddha", "🗿", function() SpawnFruit("Buddha") end)
        CreateButton("Dragon", "🐉", function() SpawnFruit("Dragon") end)
        CreateButton("Leopard", "🐆", function() SpawnFruit("Leopard") end)
        CreateButton("T-Rex", "🦖", function() SpawnFruit("T-Rex") end)
        CreateButton("Mammoth", "🐘", function() SpawnFruit("Mammoth") end)
        CreateButton("Dough", "🥯", function() SpawnFruit("Dough") end)
        CreateButton("Spirit", "👻", function() SpawnFruit("Spirit") end)
        CreateButton("Raid", "💣", function() SpawnFruit("Raid") end)
        CreateButton("Qilin", "🦄", function() SpawnFruit("Qilin") end)
        CreateButton("Jizo", "🎭", function() SpawnFruit("Jizo") end)

    elseif tab == "Player" then
        CreateHeader("⚡ MOVIMENTAÇÃO")
        CreateButton("Speed x10", "⚡", function() ChangeSpeed(50) end)
        CreateButton("Speed x20", "🚀", function() ChangeSpeed(70) end)
        CreateButton("Speed Max", "💨", function() ChangeSpeed(100) end)

        CreateHeader("🦅 HABILIDADES")
        CreateButton("Voo Ativar", "🦅", function() EnableFly(true) end)
        CreateButton("Voo Desativar", "🚫", function() EnableFly(false) end)
        CreateButton("High Jump", "🦘", function() ChangeJumpPower(100) end)
        CreateButton("God Mode", "❤️", function() EnableGodMode() end)

    elseif tab == "Admin" then
        CreateHeader("💰 COMANDOS GERAIS")
        CreateButton("Full Inventory", "🎒", function() FullInventory() end)
        CreateButton("Max Beli", "💰", function() SetBeli(999999999) end)
        CreateButton("Max Level", "📈", function() SetLevel(2550) end)
        CreateButton("Reset Stats", "🔄", function() ResetStats() end)
        CreateButton("Buy Haki (All)", "👁️", function() BuyAllHaki() end)
        CreateButton("Equip Raid", "🍎", function() EquipRaid() end)

    elseif tab == "ESP" then
        CreateHeader("👁️ VISUALIZAÇÃO")
        CreateButton("Toggle ESP On", "👁️", function() ToggleEsp(true) end)
        CreateButton("Toggle ESP Off", "❌", function() ToggleEsp(false) end)
        CreateButton("Toggle Aimbot", "🎯", function() ToggleAimbot() end)
    end
end

-- ==========================================
--- LÓGICA DO JOGO CORRIGIDA
-- ==========================================

function Teleport(pos)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(pos)
        print("[JDev] Teleportado para: " .. tostring(pos))
    else
        warn("[JDev] HumanoidRootPart não encontrado!")
    end
end

function SpawnFruit(name)
    local Remote = ReplicatedStorage:FindFirstChild("Remotes") and 
                   ReplicatedStorage.Remotes:FindFirstChild("CommF_") and 
                   ReplicatedStorage.Remotes.CommF_:FindFirstChild("RemoteEvent")
    
    if Remote then
        pcall(function()
            Remote:FireServer("RequestFruit", name)
            print("[JDev] Fruit solicitada: " .. name)
        end)
    else
        -- Fallback: cria tool no backpack
        local tool = Instance.new("Tool")
        tool.Name = name .. " Fruit"
        tool.Parent = Player.Backpack
        print("[JDev] Fruit criada no backpack: " .. name)
    end
end

function ChangeSpeed(val)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = val
        -- Mantém velocidade ativa
        spawn(function()
            while hum and hum.Parent do
                hum.WalkSpeed = val
                wait(0.5)
            end
        end)
        print("[JDev] Velocidade alterada para: " .. tostring(val))
    end
end

local flying = false
function EnableFly(state)
    flying = state
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")

    if state then
        if hum then hum.PlatformStand = true end
        print("[JDev] Voo Ativado.")
    else
        if hum then hum.PlatformStand = false end
        print("[JDev] Voo Desativado.")
    end
end

function ChangeJumpPower(val)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = val
        print("[JDev] Jump Power alterado para: " .. tostring(val))
    end
end

function EnableGodMode()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.MaxHealth = 999999
        hum.Health = 999999
        hum.HealthRegenRate = 100
        print("[JDev] God Mode Ativado!")
    end
end

function FullInventory()
    local Remote = ReplicatedStorage:FindFirstChild("Remotes") and 
                   ReplicatedStorage.Remotes:FindFirstChild("CommF_")
    if Remote then
        pcall(function()
            Remote.RemoteEvent:FireServer("Inventory", "Full")
            print("[JDev] Inventário cheio!")
        end)
    end
end

function SetBeli(amount)
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local beli = stats:FindFirstChild("Beli")
        if beli then 
            beli.Value = amount 
            print("[JDev] Beli definido para: " .. tostring(amount))
        end
    end
end

function SetLevel(level)
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local lvl = stats:FindFirstChild("Level")
        if lvl then 
            lvl.Value = level 
            print("[JDev] Nível definido para: " .. tostring(level))
        end
    end
end

function ResetStats()
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local statPoints = stats:FindFirstChild("StatPoints")
        if statPoints then 
            statPoints.Value = 0 
        end
        print("[JDev] Stats resetados.")
    end
end

function BuyAllHaki()
    local gui = Player.PlayerGui:FindFirstChild("MainGUI")
    if gui then
        local hakiTab = gui:FindFirstChild("HakiTab")
        if hakiTab then
            local buyBtn = hakiTab:FindFirstChild("Buy")
            if buyBtn then 
                pcall(function() buyBtn:Activate() end)
                print("[JDev] Haki comprado!")
            end
        end
    end
end

function EquipRaid()
    local Remote = ReplicatedStorage:FindFirstChild("Remotes") and 
                   ReplicatedStorage.Remotes:FindFirstChild("CommF_")
    if Remote then
        pcall(function()
            Remote.RemoteEvent:FireServer("UseFruit", "Raid")
            print("[JDev] Raid equipado!")
        end)
    end
end

-- ==========================================
--- ESP & AIMBOT SYSTEM (CORRIGIDO)
-- ==========================================
local espEnabled = false
local aimbotActive = false
local espLines = {}
local espBoxes = {}
local espBillboards = {}

function ToggleEsp(state)
    espEnabled = state
    if not state then
        -- Destroi todos os ESP
        for _, line in pairs(espLines) do 
            if line and line.Parent then line:Destroy() end 
        end
        espLines = {}
        for _, box in pairs(espBoxes) do 
            if box and box.Parent then box:Destroy() end 
        end
        espBoxes = {}
        for _, billboard in pairs(espBillboards) do 
            if billboard and billboard.Parent then billboard:Destroy() end 
        end
        espBillboards = {}
        print("[JDev] ESP Desligado!")
    else
        print("[JDev] ESP Ligado!")
    end
end

function ToggleAimbot()
    aimbotActive = not aimbotActive
    if aimbotActive then
        print("[JDev] Aimbot Ligado! Olhe para o alvo.")
    else
        print("[JDev] Aimbot Desligado.")
    end
end

RunService.RenderStepped:Connect(function()
    if not Player.Character then return end

    -- AIMBOT
    if aimbotActive then
        local mouse = Player:GetMouse()
        local hit = mouse.Hit.p
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Player.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        local raycastResult = workspace:Raycast(Player.Character.Head.Position, 
            (hit - Player.Character.Head.Position) * 100, raycastParams)

        if raycastResult and raycastResult.Instance then
            local instance = raycastResult.Instance
            local parent = instance.Parent

            if (parent:FindFirstChild("Humanoid") and parent ~= Player.Character) then
                local hum = parent:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local head = parent:FindFirstChild("Head") or parent:FindFirstChild("HumanoidRootPart")
                    if head then
                        -- Camera.CameraSubject = head
                    end
                end
            end
        end
    end

    -- ESP
    if espEnabled then
        -- Limpa ESP anterior
        for _, line in pairs(espLines) do 
            if line and line.Parent then line:Destroy() end 
        end
        espLines = {}
        for _, billboard in pairs(espBillboards) do 
            if billboard and billboard.Parent then billboard:Destroy() end 
        end
        espBillboards = {}

        for _, model in ipairs(workspace:GetChildren()) do
            if model ~= Player.Character and model:FindFirstChild("Humanoid") and model:FindFirstChild("Head") then
                local head = model.Head
                local hum = model.Humanoid
                local root = model:FindFirstChild("HumanoidRootPart")

                -- Billboard Gui
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPBillboard_" .. model.Name
                billboard.Size = UDim2.new(0, 100, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.Adornee = head
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                table.insert(espBillboards, billboard)

                local frame = Instance.new("Frame")
                frame.Name = "Background"
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.Parent = billboard

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "NameLabel"
                nameLabel.Text = model.Name
                nameLabel.TextColor3 = Config.ColorText
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 12
                nameLabel.Parent = billboard

                local healthBar = Instance.new("Frame")
                healthBar.Name = "HealthBar"
                healthBar.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 0.2, 0)
                healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                healthBar.Parent = billboard

                -- Line Adornment
                if root then
                    local line = Instance.new("LineHandleAdornment")
                    line.Name = "ESPLine_" .. model.Name
                    line.Length = head.Position.Y - root.Position.Y
                    line.Color3 = Color3.fromRGB(255, 0, 0)
                    line.Thickness = 1
                    local cframe = CFrame.new(root.Position, head.Position)
                    line.CFrame = cframe
                    line.Parent = head
                    table.insert(espLines, line)
                end
            end
        end
    end
end)

-- ==========================================
--- INICIALIZAÇÃO
-- ==========================================
LoadTab("Teleport")
print("[JDev] Painel Lunar Ultimate Carregado com Sucesso!")
print("[JDev] Versão Corrigida - Estilo Garnet Hub")
