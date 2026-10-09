--[[
    ═══════════════════════════════════════════════════════════════════
    Nova Hava Library v11.1 — ULTRA COMPACT EDITION
    ================================================================
    ✨ 12 ثيمات
    🎬 5 Boot Screens
    🔐 Key System + Copy Link
    🎨 Live Color Editor (Compact + Hex Copy)
    🎛️ Global Theme Editor
    🖼️ Decal→Image Auto-Converter
    📱 Resize Handle + Precision
    🎯 25+ عنصر
    ⚡ أنيميشن بدون تداخل
    ═══════════════════════════════════════════════════════════════════
]]

local Library = {}
Library.__index = Library

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local InsertService    = game:GetService("InsertService")
local LocalPlayer      = Players.LocalPlayer

Library.Elements = {}
Library.Flags = {}
Library.MasterBtn = nil
Library.Enabled = true
Library.Windows = {}
Library.CustomColors = {}

-- ═══════════════════════════════════════════════════════════════════
--                     🎨 12 ثيمات
-- ═══════════════════════════════════════════════════════════════════
Library.Themes = {
    Default = {
        Background = Color3.fromRGB(20, 20, 26), BackgroundTrans = 0,
        Sidebar = Color3.fromRGB(15, 15, 20), Card = Color3.fromRGB(30, 30, 38),
        Element = Color3.fromRGB(38, 38, 48), Hover = Color3.fromRGB(48, 48, 60),
        Accent = Color3.fromRGB(138, 43, 226), AccentAlt = Color3.fromRGB(90, 30, 180),
        Text = Color3.fromRGB(240, 240, 245), SubText = Color3.fromRGB(150, 150, 170),
        Stroke = Color3.fromRGB(50, 50, 65), Glow = Color3.fromRGB(138, 43, 226),
        GlassMode = false, CornerRadius = 8,
    },
    iOSGlass = {
        Background = Color3.fromRGB(245, 245, 250), BackgroundTrans = 0.2,
        Sidebar = Color3.fromRGB(230, 230, 240), Card = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(240, 240, 250), Hover = Color3.fromRGB(220, 220, 240),
        Accent = Color3.fromRGB(0, 122, 255), AccentAlt = Color3.fromRGB(100, 180, 255),
        Text = Color3.fromRGB(20, 20, 30), SubText = Color3.fromRGB(100, 100, 120),
        Stroke = Color3.fromRGB(200, 200, 220), Glow = Color3.fromRGB(0, 122, 255),
        GlassMode = true, CornerRadius = 14,
    },
    BlackShine = {
        Background = Color3.fromRGB(10, 10, 12), BackgroundTrans = 0.05,
        Sidebar = Color3.fromRGB(5, 5, 8), Card = Color3.fromRGB(20, 20, 24),
        Element = Color3.fromRGB(28, 28, 34), Hover = Color3.fromRGB(40, 40, 48),
        Accent = Color3.fromRGB(255, 255, 255), AccentAlt = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(140, 140, 140),
        Stroke = Color3.fromRGB(60, 60, 70), Glow = Color3.fromRGB(255, 255, 255),
        GlassMode = false, CornerRadius = 10,
    },
    RedWhite = {
        Background = Color3.fromRGB(245, 245, 245), BackgroundTrans = 0,
        Sidebar = Color3.fromRGB(220, 50, 60), Card = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(240, 240, 240), Hover = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(220, 50, 60), AccentAlt = Color3.fromRGB(180, 30, 40),
        Text = Color3.fromRGB(30, 30, 40), SubText = Color3.fromRGB(120, 120, 130),
        Stroke = Color3.fromRGB(220, 50, 60), Glow = Color3.fromRGB(255, 100, 100),
        GlassMode = false, CornerRadius = 8,
    },
    PurpleDream = {
        Background = Color3.fromRGB(30, 15, 50), BackgroundTrans = 0.1,
        Sidebar = Color3.fromRGB(20, 10, 35), Card = Color3.fromRGB(45, 25, 70),
        Element = Color3.fromRGB(55, 35, 85), Hover = Color3.fromRGB(70, 45, 105),
        Accent = Color3.fromRGB(200, 100, 255), AccentAlt = Color3.fromRGB(150, 50, 200),
        Text = Color3.fromRGB(250, 240, 255), SubText = Color3.fromRGB(180, 150, 210),
        Stroke = Color3.fromRGB(100, 60, 150), Glow = Color3.fromRGB(200, 100, 255),
        GlassMode = false, CornerRadius = 12,
    },
    Halloween = {
        Background = Color3.fromRGB(20, 10, 5), BackgroundTrans = 0.05,
        Sidebar = Color3.fromRGB(15, 5, 2), Card = Color3.fromRGB(35, 15, 5),
        Element = Color3.fromRGB(50, 20, 10), Hover = Color3.fromRGB(70, 30, 15),
        Accent = Color3.fromRGB(255, 120, 0), AccentAlt = Color3.fromRGB(180, 80, 0),
        Text = Color3.fromRGB(255, 230, 200), SubText = Color3.fromRGB(200, 150, 100),
        Stroke = Color3.fromRGB(100, 50, 20), Glow = Color3.fromRGB(255, 120, 0),
        GlassMode = false, CornerRadius = 10,
    },
    Cyberpunk = {
        Background = Color3.fromRGB(10, 5, 25), BackgroundTrans = 0.1,
        Sidebar = Color3.fromRGB(5, 2, 15), Card = Color3.fromRGB(20, 10, 40),
        Element = Color3.fromRGB(30, 15, 55), Hover = Color3.fromRGB(45, 25, 75),
        Accent = Color3.fromRGB(0, 255, 200), AccentAlt = Color3.fromRGB(255, 0, 150),
        Text = Color3.fromRGB(220, 255, 255), SubText = Color3.fromRGB(150, 200, 220),
        Stroke = Color3.fromRGB(0, 200, 180), Glow = Color3.fromRGB(0, 255, 200),
        GlassMode = false, CornerRadius = 4,
    },
    Ocean = {
        Background = Color3.fromRGB(10, 25, 40), BackgroundTrans = 0.05,
        Sidebar = Color3.fromRGB(5, 15, 25), Card = Color3.fromRGB(20, 40, 60),
        Element = Color3.fromRGB(30, 55, 80), Hover = Color3.fromRGB(45, 75, 105),
        Accent = Color3.fromRGB(0, 200, 255), AccentAlt = Color3.fromRGB(0, 120, 180),
        Text = Color3.fromRGB(220, 240, 255), SubText = Color3.fromRGB(130, 180, 220),
        Stroke = Color3.fromRGB(30, 80, 120), Glow = Color3.fromRGB(0, 200, 255),
        GlassMode = false, CornerRadius = 12,
    },
    Forest = {
        Background = Color3.fromRGB(15, 25, 15), BackgroundTrans = 0.05,
        Sidebar = Color3.fromRGB(8, 15, 8), Card = Color3.fromRGB(25, 40, 25),
        Element = Color3.fromRGB(35, 55, 35), Hover = Color3.fromRGB(45, 70, 45),
        Accent = Color3.fromRGB(80, 200, 100), AccentAlt = Color3.fromRGB(50, 150, 70),
        Text = Color3.fromRGB(220, 255, 220), SubText = Color3.fromRGB(150, 190, 150),
        Stroke = Color3.fromRGB(50, 80, 50), Glow = Color3.fromRGB(80, 200, 100),
        GlassMode = false, CornerRadius = 10,
    },
    Sunset = {
        Background = Color3.fromRGB(40, 15, 30), BackgroundTrans = 0.05,
        Sidebar = Color3.fromRGB(25, 8, 20), Card = Color3.fromRGB(60, 25, 45),
        Element = Color3.fromRGB(80, 35, 60), Hover = Color3.fromRGB(105, 50, 80),
        Accent = Color3.fromRGB(255, 100, 150), AccentAlt = Color3.fromRGB(200, 60, 100),
        Text = Color3.fromRGB(255, 230, 240), SubText = Color3.fromRGB(220, 160, 190),
        Stroke = Color3.fromRGB(120, 50, 80), Glow = Color3.fromRGB(255, 100, 150),
        GlassMode = false, CornerRadius = 10,
    },
    Candy = {
        Background = Color3.fromRGB(255, 240, 250), BackgroundTrans = 0,
        Sidebar = Color3.fromRGB(255, 200, 230), Card = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(255, 230, 245), Hover = Color3.fromRGB(255, 200, 230),
        Accent = Color3.fromRGB(255, 100, 180), AccentAlt = Color3.fromRGB(200, 60, 140),
        Text = Color3.fromRGB(80, 20, 50), SubText = Color3.fromRGB(150, 100, 130),
        Stroke = Color3.fromRGB(255, 150, 200), Glow = Color3.fromRGB(255, 100, 180),
        GlassMode = false, CornerRadius = 16,
    },
    Midnight = {
        Background = Color3.fromRGB(8, 12, 24), BackgroundTrans = 0.1,
        Sidebar = Color3.fromRGB(4, 6, 15), Card = Color3.fromRGB(15, 20, 35),
        Element = Color3.fromRGB(22, 28, 48), Hover = Color3.fromRGB(35, 45, 70),
        Accent = Color3.fromRGB(100, 150, 255), AccentAlt = Color3.fromRGB(60, 100, 200),
        Text = Color3.fromRGB(220, 230, 255), SubText = Color3.fromRGB(130, 150, 200),
        Stroke = Color3.fromRGB(40, 55, 100), Glow = Color3.fromRGB(100, 150, 255),
        GlassMode = false, CornerRadius = 12,
    },
}

Library.Theme = {}
for k, v in pairs(Library.Themes.Default) do Library.Theme[k] = v end

-- ═══════════════════════════════════════════════════════════════════
--                     🖼️ Decal → Image Converter
-- ═══════════════════════════════════════════════════════════════════
function Library:DecalToImage(decalId)
    local ok, result = pcall(function()
        local asset = InsertService:LoadAsset(decalId)
        for _, child in pairs(asset:GetChildren()) do
            if child:IsA("Decal") then
                return child.Texture
            end
        end
    end)
    if ok and result then return result end
    return "rbxthumb://type=Asset&id=" .. tostring(decalId) .. "&w=420&h=420"
end

function Library:ResolveImage(input)
    if not input then return nil end
    
    if typeof(input) == "number" then
        return "rbxassetid://" .. input
    end
    
    if typeof(input) == "string" then
        if input:match("^rbxassetid://") or input:match("^rbxthumb://") 
        or input:match("^rbxasset://") then
            return input
        end
        if input:match("^%d+$") then
            return "rbxassetid://" .. input
        end
    end
    
    return input
end

-- ═══════════════════════════════════════════════════════════════════
--                     مساعدات
-- ═══════════════════════════════════════════════════════════════════
local function create(c, p)
    local i = Instance.new(c)
    for k, v in pairs(p or {}) do i[k] = v end
    return i
end

local function corner(p, r)
    return create("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p })
end

local function stroke(p, c, t)
    return create("UIStroke", { Color = c or Library.Theme.Stroke, Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p })
end

local function tween(o, t, p, s)
    return TweenService:Create(o, TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quart), p)
end

-- ═══════════════════════════════════════════════════════════════════
--                     SetTheme
-- ═══════════════════════════════════════════════════════════════════
function Library:SetTheme(themeName)
    if not Library.Themes[themeName] then return false end
    for k, v in pairs(Library.Themes[themeName]) do
        Library.Theme[k] = v
    end
    for _, win in ipairs(Library.Windows) do
        if win.UpdateTheme then pcall(function() win:UpdateTheme() end) end
    end
    return true
end

-- ═══════════════════════════════════════════════════════════════════
--                     🎨 Live Theme Editor (Ultra Compact + Fix)
-- ═══════════════════════════════════════════════════════════════════
function Library:OpenThemeEditor()
    local editorGui = create("ScreenGui", {
        Name = "HavaThemeEditor_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- ✅ حجم مصغر جداً: 180×320
    local panel = create("Frame", {
        Size = UDim2.new(0, 180, 0, 320),
        Position = UDim2.new(0.5, -90, 0.5, -160),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = editorGui
    })
    corner(panel, 8)
    stroke(panel, Library.Theme.Accent, 1.5)
    
    -- Header
    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Active = true,
        Parent = panel
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = "🎨 Theme",
        TextColor3 = Library.Theme.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -20, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "✕",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = header
    })
    corner(closeBtn, 8)
    closeBtn.Activated:Connect(function() editorGui:Destroy() end)
    
    -- Drag
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = panel.Position
        end
    end)
    header.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    
    -- Scroll
    local scroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -76),
        Position = UDim2.new(0, 4, 0, 24),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = panel
    })
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3),
        Parent = scroll
    })
    
    local themeKeys = {"Background", "Sidebar", "Card", "Element",
                       "Hover", "Accent", "AccentAlt", "Text",
                       "SubText", "Stroke", "Glow"}
    
    -- ✅ Picker المصغر
    local activePicker = nil
    local activePickerBtn = nil
    local activePickerRow = nil
    local pickerFrame = create("Frame", {
        Size = UDim2.new(1, -8, 0, 0),
        Position = UDim2.new(0, 4, 1, -36),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = panel
    })
    corner(pickerFrame, 5)
    stroke(pickerFrame, Library.Theme.Accent, 1)
    
    -- ✅ Title ديناميكي للـ Picker
    local pickerTitle = create("TextLabel", {
        Size = UDim2.new(1, -6, 0, 8),
        Position = UDim2.new(0, 3, 0, 1),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Library.Theme.Accent,
        TextSize = 7,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pickerFrame
    })
    
    -- R/G/B sliders
    local rgbSliders = {}
    for idx, chName in ipairs({"R", "G", "B"}) do
        local rowY = (idx - 1) * 10 + 10
        create("TextLabel", {
            Size = UDim2.new(0, 10, 0, 8),
            Position = UDim2.new(0, 2, 0, rowY + 1),
            BackgroundTransparency = 1,
            Text = chName,
            TextColor3 = Library.Theme.Text,
            TextSize = 8,
            Font = Enum.Font.GothamBold,
            Parent = pickerFrame
        })
        
        local barBg = create("Frame", {
            Size = UDim2.new(1, -18, 0, 6),
            Position = UDim2.new(0, 14, 0, rowY + 2),
            BackgroundColor3 = Library.Theme.Element,
            BorderSizePixel = 0,
            Parent = pickerFrame
        })
        corner(barBg, 3)
        
        local fill = create("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Library.Theme.Accent,
            BorderSizePixel = 0,
            Parent = barBg
        })
        corner(fill, 3)
        
        local hit = create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = barBg
        })
        
        rgbSliders[chName] = { bar = barBg, fill = fill, value = 0 }
        
        local dragging = false
        local function updateFromX(absX)
            local rel = math.clamp((absX - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            rgbSliders[chName].value = rel
            fill.Size = UDim2.new(rel, 0, 1, 0)
            if activePicker then
                Library.Theme[activePicker] = Color3.new(
                    rgbSliders.R.value, rgbSliders.G.value, rgbSliders.B.value
                )
                if activePickerBtn then
                    activePickerBtn.BackgroundColor3 = Library.Theme[activePicker]
                end
                -- ✅ تحديث فوري
                for _, win in ipairs(Library.Windows) do
                    if win.UpdateTheme then pcall(function() win:UpdateTheme() end) end
                end
            end
        end
        
        hit.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromX(inp.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
                updateFromX(inp.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
    
    -- ✅ أزرار ✓ / ↺ / 📋
    local applyBtn = create("TextButton", {
        Size = UDim2.new(0.33, -3, 0, 14),
        Position = UDim2.new(0, 2, 1, -16),
        BackgroundColor3 = Library.Theme.Accent,
        Text = "✓",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = pickerFrame
    })
    corner(applyBtn, 3)
    applyBtn.Activated:Connect(function()
        for _, win in ipairs(Library.Windows) do
            if win.UpdateTheme then pcall(function() win:UpdateTheme() end) end
        end
        pickerFrame.Size = UDim2.new(1, -8, 0, 0)
        task.wait(0.15)
        pickerFrame.Visible = false
        activePicker = nil
        activePickerBtn = nil
        activePickerRow = nil
    end)
    
    local resetSingleBtn = create("TextButton", {
        Size = UDim2.new(0.33, -3, 0, 14),
        Position = UDim2.new(0.33, 1, 1, -16),
        BackgroundColor3 = Library.Theme.Element,
        Text = "↺",
        TextColor3 = Library.Theme.Text,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = pickerFrame
    })
    corner(resetSingleBtn, 3)
    resetSingleBtn.Activated:Connect(function()
        if activePicker then
            Library.Theme[activePicker] = Library.Themes.Default[activePicker]
            if activePickerBtn then
                activePickerBtn.BackgroundColor3 = Library.Theme[activePicker]
            end
            local c = Library.Theme[activePicker]
            rgbSliders.R.value = c.R
            rgbSliders.G.value = c.G
            rgbSliders.B.value = c.B
            rgbSliders.R.fill.Size = UDim2.new(c.R, 0, 1, 0)
            rgbSliders.G.fill.Size = UDim2.new(c.G, 0, 1, 0)
            rgbSliders.B.fill.Size = UDim2.new(c.B, 0, 1, 0)
            for _, win in ipairs(Library.Windows) do
                if win.UpdateTheme then pcall(function() win:UpdateTheme() end) end
            end
        end
    end)
    
    -- ✅ زر نسخ Hex
    local copyHexBtn = create("TextButton", {
        Size = UDim2.new(0.33, -3, 0, 14),
        Position = UDim2.new(0.66, 0, 1, -16),
        BackgroundColor3 = Library.Theme.Element,
        Text = "📋",
        TextColor3 = Library.Theme.Text,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = pickerFrame
    })
    corner(copyHexBtn, 3)
    copyHexBtn.Activated:Connect(function()
        if activePicker and setclipboard then
            local c = Library.Theme[activePicker]
            local hex = string.format("#%02X%02X%02X",
                math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
            setclipboard(hex)
            copyHexBtn.Text = "✓"
            task.wait(0.8)
            copyHexBtn.Text = "📋"
        end
    end)
    
    -- ✅ صفوف العناصر
    local rowsByName = {}
    for _, key in ipairs(themeKeys) do
        local row = create("Frame", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundColor3 = Library.Theme.Card,
            BorderSizePixel = 0,
            Parent = scroll
        })
        corner(row, 4)
        
        local lbl = create("TextLabel", {
            Size = UDim2.new(0.6, -6, 1, 0),
            Position = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Text = key,
            TextColor3 = Library.Theme.Text,
            TextSize = 9,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = row
        })
        
        local colorPreview = create("TextButton", {
            Size = UDim2.new(0, 40, 0, 14),
            Position = UDim2.new(1, -46, 0.5, -7),
            BackgroundColor3 = Library.Theme[key],
            Text = "",
            BorderSizePixel = 0,
            Parent = row
        })
        corner(colorPreview, 3)
        stroke(colorPreview, Library.Theme.Stroke, 1)
        
        rowsByName[key] = { row = row, lbl = lbl, preview = colorPreview }
        
        colorPreview.Activated:Connect(function()
            activePicker = key
            activePickerBtn = colorPreview
            activePickerRow = row
            
            pickerTitle.Text = "▸ " .. key
            
            local c = Library.Theme[key]
            rgbSliders.R.value = c.R
            rgbSliders.G.value = c.G
            rgbSliders.B.value = c.B
            rgbSliders.R.fill.Size = UDim2.new(c.R, 0, 1, 0)
            rgbSliders.G.fill.Size = UDim2.new(c.G, 0, 1, 0)
            rgbSliders.B.fill.Size = UDim2.new(c.B, 0, 1, 0)
            
            pickerFrame.Visible = true
            pickerFrame.Size = UDim2.new(1, -8, 0, 0)
            tween(pickerFrame, 0.15, { Size = UDim2.new(1, -8, 0, 52) }):Play()
        end)
    end
    
    -- ✅ زر Reset All (لا يغلق النافذة)
    local resetAll = create("TextButton", {
        Size = UDim2.new(1, -8, 0, 18),
        Position = UDim2.new(0, 4, 1, -22),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "🔄 Reset All",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = panel
    })
    corner(resetAll, 5)
    resetAll.Activated:Connect(function()
        -- ✅ إرجاع كل الألوان للافتراضي
        for k, v in pairs(Library.Themes.Default) do
            Library.Theme[k] = v
        end
        
        -- ✅ تحديث كل صف مباشرة
        for key, data in pairs(rowsByName) do
            data.preview.BackgroundColor3 = Library.Theme[key]
            data.lbl.TextColor3 = Library.Theme.Text
            data.row.BackgroundColor3 = Library.Theme.Card
        end
        
        -- ✅ تحديث كل النوافذ
        for _, win in ipairs(Library.Windows) do
            if win.UpdateTheme then
                pcall(function() win:UpdateTheme() end)
            end
        end
        
        -- ✅ إغلاق Picker إذا مفتوح
        pickerFrame.Visible = false
        pickerFrame.Size = UDim2.new(1, -8, 0, 0)
        activePicker = nil
        activePickerBtn = nil
        activePickerRow = nil
        
        -- ✅ تأثير بصري
        resetAll.Text = "✅ Done!"
        task.wait(0.6)
        resetAll.Text = "🔄 Reset All"
        
        -- ❌ لا نغلق النافذة!
    end)
    
    return editorGui
end

-- ═══════════════════════════════════════════════════════════════════
--                     🎬 5 Boot Screens
-- ═══════════════════════════════════════════════════════════════════

-- ✅ BootPro
function Library.BootPro(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "HavaPro"
    local sub = cfg.Subtitle or "Loading..."
    local image = cfg.Image and Library:ResolveImage(cfg.Image)
    local accent = cfg.AccentColor or Library.Theme.Accent
    local duration = cfg.Duration or 2.5
    
    local screen = create("ScreenGui", {
        Name = "BootPro_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BorderSizePixel = 0,
        Parent = screen
    })
    
    if image then
        local bgImg = create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 1,
            Parent = root
        })
        tween(bgImg, 1, { ImageTransparency = 0.5 }):Play()
    end
    
    local logo = create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 100),
        Position = UDim2.new(0.5, -100, 0.35, -50),
        BackgroundTransparency = 1,
        Text = cfg.Icon or "⚡",
        TextColor3 = accent,
        TextSize = 72,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = root
    })
    tween(logo, 0.6, { TextTransparency = 0 }):Play()
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.5, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        Parent = root
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 55),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Color3.fromRGB(180, 180, 200),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Parent = root
    })
    
    local barBg = create("Frame", {
        Size = UDim2.new(0, 320, 0, 4),
        Position = UDim2.new(0.5, -160, 0.5, 100),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Parent = root
    })
    corner(barBg, 2)
    
    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = barBg
    })
    corner(fill, 2)
    
    local pct = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 120),
        BackgroundTransparency = 1,
        Text = "0%",
        TextColor3 = Color3.fromRGB(180, 180, 200),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = root
    })
    
    task.spawn(function()
        for i = 1, 30 do
            local p = i / 30
            fill.Size = UDim2.new(p, 0, 1, 0)
            pct.Text = math.floor(p * 100) .. "%"
            task.wait(duration / 30)
        end
        task.wait(0.3)
        tween(root, 0.5, { BackgroundTransparency = 1 }):Play()
        for _, c in ipairs(root:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, 0.5, { TextTransparency = 1 }):Play() end
            if c:IsA("Frame") then tween(c, 0.5, { BackgroundTransparency = 1 }):Play() end
            if c:IsA("ImageLabel") then tween(c, 0.5, { ImageTransparency = 1 }):Play() end
        end
        task.wait(0.5)
        screen:Destroy()
    end)
    return screen
end

-- ✅ BootX
function Library.BootX(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "HavaX"
    local sub = cfg.Subtitle or "Modern UI"
    local image = cfg.Image and Library:ResolveImage(cfg.Image)
    local accent = cfg.AccentColor or Color3.fromRGB(0, 200, 255)
    local duration = cfg.Duration or 2.5
    
    local screen = create("ScreenGui", {
        Name = "BootX_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(5, 5, 10),
        BorderSizePixel = 0,
        Parent = screen
    })
    
    if image then
        create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 0.6,
            Parent = root
        })
    end
    
    local card = create("Frame", {
        Size = UDim2.new(0, 380, 0, 220),
        Position = UDim2.new(0.5, -190, 0.5, -110),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Parent = root
    })
    corner(card, 20)
    stroke(card, Color3.new(1, 1, 1), 2).Transparency = 0.5
    
    local iconCircle = create("Frame", {
        Size = UDim2.new(0, 80, 0, 80),
        Position = UDim2.new(0.5, -40, 0, 25),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = card
    })
    corner(iconCircle, 40)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = cfg.Icon or "⚡",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 40,
        Font = Enum.Font.GothamBold,
        Parent = iconCircle
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 120),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(20, 20, 30),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = card
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 150),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Color3.fromRGB(100, 100, 130),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Parent = card
    })
    
    local dots = {}
    for i = 1, 3 do
        local dot = create("Frame", {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0.5, -30 + i * 20, 1, -35),
            BackgroundColor3 = accent,
            BorderSizePixel = 0,
            Parent = card
        })
        corner(dot, 5)
        dots[i] = dot
    end
    
    task.spawn(function()
        local elapsed = 0
        while elapsed < duration do
            for i, dot in ipairs(dots) do
                task.delay(i * 0.15, function()
                    if dot.Parent then
                        tween(dot, 0.3, { BackgroundTransparency = 0.4 }):Play()
                        task.wait(0.3)
                        if dot.Parent then
                            tween(dot, 0.3, { BackgroundTransparency = 0 }):Play()
                        end
                    end
                end)
            end
            task.wait(0.9)
            elapsed = elapsed + 0.9
        end
        tween(card, 0.5, { Size = UDim2.new(0, 380, 0, 0), Position = UDim2.new(0.5, -190, 0.5, 0) }):Play()
        task.wait(0.5)
        tween(root, 0.3, { BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        screen:Destroy()
    end)
    return screen
end

-- ✅ BootGlop (Halloween)
function Library.BootGlop(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "HavaGlop"
    local sub = cfg.Subtitle or "Spooky"
    local image = cfg.Image and Library:ResolveImage(cfg.Image)
    local accent = cfg.AccentColor or Color3.fromRGB(255, 120, 0)
    local duration = cfg.Duration or 2.5
    
    local screen = create("ScreenGui", {
        Name = "BootGlop_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 5, 15),
        BorderSizePixel = 0,
        Parent = screen
    })
    
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 5, 15)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 15, 5)),
        }),
        Rotation = 45,
        Parent = root
    })
    
    if image then
        create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 0.7,
            Parent = root
        })
    end
    
    local glop = create("TextLabel", {
        Size = UDim2.new(0, 150, 0, 150),
        Position = UDim2.new(0.5, -75, 0.3, -75),
        BackgroundTransparency = 1,
        Text = cfg.Icon or "🎃",
        TextColor3 = accent,
        TextSize = 110,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = root
    })
    tween(glop, 0.7, { TextTransparency = 0 }):Play()
    
    task.spawn(function()
        local t = 0
        while glop.Parent and t < duration do
            tween(glop, 0.5, { TextSize = 130 }):Play()
            task.wait(0.5)
            if not glop.Parent then break end
            tween(glop, 0.5, { TextSize = 110 }):Play()
            task.wait(0.5)
            t = t + 1
        end
    end)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 34),
        Position = UDim2.new(0, 0, 0.55, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = accent,
        TextSize = 30,
        Font = Enum.Font.GothamBold,
        Parent = root
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.55, 58),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Color3.fromRGB(200, 150, 100),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Parent = root
    })
    
    local barBg = create("Frame", {
        Size = UDim2.new(0, 300, 0, 6),
        Position = UDim2.new(0.5, -150, 0.75, 0),
        BackgroundColor3 = Color3.fromRGB(40, 20, 10),
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
    
    task.spawn(function()
        for i = 1, 30 do
            local p = i / 30
            fill.Size = UDim2.new(p, 0, 1, 0)
            task.wait(duration / 30)
        end
        task.wait(0.3)
        tween(root, 0.5, { BackgroundTransparency = 1 }):Play()
        for _, c in ipairs(root:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, 0.5, { TextTransparency = 1 }):Play() end
            if c:IsA("Frame") then tween(c, 0.5, { BackgroundTransparency = 1 }):Play() end
            if c:IsA("ImageLabel") then tween(c, 0.5, { ImageTransparency = 1 }):Play() end
        end
        task.wait(0.5)
        screen:Destroy()
    end)
    return screen
end

-- ✅ BootWave
function Library.BootWave(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "HavaWave"
    local sub = cfg.Subtitle or "Smooth"
    local accent = cfg.AccentColor or Color3.fromRGB(100, 200, 255)
    local duration = cfg.Duration or 2.5
    
    local screen = create("ScreenGui", {
        Name = "BootWave_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 15, 25),
        BorderSizePixel = 0,
        Parent = screen
    })
    
    for i = 1, 3 do
        local wave = create("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = accent,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Parent = root
        })
        corner(wave, 999)
        
        task.spawn(function()
            task.wait(i * 0.2)
            tween(wave, 1.5, { Size = UDim2.new(2, 0, 2, 0), Position = UDim2.new(0.5, -0, 0.5, 0) }):Play()
            tween(wave, 1.5, { BackgroundTransparency = 1 }):Play()
        end)
    end
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.45, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = accent,
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        Parent = root
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.55, 0),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Color3.fromRGB(180, 200, 220),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Parent = root
    })
    
    task.spawn(function()
        task.wait(duration)
        tween(root, 0.5, { BackgroundTransparency = 1 }):Play()
        for _, c in ipairs(root:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, 0.5, { TextTransparency = 1 }):Play() end
            if c:IsA("Frame") then tween(c, 0.5, { BackgroundTransparency = 1 }):Play() end
        end
        task.wait(0.5)
        screen:Destroy()
    end)
    return screen
end

-- ✅ BootSimple
function Library.BootSimple(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Hava"
    local duration = cfg.Duration or 1.5
    local accent = cfg.AccentColor or Library.Theme.Accent
    
    local screen = create("ScreenGui", {
        Name = "BootSimple_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = screen
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0.5, -20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = accent,
        TextSize = 32,
        Font = Enum.Font.GothamBold,
        Parent = root
    })
    
    task.spawn(function()
        task.wait(duration)
        tween(root, 0.3, { BackgroundTransparency = 1 }):Play()
        for _, c in ipairs(root:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, 0.3, { TextTransparency = 1 }):Play() end
        end
        task.wait(0.3)
        screen:Destroy()
    end)
    return screen
end

-- Alias
function Library.Boot(cfg)
    cfg = cfg or {}
    local style = (cfg.Style or "Pro"):lower()
    if style == "x" then return Library.BootX(cfg)
    elseif style == "glop" then return Library.BootGlop(cfg)
    elseif style == "wave" then return Library.BootWave(cfg)
    elseif style == "simple" then return Library.BootSimple(cfg)
    else return Library.BootPro(cfg)
    end
end

-- ═══════════════════════════════════════════════════════════════════
--                     Key System
-- ═══════════════════════════════════════════════════════════════════
function Library.KeySystem(cfg)
    cfg = cfg or {}
    local keys = cfg.Keys or {"NovaKey"}
    local title = cfg.Title or "Key System"
    local sub = cfg.Subtitle or "Enter your key"
    local link = cfg.Link or ""
    local saveKey = cfg.SaveKey ~= false
    local fileName = cfg.FileName or "NovaKey"
    
    if saveKey and isfile and isfile(fileName) then
        local saved = readfile(fileName)
        for _, k in ipairs(keys) do
            if saved == k then return true end
        end
    end
    
    local keyGui = create("ScreenGui", {
        Name = "NovaKey_" .. math.random(1000, 9999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local bg = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BorderSizePixel = 0,
        Parent = keyGui
    })
    
    local box = create("Frame", {
        Size = UDim2.new(0, 350, 0, 320),
        Position = UDim2.new(0.5, -175, 0.5, -160),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = bg
    })
    corner(box, 16)
    stroke(box, Library.Theme.Accent, 2)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "🔐 " .. title,
        TextColor3 = Library.Theme.Accent,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Parent = box
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 20, 0, 65),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Library.Theme.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        Parent = box
    })
    
    if link ~= "" then
        local linkBtn = create("TextButton", {
            Size = UDim2.new(1, -40, 0, 32),
            Position = UDim2.new(0, 20, 0, 100),
            BackgroundColor3 = Library.Theme.AccentAlt,
            Text = "🔗 نسخ الرابط",
            TextColor3 = Library.Theme.Text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            BorderSizePixel = 0,
            Parent = box
        })
        corner(linkBtn, 8)
        linkBtn.Activated:Connect(function()
            if setclipboard then
                setclipboard(link)
                linkBtn.Text = "✅ تم النسخ!"
                task.wait(1.5)
                linkBtn.Text = "🔗 نسخ الرابط"
            end
        end)
    end
    
    local input = create("TextBox", {
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, link ~= "" and 145 or 110),
        BackgroundColor3 = Library.Theme.Element,
        Text = "",
        PlaceholderText = "أدخل المفتاح هنا...",
        PlaceholderColor3 = Library.Theme.SubText,
        TextColor3 = Library.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Parent = box
    })
    corner(input, 8)
    
    local status = create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 20, 0, link ~= "" and 195 or 160),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(220, 60, 60),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = box
    })
    
    local submit = create("TextButton", {
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, link ~= "" and 225 or 190),
        BackgroundColor3 = Library.Theme.Accent,
        Text = "دخول",
        TextColor3 = Library.Theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = box
    })
    corner(submit, 8)
    
    local success = false
    submit.Activated:Connect(function()
        local entered = input.Text
        for _, k in ipairs(keys) do
            if entered == k then
                if saveKey and writefile then
                    pcall(function() writefile(fileName, entered) end)
                end
                success = true
                tween(box, 0.3, { Size = UDim2.new(0, 350, 0, 0) }):Play()
                task.wait(0.3)
                keyGui:Destroy()
                return
            end
        end
        status.Text = "❌ مفتاح غير صحيح!"
    end)
    
    repeat task.wait(0.1) until success
    return true
end

-- ═══════════════════════════════════════════════════════════════════
--                     Notify
-- ═══════════════════════════════════════════════════════════════════
function Library:Notify(cfg)
    cfg = cfg or {}
    local gui = create("ScreenGui", {
        Name = "NovaNotif_" .. math.random(1000, 9999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local frame = create("Frame", {
        Size = UDim2.new(0, 320, 0, 80),
        Position = UDim2.new(1, 20, 0, 100),
        BackgroundColor3 = Library.Theme.Background,
        BorderSizePixel = 0,
        Parent = gui
    })
    corner(frame, 12)
    stroke(frame, Library.Theme.Accent, 1.5)
    
    create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.new(0, 15, 0, 12),
        BackgroundTransparency = 1,
        Text = cfg.Title or "Notification",
        TextColor3 = Library.Theme.Accent,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 40),
        Position = UDim2.new(0, 15, 0, 32),
        BackgroundTransparency = 1,
        Text = cfg.Content or "",
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = frame
    })
    
    tween(frame, 0.4, { Position = UDim2.new(1, -340, 0, 100) }, Enum.EasingStyle.Back):Play()
    
    task.delay(cfg.Duration or 5, function()
        tween(frame, 0.4, { Position = UDim2.new(1, 20, 0, 100) }):Play()
        task.wait(0.4)
        gui:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--                     Save/Load Config
-- ═══════════════════════════════════════════════════════════════════
function Library:SaveConfig(fileName)
    if not writefile then
        self:Notify({ Title = "Error", Content = "❌ الحفظ غير مدعوم", Duration = 3 })
        return
    end
    fileName = fileName or "NovaConfig.json"
    local data = HttpService:JSONEncode(Library.Flags)
    pcall(function() writefile(fileName, data) end)
    self:Notify({ Title = "Saved", Content = "✅ تم حفظ الإعدادات", Duration = 3 })
end

function Library:LoadConfig(fileName)
    if not (readfile and isfile) then
        self:Notify({ Title = "Error", Content = "❌ التحميل غير مدعوم", Duration = 3 })
        return
    end
    fileName = fileName or "NovaConfig.json"
    if not isfile(fileName) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
    if not ok or type(data) ~= "table" then return end
    for _, el in ipairs(Library.Elements) do
        if el.flag and data[el.flag] ~= nil and el.Set then
            pcall(el.Set, data[el.flag])
        end
    end
    self:Notify({ Title = "Loaded", Content = "✅ تم تحميل الإعدادات", Duration = 3 })
end

-- ═══════════════════════════════════════════════════════════════════
--                     Window
-- ═══════════════════════════════════════════════════════════════════
function Library.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Library)
    self.Title = cfg.Title or "Hava"
    self.Subtitle = cfg.Subtitle or "v11.1"
    self.Icon = cfg.Icon or "⚡"
    self.Size = cfg.Size or UDim2.new(0, 560, 0, 400)
    self.ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.IsOpen = false
    self.Tabs = {}
    self.CurrentTab = nil
    
    self.ScreenGui = create("ScreenGui", {
        Name = "HavaUI_" .. math.random(10000, 99999),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 2147483647,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    self:_buildWindow()
    self:_buildToggle()
    self:_bindHotkey()
    table.insert(Library.Windows, self)
    return self
end

function Library:_buildWindow()
    local win = create("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2),
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Visible = false,
        Active = true,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })
    corner(win, Library.Theme.CornerRadius)
    stroke(win, Library.Theme.Accent, 1.5)
    self.Window = win
    
    local sidebar = create("Frame", {
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = Library.Theme.GlassMode and 0.2 or 0,
        BorderSizePixel = 0,
        Parent = win
    })
    corner(sidebar, Library.Theme.CornerRadius)
    
    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 65),
        BackgroundTransparency = 1,
        Active = true,
        Parent = sidebar
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 14, 0, 12),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Library.Theme.Accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 14, 0, 34),
        BackgroundTransparency = 1,
        Text = self.Subtitle,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })
    
    local tabs = create("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -75),
        Position = UDim2.new(0, 6, 0, 68),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true,
        Parent = sidebar
    })
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = tabs })
    self.TabHolder = tabs
    
    local content = create("ScrollingFrame", {
        Size = UDim2.new(1, -160, 1, -20),
        Position = UDim2.new(0, 154, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Library.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true,
        Parent = win
    })
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = content })
    self.Content = content
    
    local closeBtn = create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -28, 0, 8),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "✕",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Active = true,
        Parent = win
    })
    corner(closeBtn, 11)
    closeBtn.Activated:Connect(function() self:Close() end)
    
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

function Library:_buildToggle()
    local btn = create("TextButton", {
        Size = UDim2.new(0, 58, 0, 58),
        Position = UDim2.new(0, 20, 0.5, -29),
        BackgroundColor3 = Library.Theme.Background,
        Text = "",
        AutoButtonColor = false,
        Active = true,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    corner(btn, 29)
    stroke(btn, Library.Theme.Accent, 2)
    
    local icon = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = self.Icon,
        TextColor3 = Library.Theme.Accent,
        TextSize = 26,
        Font = Enum.Font.GothamBold,
        Parent = btn
    })
    
    task.spawn(function()
        while btn.Parent do
            tween(icon, 1.4, { TextTransparency = 0.35 }):Play()
            task.wait(1.4)
            if not btn.Parent then break end
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
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not moved then self:Toggle() end
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
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                         startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end)
    self.ToggleBtn = btn
end

function Library:_bindHotkey()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then self:Toggle() end
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
    task.delay(0.2, function() self.Window.Visible = false end)
end

function Library:Toggle()
    if self.IsOpen then self:Close() else self:Open() end
end

function Library:SetEnabled(state)
    Library.Enabled = state
    for _, el in ipairs(Library.Elements) do
        if el.SetEnabled then pcall(el.SetEnabled, state) end
    end
    if Library.MasterBtn and Library.MasterBtn.Set then
        pcall(Library.MasterBtn.Set, state)
    end
end

function Library:UpdateTheme()
    if not self.Window then return end
    tween(self.Window, 0.3, {
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
    }):Play()
end

-- ═══════════════════════════════════════════════════════════════════
--                     AddTab
-- ═══════════════════════════════════════════════════════════════════
function Library:AddTab(name, icon)
    local tab = { Name = name, Elements = {}, Enabled = true }
    
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Library.Theme.Element,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        Active = true,
        Parent = self.TabHolder
    })
    corner(btn, Library.Theme.CornerRadius)
    
    local indicator = create("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Parent = btn
    })
    corner(indicator, 2)
    
    local iconLbl = create("TextLabel", {
        Size = UDim2.new(0, 18, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = icon or "",
        TextColor3 = Library.Theme.SubText,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = btn
    })
    
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -36, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = btn
    })
    
    tab.Button, tab.Label, tab.Icon, tab.Indicator = btn, lbl, iconLbl, indicator
    
    local page = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = page })
    tab.Page = page
    
    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then tween(btn, 0.15, { BackgroundTransparency = 0.5 }):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then tween(btn, 0.15, { BackgroundTransparency = 1 }):Play() end
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
        tween(t.Button, 0.15, { BackgroundTransparency = 1 }):Play()
        tween(t.Label, 0.15, { TextColor3 = Library.Theme.SubText }):Play()
        tween(t.Icon, 0.15, { TextColor3 = Library.Theme.SubText }):Play()
        tween(t.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 0) }):Play()
    end
    tab.Page.Visible = true
    tween(tab.Button, 0.15, { BackgroundTransparency = 0 }):Play()
    tab.Button.BackgroundColor3 = Library.Theme.Element
    tween(tab.Label, 0.15, { TextColor3 = Library.Theme.Text }):Play()
    tween(tab.Icon, 0.15, { TextColor3 = Library.Theme.Accent }):Play()
    tween(tab.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 18) }):Play()
    self.CurrentTab = tab
end

-- ═══════════════════════════════════════════════════════════════════
--                     Elements
-- ═══════════════════════════════════════════════════════════════════
function Library:AddSection(tab, text)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "▸ " .. text:upper(),
        TextColor3 = Library.Theme.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
end

function Library:AddLabel(tab, text)
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        Text = "  " .. text,
        TextColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = tab.Page
    })
    corner(lbl, Library.Theme.CornerRadius)
    return lbl
end

function Library:AddParagraph(tab, title, text)
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    create("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = c })
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = c })
    if title then
        create("TextLabel", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
            Text = title, TextColor3 = Library.Theme.Text, TextSize = 13,
            Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 1, Parent = c })
    end
    create("TextLabel", { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
        Text = text, TextColor3 = Library.Theme.SubText, TextSize = 12,
        Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = c })
    return c
end

function Library:AddDivider(tab)
    return create("Frame", { Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Library.Theme.Stroke, BorderSizePixel = 0, Parent = tab.Page })
end

function Library:AddButton(tab, label, callback, color, icon)
    color = color or Library.Theme.Accent
    local el = { enabled = true }
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = color,
        Text = icon and (icon .. "  " .. label) or label,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Active = true,
        AutoButtonColor = false,
        Parent = tab.Page
    })
    corner(btn, Library.Theme.CornerRadius)
    
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
    el.SetColor = function(c)
        color = c
        btn.BackgroundColor3 = c
    end
    table.insert(Library.Elements, el)
    return el
end

function Library:AddToggle(tab, label, default, flag, callback)
    local state = default or false
    local el = { enabled = true, flag = flag }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local dot = create("Frame", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -48, 0.5, -9),
        BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = c
    })
    corner(dot, 9)
    
    local knob = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
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
    
    local function setState(v)
        state = v
        tween(dot, 0.2, { BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element }):Play()
        tween(knob, 0.2, { Position = state and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }):Play()
        if flag then Library.Flags[flag] = state end
        if callback then pcall(callback, state) end
    end
    
    hit.Activated:Connect(function()
        if not el.enabled then return end
        setState(not state)
    end)
    
    el.Set = setState
    el.Get = function() return state end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    el.SetColor = function(color)
        dot.BackgroundColor3 = color
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddSlider(tab, label, min, max, default, flag, callback)
    min, max = min or 0, max or 100
    local value = default or min
    local el = { enabled = true, flag = flag }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
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
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = c
    })
    
    local barTouch = create("Frame", {
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 0, 30),
        BackgroundTransparency = 1,
        Active = true,
        Parent = c
    })
    
    local barBg = create("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0.5, -4),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Parent = barTouch
    })
    corner(barBg, 4)
    
    local fill = create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Parent = barBg
    })
    corner(fill, 4)
    
    local knob = create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new((value - min) / (max - min), -9, 0.5, -9),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = barTouch
    })
    corner(knob, 9)
    stroke(knob, Library.Theme.Accent, 2)
    
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
        tween(fill, 0.1, { Size = UDim2.new(rel, 0, 1, 0) }):Play()
        tween(knob, 0.1, { Position = UDim2.new(rel, -9, 0.5, -9) }):Play()
        if flag then Library.Flags[flag] = value end
        if callback then pcall(callback, value) end
    end
    
    barTouch.InputBegan:Connect(function(input)
        if not el.enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            if scrollParent then scrollParent.ScrollingEnabled = false end
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
            end
        end
    end)
    
    el.Set = function(v)
        value = math.clamp(v, min, max)
        local rel = (value - min) / (max - min)
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -9, 0.5, -9)
        if flag then Library.Flags[flag] = value end
        if callback then pcall(callback, value) end
    end
    el.Get = function() return value end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    el.SetColor = function(color)
        fill.BackgroundColor3 = color
        local kst = knob:FindFirstChildOfClass("UIStroke")
        if kst then kst.Color = color end
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddDropdown(tab, label, options, default, flag, callback)
    local current = default or options[1]
    local expanded = false
    local el = { enabled = true, flag = flag }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local valBtn = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 12, 0, 26),
        BackgroundColor3 = Library.Theme.Element,
        Text = tostring(current) .. "  ▾",
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        Active = true,
        Parent = c
    })
    corner(valBtn, 4)
    
    local listFrame = create("Frame", {
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, 54),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = c
    })
    corner(listFrame, 4)
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = listFrame })
    create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = listFrame })
    
    valBtn.Activated:Connect(function()
        if not el.enabled then return end
        expanded = not expanded
        listFrame.Visible = expanded
        if expanded then
            listFrame.Size = UDim2.new(1, -24, 0, #options * 22 + 8)
            tween(c, 0.25, { Size = UDim2.new(1, 0, 0, 56 + #options * 22 + 12) }):Play()
        else
            listFrame.Size = UDim2.new(1, -24, 0, 0)
            tween(c, 0.25, { Size = UDim2.new(1, 0, 0, 56) }):Play()
        end
    end)
    
    for i, opt in ipairs(options) do
        local oBtn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundColor3 = Library.Theme.Element,
            Text = tostring(opt),
            TextColor3 = Library.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            LayoutOrder = i,
            Active = true,
            Parent = listFrame
        })
        corner(oBtn, 3)
        oBtn.MouseEnter:Connect(function() tween(oBtn, 0.1, { BackgroundColor3 = Library.Theme.Hover }):Play() end)
        oBtn.MouseLeave:Connect(function() oBtn.BackgroundColor3 = Library.Theme.Element end)
        oBtn.Activated:Connect(function()
            current = opt
            valBtn.Text = tostring(opt) .. "  ▾"
            expanded = false
            listFrame.Visible = false
            listFrame.Size = UDim2.new(1, -24, 0, 0)
            tween(c, 0.25, { Size = UDim2.new(1, 0, 0, 56) }):Play()
            if flag then Library.Flags[flag] = opt end
            if callback then pcall(callback, opt) end
        end)
    end
    
    el.Set = function(v)
        current = v
        valBtn.Text = tostring(v) .. "  ▾"
        if flag then Library.Flags[flag] = v end
        if callback then pcall(callback, v) end
    end
    el.Get = function() return current end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddInput(tab, label, default, isNumber, flag, callback)
    local el = { enabled = true, flag = flag }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local box = create("TextBox", {
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 12, 0, 26),
        BackgroundColor3 = Library.Theme.Element,
        Text = tostring(default or ""),
        TextColor3 = Library.Theme.Text,
        PlaceholderText = isNumber and "أدخل رقم..." or "أدخل نص...",
        PlaceholderColor3 = Library.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
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
                if flag then Library.Flags[flag] = n end
                if callback then pcall(callback, n) end
            else
                box.Text = tostring(default or 0)
            end
        else
            if flag then Library.Flags[flag] = box.Text end
            if callback then pcall(callback, box.Text) end
        end
    end)
    
    el.Set = function(v)
        box.Text = tostring(v)
        if flag then Library.Flags[flag] = v end
        if callback then pcall(callback, v) end
    end
    el.Get = function() return box.Text end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddColorPicker(tab, label, default, flag, callback)
    local color = default or Color3.fromRGB(138, 43, 226)
    local el = { enabled = true, flag = flag }
    local hue, sat, val = color:ToHSV()
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local preview = create("TextButton", {
        Size = UDim2.new(1, -24, 0, 30),
        Position = UDim2.new(0, 12, 0, 26),
        BackgroundColor3 = color,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Active = true,
        Parent = c
    })
    corner(preview, 6)
    stroke(preview, Library.Theme.Stroke, 1)
    
    local panel = create("Frame", {
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, 62),
        BackgroundColor3 = Library.Theme.Element,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        Parent = c
    })
    corner(panel, 8)
    
    local sv = create("Frame", {
        Size = UDim2.new(1, -16, 0, 100),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        BorderSizePixel = 0,
        Active = true,
        Parent = panel
    })
    corner(sv, 6)
    
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = sv
    })
    
    local hueBar = create("Frame", {
        Size = UDim2.new(1, -16, 0, 16),
        Position = UDim2.new(0, 8, 0, 114),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Active = true,
        Parent = panel
    })
    corner(hueBar, 8)
    
    create("UIGradient", {
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
    
    local hexBox = create("TextBox", {
        Size = UDim2.new(1, -16, 0, 24),
        Position = UDim2.new(0, 8, 0, 138),
        BackgroundColor3 = Library.Theme.Background,
        Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255),
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Code,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Active = true,
        Parent = panel
    })
    corner(hexBox, 4)
    
    local activeDrag = nil
    
    local function apply()
        color = Color3.fromHSV(hue, sat, val)
        preview.BackgroundColor3 = color
        hexBox.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
        sv.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        if flag then Library.Flags[flag] = color end
        if callback then pcall(callback, color) end
    end
    
    sv.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = "sv"
            sat = math.clamp((input.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp((input.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            apply()
        end
    end)
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = "hue"
            hue = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            apply()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            if activeDrag == "sv" then
                sat = math.clamp((input.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
                val = 1 - math.clamp((input.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            elseif activeDrag == "hue" then
                hue = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
            end
            apply()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = nil
        end
    end)
    
    hexBox.FocusLost:Connect(function()
        local hex = hexBox.Text:gsub("#", "")
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        if r and g and b then
            color = Color3.fromRGB(r, g, b)
            hue, sat, val = color:ToHSV()
            apply()
        end
    end)
    
    local expanded = false
    preview.Activated:Connect(function()
        expanded = not expanded
        panel.Visible = expanded
        if expanded then
            panel.Size = UDim2.new(1, -24, 0, 170)
            tween(c, 0.3, { Size = UDim2.new(1, 0, 0, 240) }):Play()
        else
            panel.Size = UDim2.new(1, -24, 0, 0)
            tween(c, 0.3, { Size = UDim2.new(1, 0, 0, 60) }):Play()
        end
    end)
    
    el.Set = function(v)
        if typeof(v) == "Color3" then
            color = v
            hue, sat, val = v:ToHSV()
        end
        apply()
    end
    el.Get = function() return color end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddList(tab, label, options, defaultSelected, flag, callback)
    local selected = defaultSelected or {}
    local el = { enabled = true, flag = flag }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40 + math.min(#options * 22, 200)),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local holder = create("ScrollingFrame", {
        Size = UDim2.new(1, -24, 0, math.min(#options * 22, 200)),
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
    create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = holder })
    create("UIPadding", { PaddingBottom = UDim.new(0, 4), Parent = holder })
    
    local buttons = {}
    for i, opt in ipairs(options) do
        local isSel = selected[opt] == true
        local row = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundColor3 = isSel and Library.Theme.AccentAlt or Library.Theme.Element,
            Text = (isSel and "☑  " or "☐  ") .. tostring(opt),
            TextColor3 = Library.Theme.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
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
            if flag then Library.Flags[flag] = selected end
            if callback then pcall(callback, selected) end
        end)
    end
    
    el.Set = function(tbl)
        selected = tbl or {}
        for opt, row in pairs(buttons) do
            local s = selected[opt] == true
            row.BackgroundColor3 = s and Library.Theme.AccentAlt or Library.Theme.Element
            row.Text = (s and "☑  " or "☐  ") .. tostring(opt)
        end
        if flag then Library.Flags[flag] = selected end
        if callback then pcall(callback, selected) end
    end
    el.Get = function() return selected end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddKeybind(tab, label, default, callback)
    local key = default or Enum.KeyCode.E
    local el = { enabled = true }
    local listening = false
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local keyBtn = create("TextButton", {
        Size = UDim2.new(0, 70, 0, 22),
        Position = UDim2.new(1, -82, 0.5, -11),
        BackgroundColor3 = Library.Theme.Element,
        Text = key.Name,
        TextColor3 = Library.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Active = true,
        Parent = c
    })
    corner(keyBtn, 4)
    
    keyBtn.Activated:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.BackgroundColor3 = Library.Theme.Accent
    end)
    
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                keyBtn.Text = key.Name
                keyBtn.BackgroundColor3 = Library.Theme.Element
                listening = false
            end
        elseif input.KeyCode == key then
            if callback then pcall(callback) end
        end
    end)
    
    el.Set = function(k)
        key = k
        keyBtn.Text = k.Name
    end
    el.Get = function() return key end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

function Library:AddEnableToggle(tab, label, default, callback)
    local state = default ~= false
    local el = { enabled = true }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = state and Color3.fromRGB(0, 200, 110) or Color3.fromRGB(220, 60, 60),
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    local lbl = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = (state and "✅  " or "⛔  ") .. label,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
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
        tween(c, 0.2, { BackgroundColor3 = state and Color3.fromRGB(0, 200, 110) or Color3.fromRGB(220, 60, 60) }):Play()
        lbl.Text = (state and "✅  " or "⛔  ") .. label
        Library:SetEnabled(state)
        if callback then pcall(callback, state) end
    end)
    
    el.Set = function(v)
        state = v
        c.BackgroundColor3 = state and Color3.fromRGB(0, 200, 110) or Color3.fromRGB(220, 60, 60)
        lbl.Text = (state and "✅  " or "⛔  ") .. label
    end
    
    if not Library.MasterBtn then Library.MasterBtn = el end
    return el
end

-- ═══════════════════════════════════════════════════════════════════
--                     🖼️ Image Slider
-- ═══════════════════════════════════════════════════════════════════
function Library:AddImageSlider(tab, images, interval)
    interval = interval or 3
    local currentIndex = 1
    
    local resolvedImages = {}
    for i, img in ipairs(images) do
        resolvedImages[i] = Library:ResolveImage(img)
    end
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = Library.Theme.Card,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    local img = create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = resolvedImages[1] or "",
        ScaleType = Enum.ScaleType.Crop,
        Parent = c
    })
    
    local dotsFrame = create("Frame", {
        Size = UDim2.new(0, #images * 16, 0, 20),
        Position = UDim2.new(0.5, -#images * 8, 1, -25),
        BackgroundTransparency = 1,
        Parent = c
    })
    create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center, Parent = dotsFrame })
    
    local dots = {}
    for i = 1, #images do
        local dot = create("Frame", {
            Size = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = i == 1 and Library.Theme.Accent or Color3.fromRGB(100, 100, 100),
            BorderSizePixel = 0,
            Parent = dotsFrame
        })
        corner(dot, 4)
        dots[i] = dot
    end
    
    task.spawn(function()
        while img.Parent do
            task.wait(interval)
            if not img.Parent then break end
            currentIndex = currentIndex + 1
            if currentIndex > #resolvedImages then currentIndex = 1 end
            
            tween(img, 0.5, { ImageTransparency = 1 }):Play()
            task.wait(0.5)
            if not img.Parent then break end
            img.Image = resolvedImages[currentIndex]
            tween(img, 0.5, { ImageTransparency = 0 }):Play()
            
            for i, dot in ipairs(dots) do
                if dot.Parent then
                    tween(dot, 0.3, { 
                        BackgroundColor3 = i == currentIndex and Library.Theme.Accent or Color3.fromRGB(100, 100, 100)
                    }):Play()
                end
            end
        end
    end)
    
    return c
end

-- ═══════════════════════════════════════════════════════════════════
--                     🆕 NumberRange
-- ═══════════════════════════════════════════════════════════════════
function Library:AddNumberRange(tab, label, min, max, defaultMin, defaultMax, flag, callback)
    min, max = min or 0, max or 100
    local currentMin = defaultMin or min
    local currentMax = defaultMax or max
    local el = { enabled = true, flag = flag }
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Library.Theme.Card,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
        BorderSizePixel = 0,
        Parent = tab.Page
    })
    corner(c, Library.Theme.CornerRadius)
    
    create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local valLbl = create("TextLabel", {
        Size = UDim2.new(1, -24, 0, 18),
        Position = UDim2.new(0, 12, 0, 26),
        BackgroundTransparency = 1,
        Text = currentMin .. " - " .. currentMax,
        TextColor3 = Library.Theme.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = c
    })
    
    local barTouch = create("Frame", {
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 12, 0, 44),
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
    
    local rangeFill = create("Frame", {
        Size = UDim2.new((currentMax - currentMin) / (max - min), 0, 1, 0),
        Position = UDim2.new((currentMin - min) / (max - min), 0, 0, 0),
        BackgroundColor3 = Library.Theme.Accent,
        BorderSizePixel = 0,
        Parent = barBg
    })
    corner(rangeFill, 3)
    
    local knobMin = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((currentMin - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = barTouch
    })
    corner(knobMin, 7)
    stroke(knobMin, Library.Theme.Accent, 2)
    
    local knobMax = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((currentMax - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Library.Theme.Text,
        BorderSizePixel = 0,
        Parent = barTouch
    })
    corner(knobMax, 7)
    stroke(knobMax, Library.Theme.Accent, 2)
    
    local activeKnob = nil
    local function updateVal()
        valLbl.Text = currentMin .. " - " .. currentMax
        rangeFill.Size = UDim2.new((currentMax - currentMin) / (max - min), 0, 1, 0)
        rangeFill.Position = UDim2.new((currentMin - min) / (max - min), 0, 0, 0)
        knobMin.Position = UDim2.new((currentMin - min) / (max - min), -7, 0.5, -7)
        knobMax.Position = UDim2.new((currentMax - min) / (max - min), -7, 0.5, -7)
        if flag then Library.Flags[flag] = {Min = currentMin, Max = currentMax} end
        if callback then pcall(callback, currentMin, currentMax) end
    end
    
    barTouch.InputBegan:Connect(function(input)
        if not el.enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            local rel = math.clamp((input.Position.X - barTouch.AbsolutePosition.X) / barTouch.AbsoluteSize.X, 0, 1)
            local val = min + (max - min) * rel
            if math.abs(val - currentMin) < math.abs(val - currentMax) then
                activeKnob = "min"
            else
                activeKnob = "max"
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if activeKnob and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((input.Position.X - barTouch.AbsolutePosition.X) / barTouch.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel + 0.5)
            if activeKnob == "min" then
                currentMin = math.min(val, currentMax)
            else
                currentMax = math.max(val, currentMin)
            end
            updateVal()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeKnob = nil
        end
    end)
    
    el.Set = function(mn, mx)
        currentMin = mn or currentMin
        currentMax = mx or currentMax
        updateVal()
    end
    el.Get = function() return currentMin, currentMax end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

-- ═══════════════════════════════════════════════════════════════════
--                     Return
-- ═══════════════════════════════════════════════════════════════════
return Library
