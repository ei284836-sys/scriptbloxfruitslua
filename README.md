--=====================================================================
--  JDEV  v4  •  LUNAR BUILD
--  Emblema procedural, sidebar, status ao vivo, log, farm, hop, ESP.
--=====================================================================
if getgenv and getgenv().JDEV_LOADED then
	local prev = getgenv().JDEV_LOADED
	if typeof(prev) == "Instance" and prev.Parent then prev:Destroy() end
end
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.15)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local Tween = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Http = game:GetService("HttpService")
local Teleport = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local C = {
	bg = Color3.fromRGB(9, 9, 14),
	panel = Color3.fromRGB(14, 14, 21),
	card = Color3.fromRGB(20, 20, 29),
	hover = Color3.fromRGB(30, 29, 43),
	line = Color3.fromRGB(38, 36, 54),
	text = Color3.fromRGB(233, 231, 245),
	dim = Color3.fromRGB(126, 122, 150),
	violet = Color3.fromRGB(146, 108, 255),
	blue = Color3.fromRGB(86, 156, 255),
	cyan = Color3.fromRGB(120, 220, 255),
	good = Color3.fromRGB(92, 224, 148),
	bad = Color3.fromRGB(255, 96, 110),
}

--==================== HELPERS =========================================
local function new(class, props, parent)
	local o = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			if k ~= "Parent" then o[k] = v end
		end
	end
	if parent then o.Parent = parent end
	return o
end
local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, col, t, tr)
	return new("UIStroke", { Color = col or C.line, Thickness = t or 1, Transparency = tr or 0.4 }, o)
end
local function grad(o, a, b, rot)
	local g = new("UIGradient", { Rotation = rot or 90 }, o)
	g.Color = ColorSequence.new(a, b)
	return g
end
local function pad(o, t, r, b, l)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, t or 0), PaddingRight = UDim.new(0, r or 0),
		PaddingBottom = UDim.new(0, b or 0), PaddingLeft = UDim.new(0, l or 0),
	}, o)
end
local function cam() return workspace.CurrentCamera end
local function vp()
	local c = workspace.CurrentCamera
	return c and c.ViewportSize or Vector2.new(1280, 720)
end

--==================== PLAYER ==========================================
local Player = Players.LocalPlayer
local guard = 0
while not Player and guard < 40 do
	task.wait(0.15)
	Player = Players.LocalPlayer or Players:GetPlayers()[1]
	guard += 1
end
if not Player then
	warn("[JDEV] sem player")
	return
end
local PlayerGui = Player:FindFirstChildOfClass("PlayerGui") or Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then
	warn("[JDEV] sem PlayerGui — rode como LocalScript")
	return
end

local old = PlayerGui:FindFirstChild("JDEV")
if old then old:Destroy() end

--==================== GUI + WATCHDOG ==================================
local Gui = new("ScreenGui", {
	Name = "JDEV", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PlayerGui)
if getgenv then getgenv().JDEV_LOADED = Gui end

-- sonda: se isso aparece, GUI funciona
local probe = new("Frame", {
	Size = UDim2.fromOffset(150, 26), Position = UDim2.fromOffset(14, 14),
	BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 90,
}, Gui)
corner(probe, 6)
stroke(probe, C.violet, 1, 0.3)
local probeLbl = new("TextLabel", {
	Text = "carregando…", Font = Enum.Font.GothamMedium, TextSize = 12,
	TextColor3 = C.dim, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
}, probe)

local errBox = new("TextLabel", {
	Size = UDim2.new(1, -28, 0, 0), Position = UDim2.fromOffset(14, 48),
	BackgroundColor3 = Color3.fromRGB(58, 12, 20), TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.Code, TextSize = 11, TextWrapped = true,
	AutomaticSize = Enum.AutomaticSize.Y, TextXAlignment = Enum.TextXAlignment.Left,
	Visible = false, ZIndex = 95, BorderSizePixel = 0,
}, Gui)
corner(errBox, 6)
pad(errBox, 7, 8, 7, 8)

local function fail(msg)
	errBox.Text = "JDEV · ERRO\n" .. tostring(msg)
	errBox.Visible = true
	probeLbl.Text = "erro"
	probeLbl.TextColor3 = C.bad
	warn("[JDEV] " .. tostring(msg))
end

task.delay(6, function()
	if probeLbl.Text == "carregando…" then
		probeLbl.Text = "travado aqui"
		probeLbl.TextColor3 = C.bad
	end
end)

--==================== EMBLEMA =========================================
local function emblem(parent, size)
	local box = new("Frame", {
		Size = UDim2.fromOffset(size, size), BackgroundColor3 = Color3.fromRGB(6, 6, 11),
		BorderSizePixel = 0, ClipsDescendants = true,
	}, parent)
	corner(box, math.floor(size * 0.26))
	grad(box, Color3.fromRGB(16, 10, 30), Color3.fromRGB(6, 8, 18), 45)

	local ring = new("Frame", {
		Size = UDim2.fromScale(0.9, 0.9), Position = UDim2.fromScale(0.05, 0.05),
		BackgroundTransparency = 1,
	}, box)
	corner(ring, 999)
	local rs = stroke(ring, C.violet, 1, 0.15)
	grad(rs, C.violet, C.blue, 45)

	local moon = new("Frame", {
		Size = UDim2.fromScale(0.54, 0.54), Position = UDim2.fromScale(0.23, 0.23),
		BackgroundColor3 = Color3.fromRGB(120, 190, 255), BorderSizePixel = 0,
	}, box)
	corner(moon, 999)
	grad(moon, Color3.fromRGB(150, 215, 255), Color3.fromRGB(70, 120, 255), 120)

	local bite = new("Frame", {
		Size = UDim2.fromScale(0.5, 0.5), Position = UDim2.fromScale(0.36, 0.2),
		BackgroundColor3 = Color3.fromRGB(9, 9, 16), BorderSizePixel = 0,
	}, box)
	corner(bite, 999)

	local starA = new("Frame", {
		Size = UDim2.fromScale(0.075, 0.56), Position = UDim2.fromScale(0.462, 0.22),
		BackgroundColor3 = Color3.fromRGB(226, 210, 255), BorderSizePixel = 0,
	}, box)
	corner(starA, 999)
	local starB = new("Frame", {
		Size = UDim2.fromScale(0.075, 0.56), Position = UDim2.fromScale(0.462, 0.22),
		Rotation = 90, BackgroundColor3 = Color3.fromRGB(226, 210, 255), BorderSizePixel = 0,
	}, box)
	corner(starB, 999)
	starA.Size = UDim2.fromScale(0.56, 0.075)
	starA.Position = UDim2.fromScale(0.22, 0.462)
	starB.Size = UDim2.fromScale(0.56, 0.075)
	starB.Position = UDim2.fromScale(0.22, 0.462)
	starA.Rotation = 45
	starB.Rotation = 135
	grad(starA, C.cyan, C.violet, 0)
	grad(starB, C.cyan, C.violet, 0)

	local core = new("Frame", {
		Size = UDim2.fromScale(0.13, 0.13), Position = UDim2.fromScale(0.435, 0.435),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0,
	}, box)
	corner(core, 999)

	local flame = new("Frame", {
		Size = UDim2.fromScale(0.07, 0.11), Position = UDim2.fromScale(0.465, 0.055),
		Rotation = 45, BackgroundColor3 = C.violet, BorderSizePixel = 0,
	}, box)
	corner(flame, 3)

	local s1 = new("Frame", {
		Size = UDim2.fromScale(0.06, 0.06), Position = UDim2.fromScale(0.02, 0.47),
		Rotation = 45, BackgroundColor3 = C.blue, BorderSizePixel = 0,
	}, box)
	corner(s1, 2)
	local s2 = new("Frame", {
		Size = UDim2.fromScale(0.06, 0.06), Position = UDim2.fromScale(0.92, 0.47),
		Rotation = 45, BackgroundColor3 = C.blue, BorderSizePixel = 0,
	}, box)
	corner(s2, 2)

	return box
end

--==================== BUILD ===========================================
local ok, err = pcall(function()

--========== LOG / STATUS ==========
local logLines = {}
local counters = { spawnOk = 0, spawnFail = 0, groups = 0, groupsFail = 0 }
local startedAt = os.clock()

--========== TOASTS ==========
local toastHolder = new("Frame", {
	Size = UDim2.new(0, 250, 1, -24), Position = UDim2.new(1, -264, 0, 12),
	BackgroundTransparency = 1, ZIndex = 40,
}, Gui)
new("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6),
}, toastHolder)

local toastN = 0
local function Notify(txt, kind)
	toastN += 1
	local col = C.violet
	if kind == "bad" then col = C.bad elseif kind == "good" then col = C.good end
	local card = new("Frame", {
		Size = UDim2.fromOffset(0, 30), BackgroundColor3 = C.card,
		BackgroundTransparency = 0.06, LayoutOrder = toastN, ZIndex = 41,
	}, toastHolder)
	corner(card, 7)
	stroke(card, col, 1, 0.25)
	new("Frame", {
		Size = UDim2.new(0, 3, 0.55, 0), Position = UDim2.new(0, 6, 0.22, 0),
		BackgroundColor3 = col, BorderSizePixel = 0,
	}, card)
	new("TextLabel", {
		Text = tostring(txt), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, card)
	Tween:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(230, 30) }):Play()
	task.delay(2.3, function()
		Tween:Create(card, TweenInfo.new(0.18), { BackgroundTransparency = 1 }):Play()
		for _, d in ipairs(card:GetDescendants()) do
			if d:IsA("TextLabel") then Tween:Create(d, TweenInfo.new(0.18), { TextTransparency = 1 }):Play() end
		end
		task.wait(0.2)
		card:Destroy()
	end)
end

--========== DRAG ==========
local function draggable(frame, handle)
	local drag, input, origin, start
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag, origin, start = true, frame.Position, i.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then drag = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			input = i
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if i ~= input or not drag then return end
		local d = i.Position - start
		local s = vp()
		frame.Position = UDim2.fromOffset(
			math.clamp(origin.X.Offset + d.X, 0, s.X - frame.AbsoluteSize.X),
			math.clamp(origin.Y.Offset + d.Y, 0, s.Y - frame.AbsoluteSize.Y)
		)
	end)
end

--========== ORBE ==========
local Orb = new("TextButton", {
	Text = "", Size = UDim2.fromOffset(52, 52), Position = UDim2.fromOffset(14, 14),
	BackgroundColor3 = C.panel, AutoButtonColor = false, ZIndex = 30,
}, Gui)
corner(Orb, 16)
stroke(Orb, C.violet, 1, 0.15)
emblem(Orb, 52)
draggable(Orb, Orb)

--========== JANELA ==========
local s0 = vp()
local WW = math.clamp(s0.X - 48, 300, 430)
local HH = math.clamp(s0.Y - 120, 330, 560)

local Win = new("Frame", {
	Size = UDim2.fromOffset(WW, HH), Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.bg,
	ClipsDescendants = true, Visible = false, ZIndex = 20,
}, Gui)
corner(Win, 14)
stroke(Win, C.line, 1, 0.1)
new("Frame", {
	Size = UDim2.new(1, 0, 0, 120), BackgroundColor3 = C.violet,
	BackgroundTransparency = 0.94, BorderSizePixel = 0,
}, Win)

--========== HEADER ==========
local Header = new("Frame", {
	Size = UDim2.new(1, -56, 0, 54), Position = UDim2.fromOffset(56, 0),
	BackgroundTransparency = 1,
}, Win)
draggable(Win, Header)

local logo = emblem(Header, 34)
logo.Position = UDim2.fromOffset(0, 11)

local Title = new("TextLabel", {
	Text = "JDEV", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.text,
	BackgroundTransparency = 1, Size = UDim2.fromOffset(80, 17), Position = UDim2.fromOffset(42, 9),
	TextXAlignment = Enum.TextXAlignment.Left,
}, Header)
local Sub = new("TextLabel", {
	Text = "lunar build", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.dim,
	BackgroundTransparency = 1, Size = UDim2.fromOffset(110, 13), Position = UDim2.fromOffset(42, 26),
	TextXAlignment = Enum.TextXAlignment.Left,
}, Header)

local Pill = new("Frame", {
	Size = UDim2.fromOffset(96, 20), Position = UDim2.fromOffset(42, 40),
	BackgroundColor3 = C.card, BorderSizePixel = 0,
}, Header)
corner(Pill, 10)
local pillDot = new("Frame", {
	Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(7, 7),
	BackgroundColor3 = C.dim, BorderSizePixel = 0,
}, Pill)
corner(pillDot, 3)
local pillTxt = new("TextLabel", {
	Text = "idle", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.dim,
	BackgroundTransparency = 1, Size = UDim2.new(1, -18, 1, 0), Position = UDim2.fromOffset(18, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
}, Pill)

local function setPill(txt, kind)
	pillTxt.Text = txt
	local col = C.dim
	if kind == "ok" then col = C.good elseif kind == "bad" then col = C.bad elseif kind == "busy" then col = C.cyan end
	pillTxt.TextColor3 = col
	pillDot.BackgroundColor3 = col
end

local Min = new("TextButton", {
	Text = "—", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.dim,
	BackgroundColor3 = C.card, Size = UDim2.fromOffset(22, 22),
	Position = UDim2.new(1, -30, 0, 14), AutoButtonColor = false,
}, Header)
corner(Min, 6)
Min.MouseButton1Click:Connect(function() Win.Visible = false end)

--========== SIDEBAR ==========
local Rail = new("Frame", {
	Size = UDim2.new(0, 56, 1, -54), Position = UDim2.fromOffset(0, 54),
	BackgroundColor3 = C.panel, BorderSizePixel = 0,
}, Win)
new("Frame", {
	Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
	BackgroundColor3 = C.line, BorderSizePixel = 0, BackgroundTransparency = 0.4,
}, Rail)
pad(Rail, 6, 6, 6, 6)
new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, Rail)

--========== ÁREA DE PÁGINAS ==========
local Body = new("Frame", {
	Size = UDim2.new(1, -56, 1, -54), Position = UDim2.fromOffset(56, 54),
	BackgroundTransparency = 1,
}, Win)

local Pages, TabBtns = {}, {}
local activeTab

local function newPage(name)
	local sc = new("ScrollingFrame", {
		Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.line,
		CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, Body)
	pad(sc, 10, 10, 14, 12)
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sc)
	Pages[name] = sc
	return sc
end

local function showTab(name)
	for n, btn in pairs(TabBtns) do
		btn.BackgroundColor3 = C.card
		btn.TextColor3 = C.dim
		btn.TextSize = 9
		if Pages[n] then Pages[n].Visible = false end
	end
	activeTab = name
	if TabBtns[name] then
		TabBtns[name].BackgroundColor3 = C.hover
		TabBtns[name].TextColor3 = C.violet
	end
	if Pages[name] then Pages[name].Visible = true end
end

--========== COMPONENTES ==========
local function Section(page, txt)
	local h = new("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1 }, page)
	new("TextLabel", {
		Text = string.upper(txt), Font = Enum.Font.GothamBold, TextSize = 9,
		TextColor3 = C.dim, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, h)
	return h
end

local function Card(page, height)
	local f = new("Frame", {
		Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = C.card, BorderSizePixel = 0,
	}, page)
	corner(f, 8)
	stroke(f, C.line, 1, 0.65)
	return f
end

local function Button(page, txt, cb, accent)
	local b = new("TextButton", {
		Text = "", Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card,
		AutoButtonColor = false, BorderSizePixel = 0,
	}, page)
	corner(b, 8)
	stroke(b, C.line, 1, 0.65)
	new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 12,
		TextColor3 = accent and C.violet or C.text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, b)
	b.MouseEnter:Connect(function() b.BackgroundColor3 = C.hover end)
	b.MouseLeave:Connect(function() b.BackgroundColor3 = C.card end)
	b.MouseButton1Click:Connect(function()
		b.BackgroundColor3 = C.hover
		task.delay(0.1, function()
			if b.Parent then b.BackgroundColor3 = C.card end
		end)
		local okc, e = pcall(cb, b)
		if not okc then Notify(tostring(e), "bad") end
	end)
	return b
end

local function GridButton(grid, txt, col, cb)
	local b = new("TextButton", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = col or C.text,
		BackgroundColor3 = C.card, AutoButtonColor = false, BorderSizePixel = 0,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, grid)
	corner(b, 6)
	b.MouseButton1Click:Connect(function()
		local okc, e = pcall(cb, b)
		if not okc then Notify(tostring(e), "bad") end
	end)
	return b
end

local function Toggle(page, txt, def, cb)
	local on = def or false
	local row = Card(page, 32)
	new("TextLabel", {
		Text = txt, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -56, 1, 0), Position = UDim2.fromOffset(10, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, row)
	local track = new("Frame", {
		Size = UDim2.fromOffset(30, 16), Position = UDim2.new(1, -40, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0,
	}, row)
	corner(track, 8)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(12, 12), Position = UDim2.new(0, 2, 0.5, -6),
		BackgroundColor3 = C.text, BorderSizePixel = 0,
	}, track)
	corner(knob, 6)
	local function apply(v)
		on = v
		track.BackgroundColor3 = v and C.violet or Color3.fromRGB(42, 41, 56)
		knob.Position = v and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
		local okc, e = pcall(cb, v)
		if not okc then Notify(tostring(e), "bad") end
	end
	hit.MouseButton1Click:Connect(function() apply(not on) end)
	return { set = apply, get = function() return on end }
end

local function Slider(page, txt, min, max, def, cb)
	local row = Card(page, 46)
	local lbl = new("TextLabel", {
		Text = txt .. "  " .. tostring(def), Font = Enum.Font.GothamMedium, TextSize = 11,
		TextColor3 = C.text, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 22),
		Position = UDim2.fromOffset(10, 4), TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local track = new("Frame", {
		Size = UDim2.new(1, -20, 0, 4), Position = UDim2.fromOffset(10, 32),
		BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0,
	}, row)
	corner(track, 2)
	local fill = new("Frame", {
		Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = C.violet, BorderSizePixel = 0,
	}, track)
	corner(fill, 2)
	grad(fill, C.violet, C.blue, 0)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(9, 9), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0), BackgroundColor3 = C.text,
		BorderSizePixel = 0,
	}, track)
	corner(knob, 5)
	local dragging = false
	local function set(a)
		a = math.clamp(a, 0, 1)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, 0, 0.5, 0)
		local v = math.floor(min + (max - min) * a + 0.5)
		lbl.Text = txt .. "  " .. tostring(v)
		cb(v)
	end
	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			set((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			set((i.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1))
		end
	end)
	return { set = function(v) set((v - min) / (max - min)) end }
end

local function Input(page, placeholder, onSubmit)
	local b = new("TextBox", {
		Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = C.card, Text = "",
		PlaceholderText = placeholder, PlaceholderColor3 = C.dim,
		Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
		ClearTextOnFocus = false, BorderSizePixel = 0,
	}, page)
	corner(b, 7)
	stroke(b, C.line, 1, 0.65)
	pad(b, 0, 8, 0, 8)
	b.FocusLost:Connect(function(enter)
		if enter and b.Text ~= "" then
			onSubmit(b.Text)
			b.Text = ""
		end
	end)
	return b
end

local function Grid(page, cols, h)
	local g = new("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, page)
	new("UIGridLayout", {
		CellSize = UDim2.new(1 / cols, -3, 0, h or 26), CellPadding = UDim2.new(0, 3, 0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, g)
	return g
end

--========== ABAS (rail) ==========
local TABS = {
	{ "TP", "Teleport" }, { "SP", "Spawn" }, { "PL", "Player" }, { "CB", "Combat" },
	{ "VS", "Visual" }, { "ST", "Status" }, { "AD", "Admin" },
}
for i, t in ipairs(TABS) do
	local b = new("TextButton", {
		Text = t[1], Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.new(1, 0, 0, 30), AutoButtonColor = false,
		BorderSizePixel = 0, LayoutOrder = i,
	}, Rail)
	corner(b, 8)
	TabBtns[t[2]] = b
	b.MouseEnter:Connect(function()
		if activeTab ~= t[2] then b.BackgroundColor3 = C.hover end
	end)
	b.MouseLeave:Connect(function()
		if activeTab ~= t[2] then b.BackgroundColor3 = C.card end
	end)
	b.MouseButton1Click:Connect(function() showTab(t[2]) end)
end

--========== ESTADO ==========
local S = {
	speed = 40, jumpH = 50, jumpOn = false, multi = 1,
	god = false, infJump = false, noclip = false,
	fly = false, flyH = 70, flyV = 60, flyLock = false, flyAcc = 0.35,
	farm = false, farmRange = 120, fastAtk = false, autoHaki = false,
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
local function grav() return workspace.Gravity > 1 and workspace.Gravity or 196.2 end

local godOld = {}
local function applyStats()
	local h = hum()
	if not h then return end
	h.WalkSpeed = S.speed
	if S.jumpOn then
		if h.UseJumpPower then
			h.JumpPower = math.clamp(math.sqrt(2 * grav() * S.jumpH), 50, 1000)
		else
			h.JumpHeight = S.jumpH
		end
	end
	if S.god then
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

local jumpN = 0
local function jump()
	local h, r = hum(), root()
	if not h or not r then return end
	h:ChangeState(Enum.HumanoidStateType.Jumping)
	local bv = new("BodyVelocity", {
		MaxForce = Vector3.new(0, 1e5, 0),
		Velocity = Vector3.new(r.AssemblyLinearVelocity.X, math.sqrt(2 * grav() * S.jumpH), r.AssemblyLinearVelocity.Z),
	}, r)
	task.delay(0.25, function() if bv.Parent then bv:Destroy() end end)
end
UIS.JumpRequest:Connect(function()
	if S.infJump then
		jump()
	elseif S.multi > 1 and jumpN > 0 then
		jumpN -= 1
		jump()
	end
end)
Player.CharacterAdded:Connect(function(c)
	task.wait(1)
	S.fly = false
	local h = c:WaitForChild("Humanoid", 8)
	if h then
		h.StateChanged:Connect(function(st)
			if st == Enum.HumanoidStateType.Landed then jumpN = S.multi - 1 end
		end)
	end
	applyStats()
end)

--========== REDE ==========
local function CommF()
	local rem = RS:FindFirstChild("Remotes")
	return rem and rem:FindFirstChild("CommF_")
end
local function invoke(...)
	local c = CommF()
	if not c then return false end
	local a, b = pcall(function() return c:InvokeServer(...) end)
	return a, b
end

--========== LOG ==========
local logPage
local function log(txt, kind)
	local stamp = string.format("%02d:%02d", math.floor((os.clock() - startedAt) / 60), math.floor((os.clock() - startedAt) % 60))
	table.insert(logLines, { stamp, tostring(txt), kind })
	if #logLines > 70 then table.remove(logLines, 1) end
	if logPage then
		for _, c in ipairs(logPage:GetChildren()) do
			if c:IsA("TextLabel") then c:Destroy() end
		end
		for i = #logLines, 1, -1 do
			local l = logLines[i]
			local col = C.dim
			if l[3] == "ok" then col = C.good elseif l[3] == "bad" then col = C.bad end
			local row = new("TextLabel", {
				Text = l[1] .. "  " .. l[2], Font = Enum.Font.Code, TextSize = 10, TextColor3 = col,
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), LayoutOrder = #logLines - i,
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
			}, logPage)
			row.Name = "L" .. i
		end
	end
end

--========== PLACES ==========
local PLACES = {
	{ "Sea 1", {
		{ "Fruit Dealer", Vector3.new(0, 5, 0) }, { "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Amazon Lily", Vector3.new(-3000, 5, 2500) }, { "Sky Island", Vector3.new(-7863, 5545, -378) },
	} },
	{ "Sea 2", {
		{ "Colosseum", Vector3.new(-5000, 5, 0) }, { "Cursed Ship", Vector3.new(0, 5, -4000) },
		{ "Haunted Castle", Vector3.new(-3000, 5, -4000) }, { "Café", Vector3.new(-386, 74, -314) },
	} },
	{ "Sea 3", {
		{ "Egghead", Vector3.new(6000, 5, 6000) }, { "Mansion", Vector3.new(6000, 5, -6000) },
		{ "Hydra", Vector3.new(-8000, 5, 0) }, { "Great Tree", Vector3.new(-1055, 328, -8916) },
	} },
	{ "Admin", {
		{ "Admin Island", Vector3.new(0, 5, -10000) }, { "Admin Room", Vector3.new(0, 5, -12500) },
		{ "Dev Room", Vector3.new(0, 1000, -15000) }, { "Vazio", Vector3.new(0, 3000, 0) },
	} },
}

local function TP(pos, label)
	local r = root()
	if not r then
		Notify("sem personagem", "bad")
		log("TP falhou: sem personagem", "bad")
		return
	end
	setPill("teleport", "busy")
	if (r.Position - pos).Magnitude > 3000 then invoke("requestEntrance", pos); task.wait(0.45) end
	r.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
	log("TP → " .. (label or "?"), "ok")
	setPill("ok", "ok")
end

--========== FRUTAS ==========
local GROUPS = {
	{ "Comum", { "Rocket", "Kilo", "Spin", "Blade", "Chop", "Spring", "Bomb", "Spike" } },
	{ "Rara", { "Diamond", "Revive", "Rubber", "Ghost", "Barrier", "Creation", "Door", "Portal", "Smoke", "Flame", "Ice", "Sand", "Dark", "Light", "Falcon", "Eagle" } },
	{ "Lendária", { "Quake", "Love", "Spider", "String", "Sound", "Pain", "Paw", "Magma", "Lightning", "Rumble", "Blizzard", "Buddha", "Phoenix" } },
	{ "Mítica", { "Gravity", "Shadow", "Venom", "Spirit", "Soul", "Control", "Dough", "Gas", "Hellfire (Gas)", "Mammoth", "T-Rex", "Leopard", "Tiger", "Yeti", "Kitsune", "Dragon", "Dragon (Classic)", "Magnet", "Empyrean (Kitsune)", "Fiend (Yeti)", "Werewolf (Tiger)", "Celestial", "Oni", "Meme" } },
}
local ALIAS = {
	Rocket = "Kilo", Kilo = "Rocket", Blade = "Chop", Chop = "Blade", Portal = "Door",
	Door = "Portal", Lightning = "Rumble", Rumble = "Lightning", Spirit = "Soul",
	Soul = "Spirit", Spider = "String", String = "Spider", Tiger = "Leopard",
	Leopard = "Tiger", Creation = "Barrier", Barrier = "Creation", Eagle = "Falcon",
	Falcon = "Eagle",
}
local mode = "physical"
local spawned = {}
local cache = {}

local function clean(n) return (n:gsub("%s*%b()", "")) end

local function findTmpl(name)
	local base = clean(name)
	local c = cache[base]
	if c and c.Parent then return c end
	local raw = { name, base, base .. " Fruit", base .. "-" .. base, base .. "-" .. base .. " Fruit" }
	if ALIAS[base] then
		local a = ALIAS[base]
		for _, v in ipairs({ a, a .. " Fruit", a .. "-" .. a }) do table.insert(raw, v) end
	end
	local keys = {}
	for _, k in ipairs(raw) do keys[k:lower()] = true end
	local found
	for _, cont in ipairs({ RS, workspace }) do
		for _, d in ipairs(cont:GetDescendants()) do
			if (d:IsA("Tool") or d:IsA("Model")) and keys[d.Name:lower()] then
				found = d
				break
			end
		end
		if found then break end
	end
	if found then cache[base] = found end
	return found
end

local function spawnAt(name, angle, radius)
	local t = findTmpl(name)
	if not t then return false end
	if #spawned > 140 then
		local o = table.remove(spawned, 1)
		if o and o.Parent then o:Destroy() end
	end
	local r = root()
	local cf = r and (r.CFrame * CFrame.new(math.cos(angle) * radius, 4, math.sin(angle) * radius)) or CFrame.new(0, 80, 0)
	local cl = t:Clone()
	cl.Name = clean(name) .. " Fruit"
	if cl:IsA("Model") then
		for _, p in ipairs(cl:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = false
				p.CanCollide = true
			end
		end
		cl.Parent = workspace
		if cl.PrimaryPart then cl:PivotTo(cf) else
			local f = cl:FindFirstChildWhichIsA("BasePart")
			if f then f.CFrame = cf end
		end
	else
		local h = cl:FindFirstChild("Handle") or cl:FindFirstChildWhichIsA("BasePart")
		cl.Parent = workspace
		if h then
			h.Anchored = false
			h.CanCollide = true
			h.CFrame = cf
		end
	end
	new("Highlight", {
		FillTransparency = 0.75, OutlineTransparency = 0.05,
		FillColor3 = C.violet, OutlineColor3 = C.cyan,
	}, cl)
	table.insert(spawned, cl)
	return true
end

local function oneFruit(name)
	if mode == "real" then
		local okBuy = invoke("BuyFruit", clean(name) .. "-" .. clean(name))
		invoke("LoadFruit", clean(name))
		log((okBuy and "servidor: " or "falhou: ") .. name, okBuy and "ok" or "bad")
		return Notify(okBuy and ("servidor: " .. name) or ("falhou: " .. name), okBuy and "good" or "bad")
	end
	if spawnAt(name, math.random() * math.pi * 2, 9) then
		counters.spawnOk += 1
		log("spawn: " .. name, "ok")
		setPill("spawn ok", "ok")
		Notify("spawn: " .. name, "good")
	else
		counters.spawnFail += 1
		invoke("LoadFruit", clean(name))
		log("sem modelo: " .. name, "bad")
		setPill("falhou", "bad")
		Notify("sem modelo: " .. name, "bad")
	end
end

local function groupSpawn(list, label)
	if not root() then return Notify("sem personagem", "bad") end
	counters.groups += 1
	setPill("spawnando", "busy")
	local okc = 0
	for i, n in ipairs(list) do
		if spawnAt(n, (i / math.max(#list, 1)) * math.pi * 2, 16) then okc += 1 end
	end
	local miss = #list - okc
	counters.spawnOk += okc
	counters.spawnFail += miss
	if miss > 0 then counters.groupsFail += 1 end
	log((label or "grupo") .. ": " .. okc .. "/" .. #list .. " ok", miss == 0 and "ok" or "bad")
	setPill(okc .. "/" .. #list .. " ok", miss == 0 and "ok" or "bad")
	Notify((label or "grupo") .. " · " .. okc .. "/" .. #list, miss == 0 and "good" or "bad")
end

--========== ESP ==========
local E = { on = false, box = true, name = true, hp = true, skel = true, line = true, fruit = false, team = false }
local ec = {}
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
	for t, d in pairs(ec) do
		if d.box then d.box:Destroy() end
		if d.bill then d.bill:Destroy() end
		if d.line then d.line:Destroy() end
		for _, l in ipairs(d.lines) do l:Destroy() end
	end
	ec = {}
end

local function buildEsp(t, plr)
	if ec[t] then return end
	local hrp = t:FindFirstChild("HumanoidRootPart") or t:FindFirstChild("Torso") or t:FindFirstChildWhichIsA("BasePart")
	local h = t:FindFirstChildOfClass("Humanoid")
	local head = t:FindFirstChild("Head") or hrp
	local c = cam()
	if not hrp or not c then return end
	local col = Color3.fromRGB(255, 92, 104)
	if plr and plr.Team then col = plr.Team.TeamColor.Color end
	local d = { lines = {} }
	if E.box then
		d.box = new("BoxHandleAdornment", {
			Size = Vector3.new(4, 5.4, 2), AlwaysOnTop = true, ZIndex = 5,
			Transparency = 0.45, Color3 = col, Adornee = hrp,
		}, hrp)
	end
	if (E.name or E.hp) and head then
		d.bill = new("BillboardGui", {
			Size = UDim2.fromOffset(140, 42), StudsOffset = Vector3.new(0, 2.6, 0),
			AlwaysOnTop = true, Adornee = head,
		}, head)
		if E.name then
			d.lbl = new("TextLabel", {
				Text = t.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.4, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 15),
			}, d.bill)
		end
		if E.hp then
			local bg = new("Frame", {
				Size = UDim2.new(0.8, 0, 0, 5), Position = UDim2.fromOffset(14, 17),
				BackgroundColor3 = Color3.fromRGB(18, 18, 22), BorderSizePixel = 0,
			}, d.bill)
			corner(bg, 2)
			d.fill = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.good, BorderSizePixel = 0 }, bg)
			corner(d.fill, 2)
		end
	end
	if E.skel and h then
		for i = 1, #BONES do
			d.lines[i] = new("LineHandleAdornment", {
				Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 6, Adornee = hrp, Length = 0,
			}, c)
		end
	end
	if E.line and head then
		d.line = new("LineHandleAdornment", {
			Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 4, Length = 0,
		}, c)
	end
	ec[t] = d
end

local function tickEsp()
	local c = cam()
	if not c then return end
	for t, d in pairs(ec) do
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
		if d.lbl and head then
			d.lbl.Text = t.Name .. "  [" .. math.floor((c.CFrame.Position - head.Position).Magnitude) .. "]"
		end
		if hrp then
			for i, bn in ipairs(BONES) do
				local ln = d.lines[i]
				if ln then
					local a, b = t:FindFirstChild(bn[1]), t:FindFirstChild(bn[2])
					if a and b then
						ln.Length = (a.Position - b.Position).Magnitude
						ln.CFrame = CFrame.new((a.Position + b.Position) / 2, b.Position)
					else
						ln.Length = 0
					end
				end
			end
			if d.line and head then
				local o = c.CFrame.Position + c.CFrame.LookVector * 2 + c.CFrame.UpVector * -1.4
				d.line.Length = (o - head.Position).Magnitude
				d.line.CFrame = CFrame.new((o + head.Position) / 2, head.Position)
			end
		end
	end
end

Run.RenderStepped:Connect(function()
	if not E.on then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character and not (E.team and plr.Team == Player.Team) then
			local h = plr.Character:FindFirstChildOfClass("Humanoid")
			if h and h.Health > 0 then buildEsp(plr.Character, plr) end
		end
	end
	if E.fruit then
		for _, o in ipairs(workspace:GetChildren()) do
			if o.Name:find("Fruit") and not o:FindFirstChildOfClass("Humanoid") then buildEsp(o, nil) end
		end
	end
	tickEsp()
end)

--========== AIMBOT ==========
local A = { on = false, fov = 150, smooth = 0.22, predict = false, team = true }
local ring = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(A.fov * 2, A.fov * 2), BackgroundTransparency = 1, Visible = false,
	ZIndex = 10,
}, Gui)
corner(ring, 9999)
stroke(ring, C.violet, 1, 0.5)

Run.RenderStepped:Connect(function()
	if not A.on then return end
	local c = cam()
	if not c or not root() then return end
	local mid = c.ViewportSize / 2
	local best, bd
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			local h = plr.Character:FindFirstChildOfClass("Humanoid")
			local hd = plr.Character:FindFirstChild("Head")
			if h and hd and h.Health > 0 and not (A.team and plr.Team == Player.Team) then
				local sp, vis = c:WorldToViewportPoint(hd.Position)
				if vis then
					local dist = (Vector2.new(sp.X, sp.Y) - mid).Magnitude
					if dist < A.fov and (not bd or dist < bd) then
						best, bd = hd, dist
					end
				end
			end
		end
	end
	if best then
		local tp = best.Position
		if A.predict then tp = tp + best.AssemblyLinearVelocity * 0.14 end
		c.CFrame = c.CFrame:Lerp(CFrame.new(c.CFrame.Position, tp), A.smooth)
	end
end)

--========== VOO / NOCLIP ==========
local flyBV, flyConn, upHeld, downHeld, lockY
local function setFly(on)
	S.fly = on
	local r, h = root(), hum()
	if flyConn then flyConn:Disconnect(); flyConn = nil end
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if not on then
		if h then h.PlatformStand = false end
		lockY = nil
		return
	end
	if not r then
		S.fly = false
		return Notify("sem personagem", "bad")
	end
	if h then h.PlatformStand = true end
	lockY = S.flyLock and r.Position.Y or nil
	flyBV = new("BodyVelocity", { MaxForce = Vector3.new(1e5, 1e5, 1e5), P = 8000, Velocity = Vector3.zero }, r)
	flyConn = Run.RenderStepped:Connect(function()
		local c = cam()
		local cc = chr()
		local rr = cc and cc:FindFirstChild("HumanoidRootPart")
		if not rr or not c or not flyBV or not flyBV.Parent then return end
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += c.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= c.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= c.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += c.CFrame.RightVector end
		local v = 0
		if UIS:IsKeyDown(Enum.KeyCode.Space) or upHeld then v += 1 end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.C) or downHeld then v -= 1 end
		local sp = S.flyH
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then sp *= 2 end
		local flat = Vector3.new(dir.X, 0, dir.Z)
		if flat.Magnitude > 0 then flat = flat.Unit * sp end
		local target = Vector3.new(flat.X, v * S.flyV, flat.Z)
		if S.flyLock and lockY then target = Vector3.new(target.X, (lockY - rr.Position.Y) * 6, target.Z) end
		flyBV.Velocity = flyBV.Velocity:Lerp(target, math.clamp(S.flyAcc, 0.05, 1))
	end)
end

local noclipConn
local function setNoclip(on)
	S.noclip = on
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

--========== FARM / ATAQUE ==========
local function npcList()
	local list = {}
	for _, m in ipairs(workspace:GetDescendants()) do
		if m:IsA("Model") and not m:IsDescendantOf(Players) then
			local h = m:FindFirstChildOfClass("Humanoid")
			local r = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
			if h and r and h.Health > 0 and m ~= chr() then
				local pl = Players:GetPlayerFromCharacter(m)
				if not pl then table.insert(list, { m, r }) end
			end
		end
	end
	return list
end

Run.Heartbeat:Connect(function()
	if not S.farm then return end
	local r = root()
	local h = hum()
	if not r or not h then return end
	local best, bd
	for _, e in ipairs(npcList()) do
		local d = (e[2].Position - r.Position).Magnitude
		if d < S.farmRange and (not bd or d < bd) then best, bd = e, d end
	end
	if not best then return end
	if bd > 8 then
		r.CFrame = CFrame.new(r.Position, Vector3.new(best[2].Position.X, r.Position.Y, best[2].Position.Z))
		r.CFrame = r.CFrame + r.CFrame.LookVector * math.min(bd - 6, 14)
	else
		local tool = chr() and chr():FindFirstChildOfClass("Tool")
		if tool then pcall(function() tool:Activate() end) end
	end
end)

Run.Heartbeat:Connect(function()
	if not S.fastAtk then return end
	local c = chr()
	local tool = c and c:FindFirstChildOfClass("Tool")
	if tool then pcall(function() tool:Activate() end) end
end)

--========== FULLBRIGHT ==========
local lightOld
local function setBright(on)
	if on then
		if not lightOld then
			lightOld = {
				Ambient = Lighting.Ambient, Outdoor = Lighting.OutdoorAmbient,
				Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
				FogEnd = Lighting.FogEnd, Global = Lighting.GlobalShadows,
			}
		end
		Lighting.Ambient = Color3.fromRGB(160, 160, 170)
		Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 170)
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e6
		Lighting.GlobalShadows = false
	elseif lightOld then
		Lighting.Ambient = lightOld.Ambient
		Lighting.OutdoorAmbient = lightOld.Outdoor
		Lighting.Brightness = lightOld.Brightness
		Lighting.ClockTime = lightOld.ClockTime
		Lighting.FogEnd = lightOld.FogEnd
		Lighting.GlobalShadows = lightOld.Global
		lightOld = nil
	end
end

--========== ANTI AFK ==========
local antiAfk = false
UIS.WindowFocused:Connect(function()
	if not antiAfk then return end
	local vu = game:GetService("VirtualUser")
	pcall(function()
		vu:CaptureController()
		vu:ClickButton1(Vector2.new(50, 50))
	end)
end)

--========== PÁGINAS ==========
local tpPage = newPage("Teleport")
for _, g in ipairs(PLACES) do
	Section(tpPage, g[1])
	local gr = Grid(tpPage, 2)
	for _, e in ipairs(g[2]) do GridButton(gr, e[1], nil, function() TP(e[2], e[1]) end) end
end
Section(tpPage, "Jogadores")
local pGrid = Grid(tpPage, 2)
local function refreshPlayers()
	for _, c in ipairs(pGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			GridButton(pGrid, plr.Name, nil, function()
				local cc = plr.Character
				local rr = cc and cc:FindFirstChild("HumanoidRootPart")
				if rr then TP(rr.Position, plr.Name) end
			end)
		end
	end
end
refreshPlayers()
Players.PlayerAdded:Connect(function() task.wait(0.4); refreshPlayers() end)
Players.PlayerRemoving:Connect(function() task.wait(0.4); refreshPlayers() end)
Button(tpPage, "Trazer jogadores até mim", function()
	local r = root()
	if not r then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player and plr.Character then
			local rr = plr.Character:FindFirstChild("HumanoidRootPart")
			if rr then rr.CFrame = r.CFrame * CFrame.new(0, 0, -4) end
		end
	end
	Notify("trouxe todos", "good")
end)

local spPage = newPage("Spawn")
Section(spPage, "Modo")
local mrow = new("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1 }, spPage)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5) }, mrow)
local mbtns = {}
for _, m in ipairs({ { "physical", "físico" }, { "real", "servidor" } }) do
	local b = new("TextButton", {
		Text = m[2], Font = Enum.Font.GothamSemibold, TextSize = 10, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.new(0.5, -3, 1, 0), AutoButtonColor = false,
		BorderSizePixel = 0,
	}, mrow)
	corner(b, 6)
	mbtns[m[1]] = b
	b.MouseButton1Click:Connect(function()
		mode = m[1]
		for k, bb in pairs(mbtns) do
			bb.TextColor3 = k == mode and C.violet or C.dim
			bb.BackgroundColor3 = k == mode and C.hover or C.card
		end
	end)
end
mbtns.physical.TextColor3 = C.violet
mbtns.physical.BackgroundColor3 = C.hover

local allF = {}
for _, g in ipairs(GROUPS) do
	for _, n in ipairs(g[2]) do table.insert(allF, n) end
end
Section(spPage, "Mapa de spawn")
local search = Input(spPage, "filtrar fruta", function() end)
local nodes = {}
local function rebuild(filter)
	for _, n in ipairs(nodes) do n:Destroy() end
	nodes = {}
	for _, g in ipairs(GROUPS) do
		local shown = {}
		for _, n in ipairs(g[2]) do
			if filter == "" or n:lower():find(filter:lower(), 1, true) then table.insert(shown, n) end
		end
		if #shown > 0 then
			local head = new("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1 }, spPage)
			table.insert(nodes, head)
			local b = new("TextButton", {
				Text = g[1] .. "  ·  " .. #shown, Font = Enum.Font.GothamSemibold, TextSize = 10,
				TextColor3 = C.violet, BackgroundColor3 = C.card, Size = UDim2.fromScale(1, 1),
				AutoButtonColor = false, BorderSizePixel = 0,
			}, head)
			corner(b, 6)
			b.MouseButton1Click:Connect(function() groupSpawn(shown, g[1]) end)
			local gr = Grid(spPage, 3, 25)
			table.insert(nodes, gr)
			for _, n in ipairs(shown) do GridButton(gr, n, nil, function() oneFruit(n) end) end
		end
	end
end
rebuild("")
search:GetPropertyChangedSignal("Text"):Connect(function() rebuild(search.Text) end)

Section(spPage, "Ações")
Button(spPage, "Spawnar todas em círculo", function() groupSpawn(allF, "todas") end)
Button(spPage, "10 aleatórias", function()
	local p = {}
	for _ = 1, 10 do table.insert(p, allF[math.random(1, #allF)]) end
	groupSpawn(p, "aleatórias")
end)
Button(spPage, "Limpar geradas", function()
	for _, f in ipairs(spawned) do if f.Parent then f:Destroy() end end
	spawned = {}
	Notify("cena limpa", "good")
	log("frutas limpas", "ok")
end)
Input(spPage, "fruta nova / personalizada", function(t) oneFruit(t) end)

local plPage = newPage("Player")
Section(plPage, "Velocidade")
Slider(plPage, "WalkSpeed", 16, 400, 40, function(v) S.speed = v end)
Section(plPage, "Pulo")
local jT
jT = Toggle(plPage, "Aplicar altura", false, function(v)
	S.jumpOn = v
	if not v then
		local h = hum()
		if h then
			if h.UseJumpPower then h.JumpPower = 50 else h.JumpHeight = 15 end
		end
	end
end)
Slider(plPage, "Altura (studs)", 5, 400, 50, function(v) S.jumpH = v end)
Slider(plPage, "Pulos por salto", 1, 10, 1, function(v)
	S.multi = v
	jumpN = v - 1
end)
Button(plPage, "Ativar pulo agora", function()
	S.jumpOn = true
	jT.set(true)
	applyStats()
	log("pulo " .. S.jumpH .. " studs", "ok")
end)
Section(plPage, "Voo")
local fT
fT = Toggle(plPage, "Voo", false, function(v)
	setFly(v)
	flyPad.Visible = v
	log(v and "voo on" or "voo off", "ok")
end)
Slider(plPage, "Velocidade horizontal", 10, 400, 70, function(v) S.flyH = v end)
Slider(plPage, "Velocidade vertical", 10, 400, 60, function(v) S.flyV = v end)
Slider(plPage, "Suavidade", 5, 100, 35, function(v) S.flyAcc = v / 100 end)
Toggle(plPage, "Travar altitude", false, function(v) S.flyLock = v end)
Button(plPage, "Subir 100", function()
	local r = root()
	if r then r.CFrame = r.CFrame + Vector3.new(0, 100, 0) end
end)
Button(plPage, "Descer 100", function()
	local r = root()
	if r then r.CFrame = r.CFrame - Vector3.new(0, 100, 0) end
end)
Section(plPage, "Movimento")
Toggle(plPage, "Noclip", false, function(v) setNoclip(v) end)
Toggle(plPage, "Pulo infinito", false, function(v) S.infJump = v end)
Toggle(plPage, "God Mode", false, function(v) S.god = v; applyStats() end)
Button(plPage, "Curar", function()
	local h = hum()
	if h then h.Health = h.MaxHealth end
end)
Button(plPage, "Resetar personagem", function()
	local h = hum()
	if h then h.Health = 0 end
end)

local cbPage = newPage("Combat")
Section(cbPage, "Aimbot")
Toggle(cbPage, "Aimbot", false, function(v)
	A.on = v
	ring.Visible = v
end)
Slider(cbPage, "FOV", 40, 600, 150, function(v)
	A.fov = v
	ring.Size = UDim2.fromOffset(v * 2, v * 2)
end)
Slider(cbPage, "Suavidade", 5, 100, 22, function(v) A.smooth = v / 100 end)
Toggle(cbPage, "Predição", false, function(v) A.predict = v end)
Toggle(cbPage, "Ignorar time", true, function(v) A.team = v end)
Section(cbPage, "Farm")
Toggle(cbPage, "Auto farm (NPC)", false, function(v)
	S.farm = v
	log(v and "farm on" or "farm off", "ok")
end)
Slider(cbPage, "Alcance", 20, 400, 120, function(v) S.farmRange = v end)
Toggle(cbPage, "Auto ataque", false, function(v) S.fastAtk = v end)
Toggle(cbPage, "Auto haki", false, function(v)
	S.autoHaki = v
	if v then
		invoke("BuyHaki", "Buso")
		log("haki solicitado", "ok")
	end
end)

local vsPage = newPage("Visual")
Section(vsPage, "ESP")
Toggle(vsPage, "ESP ativo", false, function(v)
	E.on = v
	if not v then clearEsp() end
	log(v and "esp on" or "esp off", "ok")
end)
Toggle(vsPage, "Caixa", true, function(v) E.box = v; clearEsp() end)
Toggle(vsPage, "Nome + distância", true, function(v) E.name = v; clearEsp() end)
Toggle(vsPage, "Vida", true, function(v) E.hp = v; clearEsp() end)
Toggle(vsPage, "Esqueleto", true, function(v) E.skel = v; clearEsp() end)
Toggle(vsPage, "Linha", true, function(v) E.line = v; clearEsp() end)
Toggle(vsPage, "Ignorar time", false, function(v) E.team = v; clearEsp() end)
Section(vsPage, "Objetos")
Toggle(vsPage, "ESP de frutas", false, function(v) E.fruit = v; clearEsp() end)
Section(vsPage, "Cena")
Toggle(vsPage, "Full bright", false, function(v) setBright(v) end)
Toggle(vsPage, "Anti AFK", false, function(v) antiAfk = v end)

local stPage = newPage("Status")
Section(stPage, "Servidor")
local info = Card(stPage, 62)
local iLbl = new("TextLabel", {
	Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.dim,
	BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, -10), Position = UDim2.fromOffset(8, 5),
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
}, info)
Section(stPage, "Spawn")
local countersCard = Card(stPage, 46)
local cLbl = new("TextLabel", {
	Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.dim,
	BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, -10), Position = UDim2.fromOffset(8, 5),
	TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
}, countersCard)
Section(stPage, "Log")
local logHolder = new("Frame", { Size = UDim2.new(1, 0, 0, 250), BackgroundColor3 = C.card }, stPage)
corner(logHolder, 8)
pad(logHolder, 6, 6, 6, 8)
logPage = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, logHolder)
new("UIListLayout", { Padding = UDim.new(0, 1) }, logPage)

task.spawn(function()
	while Gui.Parent do
		local ping = 0
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		local lvl, beli = "-", "-"
		local data = Player:FindFirstChild("Data")
		if data then
			local l = data:FindFirstChild("Level")
			local b = data:FindFirstChild("Beli")
			if l then lvl = tostring(l.Value) end
			if b then beli = tostring(b.Value) end
		end
		iLbl.Text = string.format(
			"players  %d\nping     %d ms\nlevel    %s\nbeli     %s\nuptime   %ds",
			#Players:GetPlayers(), ping, lvl, beli, math.floor(os.clock() - startedAt)
		)
		cLbl.Text = string.format(
			"ok       %d\nfalhas   %d\ngrupos   %d\ngrupos falhos %d\ngeradas  %d",
			counters.spawnOk, counters.spawnFail, counters.groups, counters.groupsFail, #spawned
		)
		task.wait(1)
	end
end)

local adPage = newPage("Admin")
Section(adPage, "Ilhas de admin")
local aGrid = Grid(adPage, 2)
for _, e in ipairs(PLACES[4][2]) do GridButton(aGrid, e[1], C.violet, function() TP(e[2], e[1]) end) end
Section(adPage, "Haki / time")
Button(adPage, "Buso", function() invoke("BuyHaki", "Buso"); log("buso", "ok") end)
Button(adPage, "Kenbunshoku", function() invoke("BuyHaki", "Ken"); log("ken", "ok") end)
Button(adPage, "Geppo", function() invoke("BuyHaki", "Geppo"); log("geppo", "ok") end)
Button(adPage, "Soru", function() invoke("BuyHaki", "Soru"); log("soru", "ok") end)
Button(adPage, "Time Pirata", function() invoke("SetTeam", "Pirates"); log("time pirates", "ok") end)
Button(adPage, "Time Marinha", function() invoke("SetTeam", "Marines"); log("time marines", "ok") end)
Section(adPage, "Items")
local ITEMS = {
	"Dark Blade", "Cursed Dual Katana", "Saber", "Bisento", "Dragon Trident",
	"Hallow Scythe", "Saddi", "Kabucha", "Serpent Bow", "Bazooka", "Cannon",
	"Flintlock", "Musket", "Slingshot", "Acidum Rifle", "Bizarre Rifle",
	"Katana", "Cutlass", "Trident", "Superhuman", "Godhuman", "Sanguine Art",
}
local function giveTool(name)
	local t = findTmpl(name)
	if t and t:IsA("Tool") then
		local bp = Player:FindFirstChild("Backpack")
		if bp then
			t:Clone().Parent = bp
			log("item " .. name, "ok")
			return Notify("item: " .. name, "good")
		end
	end
	local good = invoke("BuyItem", name)
	log((good and "servidor: " or "não achado: ") .. name, good and "ok" or "bad")
	Notify(good and ("servidor: " .. name) or ("não achado: " .. name), good and "good" or "bad")
end
local iSearch = Input(adPage, "filtrar item", function() end)
local iGrid = Grid(adPage, 2)
local function fillItems(f)
	for _, c in ipairs(iGrid:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, n in ipairs(ITEMS) do
		if f == "" or n:lower():find(f:lower(), 1, true) then
			GridButton(iGrid, n, nil, function() giveTool(n) end)
		end
	end
end
fillItems("")
iSearch:GetPropertyChangedSignal("Text"):Connect(function() fillItems(iSearch.Text) end)
Input(adPage, "item personalizado", function(t) giveTool(t) end)
Section(adPage, "Sessão")
Button(adPage, "Rejoin", function()
	pcall(function() Teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
end)
Button(adPage, "Server hop", function()
	task.spawn(function()
		local okH, body = pcall(function()
			return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
		end)
		if not okH or not body then return Notify("hop falhou", "bad") end
		local okD, data = pcall(function() return Http:JSONDecode(body) end)
		if not okD or not data or not data.data then return Notify("hop falhou", "bad") end
		local pick
		for _, s in ipairs(data.data) do
			if s.playing < s.maxPlayers and s.id ~= game.JobId then
				pick = s
				break
			end
		end
		if not pick then return Notify("nenhum servidor", "bad") end
		pcall(function() Teleport:TeleportToPlaceInstance(game.PlaceId, pick.id, Player) end)
		log("hop → " .. pick.id, "ok")
	end)
end)
Button(adPage, "Copiar posição", function()
	local r = root()
	if not r then return end
	local p = r.Position
	local txt = string.format("Vector3.new(%d, %d, %d)", p.X, p.Y, p.Z)
	if setclipboard then pcall(setclipboard, txt) end
	Notify(txt)
end)

--========== PAD DE VOO ==========
local flyPad = new("Frame", {
	Size = UDim2.fromOffset(46, 104), Position = UDim2.new(1, -62, 0.5, 40),
	BackgroundTransparency = 1, Visible = false, ZIndex = 25,
}, Gui)
new("UIListLayout", { Padding = UDim.new(0, 6) }, flyPad)
local function padBtn(txt, order, setter)
	local b = new("TextButton", {
		Text = txt, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.violet,
		BackgroundColor3 = C.card, BackgroundTransparency = 0.12,
		Size = UDim2.new(1, 0, 0, 46), LayoutOrder = order, AutoButtonColor = false,
		BorderSizePixel = 0,
	}, flyPad)
	corner(b, 10)
	stroke(b, C.violet, 1, 0.4)
	b.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			setter(true)
		end
	end)
	b.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			setter(false)
		end
	end)
end
padBtn("+", 1, function(v) upHeld = v end)
padBtn("−", 2, function(v) downHeld = v end)

--========== ABRIR ==========
local function open(on)
	if on then
		Win.Visible = true
		Win.Size = UDim2.fromOffset(WW, math.floor(HH * 0.86))
		Tween:Create(Win, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(WW, HH) }):Play()
	else
		Win.Visible = false
	end
end
Orb.MouseButton1Click:Connect(function()
	if Win.Visible then
		Win.Visible = false
	else
		open(true)
	end
end)
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		Win.Visible = not Win.Visible
	end
end)

showTab("Teleport")
open(true)
probeLbl.Text = "ok"
probeLbl.TextColor3 = C.good
task.delay(2.2, function()
	Tween:Create(probe, TweenInfo.new(0.3), { BackgroundTransparency = 1, Size = UDim2.fromOffset(150, 26) }):Play()
	Tween:Create(probeLbl, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
end)

log("painel iniciado", "ok")
setPill("pronto", "ok")
Notify("JDEV v4 online", "good")

end)

if not ok then
	fail(err)
end
