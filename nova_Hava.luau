--[[
    ═══════════════════════════════════════════════════════════════════
    Hava-lib v6.0 — PRECISION UPDATE
    Fixed Slider | List Scroll | Boot Screen | Icon Support
    Advanced ColorPicker (Hue + SV + Hex + Gradient)
    Master Switch | Unlimited Scroll | Better Text | Smooth Animations
    ═══════════════════════════════════════════════════════════════════
]]

local Library = {}
Library.__index = Library

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

Library.Elements  = {}
Library.MasterBtn = nil
Library.Enabled   = true
Library.Boots     = {}

-- ═══════════════════════════════════════════════════════════════════
--                              الثيم
-- ═══════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════
--                            مساعدات
-- ═══════════════════════════════════════════════════════════════════
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

local function tween(o, t, p, s, d)
    local info = TweenInfo.new(t or 0.18, s or Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, d or 0)
    return TweenService:Create(o, info, p)
end

local function hsvToRgb(h, s, v)
    return Color3.fromHSV(h, s, v)
end

-- ═══════════════════════════════════════════════════════════════════
--                          Boot Screen
-- ═══════════════════════════════════════════════════════════════════
function Library.Boot(cfg)
    cfg = cfg or {}
    local bg      = cfg.BackgroundColor or Color3.fromRGB(12, 12, 18)
    local accent  = cfg.AccentColor or Library.Theme.Accent
    local title   = cfg.Title or "Hava-lib"
    local sub     = cfg.Subtitle or "Loading..."
    local image   = cfg.Image or nil            -- "rbxassetid://123456"
    local duration= cfg.Duration or 2.2

    local screen = create("ScreenGui", {
        Name = "HavaBoot_" .. math.random(1000, 9999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483646,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    table.insert(Library.Boots, screen)

    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = bg,
        BorderSizePixel = 0,
        Parent = screen
    })

    -- شعار / صورة
    if image then
        local img = create("ImageLabel", {
            Size = UDim2.new(0, 120, 0, 120),
            Position = UDim2.new(0.5, -60, 0.35, -60),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Fit,
            ImageTransparency = 1,
            Parent = root
        })
        tween(img, 0.6, { ImageTransparency = 0 }):Play()
    else
        local logo = create("TextLabel", {
            Size = UDim2.new(0, 200, 0, 80),
            Position = UDim2.new(0.5, -100, 0.35, -40),
            BackgroundTransparency = 1,
            Text = "⚡",
            TextColor3 = accent,
            TextSize = 64,
            Font = Library.Theme.FontBold,
            TextTransparency = 1,
            Parent = root
        })
        tween(logo, 0.6, { TextTransparency = 0 }):Play()
    end

    -- العنوان
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.5, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Library.Theme.Text,
        TextSize = 24,
        Font = Library.Theme.FontBold,
        TextTransparency = 1,
        Parent = root
    })
    tween(titleLbl, 0.6, { TextTransparency = 0 }):Play()

    local subLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 40),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Library.Theme.SubText,
        TextSize = 13,
        Font = Library.Theme.Font,
        TextTransparency = 1,
        Parent = root
    })
    tween(subLbl, 0.6, { TextTransparency = 0 }):Play()

    -- شريط التحميل
    local barBg = create("Frame", {
        Size = UDim2.new(0, 280, 0, 6),
        Position = UDim2.new(0.5, -140, 0.5, 80),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = root
    })
    corner(barBg, 3)

    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = barBg
    })
    corner(fill, 3)

    local pct = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 100),
        BackgroundTransparency = 1,
        Text = "0%",
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        Parent = root
    })

    -- تحريك شريط التحميل
    local steps = 20
    task.spawn(function()
        for i = 1, steps do
            local p = i / steps
            tween(fill, duration / steps, { Size = UDim2.new(p, 0, 1, 0) }, Enum.EasingStyle.Linear):Play()
            pct.Text = math.floor(p * 100) .. "%"
            task.wait(duration / steps)
        end
        task.wait(0.2)
        -- إخفاء
        tween(root, 0.5, { BackgroundTransparency = 1 }):Play()
        tween(titleLbl, 0.5, { TextTransparency = 1 }):Play()
        tween(subLbl, 0.5, { TextTransparency = 1 }):Play()
        tween(pct, 0.5, { TextTransparency = 1 }):Play()
        tween(barBg, 0.5, { BackgroundTransparency = 1 }):Play()
        tween(fill, 0.5, { BackgroundTransparency = 1 }):Play()
        task.wait(0.5)
        screen:Destroy()
    end)

    return screen
end

-- ═══════════════════════════════════════════════════════════════════
--                          إنشاء النافذة
-- ═══════════════════════════════════════════════════════════════════
function Library.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Library)
    self.Title     = cfg.Title    or "Hava-lib"
    self.Subtitle  = cfg.Subtitle or "v6.0"
    self.Icon      = cfg.Icon     or "⚡"
    self.Size      = cfg.Size     or UDim2.new(0, 500, 0, 340)
    self.ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.IsOpen    = false
    self.Tabs      = {}
    self.CurrentTab = nil

    self.ScreenGui = create("ScreenGui", {
        Name = "HavaLib_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 2147483647,
        Enabled = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })

    self:_buildWindow()
    self:_buildToggle()
    self:_bindHotkey()
    return self
end

function Library:_buildWindow()
    local win = create("Frame", {
        Name = "Window",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    corner(win, 10)
    stroke(win, Library.Theme.Accent, 1.5)
    self.Window = win

    -- ═══ الشريط الجانبي ═══
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 145, 1, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Active = true,
        Parent = win
    })
    corner(sidebar, 10)
    create("Frame", {
        Size = UDim2.new(0, 14, 1, 0),
        Position = UDim2.new(1, -14, 0, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = sidebar
    })

    local header = create("Frame", {
        Name = "Header",
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

    local tabs = create("ScrollingFrame", {
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
        Parent = tabs
    })
    create("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        Parent = tabs
    })
    self.TabHolder = tabs

    -- ═══ منطقة المحتوى ═══
    local content = create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -155, 1, -20),
        Position = UDim2.new(0, 149, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Parent = win
    })
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = content
    })
    create("UIPadding", {
        PaddingBottom = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 6),
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
        Active = true,
        Parent = win
    })
    corner(closeBtn, 11)
    closeBtn.Activated:Connect(function()
        self:Close()
    end)

    -- سحب النافذة
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
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

function Library:_buildToggle()
    local btn = create("TextButton", {
        Name = "FloatingToggle",
        Size = UDim2.new(0, 55, 0, 55),
        Position = UDim2.new(0, 20, 0.5, -27),
        BackgroundColor3 = Library.Theme.Background,
        Text = "",
        AutoButtonColor = false,
        Active = true,
        Selectable = true,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    corner(btn, 27)
    stroke(btn, Library.Theme.Accent, 2)

    local icon = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Icon,
        TextColor3 = Library.Theme.Accent,
        TextSize = 26,
        Font = Library.Theme.FontBold,
        Parent = btn
    })

    task.spawn(function()
        while btn.Parent do
            tween(icon, 1.4, { TextTransparency = 0.35 }):Play()
            task.wait(1.4)
            tween(icon, 1.4, { TextTransparency = 0 }):Play()
            task.wait(1.4)
        end
    end)

    local dragging, moved = false, false
    local dragStart, startPos
    local THRESHOLD = 8

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = btn.Position
            tween(btn, 0.1, { Size = UDim2.new(0, 50, 0, 50) }):Play()
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            tween(btn, 0.1, { Size = UDim2.new(0, 55, 0, 55) }):Play()
            if not moved then
                self:Toggle()
            end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            if math.abs(d.X) > THRESHOLD or math.abs(d.Y) > THRESHOLD then
                moved = true
            end
            if moved then
                btn.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end
    end)

    self.ToggleBtn = btn
end

function Library:_bindHotkey()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            self:Toggle()
        end
    end)
end

function Library:Open()
    self.IsOpen = true
    self.Window.Visible = true
    self.Window.Size = UDim2.new(0, 0, 0, 0)
    tween(self.Window, 0.3, { Size = self.Size }, Enum.EasingStyle.Back):Play()
end

function Library:Close()
    self.IsOpen = false
    tween(self.Window, 0.2, { Size = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(0.2, function()
        self.Window.Visible = false
    end)
end

function Library:Toggle()
    if self.IsOpen then self:Close() else self:Open() end
end

function Library:SetEnabled(state)
    Library.Enabled = state
    for _, el in ipairs(Library.Elements) do
        if el.SetEnabled then
            pcall(el.SetEnabled, state)
        end
    end
    if Library.MasterBtn and Library.MasterBtn.Set then
        pcall(Library.MasterBtn.Set, state)
    end
end

-- ═══════════════════════════════════════════════════════════════════
--                            تبويب
-- ═══════════════════════════════════════════════════════════════════
function Library:AddTab(name, icon)
    local tab = { Name = name, Elements = {}, Enabled = true }

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
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

    -- ✅ أيقونة نصية أو صورة
    local iconLbl
    if icon and icon:match("^rbxasset") then
        iconLbl = create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 10, 0.5, -9),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = Library.Theme.SubText,
            Parent = btn
        })
    else
        iconLbl = create("TextLabel", {
            Size = UDim2.new(0, 18, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = icon or "",
            TextColor3 = Library.Theme.SubText,
            TextSize = 14,
            Font = Library.Theme.FontBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = btn
        })
    end

    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = btn
    })

    tab.Button    = btn
    tab.Label     = lbl
    tab.Icon      = iconLbl
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
        Padding = UDim.new(0, 8),
        Parent = page
    })
    tab.Page = page

    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            tween(btn, 0.15, { BackgroundTransparency = 0.5 }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            tween(btn, 0.15, { BackgroundTransparency = 1 }):Play()
        end
    end)
    btn.Activated:Connect(function()
        self:SelectTab(tab)
    end)

    table.insert(self.Tabs, tab)
    if not self.CurrentTab then
        self:SelectTab(tab)
    end
    return tab
end

function Library:SelectTab(tab)
    if self.CurrentTab == tab then return end
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
        tween(t.Button, 0.15, { BackgroundTransparency = 1 }):Play()
        tween(t.Label, 0.15, { TextColor3 = Library.Theme.SubText }):Play()
        tween(t.Icon, 0.15, { TextColor3 = Library.Theme.SubText, ImageColor3 = Library.Theme.SubText }):Play()
        tween(t.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 0) }):Play()
    end
    tab.Page.Visible = true
    tween(tab.Button, 0.15, { BackgroundTransparency = 0 }):Play()
    tab.Button.BackgroundColor3 = Library.Theme.Element
    tween(tab.Label, 0.15, { TextColor3 = Library.Theme.Text }):Play()
    tween(tab.Icon, 0.15, { TextColor3 = Library.Theme.Accent, ImageColor3 = Library.Theme.Accent }):Play()
    tween(tab.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 18) }):Play()
    self.CurrentTab = tab
end

-- ═══════════════════════════════════════════════════════════════════
--                            عناصر
-- ═══════════════════════════════════════════════════════════════════
function Library:AddSection(tab, text)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "▸ " .. text:upper(),
        TextColor3 = Library.Theme.Accent,
        TextSize = 11,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
end

function Library:AddLabel(tab, text)
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = Library.Theme.Card,
        Text = "  " .. text,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = tab.Page
    })
    corner(lbl, 6)
    return lbl
end

function Library:AddParagraph(tab, title, text)
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, 6)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = c
    })
    local layout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = c
    })
    if title then
        create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Library.Theme.Text,
            TextSize = 13,
            Font = Library.Theme.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1,
            Parent = c
        })
    end
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        Parent = c
    })
    return c
end

function Library:AddDivider(tab)
    return create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Library.Theme.Stroke,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
end

-- ──────────────── Toggle ────────────────
function Library:AddToggle(tab, label, default, callback)
    local state = default or false
    local el = { enabled = true }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, 6)

    create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    local dot = create("Frame", {
        Size = UDim2.new(0, 34, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = c
    })
    corner(dot, 9)

    local knob = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = dot
    })
    corner(knob, 7)

    local hit = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Active = true,
        Parent = c
    })

    hit.Activated:Connect(function()
        if not el.enabled then return end
        state = not state
        tween(dot, 0.15, { BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element }):Play()
        tween(knob, 0.2, { Position = state and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }):Play()
        if callback then pcall(callback, state) end
    end)

    el.Set = function(v)
        state = v
        dot.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element
        knob.Position = state and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        if callback then pcall(callback, state) end
    end
    el.Get = function() return state end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

-- ──────────────── EnableToggle ────────────────
function Library:AddEnableToggle(tab, label, default, callback)
    local state = default ~= false
    local el = { enabled = true }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, 6)

    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = (state and "✅  " or "⛔  ") .. label,
        TextColor3 = Library.Theme.Text,
        TextSize = 13,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    local hit = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Active = true,
        Parent = c
    })

    hit.Activated:Connect(function()
        state = not state
        c.BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger
        lbl.Text = (state and "✅  " or "⛔  ") .. label
        Library:SetEnabled(state)
        if callback then pcall(callback, state) end
    end)

    el.Set = function(v)
        state = v
        c.BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Danger
        lbl.Text = (state and "✅  " or "⛔  ") .. label
    end

    if not Library.MasterBtn then
        Library.MasterBtn = el
    end

    return el
end

-- ──────────────── Dropdown ────────────────
function Library:AddDropdown(tab, label, options, default, callback)
    local current  = default or options[1]
    local expanded = false
    local el = { enabled = true }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Page
    })
    corner(c, 6)

    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    local valBtn = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 0, 24),
        BackgroundColor3 = Library.Theme.Element,
        Text = tostring(current) .. "  ▾",
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        Active = true,
        Parent = c
    })
    corner(valBtn, 4)

    local listFrame = create("Frame", {
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, 52),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = c
    })
    corner(listFrame, 4)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = listFrame
    })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        Parent = listFrame
    })

    valBtn.Activated:Connect(function()
        if not el.enabled then return end
        expanded = not expanded
        listFrame.Visible = expanded
        if expanded then
            listFrame.Size = UDim2.new(1, -24, 0, #options * 22 + 8)
            tween(c, 0.25, { Size = UDim2.new(1, 0, 0, 54 + #options * 22 + 12) }):Play()
        else
            listFrame.Size = UDim2.new(1, -24, 0, 0)
            tween(c, 0.25, { Size = UDim2.new(1, 0, 0, 54) }):Play()
        end
    end)

    for i, opt in ipairs(options) do
        local oBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundColor3 = Library.Theme.Element,
            Text = tostring(opt),
            TextColor3 = Library.Theme.Text,
            TextSize = 12,
            Font = Library.Theme.Font,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Active = true,
            Parent = listFrame
        })
        corner(oBtn, 3)
        oBtn.MouseEnter:Connect(function()
            tween(oBtn, 0.1, { BackgroundColor3 = Library.Theme.Hover }):Play()
        end)
        oBtn.MouseLeave:Connect(function()
            oBtn.BackgroundColor3 = Library.Theme.Element
        end)
        oBtn.Activated:Connect(function()
            current = opt
            valBtn.Text = tostring(opt) .. "  ▾"
            expanded = false
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, -24, 0, 0)
            tween(c, 0.25, { Size = UDim2.new(1, 0, 0, 54) }):Play()
            if callback then pcall(callback, opt) end
        end)
    end

    el.Set = function(v)
        current = v
        valBtn.Text = tostring(v) .. "  ▾"
        if callback then pcall(callback, v) end
    end
    el.Get = function() return current end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

-- ──────────────── Input ────────────────
function Library:AddInput(tab, label, default, isNumber, callback)
    local el = { enabled = true }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, 6)

    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    local box = create("TextBox", {
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 0, 24),
        BackgroundColor3 = Library.Theme.Element,
        Text = tostring(default or ""),
        TextColor3 = Library.Theme.Text,
        PlaceholderText = isNumber and "أدخل رقم..." or "أدخل نص...",
        PlaceholderColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Active = true,
        Parent = c
    })
    corner(box, 4)

    box.FocusLost:Connect(function()
        if isNumber then
            local n = tonumber(box.Text)
            if n then
                if callback then pcall(callback, n) end
            else
                box.Text = tostring(default or 0)
            end
        else
            if callback then pcall(callback, box.Text) end
        end
    end)

    el.Set = function(v)
        box.Text = tostring(v)
        if callback then pcall(callback, v) end
    end
    el.Get = function() return box.Text end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

-- ──────────────── Slider (FIXED) ────────────────
function Library:AddSlider(tab, label, min, max, default, callback)
    min, max = min or 0, max or 100
    local value = default or min
    local el = { enabled = true }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, 6)

    create("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    local valLbl = create("TextLabel", {
        Size = UDim2.new(0.4, -24, 0, 18),
        Position = UDim2.new(0.6, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Library.Theme.Accent,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = c
    })

    -- ✅ منطقة اللمس الأكبر (20px)
    local barTouch = create("Frame", {
        Size = UDim2.new(1, -24, 0, 22),
        Position = UDim2.new(0, 12, 0, 28),
        BackgroundTransparency = 1,
        Active = true,
        Parent = c
    })

    local barBg = create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0.5, -3),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = barTouch
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
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = barTouch
    })
    corner(knob, 7)
    stroke(knob, Library.Theme.Accent, 1.5)

    -- ✅ إيجاد السكرول الأم لتعطيله أثناء السحب
    local scrollParent = nil
    local p = tab.Page
    while p do
        if p:IsA("ScrollingFrame") then scrollParent = p; break end
        p = p.Parent
    end

    local dragging = false
    local function updateFromX(absX)
        local rel = math.clamp((absX - barTouch.AbsolutePosition.X) / barTouch.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel + 0.5)
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -7, 0.5, -7)
        if callback then pcall(callback, value) end
    end

    barTouch.InputBegan:Connect(function(input)
        if not el.enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            if scrollParent then scrollParent.ScrollingEnabled = false end
            tween(knob, 0.1, { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new((value - min) / (max - min), -9, 0.5, -9) }):Play()
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
            if dragging then
                dragging = false
                if scrollParent then scrollParent.ScrollingEnabled = true end
                tween(knob, 0.15, { Size = UDim2.new(0, 14, 0, 14) }):Play()
            end
        end
    end)

    el.Set = function(v)
        value = math.clamp(v, min, max)
        local rel = (value - min) / (max - min)
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -7, 0.5, -7)
        if callback then pcall(callback, value) end
    end
    el.Get = function() return value end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

-- ──────────────── List (FIXED) ────────────────
function Library:AddList(tab, label, options, defaultSelected, callback)
    local selected = defaultSelected or {}
    local el = { enabled = true }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34 + #options * 22),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, 6)

    create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    -- ✅ قائمة قابلة للتمرير إذا طالت
    local maxHeight = 180
    local listHeight = math.min(#options * 22, maxHeight)
    local useScroll  = (#options * 22) > maxHeight

    local holder
    if useScroll then
        holder = create("ScrollingFrame", {
            Size = UDim2.new(1, -24, 0, listHeight),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Active = true,
            Parent = c
        })
        c.Size = UDim2.new(1, 0, 0, 40 + listHeight)
    else
        holder = create("Frame", {
            Size = UDim2.new(1, -24, 0, listHeight),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            Parent = c
        })
    end

    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = holder
    })
    create("UIPadding", {
        PaddingBottom = UDim.new(0, 4),
        Parent = holder
    })

    local buttons = {}
    for i, opt in ipairs(options) do
        local isSel = selected[opt] == true
        local row = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundColor3 = isSel and Library.Theme.AccentAlt or Library.Theme.Element,
            Text = (isSel and "☑  " or "☐  ") .. tostring(opt),
            TextColor3 = Library.Theme.Text,
            TextSize = 12,
            Font = Library.Theme.Font,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Active = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = holder
        })
        corner(row, 3)
        buttons[opt] = row
        row.Activated:Connect(function()
            if not el.enabled then return end
            selected[opt] = not selected[opt]
            row.BackgroundColor3 = selected[opt] and Library.Theme.AccentAlt or Library.Theme.Element
            row.Text = (selected[opt] and "☑  " or "☐  ") .. tostring(opt)
            if callback then pcall(callback, selected) end
        end)
    end

    el.Set = function(tbl)
        selected = tbl
        for opt, row in pairs(buttons) do
            local s = selected[opt] == true
            row.BackgroundColor3 = s and Library.Theme.AccentAlt or Library.Theme.Element
            row.Text = (s and "☑  " or "☐  ") .. tostring(opt)
        end
        if callback then pcall(callback, selected) end
    end
    el.Get = function() return selected end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

-- ──────────────── ColorPicker (Rayfield Style) ────────────────
function Library:AddColorPicker(tab, label, default, callback)
    local color = default or Color3.fromRGB(138, 43, 226)
    local el = { enabled = true, gradient = false, color2 = color }

    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Page
    })
    corner(c, 6)

    create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })

    local preview = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 0, 26),
        BackgroundColor3 = color,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Parent = c
    })
    corner(preview, 4)
    stroke(preview, Library.Theme.Stroke, 1)

    -- تدرج اختياري
    local gradient = create("UIGradient", {
        Color = ColorSequence.new(color, color),
        Parent = preview
    })

    -- ═══ لوحة الألوان المنبثقة (Rayfield-style) ═══
    local panel = create("Frame", {
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, 54),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = c
    })
    corner(panel, 6)

    -- Hue slider
    local hueHolder = create("Frame", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        Parent = panel
    })
    local hueBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0.5, -6),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Active = true,
        Parent = hueHolder
    })
    corner(hueBar, 6)
    local hueGrad = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
        }),
        Parent = hueBar
    })
    local hueKnob = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, -8, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = hueHolder
    })
    corner(hueKnob, 8)
    stroke(hueKnob, Color3.new(0, 0, 0), 1)

    -- Saturation slider
    local satRow = create("Frame", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 8, 0, 34),
        BackgroundTransparency = 1,
        Parent = panel
    })
    local satBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0.5, -6),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Active = true,
        Parent = satRow
    })
    corner(satBar, 6)
    local satGrad = create("UIGradient", { Parent = satBar })
    local satKnob = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, -8, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = satRow
    })
    corner(satKnob, 8)
    stroke(satKnob, Color3.new(0, 0, 0), 1)

    -- Value slider
    local valRow = create("Frame", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 8, 0, 60),
        BackgroundTransparency = 1,
        Parent = panel
    })
    local valBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0.5, -6),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Active = true,
        Parent = valRow
    })
    corner(valBar, 6)
    local valGrad = create("UIGradient", { Parent = valBar })
    local valKnob = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, -8, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = valRow
    })
    corner(valKnob, 8)
    stroke(valKnob, Color3.new(0, 0, 0), 1)

    -- Hex input
    local hexBox = create("TextBox", {
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 8, 0, 86),
        BackgroundColor3 = Library.Theme.Background,
        Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255),
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Active = true,
        Parent = panel
    })
    corner(hexBox, 4)

    -- زر التدرج
    local gradBtn = create("TextButton", {
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 8, 0, 114),
        BackgroundColor3 = Library.Theme.Card,
        Text = "🎨 تفعيل التدرج",
        TextColor3 = Library.Theme.Text,
        TextSize = 11,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        Active = true,
        Parent = panel
    })
    corner(gradBtn, 4)

    -- المتغيرات
    local hue, sat, val = color:ToHSV()

    local function refreshSliders()
        satGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 0, val)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, val)),
        })
        valGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, 1)),
        })
        hueKnob.Position = UDim2.new(hue, -8, 0.5, -8)
        satKnob.Position = UDim2.new(sat, -8, 0.5, -8)
        valKnob.Position = UDim2.new(val, -8, 0.5, -8)
        satKnob.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
        valKnob.BackgroundColor3 = Color3.fromHSV(hue, sat, val)
        hueKnob.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    end

    local function applyColor()
        color = Color3.fromHSV(hue, sat, val)
        preview.BackgroundColor3 = color
        hexBox.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
        gradient.Color = ColorSequence.new(el.gradient and el.color2 or color, color)
        refreshSliders()
        if callback then
            if el.gradient then
                pcall(callback, color, el.color2)
            else
                pcall(callback, color)
            end
        end
    end

    -- Slider dragging
    local activeDrag = nil
    local function startDrag(kind)
        activeDrag = kind
    end

    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            startDrag("hue")
            local rel = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            hue = rel
            applyColor()
        end
    end)
    satBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            startDrag("sat")
            local rel = math.clamp((input.Position.X - satBar.AbsolutePosition.X) / satBar.AbsoluteSize.X, 0, 1)
            sat = rel
            applyColor()
        end
    end)
    valBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            startDrag("val")
            local rel = math.clamp((input.Position.X - valBar.AbsolutePosition.X) / valBar.AbsoluteSize.X, 0, 1)
            val = rel
            applyColor()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            if activeDrag == "hue" then
                hue = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            elseif activeDrag == "sat" then
                sat = math.clamp((input.Position.X - satBar.AbsolutePosition.X) / satBar.AbsoluteSize.X, 0, 1)
            elseif activeDrag == "val" then
                val = math.clamp((input.Position.X - valBar.AbsolutePosition.X) / valBar.AbsoluteSize.X, 0, 1)
            end
            applyColor()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = nil
        end
    end)

    -- Hex input
    hexBox.FocusLost:Connect(function()
        local hex = hexBox.Text:gsub("#", "")
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        if r and g and b then
            color = Color3.fromRGB(r, g, b)
            hue, sat, val = color:ToHSV()
            applyColor()
        else
            hexBox.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
        end
    end)

    -- Gradient toggle
    gradBtn.Activated:Connect(function()
        el.gradient = not el.gradient
        gradBtn.Text = el.gradient and "🎨 التدرج مفعّل" or "🎨 تفعيل التدرج"
        gradBtn.BackgroundColor3 = el.gradient and Library.Theme.Accent or Library.Theme.Card
        applyColor()
    end)

    -- Popup toggle
    local expanded = false
    preview.Activated:Connect(function()
        expanded = not expanded
        panel.Visible = expanded
        if expanded then
            local targetH = 144
            panel.Size = UDim2.new(1, -24, 0, targetH)
            tween(c, 0.3, { Size = UDim2.new(1, 0, 0, 54 + targetH + 8) }):Play()
        else
            panel.Size = UDim2.new(1, -24, 0, 0)
            tween(c, 0.3, { Size = UDim2.new(1, 0, 0, 54) }):Play()
        end
    end)

    refreshSliders()

    el.Set = function(v)
        if typeof(v) == "Color3" then
            color = v
            hue, sat, val = v:ToHSV()
        end
        applyColor()
    end
    el.Get = function() return color end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

-- ──────────────── Button (with icon) ────────────────
function Library:AddButton(tab, label, callback, color, icon)
    color = color or Library.Theme.Accent
    local el = { enabled = true }

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = color,
        Text = icon and (icon .. "  " .. label) or label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        Active = true,
        AutoButtonColor = false,
        Parent = tab.Page
    })
    corner(btn, 6)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.2) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, { BackgroundColor3 = color }):Play()
    end)
    btn.Activated:Connect(function()
        if not el.enabled then return end
        if callback then pcall(callback) end
    end)

    el.SetEnabled = function(s)
        el.enabled = s
        btn.BackgroundTransparency = s and 0 or 0.5
    end

    table.insert(Library.Elements, el)
    return el
end

return Library
