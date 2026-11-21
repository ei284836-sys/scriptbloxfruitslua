--=====================================================================
--  JDEV v5  •  DELTA / MOBILE  •  BLOX FRUITS
--=====================================================================
task.wait(1)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local Tween = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local C = {
	bg = Color3.fromRGB(9, 9, 14), panel = Color3.fromRGB(14, 14, 21),
	card = Color3.fromRGB(20, 20, 29), hover = Color3.fromRGB(31, 30, 44),
	line = Color3.fromRGB(38, 36, 54), text = Color3.fromRGB(233, 231, 245),
	dim = Color3.fromRGB(126, 122, 150), violet = Color3.fromRGB(146, 108, 255),
	blue = Color3.fromRGB(86, 156, 255), cyan = Color3.fromRGB(120, 220, 255),
	good = Color3.fromRGB(92, 224, 148), bad = Color3.fromRGB(255, 96, 110),
}

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
local function pad(o, a, b, c, d)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, a or 0), PaddingRight = UDim.new(0, b or 0),
		PaddingBottom = UDim.new(0, c or 0), PaddingLeft = UDim.new(0, d or 0),
	}, o)
end
local function cam() return workspace.CurrentCamera end
local function scr()
	local c = workspace.CurrentCamera
	return c and c.ViewportSize or Vector2.new(1280, 720)
end

local Player = Players.LocalPlayer
local tries = 0
while not Player and tries < 40 do
	task.wait(0.1)
	Player = Players.LocalPlayer or Players:GetPlayers()[1]
	tries += 1
end
if not Player then return warn("[JDEV] sem player") end
local PGui = Player:FindFirstChildOfClass("PlayerGui") or Player:WaitForChild("PlayerGui", 10)
if not PGui then return warn("[JDEV] rode como LocalScript") end
local prev = PGui:FindFirstChild("JDEV")
if prev then prev:Destroy() end

local R = { Pages = {}, Tabs = {}, Log = {}, Cnt = { ok = 0, fail = 0, grp = 0, grpFail = 0 }, T0 = os.clock(), Spawned = {} }

--==================== GUI =============================================
local Gui = new("ScreenGui", {
	Name = "JDEV", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PGui)

local probe = new("TextLabel", {
	Size = UDim2.fromOffset(140, 24), Position = UDim2.fromOffset(12, 12),
	BackgroundColor3 = C.card, Text = "carregando…", Font = Enum.Font.GothamMedium,
	TextSize = 12, TextColor3 = C.dim, BorderSizePixel = 0, ZIndex = 99,
}, Gui)
corner(probe, 6)

local errBox = new("TextLabel", {
	Size = UDim2.new(1, -24, 0, 0), Position = UDim2.fromOffset(12, 44),
	BackgroundColor3 = Color3.fromRGB(58, 12, 20), TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.Code, TextSize = 11, TextWrapped = true,
	AutomaticSize = Enum.AutomaticSize.Y, TextXAlignment = Enum.TextXAlignment.Left,
	Visible = false, ZIndex = 100, BorderSizePixel = 0,
}, Gui)
corner(errBox, 6)
pad(errBox, 7, 8, 7, 8)

local function fail(m)
	errBox.Text = "JDEV · ERRO\n" .. tostring(m)
	errBox.Visible = true
	probe.Text = "erro"
	probe.TextColor3 = C.bad
	warn("[JDEV] " .. tostring(m))
end

task.delay(8, function()
	if probe.Text == "carregando…" then
		probe.Text = "travou"
		probe.TextColor3 = C.bad
	end
end)

--==================== EMBLEMA =========================================
local function emblem(parent, size)
	local b = new("Frame", {
		Size = UDim2.fromOffset(size, size), BackgroundColor3 = Color3.fromRGB(8, 7, 14),
		BorderSizePixel = 0, ClipsDescendants = true,
	}, parent)
	corner(b, math.floor(size * 0.28))
	local ring = new("Frame", {
		Size = UDim2.fromScale(0.88, 0.88), Position = UDim2.fromScale(0.06, 0.06),
		BackgroundTransparency = 1,
	}, b)
	corner(ring, 999)
	pcall(function() stroke(ring, C.violet, 1, 0.1) end)
	local moon = new("Frame", {
		Size = UDim2.fromScale(0.5, 0.5), Position = UDim2.fromScale(0.24, 0.26),
		BackgroundColor3 = Color3.fromRGB(130, 195, 255), BorderSizePixel = 0,
	}, b)
	corner(moon, 999)
	local bite = new("Frame", {
		Size = UDim2.fromScale(0.46, 0.46), Position = UDim2.fromScale(0.38, 0.22),
		BackgroundColor3 = Color3.fromRGB(8, 7, 14), BorderSizePixel = 0,
	}, b)
	corner(bite, 999)
	local a = new("Frame", {
		Size = UDim2.fromScale(0.54, 0.07), Position = UDim2.fromScale(0.23, 0.465),
		BackgroundColor3 = Color3.fromRGB(226, 212, 255), BorderSizePixel = 0,
	}, b)
	corner(a, 999)
	local bb = new("Frame", {
		Size = UDim2.fromScale(0.07, 0.54), Position = UDim2.fromScale(0.465, 0.23),
		BackgroundColor3 = Color3.fromRGB(226, 212, 255), BorderSizePixel = 0,
	}, b)
	corner(bb, 999)
	local core = new("Frame", {
		Size = UDim2.fromScale(0.13, 0.13), Position = UDim2.fromScale(0.435, 0.435),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0,
	}, b)
	corner(core, 999)
	local fl = new("Frame", {
		Size = UDim2.fromScale(0.07, 0.1), Position = UDim2.fromScale(0.465, 0.06),
		Rotation = 45, BackgroundColor3 = C.violet, BorderSizePixel = 0,
	}, b)
	corner(fl, 2)
	return b
end

--==================== DRAG ============================================
local function drag(frame, handle)
	local on, cur, org, st
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			on, org, st = true, frame.Position, i.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then on = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			cur = i
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if i ~= cur or not on then return end
		local d = i.Position - st
		local s = scr()
		frame.Position = UDim2.fromOffset(
			math.clamp(org.X.Offset + d.X, 0, s.X - frame.AbsoluteSize.X),
			math.clamp(org.Y.Offset + d.Y, 0, s.Y - frame.AbsoluteSize.Y)
		)
	end)
end

--==================== LOG / PILL ======================================
local pillTxt, pillDot
local function setPill(t, kind)
	if not pillTxt then return end
	pillTxt.Text = t
	local col = C.dim
	if kind == "ok" then col = C.good elseif kind == "bad" then col = C.bad elseif kind == "busy" then col = C.cyan end
	pillTxt.TextColor3 = col
	pillDot.BackgroundColor3 = col
end

local function log(t, kind)
	local up = math.floor(os.clock() - R.T0)
	table.insert(R.Log, { string.format("%02d:%02d", math.floor(up / 60), up % 60), tostring(t), kind })
	if #R.Log > 60 then table.remove(R.Log, 1) end
	if not R.LogBox then return end
	for _, c in ipairs(R.LogBox:GetChildren()) do
		if c:IsA("TextLabel") then c:Destroy() end
	end
	for i = #R.Log, 1, -1 do
		local l = R.Log[i]
		local col = C.dim
		if l[3] == "ok" then col = C.good elseif l[3] == "bad" then col = C.bad end
		new("TextLabel", {
			Text = l[1] .. "  " .. l[2], Font = Enum.Font.Code, TextSize = 10, TextColor3 = col,
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 13),
			TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		}, R.LogBox)
	end
end

local toastN = 0
local function note(t, kind)
	if not R.Toasts then return end
	toastN += 1
	local col = C.violet
	if kind == "bad" then col = C.bad elseif kind == "good" then col = C.good end
	local card = new("Frame", {
		Size = UDim2.fromOffset(210, 28), BackgroundColor3 = C.card,
		LayoutOrder = toastN, ZIndex = 60,
	}, R.Toasts)
	corner(card, 6)
	stroke(card, col, 1, 0.3)
	new("TextLabel", {
		Text = tostring(t), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -14, 1, 0), Position = UDim2.fromOffset(8, 0),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, card)
	task.delay(2.2, function()
		Tween:Create(card, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		task.wait(0.22)
		card:Destroy()
	end)
end

--==================== COMPONENTES =====================================
local function card(parent, h)
	local f = new("Frame", { Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = C.card, BorderSizePixel = 0 }, parent)
	corner(f, 8)
	stroke(f, C.line, 1, 0.7)
	return f
end

local function sec(parent, t)
	local f = new("Frame", { Size = UDim2.new(1, 0, 0, 17), BackgroundTransparency = 1 }, parent)
	new("TextLabel", {
		Text = string.upper(t), Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Left,
	}, f)
end

local function btn(parent, t, cb, accent)
	local b = new("TextButton", {
		Text = "", Size = UDim2.new(1, 0, 0, 31), BackgroundColor3 = C.card,
		AutoButtonColor = false, BorderSizePixel = 0,
	}, parent)
	corner(b, 7)
	stroke(b, C.line, 1, 0.7)
	new("TextLabel", {
		Text = t, Font = Enum.Font.GothamMedium, TextSize = 12,
		TextColor3 = accent and C.violet or C.text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -18, 1, 0), Position = UDim2.fromOffset(9, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, b)
	b.MouseEnter:Connect(function() b.BackgroundColor3 = C.hover end)
	b.MouseLeave:Connect(function() b.BackgroundColor3 = C.card end)
	b.MouseButton1Click:Connect(function()
		local o, e = pcall(cb)
		if not o then note(e, "bad") end
	end)
	return b
end

local function gbtn(grid, t, col, cb)
	local b = new("TextButton", {
		Text = t, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = col or C.text,
		BackgroundColor3 = C.card, AutoButtonColor = false, BorderSizePixel = 0,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, grid)
	corner(b, 6)
	b.MouseButton1Click:Connect(function()
		local o, e = pcall(cb)
		if not o then note(e, "bad") end
	end)
	return b
end

local function grid(parent, cols, h)
	local g = new("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }, parent)
	new("UIGridLayout", {
		CellSize = UDim2.new(1 / cols, -3, 0, h or 25), CellPadding = UDim2.new(0, 3, 0, 3),
	}, g)
	return g
end

local function tog(parent, t, def, cb)
	local on = def or false
	local row = card(parent, 31)
	new("TextLabel", {
		Text = t, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -52, 1, 0), Position = UDim2.fromOffset(9, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, row)
	local track = new("Frame", {
		Size = UDim2.fromOffset(28, 15), Position = UDim2.new(1, -37, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0,
	}, row)
	corner(track, 8)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(11, 11), Position = UDim2.new(0, 2, 0.5, -5),
		BackgroundColor3 = C.text, BorderSizePixel = 0,
	}, track)
	corner(knob, 6)
	local function apply(v)
		on = v
		track.BackgroundColor3 = v and C.violet or Color3.fromRGB(42, 41, 56)
		knob.Position = v and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		local o, e = pcall(cb, v)
		if not o then note(e, "bad") end
	end
	hit.MouseButton1Click:Connect(function() apply(not on) end)
	return { set = apply, get = function() return on end }
end

local function sld(parent, t, min, max, def, cb)
	local row = card(parent, 44)
	local lbl = new("TextLabel", {
		Text = t .. "  " .. tostring(def), Font = Enum.Font.GothamMedium, TextSize = 11,
		TextColor3 = C.text, BackgroundTransparency = 1, Size = UDim2.new(1, -18, 0, 20),
		Position = UDim2.fromOffset(9, 3), TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local track = new("Frame", {
		Size = UDim2.new(1, -18, 0, 4), Position = UDim2.fromOffset(9, 30),
		BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0,
	}, row)
	corner(track, 2)
	local fill = new("Frame", {
		Size = UDim2.new((def - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = C.violet, BorderSizePixel = 0,
	}, track)
	corner(fill, 2)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(9, 9), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0), BackgroundColor3 = C.text,
		BorderSizePixel = 0,
	}, track)
	corner(knob, 5)
	local held = false
	local function set(a)
		a = math.clamp(a, 0, 1)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, 0, 0.5, 0)
		local v = math.floor(min + (max - min) * a + 0.5)
		lbl.Text = t .. "  " .. tostring(v)
		pcall(cb, v)
	end
	local function at(x) set((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)) end
	track.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			held = true
			at(i.Position.X)
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then held = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if held then at(i.Position.X) end
	end)
	return { set = function(v) set((v - min) / (max - min)) end }
end

local function inp(parent, ph, cb)
	local b = new("TextBox", {
		Size = UDim2.new(1, 0, 0, 29), BackgroundColor3 = C.card, Text = "",
		PlaceholderText = ph, PlaceholderColor3 = C.dim, Font = Enum.Font.GothamMedium,
		TextSize = 11, TextColor3 = C.text, ClearTextOnFocus = false, BorderSizePixel = 0,
	}, parent)
	corner(b, 7)
	stroke(b, C.line, 1, 0.7)
	pad(b, 0, 8, 0, 8)
	b.FocusLost:Connect(function(enter)
		if enter and b.Text ~= "" then
			local o, e = pcall(cb, b.Text)
			if not o then note(e, "bad") end
			b.Text = ""
		end
	end)
	return b
end

local function page(name)
	local sc = new("ScrollingFrame", {
		Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.line,
		CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, R.Body)
	pad(sc, 9, 9, 14, 11)
	new("UIListLayout", { Padding = UDim.new(0, 5) }, sc)
	R.Pages[name] = sc
	return sc
end

local function show(name)
	for n, b in pairs(R.Tabs) do
		b.BackgroundColor3 = C.card
		b.TextColor3 = C.dim
		if R.Pages[n] then R.Pages[n].Visible = false end
	end
	if R.Tabs[name] then
		R.Tabs[name].BackgroundColor3 = C.hover
		R.Tabs[name].TextColor3 = C.violet
	end
	if R.Pages[name] then R.Pages[name].Visible = true end
end

--==================== ESTADO ==========================================
local S = {
	speed = 40, jH = 50, jOn = false, multi = 1, god = false, infJ = false,
	noclip = false, fly = false, flyH = 70, flyV = 60, lock = false, acc = 0.35,
	farm = false, range = 120, atk = false,
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
local function stats()
	local h = hum()
	if not h then return end
	h.WalkSpeed = S.speed
	if S.jOn then
		if h.UseJumpPower then
			h.JumpPower = math.clamp(math.sqrt(2 * grav() * S.jH), 50, 1000)
		else
			h.JumpHeight = S.jH
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
Run.Heartbeat:Connect(stats)

local jumpN = 0
local function doJump()
	local h, r = hum(), root()
	if not h or not r then return end
	h:ChangeState(Enum.HumanoidStateType.Jumping)
	local bv = new("BodyVelocity", {
		MaxForce = Vector3.new(0, 1e5, 0),
		Velocity = Vector3.new(r.AssemblyLinearVelocity.X, math.sqrt(2 * grav() * S.jH), r.AssemblyLinearVelocity.Z),
	}, r)
	task.delay(0.25, function() if bv.Parent then bv:Destroy() end end)
end
UIS.JumpRequest:Connect(function()
	if S.infJ then doJump() elseif S.multi > 1 and jumpN > 0 then
		jumpN -= 1
		doJump()
	end
end)
Player.CharacterAdded:Connect(function(c)
	task.wait(1)
	S.fly = false
	local h = c:WaitForChild("Humanoid", 8)
	if h then
		h.StateChanged:Connect(function(s)
			if s == Enum.HumanoidStateType.Landed then jumpN = S.multi - 1 end
		end)
	end
	stats()
end)

local function invoke(...)
	local rem = RS:FindFirstChild("Remotes")
	local c = rem and rem:FindFirstChild("CommF_")
	if not c then return false end
	local ok2 = pcall(function() c:InvokeServer(...) end)
	return ok2
end

--==================== TELEPORTE =======================================
local PLACES = {
	{ "Sea 1", { { "Fruit Dealer", Vector3.new(0, 5, 0) }, { "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Amazon Lily", Vector3.new(-3000, 5, 2500) }, { "Sky Island", Vector3.new(-7863, 5545, -378) } } },
	{ "Sea 2", { { "Colosseum", Vector3.new(-5000, 5, 0) }, { "Cursed Ship", Vector3.new(0, 5, -4000) },
		{ "Haunted Castle", Vector3.new(-3000, 5, -4000) }, { "Café", Vector3.new(-386, 74, -314) } } },
	{ "Sea 3", { { "Egghead", Vector3.new(6000, 5, 6000) }, { "Mansion", Vector3.new(6000, 5, -6000) },
		{ "Hydra", Vector3.new(-8000, 5, 0) }, { "Great Tree", Vector3.new(-1055, 328, -8916) } } },
	{ "Admin", { { "Admin Island", Vector3.new(0, 5, -10000) }, { "Admin Room", Vector3.new(0, 5, -12500) },
		{ "Dev Room", Vector3.new(0, 1000, -15000) }, { "Vazio", Vector3.new(0, 3000, 0) } } },
}

local function TP(pos, label)
	local r = root()
	if not r then
		note("sem personagem", "bad")
		return
	end
	setPill("teleport", "busy")
	if (r.Position - pos).Magnitude > 3000 then invoke("requestEntrance", pos); task.wait(0.45) end
	r.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
	log("TP → " .. (label or "?"), "ok")
	setPill("ok", "ok")
end

--==================== FRUTAS ==========================================
local GROUPS = {
	{ "Comum", { "Rocket", "Kilo", "Spin", "Blade", "Chop", "Spring", "Bomb", "Spike" } },
	{ "Rara", { "Diamond", "Revive", "Rubber", "Ghost", "Barrier", "Creation", "Door", "Portal",
		"Smoke", "Flame", "Ice", "Sand", "Dark", "Light", "Falcon", "Eagle" } },
	{ "Lendaria", { "Quake", "Love", "Spider", "String", "Sound", "Pain", "Paw", "Magma",
		"Lightning", "Rumble", "Blizzard", "Buddha", "Phoenix" } },
	{ "Mitica", { "Gravity", "Shadow", "Venom", "Spirit", "Soul", "Control", "Dough", "Gas",
		"Hellfire (Gas)", "Mammoth", "T-Rex", "Leopard", "Tiger", "Yeti", "Kitsune", "Dragon",
		"Dragon (Classic)", "Magnet", "Empyrean (Kitsune)", "Fiend (Yeti)", "Werewolf (Tiger)",
		"Celestial", "Oni", "Meme" } },
}
local ALIAS = {
	Rocket = "Kilo", Kilo = "Rocket", Blade = "Chop", Chop = "Blade", Portal = "Door",
	Door = "Portal", Lightning = "Rumble", Rumble = "Lightning", Spirit = "Soul", Soul = "Spirit",
	Spider = "String", String = "Spider", Tiger = "Leopard", Leopard = "Tiger",
	Creation = "Barrier", Barrier = "Creation", Eagle = "Falcon", Falcon = "Eagle",
}
local mode = "physical"
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
	if #R.Spawned > 120 then
		local o = table.remove(R.Spawned, 1)
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
	table.insert(R.Spawned, cl)
	return true
end

local function oneFruit(name)
	if mode == "real" then
		local good = invoke("BuyFruit", clean(name) .. "-" .. clean(name))
		invoke("LoadFruit", clean(name))
		log((good and "servidor: " or "falhou: ") .. name, good and "ok" or "bad")
		return note(good and ("servidor: " .. name) or ("falhou: " .. name), good and "good" or "bad")
	end
	if spawnAt(name, math.random() * 6.28, 9) then
		R.Cnt.ok += 1
		log("spawn " .. name, "ok")
		setPill("spawn ok", "ok")
		note("spawn " .. name, "good")
	else
		R.Cnt.fail += 1
		invoke("LoadFruit", clean(name))
		log("sem modelo " .. name, "bad")
		setPill("falhou", "bad")
		note("sem modelo " .. name, "bad")
	end
end

local function groupSpawn(list, label)
	if not root() then return note("sem personagem", "bad") end
	R.Cnt.grp += 1
	setPill("spawnando", "busy")
	local okN = 0
	for i, n in ipairs(list) do
		if spawnAt(n, (i / math.max(#list, 1)) * 6.28, 16) then okN += 1 end
	end
	local miss = #list - okN
	R.Cnt.ok += okN
	R.Cnt.fail += miss
	if miss > 0 then R.Cnt.grpFail += 1 end
	log((label or "grupo") .. " " .. okN .. "/" .. #list, miss == 0 and "ok" or "bad")
	setPill(okN .. "/" .. #list, miss == 0 and "ok" or "bad")
	note((label or "grupo") .. " " .. okN .. "/" .. #list, miss == 0 and "good" or "bad")
end

--==================== ESP =============================================
local E = { on = false, box = true, nm = true, hp = true, sk = true, ln = true, fr = false, team = false }
local ec = {}
local BONES = {
	{ "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" }, { "UpperTorso", "LeftUpperArm" },
	{ "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" }, { "UpperTorso", "RightUpperArm" },
	{ "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" }, { "LowerTorso", "LeftUpperLeg" },
	{ "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" }, { "LowerTorso", "RightUpperLeg" },
	{ "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
}

local function clearEsp()
	for t, d in pairs(ec) do
		if d.box then d.box:Destroy() end
		if d.bill then d.bill:Destroy() end
		if d.ln then d.ln:Destroy() end
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
	if (E.nm or E.hp) and head then
		d.bill = new("BillboardGui", {
			Size = UDim2.fromOffset(140, 42), StudsOffset = Vector3.new(0, 2.6, 0), AlwaysOnTop = true, Adornee = head,
		}, head)
		if E.nm then
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
	if E.sk and h then
		for i = 1, #BONES do
			d.lines[i] = new("LineHandleAdornment", {
				Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 6, Adornee = hrp, Length = 0,
			}, c)
		end
	end
	if E.ln and head then
		d.ln = new("LineHandleAdornment", { Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 4, Length = 0 }, c)
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
			local rt = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
			d.fill.Size = UDim2.new(rt, 0, 1, 0)
			d.fill.BackgroundColor3 = C.bad:Lerp(C.good, rt)
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
			if d.ln and head then
				local o = c.CFrame.Position + c.CFrame.LookVector * 2 + c.CFrame.UpVector * -1.4
				d.ln.Length = (o - head.Position).Magnitude
				d.ln.CFrame = CFrame.new((o + head.Position) / 2, head.Position)
			end
		end
	end
end

Run.RenderStepped:Connect(function()
	if not E.on then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player and p.Character and not (E.team and p.Team == Player.Team) then
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if h and h.Health > 0 then buildEsp(p.Character, p) end
		end
	end
	if E.fr then
		for _, o in ipairs(workspace:GetChildren()) do
			if o.Name:find("Fruit") and not o:FindFirstChildOfClass("Humanoid") then buildEsp(o, nil) end
		end
	end
	tickEsp()
end)

--==================== AIMBOT ==========================================
local A = { on = false, fov = 150, sm = 0.22, team = true }
Run.RenderStepped:Connect(function()
	if not A.on then return end
	local c = cam()
	if not c or not root() then return end
	local mid = c.ViewportSize / 2
	local best, bd
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player and p.Character and not (A.team and p.Team == Player.Team) then
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			local hd = p.Character:FindFirstChild("Head")
			if h and hd and h.Health > 0 then
				local sp, vis = c:WorldToViewportPoint(hd.Position)
				if vis then
					local dd = (Vector2.new(sp.X, sp.Y) - mid).Magnitude
					if dd < A.fov and (not bd or dd < bd) then
						best, bd = hd, dd
					end
				end
			end
		end
	end
	if best then
		c.CFrame = c.CFrame:Lerp(CFrame.new(c.CFrame.Position, best.Position), A.sm)
	end
end)

--==================== VOO / NOCLIP ====================================
local flyBV, flyConn, upH, downH, lockY
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
		return note("sem personagem", "bad")
	end
	if h then h.PlatformStand = true end
	lockY = S.lock and r.Position.Y or nil
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
		if UIS:IsKeyDown(Enum.KeyCode.Space) or upH then v += 1 end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or downH then v -= 1 end
		local sp = S.flyH
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then sp *= 2 end
		local flat = Vector3.new(dir.X, 0, dir.Z)
		if flat.Magnitude > 0 then flat = flat.Unit * sp end
		local target = Vector3.new(flat.X, v * S.flyV, flat.Z)
		if S.lock and lockY then target = Vector3.new(target.X, (lockY - rr.Position.Y) * 6, target.Z) end
		flyBV.Velocity = flyBV.Velocity:Lerp(target, math.clamp(S.acc, 0.05, 1))
	end)
end

local ncConn
local function setNoclip(on)
	S.noclip = on
	if ncConn then ncConn:Disconnect(); ncConn = nil end
	if not on then return end
	ncConn = Run.Stepped:Connect(function()
		local c = chr()
		if not c then return end
		for _, p in ipairs(c:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end)
end

--==================== FARM ============================================
Run.Heartbeat:Connect(function()
	if not S.farm then return end
	local r = root()
	if not r then return end
	local best, bd
	for _, m in ipairs(workspace:GetDescendants()) do
		if m:IsA("Model") and not Players:GetPlayerFromCharacter(m) then
			local h = m:FindFirstChildOfClass("Humanoid")
			local rr = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
			if h and rr and h.Health > 0 then
				local dd = (rr.Position - r.Position).Magnitude
				if dd < S.range and (not bd or dd < bd) then best, bd = rr, dd end
			end
		end
	end
	if not best then return end
	if bd > 9 then
		r.CFrame = CFrame.new(r.Position, Vector3.new(best.Position.X, r.Position.Y, best.Position.Z))
		r.CFrame = r.CFrame + r.CFrame.LookVector * math.min(bd - 6, 14)
	else
		local c = chr()
		local tool = c and c:FindFirstChildOfClass("Tool")
		if tool then pcall(function() tool:Activate() end) end
	end
end)

Run.Heartbeat:Connect(function()
	if not S.atk then return end
	local c = chr()
	local tool = c and c:FindFirstChildOfClass("Tool")
	if tool then pcall(function() tool:Activate() end) end
end)

local brightOn = false
local lightOld
local function setBright(on)
	brightOn = on
	if on then
		if not lightOld then
			lightOld = { Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd }
		end
		Lighting.Ambient = Color3.fromRGB(160, 160, 170)
		Lighting.OutdoorAmbient = Color3.fromRGB(160, 160, 170)
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.FogEnd = 1e6
	elseif lightOld then
		Lighting.Ambient = lightOld[1]
		Lighting.OutdoorAmbient = lightOld[2]
		Lighting.Brightness = lightOld[3]
		Lighting.ClockTime = lightOld[4]
		Lighting.FogEnd = lightOld[5]
		lightOld = nil
	end
end

local antiAfk = false
UIS.WindowFocused:Connect(function()
	if not antiAfk then return end
	local vu = game:GetService("VirtualUser")
	pcall(function()
		vu:CaptureController()
		vu:ClickButton1(Vector2.new(50, 50))
	end)
end)

--==================== BUILD ===========================================
local function build()
	-- toasts
	R.Toasts = new("Frame", {
		Size = UDim2.new(0, 220, 1, -20), Position = UDim2.new(1, -232, 0, 10), BackgroundTransparency = 1, ZIndex = 55,
	}, Gui)
	new("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder,
	}, R.Toasts)

	-- orbe
	local Orb = new("TextButton", {
		Text = "", Size = UDim2.fromOffset(50, 50), Position = UDim2.fromOffset(12, 12),
		BackgroundColor3 = C.panel, AutoButtonColor = false, ZIndex = 30,
	}, Gui)
	corner(Orb, 15)
	stroke(Orb, C.violet, 1, 0.15)
	emblem(Orb, 50)
	drag(Orb, Orb)

	local s = scr()
	local WW = math.clamp(s.X - 40, 296, 420)
	local HH = math.clamp(s.Y - 110, 320, 550)

	local Win = new("Frame", {
		Size = UDim2.fromOffset(WW, HH), Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.bg,
		ClipsDescendants = true, Visible = false, ZIndex = 20,
	}, Gui)
	corner(Win, 13)
	stroke(Win, C.line, 1, 0.1)
	R.Win = Win

	local Head = new("Frame", {
		Size = UDim2.new(1, -52, 0, 52), Position = UDim2.fromOffset(52, 0), BackgroundTransparency = 1,
	}, Win)
	drag(Win, Head)

	local lg = emblem(Head, 32)
	lg.Position = UDim2.fromOffset(0, 10)

	new("TextLabel", {
		Text = "JDEV", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.fromOffset(90, 16), Position = UDim2.fromOffset(40, 8),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, Head)
	new("TextLabel", {
		Text = "blox fruits · delta", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.fromOffset(120, 12), Position = UDim2.fromOffset(40, 24),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, Head)

	local pill = new("Frame", {
		Size = UDim2.fromOffset(92, 18), Position = UDim2.fromOffset(40, 36),
		BackgroundColor3 = C.card, BorderSizePixel = 0,
	}, Head)
	corner(pill, 9)
	pillDot = new("Frame", {
		Size = UDim2.fromOffset(5, 5), Position = UDim2.fromOffset(6, 6),
		BackgroundColor3 = C.dim, BorderSizePixel = 0,
	}, pill)
	corner(pillDot, 3)
	pillTxt = new("TextLabel", {
		Text = "idle", Font = Enum.Font.GothamMedium, TextSize = 9, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(15, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, pill)

	local Min = new("TextButton", {
		Text = "—", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.fromOffset(21, 21), Position = UDim2.new(1, -28, 0, 12),
		AutoButtonColor = false, BorderSizePixel = 0,
	}, Head)
	corner(Min, 6)
	Min.MouseButton1Click:Connect(function() Win.Visible = false end)

	-- rail
	local Rail = new("Frame", {
		Size = UDim2.new(0, 52, 1, -52), Position = UDim2.fromOffset(0, 52),
		BackgroundColor3 = C.panel, BorderSizePixel = 0,
	}, Win)
	pad(Rail, 5, 5, 5, 5)
	new("UIListLayout", { Padding = UDim.new(0, 3) }, Rail)

	R.Body = new("Frame", {
		Size = UDim2.new(1, -52, 1, -52), Position = UDim2.fromOffset(52, 52), BackgroundTransparency = 1,
	}, Win)

	for i, t in ipairs({
		{ "TP", "Teleport" }, { "SP", "Spawn" }, { "PL", "Player" }, { "CB", "Combat" },
		{ "VS", "Visual" }, { "ST", "Status" }, { "AD", "Admin" },
	}) do
		local b = new("TextButton", {
			Text = t[1], Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.dim,
			BackgroundColor3 = C.card, Size = UDim2.new(1, 0, 0, 28), AutoButtonColor = false,
			BorderSizePixel = 0, LayoutOrder = i,
		}, Rail)
		corner(b, 7)
		R.Tabs[t[2]] = b
		b.MouseButton1Click:Connect(function() show(t[2]) end)
	end

	-- pad de voo
	local flyPad = new("Frame", {
		Size = UDim2.fromOffset(44, 100), Position = UDim2.new(1, -58, 0.5, 40),
		BackgroundTransparency = 1, Visible = false, ZIndex = 25,
	}, Gui)
	new("UIListLayout", { Padding = UDim.new(0, 5) }, flyPad)
	for i, t in ipairs({ { "+", 1 }, { "−", 2 } }) do
		local b = new("TextButton", {
			Text = t[1], Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.violet,
			BackgroundColor3 = C.card, Size = UDim2.new(1, 0, 0, 44), LayoutOrder = t[2],
			AutoButtonColor = false, BorderSizePixel = 0, BackgroundTransparency = 0.1,
		}, flyPad)
		corner(b, 9)
		stroke(b, C.violet, 1, 0.4)
		b.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if t[1] == "+" then upH = true else downH = true end
			end
		end)
		b.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if t[1] == "+" then upH = false else downH = false end
			end
		end)
	end
	R.FlyPad = flyPad

	-- TELEPORT
	local tp = page("Teleport")
	for _, g in ipairs(PLACES) do
		sec(tp, g[1])
		local gr = grid(tp, 2)
		for _, e in ipairs(g[2]) do gbtn(gr, e[1], nil, function() TP(e[2], e[1]) end) end
	end
	sec(tp, "Jogadores")
	R.PGrid = grid(tp, 2)
	local function refresh()
		for _, c in ipairs(R.PGrid:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player then
				gbtn(R.PGrid, p.Name, nil, function()
					local cc = p.Character
					local rr = cc and cc:FindFirstChild("HumanoidRootPart")
					if rr then TP(rr.Position, p.Name) end
				end)
			end
		end
	end
	refresh()
	Players.PlayerAdded:Connect(function() task.wait(0.4); refresh() end)
	Players.PlayerRemoving:Connect(function() task.wait(0.4); refresh() end)
	btn(tp, "Trazer todos até mim", function()
		local r = root()
		if not r then return end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.CFrame = r.CFrame * CFrame.new(0, 0, -4) end
			end
		end
	end)

	-- SPAWN
	local sp = page("Spawn")
	sec(sp, "Modo")
	local mr = new("Frame", { Size = UDim2.new(1, 0, 0, 27), BackgroundTransparency = 1 }, sp)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, mr)
	local mb = {}
	for _, m in ipairs({ { "physical", "fisico" }, { "real", "servidor" } }) do
		local b = new("TextButton", {
			Text = m[2], Font = Enum.Font.GothamSemibold, TextSize = 10, TextColor3 = C.dim,
			BackgroundColor3 = C.card, Size = UDim2.new(0.5, -2, 1, 0), AutoButtonColor = false, BorderSizePixel = 0,
		}, mr)
		corner(b, 6)
		mb[m[1]] = b
		b.MouseButton1Click:Connect(function()
			mode = m[1]
			for k, bb in pairs(mb) do
				bb.TextColor3 = k == mode and C.violet or C.dim
				bb.BackgroundColor3 = k == mode and C.hover or C.card
			end
		end)
	end
	mb.physical.TextColor3 = C.violet
	mb.physical.BackgroundColor3 = C.hover

	local all = {}
	for _, g in ipairs(GROUPS) do
		for _, n in ipairs(g[2]) do table.insert(all, n) end
	end
	sec(sp, "Mapa de spawn")
	local q = inp(sp, "filtrar fruta", function() end)
	local nodes = {}
	local function rebuild(f)
		for _, n in ipairs(nodes) do n:Destroy() end
		nodes = {}
		for _, g in ipairs(GROUPS) do
			local shown = {}
			for _, n in ipairs(g[2]) do
				if f == "" or n:lower():find(f:lower(), 1, true) then table.insert(shown, n) end
			end
			if #shown > 0 then
				local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 23), BackgroundTransparency = 1 }, sp)
				table.insert(nodes, hd)
				local b = new("TextButton", {
					Text = g[1] .. "  ·  " .. #shown, Font = Enum.Font.GothamSemibold, TextSize = 10,
					TextColor3 = C.violet, BackgroundColor3 = C.card, Size = UDim2.fromScale(1, 1),
					AutoButtonColor = false, BorderSizePixel = 0,
				}, hd)
				corner(b, 6)
				b.MouseButton1Click:Connect(function() groupSpawn(shown, g[1]) end)
				local gr = grid(sp, 3, 24)
				table.insert(nodes, gr)
				for _, n in ipairs(shown) do gbtn(gr, n, nil, function() oneFruit(n) end) end
			end
		end
	end
	rebuild("")
	q:GetPropertyChangedSignal("Text"):Connect(function() rebuild(q.Text) end)
	sec(sp, "Ações")
	btn(sp, "Spawnar todas em círculo", function() groupSpawn(all, "todas") end)
	btn(sp, "10 aleatórias", function()
		local p = {}
		for _ = 1, 10 do table.insert(p, all[math.random(1, #all)]) end
		groupSpawn(p, "aleatorias")
	end)
	btn(sp, "Limpar geradas", function()
		for _, f in ipairs(R.Spawned) do if f.Parent then f:Destroy() end end
		R.Spawned = {}
		log("frutas limpas", "ok")
	end)
	inp(sp, "fruta nova / personalizada", function(t) oneFruit(t) end)

	-- PLAYER
	local pl = page("Player")
	sec(pl, "Velocidade")
	sld(pl, "WalkSpeed", 16, 400, 40, function(v) S.speed = v end)
	sec(pl, "Pulo")
	local jt
	jt = tog(pl, "Aplicar altura", false, function(v)
		S.jOn = v
		if not v then
			local h = hum()
			if h then
				if h.UseJumpPower then h.JumpPower = 50 else h.JumpHeight = 15 end
			end
		end
	end)
	sld(pl, "Altura (studs)", 5, 400, 50, function(v) S.jH = v end)
	sld(pl, "Pulos por salto", 1, 10, 1, function(v)
		S.multi = v
		jumpN = v - 1
	end)
	btn(pl, "Ativar pulo agora", function()
		S.jOn = true
		jt.set(true)
		stats()
		log("pulo " .. S.jH .. " studs", "ok")
	end)
	sec(pl, "Voo")
	tog(pl, "Voo", false, function(v)
		setFly(v)
		R.FlyPad.Visible = v
		log(v and "voo on" or "voo off", "ok")
	end)
	sld(pl, "Velocidade horizontal", 10, 400, 70, function(v) S.flyH = v end)
	sld(pl, "Velocidade vertical", 10, 400, 60, function(v) S.flyV = v end)
	sld(pl, "Suavidade", 5, 100, 35, function(v) S.acc = v / 100 end)
	tog(pl, "Travar altitude", false, function(v) S.lock = v end)
	btn(pl, "Subir 100", function()
		local r = root()
		if r then r.CFrame = r.CFrame + Vector3.new(0, 100, 0) end
	end)
	btn(pl, "Descer 100", function()
		local r = root()
		if r then r.CFrame = r.CFrame - Vector3.new(0, 100, 0) end
	end)
	sec(pl, "Movimento")
	tog(pl, "Noclip", false, function(v) setNoclip(v) end)
	tog(pl, "Pulo infinito", false, function(v) S.infJ = v end)
	tog(pl, "God Mode", false, function(v) S.god = v; stats() end)
	btn(pl, "Curar", function()
		local h = hum()
		if h then h.Health = h.MaxHealth end
	end)
	btn(pl, "Resetar personagem", function()
		local h = hum()
		if h then h.Health = 0 end
	end)

	-- COMBAT
	local cb = page("Combat")
	sec(cb, "Aimbot")
	tog(cb, "Aimbot", false, function(v) A.on = v end)
	sld(cb, "FOV", 40, 600, 150, function(v) A.fov = v end)
	sld(cb, "Suavidade", 5, 100, 22, function(v) A.sm = v / 100 end)
	tog(cb, "Ignorar time", true, function(v) A.team = v end)
	sec(cb, "Farm")
	tog(cb, "Auto farm", false, function(v)
		S.farm = v
		log(v and "farm on" or "farm off", "ok")
	end)
	sld(cb, "Alcance", 20, 400, 120, function(v) S.range = v end)
	tog(cb, "Auto ataque", false, function(v) S.atk = v end)
	btn(cb, "Comprar Buso", function() invoke("BuyHaki", "Buso"); log("buso", "ok") end)

	-- VISUAL
	local vs = page("Visual")
	sec(vs, "ESP")
	tog(vs, "ESP ativo", false, function(v)
		E.on = v
		if not v then clearEsp() end
		log(v and "esp on" or "esp off", "ok")
	end)
	tog(vs, "Caixa", true, function(v) E.box = v; clearEsp() end)
	tog(vs, "Nome + distância", true, function(v) E.nm = v; clearEsp() end)
	tog(vs, "Vida", true, function(v) E.hp = v; clearEsp() end)
	tog(vs, "Esqueleto", true, function(v) E.sk = v; clearEsp() end)
	tog(vs, "Linha", true, function(v) E.ln = v; clearEsp() end)
	tog(vs, "Ignorar time", false, function(v) E.team = v; clearEsp() end)
	sec(vs, "Objetos")
	tog(vs, "ESP de frutas", false, function(v) E.fr = v; clearEsp() end)
	sec(vs, "Cena")
	tog(vs, "Full bright", false, function(v) setBright(v) end)
	tog(vs, "Anti AFK", false, function(v) antiAfk = v end)

	-- STATUS
	local st = page("Status")
	sec(st, "Servidor")
	local ic = card(st, 66)
	local il = new("TextLabel", {
		Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.new(1, -14, 1, -8), Position = UDim2.fromOffset(7, 4),
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
	}, ic)
	sec(st, "Spawn")
	local cc2 = card(st, 50)
	local cl = new("TextLabel", {
		Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.new(1, -14, 1, -8), Position = UDim2.fromOffset(7, 4),
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
	}, cc2)
	sec(st, "Log")
	local lh = new("Frame", { Size = UDim2.new(1, 0, 0, 230), BackgroundColor3 = C.card }, st)
	corner(lh, 8)
	pad(lh, 5, 5, 5, 7)
	R.LogBox = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, lh)

	task.spawn(function()
		while Gui.Parent do
			local ping = 0
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			local lvl, beli = "-", "-"
			local d = Player:FindFirstChild("Data")
			if d then
				local l, b = d:FindFirstChild("Level"), d:FindFirstChild("Beli")
				if l then lvl = tostring(l.Value) end
				if b then beli = tostring(b.Value) end
			end
			il.Text = "players  " .. #Players:GetPlayers() .. "\nping     " .. ping ..
				" ms\nlevel    " .. lvl .. "\nbeli     " .. beli ..
				"\nuptime   " .. math.floor(os.clock() - R.T0) .. "s"
			cl.Text = "ok       " .. R.Cnt.ok .. "\nfalhas   " .. R.Cnt.fail ..
				"\ngrupos   " .. R.Cnt.grp .. "\ngrupo falho " .. R.Cnt.grpFail ..
				"\ngeradas  " .. #R.Spawned
			task.wait(1)
		end
	end)

	-- ADMIN
	local ad = page("Admin")
	sec(ad, "Ilhas de admin")
	local ag = grid(ad, 2)
	for _, e in ipairs(PLACES[4][2]) do gbtn(ag, e[1], C.violet, function() TP(e[2], e[1]) end) end
	sec(ad, "Haki / time")
	btn(ad, "Buso", function() invoke("BuyHaki", "Buso"); log("buso", "ok") end)
	btn(ad, "Kenbunshoku", function() invoke("BuyHaki", "Ken"); log("ken", "ok") end)
	btn(ad, "Geppo", function() invoke("BuyHaki", "Geppo"); log("geppo", "ok") end)
	btn(ad, "Soru", function() invoke("BuyHaki", "Soru"); log("soru", "ok") end)
	btn(ad, "Time Pirata", function() invoke("SetTeam", "Pirates"); log("pirates", "ok") end)
	btn(ad, "Time Marinha", function() invoke("SetTeam", "Marines"); log("marines", "ok") end)
	sec(ad, "Items")
	local ITEMS = {
		"Dark Blade", "Cursed Dual Katana", "Saber", "Bisento", "Dragon Trident",
		"Hallow Scythe", "Saddi", "Kabucha", "Serpent Bow", "Bazooka", "Cannon",
		"Flintlock", "Musket", "Slingshot", "Acidum Rifle", "Bizarre Rifle", "Katana", "Cutlass",
	}
	local function give(name)
		local t = findTmpl(name)
		if t and t:IsA("Tool") then
			local bp = Player:FindFirstChild("Backpack")
			if bp then
				t:Clone().Parent = bp
				log("item " .. name, "ok")
				return note("item " .. name, "good")
			end
		end
		local g2 = invoke("BuyItem", name)
		log((g2 and "servidor " or "nao achado ") .. name, g2 and "ok" or "bad")
		note(g2 and ("servidor " .. name) or ("nao achado " .. name), g2 and "good" or "bad")
	end
	local iq = inp(ad, "filtrar item", function() end)
	local ig = grid(ad, 2)
	local function fill(f)
		for _, c in ipairs(ig:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for _, n in ipairs(ITEMS) do
			if f == "" or n:lower():find(f:lower(), 1, true) then
				gbtn(ig, n, nil, function() give(n) end)
			end
		end
	end
	fill("")
	iq:GetPropertyChangedSignal("Text"):Connect(function() fill(iq.Text) end)
	inp(ad, "item personalizado", function(t) give(t) end)
	sec(ad, "Sessão")
	btn(ad, "Rejoin", function()
		pcall(function() TeleportService = game:GetService("TeleportService") end)
		pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
		end)
	end)
	btn(ad, "Copiar posição", function()
		local r = root()
		if not r then return end
		local p = r.Position
		local t = string.format("Vector3.new(%d, %d, %d)", p.X, p.Y, p.Z)
		if setclipboard then pcall(setclipboard, t) end
		note(t)
	end)

	-- abrir
	local function open(v)
		if v then
			Win.Visible = true
			Win.Size = UDim2.fromOffset(WW, math.floor(HH * 0.87))
			Tween:Create(Win, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(WW, HH) }):Play()
		else
			Win.Visible = false
		end
	end
	Orb.MouseButton1Click:Connect(function()
		Win.Visible = not Win.Visible
	end)
	UIS.InputBegan:Connect(function(i, gp)
		if gp then return end
		if i.KeyCode == Enum.KeyCode.RightShift then Win.Visible = not Win.Visible end
	end)

	show("Teleport")
	open(true)
	probe.Text = "ok"
	probe.TextColor3 = C.good
	task.delay(2, function()
		Tween:Create(probe, TweenInfo.new(0.3), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
	end)
	log("painel iniciado", "ok")
	setPill("pronto", "ok")
end

local ok2, e2 = pcall(build)
if not ok2 then fail(e2) end
