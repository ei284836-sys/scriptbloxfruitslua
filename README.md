--=====================================================================
--  JDEV ULTIMATE  v2  •  LUNAR STYLE
--  Build estável: sem erro de sintaxe, voo e pulo configuráveis,
--  mapa de spawn com todas as frutas, ESP estilo Free Fire, aimbot.
--=====================================================================
local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local Run     = game:GetService("RunService")
local Tween   = game:GetService("TweenService")
local UIS     = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Cam = workspace.CurrentCamera or workspace:WaitForChild("CurrentCamera")
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if workspace.CurrentCamera then Cam = workspace.CurrentCamera end
end)

local old = PlayerGui:FindFirstChild("JDEV")
if old then old:Destroy() end

--==================== PALETA ==========================================
local C = {
	bg     = Color3.fromRGB(11, 11, 14),
	card   = Color3.fromRGB(23, 23, 29),
	hover  = Color3.fromRGB(33, 33, 42),
	line   = Color3.fromRGB(38, 38, 48),
	text   = Color3.fromRGB(230, 230, 238),
	dim    = Color3.fromRGB(118, 118, 132),
	accent = Color3.fromRGB(139, 124, 255),
	good   = Color3.fromRGB(88, 222, 143),
	bad    = Color3.fromRGB(255, 96, 96),
}

--==================== HELPERS =========================================
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
local W  = math.clamp(vp.X - 56, 292, 400)
local H  = math.clamp(vp.Y - 130, 330, 540)

--==================== GUI =============================================
local Gui = new("ScreenGui", {
	Name = "JDEV", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui,
})

--==================== TOASTS ==========================================
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
		Tween:Create(bar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		for _, d in ipairs(card:GetDescendants()) do
			if d:IsA("TextLabel") then Tween:Create(d, TweenInfo.new(0.2), { TextTransparency = 1 }):Play() end
		end
		task.wait(0.25)
		card:Destroy()
	end)
end

--==================== DRAG ============================================
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

--==================== ORBE J ==========================================
local Orb = new("TextButton", {
	Name = "Orb", Text = "", Size = UDim2.new(0, 46, 0, 46),
	Position = UDim2.new(0, 16, 0.5, -23), BackgroundColor3 = C.card,
	AutoButtonColor = false, Parent = Gui,
})
corner(Orb, 23)
stroke(Orb, C.accent, 1, 0.15)
local OrbLbl = new("TextLabel", {
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
	new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 13,
		TextColor3 = accent and C.accent or C.text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -18, 1, 0), Position = UDim2.new(0, 11, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
	})
	b.MouseEnter:Connect(function() Tween:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = C.hover }):Play() end)
	b.MouseLeave:Connect(function() Tween:Create(b, TweenInfo.new(0.12), { BackgroundColor3 = C.card }):Play() end)
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
	b.MouseEnter:Connect(function() Tween:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = C.hover }):Play() end)
	b.MouseLeave:Connect(function() Tween:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = C.card }):Play() end)
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
		Tween:Create(track, TweenInfo.new(0.16, Enum.EasingStyle.Quint), {
			BackgroundColor3 = v and C.accent or Color3.fromRGB(45, 45, 55),
		}):Play()
		Tween:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quint), {
			Position = v and UDim2.new(1, -15, 0.5, -6.5) or UDim2.new(0, 2, 0.5, -6.5),
		}):Play()
		cb(v)
	end

	hit.MouseButton1Click:Connect(function() apply(not state) end)
	return { set = apply, get = function() return state end }
end

local function Slider(page, txt, min, max, default, cb, step)
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
		local val = min + (max - min) * alpha
		if step then val = math.floor(val / step + 0.5) * step end
		val = math.floor(val + 0.5)
		lbl.Text = txt .. "  " .. tostring(val)
		cb(val)
	end
	local function fromX(x)
		set((x - track.AbsolutePosition.X) / track.AbsoluteSize.X)
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

--==================== CRIA ABAS =======================================
local TABS = { "Teleport", "Spawn", "Player", "Combate", "Visual", "Admin" }
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
		if activeTab ~= name then showTab(name) end
	end)
end

--==================== ESTADO ==========================================
local state = {
	speed = 40, jumpHeight = 50, jumpOn = false, multiJump = 1,
	god = false, infJump = false, noclip = false,
	fly = false, flySpeed = 70, flyVert = 60, flyLock = false, flyAccel = 0.35,
}

local function char() return Player.Character end
local function root()
	local c = char()
	return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end
local function hum()
	local c = char()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local godOld = {}
local function applyStats()
	local h = hum()
	if not h then return end
	h.WalkSpeed = state.speed
	if state.jumpOn then
		local g = workspace.Gravity > 1 and workspace.Gravity or 196.2
		if h.UseJumpPower then
			h.JumpPower = math.clamp(math.sqrt(2 * g * state.jumpHeight), 50, 1000)
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

--==================== PULO ============================================
local jumpCount = 0
local function resetJump()
	local h = hum()
	if h then
		jumpCount = math.max(0, state.multiJump - 1)
	end
end

local function doJump()
	local h = hum()
	local r = root()
	if not h or not r then return end
	h:ChangeState(Enum.HumanoidStateType.Jumping)
	local boost = math.sqrt(2 * (workspace.Gravity > 1 and workspace.Gravity or 196.2) * state.jumpHeight)
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(0, 1e5, 0)
	bv.Velocity = Vector3.new(r.AssemblyLinearVelocity.X, boost, r.AssemblyLinearVelocity.Z)
	bv.Parent = r
	task.delay(0.25, function() if bv.Parent then bv:Destroy() end end)
end

UIS.JumpRequest:Connect(function()
	if state.infJump then doJump(); return end
	if state.multiJump > 1 and jumpCount > 0 then
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
			if s == Enum.HumanoidStateType.Landed or s == Enum.HumanoidStateType.Running then
				jumpCount = state.multiJump - 1
			end
		end)
	end
	applyStats()
end)

--==================== TELEPORTES ======================================
local PLACES = {
	{ "Primeiro Mar", {
		{ "Fruit Dealer", Vector3.new(0, 5, 0) },
		{ "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Amazon Lily", Vector3.new(-3000, 5, 2500) },
		{ "Sky Island", Vector3.new(-7863, 5545, -378) },
		{ "Holy Tower", Vector3.new(0, 2000, 4500) },
	} },
	{ "Segundo Mar", {
		{ "Colosseum", Vector3.new(-5000, 5, 0) },
		{ "Cursed Ship", Vector3.new(0, 5, -4000) },
		{ "Haunted Castle", Vector3.new(-3000, 5, -4000) },
		{ "Café", Vector3.new(-386, 74, -314) },
	} },
	{ "Terceiro Mar", {
		{ "Egghead", Vector3.new(6000, 5, 6000) },
		{ "Mansion", Vector3.new(6000, 5, -6000) },
		{ "Hydra", Vector3.new(-8000, 5, 0) },
		{ "Great Tree", Vector3.new(-1055, 328, -8916) },
	} },
	{ "Admin / Dev", {
		{ "Admin Island", Vector3.new(0, 5, -10000) },
		{ "Admin Room", Vector3.new(0, 5, -12500) },
		{ "Dev Room", Vector3.new(0, 1000, -15000) },
		{ "Vazio / Skybox", Vector3.new(0, 3000, 0) },
	} },
}

local function CommF()
	local remotes = RS:FindFirstChild("Remotes")
	return remotes and remotes:FindFirstChild("CommF_")
end
local function invoke(...)
	local c = CommF()
	if not c then return false end
	local ok, res = pcall(function() return c:InvokeServer(...) end)
	return ok, res
end

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

--==================== FRUTAS ==========================================
local FRUIT_GROUPS = {
	{ "Comum / Baratas", {
		"Rocket", "Kilo", "Spin", "Blade", "Chop", "Spring", "Bomb", "Spike",
	} },
	{ "Incomum / Rara", {
		"Diamond", "Revive", "Rubber", "Ghost", "Barrier", "Creation", "Door", "Portal",
		"Smoke", "Flame", "Ice", "Sand", "Dark", "Light", "Falcon", "Eagle",
	} },
	{ "Lendária", {
		"Quake", "Love", "Spider", "String", "Sound", "Pain", "Paw", "Magma",
		"Lightning", "Rumble", "Blizzard", "Buddha", "Phoenix",
	} },
	{ "Mítica", {
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

local function cleanName(name)
	return (name:gsub("%s*%b()", ""))
end

local function findTemplate(name)
	local base = cleanName(name)
	local keys = { name, base, base .. " Fruit", base .. "-" .. base, base .. "-" .. base .. " Fruit" }
	if ALIAS[base] then
		local a = ALIAS[base]
		table.insert(keys, a)
		table.insert(keys, a .. " Fruit")
		table.insert(keys, a .. "-" .. a)
		table.insert(keys, a .. "-" .. a .. " Fruit")
	end
	for _, k in ipairs(keys) do k = k:lower() end
	local function matches(o)
		local n = o.Name:lower()
		for _, k in ipairs(keys) do
			if n == k then return true end
		end
		return false
	end
	local scanned = 0
	for _, container in ipairs({ RS, workspace }) do
		for _, d in ipairs(container:GetDescendants()) do
			scanned += 1
			if scanned > 60000 then break end
			if (d:IsA("Tool") or d:IsA("Model")) and matches(d) then return d end
		end
	end
	return nil
end

local function spawnAt(name, angle, radius)
	local tmpl = findTemplate(name)
	if not tmpl then return false end
	if #spawned > 130 then
		local oldF = table.remove(spawned, 1)
		if oldF and oldF.Parent then oldF:Destroy() end
	end
	local r = root()
	local baseCF
	if r then
		baseCF = r.CFrame * CFrame.new(math.cos(angle) * radius, 4, math.sin(angle) * radius)
	else
		baseCF = CFrame.new(0, 80, 0)
	end
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
		if clone.PrimaryPart then
			clone:PivotTo(baseCF)
		else
			local first = clone:FindFirstChildWhichIsA("BasePart")
			if first then first.CFrame = baseCF end
		end
	else
		local handle = clone:FindFirstChild("Handle") or clone:FindFirstChildWhichIsA("BasePart")
		clone.Parent = workspace
		if handle then
			handle.Anchored = false
			handle.CanCollide = true
			handle.CFrame = baseCF
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
		local ok = invoke("BuyFruit", cleanName(name) .. "-" .. cleanName(name))
		invoke("LoadFruit", cleanName(name))
		Notify(ok and ("Servidor: " .. name) or ("Falha: " .. name), not ok)
		return
	end
	if spawnAt(name, math.random() * math.pi * 2, 9) then
		Notify("Spawn: " .. name)
	else
		invoke("LoadFruit", cleanName(name))
		Notify("Sem modelo, enviado ao inventário: " .. name, true)
	end
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
	for c, d in pairs(espCache) do
		if d.box then d.box:Destroy() end
		if d.bill then d.bill:Destroy() end
		if d.tracer then d.tracer:Destroy() end
		if d.lines then
			for _, l in ipairs(d.lines) do l:Destroy() end
		end
		espCache[c] = nil
	end
	espCache = {}
end

local function buildEsp(target, plr)
	if espCache[target] then return end
	local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso")
		or target:FindFirstChild("UpperTorso") or target:FindFirstChildWhichIsA("BasePart")
	local h = target:FindFirstChildOfClass("Humanoid")
	local head = target:FindFirstChild("Head") or hrp
	if not hrp then return end
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
				Text = target.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
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
			d.fill = new("Frame", {
				Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.good,
				BorderSizePixel = 0, Parent = bg,
			})
			corner(d.fill, 2)
		end
	end
	if esp.skel and h then
		for i = 1, #BONES do
			d.lines[i] = new("LineHandleAdornment", {
				Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 6,
				Adornee = hrp, Parent = Cam, Length = 0,
			})
		end
	end
	if esp.tracer and head then
		d.tracer = new("LineHandleAdornment", {
			Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 4, Parent = Cam, Length = 0,
		})
	end
	espCache[target] = d
end

local function updateEsp()
	for target, d in pairs(espCache) do
		if not target.Parent then
			clearEsp()
			break
		end
		local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso")
		local head = target:FindFirstChild("Head")
		local h = target:FindFirstChildOfClass("Humanoid")
		if d.box and hrp then d.box.Adornee = hrp end
		if d.bill and head then d.bill.Adornee = head end
		if d.fill and h then
			local ratio = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
			d.fill.Size = UDim2.new(ratio, 0, 1, 0)
			d.fill.BackgroundColor3 = C.bad:Lerp(C.good, ratio)
		end
		if d.label and head then
			d.label.Text = target.Name .. "  [" .. math.floor((Cam.CFrame.Position - head.Position).Magnitude) .. "]"
		end
		if hrp then
			for i, pairNames in ipairs(BONES) do
				local line = d.lines[i]
				if line then
					local a = target:FindFirstChild(pairNames[1])
					local b = target:FindFirstChild(pairNames[2])
					if a and b then
						line.Length = (a.Position - b.Position).Magnitude
						line.CFrame = CFrame.new((a.Position + b.Position) / 2, b.Position)
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
			local isTeam = esp.team and plr.Team == Player.Team
			if not isTeam then
				local h = plr.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Health > 0 then buildEsp(plr.Character, plr) end
			end
		end
	end
	if esp.fruit then
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj.Name:find("Fruit") and not obj:FindFirstChildOfClass("Humanoid") then
				buildEsp(obj, nil)
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
		if aim.predict then target = target + best.AssemblyLinearVelocity * 0.14 end
		Cam.CFrame = Cam.CFrame:Lerp(CFrame.new(Cam.CFrame.Position, target), aim.smooth)
	end
end)

--==================== VOO =============================================
local flyBV, flyConn
local flyUp, flyDown = false, false
local lockY

local function setFly(on)
	state.fly = on
	local r, h = root(), hum()
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if on then
		if not r then
			state.fly = false
			return Notify("Sem personagem", true)
		end
		if h then h.PlatformStand = true end
		lockY = state.flyLock and r.Position.Y or nil
		flyBV = new("BodyVelocity", {
			MaxForce = Vector3.new(1e5, 1e5, 1e5), P = 8000, Velocity = Vector3.zero, Parent = r,
		})
		flyConn = Run.RenderStepped:Connect(function()
			local c = char()
			local rr = c and c:FindFirstChild("HumanoidRootPart")
			if not rr or not flyBV or not flyBV.Parent then return end
			local dir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Cam.CFrame.RightVector end
			local vertical = 0
			if UIS:IsKeyDown(Enum.KeyCode.Space) or flyUp then vertical += 1 end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.C) or flyDown then vertical -= 1 end
			local speed = state.flySpeed
			if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then speed *= 2 end
			local target = Vector3.new(dir.X, 0, dir.Z)
			if target.Magnitude > 0 then target = target.Unit * speed end
			target = Vector3.new(target.X, vertical * state.flyVert, target.Z)
			if state.flyLock and lockY then
				target = Vector3.new(target.X, (lockY - rr.Position.Y) * 6, target.Z)
			end
			flyBV.Velocity = flyBV.Velocity:Lerp(target, math.clamp(state.flyAccel, 0.05, 1))
		end)
	else
		if h then h.PlatformStand = false end
		lockY = nil
	end
end

--==================== NOCLIP ==========================================
local noclipConn
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

--==================== BOTÕES MÓVEIS DE VOO ============================
local flyPad = new("Frame", {
	Size = UDim2.new(0, 46, 0, 104), Position = UDim2.new(1, -62, 0.5, 40),
	BackgroundTransparency = 1, Visible = false, Parent = Gui,
})
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, flyPad)
local function padBtn(txt, order, setter)
	local b = new("TextButton", {
		Text = txt, Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = C.accent,
		BackgroundColor3 = C.card, BackgroundTransparency = 0.15, Size = UDim2.new(1, 0, 0, 46),
		LayoutOrder = order, AutoButtonColor = false, Parent = flyPad,
	})
	corner(b, 10)
	stroke(b, C.accent, 1, 0.5)
	b.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			setter(true)
			b.BackgroundColor3 = C.hover
		end
	end)
	b.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			setter(false)
			b.BackgroundColor3 = C.card
		end
	end)
	return b
end
padBtn("+", 1, function(v) flyUp = v end)
padBtn("−", 2, function(v) flyDown = v end)

--==================== ABA TELEPORT ====================================
local tpPage = newPage("Teleport")
for _, group in ipairs(PLACES) do
	Section(tpPage, group[1])
	local g = Grid(tpPage, 2)
	for _, entry in ipairs(group[2]) do
		GridButton(g, entry[1], nil, function() TP(entry[2], entry[1]) end)
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
			GridButton(playerGrid, plr.Name, nil, function()
				local c = plr.Character
				local r = c and c:FindFirstChild("HumanoidRootPart")
				if r then TP(r.Position, plr.Name) end
			end)
		end
	end
end
refreshPlayers()
Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5); refreshPlayers() end)

--==================== ABA SPAWN =======================================
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

Section(spPage, "Mapa de spawn")
local searchBox = Input(spPage, "filtrar fruta", function() end)
local allFruits = {}
for _, g in ipairs(FRUIT_GROUPS) do
	for _, n in ipairs(g[2]) do table.insert(allFruits, n) end
end

local function spawnCircle(list)
	local r = root()
	if not r then return Notify("Sem personagem", true) end
	local ok = 0
	for i, name in ipairs(list) do
		local angle = (i / #list) * math.pi * 2
		if spawnAt(name, angle, 16) then ok += 1 end
	end
	Notify("Spawn: " .. ok .. "/" .. #list .. " frutas")
end

local spawnGrids = {}
local function rebuildSpawn(filter)
	for _, g in ipairs(spawnGrids) do g:Destroy() end
	spawnGrids = {}
	for _, group in ipairs(FRUIT_GROUPS) do
		local shown = {}
		for _, name in ipairs(group[2]) do
			if filter == "" or name:lower():find(filter:lower(), 1, true) then
				table.insert(shown, name)
			end
		end
		if #shown > 0 then
			Section(spPage, group[1])
			local head = new("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = spPage })
			table.insert(spawnGrids, head)
			local b = new("TextButton", {
				Text = "spawnar grupo (" .. #shown .. ")", Font = Enum.Font.GothamSemibold,
				TextSize = 11, TextColor3 = C.accent, BackgroundColor3 = C.card,
				Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Parent = head,
			})
			corner(b, 6)
			b.MouseButton1Click:Connect(function() spawnCircle(shown) end)

			local g = Grid(spPage, 3, 26)
			table.insert(spawnGrids, g)
			for _, name in ipairs(shown) do
				GridButton(g, name, nil, function() fruitAction(name) end)
			end
		end
	end
end
rebuildSpawn("")
searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildSpawn(searchBox.Text) end)

Section(spPage, "Ações")
Button(spPage, "Spawnar TODAS em círculo", function() spawnCircle(allFruits) end)
Button(spPage, "Spawnar 10 aleatórias", function()
	local pick = {}
	for _ = 1, 10 do table.insert(pick, allFruits[math.random(1, #allFruits)]) end
	spawnCircle(pick)
end)
Button(spPage, "Fruta aleatória única", function() fruitAction(allFruits[math.random(1, #allFruits)]) end)
Button(spPage, "Limpar frutas geradas", function()
	for _, f in ipairs(spawned) do if f.Parent then f:Destroy() end end
	spawned = {}
	Notify("Cena limpa")
end)
Input(spPage, "fruta personalizada / nova", function(txt) fruitAction(txt) end)

--==================== ABA PLAYER ======================================
local plPage = newPage("Player")
Section(plPage, "Velocidade")
Slider(plPage, "WalkSpeed", 16, 400, 40, function(v) state.speed = v end)
Section(plPage, "Pulo")
local jumpToggle
jumpToggle = Toggle(plPage, "Aplicar altura de pulo", false, function(v)
	state.jumpOn = v
	if not v then
		local h = hum()
		if h then
			if h.UseJumpPower then h.JumpPower = 50 else h.JumpHeight = 15 end
		end
	end
end)
Slider(plPage, "Altura do pulo (studs)", 5, 400, 50, function(v) state.jumpHeight = v end)
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
Button(plPage, "Restaurar pulo padrão", function()
	state.jumpOn = false
	state.jumpHeight = 50
	jumpToggle.set(false)
	local h = hum()
	if h then
		if h.UseJumpPower then h.JumpPower = 50 else h.JumpHeight = 15 end
	end
	Notify("Pulo padrão")
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
Slider(plPage, "Suavidade do voo", 5, 100, 35, function(v) state.flyAccel = v / 100 end)
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
	Notify(v and "God on" or "God off")
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
Button(plPage, "Restaurar tudo", function()
	state.speed, state.jumpHeight, state.multiJump = 16, 50, 1
	state.god, state.infJump, state.noclip = false, false, false
	if state.fly then setFly(false) end
	setNoclip(false)
	applyStats()
	Notify("Tudo restaurado")
end)

--==================== ABA COMBATE =====================================
local cbPage = newPage("Combate")
Section(cbPage, "Aimbot")
Toggle(cbPage, "Aimbot", false, function(v)
	aim.on = v
	fovCircle.Visible = v
	Notify(v and "Aimbot on" or "Aimbot off")
end)
Slider(cbPage, "FOV", 40, 600, 150, function(v)
	aim.fov = v
	fovCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end)
Slider(cbPage, "Suavidade", 5, 100, 22, function(v) aim.smooth = v / 100 end)
Toggle(cbPage, "Predição", false, function(v) aim.predict = v end)
Toggle(cbPage, "Ignorar time", true, function(v) aim.team = v end)
Section(cbPage, "Mira")
Button(cbPage, "Centralizar mira", function()
	local r = root()
	if r then Cam.CFrame = CFrame.new(Cam.CFrame.Position, r.Position + Cam.CFrame.LookVector * 10) end
end)

--==================== ABA VISUAL ======================================
local vsPage = newPage("Visual")
Section(vsPage, "ESP")
Toggle(vsPage, "ESP ativo", false, function(v)
	esp.on = v
	if not v then clearEsp() end
	Notify(v and "ESP on" or "ESP off")
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

--==================== ABA ADMIN =======================================
local adPage = newPage("Admin")
Section(adPage, "Ilhas de admin")
local adminGrid = Grid(adPage, 2)
for _, entry in ipairs(PLACES[4][2]) do
	GridButton(adminGrid, entry[1], C.accent, function() TP(entry[2], entry[1]) end)
end

Section(adPage, "Haki / time (servidor)")
Button(adPage, "Comprar Buso Haki", function() invoke("BuyHaki", "Buso"); Notify("Buso") end)
Button(adPage, "Comprar Kenbunshoku", function() invoke("BuyHaki", "Ken"); Notify("Ken") end)
Button(adPage, "Comprar Geppo", function() invoke("BuyHaki", "Geppo"); Notify("Geppo") end)
Button(adPage, "Comprar Soru", function() invoke("BuyHaki", "Soru"); Notify("Soru") end)
Button(adPage, "Time Pirata", function() invoke("SetTeam", "Pirates"); Notify("Pirates") end)
Button(adPage, "Time Marinha", function() invoke("SetTeam", "Marines"); Notify("Marines") end)

Section(adPage, "Items")
local ITEMS = {
	"Dark Blade", "Cursed Dual Katana", "Saber", "Bisento", "Dragon Trident",
	"Hallow Scythe", "Saddi", "Kabucha", "Serpent Bow", "Bazooka", "Cannon",
	"Flintlock", "Musket", "Slingshot", "Acidum Rifle", "Bizarre Rifle",
	"Katana", "Cutlass", "Trident", "Superhuman", "Godhuman", "Sanguine Art",
	"Electric Claw", "Dragon Talon", "Sharkman Karate", "Death Step", "Mink",
}
local function giveTool(name)
	local tmpl = findTemplate(name)
	if tmpl and tmpl:IsA("Tool") then
		local bp = Player:FindFirstChild("Backpack")
		if not bp then return Notify("Sem backpack", true) end
		tmpl:Clone().Parent = bp
		return Notify("Item: " .. name)
	end
	local ok = invoke("BuyItem", name)
	Notify(ok and ("Servidor: " .. name) or ("Não achado: " .. name), not ok)
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

Section(adPage, "Extras")
Button(adPage, "Copiar posição", function()
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
		Tween:Create(OrbLbl, TweenInfo.new(0.18), { TextColor3 = C.bg }):Play()
	else
		Tween:Create(Win, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.new(0, W, 0, 0) }):Play()
		Tween:Create(Orb, TweenInfo.new(0.18), { BackgroundColor3 = C.card }):Play()
		Tween:Create(OrbLbl, TweenInfo.new(0.18), { TextColor3 = C.accent }):Play()
		task.delay(0.19, function()
			if Win.Size.Y.Offset < 40 then Win.Visible = false end
		end)
	end
end

Orb.MouseButton1Click:Connect(function() setOpen(not Win.Visible) end)

UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then setOpen(not Win.Visible) end
end)

showTab("Teleport")
task.wait(0.1)
Notify("JDEV v2 pronto")
