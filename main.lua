--=====================================================================
--  JDEV BLOX 🤫🌙  •  v10  •  LAUNCHER PREMIUM
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

-- ícone: caminho de arquivo do executor OU asset id
local LOGO_FILE = "jdev_icon.png"
local LOGO_ID = ""

local C = {
	bg = Color3.fromRGB(8, 7, 12), bg2 = Color3.fromRGB(13, 12, 19),
	side = Color3.fromRGB(11, 10, 16), card = Color3.fromRGB(19, 18, 27),
	card2 = Color3.fromRGB(24, 23, 34), hover = Color3.fromRGB(31, 29, 44),
	line = Color3.fromRGB(37, 34, 50), text = Color3.fromRGB(238, 236, 248),
	dim = Color3.fromRGB(128, 124, 152), mute = Color3.fromRGB(78, 76, 96),
	pur = Color3.fromRGB(166, 116, 255), pur2 = Color3.fromRGB(108, 68, 214),
	blue = Color3.fromRGB(96, 168, 255), cyan = Color3.fromRGB(130, 226, 255),
	good = Color3.fromRGB(96, 228, 152), bad = Color3.fromRGB(255, 96, 112),
	gold = Color3.fromRGB(255, 208, 120),
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

local CONNS = {}
local function track(c) table.insert(CONNS, c) return c end
local function untrack()
	for _, c in ipairs(CONNS) do pcall(function() c:Disconnect() end) end
	CONNS = {}
end

--==================== LOGO ============================================
local LOGO_IMG = ""
local function resolveLogo()
	if LOGO_ID ~= "" then LOGO_IMG = LOGO_ID return end
	if getcustomasset and LOGO_FILE ~= "" then
		local ok, res = pcall(getcustomasset, LOGO_FILE)
		if ok and res then LOGO_IMG = res end
	end
end
resolveLogo()

local function emblem(parent, size)
	if LOGO_IMG ~= "" then
		local img = new("ImageLabel", {
			Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1,
			Image = LOGO_IMG, ScaleType = Enum.ScaleType.Fit,
		}, parent)
		corner(img, math.floor(size * 0.24))
		return img
	end
	local b = new("Frame", {
		Size = UDim2.fromOffset(size, size), BackgroundColor3 = Color3.fromRGB(6, 5, 11),
		BorderSizePixel = 0, ClipsDescendants = true,
	}, parent)
	corner(b, math.floor(size * 0.26))
	local ring = new("Frame", { Size = UDim2.fromScale(0.92, 0.92), Position = UDim2.fromScale(0.04, 0.04), BackgroundTransparency = 1 }, b)
	corner(ring, 999)
	grad(stroke(ring, C.pur, 1, 0.05), C.pur, C.blue, 45)
	local moon = new("Frame", {
		Size = UDim2.fromScale(0.52, 0.52), Position = UDim2.fromScale(0.22, 0.25),
		BackgroundColor3 = Color3.fromRGB(120, 196, 255), BorderSizePixel = 0,
	}, b)
	corner(moon, 999)
	grad(moon, Color3.fromRGB(170, 226, 255), Color3.fromRGB(62, 108, 255), 120)
	local bite = new("Frame", {
		Size = UDim2.fromScale(0.48, 0.48), Position = UDim2.fromScale(0.37, 0.21),
		BackgroundColor3 = Color3.fromRGB(6, 5, 11), BorderSizePixel = 0,
	}, b)
	corner(bite, 999)
	local h1 = new("Frame", { Size = UDim2.fromScale(0.66, 0.075), Position = UDim2.fromScale(0.17, 0.462), BackgroundColor3 = Color3.fromRGB(238, 222, 255), BorderSizePixel = 0 }, b)
	corner(h1, 999)
	local v1 = new("Frame", { Size = UDim2.fromScale(0.075, 0.66), Position = UDim2.fromScale(0.462, 0.17), BackgroundColor3 = Color3.fromRGB(238, 222, 255), BorderSizePixel = 0 }, b)
	corner(v1, 999)
	local core = new("Frame", { Size = UDim2.fromScale(0.15, 0.15), Position = UDim2.fromScale(0.425, 0.425), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, b)
	corner(core, 999)
	local fl = new("Frame", { Size = UDim2.fromScale(0.08, 0.12), Position = UDim2.fromScale(0.46, 0.04), Rotation = 45, BackgroundColor3 = C.pur, BorderSizePixel = 0 }, b)
	corner(fl, 2)
	local s1 = new("Frame", { Size = UDim2.fromScale(0.075, 0.075), Position = UDim2.fromScale(0.01, 0.462), Rotation = 45, BackgroundColor3 = C.blue, BorderSizePixel = 0 }, b)
	corner(s1, 2)
	local s2 = new("Frame", { Size = UDim2.fromScale(0.075, 0.075), Position = UDim2.fromScale(0.915, 0.462), Rotation = 45, BackgroundColor3 = C.blue, BorderSizePixel = 0 }, b)
	corner(s2, 2)
	return b
end

local function drag(frame, handle)
	local on, cur, org, st
	track(handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			on, org, st = true, frame.Position, i.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then on = false end
			end)
		end
	end))
	track(handle.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then cur = i end
	end))
	track(UIS.InputChanged:Connect(function(i)
		if i ~= cur or not on then return end
		local d = i.Position - st
		local s = scr()
		frame.Position = UDim2.fromOffset(
			math.clamp(org.X.Offset + d.X, 0, s.X - frame.AbsoluteSize.X),
			math.clamp(org.Y.Offset + d.Y, 0, s.Y - frame.AbsoluteSize.Y)
		)
	end))
end

--==================== TOAST ===========================================
local toasts = new("Frame", {
	Size = UDim2.new(0, 240, 1, -20), Position = UDim2.new(1, -252, 0, 10),
	BackgroundTransparency = 1, ZIndex = 400,
}, Gui)
new("UIListLayout", {
	VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right,
	Padding = UDim.new(0, 6),
}, toasts)

local tn = 0
local function note(t, kind)
	tn += 1
	local c = C.pur
	if kind == "bad" then c = C.bad elseif kind == "good" then c = C.good end
	local cd = new("Frame", { Size = UDim2.fromOffset(230, 32), BackgroundColor3 = C.card2, LayoutOrder = tn, ZIndex = 401 }, toasts)
	corner(cd, 9)
	stroke(cd, c, 1, 0.2)
	new("Frame", { Size = UDim2.new(0, 3, 0.5, 0), Position = UDim2.new(0, 8, 0.25, 0), BackgroundColor3 = c, BorderSizePixel = 0 }, cd)
	new("TextLabel", {
		Text = tostring(t), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
		BackgroundTransparency = 1, Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(17, 0),
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
	}, cd)
	task.delay(2.4, function()
		Tween:Create(cd, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
		task.wait(0.22)
		cd:Destroy()
	end)
end

--==================== ORBE ============================================
local Orb = new("TextButton", {
	Text = "", Size = UDim2.fromOffset(56, 56), Position = UDim2.fromOffset(14, 14),
	BackgroundColor3 = C.bg2, AutoButtonColor = false, ZIndex = 300,
}, Gui)
corner(Orb, 17)
local orbStroke = stroke(Orb, C.pur, 1, 0.2)
emblem(Orb, 56)
drag(Orb, Orb)

--==================== SELETOR DE JOGO =================================
local GAMES = {
	{ id = "blox", name = "Blox Fruits", sub = "farm · esp · frutas", ready = true },
	{ id = "vanguard", name = "Anime Vanguards", sub = "em desenvolvimento", ready = false },
	{ id = "battlegrounds", name = "Battlegrounds", sub = "em desenvolvimento", ready = false },
	{ id = "arsenal", name = "Arsenal", sub = "em desenvolvimento", ready = false },
}

local s0 = scr()
local LW = math.clamp(s0.X - 60, 300, 420)
local LH = math.clamp(s0.Y - 140, 320, 480)

local Launcher = new("Frame", {
	Size = UDim2.fromOffset(LW, LH), Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.bg,
	ClipsDescendants = true, ZIndex = 200,
}, Gui)
corner(Launcher, 16)
grad(stroke(Launcher, C.pur, 1, 0.25), C.pur, C.cyan, 45)
grad(Launcher, C.bg2, C.bg, 90)

local LHead = new("Frame", { Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1 }, Launcher)
drag(Launcher, LHead)
local LLogo = emblem(LHead, 46)
LLogo.Position = UDim2.fromOffset(16, 15)
new("TextLabel", {
	Text = "JDEV BLOX🤫🌙", Font = Enum.Font.GothamBold, TextSize = 17, TextColor3 = C.text,
	BackgroundTransparency = 1, Size = UDim2.fromOffset(240, 20), Position = UDim2.fromOffset(72, 16),
	TextXAlignment = Enum.TextXAlignment.Left,
}, LHead)
new("TextLabel", {
	Text = "escolha o jogo para executar", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.mute,
	BackgroundTransparency = 1, Size = UDim2.fromOffset(240, 14), Position = UDim2.fromOffset(72, 36),
	TextXAlignment = Enum.TextXAlignment.Left,
}, LHead)
local LClose = new("TextButton", {
	Text = "×", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.dim,
	BackgroundColor3 = C.card, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -38, 0, 16),
	AutoButtonColor = false, BorderSizePixel = 0,
}, LHead)
corner(LClose, 8)
LClose.MouseButton1Click:Connect(function()
	Launcher.Visible = false
end)
new("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 76), BackgroundColor3 = C.pur, BorderSizePixel = 0 }, Launcher)

local LList = new("ScrollingFrame", {
	Size = UDim2.new(1, -24, 1, -92), Position = UDim2.fromOffset(12, 86),
	BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
	ScrollBarImageColor3 = C.pur, CanvasSize = UDim2.fromOffset(0, 0),
}, Launcher)
new("UIListLayout", { Padding = UDim.new(0, 7) }, LList)

--==================== ABRIR / FECHAR ==================================
local function toggleLauncher(v)
	Launcher.Visible = v
	if v then
		Launcher.Size = UDim2.fromOffset(LW, math.floor(LH * 0.9))
		Tween:Create(Launcher, TweenInfo.new(0.18, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(LW, LH) }):Play()
	end
end

Orb.MouseButton1Click:Connect(function() toggleLauncher(not Launcher.Visible) end)
track(UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then toggleLauncher(not Launcher.Visible) end
end))

--==================== MÓDULO BLOX FRUITS ==============================
local S, R, Panel
local function alive() return Panel and Panel.Parent end

local function bootBlox()
	if Panel then Panel:Destroy() end
	untrack()
	Panel = new("Frame", {
		Size = UDim2.new(0.92, 0, 0.86, 0), Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = C.bg,
		ClipsDescendants = true, ZIndex = 150,
	}, Gui)
	corner(Panel, 14)
	grad(stroke(Panel, C.pur, 1, 0.3), C.pur, C.cyan, 45)
	grad(Panel, C.bg2, C.bg, 90)

	R = { Pages = {}, Tabs = {}, Ind = {}, Cards = {}, Log = {}, Wp = {}, Spawned = {}, ok = 0, fail = 0, T0 = os.clock() }
	S = {
		speed = 40, jH = 50, jOn = false, multi = 1, god = false, infJ = false, noclip = false,
		fly = false, flyH = 80, flyV = 60, lock = false, acc = 0.4,
		farm = false, range = 130, atk = false, chest = false, collect = false, hit = 1,
	}
	local chr = function() return Player.Character end
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
	track(Run.Heartbeat:Connect(stats))

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
	track(UIS.JumpRequest:Connect(function()
		if S.infJ then doJump() elseif S.multi > 1 and jumpN > 0 then
			jumpN -= 1
			doJump()
		end
	end))

	local function CommF()
		local rem = RS:FindFirstChild("Remotes")
		return rem and rem:FindFirstChild("CommF_")
	end
	local function invoke(...)
		local c = CommF()
		if not c then return false, "sem remote" end
		local args = table.pack(...)
		return pcall(function() return c:InvokeServer(table.unpack(args, 1, args.n)) end)
	end
	local function invokeLog(a, b)
		local ok, res = invoke(a, b)
		log(tostring(a) .. (b and (" " .. tostring(b)) or "") .. " → " .. tostring(res), ok and "ok" or "bad")
		return ok, res
	end

	-- LOG
	local logBox
	function log(t, kind)
		table.insert(R.Log, { os.date("%H:%M"), tostring(t), kind })
		if #R.Log > 70 then table.remove(R.Log, 1) end
		if not logBox then return end
		for _, c in ipairs(logBox:GetChildren()) do
			if c:IsA("TextLabel") then c:Destroy() end
		end
		for i = #R.Log, 1, -1 do
			local l = R.Log[i]
			local col = C.mute
			if l[3] == "ok" then col = C.good elseif l[3] == "bad" then col = C.bad end
			new("TextLabel", {
				Text = l[1] .. "  " .. l[2], Font = Enum.Font.Code, TextSize = 10, TextColor3 = col,
				BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 13),
				TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
			}, logBox)
		end
	end

	-- TELEPORTE VOANDO
	local flying = false
	local function flyTo(pos, label)
		local r = root()
		if not r or flying then return end
		flying = true
		local target = pos + Vector3.new(0, 3, 0)
		if (target - r.Position).Magnitude > 3000 then
			invoke("requestEntrance", pos)
			task.wait(0.6)
			r = root()
		end
		if r then
			if S.fly then
				r.CFrame = CFrame.new(target)
			else
				r.Anchored = true
				local dur = math.clamp((target - r.Position).Magnitude / 400, 0.25, 3)
				local tw = Tween:Create(r, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = CFrame.new(target) })
				tw:Play()
				tw.Completed:Wait()
				local rr = root()
				if rr then
					rr.Anchored = false
					rr.CFrame = CFrame.new(target)
				end
			end
		end
		flying = false
		log("TP " .. (label or "?"), "ok")
	end

	-- FRUTAS
	local GROUPS = {
		{ "Comuns", { "Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike" } },
		{ "Incomuns", { "Flame", "Ice", "Sand", "Dark", "Eagle", "Diamond" } },
		{ "Raras", { "Light", "Rubber", "Ghost", "Magma" } },
		{ "Lendárias", { "Quake", "Buddha", "Love", "Creation", "Spider", "Sound", "Phoenix",
			"Portal", "Lightning", "Pain", "Blizzard" } },
		{ "Míticas", { "Gravity", "Mammoth", "T-Rex", "Dough", "Shadow", "Venom", "Control",
			"Gas", "Spirit", "Tiger", "Magnet", "Yeti", "Kitsune", "Dragon" } },
	}
	local ALIAS = {
		Rocket = "Kilo", Kilo = "Rocket", Blade = "Chop", Chop = "Blade", Portal = "Door",
		Door = "Portal", Lightning = "Rumble", Rumble = "Lightning", Spirit = "Soul",
		Soul = "Spirit", Spider = "String", String = "Spider", Tiger = "Leopard",
		Leopard = "Tiger", Creation = "Barrier", Barrier = "Creation", Eagle = "Falcon",
		Falcon = "Eagle", Ghost = "Revive", Revive = "Ghost", Pain = "Paw", Paw = "Pain",
	}
	local mode = "dealer"
	local cache = {}
	local function clean(n) return (n:gsub("%s*%b()", "")) end

	local function findTmpl(name)
		local base = clean(name)
		local c = cache[base]
		if c and c.Parent then return c end
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

	local function spawnPhysical(name)
		local t = findTmpl(name)
		if not t then return false end
		if #R.Spawned > 50 then
			local o = table.remove(R.Spawned, 1)
			if o and o.Parent then o:Destroy() end
		end
		local r = root()
		local cf = r and (r.CFrame * CFrame.new(math.random(-7, 7), 3, math.random(-7, 7))) or CFrame.new(0, 60, 0)
		local cl = t:Clone()
		cl.Name = clean(name) .. " Fruit"
		local part = cl:IsA("BasePart") and cl or (cl:FindFirstChild("Handle") or cl:FindFirstChildWhichIsA("BasePart"))
		if cl:IsA("Model") then
			for _, pp in ipairs(cl:GetDescendants()) do
				if pp:IsA("BasePart") then
					pp.Anchored = true
					pp.CanCollide = false
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
		new("Highlight", { FillTransparency = 0.7, OutlineTransparency = 0.05, FillColor3 = C.pur, OutlineColor3 = C.cyan }, cl)
		table.insert(R.Spawned, cl)
		return true
	end

	local function fruitReal(name)
		local base = clean(name)
		if mode == "gacha" then
			local ok = invoke("Cousin", "Buy")
			log("sorteio", ok and "ok" or "bad")
			return note(ok and "sorteio feito" or "sorteio falhou", ok and "good" or "bad")
		end
		local ok, res = invoke("BuyFruit", base .. "-" .. base)
		if ok and res ~= 0 and res ~= false and res ~= nil then
			R.ok += 1
			log("comprada " .. base, "ok")
			return note("comprada: " .. base, "good")
		end
		local ok2, res2 = invoke("LoadFruit", base)
		if ok2 and res2 then
			R.ok += 1
			log("entregue " .. base, "ok")
			return note("entregue: " .. base, "good")
		end
		R.fail += 1
		log("falhou " .. base, "bad")
		note("falhou: " .. base, "bad")
	end

	local function oneFruit(name)
		if mode == "chao" then
			if spawnPhysical(name) then
				R.ok += 1
				note("no chão: " .. name, "good")
			else
				R.fail += 1
				note("sem modelo: " .. name, "bad")
			end
		else
			fruitReal(name)
		end
	end

	-- ESP
	local E = { on = false, plr = true, box = true, nm = true, hp = true, sk = true, ln = true, fr = false, chest = false, team = false, dist = 1000 }
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
		if d.lines then for _, l in ipairs(d.lines) do l:Destroy() end end
		ec[t] = nil
	end
	local function clearEsp()
		local list = {}
		for t in pairs(ec) do table.insert(list, t) end
		for _, t in ipairs(list) do killEsp(t) end
	end
	local function bracket(bill, size, thick, col, ax, ay)
		new("Frame", { Size = UDim2.fromOffset(size, thick), BackgroundColor3 = col, BorderSizePixel = 0, AnchorPoint = Vector2.new(ax, ay), Position = UDim2.new(ax, 0, ay, 0) }, bill)
		new("Frame", { Size = UDim2.fromOffset(thick, size), BackgroundColor3 = col, BorderSizePixel = 0, AnchorPoint = Vector2.new(ax, ay), Position = UDim2.new(ax, 0, ay, 0) }, bill)
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
		if not plr then col = C.pur end
		local d = { lines = {} }
		if E.box then
			d.hi = new("Highlight", { FillTransparency = 1, OutlineTransparency = 0.25, OutlineColor = col, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Adornee = t }, t)
			d.bill = new("BillboardGui", { Size = UDim2.fromOffset(70, 110), StudsOffset = Vector3.new(0, 3, 0), AlwaysOnTop = true, Adornee = head, MaxDistance = 4000 }, head)
			bracket(d.bill, 13, 2, col, 0, 0)
			bracket(d.bill, 13, 2, col, 1, 0)
			bracket(d.bill, 13, 2, col, 0, 1)
			bracket(d.bill, 13, 2, col, 1, 1)
			if E.nm then
				d.lbl = new("TextLabel", { Text = t.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1), TextStrokeTransparency = 0.2, BackgroundTransparency = 1, Size = UDim2.new(1, 44, 0, 15), Position = UDim2.fromOffset(-22, -18) }, d.bill)
			end
			if E.hp then
				local bg = new("Frame", { Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 1, 6), BackgroundColor3 = Color3.fromRGB(14, 14, 18), BorderSizePixel = 0 }, d.bill)
				corner(bg, 2)
				d.fill = new("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.good, BorderSizePixel = 0 }, bg)
				corner(d.fill, 2)
			end
		end
		if E.sk and h then
			for i = 1, #BONES do
				d.lines[i] = new("LineHandleAdornment", { Thickness = 1, Color3 = col, AlwaysOnTop = true, ZIndex = 6, Adornee = hrp, Length = 0 }, c)
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
	track(Run.RenderStepped:Connect(function()
		if not E.on or not alive() then return end
		local myPos = root() and root().Position
		if E.plr then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= Player and p.Character and not (E.team and p.Team == Player.Team) then
					local h = p.Character:FindFirstChildOfClass("Humanoid")
					local hrp = p.Character:FindFirstChild("HumanoidRootPart")
					local okd = true
					if myPos and hrp then okd = (hrp.Position - myPos).Magnitude <= E.dist end
					if h and h.Health > 0 and okd then buildEsp(p.Character, p) elseif not okd then killEsp(p.Character) end
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
	end))

	-- AIMBOT
	local A = { on = false, fov = 160, sm = 0.3, team = true, atk = true }
	local ring = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.fromOffset(A.fov * 2, A.fov * 2), BackgroundTransparency = 1, Visible = false, ZIndex = 100,
	}, Gui)
	corner(ring, 9999)
	stroke(ring, C.pur, 1, 0.45)
	local aimTarget
	track(Run.RenderStepped:Connect(function()
		if not A.on or not alive() then return end
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
			c.CFrame = c.CFrame:Lerp(CFrame.new(c.CFrame.Position, best.Position + best.AssemblyLinearVelocity * 0.12), A.sm)
		end
	end))
	task.spawn(function()
		while alive() do
			task.wait(0.08)
			if A.on and A.atk and aimTarget then
				local c = chr()
				local tool = c and c:FindFirstChildOfClass("Tool")
				if tool then pcall(function() tool:Activate() end) end
			end
		end
	end)

	-- VOO
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

	-- FARM
	local lastPos, stuckAt = nil, 0
	local function nearestModel(tag, range)
		local r = root()
		if not r then return nil end
		local best, bd
		for _, o in ipairs(workspace:GetChildren()) do
			if o:IsA("Model") and o.Name:lower():find(tag) then
				local part = o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
				if part then
					local d = (part.Position - r.Position).Magnitude
					if d <= range and (not bd or d < bd) then best, bd = part, d end
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
	task.spawn(function()
		while alive() do
			task.wait(0.15)
			if S.farm or S.chest or S.collect then
				local target
				if S.farm then target = nearestNpc(S.range)
				elseif S.chest then target = nearestModel("chest", S.range)
				elseif S.collect then target = nearestModel("fruit", S.range) end
				local r, h = root(), hum()
				if target and r and h then
					if (target.Position - r.Position).Magnitude > 8 then
						h:MoveTo(target.Position)
						if lastPos and (r.Position - lastPos).Magnitude < 2 and tick() - stuckAt > 1.4 then
							r.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
							stuckAt = tick()
						end
						lastPos = r.Position
					else
						h:MoveTo(target.Position)
						local tool = chr() and chr():FindFirstChildOfClass("Tool")
						if tool then pcall(function() tool:Activate() end) end
					end
				end
			end
		end
	end)

	-- CENA
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
	track(UIS.WindowFocused:Connect(function()
		if not antiAfk then return end
		pcall(function()
			VU:CaptureController()
			VU:ClickButton1(Vector2.new(50, 50))
		end)
	end))

	--==================== INTERFACE ====================
	local Head = new("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1 }, Panel)
	drag(Panel, Head)
	new("TextLabel", {
		Text = "JDEV BLOX🤫🌙", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.pur,
		BackgroundTransparency = 1, Size = UDim2.fromOffset(260, 20), Position = UDim2.fromOffset(150, 16),
		TextXAlignment = Enum.TextXAlignment.Left,
	}, Head)
	local back = new("TextButton", {
		Text = "jogos", Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.fromOffset(54, 22), Position = UDim2.fromOffset(14, 15),
		AutoButtonColor = false, BorderSizePixel = 0,
	}, Head)
	corner(back, 7)
	back.MouseButton1Click:Connect(function()
		Panel:Destroy()
		Panel = nil
		untrack()
		toggleLauncher(true)
	end)
	local closeP = new("TextButton", {
		Text = "×", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.dim,
		BackgroundColor3 = C.card, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -38, 0, 14),
		AutoButtonColor = false, BorderSizePixel = 0,
	}, Head)
	corner(closeP, 8)
	closeP.MouseButton1Click:Connect(function() Panel.Visible = false end)

	local Side = new("Frame", {
		Size = UDim2.new(0, 138, 1, -52), Position = UDim2.fromOffset(0, 52),
		BackgroundColor3 = C.side, BorderSizePixel = 0,
	}, Panel)
	pad(Side, 10, 8, 10, 8)
	new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, Side)
	new("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 52), BackgroundColor3 = C.line, BorderSizePixel = 0 }, Panel)

	local Body = new("Frame", {
		Size = UDim2.new(1, -138, 1, -52), Position = UDim2.fromOffset(138, 52), BackgroundTransparency = 1,
	}, Panel)

	local NAV = {
		{ "★", "Principal" }, { "⚔", "Farm" }, { "◉", "Player" }, { "✧", "Visual" },
		{ "➤", "Teleporte" }, { "❖", "Frutas" }, { "♛", "Admin" }, { "≡", "Status" },
	}
	for i, n in ipairs(NAV) do
		local b = new("TextButton", {
			Text = "", BackgroundColor3 = C.side, Size = UDim2.new(1, 0, 0, 31),
			AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i,
		}, Side)
		corner(b, 8)
		new("TextLabel", {
			Text = n[1], Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.mute,
			BackgroundTransparency = 1, Size = UDim2.fromOffset(20, 31), Position = UDim2.fromOffset(8, 0),
		}, b)
		local lbl = new("TextLabel", {
			Text = n[2], Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.dim,
			BackgroundTransparency = 1, Size = UDim2.new(1, -34, 1, 0), Position = UDim2.fromOffset(30, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, b)
		local ind = new("Frame", {
			Size = UDim2.new(0, 2, 0, 14), Position = UDim2.new(0, -8, 0.5, -7),
			BackgroundColor3 = C.pur, BorderSizePixel = 0, Visible = false,
		}, b)
		corner(ind, 1)
		R.Ind[n[2]] = ind
		R.Tabs[n[2]] = { btn = b, lbl = lbl }
		b.MouseButton1Click:Connect(function() showPage(n[2]) end)
	end

	local function showPage(name)
		for k, t in pairs(R.Tabs) do
			t.btn.BackgroundColor3 = C.side
			t.lbl.TextColor3 = C.dim
			if R.Ind[k] then R.Ind[k].Visible = false end
			if R.Pages[k] then R.Pages[k].Visible = false end
		end
		local t = R.Tabs[name]
		if t then
			t.btn.BackgroundColor3 = C.card
			t.lbl.TextColor3 = C.text
			if R.Ind[name] then R.Ind[name].Visible = true end
		end
		if R.Pages[name] then R.Pages[name].Visible = true end
	end

	local function newPage(name)
		local sc = new("ScrollingFrame", {
			Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
			BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.pur,
			ScrollBarImageTransparency = 0.4, CanvasSize = UDim2.fromOffset(0, 0),
			Visible = false, ClipsDescendants = true,
		}, Body)
		local p = { f = sc, col = { {}, {} } }
		for i = 1, 2 do
			local colF = new("Frame", { Size = UDim2.new(0.5, -12, 1, 0), Position = UDim2.fromOffset(i == 1 and 10 or 0, 10), BackgroundTransparency = 1 }, sc)
			if i == 2 then colF.Position = UDim2.new(0.5, 2, 0, 10) end
			colF.Size = UDim2.new(0.5, -12, 0, 0)
			colF.AutomaticSize = Enum.AutomaticSize.Y
			new("UIListLayout", { Padding = UDim.new(0, 8) }, colF)
			p.col[i] = colF
		end
		R.Pages[name] = sc
		return p
	end

	local function addCard(p, col, title)
		local c = { y = 36, col = p.col[col] }
		local f = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.card, BorderSizePixel = 0 }, c.col)
		corner(f, 10)
		stroke(f, C.line, 1, 0.55)
		new("TextLabel", {
			Text = string.upper(title), Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.pur,
			BackgroundTransparency = 1, Size = UDim2.new(1, -20, 0, 16), Position = UDim2.fromOffset(12, 9),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, f)
		c.f = f
		return c
	end
	local function inCard(c, obj, h)
		obj.Size = UDim2.new(1, -20, 0, h)
		obj.Position = UDim2.fromOffset(10, c.y)
		c.y += h + 6
		c.f.Size = UDim2.new(1, 0, 0, c.y + 4)
	end

	local function tog(c, label, def, cb)
		local on = def or false
		local row = new("Frame", { BackgroundTransparency = 1 }, c.f)
		new("TextLabel", {
			Text = label, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
			BackgroundTransparency = 1, Size = UDim2.new(1, -46, 1, 0), TextXAlignment = Enum.TextXAlignment.Left,
		}, row)
		local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, row)
		local track = new("Frame", { Size = UDim2.fromOffset(30, 16), Position = UDim2.new(1, -30, 0.5, -8), BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0 }, row)
		corner(track, 8)
		local knob = new("Frame", { Size = UDim2.fromOffset(12, 12), Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = C.text, BorderSizePixel = 0 }, track)
		corner(knob, 6)
		local function apply(v)
			on = v
			track.BackgroundColor3 = v and C.pur or Color3.fromRGB(42, 41, 56)
			knob.Position = v and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
			local o, e = pcall(cb, v)
			if not o then note(e, "bad") end
		end
		hit.MouseButton1Click:Connect(function() apply(not on) end)
		inCard(c, row, 24)
		return { set = apply }
	end

	local function sld(c, label, min, max, def, cb)
		local row = new("Frame", { BackgroundTransparency = 1 }, c.f)
		local lbl = new("TextLabel", {
			Text = label, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
			BackgroundTransparency = 1, Size = UDim2.new(1, -40, 0, 14), TextXAlignment = Enum.TextXAlignment.Left,
		}, row)
		local val = new("TextLabel", {
			Text = tostring(def), Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.dim,
			BackgroundTransparency = 1, Size = UDim2.fromOffset(36, 14), Position = UDim2.new(1, -36, 0, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
		}, row)
		local track = new("Frame", { Size = UDim2.new(1, 0, 0, 4), Position = UDim2.fromOffset(0, 20), BackgroundColor3 = Color3.fromRGB(42, 41, 56), BorderSizePixel = 0 }, row)
		corner(track, 2)
		local fill = new("Frame", { Size = UDim2.new((def - min) / (max - min), 0, 1, 0), BackgroundColor3 = C.pur, BorderSizePixel = 0 }, track)
		corner(fill, 2)
		grad(fill, C.pur, C.blue, 0)
		local held = false
		local function set(a)
			a = math.clamp(a, 0, 1)
			fill.Size = UDim2.new(a, 0, 1, 0)
			local v = math.floor(min + (max - min) * a + 0.5)
			val.Text = tostring(v)
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
		inCard(c, row, 30)
		return { set = function(v) set((v - min) / (max - min)) end }
	end

	local function btn(c, label, cb, wide)
		local b = new("TextButton", {
			Text = label, Font = Enum.Font.GothamSemibold, TextSize = 11, TextColor3 = C.text,
			BackgroundColor3 = C.card2, AutoButtonColor = false, BorderSizePixel = 0,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}, c.f)
		corner(b, 8)
		b.MouseEnter:Connect(function()
			b.BackgroundColor3 = C.pur2
			b.TextColor3 = Color3.new(1, 1, 1)
		end)
		b.MouseLeave:Connect(function()
			b.BackgroundColor3 = C.card2
			b.TextColor3 = C.text
		end)
		b.MouseButton1Click:Connect(function()
			local o, e = pcall(cb)
			if not o then note(e, "bad") end
		end)
		inCard(c, b, wide and 30 or 26)
	end

	local function chips(c, list, cols, cb)
		local rows = math.max(1, math.ceil(#list / cols))
		local g = new("Frame", { BackgroundTransparency = 1 }, c.f)
		new("UIGridLayout", { CellSize = UDim2.new(1 / cols, -3, 0, 24), CellPadding = UDim.new(0, 3, 0, 3) }, g)
		for _, n in ipairs(list) do
			local b = new("TextButton", {
				Text = n, Font = Enum.Font.GothamMedium, TextSize = 9, TextColor3 = C.text,
				BackgroundColor3 = C.card2, AutoButtonColor = false, BorderSizePixel = 0,
				TextTruncate = Enum.TextTruncate.AtEnd,
			}, g)
			corner(b, 6)
			b.MouseButton1Click:Connect(function()
				local o, e = pcall(cb, n)
				if not o then note(e, "bad") end
			end)
		end
		inCard(c, g, rows * 27)
	end

	--==================== PÁGINAS ====================
	local pgMain = newPage("Principal")
	local c1 = addCard(pgMain, 1, "Auto Farm")
	tog(c1, "Auto Farm", false, function(v) S.farm = v end)
	tog(c1, "Auto Baú", false, function(v) S.chest = v end)
	tog(c1, "Auto Coletar Fruta", false, function(v) S.collect = v end)
	sld(c1, "Alcance", 20, 500, 130, function(v) S.range = v end)
	local c2 = addCard(pgMain, 2, "Player")
	tog(c2, "God Mode", false, function(v) S.god = v; stats() end)
	tog(c2, "Pulo Infinito", false, function(v) S.infJ = v end)
	tog(c2, "Noclip", false, function(v) setNoclip(v) end)
	sld(c2, "WalkSpeed", 16, 400, 40, function(v) S.speed = v end)
	sld(c2, "JumpPower", 50, 500, 50, function(v)
		S.jH = v
		S.jOn = true
	end)
	local c3 = addCard(pgMain, 1, "Visual")
	tog(c3, "ESP Players", false, function(v) E.on = v; if not v then clearEsp() end end)
	tog(c3, "Mostrar Nomes", true, function(v) E.nm = v; clearEsp() end)
	tog(c3, "Mostrar Distância", true, function(v) E.ln = v; clearEsp() end)
	local c4 = addCard(pgMain, 2, "Teleporte")
	local QUICK = {
		{ "Marineford", Vector3.new(1000, 5, 2500) },
		{ "Sky Island", Vector3.new(-7863, 5545, -378) },
		{ "Ilha Admin", Vector3.new(0, 5, -10000) },
	}
	for _, q in ipairs(QUICK) do btn(c4, q[1], function() flyTo(q[2], q[1]) end, true) end

	local pgFarm = newPage("Farm")
	local f1 = addCard(pgFarm, 1, "Farm")
	tog(f1, "Auto Farm", false, function(v) S.farm = v end)
	tog(f1, "Auto Baú", false, function(v) S.chest = v end)
	tog(f1, "Auto Coletar Fruta", false, function(v) S.collect = v end)
	tog(f1, "Ataque Contínuo", false, function(v) S.atk = v end)
	sld(f1, "Alcance", 20, 500, 130, function(v) S.range = v end)
	local f2 = addCard(pgFarm, 2, "Ações")
	btn(f2, "Ir até NPC próximo", function()
		local t = nearestNpc(600)
		if t then flyTo(t.Position, "NPC") else note("nenhum NPC", "bad") end
	end, true)
	btn(f2, "Curar", function()
		local h = hum()
		if h then h.Health = h.MaxHealth end
	end, true)
	btn(f2, "Resetar personagem", function()
		local h = hum()
		if h then h.Health = 0 end
	end, true)

	local pgPlayer = newPage("Player")
	local p1 = addCard(pgPlayer, 1, "Movimento")
	sld(p1, "WalkSpeed", 16, 400, 40, function(v) S.speed = v end)
	sld(p1, "JumpPower", 50, 500, 50, function(v) S.jH = v; S.jOn = true end)
	sld(p1, "Pulos por salto", 1, 10, 1, function(v)
		S.multi = v
		jumpN = v - 1
	end)
	tog(p1, "Pulo Infinito", false, function(v) S.infJ = v end)
	tog(p1, "Noclip", false, function(v) setNoclip(v) end)
	local p2 = addCard(pgPlayer, 2, "Voo")
	tog(p2, "Voo", false, function(v) setFly(v) end)
	sld(p2, "Velocidade horizontal", 10, 400, 80, function(v) S.flyH = v end)
	sld(p2, "Velocidade vertical", 10, 400, 60, function(v) S.flyV = v end)
	tog(p2, "Travar altitude", false, function(v) S.lock = v end)
	local p3 = addCard(pgPlayer, 1, "Vida")
	tog(p3, "God Mode", false, function(v) S.god = v; stats() end)
	sld(p3, "Hitbox", 1, 5, 1, function(v)
		local r = root()
		if r then r.Size = Vector3.new(2 * v, 2 * v, v) end
	end)

	local pgVisual = newPage("Visual")
	local v1 = addCard(pgVisual, 1, "ESP")
	tog(v1, "ESP ativo", false, function(v) E.on = v; if not v then clearEsp() end end)
	tog(v1, "Players", true, function(v) E.plr = v; clearEsp() end)
	tog(v1, "Caixa", true, function(v) E.box = v; clearEsp() end)
	tog(v1, "Nomes", true, function(v) E.nm = v; clearEsp() end)
	tog(v1, "Vida", true, function(v) E.hp = v; clearEsp() end)
	tog(v1, "Esqueleto", true, function(v) E.sk = v; clearEsp() end)
	tog(v1, "Linha", true, function(v) E.ln = v; clearEsp() end)
	tog(v1, "Ignorar time", false, function(v) E.team = v; clearEsp() end)
	sld(v1, "Distância máx.", 50, 3000, 1000, function(v) E.dist = v end)
	local v2 = addCard(pgVisual, 2, "Cena")
	tog(v2, "ESP frutas", false, function(v) E.fr = v; clearEsp() end)
	tog(v2, "ESP baús", false, function(v) E.chest = v; clearEsp() end)
	tog(v2, "Full bright", false, function(v) setBright(v) end)
	tog(v2, "Anti AFK", false, function(v) antiAfk = v end)
	sld(v2, "Camera FOV", 30, 120, 70, function(v)
		local c = cam()
		if c then c.FieldOfView = v end
	end)

	local pgTP = newPage("Teleporte")
	local PLACES = {
		{ "Primeiro Mar", { { "Vendedor", Vector3.new(0, 5, 0) }, { "Marineford", Vector3.new(1000, 5, 2500) }, { "Amazon Lily", Vector3.new(-3000, 5, 2500) }, { "Sky Island", Vector3.new(-7863, 5545, -378) } } },
		{ "Segundo Mar", { { "Coliseu", Vector3.new(-5000, 5, 0) }, { "Navio", Vector3.new(0, 5, -4000) }, { "Castelo", Vector3.new(-3000, 5, -4000) }, { "Café", Vector3.new(-386, 74, -314) } } },
		{ "Terceiro Mar", { { "Egghead", Vector3.new(6000, 5, 6000) }, { "Mansão", Vector3.new(6000, 5, -6000) }, { "Hydra", Vector3.new(-8000, 5, 0) }, { "Árvore", Vector3.new(-1055, 328, -8916) } } },
		{ "Admin", { { "Ilha Admin", Vector3.new(0, 5, -10000) }, { "Sala Admin", Vector3.new(0, 5, -12500) }, { "Sala Dev", Vector3.new(0, 1000, -15000) }, { "Vazio", Vector3.new(0, 3000, 0) } } },
	}
	local tcol = 1
	for _, g in ipairs(PLACES) do
		local cardT = addCard(pgTP, tcol, g[1])
		for _, e in ipairs(g[2]) do btn(cardT, e[1], function() flyTo(e[2], e[1]) end, true) end
		tcol = tcol == 1 and 2 or 1
	end
	local tpP = addCard(pgTP, tcol, "Jogadores")
	btn(tpP, "Trazer todos", function()
		local r = root()
		if not r then return end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.CFrame = r.CFrame * CFrame.new(0, 0, -4) end
			end
		end
	end, true)
	btn(tpP, "Salvar waypoint", function()
		local r = root()
		if not r then return end
		table.insert(R.Wp, { "wp" .. (#R.Wp + 1), r.Position })
		note("waypoint salvo", "good")
	end, true)

	local pgFruta = newPage("Frutas")
	local modCard = addCard(pgFruta, 1, "Modo")
	for _, m in ipairs({ { "dealer", "Comprar" }, { "gacha", "Sorteio" }, { "chao", "No chão" } }) do
		btn(modCard, m[2], function()
			mode = m[1]
			note("modo: " .. m[2])
		end, true)
	end
	btn(modCard, "Processar todas", function()
		local all = {}
		for _, g in ipairs(GROUPS) do
			for _, n in ipairs(g[2]) do table.insert(all, n) end
		end
		for _, n in ipairs(all) do
			oneFruit(n)
			task.wait(mode == "chao" and 0.05 or 0.5)
		end
	end, true)
	btn(modCard, "Limpar do chão", function()
		for _, f in ipairs(R.Spawned) do if f.Parent then f:Destroy() end end
		R.Spawned = {}
	end, true)
	local col = 2
	for _, g in ipairs(GROUPS) do
		local cg = addCard(pgFruta, col, g[1])
		chips(cg, g[2], 2, function(n) oneFruit(n) end)
		col = col == 1 and 2 or 1
	end

	local pgAdmin = newPage("Admin")
	local a1 = addCard(pgAdmin, 1, "Servidor")
	btn(a1, "Congelar todos", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.Anchored = true end
			end
		end
	end, true)
	btn(a1, "Descongelar todos", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.Anchored = false end
			end
		end
	end, true)
	btn(a1, "Arremessar todos", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then
					rr.Anchored = false
					rr.AssemblyLinearVelocity = Vector3.new(math.random(-500, 500), 700, math.random(-500, 500))
				end
			end
		end
	end, true)
	btn(a1, "Expulsar do mapa", function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and p.Character then
				local rr = p.Character:FindFirstChild("HumanoidRootPart")
				if rr then rr.CFrame = CFrame.new(0, -800, 0) end
			end
		end
	end, true)
	local a2 = addCard(pgAdmin, 2, "Progresso")
	btn(a2, "Level 3000", function()
		local d = Player:FindFirstChild("Data")
		local l = d and d:FindFirstChild("Level")
		if l then l.Value = 3000 end
	end, true)
	btn(a2, "Beli 1M", function()
		local d = Player:FindFirstChild("Data")
		local b = d and d:FindFirstChild("Beli")
		if b then b.Value = 1000000 end
	end, true)
	btn(a2, "Buso", function() invokeLog("BuyHaki", "Buso") end, true)
	btn(a2, "Geppo", function() invokeLog("BuyHaki", "Geppo") end, true)
	btn(a2, "Despertar", function() invokeLog("Awaken") end, true)
	btn(a2, "Pirata", function() invokeLog("SetTeam", "Pirates") end, true)
	btn(a2, "Marinha", function() invokeLog("SetTeam", "Marines") end, true)
	btn(a2, "Rejoin", function()
		pcall(function() Teleport:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
	end, true)

	local pgStatus = newPage("Status")
	local s1 = addCard(pgStatus, 1, "Servidor")
	local info = new("TextLabel", {
		Text = "—", Font = Enum.Font.Code, TextSize = 10, TextColor3 = C.dim,
		BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 70), TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, s1.f)
	inCard(s1, info, 70)
	local s2 = addCard(pgStatus, 2, "Log")
	local lh = new("Frame", { BackgroundColor3 = C.card2 }, s2.f)
	corner(lh, 8)
	pad(lh, 6, 6, 6, 8)
	logBox = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, lh)
	inCard(s2, lh, 190)
	task.spawn(function()
		while alive() do
			local ping = 0
			pcall(function()
				ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			info.Text = "jogadores " .. #Players:GetPlayers() .. "\nping " .. ping ..
				" ms\nuptime " .. math.floor(os.clock() - R.T0) .. "s\nok " .. R.ok .. "  falhas " .. R.fail
			task.wait(1)
		end
	end)

	showPage("Principal")
	log("painel iniciado", "ok")
end

--==================== LAUNCHER ========================================
local function buildLauncher()
	for _, c in ipairs(LList:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, g in ipairs(GAMES) do
		local b = new("TextButton", {
			Text = "", BackgroundColor3 = C.card, Size = UDim2.new(1, 0, 0, 62),
			AutoButtonColor = false, BorderSizePixel = 0,
		}, LList)
		corner(b, 11)
		stroke(b, C.line, 1, 0.55)
		new("TextLabel", {
			Text = g.name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.text,
			BackgroundTransparency = 1, Size = UDim2.new(1, -90, 0, 18), Position = UDim2.fromOffset(14, 12),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, b)
		new("TextLabel", {
			Text = g.sub, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = C.mute,
			BackgroundTransparency = 1, Size = UDim2.new(1, -90, 0, 14), Position = UDim2.fromOffset(14, 32),
			TextXAlignment = Enum.TextXAlignment.Left,
		}, b)
		local tag = new("Frame", {
			Size = UDim2.fromOffset(62, 20), Position = UDim2.new(1, -74, 0, 21),
			BackgroundColor3 = g.ready and C.pur or C.card2, BorderSizePixel = 0,
		}, b)
		corner(tag, 6)
		new("TextLabel", {
			Text = g.ready and "ONLINE" or "EM BREVE", Font = Enum.Font.GothamBold, TextSize = 8,
			TextColor3 = g.ready and Color3.new(1, 1, 1) or C.mute, BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, tag)
		b.MouseEnter:Connect(function() b.BackgroundColor3 = C.hover end)
		b.MouseLeave:Connect(function() b.BackgroundColor3 = C.card end)
		b.MouseButton1Click:Connect(function()
			if not g.ready then
				note(g.name .. " — em breve", "bad")
				toggleLauncher(true)
				return
			end
			Launcher.Visible = false
			bootBlox()
			note(g.name .. " carregado", "good")
		end)
	end
	LList.CanvasSize = UDim2.fromOffset(0, #GAMES * 69 + 4)
end

buildLauncher()
note("escolha um jogo", "good")
