--[[
    Hava-lib v2.0
    تصميم مستوحى من Rayfield UI
    - مدمج وأنيق
    - شريط جانبي أيقونات
    - ثيم داكن مع ألوان بنفسجية
]]

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ========== الثيم ==========
Library.Theme = {
    Background   = Color3.fromRGB(20, 20, 25),
    Sidebar      = Color3.fromRGB(15, 15, 20),
    Card         = Color3.fromRGB(30, 30, 38),
    Element      = Color3.fromRGB(38, 38, 48),
    Hover        = Color3.fromRGB(48, 48, 60),
    Accent       = Color3.fromRGB(138, 43, 226),  -- بنفسجي Rayfield
    AccentAlt    = Color3.fromRGB(90, 30, 180),
    Text         = Color3.fromRGB(240, 240, 245),
    SubText      = Color3.fromRGB(150, 150, 170),
    Success      = Color3.fromRGB(0, 200, 110),
    Danger       = Color3.fromRGB(220, 60, 60),
    Stroke       = Color3.fromRGB(50, 50, 65),
    Font         = Enum.Font.GothamMedium,
    FontBold     = Enum.Font.GothamBold,
}

-- ========== مساعدات ==========
local function create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

local function corner(p, r)
    return create("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p })
end

local function stroke(p, c, t)
    return create("UIStroke", {
        Color = c or Library.Theme.Stroke,
        Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = p
    })
end

local function pad(p, val)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, val),
        PaddingBottom = UDim.new(0, val),
        PaddingLeft = UDim.new(0, val),
        PaddingRight = UDim.new(0, val),
        Parent = p
    })
end

local function tween(obj, time, props, style)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quart), props):Play()
end

-- ========== إنشاء النافذة ==========
function Library.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Library)
    self.Title = cfg.Title or "Hava-lib"
    self.Subtitle = cfg.Subtitle or ""
    self.Icon = cfg.Icon or "⚡"
    self.Size = cfg.Size or UDim2.new(0, 460, 0, 280)
    self.Minimized = true
    self.Tabs = {}
    self.CurrentTab = nil
    self.Open = false
    
    self.ScreenGui = create("ScreenGui", {
        Name = "HavaLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    self:_createToggle()
    self:_createWindow()
    
    return self
end

-- ========== زر التفعيل ==========
function Library:_createToggle()
    local btn = create("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0, 15, 0.5, -22),
        BackgroundColor3 = Library.Theme.Background,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    corner(btn, 22)
    stroke(btn, Library.Theme.Accent, 2)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Icon,
        TextColor3 = Library.Theme.Accent,
        TextSize = 20,
        Font = Library.Theme.FontBold,
        Parent = btn
    })
    
    -- سحب
    local dragging, dragStart, startPos = false, nil, nil
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
           or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                     startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    
    local moved = false
    btn.MouseButton1Down:Connect(function() moved = false end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement 
           or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then moved = true end
        end
    end)
    btn.MouseButton1Click:Connect(function()
        if not moved then self:Toggle() end
    end)
    
    self.ToggleBtn = btn
end

-- ========== النافذة الرئيسية ==========
function Library:_createWindow()
    local win = create("Frame", {
        Name = "Window",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    corner(win, 10)
    stroke(win, Library.Theme.Accent, 1.5)
    self.Window = win
    
    -- الشريط الجانبي
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 130, 1, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = win
    })
    corner(sidebar, 10)
    create("Frame", {
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = sidebar
    })
    
    -- الترويسة في الشريط الجانبي
    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = sidebar
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Library.Theme.Accent,
        TextSize = 14,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 12, 0, 30),
        BackgroundTransparency = 1,
        Text = self.Subtitle,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- حاوية التبويبات
    local tabHolder = create("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(1, -12, 1, -70),
        Position = UDim2.new(0, 6, 0, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabHolder
    })
    self.TabHolder = tabHolder
    
    -- منطقة المحتوى
    local content = create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -140, 1, -20),
        Position = UDim2.new(0, 134, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = win
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = content
    })
    self.Content = content
    
    -- زر الإغلاق
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -28, 0, 6),
        BackgroundColor3 = Library.Theme.Danger,
        Text = "✕",
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = win
    })
    corner(closeBtn, 11)
    closeBtn.MouseButton1Click:Connect(function() self:Close() end)
    
    -- السحب من الترويسة
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
        end
    end)
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
           or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                     startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ========== فتح/إغلاق ==========
function Library:Open()
    self.Open = true
    self.Window.Visible = true
    self.Window.Size = UDim2.new(0, 0, 0, 0)
    tween(self.Window, 0.3, { Size = self.Size }, Enum.EasingStyle.Back)
end

function Library:Close()
    self.Open = false
    tween(self.Window, 0.2, { Size = UDim2.new(0, 0, 0, 0) })
    task.delay(0.2, function() self.Window.Visible = false end)
end

function Library:Toggle()
    if self.Open then self:Close() else self:Open() end
end

-- ========== إضافة تبويب ==========
function Library:AddTab(name, icon)
    local tab = { Name = name, Elements = {} }
    
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Library.Theme.Element,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Parent = self.TabHolder
    })
    corner(btn, 6)
    
    -- مؤشر جانبي
    local indicator = create("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Parent = btn
    })
    corner(indicator, 2)
    
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = (icon and icon .. "  " or "") .. name,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })
    
    tab.Button = btn
    tab.Label = lbl
    tab.Indicator = indicator
    
    local page = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = page
    })
    tab.Page = page
    
    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            tween(btn, 0.15, { BackgroundTransparency = 0.5 })
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            tween(btn, 0.15, { BackgroundTransparency = 1 })
        end
    end)
    btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    
    table.insert(self.Tabs, tab)
    if not self.CurrentTab then self:SelectTab(tab) end
    return tab
end

function Library:SelectTab(tab)
    if self.CurrentTab == tab then return end
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
        tween(t.Button, 0.15, { BackgroundTransparency = 1 })
        tween(t.Label, 0.15, { TextColor3 = Library.Theme.SubText })
        tween(t.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 0) })
    end
    tab.Page.Visible = true
    tween(tab.Button, 0.15, { BackgroundTransparency = 0 })
    tab.Button.BackgroundColor3 = Library.Theme.Element
    tween(tab.Label, 0.15, { TextColor3 = Library.Theme.Text })
    tween(tab.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 16) })
    self.CurrentTab = tab
end

-- ========== قسم ==========
function Library:AddSection(tab, text)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text:upper(),
        TextColor3 = Library.Theme.Accent,
        TextSize = 10,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
end

-- ========== Toggle ==========
function Library:AddToggle(tab, label, default, callback)
    local state = default or false
    
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 6)
    
    create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    -- مؤشر صغير
    local dot = create("Frame", {
        Size = UDim2.new(0, 32, 0, 16),
        Position = UDim2.new(1, -42, 0.5, -8),
        BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = container
    })
    corner(dot, 8)
    
    local knob = create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = dot
    })
    corner(knob, 6)
    
    local hit = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = container
    })
    
    hit.MouseButton1Click:Connect(function()
        state = not state
        tween(dot, 0.15, { BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element })
        tween(knob, 0.2, { Position = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) })
        if callback then callback(state) end
    end)
    
    return { Set = function(v)
        state = v
        dot.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element
        knob.Position = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(state) end
    end }
end

-- ========== Dropdown ==========
function Library:AddDropdown(tab, label, options, default, callback)
    local current = default or options[1]
    local expanded = false
    
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Page
    })
    corner(container, 6)
    
    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    local valBtn = create("TextButton", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 10, 0, 22),
        BackgroundColor3 = Library.Theme.Element,
        Text = tostring(current) .. "  ▾",
        TextColor3 = Library.Theme.Text,
        TextSize = 11,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        Parent = container
    })
    corner(valBtn, 4)
    
    local listFrame = create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 48),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        Parent = container
    })
    corner(listFrame, 4)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = listFrame
    })
    pad(listFrame, 3)
    
    valBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        listFrame.Visible = expanded
        if expanded then
            listFrame.Size = UDim2.new(1, -20, 0, #options * 20 + 8)
            tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 50 + #options * 20 + 12) })
        else
            listFrame.Size = UDim2.new(1, -20, 0, 0)
            tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 50) })
        end
    end)
    
    for i, opt in ipairs(options) do
        local oBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundColor3 = Library.Theme.Element,
            Text = tostring(opt),
            TextColor3 = Library.Theme.Text,
            TextSize = 11,
            Font = Library.Theme.Font,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Parent = listFrame
        })
        corner(oBtn, 3)
        oBtn.MouseEnter:Connect(function()
            tween(oBtn, 0.1, { BackgroundColor3 = Library.Theme.Hover })
        end)
        oBtn.MouseLeave:Connect(function()
            oBtn.BackgroundColor3 = Library.Theme.Element
        end)
        oBtn.MouseButton1Click:Connect(function()
            current = opt
            valBtn.Text = tostring(opt) .. "  ▾"
            expanded = false
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, -20, 0, 0)
            tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 50) })
            if callback then callback(opt) end
        end)
    end
    
    return { Set = function(v)
        current = v
        valBtn.Text = tostring(v) .. "  ▾"
        if callback then callback(v) end
    end }
end

-- ========== Input ==========
function Library:AddInput(tab, label, default, isNumber, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 6)
    
    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    local box = create("TextBox", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 10, 0, 22),
        BackgroundColor3 = Library.Theme.Element,
        Text = tostring(default or ""),
        TextColor3 = Library.Theme.Text,
        PlaceholderText = isNumber and "0" or "...",
        PlaceholderColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Parent = container
    })
    corner(box, 4)
    
    box.FocusLost:Connect(function()
        if isNumber then
            local n = tonumber(box.Text)
            if n then
                if callback then callback(n) end
            else
                box.Text = tostring(default or 0)
            end
        else
            if callback then callback(box.Text) end
        end
    end)
    
    return { Set = function(v)
        box.Text = tostring(v)
        if callback then callback(v) end
    end }
end

-- ========== Button ==========
function Library:AddButton(tab, label, callback, color)
    color = color or Library.Theme.Accent
    
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = color,
        Text = label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(btn, 6)
    
    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2) })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color })
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return btn
end

-- ========== Divider ==========
function Library:AddDivider(tab)
    return create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Library.Theme.Stroke,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
end

-- ========== Label ==========
function Library:AddLabel(tab, text)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundColor3 = Library.Theme.Card,
        Text = text,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
end

-- ========== اختصار ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name == "HavaLib" then
                -- سيتم تفعيله من النافذة الرئيسية
            end
        end
    end
end)

return Library
