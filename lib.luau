--[[
    StartTraining UI Library
    مكتبة لإنشاء واجهات تخصيص ريموت StartTraining في MM2
    Author: Custom Library
    Version: 1.0
]]

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ========== الثيم (Theme) ==========
Library.Theme = {
    Background    = Color3.fromRGB(18, 18, 24),
    Secondary     = Color3.fromRGB(28, 28, 38),
    Element       = Color3.fromRGB(38, 38, 52),
    ElementHover  = Color3.fromRGB(48, 48, 65),
    Accent        = Color3.fromRGB(0, 170, 255),
    AccentDark    = Color3.fromRGB(0, 120, 200),
    Text          = Color3.fromRGB(240, 240, 255),
    SubText       = Color3.fromRGB(160, 170, 200),
    Success       = Color3.fromRGB(0, 200, 110),
    Danger        = Color3.fromRGB(220, 60, 60),
    Warning       = Color3.fromRGB(255, 170, 0),
    Stroke        = Color3.fromRGB(55, 55, 75),
    Font          = Enum.Font.Gotham,
    FontBold      = Enum.Font.GothamBold,
    CornerRadius  = 10,
    Padding       = 8,
}

-- ========== دوال مساعدة ==========
local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function corner(parent, radius)
    return create("UICorner", {
        CornerRadius = UDim.new(0, radius or Library.Theme.CornerRadius),
        Parent = parent
    })
end

local function stroke(parent, color, thickness)
    return create("UIStroke", {
        Color = color or Library.Theme.Stroke,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function padding(parent, p)
    p = p or Library.Theme.Padding
    return create("UIPadding", {
        PaddingTop = UDim.new(0, p),
        PaddingBottom = UDim.new(0, p),
        PaddingLeft = UDim.new(0, p),
        PaddingRight = UDim.new(0, p),
        Parent = parent
    })
end

-- ========== إنشاء النافذة الرئيسية ==========
function Library.new(config)
    config = config or {}
    local self = setmetatable({}, Library)
    
    self.Title = config.Title or "Menu"
    self.Subtitle = config.Subtitle or "v1.0"
    self.Size = config.Size or UDim2.new(0, 340, 0, 480)
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    self.Icon = config.Icon or "⚙"
    self.Minimized = false
    self.Dragging = false
    self.Elements = {}
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- ScreenGui
    self.ScreenGui = create("ScreenGui", {
        Name = "Library_" .. self.Title:gsub("%s", "_"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    self:_createToggleButton()
    self:_createMainWindow()
    self:_createDragging()
    
    return self
end

function Library:_createToggleButton()
    local btn = create("TextButton", {
        Name = "ToggleBtn",
        Size = UDim2.new(0, 55, 0, 55),
        Position = UDim2.new(0, 15, 0.45, 0),
        BackgroundColor3 = Library.Theme.Background,
        TextColor3 = Library.Theme.Accent,
        Text = self.Icon,
        TextSize = 26,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    corner(btn, 14)
    stroke(btn, Library.Theme.Accent, 1.5)
    
    -- السحب
    local dragStart, startPos, dragging = nil, nil, false
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
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        if self.Minimized then
            self:Open()
        else
            self:Close()
        end
    end)
    
    self.ToggleBtn = btn
end

function Library:_createMainWindow()
    local frame = create("Frame", {
        Name = "MainWindow",
        Size = self.Size,
        Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Visible = false,
        Parent = self.ScreenGui
    })
    corner(frame, 14)
    stroke(frame, Library.Theme.Accent, 1.5)
    self.MainFrame = frame
    
    -- الترويسة
    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = frame
    })
    corner(header, 14)
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = header
    })
    
    -- شريط ملوّن
    create("Frame", {
        Size = UDim2.new(0, 4, 0, 22),
        Position = UDim2.new(0, 12, 0, 11),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Parent = header
    })
    local accentCorner = create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = header:FindFirstChildOfClass("Frame")
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 20),
        Position = UDim2.new(0, 24, 0, 8),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Library.Theme.Text,
        TextSize = 15,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 14),
        Position = UDim2.new(0, 24, 0, 26),
        BackgroundTransparency = 1,
        Text = self.Subtitle,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    -- زر الإغلاق
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -38, 0, 8),
        BackgroundColor3 = Library.Theme.Danger,
        TextColor3 = Library.Theme.Text,
        Text = "✕",
        TextSize = 14,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        Parent = header
    })
    corner(closeBtn, 8)
    closeBtn.MouseButton1Click:Connect(function() self:Close() end)
    
    -- شريط التبويبات
    self.TabBar = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -16, 0, 34),
        Position = UDim2.new(0, 8, 0, 52),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = frame
    })
    corner(self.TabBar, 8)
    
    local tabLayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = self.TabBar
    })
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 4),
        Parent = self.TabBar
    })
    
    -- محتوى الصفحة
    self.Content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -16, 1, -104),
        Position = UDim2.new(0, 8, 0, 94),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = frame
    })
    corner(self.Content, 8)
end

function Library:_createDragging()
    local header = self.MainFrame:FindFirstChild("Header")
    local dragStart, startPos, dragging = nil, nil, false
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
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
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ========== فتح/إغلاق ==========
function Library:Open()
    self.Minimized = false
    self.MainFrame.Visible = true
    self.MainFrame.Size = UDim2.new(0, self.Size.X.Offset, 0, 0)
    TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
        Size = self.Size
    }):Play()
end

function Library:Close()
    self.Minimized = true
    TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
        Size = UDim2.new(0, self.Size.X.Offset, 0, 0)
    }):Play()
    task.delay(0.2, function()
        self.MainFrame.Visible = false
    end)
end

function Library:Toggle()
    if self.Minimized then self:Open() else self:Close() end
end

-- ========== إضافة تبويب ==========
function Library:AddTab(name)
    local tab = {
        Name = name,
        Elements = {}
    }
    
    local btn = create("TextButton", {
        Size = UDim2.new(0, 70, 0, 26),
        BackgroundColor3 = Library.Theme.Element,
        TextColor3 = Library.Theme.SubText,
        Text = name,
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        Parent = self.TabBar
    })
    corner(btn, 6)
    tab.Button = btn
    
    local page = create("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    corner(page, 8)
    padding(page, 6)
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = page
    })
    
    tab.Page = page
    
    btn.MouseButton1Click:Connect(function()
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
        TweenService:Create(t.Button, TweenInfo.new(0.15), {
            BackgroundColor3 = Library.Theme.Element,
            TextColor3 = Library.Theme.SubText
        }):Play()
    end
    tab.Page.Visible = true
    TweenService:Create(tab.Button, TweenInfo.new(0.15), {
        BackgroundColor3 = Library.Theme.Accent,
        TextColor3 = Library.Theme.Text
    }):Play()
    self.CurrentTab = tab
end

-- ========== عناصر التحكم ==========

-- عنوان قسم
function Library:AddSection(tab, text)
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "▸ " .. text,
        TextColor3 = Library.Theme.Accent,
        TextSize = 13,
        Font = Library.Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
    table.insert(tab.Elements, lbl)
    return lbl
end

-- قائمة منسدلة
function Library:AddDropdown(tab, labelText, options, default, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 8)
    padding(container, 6)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    local currentValue = default or options[1]
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = Library.Theme.Element,
        TextColor3 = Library.Theme.Text,
        Text = tostring(currentValue) .. "  ▼",
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        Parent = container
    })
    corner(btn, 6)
    
    local expanded = false
    local optFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
        Parent = container
    })
    corner(optFrame, 8)
    stroke(optFrame, Library.Theme.Stroke, 1)
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = optFrame
    })
    padding(optFrame, 4)
    
    local originalSize = UDim2.new(1, 0, 0, 52)
    
    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        optFrame.Visible = expanded
        if expanded then
            optFrame.Size = UDim2.new(1, 0, 0, #options * 26 + 8)
            container.Size = UDim2.new(1, 0, 0, 52 + #options * 26 + 12)
        else
            optFrame.Size = UDim2.new(1, 0, 0, 0)
            container.Size = originalSize
        end
    end)
    
    for i, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = Library.Theme.Secondary,
            TextColor3 = Library.Theme.Text,
            Text = tostring(opt),
            TextSize = 12,
            Font = Library.Theme.Font,
            BorderSizePixel = 0,
            LayoutOrder = i,
            ZIndex = 6,
            Parent = optFrame
        })
        corner(optBtn, 5)
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Library.Theme.ElementHover
        end)
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundColor3 = Library.Theme.Secondary
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            currentValue = opt
            btn.Text = tostring(opt) .. "  ▼"
            expanded = false
            optFrame.Visible = false
            optFrame.Size = UDim2.new(1, 0, 0, 0)
            container.Size = originalSize
            if callback then callback(opt) end
        end)
    end
    
    table.insert(tab.Elements, container)
    return { Set = function(v)
        currentValue = v
        btn.Text = tostring(v) .. "  ▼"
        if callback then callback(v) end
    end }
end

-- زر تبديل
function Library:AddToggle(tab, labelText, default, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 8)
    
    create("TextLabel", {
        Size = UDim2.new(0.65, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    local state = default or false
    
    -- خلفية المفتاح
    local switchBg = create("Frame", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = container
    })
    corner(switchBg, 11)
    
    -- الدائرة المتحركة
    local knob = create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = switchBg
    })
    corner(knob, 9)
    
    local hitbox = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = container
    })
    
    hitbox.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switchBg, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Element
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        if callback then callback(state) end
    end)
    
    table.insert(tab.Elements, container)
    return { Set = function(v)
        state = v
        switchBg.BackgroundColor3 = state and Library.Theme.Success or Library.Theme.Element
        knob.Position = state and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        if callback then callback(state) end
    end }
end

-- حقل إدخال
function Library:AddInput(tab, labelText, default, isNumber, callback)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Library.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(container, 8)
    padding(container, 6)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Library.Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    local box = create("TextBox", {
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = Library.Theme.Element,
        TextColor3 = Library.Theme.Text,
        PlaceholderText = isNumber and "أدخل رقم..." or "أدخل نص...",
        PlaceholderColor3 = Library.Theme.SubText,
        Text = tostring(default or ""),
        TextSize = 12,
        Font = Library.Theme.Font,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Parent = container
    })
    corner(box, 6)
    
    box.Focused:Connect(function()
        TweenService:Create(box, TweenInfo.new(0.15), {
            BackgroundColor3 = Library.Theme.ElementHover
        }):Play()
    end)
    box.FocusLost:Connect(function()
        TweenService:Create(box, TweenInfo.new(0.15), {
            BackgroundColor3 = Library.Theme.Element
        }):Play()
        local val = box.Text
        if isNumber then
            local n = tonumber(val)
            if n then
                if callback then callback(n) end
            else
                box.Text = tostring(default or 0)
            end
        else
            if callback then callback(val) end
        end
    end)
    
    table.insert(tab.Elements, container)
    return { Set = function(v)
        box.Text = tostring(v)
        if callback then callback(v) end
    end }
end

-- زر تنفيذ
function Library:AddButton(tab, labelText, callback, color)
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = color or Library.Theme.Accent,
        TextColor3 = Library.Theme.Text,
        Text = labelText,
        TextSize = 13,
        Font = Library.Theme.FontBold,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(btn, 8)
    stroke(btn, color and color:Lerp(Color3.new(0,0,0), 0.5) or Library.Theme.AccentDark, 1.5)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = color and color:Lerp(Color3.new(1,1,1), 0.15) 
                                 or Library.Theme.Accent:Lerp(Color3.new(1,1,1), 0.15)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = color or Library.Theme.Accent
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    table.insert(tab.Elements, btn)
    return btn
end

-- فاصل
function Library:AddDivider(tab)
    local d = create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Library.Theme.Stroke,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    table.insert(tab.Elements, d)
    return d
end

-- ========== اختصار لوحة المفاتيح ==========
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.RightShift then
        for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name:match("^Library_") then
                -- إيجاد النافذة وتفعيلها
            end
        end
    end
end)

return Library
