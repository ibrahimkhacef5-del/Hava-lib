--[[
    Hava-lib v3.0
    تصميم Rayfield + كل الميزات
    Author: You
]]

local Library = {}
Library.__index = Library

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ========== الثيم ==========
Library.Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar    = Color3.fromRGB(15, 15, 20),
    Card       = Color3.fromRGB(30, 30, 38),
    Element    = Color3.fromRGB(38, 38, 48),
    Hover      = Color3.fromRGB(48, 48, 60),
    Accent     = Color3.fromRGB(138, 43, 226),
    AccentAlt  = Color3.fromRGB(90, 30, 180),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(150, 150, 170),
    Success    = Color3.fromRGB(0, 200, 110),
    Danger     = Color3.fromRGB(220, 60, 60),
    Warning    = Color3.fromRGB(255, 170, 0),
    Stroke     = Color3.fromRGB(50, 50, 65),
    Font       = Enum.Font.GothamMedium,
    FontBold   = Enum.Font.GothamBold,
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

local function tween(o, t, p, s)
    TweenService:Create(o, TweenInfo.new(t or 0.18, s or Enum.EasingStyle.Quart), p):Play()
end

-- ========== إنشاء النافذة ==========
function Library.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Library)
    self.Title     = cfg.Title or "Hava-lib"
    self.Subtitle  = cfg.Subtitle or "v3.0"
    self.Icon      = cfg.Icon or "⚡"
    self.Size      = cfg.Size or UDim2.new(0, 480, 0, 300)
    self.Open      = false
    self.Enabled   = true
    self.Tabs      = {}
    self.CurrentTab = nil
    self.Elements  = {}
    self.ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift

    self.ScreenGui = create("ScreenGui", {
        Name = "HavaLib",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })

    self:_createToggle()
    self:_createWindow()
    self:_bindHotkey()
    return self
end

-- ========== زر الفتح العائم ==========
function Library:_createToggle()
    local btn = create("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(0, 46, 0, 46),
        Position = UDim2.new(0, 15, 0.5, -23),
        BackgroundColor3 = Library.Theme.Background,
        Text = "",
        AutoButtonColor = false,
        Active = true,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    corner(btn, 23)
    stroke(btn, Library.Theme.Accent, 2)

    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Icon,
        TextColor3 = Library.Theme.Accent,
        TextSize = 22,
        Font = Library.Theme.FontBold,
        Parent = btn
    })

    -- سحب مع تمييز النقر
    local dragging, moved = false, false
    local dragStart, startPos

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
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
            if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    btn.Activated:Connect(function()
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
        ClipsDescendants = false,
        Active = true,
        Parent = self.ScreenGui
    })
    corner(win, 10)
    stroke(win, Library.Theme.Accent, 1.5)
    self.Window = win

    -- شريط جانبي
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 135, 1, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Active = true,
        Parent = win
    })
    corner(sidebar, 10)
    create("Frame", {
        Size = UDim2.new(0, 12, 1, 0),
        Position = UDim2.new(1, -12, 0, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = sidebar
    })

    -- ترويسة جانبية
    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Active = true,
        Parent = sidebar
    })

    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 14, 0, 12),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Library.Theme.Accent,
        TextSize = 15,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 14, 0, 32),
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
        Position = UDim2.new(0, 6, 0, 62),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true,
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
        Size = UDim2.new(1, -145, 1, -20),
        Position = UDim2.new(0, 139, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true,
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
        Position = UDim2.new(1, -28, 0, 8),
        BackgroundColor3 = Library.Theme.Danger,
        Text = "✕",
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        ZIndex = 10,
        Active = true,
        Parent = win
    })
    corner(closeBtn, 11)
    closeBtn.Activated:Connect(function() self:Close() end)

    -- سحب من الترويسة
    local dragging = false
    local dragStart, startPos
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
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ========== اختصار لوحة المفاتيح ==========
function Library:_bindHotkey()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end)
end

-- ========== فتح / إغلاق ==========
function Library:Open()
    self.Open = true
    self.Window.Visible = true
    self.Window.Size = UDim2.new(0, 0, 0, 0)
    tween(self.Window, 0.28, { Size = self.Size }, Enum.EasingStyle.Back)
end

function Library:Close()
    self.Open = false
    tween(self.Window, 0.2, { Size = UDim2.new(0, 0, 0, 0) })
    task.delay(0.2, function() self.Window.Visible = false end)
end

function Library:Toggle()
    if self.Open then self:Close() else self:Open() end
end

-- ========== تعطيل/تفعيل كل العناصر ==========
function Library:SetEnabled(state)
    self.Enabled = state
    for _, el in ipairs(self.Elements) do
        if el.SetEnabled then el.SetEnabled(state) end
    end
    -- تحديث الزر الرئيسي
    if self.MasterBtn then
        self.MasterBtn.Set(state)
    end
end

-- ========== تبويب ==========
function Library:AddTab(name, icon)
    local tab = { Name = name, Elements = {}, Enabled = true }

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Library.Theme.Element,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Active = true,
        Parent = self.TabHolder
    })
    corner(btn, 6)

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
        Padding = UDim.new(0, 6),
        Parent = page
    })
    tab.Page = page

    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then tween(btn, 0.15, { BackgroundTransparency = 0.5 }) end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then tween(btn, 0.15, { BackgroundTransparency = 1 }) end
    end)
    btn.Activated:Connect(function() self:SelectTab(tab) end)

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
    local l = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text:upper(),
        TextColor3 = Library.Theme.Accent,
        TextSize = 10,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
    table.insert(self.Elements, { SetEnabled = function() end })
    return l
end

-- ========== نص بسيط ==========
function Library:AddLabel(tab, text)
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundColor3 = Library.Theme.Card,
        Text = "  " .. text,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
    corner(lbl, 6)
    return lbl
end

-- ========== فقرة نصية ==========
function Library:AddParagraph(tab, title, text)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 6)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = container
    })

    if title then
        create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Library.Theme.Text,
            TextSize = 12,
            Font = Library.Theme.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container
        })
    end

    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, title and 18 or 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = container
    })

    return container
end

-- ========== فاصل ==========
function Library:AddDivider(tab)
    return create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Library.Theme.Stroke,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
end

-- ========== زر تبديل عادي ==========
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
        Active = true,
        Parent = container
    })

    local el = { enabled = true }

    hit.Activated:Connect(function()
        if not el.enabled then return end
        state = not state
        tween(dot, 0.15, { BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element })
        tween(knob, 0.2, { Position = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) })
        if callback then callback(state) end
    end)

    el.Set = function(v)
        state = v
        dot.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element
        knob.Position = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(state) end
    end
    el.SetEnabled = function(s)
        el.enabled = s
        container.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

-- ========== زر تفعيل/تعطيل رئيسي ==========
function Library:AddEnableToggle(tab, label, default, callback)
    local state = default or false
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 6)
    tween(container, 0.2, { BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger })

    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = (state and "✅  " or "⛔  ") .. label,
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local hit = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Active = true,
        Parent = container
    })

    hit.Activated:Connect(function()
        state = not state
        container.BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger
        lbl.Text = (state and "✅  " or "⛔  ") .. label
        -- تعطيل/تفعيل باقي العناصر
        self:SetEnabled(state)
        if callback then callback(state) end
    end)

    -- تسجيله كزر رئيسي
    if not self.MasterBtn then
        self.MasterBtn = {
            Set = function(v)
                state = v
                container.BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger
                lbl.Text = (state and "✅  " or "⛔  ") .. label
            end
        }
    end

    return {
        Set = function(v)
            state = v
            container.BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger
            lbl.Text = (state and "✅  " or "⛔  ") .. label
            if callback then callback(state) end
        end
    }
end

-- ========== Dropdown ==========
function Library:AddDropdown(tab, label, options, default, callback)
    local current = default or options[1]
    local expanded = false
    local el = { enabled = true }

    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 2,
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
        ZIndex = 3,
        Active = true,
        Parent = container
    })
    corner(valBtn, 4)

    local listFrame = create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 48),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 4,
        Parent = container
    })
    corner(listFrame, 4)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = listFrame
    })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
        Parent = listFrame
    })

    valBtn.Activated:Connect(function()
        if not el.enabled then return end
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
            ZIndex = 5,
            Active = true,
            Parent = listFrame
        })
        corner(oBtn, 3)
        oBtn.MouseEnter:Connect(function()
            tween(oBtn, 0.1, { BackgroundColor3 = Library.Theme.Hover })
        end)
        oBtn.MouseLeave:Connect(function()
            oBtn.BackgroundColor3 = Library.Theme.Element
        end)
        oBtn.Activated:Connect(function()
            current = opt
            valBtn.Text = tostring(opt) .. "  ▾"
            expanded = false
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, -20, 0, 0)
            tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 50) })
            if callback then callback(opt) end
        end)
    end

    el.Set = function(v)
        current = v
        valBtn.Text = tostring(v) .. "  ▾"
        if callback then callback(v) end
    end
    el.SetEnabled = function(s)
        el.enabled = s
        container.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

-- ========== Input ==========
function Library:AddInput(tab, label, default, isNumber, callback)
    local el = { enabled = true }
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
        Active = true,
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

    el.Set = function(v)
        box.Text = tostring(v)
        if callback then callback(v) end
    end
    el.SetEnabled = function(s)
        el.enabled = s
        container.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

-- ========== Slider ==========
function Library:AddSlider(tab, label, min, max, default, callback)
    min = min or 0
    max = max or 100
    local value = default or min
    local el = { enabled = true }

    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 6)

    local lbl = create("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 16),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local valLbl = create("TextLabel", {
        Size = UDim2.new(0.3, 0, 0, 16),
        Position = UDim2.new(0.7, -10, 0, 6),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Library.Theme.Accent,
        TextSize = 11,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })

    local barBg = create("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 28),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Active = true,
        Parent = container
    })
    corner(barBg, 3)

    local fill = create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Parent = barBg
    })
    corner(fill, 3)

    local knob = create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = barBg
    })
    corner(knob, 6)

    local dragging = false

    local function updateFromX(x)
        local rel = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local newValue = math.floor(min + (max - min) * rel + 0.5)
        value = newValue
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
        if callback then callback(value) end
    end

    barBg.InputBegan:Connect(function(input)
        if not el.enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    el.Set = function(v)
        value = math.clamp(v, min, max)
        local rel = (value - min) / (max - min)
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
        if callback then callback(value) end
    end
    el.SetEnabled = function(s)
        el.enabled = s
        container.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

-- ========== Color Picker ==========
function Library:AddColorPicker(tab, label, default, callback)
    local color = default or Color3.fromRGB(138, 43, 226)
    local el = { enabled = true }

    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
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

    local preview = create("Frame", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 24),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Active = true,
        Parent = container
    })
    corner(preview, 4)
    stroke(preview, Library.Theme.Stroke, 1)

    local expanded = false
    local panel = create("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 52),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        Parent = container
    })
    corner(panel, 6)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = panel
    })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = panel
    })

    -- قنوات RGB
    local channels = {}
    for i, ch in ipairs({"R", "G", "B"}) do
        local row = create("Frame", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            LayoutOrder = i,
            Parent = panel
        })
        create("TextLabel", {
            Size = UDim2.new(0, 14, 1, 0),
            BackgroundTransparency = 1,
            Text = ch,
            TextColor3 = Library.Theme.SubText,
            TextSize = 11,
            Font = Library.Theme.FontBold,
            Parent = row
        })
        local bg = create("Frame", {
            Size = UDim2.new(1, -20, 0, 6),
            Position = UDim2.new(0, 18, 0.5, -3),
            BackgroundColor3 = Library.Theme.Background,
            BorderSizePixel = 0,
            Active = true,
            Parent = row
        })
        corner(bg, 3)
        local fillColor = (ch == "R" and Color3.new(1,0,0))
                       or (ch == "G" and Color3.new(0,1,0))
                       or Color3.new(0,0,1)
        local f = create("Frame", {
            Size = UDim2.new((color[ch] or 0), 0, 1, 0),
            BackgroundColor3 = fillColor,
            BorderSizePixel = 0,
            Parent = bg
        })
        corner(f, 3)

        channels[ch] = { bg = bg, fill = f, value = color[ch] or 0 }
    end

    -- Hex
    local hexRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = 4,
        Parent = panel
    })
    local hexBox = create("TextBox", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Library.Theme.Background,
        Text = string.format("#%02X%02X%02X",
            color.R * 255, color.G * 255, color.B * 255),
        TextColor3 = Library.Theme.Text,
        TextSize = 11,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Active = true,
        Parent = hexRow
    })
    corner(hexBox, 4)

    local function applyColor(newColor)
        color = newColor
        preview.BackgroundColor3 = newColor
        for ch, data in pairs(channels) do
            data.value = newColor[ch]
            data.fill.Size = UDim2.new(newColor[ch], 0, 1, 0)
        end
        hexBox.Text = string.format("#%02X%02X%02X",
            newColor.R * 255, newColor.G * 255, newColor.B * 255)
        if callback then callback(newColor) end
    end

    -- ربط RGB sliders
    for ch, data in pairs(channels) do
        local drag = false
        data.bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                drag = true
                local rel = math.clamp((input.Position.X - data.bg.AbsolutePosition.X)
                    / data.bg.AbsoluteSize.X, 0, 1)
                data.value = rel
                data.fill.Size = UDim2.new(rel, 0, 1, 0)
                applyColor(Color3.new(channels.R.value, channels.G.value, channels.B.value))
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if drag and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
                local rel = math.clamp((input.Position.X - data.bg.AbsolutePosition.X)
                    / data.bg.AbsoluteSize.X, 0, 1)
                data.value = rel
                data.fill.Size = UDim2.new(rel, 0, 1, 0)
                applyColor(Color3.new(channels.R.value, channels.G.value, channels.B.value))
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                drag = false
            end
        end)
    end

    hexBox.FocusLost:Connect(function()
        local hex = hexBox.Text:gsub("#", "")
        local r = tonumber(hex:sub(1,2), 16)
        local g = tonumber(hex:sub(3,4), 16)
        local b = tonumber(hex:sub(5,6), 16)
        if r and g and b then
            applyColor(Color3.fromRGB(r, g, b))
        else
            hexBox.Text = string.format("#%02X%02X%02X",
                color.R * 255, color.G * 255, color.B * 255)
        end
    end)

    preview.Activated:Connect(function()
        expanded = not expanded
        panel.Visible = expanded
        if expanded then
            panel.Size = UDim2.new(1, -20, 0, 110)
            tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 60 + 110 + 8) })
        else
            panel.Size = UDim2.new(1, -20, 0, 0)
            tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 60) })
        end
    end)

    el.Set = function(v) applyColor(v) end
    el.SetEnabled = function(s)
        el.enabled = s
        container.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

-- ========== List (اختيار متعدد) ==========
function Library:AddList(tab, label, options, defaultSelected, callback)
    local selected = defaultSelected or {}
    local el = { enabled = true }

    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 30 + #options * 18),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 6)

    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 18),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local listHolder = create("Frame", {
        Size = UDim2.new(1, -20, 0, #options * 18),
        Position = UDim2.new(0, 10, 0, 26),
        BackgroundTransparency = 1,
        Parent = container
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = listHolder
    })

    local buttons = {}
    for i, opt in ipairs(options) do
        local isSelected = selected[opt] == true
        local row = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundColor3 = isSelected and Library.Theme.AccentAlt or Library.Theme.Element,
            Text = (isSelected and "☑  " or "☐  ") .. tostring(opt),
            TextColor3 = Library.Theme.Text,
            TextSize = 11,
            Font = Library.Theme.Font,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Active = true,
            Parent = listHolder
        })
        corner(row, 3)
        buttons[opt] = row

        row.Activated:Connect(function()
            if not el.enabled then return end
            selected[opt] = not selected[opt]
            row.BackgroundColor3 = selected[opt] and Library.Theme.AccentAlt or Library.Theme.Element
            row.Text = (selected[opt] and "☑  " or "☐  ") .. tostring(opt)
            if callback then callback(selected) end
        end)
    end

    el.Set = function(tbl)
        selected = tbl
        for opt, row in pairs(buttons) do
            local s = selected[opt] == true
            row.BackgroundColor3 = s and Library.Theme.AccentAlt or Library.Theme.Element
            row.Text = (s and "☑  " or "☐  ") .. tostring(opt)
        end
        if callback then callback(selected) end
    end
    el.Get = function() return selected end
    el.SetEnabled = function(s)
        el.enabled = s
        container.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

-- ========== Button (Command) ==========
function Library:AddButton(tab, label, callback, color)
    color = color or Library.Theme.Accent
    local el = { enabled = true }

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = color,
        Text = label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        Active = true,
        Parent = tab.Page
    })
    corner(btn, 6)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2) })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color })
    end)
    btn.Activated:Connect(function()
        if not el.enabled then return end
        if callback then callback() end
    end)

    el.SetEnabled = function(s)
        el.enabled = s
        btn.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(self.Elements, el)
    return el
end

return Library
