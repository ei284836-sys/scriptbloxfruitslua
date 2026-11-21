-- ==========================================
-- JDEV ULTIMATE LUNAR UI - FIXED VERSION
-- ==========================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variáveis Globais
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "JDevLunar"
MainGui.ResetOnSpawn = false
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = Player.PlayerGui -- IMPORTANTE: Adicionado aqui

local Dragging = false
local DragStart = nil
local StartPos = nil
local CurrentTab = "Teleport"

-- ==========================================
-- CORE DO PAINEL
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 35)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local TitleButton = Instance.new("TextButton")
TitleButton.Name = "Title"
TitleButton.Text = "J"
TitleButton.Font = Enum.Font.GothamBold
TitleButton.TextSize = 20
TitleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleButton.BackgroundTransparency = 1
TitleButton.Size = UDim2.new(1, 0, 1, 0)
TitleButton.Parent = MainFrame

-- Container Principal
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(0, 260, 0, 350)
Container.Position = UDim2.new(0, 0, 0, 35)
Container.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Container.BorderSizePixel = 0
Container.BackgroundTransparency = 0.1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Container

-- Toggle Button
TitleButton.MouseButton1Click:Connect(function()
    if Container.Visible then
        TweenService:Create(Container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 0)}):Play()
        wait(0.2)
        Container.Visible = false
    else
        Container.Visible = true
        TweenService:Create(Container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 350)}):Play()
    end
end)

-- Drag Logic
MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragStart = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragStart and Dragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        Container.Position = UDim2.new(0, delta.X, 0, delta.Y + 35)
    end
end)

-- ==========================================
-- FUNÇÕES DE CRIAÇÃO DE UI
-- ==========================================
function CreateButton(text, icon, action, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = icon
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 18
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 5, 0, 0)
    iconLabel.Parent = btn
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, -40, 1, 0)
    textLabel.Position = UDim2.new(0, 35, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    btn.MouseButton1Click:Connect(action)
    return btn
end

function CreateHeader(text)
    local header = Instance.new("TextLabel")
    header.Text = text
    header.Font = Enum.Font.GothamBlack
    header.TextSize = 13
    header.TextColor3 = Color3.fromRGB(100, 100, 100)
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 20)
    header.TextXAlignment = Enum.TextXAlignment.Center
    header.Parent = Container
    return header
end

-- ==========================================
--- SISTEMA DE ABAS
-- ==========================================
local Tabs = {"Teleport", "Frutas", "Player", "Admin", "ESP"}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Size = UDim2.new(0, 50, 0, 30)
    btn.Position = UDim2.new(0, 5 + ((i-1)*55), 0, 0)
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    TabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, tBtn in pairs(TabButtons) do
            tBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            tBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
        UIListLayout.Parent = Container
        
        CurrentTab = tabName
        LoadTab(tabName)
    end)
end

-- ==========================================
--- CONTEÚDOS DAS ABAS
-- ==========================================

function LoadTab(tab)
    if tab == "Teleport" then
        CreateHeader("PRIME SEA")
        CreateButton("Marineford", "⚓", function() Teleport(Vector3.new(1000, 5, 2500)) end)
        CreateButton("Amazon Lily", "🌺", function() Teleport(Vector3.new(-3000, 5, 2500)) end)
        CreateButton("Sky Island", "☁️", function() Teleport(Vector3.new(0, 1500, 0)) end)
        CreateButton("Holy Tower", "🗼", function() Teleport(Vector3.new(0, 2000, 4500)) end)
        
        CreateHeader("SECOND SEA")
        CreateButton("Colosseum", "🏟️", function() Teleport(Vector3.new(-5000, 5, 0)) end)
        CreateButton("Cursed Ship", "🚢", function() Teleport(Vector3.new(0, 5, -4000)) end)
        CreateButton("Haunted Castle", "👻", function() Teleport(Vector3.new(-3000, 5, -4000)) end)
        
        CreateHeader("THIRD SEA")
        CreateButton("Egghead", "🥚", function() Teleport(Vector3.new(6000, 5, 6000)) end)
        CreateButton("Mansion", "🏚️", function() Teleport(Vector3.new(6000, 5, -6000)) end)
        CreateButton("Hydra", "🐍", function() Teleport(Vector3.new(-8000, 5, 0)) end)
        
        CreateHeader("ADMIN / DEV")
        CreateButton("Admin Island", "🛠️", function() Teleport(Vector3.new(0, 5, -10000)) end)
        CreateButton("Dev Room", "🔧", function() Teleport(Vector3.new(0, 1000, -15000)) end)
        
    elseif tab == "Frutas" then
        CreateHeader("FRUTAS BÁSICAS")
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
        CreateHeader("MOVIMENTAÇÃO")
        CreateButton("Speed x10", "⚡", function() ChangeSpeed(50) end)
        CreateButton("Speed x20", "🚀", function() ChangeSpeed(70) end)
        CreateButton("Speed Max", "💨", function() ChangeSpeed(100) end)
        
        CreateHeader("HABILIDADES")
        CreateButton("Voo Ativar", "🦅", function() EnableFly(true) end)
        CreateButton("Voo Desativar", "🚫", function() EnableFly(false) end)
        CreateButton("High Jump", "🦘", function() ChangeJumpPower(100) end)
        CreateButton("God Mode", "❤️", function() EnableGodMode() end)
        
    elseif tab == "Admin" then
        CreateHeader("COMANDOS GERAIS")
        CreateButton("Full Inventory", "🎒", function() FullInventory() end)
        CreateButton("Max Beli", "💰", function() SetBeli(999999999) end)
        CreateButton("Max Level", "📈", function() SetLevel(2550) end)
        CreateButton("Reset Stats", "🔄", function() ResetStats() end)
        CreateButton("Buy Haki (All)", "👁️", function() BuyAllHaki() end)
        CreateButton("Equip Raid", "🍎", function() EquipRaid() end)
        
    elseif tab == "ESP" then
        CreateHeader("VISUALIZAÇÃO")
        CreateButton("Toggle ESP On", "👁️", function() ToggleEsp(true) end)
        CreateButton("Toggle ESP Off", "❌", function() ToggleEsp(false) end)
        CreateButton("Toggle Aimbot", "🎯", function() ToggleAimbot() end)
    end
end

-- ==========================================
--- LÓGICA DO JOGO
-- ==========================================

function Teleport(pos)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(pos)
    end
end

function SpawnFruit(name)
    local Remote = ReplicatedStorage.Remotes.CommF_:FindFirstChild("RemoteEvent")
    if Remote then
        Remote:FireServer("RequestFruit", name)
    else
        local tool = Instance.new("Tool")
        tool.Name = name .. " Fruit"
        tool.Parent = Player.Backpack
    end
end

function ChangeSpeed(val)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = val
        while wait(1) do
            if hum then hum.WalkSpeed = val end
        end
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
    end
    
    RunService.RenderStepped:Connect(function()
        if flying and root and Player.Character then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                root.Velocity = root.Velocity + Vector3.new(0, 20, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                root.Velocity = root.Velocity - Vector3.new(0, 20, 0)
            end
        end
    end)
end

function ChangeJumpPower(val)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.JumpPower = val
    end
end

function EnableGodMode()
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.MaxHealth = 999999
        hum.Health = 999999
        hum.HealthRegenRate = 100
    end
end

function FullInventory()
    local Remote = ReplicatedStorage.Remotes.CommF_
    if Remote then
        Remote.RemoteEvent:FireServer("Inventory", "Full")
    end
end

function SetBeli(amount)
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local beli = stats:FindFirstChild("Beli")
        if beli then beli.Value = amount end
    end
end

function SetLevel(level)
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local lvl = stats:FindFirstChild("Level")
        if lvl then lvl.Value = level end
    end
end

function ResetStats()
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local statPoints = stats:FindFirstChild("StatPoints")
        if statPoints then statPoints.Value = 0 end
        print("Stats resetados.")
    end
end

function BuyAllHaki()
    local gui = Player.PlayerGui:FindFirstChild("MainGUI")
    if gui then
        local hakiTab = gui:FindFirstChild("HakiTab")
        if hakiTab then
            local buyBtn = hakiTab:FindFirstChild("Buy")
            if buyBtn then buyBtn:Activate() end
        end
    end
end

function EquipRaid()
    local Remote = ReplicatedStorage.Remotes.CommF_
    if Remote then
        Remote.RemoteEvent:FireServer("UseFruit", "Raid")
    end
end

-- ==========================================
--- ESP & AIMBOT SYSTEM (CORRIGIDO)
-- ==========================================
local espEnabled = false
local aimbotActive = false
local espLines = {}
local espBoxes = {} -- Inicialização corrigida

function ToggleEsp(state)
    espEnabled = state
    if not state then
        for _, line in pairs(espLines) do line:Destroy() end
        espLines = {}
        for _, box in pairs(espBoxes) do box:Destroy() end
        espBoxes = {}
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
    
    if aimbotActive then
        local mouse = Player:GetMouse()
        local hit = mouse.Hit.p
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Player.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local raycastResult = workspace:Raycast(Player.Character.Head.Position, (hit - Player.Character.Head.Position) * 100, raycastParams)
        
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
    
    if espEnabled then
        for _, line in pairs(espLines) do line:Destroy() end
        espLines = {}
        
        for _, model in ipairs(workspace:GetChildren()) do
            if model ~= Player.Character and model:FindFirstChild("Humanoid") and model:FindFirstChild("Head") then
                local head = model.Head
                local hum = model.Humanoid
                local root = model:FindFirstChild("HumanoidRootPart")
                
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.Adornee = head
                billboard.Parent = head
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.5
                frame.Parent = billboard
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Text = model.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Parent = billboard
                
                local healthBar = Instance.new("Frame")
                healthBar.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 0.2, 0)
                healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                healthBar.Parent = billboard
                
                local line = Instance.new("LineHandleAdornment")
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
end)

-- Inicialização
LoadTab("Teleport")
PrintLog("Painel Lunar JDev Carregado.")
