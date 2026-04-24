local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer
local mouse = lp:GetMouse()

local lib = {}
lib.tabs = {}
lib.activeTab = nil
lib.open = false
lib.connections = {}
lib.colorpickers = {}

local accentColor = Color3.fromRGB(0, 191, 255)
local bgColor = Color3.fromRGB(18, 18, 22)
local secondBg = Color3.fromRGB(24, 24, 30)
local thirdBg = Color3.fromRGB(30, 30, 38)
local borderColor = Color3.fromRGB(45, 45, 55)
local textColor = Color3.fromRGB(210, 210, 220)
local dimText = Color3.fromRGB(120, 120, 135)
local toggleOn = Color3.fromRGB(0, 191, 255)
local toggleOff = Color3.fromRGB(55, 55, 68)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DopamineUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 420, 0, 310)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -155)
mainFrame.BackgroundColor3 = bgColor
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 4)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = borderColor
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = secondBg
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 4)
topCorner.Parent = topBar

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0.5, 0)
topFix.Position = UDim2.new(0, 0, 0.5, 0)
topFix.BackgroundColor3 = secondBg
topFix.BorderSizePixel = 0
topFix.Parent = topBar

local accentLine = Instance.new("Frame")
accentLine.Name = "AccentLine"
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 0, 0)
accentLine.BackgroundColor3 = accentColor
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 5
accentLine.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "dopamine.wtf"
titleLabel.TextColor3 = accentColor
titleLabel.Font = Enum.Font.Code
titleLabel.TextSize = 13
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.ZIndex = 2
titleLabel.Parent = topBar

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(0, 90, 1, -34)
tabBar.Position = UDim2.new(0, 0, 0, 34)
tabBar.BackgroundColor3 = secondBg
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabBarStroke = Instance.new("UIStroke")
tabBarStroke.Color = borderColor
tabBarStroke.Thickness = 1
tabBarStroke.Parent = tabBar

local tabList = Instance.new("UIListLayout")
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 2)
tabList.Parent = tabBar

local tabPad = Instance.new("UIPadding")
tabPad.PaddingTop = UDim.new(0, 4)
tabPad.PaddingLeft = UDim.new(0, 4)
tabPad.PaddingRight = UDim.new(0, 4)
tabPad.Parent = tabBar

local contentArea = Instance.new("Frame")
contentArea.Name = "Content"
contentArea.Size = UDim2.new(1, -94, 1, -36)
contentArea.Position = UDim2.new(0, 94, 0, 34)
contentArea.BackgroundColor3 = bgColor
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = mainFrame

local dragging = false
local dragStart = nil
local startPos = nil

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

topBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

uis.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

local function makeScroll(parent)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = accentColor
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 3)
	layout.Parent = scroll

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 6)
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 6)
	pad.Parent = scroll

	return scroll
end

function lib:AddTab(name)
	local tabData = { name = name, content = nil, button = nil, elements = {} }

	local tabBtn = Instance.new("TextButton")
	tabBtn.Name = name
	tabBtn.Size = UDim2.new(1, 0, 0, 26)
	tabBtn.BackgroundColor3 = thirdBg
	tabBtn.BorderSizePixel = 0
	tabBtn.Text = name
	tabBtn.TextColor3 = dimText
	tabBtn.Font = Enum.Font.Code
	tabBtn.TextSize = 11
	tabBtn.AutoButtonColor = false
	tabBtn.LayoutOrder = #lib.tabs + 1
	tabBtn.Parent = tabBar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 3)
	btnCorner.Parent = tabBtn

	local tabContent = Instance.new("Frame")
	tabContent.Name = name .. "Content"
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.Visible = false
	tabContent.Parent = contentArea

	local scroll = makeScroll(tabContent)
	tabData.scroll = scroll
	tabData.button = tabBtn
	tabData.content = tabContent

	tabBtn.MouseButton1Click:Connect(function()
		lib:SelectTab(tabData)
	end)

	table.insert(lib.tabs, tabData)

	if #lib.tabs == 1 then
		lib:SelectTab(tabData)
	end

	return tabData
end

function lib:SelectTab(tabData)
	for _, t in ipairs(lib.tabs) do
		t.content.Visible = false
		t.button.BackgroundColor3 = thirdBg
		t.button.TextColor3 = dimText
	end
	tabData.content.Visible = true
	tabData.button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	tabData.button.TextColor3 = accentColor
	lib.activeTab = tabData
end

local function makeBase(scroll, height)
	local base = Instance.new("Frame")
	base.Size = UDim2.new(1, -2, 0, height)
	base.BackgroundColor3 = secondBg
	base.BorderSizePixel = 0
	base.Parent = scroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 3)
	corner.Parent = base

	return base
end

function lib:AddLabel(tab, text)
	local base = makeBase(tab.scroll, 22)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -8, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = dimText
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = base

	return lbl
end

function lib:AddDivider(tab)
	local base = makeBase(tab.scroll, 14)
	base.BackgroundTransparency = 1

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -8, 0, 1)
	line.Position = UDim2.new(0, 4, 0.5, 0)
	line.BackgroundColor3 = borderColor
	line.BorderSizePixel = 0
	line.Parent = base

	return base
end

function lib:AddToggle(tab, text, default, callback)
	local state = default or false
	local base = makeBase(tab.scroll, 28)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -50, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = textColor
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = base

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 30, 0, 14)
	track.Position = UDim2.new(1, -38, 0.5, -7)
	track.BackgroundColor3 = state and toggleOn or toggleOff
	track.BorderSizePixel = 0
	track.Parent = base

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 10, 0, 10)
	knob.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 2
	knob.Parent = track

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.ZIndex = 3
	btn.Parent = base

	btn.MouseButton1Click:Connect(function()
		state = not state
		track.BackgroundColor3 = state and toggleOn or toggleOff
		knob.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		if callback then callback(state) end
	end)

	local toggleObj = {}
	function toggleObj:Set(val)
		state = val
		track.BackgroundColor3 = state and toggleOn or toggleOff
		knob.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
		if callback then callback(state) end
	end
	function toggleObj:Get() return state end

	return toggleObj
end

function lib:AddButton(tab, text, callback)
	local base = makeBase(tab.scroll, 28)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 1, -6)
	btn.Position = UDim2.new(0, 4, 0, 3)
	btn.BackgroundColor3 = thirdBg
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = textColor
	btn.Font = Enum.Font.Code
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.Parent = base

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 3)
	btnCorner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = borderColor
	stroke.Thickness = 1
	stroke.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		stroke.Color = accentColor
	end)

	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = thirdBg
		stroke.Color = borderColor
	end)

	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return btn
end

function lib:AddSlider(tab, text, min, max, default, callback)
	local val = default or min
	local base = makeBase(tab.scroll, 40)

	local topRow = Instance.new("Frame")
	topRow.Size = UDim2.new(1, -8, 0, 18)
	topRow.Position = UDim2.new(0, 4, 0, 3)
	topRow.BackgroundTransparency = 1
	topRow.Parent = base

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.7, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = textColor
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = topRow

	local valLbl = Instance.new("TextLabel")
	valLbl.Size = UDim2.new(0.3, 0, 1, 0)
	valLbl.Position = UDim2.new(0.7, 0, 0, 0)
	valLbl.BackgroundTransparency = 1
	valLbl.Text = tostring(val)
	valLbl.TextColor3 = accentColor
	valLbl.Font = Enum.Font.Code
	valLbl.TextSize = 11
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.Parent = topRow

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -8, 0, 4)
	track.Position = UDim2.new(0, 4, 0, 28)
	track.BackgroundColor3 = thirdBg
	track.BorderSizePixel = 0
	track.Parent = base

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = accentColor
	fill.BorderSizePixel = 0
	fill.ZIndex = 2
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local hitbox = Instance.new("TextButton")
	hitbox.Size = UDim2.new(1, 0, 0, 14)
	hitbox.Position = UDim2.new(0, 0, 0.5, -7)
	hitbox.BackgroundTransparency = 1
	hitbox.Text = ""
	hitbox.ZIndex = 3
	hitbox.Parent = track

	local sliding = false

	local function update(x)
		local trackAbs = track.AbsolutePosition
		local trackSize = track.AbsoluteSize
		local rel = math.clamp((x - trackAbs.X) / trackSize.X, 0, 1)
		val = math.floor(min + rel * (max - min) + 0.5)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		valLbl.Text = tostring(val)
		if callback then callback(val) end
	end

	hitbox.MouseButton1Down:Connect(function()
		sliding = true
		update(mouse.X)
	end)

	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = false
		end
	end)

	rs.RenderStepped:Connect(function()
		if sliding then
			update(mouse.X)
		end
	end)

	local sliderObj = {}
	function sliderObj:Set(v)
		val = math.clamp(v, min, max)
		local rel = (val - min) / (max - min)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		valLbl.Text = tostring(val)
		if callback then callback(val) end
	end
	function sliderObj:Get() return val end

	return sliderObj
end

function lib:AddDropdown(tab, text, options, default, callback)
	local selected = default or options[1]
	local open = false
	local base = makeBase(tab.scroll, 28)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.45, 0, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = textColor
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = base

	local box = Instance.new("Frame")
	box.Size = UDim2.new(0, 100, 0, 20)
	box.Position = UDim2.new(1, -108, 0.5, -10)
	box.BackgroundColor3 = thirdBg
	box.BorderSizePixel = 0
	box.ZIndex = 2
	box.Parent = base

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 3)
	boxCorner.Parent = box

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = borderColor
	boxStroke.Thickness = 1
	boxStroke.Parent = box

	local selectedLbl = Instance.new("TextLabel")
	selectedLbl.Size = UDim2.new(1, -16, 1, 0)
	selectedLbl.Position = UDim2.new(0, 5, 0, 0)
	selectedLbl.BackgroundTransparency = 1
	selectedLbl.Text = selected
	selectedLbl.TextColor3 = textColor
	selectedLbl.Font = Enum.Font.Code
	selectedLbl.TextSize = 11
	selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
	selectedLbl.ZIndex = 3
	selectedLbl.Parent = box

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 14, 1, 0)
	arrow.Position = UDim2.new(1, -16, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "v"
	arrow.TextColor3 = dimText
	arrow.Font = Enum.Font.Code
	arrow.TextSize = 10
	arrow.ZIndex = 3
	arrow.Parent = box

	local dropdown = Instance.new("Frame")
	dropdown.Size = UDim2.new(0, 100, 0, #options * 22)
	dropdown.Position = UDim2.new(1, -108, 1, 2)
	dropdown.BackgroundColor3 = thirdBg
	dropdown.BorderSizePixel = 0
	dropdown.ZIndex = 20
	dropdown.Visible = false
	dropdown.ClipsDescendants = true
	dropdown.Parent = base

	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 3)
	dropCorner.Parent = dropdown

	local dropStroke = Instance.new("UIStroke")
	dropStroke.Color = accentColor
	dropStroke.Thickness = 1
	dropStroke.Parent = dropdown

	local dropList = Instance.new("UIListLayout")
	dropList.SortOrder = Enum.SortOrder.LayoutOrder
	dropList.Parent = dropdown

	for i, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, 22)
		optBtn.BackgroundColor3 = thirdBg
		optBtn.BorderSizePixel = 0
		optBtn.Text = opt
		optBtn.TextColor3 = textColor
		optBtn.Font = Enum.Font.Code
		optBtn.TextSize = 11
		optBtn.AutoButtonColor = false
		optBtn.ZIndex = 21
		optBtn.LayoutOrder = i
		optBtn.Parent = dropdown

		optBtn.MouseEnter:Connect(function()
			optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
		end)

		optBtn.MouseLeave:Connect(function()
			optBtn.BackgroundColor3 = thirdBg
		end)

		optBtn.MouseButton1Click:Connect(function()
			selected = opt
			selectedLbl.Text = opt
			open = false
			dropdown.Visible = false
			base.Size = UDim2.new(1, -2, 0, 28)
			if callback then callback(opt) end
		end)
	end

	local openBtn = Instance.new("TextButton")
	openBtn.Size = UDim2.new(1, 0, 1, 0)
	openBtn.BackgroundTransparency = 1
	openBtn.Text = ""
	openBtn.ZIndex = 4
	openBtn.Parent = box

	openBtn.MouseButton1Click:Connect(function()
		open = not open
		dropdown.Visible = open
		if open then
			base.Size = UDim2.new(1, -2, 0, 28 + #options * 22 + 4)
		else
			base.Size = UDim2.new(1, -2, 0, 28)
		end
	end)

	local dropObj = {}
	function dropObj:Set(v)
		selected = v
		selectedLbl.Text = v
		if callback then callback(v) end
	end
	function dropObj:Get() return selected end

	return dropObj
end

function lib:AddColorPicker(tab, text, default, callback)
	local color = default or Color3.fromRGB(255, 255, 255)
	local open = false
	local base = makeBase(tab.scroll, 28)

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.6, 0, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = textColor
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = base

	local preview = Instance.new("Frame")
	preview.Size = UDim2.new(0, 20, 0, 16)
	preview.Position = UDim2.new(1, -28, 0.5, -8)
	preview.BackgroundColor3 = color
	preview.BorderSizePixel = 0
	preview.ZIndex = 2
	preview.Parent = base

	local prevCorner = Instance.new("UICorner")
	prevCorner.CornerRadius = UDim.new(0, 3)
	prevCorner.Parent = preview

	local prevStroke = Instance.new("UIStroke")
	prevStroke.Color = borderColor
	prevStroke.Thickness = 1
	prevStroke.Parent = preview

	local picker = Instance.new("Frame")
	picker.Size = UDim2.new(0, 160, 0, 110)
	picker.Position = UDim2.new(1, -168, 1, 2)
	picker.BackgroundColor3 = thirdBg
	picker.BorderSizePixel = 0
	picker.ZIndex = 25
	picker.Visible = false
	picker.Parent = base

	local pickerCorner = Instance.new("UICorner")
	pickerCorner.CornerRadius = UDim.new(0, 4)
	pickerCorner.Parent = picker

	local pickerStroke = Instance.new("UIStroke")
	pickerStroke.Color = accentColor
	pickerStroke.Thickness = 1
	pickerStroke.Parent = picker

	local h, s, v2 = Color3.toHSV(color)

	local svField = Instance.new("ImageLabel")
	svField.Size = UDim2.new(0, 130, 0, 80)
	svField.Position = UDim2.new(0, 6, 0, 6)
	svField.Image = "rbxassetid://4155801252"
	svField.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
	svField.ZIndex = 26
	svField.Parent = picker

	local svCorner = Instance.new("UICorner")
	svCorner.CornerRadius = UDim.new(0, 3)
	svCorner.Parent = svField

	local svKnob = Instance.new("Frame")
	svKnob.Size = UDim2.new(0, 8, 0, 8)
	svKnob.Position = UDim2.new(s, -4, 1 - v2, -4)
	svKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	svKnob.BorderSizePixel = 0
	svKnob.ZIndex = 28
	svKnob.Parent = svField

	local svKnobCorner = Instance.new("UICorner")
	svKnobCorner.CornerRadius = UDim.new(1, 0)
	svKnobCorner.Parent = svKnob

	local hueBar = Instance.new("ImageLabel")
	hueBar.Size = UDim2.new(0, 12, 0, 80)
	hueBar.Position = UDim2.new(0, 142, 0, 6)
	hueBar.Image = "rbxassetid://4155801232"
	hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hueBar.ZIndex = 26
	hueBar.Parent = picker

	local hueCorner = Instance.new("UICorner")
	hueCorner.CornerRadius = UDim.new(0, 3)
	hueCorner.Parent = hueBar

	local hueKnob = Instance.new("Frame")
	hueKnob.Size = UDim2.new(1, 2, 0, 3)
	hueKnob.Position = UDim2.new(0, -1, h, -1)
	hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hueKnob.BorderSizePixel = 0
	hueKnob.ZIndex = 27
	hueKnob.Parent = hueBar

	local hexLabel = Instance.new("TextBox")
	hexLabel.Size = UDim2.new(0, 130, 0, 16)
	hexLabel.Position = UDim2.new(0, 6, 0, 90)
	hexLabel.BackgroundColor3 = secondBg
	hexLabel.BorderSizePixel = 0
	hexLabel.Text = string.format("%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
	hexLabel.TextColor3 = textColor
	hexLabel.Font = Enum.Font.Code
	hexLabel.TextSize = 10
	hexLabel.ZIndex = 26
	hexLabel.Parent = picker

	local hexCorner = Instance.new("UICorner")
	hexCorner.CornerRadius = UDim.new(0, 2)
	hexCorner.Parent = hexLabel

	local function applyColor()
		color = Color3.fromHSV(h, s, v2)
		preview.BackgroundColor3 = color
		svField.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svKnob.Position = UDim2.new(s, -4, 1 - v2, -4)
		hueKnob.Position = UDim2.new(0, -1, h, -1)
		hexLabel.Text = string.format("%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
		if callback then callback(color) end
	end

	local draggingSV = false
	local draggingHue = false

	local svBtn = Instance.new("TextButton")
	svBtn.Size = UDim2.new(1, 0, 1, 0)
	svBtn.BackgroundTransparency = 1
	svBtn.Text = ""
	svBtn.ZIndex = 29
	svBtn.Parent = svField

	svBtn.MouseButton1Down:Connect(function()
		draggingSV = true
	end)

	local hueBtn = Instance.new("TextButton")
	hueBtn.Size = UDim2.new(1, 0, 1, 0)
	hueBtn.BackgroundTransparency = 1
	hueBtn.Text = ""
	hueBtn.ZIndex = 29
	hueBtn.Parent = hueBar

	hueBtn.MouseButton1Down:Connect(function()
		draggingHue = true
	end)

	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSV = false
			draggingHue = false
		end
	end)

	rs.RenderStepped:Connect(function()
		if draggingSV then
			local abs = svField.AbsolutePosition
			local sz = svField.AbsoluteSize
			s = math.clamp((mouse.X - abs.X) / sz.X, 0, 1)
			v2 = 1 - math.clamp((mouse.Y - abs.Y) / sz.Y, 0, 1)
			applyColor()
		end
		if draggingHue then
			local abs = hueBar.AbsolutePosition
			local sz = hueBar.AbsoluteSize
			h = math.clamp((mouse.Y - abs.Y) / sz.Y, 0, 1)
			applyColor()
		end
	end)

	local openBtn2 = Instance.new("TextButton")
	openBtn2.Size = UDim2.new(1, 0, 1, 0)
	openBtn2.BackgroundTransparency = 1
	openBtn2.Text = ""
	openBtn2.ZIndex = 3
	openBtn2.Parent = preview

	openBtn2.MouseButton1Click:Connect(function()
		open = not open
		picker.Visible = open
		if open then
			base.Size = UDim2.new(1, -2, 0, 142)
		else
			base.Size = UDim2.new(1, -2, 0, 28)
		end
	end)

	local cpObj = {}
	function cpObj:Set(c)
		color = c
		h, s, v2 = Color3.toHSV(c)
		applyColor()
	end
	function cpObj:Get() return color end

	return cpObj
end

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		lib.open = not lib.open
		mainFrame.Visible = lib.open
	end
	if input.KeyCode == Enum.KeyCode.Delete then
		mainFrame.Visible = false
		lib.open = false
		screenGui:Destroy()
	end
end)

return lib
