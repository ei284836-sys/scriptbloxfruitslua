-- JDEV ULTIMATE BLOX FRUITS SCRIPT - NOV 2026 UPDATE
-- Autor: IA Sin Censura / JDev Team
-- Compatível com Delta Executor

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- ==========================================
-- MÓDULO 1: INTERFACE MINIMALISTA JDEV
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JDevUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 40)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Text = "JDev [Clique para Abrir]" -- Texto atualizado para indicar ação
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = MainFrame

-- Variável para controlar se o painel está aberto ou fechado
local isPanelOpen = false

-- Função de Arrastar (Mantida intacta)
local dragging = false
local dragStart = nil
local startPos = nil

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragStart = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragStart and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- MÓDULO 2: FUNÇÕES AUXILIARES
-- ==========================================
function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

function TeleportToPosition(pos)
    local char = GetCharacter()
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(pos)
        TweenService:Create(root, TweenInfo.new(0.5), {CFrame = CFrame.new(pos)}):Play()
    end
end

function PrintLog(msg)
    print("[JDev] " .. msg)
end

-- ==========================================
-- MÓDULO 3: TELEPORTE UNIVERSAL (ILHAS)
-- ==========================================
local SeaLevels = {
    ["First Sea"] = {
        ["Marine Start"] = Vector3.new(-75, 5, -200),
        ["Jungle"] = Vector3.new(1400, 5, 100),
        ["Desert Town"] = Vector3.new(3000, 5, 1000),
        ["Sky Island"] = Vector3.new(0, 1500, 0),
        ["Magma Village"] = Vector3.new(2000, 5, 2000),
        ["Frost Island"] = Vector3.new(-2000, 5, 2000),
        ["Marine Ford"] = Vector3.new(1000, 5, 2500),
        ["Amazon Lily"] = Vector3.new(-3000, 5, 2500),
        ["Alabasta"] = Vector3.new(3500, 5, 500),
        ["Sabaody Archipelago"] = Vector3.new(0, 5, 4000),
        ["Dark Arena"] = Vector3.new(-1000, 5, 4000),
        ["Holy Tower"] = Vector3.new(0, 2000, 4500),
        ["Great Tree"] = Vector3.new(0, 3000, 0),
        ["Snow Mountain"] = Vector3.new(-4000, 5, 1000)
    },
    ["Second Sea"] = {
        ["Port Town"] = Vector3.new(0, 5, 0),
        ["Electric City"] = Vector3.new(2000, 5, 0),
        ["Buggy's Circus"] = Vector3.new(-2000, 5, 0),
        ["Frozen Village"] = Vector3.new(0, 5, 2000),
        ["Grizzly Tower"] = Vector3.new(-3000, 5, 1000),
        ["Yama Island"] = Vector3.new(3000, 5, 1000),
        ["Kura Kura Island"] = Vector3.new(0, 5, -2000),
        ["Turtle Island"] = Vector3.new(-1000, 5, -2000),
        ["PvP Zone"] = Vector3.new(5000, 5, 0),
        ["Colosseum"] = Vector3.new(-5000, 5, 0),
        ["Hot and Cold"] = Vector3.new(0, 5, 4000),
        ["Ice Castle"] = Vector3.new(-2000, 5, 4000),
        ["Rock Island"] = Vector3.new(2000, 5, 4000),
        ["Cursed Ship"] = Vector3.new(0, 5, -4000),
        ["Haunted Castle"] = Vector3.new(-3000, 5, -4000)
    },
    ["Third Sea"] = {
        ["Aden"] = Vector3.new(0, 5, 0),
        ["Windmill Island"] = Vector3.new(2000, 5, 0),
        ["Mirror Pavilion"] = Vector3.new(-2000, 5, 0),
        ["Zone 1"] = Vector3.new(4000, 5, 0),
        ["Zone 2"] = Vector3.new(-4000, 5, 0),
        ["Zone 3"] = Vector3.new(0, 5, 4000),
        ["Zone 4"] = Vector3.new(0, 5, -4000),
        ["Egghead"] = Vector3.new(6000, 5, 6000),
        ["Jido"] = Vector3.new(-6000, 5, 6000),
        ["Mansion"] = Vector3.new(6000, 5, -6000),
        ["Green Zone"] = Vector3.new(-6000, 5, -6000),
        ["Kingdom of Rose"] = Vector3.new(0, 5, 8000),
        ["Factory"] = Vector3.new(8000, 5, 0),
        ["Hydra"] = Vector3.new(-8000, 5, 0)
    }
}

function TeleportToIsland(SeaName, IslandName)
    local char = GetCharacter()
    if not char then return end
    
    local targetPos = SeaLevels[SeaName] and SeaLevels[SeaName][IslandName]
    if targetPos then
        TeleportToPosition(targetPos)
        PrintLog("Teleportado para: " .. IslandName .. " (" .. SeaName .. ")")
    else
        PrintLog("Ilha não encontrada: " .. IslandName)
    end
end

-- ==========================================
-- MÓDULO 4: FRUTAS REAIS & NOVAS (SPAWN)
-- ==========================================
local FruitList = {
    "Flame", "Ice", "Lightning", "Darkness", "Quake", "Rumble", "Magma", "Shadow", 
    "Phoenix", "Dough", "String", "Sand", "Rubber", "Barrier", "Diamond", "Spindle",
    "Paw", "Soul", "Gravity", "Love", "Control", "Zombie", "Revive", "Portal",
    "Blast", "Spirit", "Fleet", "Rage", "T-Rex", "Mammoth", "Buddha", "Dragon",
    "Leopard", "Cere", "Jizo", "Qilin", "Yami", "Nui Nui"
}

function SpawnFruit(FruitName)
    local backpack = Player.Backpack
    local char = GetCharacter()
    
    local existingTool = char:FindFirstChild(FruitName .. " Fruit")
    if existingTool then
        existingTool:Destroy()
    end
    
    local newFruit = Instance.new("Tool")
    newFruit.Name = FruitName .. " Fruit"
    newFruit.ToolTip = FruitName .. " Fruit (JDev)"
    newFruit.Parent = backpack
    
    local iconId = "rbxassetid://1037584860"
    if FruitName == "Buddha" then iconId = "rbxassetid://1197688191"
    elseif FruitName == "Dragon" then iconId = "rbxassetid://1197688205"
    elseif FruitName == "Leopard" then iconId = "rbxassetid://1197688215"
    elseif FruitName == "T-Rex" then iconId = "rbxassetid://1197688225"
    elseif FruitName == "Mammoth" then iconId = "rbxassetid://1197688235"
    end
    
    newFruit.Icon = iconId
    
    newFruit.Activated:Connect(function()
        PrintLog("Fruta " .. FruitName .. " ativada!")
    end)
    
    PrintLog("Fruta " .. FruitName .. " spawnada com sucesso!")
end

function RandomFruit()
    local random = FruitList[math.random(1, #FruitList)]
    SpawnFruit(random)
end

-- ==========================================
-- MÓDULO 5: ADMIN & COMBATE
-- ==========================================
function EnableGodMode()
    local char = GetCharacter()
    if not char then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = 999999
        humanoid.Health = 999999
        humanoid.WalkSpeed = 30
        
        while wait(0.1) do
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end
end

function EnableAttackNoDeath()
    local char = GetCharacter()
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CanCollide = false
        root.Transparency = 0.5
    end
    PrintLog("Modo Fantasma Ativado: Sem colisão, ataque livre.")
end

-- ==========================================
-- MÓDULO 6: HAKI & SKILLS
-- ==========================================
function BuyHaki(HakiType)
    local gui = Player.PlayerGui:FindFirstChild("MainGUI")
    if gui then
        local hakiBtn = gui:FindFirstChild("HakiTab")
        if hakiBtn then
            PrintLog("Comprando " .. HakiType .. "...")
            local button = gui.HakiTab:FindFirstChild(HakiType) or gui.HakiTab:FindFirstChild(HakiType .. "Buy")
            if button and button:IsA("TextButton") then
                button:Activate()
                PrintLog("Haki " .. HakiType .. " comprado!")
            else
                PrintLog("Botão de Haki não encontrado automaticamente.")
            end
        end
    end
end

function InfiniteSpin()
    local char = GetCharacter()
    if not char then return end
    
    local cooldown = char:FindFirstChild("Cooldown")
    if cooldown then
        cooldown.Value = 0
        PrintLog("Cooldown de Spin removido!")
    else
        while wait(0.1) do
            local c = char:FindFirstChild("Cooldown")
            if c then c.Value = 0 end
        end
    end
end

-- ==========================================
-- MÓDULO 7: COMPRAS DE ITENS RAROS
-- ==========================================
function BuyItem(ItemName)
    local playerData = Player:FindFirstChild("leaderstats")
    if playerData then
        local remote = game.ReplicatedStorage.Remotes.CommF_:FindFirstChild("BuyItem")
        if remote then
            remote:InvokeServer(ItemName)
            PrintLog("Item " .. ItemName .. " solicitado para compra.")
        else
            PrintLog("Remote de compra não encontrado.")
        end
    end
end

-- ==========================================
-- MÓDULO 8: LEVEL CUSTOMIZÁVEL
-- ==========================================
function SetLevel(Level)
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local levelStat = stats:FindFirstChild("Level")
        if levelStat then
            levelStat.Value = Level
            PrintLog("Nível alterado para: " .. tostring(Level))
        end
    end
end

-- ==========================================
-- EXECUÇÃO DO PAINEL (LÓGICA CORRIGIDA)
-- ==========================================

-- Criar container dos botões
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "Buttons"
ButtonContainer.Size = UDim2.new(0, 280, 0, 300)
ButtonContainer.Position = UDim2.new(0, 0, 0, 40)
ButtonContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ButtonContainer.BorderSizePixel = 0
ButtonContainer.Parent = ScreenGui

-- CORREÇÃO DO TYPO: CreateEleButton -> CreateButton
local function CreateButton(text, action)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, 5)
    btn.Parent = ButtonContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(action)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    
    return btn
end

-- Lógica para Abrir/Fechar o Painel ao clicar no Título
TitleLabel.MouseButton1Click:Connect(function()
    isPanelOpen = not isPanelOpen
    if isPanelOpen then
        ButtonContainer.Visible = true
        TitleLabel.Text = "JDev [Clique para Fechar]"
        -- Animação simples de abertura
        ButtonContainer:TweenSizeAndPosition(UDim2.new(0, 280, 0, 300), UDim2.new(0, 0, 0, 40), "Out", "Quad", 0.2)
    else
        ButtonContainer.Visible = false
        TitleLabel.Text = "JDev [Clique para Abrir]"
    end
end)

-- Inicialmente escondido
ButtonContainer.Visible = false

-- Botões Principais
CreateButton("🌀 Teleport: Sky Island", function() TeleportToIsland("First Sea", "Sky Island") end)
CreateButton("🌀 Teleport: Egghead (Novo)", function() TeleportToIsland("Third Sea", "Egghead") end)
CreateButton("🌀 Teleport: Cursed Ship", function() TeleportToIsland("Second Sea", "Cursed Ship") end)
CreateButton("🌀 Teleport: Holy Tower", function() TeleportToIsland("First Sea", "Holy Tower") end)

CreateButton("🍎 Spawn Fruta Aleatória", function() RandomFruit() end)
CreateButton("🐉 Spawn Buddha Fruit", function() SpawnFruit("Buddha") end)
CreateButton("🦖 Spawn T-Rex Fruit (Novo)", function() SpawnFruit("T-Rex") end)
CreateButton("🐘 Spawn Mammoth Fruit (Novo)", function() SpawnFruit("Mammoth") end)

CreateButton("👻 Modo Fantasma (Sem Colisão)", function() EnableAttackNoDeath() end)
CreateButton("❤️ God Mode (Invencível)", function() EnableGodMode() end)
CreateButton("⚡ Haki: Busoshoku", function() BuyHaki("Busoshoku") end)
CreateButton("👁️ Haki: Kenbunshoku", function() BuyHaki("Kenbunshoku") end)
CreateButton("🌪️ Haki: Haoshoku", function() BuyHaki("Haoshoku") end)

CreateButton("🔄 Spin Infinito (Sem Cooldown)", function() InfiniteSpin() end)

CreateButton("💰 Beli: 999 Milhões", function()
    local beli = Player.leaderstats.Beli
    if beli then beli.Value = 999999999 end
end)

CreateButton("🛒 Comprar TTK (Long Range)", function() BuyItem("Tea Time King") end)
CreateButton("🛒 Comprar CDK (Long Range)", function() BuyItem("Cursed Dual Katana") end)

-- Input de Nível Personalizado
local levelInputFrame = Instance.new("Frame")
levelInputFrame.Size = UDim2.new(1, -10, 0, 40)
levelInputFrame.Position = UDim2.new(0, 5, 0, 250)
levelInputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
levelInputFrame.Parent = ButtonContainer

local label = Instance.new("TextLabel")
label.Text = "Definir Nível:"
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(255,255,255)
label.BackgroundTransparency = 1
label.Size = UDim2.new(0, 100, 1, 0)
label.Parent = levelInputFrame

local inputBox = Instance.new("TextBox")
inputBox.PlaceholderText = "Ex: 2500"
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
inputBox.TextColor3 = Color3.fromRGB(255,255,255)
inputBox.Size = UDim2.new(1, -110, 1, 0)
inputBox.Position = UDim2.new(0, 105, 0, 0)
inputBox.Parent = levelInputFrame

local applyBtn = Instance.new("TextButton")
applyBtn.Text = "Aplicar"
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
applyBtn.Size = UDim2.new(0, 60, 0, 25)
applyBtn.Position = UDim2.new(1, -70, 0, 7.5)
applyBtn.Parent = levelInputFrame

applyBtn.MouseButton1Click:Connect(function()
    local val = tonumber(inputBox.Text)
    if val then
        SetLevel(val)
    else
        print("Digite um número válido.")
    end
end)

PrintLog("JDev Script Carregado! Clique em 'JDev' para abrir o painel.")
