--=====================================================================
--  JDEV v7  •  BLOX FRUITS  •  PREMIUM BUILD
--=====================================================================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local Tween = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Teleport = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local VU = game:GetService("VirtualUser")

local LOGO = ""

local C = {
	bg = Color3.fromRGB(10, 10, 16), bg2 = Color3.fromRGB(14, 13, 21),
	panel = Color3.fromRGB(15, 15, 22), card = Color3.fromRGB(20, 20, 29),
	card2 = Color3.fromRGB(24, 24, 34), hover = Color3.fromRGB(31, 30, 44),
	line = Color3.fromRGB(37, 35, 51), text = Color3.fromRGB(235, 233, 246),
	dim = Color3.fromRGB(124, 120, 148), mute = Color3.fromRGB(84, 82, 104),
	violet = Color3.fromRGB(150, 112, 255), blue = Color3.fromRGB(88, 158, 255),
	cyan = Color3.fromRGB(126, 224, 255), good = Color3.fromRGB(94, 226, 150),
	bad = Color3.fromRGB(255, 96, 112), gold = Color3.fromRGB(255, 206, 118),
}

local function new(cl, p, parent)
	local o = Instance.new(cl)
	if p then
		for k, v in pairs(p) do
			if k ~= "Parent" then pcall(function() o[k] = v end) end
		end
	end
	if parent then o.Parent = parent end
	return o
end
local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function stroke(o, c, t, tr)
	return new("UIStroke", { Color = c or C.line, Thickness = t or 1, Transparency = tr or 0.55 }, o)
end
local function pad(o, a, b, c, d)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, a or 0), PaddingRight = UDim.new(0, b or 0),
		PaddingBottom = UDim.new(0, c or 0), PaddingLeft = UDim.new(0, d or 0),
	}, o)
end
local function grad(o, a, b, rot)
	local g = new("UIGradient", { Rotation = rot or 90 }, o)
	pcall(function() g.Color = ColorSequence.new(a, b) end)
	return g
end
local function cam() return workspace.CurrentCamera end
local function scr()
	local c = workspace.CurrentCamera
	return c and c.ViewportSize or Vector2.new(1280, 720)
end

local Player = Players.LocalPlayer
local w0 = 0
while not Player and w0 < 80 do
	task.wait(0.1)
	Player = Players.LocalPlayer or Players:GetPlayers()[1]
	w0 += 1
end
local PGui = Player and (Player:FindFirstChildOfClass("PlayerGui") or Player:WaitForChild("PlayerGui", 10))
local old = PGui and PGui:FindFirstChild("JDEV")
if old then old:Destroy() end

local Gui = new("ScreenGui", {
	Name = "JDEV", ResetOnSpawn = false, IgnoreGuiInset = true,
	DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, PGui)

local R = {
	Pages = {}, Tabs = {}, Log = {}, Wp = {}, Spawned = {},
	Cnt = { ok = 0, fail = 0, grp = 0, grpFail = 0 }, T0 = os.clock(),
}

local probe = new("TextLabel", {
	Size = UDim2.fromOffset(150, 24), Position = UDim2.fromOffset(12, 12),
	BackgroundColor3 = C.card, Text = "iniciando", Font = Enum.Font.GothamMedium,
	TextSize = 12, TextColor3 = C.dim, BorderSizePixel = 0, ZIndex = 99,
}, Gui)
corner(probe, 6)

local errBox = new("TextLabel", {
	Size = UDim2.new(1, -24, 0, 0), Position = UDim2.fromOffset(12, 44),
	BackgroundColor3 = Color3.fromRGB(58, 12, 20), TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.Code, TextSize = 11, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y,
	TextXAlignment = Enum.TextXAlignment.Left, Visible = false, ZIndex = 100, BorderSizePixel = 0,
}, Gui)
corner(errBox, 6)
pad(errBox, 7, 8, 7, 8)

local function fail(m)
	errBox.Text = "JDEV ERRO\n" .. tostring(m)
	errBox.Visible = true
	probe.Text = "erro"
	probe.TextColor3 = C.bad
	warn("[JDEV] " .. tostring(m))
end

--==================== LOGO ============================================
local function emblem(parent, size)
	if LOGO ~= "" then
		local img = new("ImageLabel", {
			Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1,
			Image = LOGO, ScaleType = Enum.ScaleType.Fit,
		}, parent)
		return img
	end
	local b = new("Frame", {
		Size = UDim2.fromOffset(size, size), BackgroundColor3 = Color3.fromRGB(7, 6, 13),
		BorderSizePixel = 0, ClipsDescendants = true,
	}, parent)
	corner(b, math.floor(size * 0.3))
	local ring = new("Frame", { Size = UDim2.fromScale(0.9, 0.9), Position = UDim2.fromScale(0.05, 0.05), BackgroundTransparency = 1 }, b)
	corner(ring, 999)
	local rs = stroke(ring, C.violet, 1, 0.05)
	grad(rs, C.violet, C.blue, 45)
	local glow = new("Frame", { Size = UDim2.fromScale(0.74, 0.74), Position = UDim2.fromScale(0.13, 0.13), BackgroundTransparency = 1 }, b)
	corner(glow, 999)
	stroke(glow, C.blue, 1, 0.72)
	local moon = new("Frame", {
		Size = UDim2.fromScale(0.5, 0.5), Position = UDim2.fromScale(0.23, 0.26),
		BackgroundColor3 = Color3.fromRGB(132, 198, 255), BorderSizePixel = 0,
	}, b)
	corner(moon, 999)
	grad(moon, Color3.fromRGB(160, 220, 255), Color3.fromRGB(72, 122, 255), 120)
	local bite = new("Frame", {
		Size = UDim2.fromScale(0.46, 0.46), Position = UDim2.fromScale(0.38, 0.22),
		BackgroundColor3 = Color3.fromRGB(7, 6, 13), BorderSizePixel = 0,
	}, b)
	corner(bite, 999)
	local h1 = new("Frame", { Size = UDim2.fromScale(0.62, 0.075), Position = UDim2.fromScale(0.19, 0.462), BackgroundColor3 = Color3.fromRGB(230, 214, 255), BorderSizePixel = 0 }, b)
	corner(h1, 999)
	local v1 = new("Frame", { Size = UDim2.fromScale(0.075, 0.62), Position = UDim2.fromScale(0.462, 0.19), BackgroundColor3 = Color3.fromRGB(230, 214, 255), BorderSizePixel = 0 }, b)
	corner(v1, 999)
	local core = new("Frame", { Size = UDim2.fromScale(0.14, 0.14), Position = UDim2.fromScale(0.43, 0.43), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, b)
	corner(core, 999)
	local fl = new("Frame", { Size = UDim2.fromScale(0.075, 0.11), Position = UDim2.fromScale(0.462, 0.045), Rotation = 45, BackgroundColor3 = C.violet, BorderSizePixel = 0 }, b)
	corner(fl, 2)
	local s1 = new("Frame", { Size = UDim2.fromScale(0.07, 0.07), Position = UDim2.fromScale(0.015, 0.465), Rotation = 45, BackgroundColor3 = C.blue, BorderSizePixel = 0 }, b)
	corner(s1, 2)
	local s2 = new("Frame", { Size = UDim2.fromScale(0.07, 0.07), Position = UDim2.fromScale(0.915, 0.465), Rotation = 45, BackgroundColor3 = C.blue, BorderSizePixel = 0 }, b)
	corner(s2, 2)
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
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then cur = i end
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

--==================== PILL / LOG / TOAST ==============================
local pillTxt, pillDot
local function setPill(t, kind)
	if not pillTxt then return end
	pillTxt.Text = t
	local c = C.dim
	if kind == "ok" then c = C.good elseif kind == "bad" then c = C.bad elseif kind == "busy" then c = C.cyan end
	pillTxt.TextColor3 = c
	pillDot.BackgroundColor3 = c
end

local function log(t, kind)
	local up = math.floor(os.clock() - R.T0)
	table.insert(R.Log, { string.format("%02d:%02d", math.floor(up / 60), up % 60), tostring(t), kind })
	if #R.Log > 80 then table.remove(R.Log, 1) end
	if not R.LogBox then return end
	for _, c in ipairs(R.LogBox:GetChildren()) do
		if c:IsA("TextLabel") then c:Destroy() end
	end
	for i = #R.Log, 1, -1 do
		local l = R.Log[i]
		local c = C.mute
		if l[3] == "ok" then c = C.good elseif l[3] == "bad" then c = C.bad end
		new("TextLabel", {
			Text = l[1] .. "   " .. l[2], Font = Enum.Font.Code, TextSize = 10, TextColor3 = c,
			BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 13),
			TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
		}, R.LogBox)
	end
end

local toastN = 0
local function note(t, kind)
	if not R.Toasts then return end
	toastN += 1
	local c = C.violet
	if kind == "bad" then c = C.bad elseif kind == "good" then c = C.good end
	local cd = new("Frame", {
		Size = UDim2.fromOffset(210, 30), BackgroundColor3 = C.card2,
		LayoutOrder = toastN, ZIndex = 60,
	}, R.Toasts)
	corner(cd, 8)
	stroke(cd, c, 1, 0.25)
	new("Frame", { Size = UDim2.new(0, 3, 0.5, 0), Position = UDim2.new(0, 7, 0.25, 0), BackgroundColor3 = c, BorderSizePixel = 0 }, cd)
	new("TextLabel", {
		Text = tostring(t), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(16, 0),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, cd)
	task.delay(2.2, function()
		Tween:Create(cd, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		task.wait(0.22)
		cd:Destroy()
	end)
end

--==================== COMPONENTES =====================================
local function card(parent, h)
	local f = new("Frame", { Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = C.card, BorderSizePixel = 0 }, parent)
	corner(f, 9)
	stroke(f, C.line, 1, 0.5)
	return f
end

local function sec(parent, t)
	local f = new("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1 }, parent)
	new("TextLabel", {
		Text = string.upper(t), Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = C.mute,
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left,
	}, f)
	local line = new("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -3),
		BackgroundColor3 = C.line, BackgroundTransparency = 0.5, BorderSizePixel = 0,
	}, f)
	return f
end

local function btn(parent, t, cb, accent)
	local b = new("TextButton", {
		Text = "", Size = UDim2.new(1, 0, 0, 33), BackgroundColor3 = C.card,
		AutoButtonColor = false, BorderSizePixel = 0,
	}, parent)
	corner(b, 9)
	local st = stroke(b, C.line, 1, 0.5)
	new("TextLabel", {
		Text = t, Font = Enum.Font.GothamMedium, TextSize = 12,
		TextColor3 = accent and C.violet or C.text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(11, 0), TextXAlignment = Enum.TextXAlignment.Left,
	}, b)
	b.MouseEnter:Connect(function()
		b.BackgroundColor3 = C.hover
		st.Color = C.violet
		st.Transparency = 0.35
	end)
	b.MouseLeave:Connect(function()
		b.BackgroundColor3 = C.card
		st.Color = C.line
		st.Transparency = 0.5
	end)
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
	corner(b, 7)
	b.MouseEnter:Connect(function() b.BackgroundColor3 = C.hover end)
	b.MouseLeave:Connect(function() b.BackgroundColor3 = C.card end)
	b.MouseButton1Click:Connect(function()
		local o, e = pcall(cb)
		if not o then note(e, "bad") end
	end)
	return b
end

local function grid(parent, cols, h)
	local g = new("Frame", {
		Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, parent)
	new("UIGridLayout", {
		CellSize = UDim2.new(1 / cols, -3, 0, h or 26), CellPadding = UDim.new(0, 3, 0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, g)
	return g
end

local function tog(parent, t, def, cb)
	local on = def or false
	local row = card(parent, 33)
	new("TextLabel", {
		Text = t, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -56, 1, 0), Position = UDim2.fromOffset(11, 0),
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
		local o, e = pcall(cb, v)
		if not o then note(e, "bad") end
	end
	hit.MouseButton1Click:Connect(function() apply(not on) end)
	return { set = apply, get = function() return on end }
end

local function sld(parent, t, min, max, def, cb)
	local row = card(parent, 47)
	local lbl = new("TextLabel", {
		Text = t .. "   " .. tostring(def), Font = Enum.Font.GothamMedium, TextSize = 11,
		TextColor3 = C.text, BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 21),
		Position = UDim2.fromOffset(11, 4), TextXAlignment = Enum.TextXAlignment.Left,
	}, row)
	local track = new("Frame", {
		Size = UDim2.new(1, -22, 0, 4), Position = UDim2.fromOffset(11, 33),
		BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0,
	}, row)
	corner(track, 2)
	local fill = new("Frame", {
		Size = UDim2.new((def - min) / (max - min), 0, 1, 0), BackgroundColor3 = C.violet, BorderSizePixel = 0,
	}, track)
	corner(fill, 2)
	grad(fill, C.violet, C.blue, 0)
	local knob = new("Frame", {
		Size = UDim2.fromOffset(10, 10), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0), BackgroundColor3 = C.text, BorderSizePixel = 0,
	}, track)
	corner(knob, 5)
	local held = false
	local function set(a)
		a = math.clamp(a, 0, 1)
		fill.Size = UDim2.new(a, 0, 1, 0)
		knob.Position = UDim2.new(a, 0, 0.5, 0)
		local v = math.floor(min + (max - min) * a + 0.5)
		lbl.Text = t .. "   " .. tostring(v)
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
		Size = UDim2.new(1, 0, 0, 31), BackgroundColor3 = C.card, Text = "",
		PlaceholderText = ph, PlaceholderColor3 = C.mute, Font = Enum.Font.GothamMedium,
		TextSize = 11, TextColor3 = C.text, ClearTextOnFocus = false, BorderSizePixel = 0,
	}, parent)
	corner(b, 8)
	stroke(b, C.line, 1, 0.5)
	pad(b, 0, 9, 0, 9)
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
		Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, ScrollBarImageColor3 = C.violet, ScrollBarImageTransparency = 0.45,
		CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false, ScrollingDirection = Enum.ScrollingDirection.Y,
	}, R.Body)
	pad(sc, 10, 12, 16, 4)
	new("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, sc)
	R.Pages[name] = sc
	return sc
end

local function show(name)
	for n, b in pairs(R.Tabs) do
		b.BackgroundColor3 = C.panel
		b.TextColor3 = C.mute
		if R.Pages[n] then R.Pages[n].Visible = false end
		if b.ind then b.ind.Visible = false end
	end
	if R.Tabs[name] then
		R.Tabs[name].BackgroundColor3 = C.card2
		R.Tabs[name].TextColor3 = C.violet
		if R.Tabs[name].ind then R.Tabs[name].ind.Visible = true end
	end
	if R.Pages[name] then R.Pages[name].Visible = true end
end

--==================== ESTADO ==========================================
local S = {
	speed = 40, jH = 50, jOn = false, multi = 1, god = false, infJ = false, noclip = false,
	fly = false, flyH = 80, flyV = 60, lock = false, acc = 0.4,
	farm = false, range = 130, atk = false, chest = false, collect = false, hit = 1, invis = false,
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
		if h.UseJumpPower then h.JumpPower = math.clamp(math.sqrt(2 * grav() * S.jH), 50, 1000) else h.JumpHeight = S.jH end
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

local function setHit(mult)
	S.hit = mult
	local r = root()
	if r then r.Size = Vector3.new(2 * mult, 2 * mult, 1 * mult) end
end

local invisSaved = {}
local function setInvis(on)
	S.invis = on
	local c = chr()
	if not c then return end
	for _, p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") then
			if on then
				invisSaved[p] = p.Transparency
				p.Transparency = 1
			elseif invisSaved[p] then
				p.Transparency = invisSaved[p]
			end
		elseif p:IsA("Decal") then
			if on then
				invisSaved[p] = p.Transparency
				p.Transparency = 1
			elseif invisSaved[p] then
				p.Transparency = invisSaved[p]
			end
		end
	end
end

Player.CharacterAdded:Connect(function(c)
	task.wait(1)
	S.fly = false
	if R.FlyPad then R.FlyPad.Visible = false end
	local h = c:WaitForChild("Humanoid", 8)
	if h then
		h.StateChanged:Connect(function(s)
			if s == Enum.HumanoidStateType.Landed then jumpN = S.multi - 1 end
		end)
	end
	local r = c:WaitForChild("HumanoidRootPart", 5)
	if r and S.hit ~= 1 then r.Size = Vector3.new(2 * S.hit, 2 * S.hit, 1 * S.hit) end
	stats()
end)

--==================== REDE ============================================
local function CommF()
	local rem = RS:FindFirstChild("Remotes")
	return rem and rem:FindFirstChild("CommF_")
end

local function invoke(...)
	local c = CommF()
	if not c then return false, "sem remote" end
	local args = table.pack(...)
	local ok, res = pcall(function() return c:InvokeServer(table.unpack(args, 1, args.n)) end)
	return ok, res
end

local function invokeLog(...)
	local ok, res = invoke(...)
	local args = table.pack(...)
	log(table.concat({ tostring(args[1]), tostring(args[2] or "") }, " ") .. " -> " .. tostring(res), ok and "ok" or "bad")
	return ok, res
end

--==================== TELEPORTE VOANDO ================================
local flying = false
local function flyTo(pos, label)
	local r = root()
	if not r then return note("sem personagem", "bad") end
	if flying then return end
	flying = true
	setPill("voando", "busy")
	local target = pos + Vector3.new(0, 3, 0)
	local dist = (target - r.Position).Magnitude
	if dist > 3000 then
		invoke("requestEntrance", pos)
		task.wait(0.6)
		r = root()
		if not r then flying = false; return end
	end
	if S.fly then
		r.CFrame = CFrame.new(target)
	else
		r.Anchored = true
		local dur = math.clamp(dist / 380, 0.25, 3.2)
		local tw = Tween:Create(r, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = CFrame.new(target) })
		tw:Play()
		tw.Completed:Wait()
		local rr = root()
		if rr then
			rr.Anchored = false
			rr.CFrame = CFrame.new(target)
		end
	end
	flying = false
	log("TP " .. (label or "?"), "ok")
	setPill("ok", "ok")
end

local PLACES = {
	{ "Primeiro Mar", {
		{ "Vendedor de Fruta", Vector3.new(0, 5, 0) }, { "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Amazon Lily", Vector3.new(-3000, 5, 2500) }, { "Sky Island", Vector3.new(-7863, 5545, -378) },
		{ "Holy Tower", Vector3.new(0, 2000, 4500) },
	} },
	{ "Segundo Mar", {
		{ "Coliseu", Vector3.new(-5000, 5, 0) }, { "Navio Amaldiçoado", Vector3.new(0, 5, -4000) },
		{ "Castelo Assombrado", Vector3.new(-3000, 5, -4000) }, { "Café", Vector3.new(-386, 74, -314) },
		{ "Reino de Rosas", Vector3.new(500, 5, -3000) },
	} },
	{ "Terceiro Mar", {
		{ "Egghead", Vector3.new(6000, 5, 6000) }, { "Mansão", Vector3.new(6000, 5, -6000) },
		{ "Hydra", Vector3.new(-8000, 5, 0) }, { "Grande Árvore", Vector3.new(-1055, 328, -8916) },
		{ "Terra do Gelo", Vector3.new(-12000, 5, -3000) },
	} },
	{ "Admin / Dev", {
		{ "Ilha Admin", Vector3.new(0, 5, -10000) }, { "Sala Admin", Vector3.new(0, 5, -12500) },
		{ "Sala Dev", Vector3.new(0, 1000, -15000) }, { "Vazio", Vector3.new(0, 3000, 0) },
		{ "Acima do Mapa", Vector3.new(0, 6000, 0) },
	} },
}

--==================== FRUTAS ==========================================
local GROUPS = {
	{ "Comum", { "Rocket", "Kilo", "Spin", "Blade", "Chop", "Spring", "Bomb", "Spike" } },
	{ "Rara", { "Diamond", "Revive", "Rubber", "Ghost", "Barrier", "Creation", "Door", "Portal",
		"Smoke", "Flame", "Ice", "Sand", "Dark", "Light", "Falcon", "Eagle" } },
	{ "Lendária", { "Quake", "Love", "Spider", "String", "Sound", "Pain", "Paw", "Magma",
		"Lightning", "Rumble", "Blizzard", "Buddha", "Phoenix" } },
	{ "Mítica", { "Gravity", "Shadow", "Venom", "Spirit", "Soul", "Control", "Dough", "Gas",
		"Hellfire (Gas)", "Mammoth", "T-Rex", "Leopard", "Tiger", "Yeti", "Kitsune", "Dragon",
		"Dragon (Classic)", "Magnet", "Empyrean (Kitsune)", "Fiend (Yeti)", "Werewolf (Tiger)",
		"Celestial", "Oni", "Meme" } },
}
local ALIAS = {
	Rocket = "Kilo", Kilo = "Rocket", Blade = "Chop", Chop = "Blade", Portal = "Door", Door = "Portal",
	Lightning = "Rumble", Rumble = "Lightning", Spirit = "Soul", Soul = "Spirit", Spider = "String",
	String = "Spider", Tiger = "Leopard", Leopard = "Tiger", Creation = "Barrier", Barrier = "Creation",
	Eagle = "Falcon", Falcon = "Eagle",
}
local mode = "real"
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

local function spawnPhysical(name, angle, radius)
	local t = findTmpl(name)
	if not t then return false end
	if #R.Spawned > 60 then
		local o = table.remove(R.Spawned, 1)
		if o and o.Parent then o:Destroy() end
	end
	local r = root()
	local cf = r and (r.CFrame * CFrame.new(math.cos(angle) * radius, 3, math.sin(angle) * radius)) or CFrame.new(0, 60, 0)
	local cl = t:Clone()
	cl.Name = clean(name) .. " Fruit"
	local part = cl:IsA("BasePart") and cl or (cl:FindFirstChild("Handle") or cl:FindFirstChildWhichIsA("BasePart"))
	if cl:IsA("Model") then
		for _, p in ipairs(cl:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = true
				p.CanCollide = false
			end
		end
		cl.Parent = workspace
		if cl.PrimaryPart then cl:PivotTo(cf) elseif part then part.CFrame = cf end
	else
		cl.Parent = workspace
		if part then
			part.Anchored = true
			part.CanCollide = false
			part.CFrame = cf
		end
	end
	new("Highlight", {
		FillTransparency = 0.7, OutlineTransparency = 0.05,
		FillColor3 = C.violet, OutlineColor3 = C.cyan,
	}, cl)
	table.insert(R.Spawned, cl)
	return true
end

local function giveFruitReal(name)
	local base = clean(name)
	local ok, res = invoke("BuyFruit", base .. "-" .. base)
	if not ok or (res == 0 or res == false) then
		local ok2, res2 = invoke("LoadFruit", base)
		if ok2 and res2 then
			log("fruta " .. base .. " (inventário)", "ok")
			return note("fruta " .. base .. " no inventário", "good")
		end
		log("fruta " .. base .. " falhou: " .. tostring(res), "bad")
		return note("falhou: " .. base, "bad")
	end
	log("fruta " .. base .. " comprada", "ok")
	note("comprada: " .. base, "good")
end

local function oneFruit(name)
	if mode == "fisico" then
		if spawnPhysical(name, math.random() * 6.28, 8) then
			R.Cnt.ok += 1
			log("gerada " .. name, "ok")
			setPill("gerada", "ok")
			note("gerada: " .. name, "good")
		else
			R.Cnt.fail += 1
			log("sem modelo " .. name, "bad")
			note("sem modelo: " .. name, "bad")
		end
	else
		giveFruitReal(name)
	end
end

local function groupSpawn(list, label)
	if not root() then return note("sem personagem", "bad") end
	R.Cnt.grp += 1
	setPill("gerando", "busy")
	local okN = 0
	for i, n in ipairs(list) do
		if spawnPhysical(n, (i / math.max(#list, 1)) * 6.28, 15) then okN += 1 end
		if i % 6 == 0 then task.wait(0.04) end
	end
	local miss = #list - okN
	R.Cnt.ok += okN
	R.Cnt.fail += miss
	if miss > 0 then R.Cnt.grpFail += 1 end
	log((label or "grupo") .. " " .. okN .. "/" .. #list, miss == 0 and "ok" or "bad")
	setPill(okN .. "/" .. #list, miss == 0 and "ok" or "bad")
	note((label or "grupo") .. ": " .. okN .. "/" .. #list, miss == 0 and "good" or "bad")
end

--==================== ESP FREE FIRE ===================================
local E = {
	on = false, plr = true, box = true, nm = true, hp = true, sk = true, ln = true,
	fr = false, chest = false, team = false, dist = 1000, scale = 1,
}
local ec = {}
local BONES = {
	{ "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" }, { "UpperTorso", "LeftUpperArm" },
	{ "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" }, { "UpperTorso", "RightUpperArm" },
	{ "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" }, { "LowerTorso", "LeftUpperLeg" },
	{ "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" }, { "LowerTorso", "RightUpperLeg" },
	{ "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
}

local function killEsp(t)
	local d = ec[t]
	if not d then return end
	if d.hi then d.hi:Destroy() end
	if d.bill then d.bill:Destroy() end
	if d.ln then d.ln:Destroy() end
	if d.lines then
		for _, l in ipairs(d.lines) do l:Destroy() end
	end
	ec[t] = nil
end

local function clearEsp()
	local list = {}
	for t in pairs(ec) do table.insert(list, t) end
	for _, t in ipairs(list) do killEsp(t) end
end

local function bracket(bill, size, thick, col, ax, ay, px, py)
	local h = new("Frame", {
		Size = UDim2.fromOffset(size, thick), BackgroundColor3 = col, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(ax, ay), Position = UDim2.new(px, 0, py, 0),
	}, bill)
	local v = new("Frame", {
		Size = UDim2.fromOffset(thick, size), BackgroundColor3 = col, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(ax, ay), Position = UDim2.new(px, 0, py, 0),
	}, bill)
	return h, v
end

local function buildEsp(t, plr)
	if ec[t] then return end
	local hrp = t:FindFirstChild("HumanoidRootPart") or t:FindFirstChild("Torso") or t:FindFirstChildWhichIsA("BasePart")
	local h = t:FindFirstChildOfClass("Humanoid")
	local head = t:FindFirstChild("Head") or hrp
	local c = cam()
	if not hrp or not c then return end
	local col = Color3.fromRGB(240, 240, 250)
	if plr and Player.Team and plr.Team ~= Player.Team then col = Color3.fromRGB(255, 92, 108) end
	if not plr then col = C.violet end
	local d = { lines = {} }

	if E.box then
		d.hi = new("Highlight", {
			FillTransparency = 1, OutlineTransparency = 0.25, OutlineColor = col,
			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Adornee = t,
		}, t)
		d.bill = new("BillboardGui", {
			Size = UDim2.fromOffset(70, 110), StudsOffset = Vector3.new(0, 3, 0),
			AlwaysOnTop = true, Adornee = head or hrp, MaxDistance = 3000,
		}, head or hrp)
		local th = 2
		bracket(d.bill, 13, th, col, 0, 0, 0, 0)
		bracket(d.bill, 13, th, col, 1, 0, 1, 0)
		bracket(d.bill, 13, th, col, 0, 1, 0, 1)
		bracket(d.bill, 13, th, col, 1, 1, 1, 1)
		if E.nm then
			d.lbl = new("TextLabel", {
				Text = t.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1),
				TextStrokeTransparency = 0.2, BackgroundTransparency = 1,
				Size = UDim2.new(1, 40, 0, 15), Position = UDim2.fromOffset(-20, -18),
			}, d.bill)
		end
		if E.hp then
			local bg = new("Frame", {
				Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 1, 6),
				BackgroundColor3 = Color3.fromRGB(14, 14, 18), BorderSizePixel = 0,
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
		local hrp = t:FindFirstChild("HumanoidRootPart") or t:FindFirstChild("Torso")
		local head = t:FindFirstChild("Head")
		local h = t:FindFirstChildOfClass("Humanoid")
		if not t.Parent or not hrp then
			killEsp(t)
		else
			if d.bill and head then d.bill.Adornee = head end
			if d.fill and h then
				local rt = math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1)
				d.fill.Size = UDim2.new(rt, 0, 1, 0)
				d.fill.BackgroundColor3 = C.bad:Lerp(C.good, rt)
			end
			if d.lbl and head then
				d.lbl.Text = t.Name .. "  [" .. math.floor((c.CFrame.Position - head.Position).Magnitude) .. "]"
			end
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

local espScan = 0
Run.RenderStepped:Connect(function()
	if not E.on then return end
	local myRoot = root()
	local myPos = myRoot and myRoot.Position
	if E.plr then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character and not (E.team and p.Team == Player.Team) then
				local h = p.Character:FindFirstChildOfClass("Humanoid")
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				local okDist = true
				if myPos and hrp then okDist = (hrp.Position - myPos).Magnitude <= E.dist end
				if h and h.Health > 0 and okDist then
					buildEsp(p.Character, p)
				elseif not okDist then
					killEsp(p.Character)
				end
			end
		end
	end
	espScan += 1
	if espScan % 30 == 0 then
		if E.fr then
			for _, o in ipairs(workspace:GetChildren()) do
				if o.Name:find("Fruit") and not o:FindFirstChildOfClass("Humanoid") then buildEsp(o, nil) end
			end
		end
		if E.chest then
			for _, o in ipairs(workspace:GetChildren()) do
				if o:IsA("Model") and o.Name:lower():find("chest") then buildEsp(o, nil) end
			end
		end
	end
	tickEsp()
end)

--==================== AIMBOT ==========================================
local A = { on = false, fov = 160, sm = 0.3, team = true, atk = true }
local ring = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(A.fov * 2, A.fov * 2), BackgroundTransparency = 1, Visible = false, ZIndex = 10,
}, Gui)
corner(ring, 9999)
stroke(ring, C.violet, 1, 0.45)

local aimTarget
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
					if dd < A.fov and (not bd or dd < bd) then best, bd = hd, dd end
				end
			end
		end
	end
	aimTarget = best
	if best then
		local tgt = best.Position + best.AssemblyLinearVelocity * 0.12
		c.CFrame = c.CFrame:Lerp(CFrame.new(c.CFrame.Position, tgt), A.sm)
	end
end)

task.spawn(function()
	while Gui.Parent do
		task.wait(0.08)
		if A.on and A.atk and aimTarget then
			local c = chr()
			local tool = c and c:FindFirstChildOfClass("Tool")
			if tool then pcall(function() tool:Activate() end) end
		end
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
	flyBV = new("BodyVelocity", { MaxForce = Vector3.new(1e5, 1e5, 1e5), P = 9000, Velocity = Vector3.zero }, r)
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

--==================== FARM / COLETA ===================================
local lastPos, stuckAt, stuckCount = nil, 0, 0

local function nearestModel(tag, range)
	local r = root()
	if not r then return nil end
	local best, bd
	for _, o in ipairs(workspace:GetChildren()) do
		if o:IsA("Model") and o.Name:lower():find(tag) then
			local part = o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
			if part then
				local d = (part.Position - r.Position).Magnitude
				if d <= (range or 1e9) and (not bd or d < bd) then best, bd = part, d end
			end
		end
	end
	return best
end

local function nearestNpc(range)
	local r = root()
	if not r then return nil end
	local best, bd
	for _, m in ipairs(workspace:GetChildren()) do
		if m:IsA("Model") and not Players:GetPlayerFromCharacter(m) then
			local h = m:FindFirstChildOfClass("Humanoid")
			local rr = m:FindFirstChild("HumanoidRootPart") or m:FindFirstChildWhichIsA("BasePart")
			if h and rr and h.Health > 0 then
				local d = (rr.Position - r.Position).Magnitude
				if d <= range and (not bd or d < bd) then best, bd = rr, d end
			end
		end
	end
	return best
end

local function walkTo(part)
	local h = hum()
	local r = root()
	if not h or not r or not part then return end
	h:MoveTo(part.Position)
	local now = tick()
	if lastPos and (r.Position - lastPos).Magnitude < 2 then
		stuckCount += 1
		if now - stuckAt > 1.2 and stuckCount > 4 then
			r.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
			stuckCount = 0
			stuckAt = now
		end
	else
		stuckCount = 0
		stuckAt = now
	end
	lastPos = r.Position
end

task.spawn(function()
	while Gui.Parent do
		task.wait(0.16)
		if S.farm or S.chest or S.collect then
			local target
			if S.farm then
				target = nearestNpc(S.range)
			elseif S.chest then
				target = nearestModel("chest", S.range)
			elseif S.collect then
				target = nearestModel("fruit", S.range)
			end
			if target then
				local r = root()
				if r then
					local d = (target.Position - r.Position).Magnitude
					if d > 8 then
						walkTo(target)
					else
						local h = hum()
						if h then h:MoveTo(target.Position) end
						local c = chr()
						local tool = c and c:FindFirstChildOfClass("Tool")
						if tool then pcall(function() tool:Activate() end) end
					end
				end
			end
		end
	end
end)

local lightOld
local function setBright(on)
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
	pcall(function()
		VU:CaptureController()
		VU:ClickButton1(Vector2.new(50, 50))
	end)
end)

--==================== ITENS (LISTA GRANDE) ============================
local ITEMS = {
	"Dark Blade", "Cursed Dual Katana", "Saber", "Bisento", "Dragon Trident", "Hallow Scythe",
	"True Triple Katana", "Saddi", "Kabucha", "Serpent Bow", "Bazooka", "Cannon", "Flintlock",
	"Musket", "Slingshot", "Acidum Rifle", "Bizarre Rifle", "Katana", "Cutlass", "Trident",
	"Pipe", "Warden Sword", "Valkyrie Helm", "Superhuman", "Godhuman", "Sanguine Art",
	"Electric Claw", "Dragon Talon", "Sharkman Karate", "Death Step", "Mink", "Fishman Karate",
	"Black Leg", "Dark Step", "Combat", "Dragon Breath", "Soru", "Geppo", "Buso", "Ken",
}

local function giveTool(name)
	local t = findTmpl(name)
	if t and t:IsA("Tool") then
		local bp = Player:FindFirstChild("Backpack")
		if bp then
			local cl = t:Clone()
			cl.Parent = bp
			log("item " .. name, "ok")
			return note("item: " .. name, "good")
		end
	end
	local ok, res = invoke("BuyItem", name)
	if ok and res then
		log("item " .. name .. " (servidor)", "ok")
		return note("item: " .. name, "good")
	end
	local ok2 = invoke("BuySword", name)
	if ok2 then
		log("item " .. name .. " (loja)", "ok")
		return note("item: " .. name, "good")
	end
	log("item " .. name .. " falhou", "bad")
	note("não achado: " .. name, "bad")
end

--==================== BUILD ===========================================
local function build()
	R.Toasts = new("Frame", {
		Size = UDim2.new(0, 220, 1, -20), Position = UDim2.new(1, -232, 0, 10), BackgroundTransparency = 1, ZIndex = 55,
	}, Gui)
	new("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
	}, R.Toasts)

	local Orb = new("TextButton", {
		Text = "", Size = UDim2.fromOffset(54, 54), Position = UDim2.fromOffset(12, 12),
		BackgroundColor3 = C.panel, AutoButtonColor = false, ZIndex = 30,
	}, Gui)
	corner(Orb, 16)
	local orbStroke = stroke(Orb, C.violet, 1, 0.2)
	emblem(Orb, 54)
	drag(Orb, Orb)
	Orb.MouseEnter:Connect(function() orbStroke.Transparency = 0.05 end)
	Orb.MouseLeave:Connect(function() orbStroke.Transparency = 0.2 end)

	local s = scr()
	local WW = math.clamp(s.X - 40, 300, 440)
	local HH = math.clamp(s.Y - 110, 330, 590)

	local Win = new("Frame", {
		Size = UDim2.fromOffset(WW, HH), Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.bg,
		ClipsDescendants = true, Visible = false, ZIndex = 20,
	}, Gui)
	corner(Win, 16)
	stroke(Win, C.line, 1, 0.15)
	grad(Win, C.bg2, C.bg, 90)
	R.Win = Win

	local Head = new("Frame", { Size = UDim2.new(1, 0, 0, 68), BackgroundTransparency = 1 }, Win)
	drag(Win, Head)

	local logoBox = emblem(Head, 40)
	logoBox.Position = UDim2.fromOffset(14, 14)

	new("TextLabel", {
		Text = "JDEV", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.fromOffset(140, 18), Position = UDim2.fromOffset(64, 14),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, Head)
	new("TextLabel", {
		Text = "blox fruits · premium", Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = C.mute,
		BackgroundTransparency = 1, Size = UDim2.fromOffset(160, 12), Position = UDim2.fromOffset(64, 31),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, Head)

	local pill = new("Frame", {
		Size = UDim2.fromOffset(88, 17), Position = UDim2.fromOffset(64, 44),
		BackgroundColor3 = C.card, BorderSizePixel = 0,
	}, Head)
	corner(pill, 9)
	stroke(pill, C.line, 1, 0.7)
	pillDot = new("Frame", {
		Size = UDim2.fromOffset(5, 5), Position = UDim2.fromOffset(7, 6),
		BackgroundColor3 = C.dim, BorderSizePixel = 0,
	}, pill)
	corner(pillDot, 3)
	pillTxt = new("TextLabel", {
		Text = "pronto", Font = Enum.Font.GothamMedium, TextSize = 9, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(16, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, pill)

	local Min = new("TextButton", {
		Text = "—", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -36, 0, 16),
		AutoButtonColor = false, BorderSizePixel = 0,
	}, Head)
	corner(Min, 7)
	Min.MouseEnter:Connect(function() Min.TextColor3 = C.text end)
	Min.MouseLeave:Connect(function() Min.TextColor3 = C.dim end)
	Min.MouseButton1Click:Connect(function() Win.Visible = false end)

	local strip = new("Frame", {
		Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 68),
		BackgroundColor3 = C.violet, BorderSizePixel = 0, BackgroundTransparency = 0.55,
	}, Win)
	grad(strip, C.violet, C.cyan, 0)

	local Rail = new("Frame", {
		Size = UDim2.new(0, 58, 1, -69), Position = UDim2.fromOffset(0, 69),
		BackgroundColor3 = C.panel, BorderSizePixel = 0,
	}, Win)
	pad(Rail, 8, 8, 8, 8)
	new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, Rail)

	R.Body = new("Frame", {
		Size = UDim2.new(1, -58, 1, -69), Position = UDim2.fromOffset(58, 69), BackgroundTransparency = 1,
	}, Win)

	for i, t in ipairs({
		{ "TP", "Teleporte" }, { "FR", "Frutas" }, { "PL", "Player" }, { "CB", "Combate" },
		{ "VS", "Visual" }, { "ST", "Status" }, { "AD", "Admin" },
	}) do
		local b = new("TextButton", {
			Text = t[1], Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.mute,
			BackgroundColor3 = C.panel, Size = UDim2.new(1, 0, 0, 32), AutoButtonColor = false,
			BorderSizePixel = 0, LayoutOrder = i,
		}, Rail)
		corner(b, 8)
		local ind = new("Frame", {
			Size = UDim2.new(0, 2, 0, 14), Position = UDim2.new(0, -8, 0.5, -7),
			BackgroundColor3 = C.violet, BorderSizePixel = 0, Visible = false,
		}, b)
		corner(ind, 1)
		b.ind = ind
		R.Tabs[t[2]] = b
		b.MouseEnter:Connect(function()
			if R.Tabs[t[2]] then b.BackgroundColor3 = C.card end
		end)
		b.MouseButton1Click:Connect(function() show(t[2]) end)
	end

	local flyPad = new("Frame", {
		Size = UDim2.fromOffset(46, 104), Position = UDim2.new(1, -60, 0.5, 40),
		BackgroundTransparency = 1, Visible = false, ZIndex = 25,
	}, Gui)
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, flyPad)
	for _, t in ipairs({ { "+", 1 }, { "−", 2 } }) do
		local b = new("TextButton", {
			Text = t[1], Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.violet,
			BackgroundColor3 = C.card2, Size = UDim2.new(1, 0, 0, 46), LayoutOrder = t[2],
			AutoButtonColor = false, BorderSizePixel = 0,
		}, flyPad)
		corner(b, 11)
		stroke(b, C.violet, 1, 0.35)
		b.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if t[1] == "+" then upH = true else downH = true end
			end
		end)
		b.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				if t[1] == "+" then upH = false else downH = false end
			end
		end)
	end
	R.FlyPad = flyPad

	--========== TELEPORTE ==========
	local tp = page("Teleporte")
	for _, g in ipairs(PLACES) do
		sec(tp, g[1])
		local gr = grid(tp, 2)
		for _, e in ipairs(g[2]) do gbtn(gr, e[1], nil, function() flyTo(e[2], e[1]) end) end
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
					if rr then flyTo(rr.Position, p.Name) end
				end)
			end
		end
	end
	refresh()
	Players.PlayerAdded:Connect(function() task.wait(0.4); refresh() end)
	Players.PlayerRemoving:Connect(function() task.wait(0.4); refresh() end)
	sec(tp, "Waypoints")
	R.WpGrid = grid(tp, 2)
	local function refreshWp()
		for _, c in ipairs(R.WpGrid:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for _, w in ipairs(R.Wp) do
			gbtn(R.WpGrid, w[1], C.cyan, function() flyTo(w[2], w[1]) end)
		end
	end
	inp(tp, "salvar waypoint (nome)", function(n)
		local r = root()
		if not r then return end
		table.insert(R.Wp, { n, r.Position })
		refreshWp()
		note("waypoint salvo: " .. n, "good")
	end)

	--========== FRUTAS ==========
	local fr = page("Frutas")
	sec(fr, "Modo")
	local mr = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, fr)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, mr)
	local mb = {}
	for _, m in ipairs({ { "real", "inventário" }, { "fisico", "no chão" } }) do
		local b = new("TextButton", {
			Text = m[2], Font = Enum.Font.GothamSemibold, TextSize = 10, TextColor3 = C.mute,
			BackgroundColor3 = C.card, Size = UDim2.new(0.5, -2, 1, 0), AutoButtonColor = false, BorderSizePixel = 0,
		}, mr)
		corner(b, 7)
		mb[m[1]] = b
		b.MouseButton1Click:Connect(function()
			mode = m[1]
			for k, bb in pairs(mb) do
				bb.TextColor3 = k == mode and C.violet or C.mute
				bb.BackgroundColor3 = k == mode and C.hover or C.card
			end
		end)
	end
	mb.real.TextColor3 = C.violet
	mb.real.BackgroundColor3 = C.hover

	local all = {}
	for _, g in ipairs(GROUPS) do
		for _, n in ipairs(g[2]) do table.insert(all, n) end
	end
	sec(fr, "Catálogo")
	local q = inp(fr, "filtrar fruta", function() end)
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
				local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1 }, fr)
				table.insert(nodes, hd)
				local b = new("TextButton", {
					Text = g[1] .. "   ·   " .. #shown, Font = Enum.Font.GothamSemibold, TextSize = 10,
					TextColor3 = C.violet, BackgroundColor3 = C.card, Size = UDim2.fromScale(1, 1),
					AutoButtonColor = false, BorderSizePixel = 0,
				}, hd)
				corner(b, 7)
				b.MouseButton1Click:Connect(function() groupSpawn(shown, g[1]) end)
				local gr = grid(fr, 3, 25)
				table.insert(nodes, gr)
				for _, n in ipairs(shown) do gbtn(gr, n, nil, function() oneFruit(n) end) end
			end
		end
	end
	rebuild("")
	q:GetPropertyChangedSignal("Text"):Connect(function() rebuild(q.Text) end)
	sec(fr, "Ações")
	btn(fr, "Gerar todas em círculo", function() groupSpawn(all, "todas") end)
	btn(fr, "10 aleatórias", function()
		local p = {}
		for _ = 1, 10 do table.insert(p, all[math.random(1, #all)]) end
		groupSpawn(p, "aleatórias")
	end)
	btn(fr, "Limpar geradas", function()
		for _, f in ipairs(R.Spawned) do if f.Parent then f:Destroy() end end
		R.Spawned = {}
		log("frutas limpas", "ok")
	end)
	inp(fr, "fruta nova / personalizada", function(t) oneFruit(t) end)

	--========== PLAYER ==========
	local pl = page("Player")
	sec(pl, "Velocidade")
	sld(pl, "Velocidade", 16, 400, 40, function(v) S.speed = v end)
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
	btn(pl, "Aplicar pulo agora", function()
		S.jOn = true
		jt.set(true)
		stats()
		log("pulo " .. S.jH, "ok")
	end)
	sec(pl, "Voo")
	tog(pl, "Voo", false, function(v)
		setFly(v)
		R.FlyPad.Visible = v
		log(v and "voo on" or "voo off", "ok")
	end)
	sld(pl, "Velocidade horizontal", 10, 400, 80, function(v) S.flyH = v end)
	sld(pl, "Velocidade vertical", 10, 400, 60, function(v) S.flyV = v end)
	sld(pl, "Suavidade", 5, 100, 40, function(v) S.acc = v / 100 end)
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
	tog(pl, "Invisível", false, function(v) setInvis(v) end)
	sec(pl, "Hitbox")
	sld(pl, "Escala", 1, 5, 1, function(v) setHit(v) end)
	btn(pl, "Hitbox grande", function() setHit(3) end)
	btn(pl, "Hitbox normal", function() setHit(1) end)
	sec(pl, "Personagem")
	btn(pl, "Curar", function()
		local h = hum()
		if h then h.Health = h.MaxHealth end
	end)
	btn(pl, "Resetar personagem", function()
		local h = hum()
		if h then h.Health = 0 end
	end)

	--========== COMBATE ==========
	local cb = page("Combate")
	sec(cb, "Aimbot")
	tog(cb, "Aimbot", false, function(v)
		A.on = v
		ring.Visible = v
	end)
	sld(cb, "FOV", 40, 600, 160, function(v)
		A.fov = v
		ring.Size = UDim2.fromOffset(v * 2, v * 2)
	end)
	sld(cb, "Suavidade", 5, 100, 30, function(v) A.sm = v / 100 end)
	tog(cb, "Atacar automaticamente", true, function(v) A.atk = v end)
	tog(cb, "Ignorar time", true, function(v) A.team = v end)
	sec(cb, "Farm")
	tog(cb, "Farm automático", false, function(v)
		S.farm = v
		log(v and "farm on" or "farm off", "ok")
	end)
	sld(cb, "Alcance", 20, 500, 130, function(v) S.range = v end)
	tog(cb, "Auto baú", false, function(v) S.chest = v end)
	tog(cb, "Auto coletar fruta", false, function(v) S.collect = v end)
	sec(cb, "Ataque")
	tog(cb, "Ataque contínuo", false, function(v) S.atk = v end)
	btn(cb, "Matar NPC mais próximo", function()
		local t = nearestNpc(500)
		if t then flyTo(t.Position, "NPC") end
	end)

	--========== VISUAL ==========
	local vs = page("Visual")
	sec(vs, "ESP")
	tog(vs, "ESP ativo", false, function(v)
		E.on = v
		if not v then clearEsp() end
		log(v and "esp on" or "esp off", "ok")
	end)
	tog(vs, "Jogadores", true, function(v)
		E.plr = v
		clearEsp()
	end)
	tog(vs, "Cantos + contorno", true, function(v) E.box = v; clearEsp() end)
	tog(vs, "Nome + distância", true, function(v) E.nm = v; clearEsp() end)
	tog(vs, "Barra de vida", true, function(v) E.hp = v; clearEsp() end)
	tog(vs, "Esqueleto", true, function(v) E.sk = v; clearEsp() end)
	tog(vs, "Linha", true, function(v) E.ln = v; clearEsp() end)
	tog(vs, "Ignorar time", false, function(v) E.team = v; clearEsp() end)
	sld(vs, "Distância máx.", 50, 3000, 1000, function(v) E.dist = v end)
	sec(vs, "Objetos")
	tog(vs, "ESP de frutas", false, function(v) E.fr = v; clearEsp() end)
	tog(vs, "ESP de baús", false, function(v) E.chest = v; clearEsp() end)
	sec(vs, "Cena")
	tog(vs, "Full bright", false, function(v) setBright(v) end)
	tog(vs, "Anti AFK", false, function(v) antiAfk = v end)
	sld(vs, "Camera FOV", 30, 120, 70, function(v)
		local c = cam()
		if c then c.FieldOfView = v end
	end)

	--========== STATUS ==========
	local st = page("Status")
	sec(st, "Servidor")
	local ic = card(st, 70)
	local il = new("TextLabel", {
		Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.mute, BackgroundTransparency = 1,
		Size = UDim2.new(1, -16, 1, -10), Position = UDim2.fromOffset(9, 6),
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
	}, ic)
	sec(st, "Spawn")
	local cc2 = card(st, 54)
	local cl = new("TextLabel", {
		Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.mute, BackgroundTransparency = 1,
		Size = UDim2.new(1, -16, 1, -10), Position = UDim2.fromOffset(9, 6),
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
	}, cc2)
	sec(st, "Log")
	local lh = new("Frame", { Size = UDim2.new(1, 0, 0, 220), BackgroundColor3 = C.card }, st)
	corner(lh, 9)
	stroke(lh, C.line, 1, 0.5)
	pad(lh, 7, 7, 7, 9)
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
			il.Text = "jogadores " .. #Players:GetPlayers() .. "\nping      " .. ping ..
				" ms\nlevel     " .. lvl .. "\nbeli      " .. beli ..
				"\nuptime    " .. math.floor(os.clock() - R.T0) .. "s"
			cl.Text = "ok        " .. R.Cnt.ok .. "\nfalhas    " .. R.Cnt.fail ..
				"\ngrupos    " .. R.Cnt.grp .. "\ngrupo falho " .. R.Cnt.grpFail ..
				"\ngeradas   " .. #R.Spawned
			task.wait(1)
		end
	end)

	--========== ADMIN ==========
	local ad = page("Admin")
	sec(ad, "Ilhas restritas")
	local ag = grid(ad, 2)
	for _, e in ipairs(PLACES[4][2]) do gbtn(ag, e[1], C.violet, function() flyTo(e[2], e[1]) end) end
	sec(ad, "Jogadores")
	btn(ad, "Trazer todos até mim", function()
		local r = root()
		if not r then return end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.CFrame = r.CFrame * CFrame.new(0, 0, -4) end
			end
		end
		log("bring all", "ok")
	end)
	btn(ad, "Congelar todos", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.Anchored = true end
			end
		end
		log("congelar todos", "ok")
	end)
	btn(ad, "Descongelar todos", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.Anchored = false end
			end
		end
		log("descongelar", "ok")
	end)
	btn(ad, "Arremessar todos (fling)", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then
					rr.Anchored = false
					rr.AssemblyLinearVelocity = Vector3.new(
						math.random(-500, 500), math.random(400, 900), math.random(-500, 500)
					)
				end
			end
		end
		log("fling all", "ok")
	end)
	btn(ad, "Expulsar jogador do mapa", function()
		local r = root()
		if not r then return end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.CFrame = CFrame.new(0, -800, 0) end
			end
		end
		log("expulsar todos", "ok")
	end)
	btn(ad, "Atacar todos", function()
		local r = root()
		if not r then return end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then
					r.CFrame = rr.CFrame * CFrame.new(0, 0, 3)
					local tool = chr() and chr():FindFirstChildOfClass("Tool")
					if tool then pcall(function() tool:Activate() end) end
					task.wait(0.3)
				end
			end
		end
		log("ataque em todos", "ok")
	end)
	sec(ad, "Travar servidor")
	btn(ad, "Congelar servidor inteiro", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.Anchored = true end
			end
		end
		local r = root()
		if r then r.Anchored = true end
		log("SERVIDOR CONGELADO", "ok")
		setPill("servidor travado", "busy")
	end)
	btn(ad, "Liberar servidor", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.Anchored = false end
			end
		end
		log("servidor liberado", "ok")
		setPill("pronto", "ok")
	end)
	sec(ad, "Progresso")
	btn(ad, "Level 3000", function()
		local d = Player:FindFirstChild("Data")
		local l = d and d:FindFirstChild("Level")
		if l then l.Value = 3000 end
		log("level 3000", "ok")
	end)
	btn(ad, "Beli 1.000.000", function()
		local d = Player:FindFirstChild("Data")
		local b = d and d:FindFirstChild("Beli")
		if b then b.Value = 1000000 end
		log("beli 1M", "ok")
	end)
	btn(ad, "Fragmentos 100.000", function()
		local d = Player:FindFirstChild("Data")
		local f = d and d:FindFirstChild("Fragments")
		if f then f.Value = 100000 end
		log("fragments", "ok")
	end)
	btn(ad, "Resetar status", function() invokeLog("ResetStats") end)
	sec(ad, "Haki e estilos")
	btn(ad, "Comprar Buso", function() invokeLog("BuyHaki", "Buso") end)
	btn(ad, "Comprar Kenbunshoku", function() invokeLog("BuyHaki", "Ken") end)
	btn(ad, "Comprar Geppo", function() invokeLog("BuyHaki", "Geppo") end)
	btn(ad, "Comprar Soru", function() invokeLog("BuyHaki", "Soru") end)
	btn(ad, "Despertar fruta", function() invokeLog("Awaken") end)
	btn(ad, "Sorteio de fruta (Cousin)", function() invokeLog("Cousin", "Buy") end)
	sec(ad, "Time")
	btn(ad, "Entrar nos Piratas", function() invokeLog("SetTeam", "Pirates") end)
	btn(ad, "Entrar na Marinha", function() invokeLog("SetTeam", "Marines") end)
	sec(ad, "Itens")
	local iq = inp(ad, "filtrar item", function() end)
	local ig = grid(ad, 2)
	local function fill(f)
		for _, c in ipairs(ig:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for _, n in ipairs(ITEMS) do
			if f == "" or n:lower():find(f:lower(), 1, true) then
				gbtn(ig, n, nil, function() giveTool(n) end)
			end
		end
	end
	fill("")
	iq:GetPropertyChangedSignal("Text"):Connect(function() fill(iq.Text) end)
	inp(ad, "item personalizado", function(t) giveTool(t) end)
	btn(ad, "Dar todos os itens da lista", function()
		local okN = 0
		for _, n in ipairs(ITEMS) do
			local t = findTmpl(n)
			local bp = Player:FindFirstChild("Backpack")
			if t and t:IsA("Tool") and bp then
				t:Clone().Parent = bp
				okN += 1
			end
			task.wait(0.03)
		end
		log("itens dados: " .. okN, "ok")
		note("itens dados: " .. okN, "good")
	end)
	btn(ad, "Escanear itens reais do jogo", function()
		local found = {}
		for _, d in ipairs(RS:GetDescendants()) do
			if d:IsA("Tool") and #found < 400 then
				table.insert(found, d.Name)
			end
		end
		for _, n in ipairs(found) do
			if not table.find(ITEMS, n) then table.insert(ITEMS, n) end
		end
		fill(iq.Text)
		log("escaneados " .. #found, "ok")
		note("itens encontrados: " .. #found, "good")
	end)
	sec(ad, "Sessão")
	btn(ad, "Rejoin", function()
		pcall(function() Teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
	end)
	btn(ad, "Server hop", function()
		task.spawn(function()
			local okH, body = pcall(function()
				return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
			end)
			if not okH or not body then return note("hop falhou", "bad") end
			local okD, data = pcall(function() return Http:JSONDecode(body) end)
			if not okD or not data or not data.data then return note("hop falhou", "bad") end
			for _, sv in ipairs(data.data) do
				if sv.playing < sv.maxPlayers and sv.id ~= game.JobId then
					pcall(function() Teleport:TeleportToPlaceInstance(game.PlaceId, sv.id, Player) end)
					log("hop", "ok")
					return
				end
			end
			note("nenhum servidor livre", "bad")
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

	local function open(v)
		if v then
			Win.Visible = true
			Win.Size = UDim2.fromOffset(WW, math.floor(HH * 0.88))
			Tween:Create(Win, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(WW, HH) }):Play()
		else
			Win.Visible = false
		end
	end
	Orb.MouseButton1Click:Connect(function() Win.Visible = not Win.Visible end)
	UIS.InputBegan:Connect(function(i, gp)
		if gp then return end
		if i.KeyCode == Enum.KeyCode.RightShift then Win.Visible = not Win.Visible end
	end)

	show("Teleporte")
	open(true)
	probe.Text = "ok"
	probe.TextColor3 = C.good
	task.delay(2, function()
		Tween:Create(probe, TweenInfo.new(0.3), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
	end)
	log("painel iniciado", "ok")
	setPill("pronto", "ok")
end

local okb, eb = pcall(build)
if not okb then fail(eb) end
