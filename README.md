--=====================================================================
--  JDEV v3  •  build à prova de falha
--  Mostra o erro na tela, abre sozinho, funciona sem LocalPlayer/Camera.
--=====================================================================
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.2)

local Players  = game:GetService("Players")
local RS       = game:GetService("ReplicatedStorage")
local Run      = game:GetService("RunService")
local Tween    = game:GetService("TweenService")
local UIS      = game:GetService("UserInputService")

local C = {
	bg = Color3.fromRGB(11, 11, 14), card = Color3.fromRGB(23, 23, 29),
	hover = Color3.fromRGB(33, 33, 42), line = Color3.fromRGB(38, 38, 48),
	text = Color3.fromRGB(230, 230, 238), dim = Color3.fromRGB(118, 118, 132),
	accent = Color3.fromRGB(139, 124, 255), good = Color3.fromRGB(88, 222, 143),
	bad = Color3.fromRGB(255, 96, 96),
}

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do pcall(function() o[k] = v end) end
	if parent then o.Parent = parent end
	return o
end
local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, col, t, tr)
	return new("UIStroke", { Color = col or C.line, Thickness = t or 1, Transparency = tr or 0.45 }, o)
end
local function cam() return workspace.CurrentCamera end
local function vpSize()
	local c = workspace.CurrentCamera
	return c and c.ViewportSize or Vector2.new(1280, 720)
end

--==================== PLAYER (compatível com Script e LocalScript) =====
local Player
if Players.LocalPlayer then
	Player = Players.LocalPlayer
else
	local t = 0
	repeat
		task.wait(0.2)
		t += 0.2
		Player = Players:GetPlayers()[1]
	until Player or t > 6
end

local PlayerGui = Player and Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then
	warn("[JDEV] PlayerGui não encontrado. Rode como LocalScript ou executor.")
	return
end

local old = PlayerGui:FindFirstChild("JDEV")
if old then old:Destroy() end

--==================== GUI BASE (existe antes de tudo) =================
local Gui = new("ScreenGui", {
	Name = "JDEV", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 2147483647, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = PlayerGui,
})

local errBox = new("TextLabel", {
	Name = "ErrBox", Size = UDim2.new(1, -40, 0, 0), Position = UDim2.new(0, 20, 0, 20),
	BackgroundColor3 = Color3.fromRGB(60, 12, 16), TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.Code, TextSize = 12, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y,
	TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ZIndex = 60, Parent = Gui,
})
corner(errBox, 8)
new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) }, errBox)

local function showError(msg)
	errBox.Text = "JDEV ERRO\n" .. tostring(msg)
	errBox.Visible = true
	warn("[JDEV] " .. tostring(msg))
end

--==================== BUILD ===========================================
local ok, err = pcall(function()

-- toasts
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
		Text = tostring(txt), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -22, 1, 0), Position = UDim2.new(0, 16, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
	})
	Tween:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 236, 0, 30) }):Play()
	task.delay(2.2, function()
		Tween:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		for _, d in ipairs(card:GetDescendants()) do
			if d:IsA("TextLabel") then Tween:Create(d, TweenInfo.new(0.2), { TextTransparency = 1 }):Play() end
		end
		task.wait(0.25)
		card:Destroy()
	end)
end

-- drag
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
		local vp = vpSize()
		local nx = math.clamp(origin.X.Offset + d.X, 0, vp.X - frame.AbsoluteSize.X)
		local ny = math.clamp(origin.Y.Offset + d.Y, 0, vp.Y - frame.AbsoluteSize.Y)
		frame.Position = UDim2.new(0, nx, 0, ny)
	end)
end

local vp = vpSize()
local W = math.clamp(vp.X - 56, 288, 400)
local H = math.clamp(vp.Y - 140, 320, 540)

-- orbe J
local Orb = new("TextButton", {
	Name = "Orb", Text = "", Size = UDim2.new(0, 48, 0, 48),
	Position = UDim2.new(0, 16, 0, 16), BackgroundColor3 = C.accent,
	AutoButtonColor = false, Parent = Gui,
})
corner(Orb, 24)
stroke(Orb, C.accent, 1, 0.1)
local OrbLbl = new("TextLabel", {
	Text = "J", Font = Enum.Font.GothamBlack, TextSize = 23, TextColor3 = C.bg,
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Orb,
})
draggable(Orb, Orb)

-- janela
local Win = new("Frame", {
	Name = "Window", Size = UDim2.new(0, W, 0, H),
	Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = C.bg, ClipsDescendants = true, Parent = Gui,
})
corner(Win, 14)
stroke(Win, C.line, 1, 0.2)
new("Frame", {
	Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = C.accent,
	BackgroundTransparency = 0.93, BorderSizePixel = 0, Parent = Win,
})

local Top = new("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Parent = Win })
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
	BackgroundTransparency = 1, Size = UDim2.new(0, 90, 0, 24), Position = UDim2.new(0, 42, 0, 9),
	TextXAlignment = Enum.TextXAlignment.Left, Parent = Top,
})
local MinBtn = new("TextButton", {
	Text = "—", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.dim,
	BackgroundColor3 = C.card, Size = UDim2.new(0, 24, 0, 24),
	Position = UDim2.new(1, -36, 0, 9), AutoButtonColor = false, Parent = Top,
})
corner(MinBtn, 7)
MinBtn.MouseButton1Click:Connect(function() Win.Visible = false end)

-- abas
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

local function showTab(name)
	for n, btn in pairs(TabBtns) do
		btn.TextColor3 = C.dim
		btn.BackgroundColor3 = C.card
		if PageFrames[n] then PageFrames[n].Visible = false end
	end
	activeTab = name
	if TabBtns[name] then
		TabBtns[name].TextColor3 = C.accent
		TabBtns[name].BackgroundColor3 = C.hover
	end
	if PageFrames[name] then PageFrames[name].Visible = true end
end

-- componentes
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
	new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 13,
		TextColor3 = accent and C.accent or C.text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -18, 1, 0), Position = UDim2.new(0, 11, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
	})
	b.MouseButton1Click:Connect(function()
		Tween:Create(b, TweenInfo.new(0.08), { BackgroundColor3 = C.hover }):Play()
		task.delay(0.1, function()
			if b.Parent then Tween:Create(b, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play() end
		end)
		cb(b)
	end)
	return b
end

local function GridButton(grid, txt, col, cb)
	local b = new("TextButton", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = col or C.text,
		BackgroundColor3 = C.card, AutoButtonColor = false,
		TextTruncate = Enum.TextTruncate.AtEnd, Parent = grid,
	})
	corner(b, 6)
	b.MouseButton1Click:Connect(function() cb(b) end)
	return b
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
		track.BackgroundColor3 = v and C.accent or Color3.fromRGB(45, 45, 55)
		knob.Position = v and UDim2.new(1, -15, 0.5, -6.5) or UDim2.new(0, 2, 0.5, -6.5)
		cb(v)
	end
	hit.MouseButton1Click:Connect(function() apply(not state) end)
	return { set = apply, get = function() return state end }
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
		set((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
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

local function Grid(page, cols, cellH)
	local g = new("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Parent = page })
	new("UIGridLayout", {
		CellSize = UDim2.new(1 / cols, -4, 0, cellH or 30), CellPadding = UDim2.new(0, 4, 0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, g)
	return g
end

for i, name in ipairs({ "Teleport", "Spawn", "Player", "Combate", "Visual", "Admin" }) do
	local b = new("TextButton", {
		Text = name, Font = Enum.Font.GothamSemibold, TextSize = 12, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.new(0, 0, 0, 26), AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = i, AutoButtonColor = false, Parent = TabBar,
	})
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, b)
	corner(b, 7)
	TabBtns[name] = b
	b.MouseButton1Click:Connect(function()
		if activeTab ~= name then showTab(name) end
	end)
end

-- estado
local state = {
	speed = 40, jumpHeight = 50, jumpOn = false, multiJump = 1,
	god = false, infJump = false, noclip = false,
	fly = false, flySpeed = 70, flyVert = 60, flyLock = false, flyAccel = 0.35,
}
local function chr() return Player.Character end
local function root()
	local c = chr()
	return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end
local function hum()
	local c = chr()
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function gravity() return workspace.Gravity > 1 and workspace.Gravity or 196.2 end

local godOld = {}
local function applyStats()
	local h = hum()
	if not h then return end
	h.WalkSpeed = state.speed
	if state.jumpOn then
		if h.UseJumpPower then
			h.JumpPower = math.clamp(math.sqrt(2 * gravity() * state.jumpHeight), 50, 1000)
		else
			h.JumpHeight = state.jumpHeight
		end
	end
	if state.god then
		if not godOld[h] then godOld[h] = h.MaxHealth end
		h.MaxHealth = 1e9
		h.Health = h.MaxHealth
	elseif godOld[h] then
		h.MaxHealth = godOld[h]
		h.Health = math.min(h.Health, h.MaxHealth)
		godOld[h] = nil
	end
end
Run.Heartbeat:Connect(applyStats)

local jumpCount = 0
local function doJump()
	local h, r = hum(), root()
	if not h or not r then return end
	h:ChangeState(Enum.HumanoidStateType.Jumping)
	local bv = new("BodyVelocity", {
		MaxForce = Vector3.new(0, 1e5, 0),
		Velocity = Vector3.new(r.AssemblyLinearVelocity.X, math.sqrt(2 * gravity() * state.jumpHeight), r.AssemblyLinearVelocity.Z),
		Parent = r,
	})
	task.delay(0.25, function() if bv.Parent then bv:Destroy() end end)
end
UIS.JumpRequest:Connect(function()
	if state.infJump then doJump() elseif state.multiJump > 1 and jumpCount > 0 then
		jumpCount -= 1
		doJump()
	end
end)
Player.CharacterAdded:Connect(function(c)
	task.wait(1)
	state.fly = false
	local h = c:WaitForChild("Humanoid", 8)
	if h then
		h.StateChanged:Connect(function(s)
			if s == Enum.HumanoidStateType.Landed then jumpCount = state.multiJump - 1 end
		end)
	end
	applyStats()
end)

-- rede
local function CommF()
	local remotes = RS:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("CommF_")
end
local function invoke(...)
	local c = CommF()
	if not c then return false end
	local a, b = pcall(function() return c:InvokeServer(...) end)
	return a, b
end

local PLACES = {
	{ "Primeiro Mar", {
		{ "Fruit Dealer", Vector3.new(0, 5, 0) }, { "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Amazon Lily", Vector3.new(-3000, 5, 2500) }, { "Sky Island", Vector3.new(-7863, 5545, -378) },
	} },
	{ "Segundo Mar", {
		{ "Colosseum", Vector3.new(-5000, 5, 0) }, { "Cursed Ship", Vector3.new(0, 5, -4000) },
		{ "Haunted Castle", Vector3.new(-3000, 5, -4000) }, { "Café", Vector3.new(-386, 74, -314) },
	} },
	{ "Terceiro Mar", {
		{ "Egghead", Vector3.new(6000, 5, 6000) }, { "Mansion", Vector3.new(6000, 5, -6000) },
		{ "Hydra", Vector3.new(-8000, 5, 0) }, { "Great Tree", Vector3.new(-1055, 328, -8916) },
	} },
	{ "Admin / Dev", {
		{ "Admin Island", Vector3.new(0, 5, -10000) }, { "Admin Room", Vector3.new(0, 5, -12500) },
		{ "Dev Room", Vector3.new(0, 1000, -15000) }, { "Vazio", Vector3.new(0, 3000, 0) },
	} },
}

local function TP(pos, label)
	local r = root()
	if not r then return Notify("Sem personagem", true) end
	if (r.Position - pos).Magnitude > 3000 then
		invoke("requestEntrance", pos)
		task.wait(0.5)
	end
	r.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
	Notify("→ " .. (label or "Destino"))
end

-- frutas
local FRUIT_GROUPS = {
	{ "Comum", { "Rocket", "Kilo", "Spin", "Blade", "Chop", "Spring", "Bomb", "Spike" } },
	{ "Incomum / Rara", {
		"Diamond", "Revive", "Rubber", "Ghost", "Barrier", "Creation", "Door", "Portal",
		"Smoke", "Flame", "Ice", "Sand", "Dark", "Light", "Falcon", "Eagle",
	} },
	{ "Lendária", {
		"Quake", "Love", "Spider", "String", "Sound", "Pain", "Paw", "Magma",
		"Lightning", "Rumble", "Blizzard", "Buddha", "Phoenix",
	} },
	{ "Mítica / Nova", {
		"Gravity", "Shadow", "Venom", "Spirit", "Soul", "Control", "Dough", "Gas",
		"Hellfire (Gas)", "Mammoth", "T-Rex", "Leopard", "Tiger", "Yeti", "Kitsune",
		"Dragon", "Dragon (Classic)", "Magnet", "Empyrean (Kitsune)", "Fiend (Yeti)",
		"Werewolf (Tiger)", "Celestial", "Oni", "Meme",
	} },
}
local ALIAS = {
	Rocket = "Kilo", Kilo = "Rocket", Blade = "Chop", Chop = "Blade",
	Portal = "Door", Door = "Portal", Lightning = "Rumble", Rumble = "Lightning",
	Spirit = "Soul", Soul = "Spirit", Spider = "String", String = "Spider",
	Tiger = "Leopard", Leopard = "Tiger", Creation = "Barrier", Barrier = "Creation",
	Eagle = "Falcon", Falcon = "Eagle",
}
local fruitMode = "physical"
local spawned = {}
local function cleanName(n) return (n:gsub("%s*%b()", "")) end

local templateCache = {}
local function findTemplate(name)
	local base = cleanName(name)
	if templateCache[base] then
		local c = templateCache[base]
		if c and c.Parent then return c end
		templateCache[base] = nil
	end
	local raw = { name, base, base .. " Fruit", base .. "-" .. base, base .. "-" .. base .. " Fruit" }
	if ALIAS[base] then
		local a = ALIAS[base]
		for _, v in ipairs({ a, a .. " Fruit", a .. "-" .. a, a .. "-" .. a .. " Fruit" }) do
			table.insert(raw, v)
		end
	end
	local keys = {}
	for _, k in ipairs(raw) do keys[k:lower()] = true end
	local found
	for _, container in ipairs({ RS, workspace }) do
		for _, d in ipairs(container:GetDescendants()) do
			if (d:IsA("Tool") or d:IsA("Model")) and keys[d.Name:lower()] then
				found = d
				break
			end
		end
		if found then break end
	end
	if found then templateCache[base] = found end
	return found
end

local function spawnAt(name, angle, radius)
	local tmpl = findTemplate(name)
	if not tmpl then return false end
	if #spawned > 130 then
		local o = table.remove(spawned, 1)
		if o and o.Parent then o:Destroy() end
	end
	local r = root()
	local cf = r and (r.CFrame * CFrame.new(math.cos(angle) * radius, 4, math.sin(angle) * radius)) or CFrame.new(0, 80, 0)
	local clone = tmpl:Clone()
	clone.Name = cleanName(name) .. " Fruit"
	if clone:IsA("Model") then
		for _, p in ipairs(clone:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = false
				p.CanCollide = true
			end
		end
		clone.Parent = workspace
		if clone.PrimaryPart then clone:PivotTo(cf)
		else
			local f = clone:FindFirstChildWhichIsA("BasePart")
			if f then f.CFrame = cf end
		end
	else
		local hnd = clone:FindFirstChild("Handle") or clone:FindFirstChildWhichIsA("BasePart")
		clone.Parent = workspace
		if hnd then
			hnd.Anchored = false
			hnd.CanCollide = true
			hnd.CFrame = cf
		end
	end
	new("Highlight", {
		FillTransparency = 0.72, OutlineTransparency = 0.1,
		FillColor3 = C.accent, OutlineColor3 = C.accent, Parent = clone,
	})
	table.insert(spawned, clone)
	return true
end

local function fruitAction(name)
	if fruitMode == "real" then
		local good = invoke("BuyFruit", cleanName(name) .. "-" .. cleanName(name))
		invoke("LoadFruit", cleanName(name))
		return Notify(good and ("Servidor: " .. name) or ("Falha: " .. name), not good)
	end
	if spawnAt(name, math.random() * math.pi * 2, 9) then
		Notify("Spawn: " .. name)
	else
		invoke("LoadFruit", cleanName(name))
		Notify("Sem modelo: " .. name .. " → inventário", true)
	end
end

-- ESP
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
	for c, d in pairs(espCache) do
		if d.box then d.box:Destroy() end
		if d.bill then d.bill:Destroy() end
		if d.tracer then d.tracer:Destroy() end
		if d.lines then for _, l in ipairs(d.lines) do l:Destroy() end end
	end
	espCache = {}
end
local function buildEsp(t, plr)
	if espCache[t] then return end
	local hrp = t:FindFirstChild("HumanoidRootPart") or t:FindFirstChild("Torso")
		or t:FindFirstChild("UpperTorso") or t:FindFirstChildWhichIsA("BasePart")
	local h = t:FindFirstChildOfClass("Humanoid")
	local head = t:FindFirstChild("Head") or hrp
	local c = cam()
	if not hrp or not c then return end
	local col = Color3.fromRGB(255, 90, 90)
	if plr and plr.Team then col = plr.Team.TeamColor.Color end
	local d = { lines = {} }
	if esp.box then
		d.box = new("BoxHandleAdornment", {
			Size = Vector3.new(4, 5.4, 2), AlwaysOnTop = true, ZIndex = 5,
			Transparency = 0.4, Color3 = col, Adornee = hrp, Parent = hrp,
		})
	end
	if (esp.name or esp.hp) and head then
		d.bill = new("BillboardGui", {
			Size = UDim2.new(0, 130, 0, 40), StudsOffset = Vector3.new(0, 2.6, 0),
			AlwaysOnTop = true, Adornee = head, Parent = head,
		})
		if esp.name then
			d.label = new("TextLabel", {
				Text = t.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.4, BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 15), Parent = d.bill,
			})
		end
		if esp.hp then
			local bg = new("Frame", {
				Size = UDim2.new(0.8, 0, 0, 5), Position = UDim2.new(0.1, 0, 0, 17),
				BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0, Parent = d.bill,
			})
			corner(bg, 2)
			d.fill = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.good, BorderSizePixel = 0, Parent = bg })
			corner(d.fill, 2)
		end
	end
	if esp.skel and h then
		for i = 1, #BONES do
			d.lines[i] = new("LineHandleAdornment", {
				Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 6,
				Adornee = hrp, Parent = c, Length = 0,
			})
		end
	end
	if esp.tracer and head then
		d.tracer = new("LineHandleAdornment", {
			Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 4, Parent = c, Length = 0,
		})
	end
	espCache[t] = d
end
local function updateEsp()
	local c = cam()
	if not c then return end
	for t, d in pairs(espCache) do
		if not t.Parent then
			clearEsp()
			break
		end
		local hrp = t:FindFirstChild("HumanoidRootPart") or t:FindFirstChild("Torso")
		local head = t:FindFirstChild("Head")
		local h = t:FindFirstChildOfClass("Humanoid")
		if d.box and hrp then d.box.Adornee = hrp end
		if d.bill and head then d.bill.Adornee = head end
		if d.fill and h then
			local ratio = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
			d.fill.Size = UDim2.new(ratio, 0, 1, 0)
			d.fill.BackgroundColor3 = C.bad:Lerp(C.good, ratio)
		end
		if d.label and head then
			d.label.Text = t.Name .. "  [" .. math.floor((c.CFrame.Position - head.Position).Magnitude) .. "]"
		end
		if hrp then
			for i, bn in ipairs(BONES) do
				local line = d.lines[i]
				if line then
					local a, b = t:FindFirstChild(bn[1]), t:FindFirstChild(bn[2])
					if a and b then
						line.Length = (a.Position - b.Position).Magnitude
						line.CFrame = CFrame.new((a.Position + b.Position) / 2, b.Position)
					else
						line.Length = 0
					end
				end
			end
			if d.tracer and head then
				local o = c.CFrame.Position + c.CFrame.LookVector * 2 + c.CFrame.UpVector * -1.4
				d.tracer.Length = (o - head.Position).Magnitude
				d.tracer.CFrame = CFrame.new((o + head.Position) / 2, head.Position)
			end
		end
	end
end
Run.RenderStepped:Connect(function()
	if not esp.on then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			if not (esp.team and plr.Team == Player.Team) then
				local h = plr.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Health > 0 then buildEsp(plr.Character, plr) end
			end
		end
	end
	if esp.fruit then
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj.Name:find("Fruit") and not obj:FindFirstChildOfClass("Humanoid") then buildEsp(obj, nil) end
		end
	end
	updateEsp()
end)

-- aimbot
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
	local c = cam()
	local r = root()
	if not c or not r then return end
	local center = c.ViewportSize / 2
	local best, bestD
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			local h = plr.Character:FindFirstChildOfClass("Humanoid")
			local hd = plr.Character:FindFirstChild("Head")
			if h and hd and h.Health > 0 and not (aim.team and plr.Team == Player.Team) then
				local sp, vis = c:WorldToViewportPoint(hd.Position)
				if vis then
					local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
					if dist < aim.fov and (not bestD or dist < bestD) then best, bestD = hd, dist end
				end
			end
		end
	end
	if best then
		local target = best.Position
		if aim.predict then target = target + best.AssemblyLinearVelocity * 0.14 end
		c.CFrame = c.CFrame:Lerp(CFrame.new(c.CFrame.Position, target), aim.smooth)
	end
end)

-- voo
local flyBV, flyConn, flyUp, flyDown, lockY = nil, nil, false, false, nil
local function setFly(on)
	state.fly = on
	local r, h = root(), hum()
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if not on then
		if h then h.PlatformStand = false end
		lockY = nil
		return
	end
	if not r then state.fly = false; return Notify("Sem personagem", true) end
	if h then h.PlatformStand = true end
	lockY = state.flyLock and r.Position.Y or nil
	flyBV = new("BodyVelocity", { MaxForce = Vector3.new(1e5, 1e5, 1e5), P = 8000, Velocity = Vector3.zero, Parent = r })
	flyConn = Run.RenderStepped:Connect(function()
		local c = cam()
		local cc = chr()
		local rr = cc and cc:FindFirstChild("HumanoidRootPart")
		if not rr or not flyBV or not flyBV.Parent or not c then return end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += c.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= c.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= c.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += c.CFrame.RightVector end
		local vert = 0
		if UIS:IsKeyDown(Enum.KeyCode.Space) or flyUp then vert += 1 end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.C) or flyDown then vert -= 1 end
		local sp = state.flySpeed
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then sp *= 2 end
		local flat = Vector3.new(dir.X, 0, dir.Z)
		if flat.Magnitude > 0 then flat = flat.Unit * sp end
		local target = Vector3.new(flat.X, vert * state.flyVert, flat.Z)
		if state.flyLock and lockY then target = Vector3.new(target.X, (lockY - rr.Position.Y) * 6, target.Z) end
		flyBV.Velocity = flyBV.Velocity:Lerp(target, math.clamp(state.flyAccel, 0.05, 1))
	end)
end

local noclipConn
local function setNoclip(on)
	state.noclip = on
	if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
	if not on then return end
	noclipConn = Run.Stepped:Connect(function()
		local c = chr()
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end)
end

local flyPad = new("Frame", {
	Size = UDim2.new(0, 46, 0, 104), Position = UDim2.new(1, -62, 0.5, 40),
	BackgroundTransparency = 1, Visible = false, Parent = Gui,
})
new("UIListLayout", { Padding = UDim.new(0, 6) }, flyPad)
local function padBtn(txt, order, setter)
	local b = new("TextButton", {
		Text = txt, Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = C.accent,
		BackgroundColor3 = C.card, BackgroundTransparency = 0.15, Size = UDim2.new(1, 0, 0, 46),
		LayoutOrder = order, AutoButtonColor = false, Parent = flyPad,
	})
	corner(b, 10)
	stroke(b, C.accent, 1, 0.5)
	b.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then setter(true) end
	end)
	b.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then setter(false) end
	end)
end
padBtn("+", 1, function(v) flyUp = v end)
padBtn("−", 2, function(v) flyDown = v end)

-- TELEPORT
local tpPage = newPage("Teleport")
for _, g in ipairs(PLACES) do
	Section(tpPage, g[1])
	local grid = Grid(tpPage, 2)
	for _, e in ipairs(g[2]) do GridButton(grid, e[1], nil, function() TP(e[2], e[1]) end) end
end
Section(tpPage, "Jogadores")
local playerGrid = Grid(tpPage, 2)
local function refreshPlayers()
	for _, c in ipairs(playerGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			GridButton(playerGrid, plr.Name, nil, function()
				local cc = plr.Character
				local rr = cc and cc:FindFirstChild("HumanoidRootPart")
				if rr then TP(rr.Position, plr.Name) end
			end)
		end
	end
end
refreshPlayers()
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshPlayers() end)

-- SPAWN
local spPage = newPage("Spawn")
Section(spPage, "Modo")
local modeRow = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = spPage })
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }, modeRow)
local modeBtns = {}
for _, m in ipairs({ { "physical", "Físico" }, { "real", "Servidor" } }) do
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

local allFruits = {}
for _, g in ipairs(FRUIT_GROUPS) do
	for _, n in ipairs(g[2]) do table.insert(allFruits, n) end
end
Section(spPage, "Mapa de spawn")
local searchBox = Input(spPage, "filtrar fruta", function() end)
local spawnNodes = {}
local function spawnCircle(list)
	if not root() then return Notify("Sem personagem", true) end
	local okCount = 0
	for i, name in ipairs(list) do
		if spawnAt(name, (i / math.max(#list, 1)) * math.pi * 2, 16) then okCount += 1 end
	end
	Notify("Spawn: " .. okCount .. "/" .. #list)
end
local function rebuildSpawn(filter)
	for _, n in ipairs(spawnNodes) do n:Destroy() end
	spawnNodes = {}
	for _, g in ipairs(FRUIT_GROUPS) do
		local shown = {}
		for _, name in ipairs(g[2]) do
			if filter == "" or name:lower():find(filter:lower(), 1, true) then table.insert(shown, name) end
		end
		if #shown > 0 then
			local head = new("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Parent = spPage })
			table.insert(spawnNodes, head)
			local b = new("TextButton", {
				Text = g[1] .. "  ·  spawnar " .. #shown, Font = Enum.Font.GothamSemibold,
				TextSize = 11, TextColor3 = C.accent, BackgroundColor3 = C.card,
				Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Parent = head,
			})
			corner(b, 6)
			b.MouseButton1Click:Connect(function() spawnCircle(shown) end)
			local grid = Grid(spPage, 3, 26)
			table.insert(spawnNodes, grid)
			for _, name in ipairs(shown) do GridButton(grid, name, nil, function() fruitAction(name) end) end
		end
	end
end
rebuildSpawn("")
searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildSpawn(searchBox.Text) end)

Section(spPage, "Ações")
Button(spPage, "Spawnar todas em círculo", function() spawnCircle(allFruits) end)
Button(spPage, "Spawnar 10 aleatórias", function()
	local pick = {}
	for _ = 1, 10 do table.insert(pick, allFruits[math.random(1, #allFruits)]) end
	spawnCircle(pick)
end)
Button(spPage, "Limpar frutas geradas", function()
	for _, f in ipairs(spawned) do if f.Parent then f:Destroy() end end
	spawned = {}
	Notify("Cena limpa")
end)
Input(spPage, "fruta nova / personalizada", function(txt) fruitAction(txt) end)

-- PLAYER
local plPage = newPage("Player")
Section(plPage, "Velocidade")
Slider(plPage, "WalkSpeed", 16, 400, 40, function(v) state.speed = v end)
Section(plPage, "Pulo")
local jumpToggle
jumpToggle = Toggle(plPage, "Aplicar altura", false, function(v)
	state.jumpOn = v
	if not v then
		local h = hum()
		if h then
			if h.UseJumpPower then h.JumpPower = 50 else h.JumpHeight = 15 end
		end
	end
end)
Slider(plPage, "Altura (studs)", 5, 400, 50, function(v) state.jumpHeight = v end)
Slider(plPage, "Pulos por salto", 1, 10, 1, function(v)
	state.multiJump = v
	jumpCount = v - 1
end)
Button(plPage, "Ativar pulo agora", function()
	state.jumpOn = true
	jumpToggle.set(true)
	applyStats()
	Notify("Altura " .. state.jumpHeight .. " studs")
end)
Section(plPage, "Voo")
local flyToggle
flyToggle = Toggle(plPage, "Voo", false, function(v)
	setFly(v)
	flyPad.Visible = v
	Notify(v and "Voo on" or "Voo off")
end)
Slider(plPage, "Velocidade horizontal", 10, 400, 70, function(v) state.flySpeed = v end)
Slider(plPage, "Velocidade vertical", 10, 400, 60, function(v) state.flyVert = v end)
Slider(plPage, "Suavidade", 5, 100, 35, function(v) state.flyAccel = v / 100 end)
Toggle(plPage, "Travar altitude", false, function(v) state.flyLock = v end)
Button(plPage, "Subir 100 studs", function()
	local r = root()
	if r then r.CFrame = r.CFrame + Vector3.new(0, 100, 0) end
end)
Button(plPage, "Descer 100 studs", function()
	local r = root()
	if r then r.CFrame = r.CFrame - Vector3.new(0, 100, 0) end
end)
Section(plPage, "Movimento")
Toggle(plPage, "Noclip", false, function(v) setNoclip(v) end)
Toggle(plPage, "Pulo infinito", false, function(v) state.infJump = v end)
Toggle(plPage, "God Mode", false, function(v)
	state.god = v
	applyStats()
end)
Section(plPage, "Personagem")
Button(plPage, "Curar", function()
	local h = hum()
	if h then h.Health = h.MaxHealth end
	Notify("Curado")
end)
Button(plPage, "Resetar", function()
	local h = hum()
	if h then h.Health = 0 end
end)

-- COMBATE
local cbPage = newPage("Combate")
Section(cbPage, "Aimbot")
Toggle(cbPage, "Aimbot", false, function(v)
	aim.on = v
	fovCircle.Visible = v
end)
Slider(cbPage, "FOV", 40, 600, 150, function(v)
	aim.fov = v
	fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end)
Slider(cbPage, "Suavidade", 5, 100, 22, function(v) aim.smooth = v / 100 end)
Toggle(cbPage, "Predição", false, function(v) aim.predict = v end)
Toggle(cbPage, "Ignorar time", true, function(v) aim.team = v end)

-- VISUAL
local vsPage = newPage("Visual")
Section(vsPage, "ESP")
Toggle(vsPage, "ESP ativo", false, function(v)
	esp.on = v
	if not v then clearEsp() end
end)
Toggle(vsPage, "Caixa", true, function(v) esp.box = v; clearEsp() end)
Toggle(vsPage, "Nome + distância", true, function(v) esp.name = v; clearEsp() end)
Toggle(vsPage, "Vida", true, function(v) esp.hp = v; clearEsp() end)
Toggle(vsPage, "Esqueleto", true, function(v) esp.skel = v; clearEsp() end)
Toggle(vsPage, "Linha", true, function(v) esp.tracer = v; clearEsp() end)
Toggle(vsPage, "Ignorar time", false, function(v) esp.team = v; clearEsp() end)
Section(vsPage, "Objetos")
Toggle(vsPage, "ESP de frutas", false, function(v) esp.fruit = v; clearEsp() end)

-- ADMIN
local adPage = newPage("Admin")
Section(adPage, "Ilhas de admin")
local adminGrid = Grid(adPage, 2)
for _, e in ipairs(PLACES[4][2]) do GridButton(adminGrid, e[1], C.accent, function() TP(e[2], e[1]) end) end
Section(adPage, "Haki / time")
Button(adPage, "Buso Haki", function() invoke("BuyHaki", "Buso"); Notify("Buso") end)
Button(adPage, "Kenbunshoku", function() invoke("BuyHaki", "Ken"); Notify("Ken") end)
Button(adPage, "Geppo", function() invoke("BuyHaki", "Geppo"); Notify("Geppo") end)
Button(adPage, "Soru", function() invoke("BuyHaki", "Soru"); Notify("Soru") end)
Button(adPage, "Time Pirata", function() invoke("SetTeam", "Pirates"); Notify("Pirates") end)
Button(adPage, "Time Marinha", function() invoke("SetTeam", "Marines"); Notify("Marines") end)
Section(adPage, "Items")
local ITEMS = {
	"Dark Blade", "Cursed Dual Katana", "Saber", "Bisento", "Dragon Trident",
	"Hallow Scythe", "Saddi", "Kabucha", "Serpent Bow", "Bazooka", "Cannon",
	"Flintlock", "Musket", "Slingshot", "Acidum Rifle", "Bizarre Rifle",
	"Katana", "Cutlass", "Trident", "Superhuman", "Godhuman", "Sanguine Art",
}
local function giveTool(name)
	local tmpl = findTemplate(name)
	if tmpl and tmpl:IsA("Tool") then
		local bp = Player:FindFirstChild("Backpack")
		if not bp then return Notify("Sem backpack", true) end
		tmpl:Clone().Parent = bp
		return Notify("Item: " .. name)
	end
	local good = invoke("BuyItem", name)
	Notify(good and ("Servidor: " .. name) or ("Não achado: " .. name), not good)
end
local itemSearch = Input(adPage, "filtrar item", function() end)
local itemGrid = Grid(adPage, 2)
local function fillItems(filter)
	for _, c in ipairs(itemGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, name in ipairs(ITEMS) do
		if filter == "" or name:lower():find(filter:lower(), 1, true) then
			GridButton(itemGrid, name, nil, function() giveTool(name) end)
		end
	end
end
fillItems("")
itemSearch:GetPropertyChangedSignal("Text"):Connect(function() fillItems(itemSearch.Text) end)
Input(adPage, "item personalizado", function(txt) giveTool(txt) end)

-- abrir/fechar
local function setOpen(open)
	if open then
		Win.Visible = true
		Win.Size = UDim2.new(0, W, 0, H * 0.85)
		Tween:Create(Win, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.new(0, W, 0, H) }):Play()
	else
		Win.Visible = false
	end
end
Orb.MouseButton1Click:Connect(function()
	if Win.Visible then Win.Visible = false else setOpen(true) end
end)
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		Win.Visible = not Win.Visible
	end
end)

showTab("Teleport")
setOpen(true)
task.wait(0.15)
Notify("JDEV v3 online")

end)

if not ok then
	showError(err)
end
