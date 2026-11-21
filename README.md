--=====================================================================
--  JDEV ULTIMATE  •  LUNAR STYLE  •  CLEAN BUILD
--  Painel arrastável, abas isoladas, ESP estilo Free Fire, aimbot,
--  spawner físico de frutas/items e ilhas de admin.
--=====================================================================
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Run     = game:GetService("RunService")
local Tween   = game:GetService("TweenService")
local UIS     = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Cam    = workspace.CurrentCamera

local old = Player.PlayerGui:FindFirstChild("JDEV")
if old then old:Destroy() end

--==================== PALETA / HELPERS ================================
local C = {
	bg     = Color3.fromRGB(11, 11, 14),
	panel  = Color3.fromRGB(17, 17, 21),
	card   = Color3.fromRGB(23, 23, 29),
	hover  = Color3.fromRGB(33, 33, 42),
	line   = Color3.fromRGB(38, 38, 48),
	text   = Color3.fromRGB(230, 230, 238),
	dim    = Color3.fromRGB(118, 118, 132),
	accent = Color3.fromRGB(139, 124, 255),
	good   = Color3.fromRGB(88, 222, 143),
	bad    = Color3.fromRGB(255, 96, 96),
}

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end
local function corner(o, r) new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, col, t, tr)
	new("UIStroke", { Color = col or C.line, Thickness = t or 1, Transparency = tr or 0.45 }, o)
end

local vp = Cam.ViewportSize
local W  = math.clamp(vp.X - 56, 292, 396)
local H  = math.clamp(vp.Y - 130, 330, 520)

--==================== GUI RAIZ ========================================
local Gui = new("ScreenGui", {
	Name = "JDEV", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = Player.PlayerGui,
})

--==================== NOTIFICAÇÕES ====================================
local toastHolder = new("Frame", {
	Size = UDim2.new(0, 260, 1, -20), Position = UDim2.new(1, -280, 0, 10),
	BackgroundTransparency = 1, Parent = Gui,
})
new("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6),
}, toastHolder)

local toastCount = 0
local function Notify(txt, bad)
	toastCount += 1
	local card = new("Frame", {
		Size = UDim2.new(0, 0, 0, 30), BackgroundColor3 = C.card,
		BackgroundTransparency = 0.05, LayoutOrder = toastCount, Parent = toastHolder,
	})
	corner(card, 8)
	stroke(card, bad and C.bad or C.accent, 1, 0.35)
	local bar = new("Frame", {
		Size = UDim2.new(0, 3, 0.6, 0), Position = UDim2.new(0, 6, 0.2, 0),
		BackgroundColor3 = bad and C.bad or C.accent, BorderSizePixel = 0, Parent = card,
	})
	corner(bar, 2)
	new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -22, 1, 0), Position = UDim2.new(0, 16, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
	})
	Tween:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 236, 0, 30) }):Play()
	task.delay(2.4, function()
		Tween:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		Tween:Create(bar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		for _, d in ipairs(card:GetDescendants()) do
			if d:IsA("TextLabel") then Tween:Create(d, TweenInfo.new(0.2), { TextTransparency = 1 }):Play() end
		end
		task.wait(0.25)
		card:Destroy()
	end)
end

--==================== DRAG UNIVERSAL ==================================
local function draggable(frame, handle)
	local dragging, dragInput, start, origin
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, start, origin = true, i.Position, frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			dragInput = i
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if i ~= dragInput or not dragging then return end
		local d = i.Position - start
		local nx = math.clamp(origin.X.Offset + d.X, 0, Cam.ViewportSize.X - frame.AbsoluteSize.X)
		local ny = math.clamp(origin.Y.Offset + d.Y, 0, Cam.ViewportSize.Y - frame.AbsoluteSize.Y)
		frame.Position = UDim2.new(0, nx, 0, ny)
	end)
end

--==================== ORBE "J" ========================================
local Orb = new("TextButton", {
	Name = "Orb", Text = "", Size = UDim2.new(0, 46, 0, 46),
	Position = UDim2.new(0, 16, 0.5, -23), BackgroundColor3 = C.panel,
	AutoButtonColor = false, Parent = Gui,
})
corner(Orb, 23)
stroke(Orb, C.accent, 1, 0.15)
new("TextLabel", {
	Text = "J", Font = Enum.Font.GothamBlack, TextSize = 22, TextColor3 = C.accent,
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Orb,
})
draggable(Orb, Orb)

--==================== JANELA ==========================================
local Win = new("Frame", {
	Name = "Window", Size = UDim2.new(0, W, 0, H),
	Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = C.bg, Visible = false, ClipsDescendants = true, Parent = Gui,
})
corner(Win, 14)
stroke(Win, C.line, 1, 0.2)

-- brilho superior
new("Frame", {
	Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = C.accent,
	BackgroundTransparency = 0.93, BorderSizePixel = 0, Parent = Win,
})

-- topbar
local Top = new("Frame", {
	Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Parent = Win,
})
draggable(Win, Top)

local Badge = new("Frame", {
	Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 12, 0, 9),
	BackgroundColor3 = C.card, Parent = Top,
})
corner(Badge, 7)
new("TextLabel", {
	Text = "J", Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = C.accent,
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Badge,
})
new("TextLabel", {
	Text = "JDEV", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.dim,
	BackgroundTransparency = 1, Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(0, 42, 0, 9),
	TextXAlignment = Enum.TextXAlignment.Left, Parent = Top,
})

local MinBtn = new("TextButton", {
	Text = "—", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.dim,
	BackgroundColor3 = C.card, Size = UDim2.new(0, 24, 0, 24),
	Position = UDim2.new(1, -36, 0, 9), AutoButtonColor = false, Parent = Top,
})
corner(MinBtn, 7)
MinBtn.MouseEnter:Connect(function() Tween:Create(MinBtn, TweenInfo.new(0.12), { TextColor3 = C.text }):Play() end)
MinBtn.MouseLeave:Connect(function() Tween:Create(MinBtn, TweenInfo.new(0.12), { TextColor3 = C.dim }):Play() end)
MinBtn.MouseButton1Click:Connect(function() Win.Visible = false end)

--==================== ABAS ============================================
local TabBar = new("ScrollingFrame", {
	Size = UDim2.new(1, -24, 0, 32), Position = UDim2.new(0, 12, 0, 44),
	BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
	CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollingDirection = Enum.ScrollingDirection.X, Parent = Win,
})
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5),
	SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
}, TabBar)

local Pages = new("Frame", {
	Size = UDim2.new(1, -24, 1, -96), Position = UDim2.new(0, 12, 0, 84),
	BackgroundTransparency = 1, Parent = Win,
})

local TabBtns, PageFrames = {}, {}
local activeTab

local function newPage(name)
	local p = new("ScrollingFrame", {
		Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.line,
		CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false, Parent = Pages,
	})
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, p)
	new("UIPadding", { PaddingBottom = UDim.new(0, 12) }, p)
	PageFrames[name] = p
	return p
end

--==================== COMPONENTES =====================================
local function Section(page, txt)
	local holder = new("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = page })
	new("TextLabel", {
		Text = string.upper(txt), Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
		TextXAlignment = Enum.TextXAlignment.Left, Parent = holder,
	})
	return holder
end

local function Button(page, txt, cb, accent)
	local b = new("TextButton", {
		Text = "", Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.card,
		AutoButtonColor = false, Parent = page,
	})
	corner(b, 8)
	stroke(b, C.line, 1, 0.6)
	local lbl = new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 13,
		TextColor3 = accent and C.accent or C.text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -18, 1, 0), Position = UDim2.new(0, 11, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
	})
	b.MouseEnter:Connect(function()
		Tween:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = C.hover }):Play()
	end)
	b.MouseLeave:Connect(function()
		Tween:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = C.card }):Play()
	end)
	b.MouseButton1Click:Connect(function()
		Tween:Create(b, TweenInfo.new(0.08), { BackgroundColor3 = C.hover }):Play()
		task.delay(0.1, function() if b.Parent then Tween:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play() end end)
		cb(b)
	end)
	return b, lbl
end

local function Toggle(page, txt, default, cb)
	local state = default or false
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.card, Parent = page })
	corner(row, 8)
	stroke(row, C.line, 1, 0.6)
	new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 11, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
	})
	local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = row })
	local track = new("Frame", {
		Size = UDim2.new(0, 32, 0, 17), Position = UDim2.new(1, -43, 0.5, -8.5),
		BackgroundColor3 = Color3.fromRGB(45, 45, 55), Parent = row,
	})
	corner(track, 9)
	local knob = new("Frame", {
		Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 2, 0.5, -6.5),
		BackgroundColor3 = C.text, Parent = track,
	})
	corner(knob, 7)

	local function apply(v)
		state = v
		Tween:Create(track, TweenInfo.new(0.16, Enum.EasingStyle.Quint), {
			BackgroundColor3 = v and C.accent or Color3.fromRGB(45, 45, 55),
		}):Play()
		Tween:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quint), {
			Position = v and UDim2.new(1, -15, 0.5, -6.5) or UDim2.new(0, 2, 0.5, -6.5),
		}):Play()
		cb(v)
	end

	hit.MouseButton1Click:Connect(function() apply(not state) end)
	return { set = apply, get = function() return state end, row = row }
end

local function Slider(page, txt, min, max, default, cb)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = C.card, Parent = page })
	corner(row, 8)
	stroke(row, C.line, 1, 0.6)
	local lbl = new("TextLabel", {
		Text = txt .. "  " .. tostring(default), Font = Enum.Font.GothamMedium, TextSize = 12,
		TextColor3 = C.text, BackgroundTransparency = 1, Size = UDim2.new(1, -22, 0, 24),
		Position = UDim2.new(0, 11, 0, 5), TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
	})
	local track = new("Frame", {
		Size = UDim2.new(1, -22, 0, 4), Position = UDim2.new(0, 11, 0, 34),
		BackgroundColor3 = Color3.fromRGB(45, 45, 55), Parent = row,
	})
	corner(track, 2)
	local fill = new("Frame", {
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = C.accent, BorderSizePixel = 0, Parent = track,
	})
	corner(fill, 2)
	local knob = new("Frame", {
		Size = UDim2.new(0, 10, 0, 10), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0), BackgroundColor3 = C.text, Parent = track,
	})
	corner(knob, 5)

	local dragging = false
	local function set(alpha)
		alpha = math.clamp(alpha, 0, 1)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		local val = math.floor(min + (max - min) * alpha + 0.5)
		lbl.Text = txt .. "  " .. tostring(val)
		cb(val)
	end
	local function fromX(x)
		local rel = (x - track.AbsolutePosition.X) / track.AbsoluteSize.X
		set(rel)
	end
	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			fromX(i.Position.X)
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			fromX(i.Position.X)
		end
	end)
	return { set = function(v) set((v - min) / (max - min)) end }
end

local function Input(page, placeholder, onSubmit)
	local box = new("TextBox", {
		Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, Text = "",
		PlaceholderText = placeholder, PlaceholderColor3 = C.dim, Font = Enum.Font.GothamMedium,
		TextSize = 12, TextColor3 = C.text, ClearTextOnFocus = false, Parent = page,
	})
	corner(box, 8)
	stroke(box, C.line, 1, 0.6)
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, box)
	box.FocusLost:Connect(function(enter)
		if enter and box.Text ~= "" then
			onSubmit(box.Text)
			box.Text = ""
		end
	end)
	return box
end

local function Grid(page, cols)
	local g = new("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Parent = page })
	new("UIGridLayout", {
		CellSize = UDim2.new(1 / cols, -4, 0, 30), CellPadding = UDim2.new(0, 4, 0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, g)
	return g
end

--==================== ABAS DECLARADAS =================================
local TABS = { "Teleport", "Frutas", "Player", "Combate", "Visual", "Admin" }
for i, name in ipairs(TABS) do
	local b = new("TextButton", {
		Text = name, Font = Enum.Font.GothamSemibold, TextSize = 12, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.new(0, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = i, AutoButtonColor = false, Parent = TabBar,
	})
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, b)
	corner(b, 7)
	TabBtns[name] = b
	b.MouseButton1Click:Connect(function()
		if activeTab == name then return end
		for n, btn in pairs(TabBtns) do
			btn.TextColor3 = C.dim
			btn.BackgroundColor3 = C.card
			PageFrames[n].Visible = false
		end
		activeTab = name
		b.TextColor3 = C.accent
		b.BackgroundColor3 = C.hover
		PageFrames[name].Visible = true
	end)
end

local function showTab(name)
	TabBtns[name]:MouseButton1Click? -- noop
	for n, btn in pairs(TabBtns) do
		btn.TextColor3 = C.dim
		btn.BackgroundColor3 = C.card
		PageFrames[n].Visible = false
	end
	activeTab = name
	TabBtns[name].TextColor3 = C.accent
	TabBtns[name].BackgroundColor3 = C.hover
	PageFrames[name].Visible = true
end

--==================== ESTADO DO PLAYER ================================
local state = { speed = 16, jump = 50, god = false, infJump = false, noclip = false, fly = false, flySpeed = 60 }

local function char() return Player.Character end
local function root()
	local c = char()
	return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end
local function hum()
	local c = char()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function applyStats()
	local h = hum()
	if h then
		h.WalkSpeed = state.speed
		if h.UseJumpPower then h.JumpPower = state.jump else h.JumpHeight = state.jump / 3.2 end
		if state.god then
			h.MaxHealth = math.huge
			h.Health = h.MaxHealth
		end
	end
end
Run.Heartbeat:Connect(applyStats)

Player.CharacterAdded:Connect(function()
	task.wait(1.2)
	state.fly = false
	applyStats()
end)

--==================== TELEPORTES (EDITÁVEL) ===========================
local PLACES = {
	["Primeiro Mar"] = {
		{ "Fruit Dealer", Vector3.new(0, 5, 0) },
		{ "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Amazon Lily", Vector3.new(-3000, 5, 2500) },
		{ "Sky Island", Vector3.new(-7863, 5545, -378) },
		{ "Holy Tower", Vector3.new(0, 2000, 4500) },
	},
	["Segundo Mar"] = {
		{ "Colosseum", Vector3.new(-5000, 5, 0) },
		{ "Cursed Ship", Vector3.new(0, 5, -4000) },
		{ "Haunted Castle", Vector3.new(-3000, 5, -4000) },
		{ "Café", Vector3.new(-386, 74, -314) },
	},
	["Terceiro Mar"] = {
		{ "Egghead", Vector3.new(6000, 5, 6000) },
		{ "Mansion", Vector3.new(6000, 5, -6000) },
		{ "Hydra", Vector3.new(-8000, 5, 0) },
		{ "Great Tree", Vector3.new(-1055, 328, -8916) },
	},
	["Admin / Dev"] = {
		{ "Admin Island", Vector3.new(0, 5, -10000) },
		{ "Admin Room", Vector3.new(0, 5, -12500) },
		{ "Dev Room", Vector3.new(0, 1000, -15000) },
		{ "Skybox / Vazio", Vector3.new(0, 3000, 0) },
	},
}

local function TP(pos, label)
	local r = root()
	if not r then return Notify("Sem personagem", true) end
	if (r.Position - pos).Magnitude > 3000 then
		pcall(function()
			RS.Remotes.CommF_:InvokeServer("requestEntrance", pos)
		end)
		task.wait(0.5)
	end
	r.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
	Notify("→ " .. (label or "Destino"))
end

--==================== FRUTAS ==========================================
local FRUITS = {
	"Dragon", "Kitsune", "Magnet", "Yeti", "Control", "Gas", "Leopard", "Dough",
	"T-Rex", "Spirit", "Mammoth", "Tiger", "Empyrean", "Fiend", "Werewolf",
	"Venom", "Shadow", "Blizzard", "Gravity", "Pain", "Rumble", "Light", "Love",
	"Portal", "Buddha", "Quake", "Magma", "Spider", "Sound", "Phoenix", "Falcon",
	"Ice", "Sand", "Dark", "Diamond", "Rubber", "Barrier", "Flame", "Spring",
	"Bomb", "Smoke", "Spike", "Chop", "Revive", "Blade", "Ghost", "Eagle",
	"Rocket", "Spin", "Kilo",
}

local fruitMode = "physical" -- physical | real
local spawnedFruits = {}

local function findTemplate(name)
	local keys = { name, name .. " Fruit", name .. "-" .. name, name .. "-" .. name .. " Fruit" }
	local function match(o)
		for _, k in ipairs(keys) do
			if o.Name:lower() == k:lower() then return true end
		end
		return false
	end
	local containers = { RS, workspace }
	for _, c in ipairs(containers) do
		for _, d in ipairs(c:GetDescendants()) do
			if (d:IsA("Tool") or d:IsA("Model")) and match(d) then return d end
		end
	end
end

local function spawnPhysical(name)
	local tmpl = findTemplate(name)
	if not tmpl then return false end
	local clone = tmpl:Clone()
	clone.Name = name .. " Fruit"
	if #spawnedFruits > 30 then
		local oldF = table.remove(spawnedFruits, 1)
		if oldF and oldF.Parent then oldF:Destroy() end
	end
	local r = root()
	local origin = r and (r.CFrame * CFrame.new(0, 3, -6)).Position or Vector3.new(0, 60, 0)
	if clone:IsA("Model") then
		for _, p in ipairs(clone:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = false
				p.CanCollide = true
			end
		end
		clone.Parent = workspace
		if clone.PrimaryPart then clone:PivotTo(CFrame.new(origin)) else
			local first = clone:FindFirstChildWhichIsA("BasePart")
			if first then first.Position = origin end
		end
	else
		local handle = clone:FindFirstChild("Handle") or clone:FindFirstChildWhichIsA("BasePart")
		clone.Parent = workspace
		if handle then
			handle.Anchored = false
			handle.CanCollide = true
			handle.Position = origin
		end
	end
	local hi = new("Highlight", { FillTransparency = 0.7, OutlineTransparency = 0.1, FillColor3 = C.accent, OutlineColor3 = C.accent }, clone)
	table.insert(spawnedFruits, clone)
	task.delay(60, function() if hi then hi:Destroy() end end)
	return true
end

local function fruitAction(name)
	if fruitMode == "real" then
		local ok = pcall(function()
			RS.Remotes.CommF_:InvokeServer("BuyFruit", name .. "-" .. name)
		end)
		pcall(function() RS.Remotes.CommF_:InvokeServer("LoadFruit", name) end)
		Notify(ok and ("Servidor: " .. name) or ("Falha: " .. name), not ok)
	else
		if spawnPhysical(name) then
			Notify(name .. " gerada (física)")
		else
			pcall(function() RS.Remotes.CommF_:InvokeServer("LoadFruit", name) end)
			Notify(name .. " enviada ao inventário")
		end
	end
end

--==================== ITEMS (ADMIN) ===================================
local ITEMS = {
	"Dark Blade", "Cursed Dual Katana", "Saber", "Bisento", "Dragon Trident",
	"Hallow Scythe", "Saddi", "Kabucha", "Serpent Bow", "Bazooka", "Cannon",
	"Flintlock", "Musket", "Slingshot", "Acidum Rifle", "Bizarre Rifle",
	"Katana", "Cutlass", "Trident", "Pole (2nd Form)", "Superhuman", "Godhuman",
	"Sanguine Art", "Electric Claw", "Dragon Talon", "Sharkman Karate",
	"Death Step", "Mink", "Rokushiki",
}

local function giveTool(name)
	local tmpl = findTemplate(name)
	if tmpl and tmpl:IsA("Tool") then
		local bp = Player:FindFirstChild("Backpack")
		if not bp then return Notify("Sem backpack", true) end
		local clone = tmpl:Clone()
		clone.Parent = bp
		return Notify("Item: " .. name)
	end
	local ok = pcall(function()
		RS.Remotes.CommF_:InvokeServer("BuyItem", name)
	end)
	Notify(ok and ("Servidor: " .. name) or ("Não encontrado: " .. name), not ok)
end

--==================== ESP =============================================
local esp = { on = false, box = true, name = true, hp = true, skel = true, tracer = true, fruit = false, team = false }
local espCache = {}

local BONES = {
	{ "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
	{ "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
	{ "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
	{ "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
	{ "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
	{ "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" },
	{ "Torso", "Left Leg" }, { "Torso", "Right Leg" },
}

local function clearEsp()
	for char in pairs(espCache) do
		local d = espCache[char]
		if d.box then d.box:Destroy() end
		if d.bill then d.bill:Destroy() end
		if d.lines then for _, l in ipairs(d.lines) do l:Destroy() end end
		if d.tracer then d.tracer:Destroy() end
	end
	espCache = {}
end

local function buildEsp(char, isPlayer, plr)
	if espCache[char] then return end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local h = char:FindFirstChildOfClass("Humanoid")
	local head = char:FindFirstChild("Head") or hrp
	if not hrp or not h then return end
	local col = (isPlayer and plr and plr.Team and plr.Team.TeamColor.Color) or Color3.fromRGB(255, 90, 90)
	local d = { lines = {} }

	if esp.box then
		d.box = new("BoxHandleAdornment", {
			Size = Vector3.new(4, 5.4, 2), AlwaysOnTop = true, ZIndex = 5,
			Transparency = 0.4, Color3 = col, Adornee = hrp, Parent = hrp,
		})
	end
	if esp.name or esp.hp then
		d.bill = new("BillboardGui", {
			Size = UDim2.new(0, 130, 0, 40), StudsOffset = Vector3.new(0, 2.6, 0),
			AlwaysOnTop = true, Adornee = head, Parent = head,
		})
		if esp.name then
			d.label = new("TextLabel", {
				Text = char.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.4, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15), Parent = d.bill,
			})
		end
		if esp.hp then
			local bg = new("Frame", {
				Size = UDim2.new(0.8, 0, 0, 5), Position = UDim2.new(0.1, 0, 0, 17),
				BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0, Parent = d.bill,
			})
			corner(bg, 2)
			d.fill = new("Frame", {
				Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.good, BorderSizePixel = 0, Parent = bg,
			})
			corner(d.fill, 2)
			d.hpbg = bg
		end
	end
	if esp.skel then
		for i = 1, #BONES do
			d.lines[i] = new("LineHandleAdornment", {
				Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 6,
				Adornee = hrp, Parent = Cam, Length = 0,
			})
		end
	end
	if esp.tracer then
		d.tracer = new("LineHandleAdornment", {
			Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 4, Parent = Cam, Length = 0,
		})
	end
	espCache[char] = d
end

local function updateEsp()
	for char, d in pairs(espCache) do
		if not char.Parent then
			clearEsp() -- recria tudo no próximo ciclo
			break
		end
		local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
		local head = char:FindFirstChild("Head")
		local h = char:FindFirstChildOfClass("Humanoid")
		if d.box and hrp then d.box.Adornee = hrp end
		if d.bill and head then d.bill.Adornee = head end
		if d.fill and h then
			d.fill.Size = UDim2.new(math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1), 0, 1, 0)
			d.fill.BackgroundColor3 = C.good:Lerp(C.bad, 1 - math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1))
		end
		if d.label then
			local dist = head and (Cam.CFrame.Position - head.Position).Magnitude or 0
			d.label.Text = char.Name .. "  [" .. math.floor(dist) .. "]"
		end
		if hrp then
			for i, pair in ipairs(BONES) do
				local line = d.lines[i]
				if line then
					local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
					if a and b then
						local pa, pb = a.Position, b.Position
						line.Length = (pa - pb).Magnitude
						line.CFrame = CFrame.new((pa + pb) / 2, pb)
					else
						line.Length = 0
					end
				end
			end
			if d.tracer and head then
				local origin = Cam.CFrame.Position + Cam.CFrame.LookVector * 2 + Cam.CFrame.UpVector * -1.4
				d.tracer.Length = (origin - head.Position).Magnitude
				d.tracer.CFrame = CFrame.new((origin + head.Position) / 2, head.Position)
			end
		end
	end
end

Run.RenderStepped:Connect(function()
	if not esp.on then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			if esp.team and plr.Team == Player.Team then
				-- pula aliado
			else
				local h = plr.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Health > 0 then buildEsp(plr.Character, true, plr) end
			end
		end
	end
	if esp.fruit then
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj.Name:find("Fruit") and not obj:FindFirstChildOfClass("Humanoid") and not espCache[obj] then
				buildEsp(obj, false)
			end
		end
	end
	updateEsp()
end)

--==================== AIMBOT ==========================================
local aim = { on = false, fov = 150, smooth = 0.22, predict = false, team = true }

local fovCircle = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, aim.fov * 2, 0, aim.fov * 2), BackgroundTransparency = 1,
	Visible = false, Parent = Gui,
})
corner(fovCircle, 9999)
stroke(fovCircle, C.accent, 1, 0.55)

Run.RenderStepped:Connect(function()
	if not aim.on then return end
	local r = root()
	if not r then return end
	local center = Cam.ViewportSize / 2
	local best, bestDist
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			local h = plr.Character:FindFirstChildOfClass("Humanoid")
			local hd = plr.Character:FindFirstChild("Head")
			local isTeam = aim.team and plr.Team == Player.Team
			if h and hd and h.Health > 0 and not isTeam then
				local sp, vis = Cam:WorldToViewportPoint(hd.Position)
				if vis then
					local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
					if dist < aim.fov and (not bestDist or dist < bestDist) then
						best, bestDist = hd, dist
					end
				end
			end
		end
	end
	if best then
		local target = best.Position
		if aim.predict then
			target += best.AssemblyLinearVelocity * 0.14
		end
		Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, target), aim.smooth)
	end
end)

--==================== FLY / NOCLIP ====================================
local flyBV, flyConn, noclipConn

local function setFly(on)
	state.fly = on
	local c, r, h = char(), root(), hum()
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if not on then
		if h then h.PlatformStand = false end
		return
	end
	if not r then return Notify("Sem personagem", true) end
	if h then h.PlatformStand = true end
	flyBV = new("BodyVelocity", {
		MaxForce = Vector3.new(1e5, 1e5, 1e5), P = 4000, Velocity = Vector3.zero, Parent = r,
	})
	flyConn = Run.RenderStepped:Connect(function()
		local cc = char()
		local rr = cc and cc:FindFirstChild("HumanoidRootPart")
		if not rr or not flyBV.Parent then return end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end
		flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * state.flySpeed or Vector3.zero
	end)
end

local function setNoclip(on)
	state.noclip = on
	if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
	if not on then return end
	noclipConn = Run.Stepped:Connect(function()
		local c = char()
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end)
end

UIS.JumpRequest:Connect(function()
	if not state.infJump then return end
	local h = hum()
	if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

--==================== CONTEÚDO: TELEPORT ==============================
local tpPage = newPage("Teleport")
for group, list in pairs(PLACES) do
	Section(tpPage, group)
	local g = Grid(tpPage, 2)
	for _, entry in ipairs(list) do
		local b = new("TextButton", {
			Text = entry[1], Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
			BackgroundColor3 = C.card, AutoButtonColor = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = g,
		})
		corner(b, 6)
		b.MouseEnter:Connect(function() Tween:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = C.hover }):Play() end)
		b.MouseLeave:Connect(function() Tween:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = C.card }):Play() end)
		b.MouseButton1Click:Connect(function() TP(entry[2], entry[1]) end)
	end
end
Section(tpPage, "Jogadores")
local playerGrid = Grid(tpPage, 2)
local function refreshPlayers()
	for _, c in ipairs(playerGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			local b = new("TextButton", {
				Text = plr.Name, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
				BackgroundColor3 = C.card, AutoButtonColor = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = playerGrid,
			})
			corner(b, 6)
			b.MouseButton1Click:Connect(function()
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					TP(plr.Character.HumanoidRootPart.Position, plr.Name)
				end
			end)
		end
	end
end
refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

--==================== CONTEÚDO: FRUTAS ================================
local frPage = newPage("Frutas")
Section(frPage, "Modo")
local modeRow = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = frPage })
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }, modeRow)
local modeBtns = {}
for _, m in ipairs({ { "physical", "Física" }, { "real", "Servidor" } }) do
	local b = new("TextButton", {
		Text = m[2], Font = Enum.Font.GothamSemibold, TextSize = 11, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.new(0.5, -3, 1, 0), AutoButtonColor = false, Parent = modeRow,
	})
	corner(b, 6)
	modeBtns[m[1]] = b
	b.MouseButton1Click:Connect(function()
		fruitMode = m[1]
		for k, btn in pairs(modeBtns) do
			btn.TextColor3 = k == fruitMode and C.accent or C.dim
			btn.BackgroundColor3 = k == fruitMode and C.hover or C.card
		end
	end)
end
modeBtns.physical.TextColor3 = C.accent
modeBtns.physical.BackgroundColor3 = C.hover

Section(frPage, "Buscar")
local fruitSearch = Input(frPage, "nome da fruta", function() end)
Section(frPage, "Todas as frutas")
local fruitGrid = Grid(frPage, 2)
local function fillFruits(filter)
	for _, c in ipairs(fruitGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, name in ipairs(FRUITS) do
		if filter == "" or name:lower():find(filter:lower(), 1, true) then
			local b = new("TextButton", {
				Text = name, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
				BackgroundColor3 = C.card, AutoButtonColor = false, Parent = fruitGrid,
			})
			corner(b, 6)
			b.MouseEnter:Connect(function() Tween:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = C.hover }):Play() end)
			b.MouseLeave:Connect(function() Tween:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = C.card }):Play() end)
			b.MouseButton1Click:Connect(function() fruitAction(name) end)
		end
	end
end
fillFruits("")
fruitSearch:GetPropertyChangedSignal("Text"):Connect(function() fillFruits(fruitSearch.Text) end)

Section(frPage, "Nova fruta / extra")
Input(frPage, "qualquer fruta do jogo", function(txt) fruitAction(txt) end)
Button(frPage, "Fruta aleatória", function() fruitAction(FRUITS[math.random(1, #FRUITS)]) end)
Button(frPage, "Limpar frutas geradas", function()
	for _, f in ipairs(spawnedFruits) do if f.Parent then f:Destroy() end end
	spawnedFruits = {}
	Notify("Cena limpa")
end)

--==================== CONTEÚDO: PLAYER ================================
local plPage = newPage("Player")
Section(plPage, "Velocidade")
Slider(plPage, "WalkSpeed", 16, 300, 40, function(v) state.speed = v end)
Section(plPage, "Pulo")
Slider(plPage, "JumpPower", 50, 500, 50, function(v) state.jump = v end)
Button(plPage, "Pulo alto rápido (250)", function()
	state.jump = 250
	Notify("Pulo alto ativo")
end)
Section(plPage, "Movimento")
Toggle(plPage, "Voo", false, function(v) setFly(v) end)
Slider(plPage, "Velocidade do voo", 20, 250, 60, function(v) state.flySpeed = v end)
Toggle(plPage, "Noclip", false, function(v) setNoclip(v) end)
Toggle(plPage, "Pulo infinito", false, function(v) state.infJump = v end)
Toggle(plPage, "God Mode (local)", false, function(v)
	state.god = v
	applyStats()
	Notify(v and "God Mode on" or "God Mode off")
end)
Section(plPage, "Personagem")
Button(plPage, "Curar", function()
	local h = hum()
	if h then h.Health = h.MaxHealth end
	Notify("Curado")
end)
Button(plPage, "Resetar personagem", function()
	local h = hum()
	if h then h.Health = 0 end
end)
Button(plPage, "Resetar velocidade/pulo", function()
	state.speed, state.jump = 16, 50
	applyStats()
	Notify("Padrão restaurado")
end)

--==================== CONTEÚDO: COMBATE ===============================
local cbPage = newPage("Combate")
Section(cbPage, "Aimbot")
Toggle(cbPage, "Aimbot", false, function(v)
	aim.on = v
	fovCircle.Visible = v
	Notify(v and "Aimbot ligado" or "Aimbot desligado")
end)
Slider(cbPage, "FOV", 40, 500, 150, function(v)
	aim.fov = v
	fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end)
Slider(cbPage, "Suavidade", 5, 100, 22, function(v) aim.smooth = v / 100 end)
Toggle(cbPage, "Predição de movimento", false, function(v) aim.predict = v end)
Toggle(cbPage, "Ignorar time", true, function(v) aim.team = v end)
Section(cbPage, "Mira")
Button(cbPage, "Centralizar mira", function()
	local r = root()
	if r then Cam.CFrame = CFrame.new(Cam.CFrame.Position, r.Position + Cam.CFrame.LookVector * 10) end
end)

--==================== CONTEÚDO: VISUAL ================================
local vsPage = newPage("Visual")
Section(vsPage, "ESP")
Toggle(vsPage, "ESP ativo", false, function(v)
	esp.on = v
	if not v then clearEsp() end
	Notify(v and "ESP ligado" or "ESP desligado")
end)
Toggle(vsPage, "Caixa", true, function(v) esp.box = v; clearEsp() end)
Toggle(vsPage, "Nome + distância", true, function(v) esp.name = v; clearEsp() end)
Toggle(vsPage, "Vida", true, function(v) esp.hp = v; clearEsp() end)
Toggle(vsPage, "Esqueleto", true, function(v) esp.skel = v; clearEsp() end)
Toggle(vsPage, "Linha (tracer)", true, function(v) esp.tracer = v; clearEsp() end)
Toggle(vsPage, "Ignorar time", false, function(v) esp.team = v; clearEsp() end)
Section(vsPage, "Objetos")
Toggle(vsPage, "ESP de frutas", false, function(v) esp.fruit = v; clearEsp() end)
Button(vsPage, "Reiniciar ESP", function() clearEsp(); Notify("ESP reiniciado") end)

--==================== CONTEÚDO: ADMIN =================================
local adPage = newPage("Admin")
Section(adPage, "Ilhas de admin")
local adminGrid = Grid(adPage, 2)
for _, entry in ipairs(PLACES["Admin / Dev"]) do
	local b = new("TextButton", {
		Text = entry[1], Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.accent,
		BackgroundColor3 = C.card, AutoButtonColor = false, Parent = adminGrid,
	})
	corner(b, 6)
	b.MouseButton1Click:Connect(function() TP(entry[2], entry[1]) end)
end

Section(adPage, "Haki / estilos (servidor)")
local function invoke(...)
	local ok, res = pcall(function() return RS.Remotes.CommF_:InvokeServer(...) end)
	return ok, res
end
Button(adPage, "Comprar Buso Haki", function() invoke("BuyHaki", "Buso"); Notify("Buso") end)
Button(adPage, "Comprar Kenbunshoku", function() invoke("BuyHaki", "Ken"); Notify("Ken") end)
Button(adPage, "Comprar Geppo", function() invoke("BuyHaki", "Geppo"); Notify("Geppo") end)
Button(adPage, "Comprar Soru", function() invoke("BuyHaki", "Soru"); Notify("Soru") end)
Button(adPage, "Entrar em time Pirata", function() invoke("SetTeam", "Pirates"); Notify("Time: Pirates") end)
Button(adPage, "Entrar em time Marinha", function() invoke("SetTeam", "Marines"); Notify("Time: Marines") end)

Section(adPage, "Items (qualquer item)")
local itemSearch = Input(adPage, "buscar item", function() end)
local itemGrid = Grid(adPage, 2)
local function fillItems(filter)
	for _, c in ipairs(itemGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, name in ipairs(ITEMS) do
		if filter == "" or name:lower():find(filter:lower(), 1, true) then
			local b = new("TextButton", {
				Text = name, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
				BackgroundColor3 = C.card, AutoButtonColor = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = itemGrid,
			})
			corner(b, 6)
			b.MouseButton1Click:Connect(function() giveTool(name) end)
		end
	end
end
fillItems("")
itemSearch:GetPropertyChangedSignal("Text"):Connect(function() fillItems(itemSearch.Text) end)
Input(adPage, "item personalizado", function(txt) giveTool(txt) end)
Button(adPage, "Escanear items reais do jogo", function()
	local found = 0
	for _, d in ipairs(RS:GetDescendants()) do
		if d:IsA("Tool") then found += 1 end
	end
	Notify("Tools no jogo: " .. found)
end)

Section(adPage, "Extras")
Button(adPage, "Copiar posição atual", function()
	local r = root()
	if not r then return end
	local p = r.Position
	local txt = string.format("Vector3.new(%d, %d, %d)", p.X, p.Y, p.Z)
	if setclipboard then pcall(setclipboard, txt) end
	Notify(txt)
end)
Button(adPage, "Fechar painel", function() Win.Visible = false end)

--==================== ABRIR / FECHAR ==================================
local function setOpen(open)
	if open then
		Win.Visible = true
		Win.Size = UDim2.new(0, W, 0, H * 0.85)
		Tween:Create(Win, TweenInfo.new(0.22, Enum.EasingStyle.Quint), { Size = UDim2.new(0, W, 0, H) }):Play()
		Tween:Create(Orb, TweenInfo.new(0.18), { BackgroundColor3 = C.accent }):Play()
		Tween:Create(Orb.TextLabel, TweenInfo.new(0.18), { TextColor3 = C.bg }):Play()
	else
		Tween:Create(Win, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.new(0, W, 0, 0) }):Play()
		task.delay(0.18, function() if not (Win.Visible and Win.AbsoluteSize.Y > 40) then Win.Visible = false end end)
		Tween:Create(Orb, TweenInfo.new(0.18), { BackgroundColor3 = C.panel }):Play()
		Tween:Create(Orb.TextLabel, TweenInfo.new(0.18), { TextColor3 = C.accent }):Play()
	end
end

Orb.MouseButton1Click:Connect(function()
	setOpen(not Win.Visible)
end)

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		setOpen(not Win.Visible)
	end
end)

showTab("Teleport")
Notify("JDEV carregado")
