--[[
    ═══════════════════════════════════════════════════════════════════
    Nova Hava Library v9.0 — ULTIMATE
    ================================================================
    ✨ ثيمات متعددة (Default, iOS Glass, Black Shine, Red/White, Purple)
    🎬 3 Boot Screens مختلفة (Nova Old, Nova Now, Nova Update)
    🔐 Key System + Copy Link
    🎨 Slider محسّن + Toggle أنيميشن
    📱 Resize Handle (زاوية تفاعلية)
    🖼️ دعم الصور (Image Slider)
    🎛️ Advanced Color Picker
    ═══════════════════════════════════════════════════════════════════
]]

local Library = {}
Library.__index = Library

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

Library.Elements = {}
Library.Flags = {}
Library.MasterBtn = nil
Library.Enabled = true

-- ═══════════════════════════════════════════════════════════════════
--                     🎨 الثيمات
-- ═══════════════════════════════════════════════════════════════════

Library.Themes = {
    -- الثيم الافتراضي (بنفسجي داكن)
    Default = {
        Background      = Color3.fromRGB(20, 20, 26),
        BackgroundTrans = 0,
        Sidebar         = Color3.fromRGB(15, 15, 20),
        Card            = Color3.fromRGB(30, 30, 38),
        Element         = Color3.fromRGB(38, 38, 48),
        Hover           = Color3.fromRGB(48, 48, 60),
        Accent          = Color3.fromRGB(138, 43, 226),
        AccentAlt       = Color3.fromRGB(90, 30, 180),
        Text            = Color3.fromRGB(240, 240, 245),
        SubText         = Color3.fromRGB(150, 150, 170),
        Stroke          = Color3.fromRGB(50, 50, 65),
        Glow            = Color3.fromRGB(138, 43, 226),
        GlassMode       = false,
        CornerRadius    = 8,
    },
    
    -- iOS Glass (زجاجي شفاف)
    iOSGlass = {
        Background      = Color3.fromRGB(245, 245, 250),
        BackgroundTrans = 0.25,
        Sidebar         = Color3.fromRGB(220, 220, 230),
        Card            = Color3.fromRGB(255, 255, 255),
        Element         = Color3.fromRGB(230, 230, 240),
        Hover           = Color3.fromRGB(200, 200, 220),
        Accent          = Color3.fromRGB(0, 122, 255),
        AccentAlt       = Color3.fromRGB(100, 180, 255),
        Text            = Color3.fromRGB(20, 20, 30),
        SubText         = Color3.fromRGB(100, 100, 120),
        Stroke          = Color3.fromRGB(200, 200, 220),
        Glow            = Color3.fromRGB(0, 122, 255),
        GlassMode       = true,
        CornerRadius    = 14,
    },
    
    -- Black Shine (أسود لامع)
    BlackShine = {
        Background      = Color3.fromRGB(10, 10, 12),
        BackgroundTrans = 0.05,
        Sidebar         = Color3.fromRGB(5, 5, 8),
        Card            = Color3.fromRGB(20, 20, 24),
        Element         = Color3.fromRGB(28, 28, 34),
        Hover           = Color3.fromRGB(40, 40, 48),
        Accent          = Color3.fromRGB(255, 255, 255),
        AccentAlt       = Color3.fromRGB(180, 180, 180),
        Text            = Color3.fromRGB(255, 255, 255),
        SubText         = Color3.fromRGB(140, 140, 140),
        Stroke          = Color3.fromRGB(60, 60, 70),
        Glow            = Color3.fromRGB(255, 255, 255),
        GlassMode       = false,
        CornerRadius    = 10,
    },
    
    -- Red & White
    RedWhite = {
        Background      = Color3.fromRGB(245, 245, 245),
        BackgroundTrans = 0,
        Sidebar         = Color3.fromRGB(220, 50, 60),
        Card            = Color3.fromRGB(255, 255, 255),
        Element         = Color3.fromRGB(240, 240, 240),
        Hover           = Color3.fromRGB(230, 230, 230),
        Accent          = Color3.fromRGB(220, 50, 60),
        AccentAlt       = Color3.fromRGB(180, 30, 40),
        Text            = Color3.fromRGB(30, 30, 40),
        SubText         = Color3.fromRGB(120, 120, 130),
        Stroke          = Color3.fromRGB(220, 50, 60),
        Glow            = Color3.fromRGB(255, 100, 100),
        GlassMode       = false,
        CornerRadius    = 8,
    },
    
    -- Purple Dream
    PurpleDream = {
        Background      = Color3.fromRGB(30, 15, 50),
        BackgroundTrans = 0.1,
        Sidebar         = Color3.fromRGB(20, 10, 35),
        Card            = Color3.fromRGB(45, 25, 70),
        Element         = Color3.fromRGB(55, 35, 85),
        Hover           = Color3.fromRGB(70, 45, 105),
        Accent          = Color3.fromRGB(200, 100, 255),
        AccentAlt       = Color3.fromRGB(150, 50, 200),
        Text            = Color3.fromRGB(250, 240, 255),
        SubText         = Color3.fromRGB(180, 150, 210),
        Stroke          = Color3.fromRGB(100, 60, 150),
        Glow            = Color3.fromRGB(200, 100, 255),
        GlassMode       = false,
        CornerRadius    = 12,
    },
}

-- الثيم الحالي (افتراضي)
Library.Theme = {}
for k, v in pairs(Library.Themes.Default) do
    Library.Theme[k] = v
end

Library.CurrentThemeName = "Default"

-- دالة تغيير الثيم
function Library:SetTheme(themeName)
    if not Library.Themes[themeName] then
        warn("الثيم غير موجود:", themeName)
        return
    end
    
    Library.CurrentThemeName = themeName
    for k, v in pairs(Library.Themes[themeName]) do
        Library.Theme[k] = v
    end
    
    -- تحديث كل النوافذ المفتوحة
    for _, win in ipairs(Library.Windows or {}) do
        if win.UpdateTheme then
            win:UpdateTheme()
        end
    end
    
    return true
end

Library.Windows = {}

-- ═══════════════════════════════════════════════════════════════════
--                     مساعدات
-- ═══════════════════════════════════════════════════════════════════
local function create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

local function corner(p, r)
    return create("UICorner", { 
        CornerRadius = UDim.new(0, r or Library.Theme.CornerRadius or 8), 
        Parent = p 
    })
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
    local info = TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, false, d or 0)
    return TweenService:Create(o, info, p)
end

-- ═══════════════════════════════════════════════════════════════════
--                     🎬 Boot Screens (3 أنماط)
-- ═══════════════════════════════════════════════════════════════════

-- ═══ 1. Nova Old (كلاسيكي - بسيط) ═══
function Library.BootOld(cfg)
    cfg = cfg or {}
    local bg = cfg.BackgroundColor or Color3.fromRGB(15, 15, 20)
    local accent = cfg.AccentColor or Color3.fromRGB(138, 43, 226)
    local title = cfg.Title or "Nova Hava"
    local sub = cfg.Subtitle or "Loading..."
    local image = cfg.Image
    local duration = cfg.Duration or 2.5
    
    local screen = create("ScreenGui", {
        Name = "NovaBootOld_" .. math.random(1000, 9999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- صورة الخلفية (اختياري)
    if image then
        local bgImg = create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 1,
            Parent = screen
        })
        tween(bgImg, 1, { ImageTransparency = 0.5 }):Play()
    end
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = bg,
        BackgroundTransparency = image and 0.7 or 0,
        BorderSizePixel = 0,
        Parent = screen
    })
    
    -- شعار
    local logo = create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 100),
        Position = UDim2.new(0.5, -100, 0.4, -50),
        BackgroundTransparency = 1,
        Text = "⚡",
        TextColor3 = accent,
        TextSize = 72,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = root
    })
    tween(logo, 0.6, { TextTransparency = 0 }):Play()
    
    -- العنوان
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.5, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(240, 240, 245),
        TextSize = 26,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = root
    })
    tween(titleLbl, 0.6, { TextTransparency = 0 }):Play()
    
    -- النص الفرعي
    local subLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 50),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextTransparency = 1,
        Parent = root
    })
    tween(subLbl, 0.6, { TextTransparency = 0 }):Play()
    
    -- شريط التقدم
    local barBg = create("Frame", {
        Size = UDim2.new(0, 300, 0, 4),
        Position = UDim2.new(0.5, -150, 0.5, 90),
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
    
    -- نسبة
    local pct = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 110),
        BackgroundTransparency = 1,
        Text = "0%",
        TextColor3 = Color3.fromRGB(150, 150, 170),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = root
    })
    
    -- تحريك
    task.spawn(function()
        local steps = 30
        for i = 1, steps do
            local p = i / steps
            tween(fill, duration / steps, { Size = UDim2.new(p, 0, 1, 0) }):Play()
            pct.Text = math.floor(p * 100) .. "%"
            task.wait(duration / steps)
        end
        task.wait(0.3)
        
        -- إغلاق
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

-- ═══ 2. Nova Now (حديث - glassy) ═══
function Library.BootNow(cfg)
    cfg = cfg or {}
    local bg = cfg.BackgroundColor or Color3.fromRGB(0, 0, 0)
    local accent = cfg.AccentColor or Color3.fromRGB(0, 122, 255)
    local title = cfg.Title or "Nova Hava"
    local sub = cfg.Subtitle or "Modern UI"
    local image = cfg.Image
    local duration = cfg.Duration or 2.5
    
    local screen = create("ScreenGui", {
        Name = "NovaBootNow_" .. math.random(1000, 9999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- خلفية زجاجية
    local bg1 = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = bg,
        BorderSizePixel = 0,
        Parent = screen
    })
    
    -- صورة الخلفية
    if image then
        local bgImg = create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 0.4,
            Parent = bg1
        })
    end
    
    -- طبقة زجاجية
    local glass = create("Frame", {
        Size = UDim2.new(0, 400, 0, 250),
        Position = UDim2.new(0.5, -200, 0.5, -125),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Parent = bg1
    })
    corner(glass, 24)
    stroke(glass, Color3.fromRGB(255, 255, 255), 2).Transparency = 0.5
    
    -- Blur effect
    local blur = create("BlurEffect", {
        Size = 24,
        Parent = game:GetService("Lighting")
    })
    
    -- الأيقونة الدائرية
    local circle = create("Frame", {
        Size = UDim2.new(0, 100, 0, 100),
        Position = UDim2.new(0.5, -50, 0, 20),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = glass
    })
    corner(circle, 50)
    
    local icon = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "⚡",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 48,
        Font = Enum.Font.GothamBold,
        Parent = circle
    })
    
    -- العنوان
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 135),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(30, 30, 40),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextTransparency = 1,
        Parent = glass
    })
    tween(titleLbl, 0.6, { TextTransparency = 0 }):Play()
    
    local subLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 165),
        BackgroundTransparency = 1,
        Text = sub,
        TextColor3 = Color3.fromRGB(120, 120, 140),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextTransparency = 1,
        Parent = glass
    })
    tween(subLbl, 0.6, { TextTransparency = 0 }):Play()
    
    -- شريط تحميل دائري (dots)
    local dots = {}
    for i = 1, 3 do
        local dot = create("Frame", {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0.5, -30 + i * 20, 1, -30),
            BackgroundColor3 = accent,
            BorderSizePixel = 0,
            Parent = glass
        })
        corner(dot, 5)
        table.insert(dots, dot)
    end
    
    -- Animation
    task.spawn(function()
        -- Animating icon
        tween(circle, 0.5, { Size = UDim2.new(0, 110, 0, 110), Position = UDim2.new(0.5, -55, 0, 15) }):Play()
        task.wait(0.5)
        tween(circle, 0.5, { Size = UDim2.new(0, 100, 0, 100), Position = UDim2.new(0.5, -50, 0, 20) }):Play()
        
        -- Dots animation
        local t = 0
        while t < duration do
            for i, dot in ipairs(dots) do
                task.spawn(function()
                    task.wait(i * 0.15)
                    tween(dot, 0.3, { BackgroundTransparency = 0.3 }):Play()
                    task.wait(0.3)
                    tween(dot, 0.3, { BackgroundTransparency = 0 }):Play()
                end)
            end
            task.wait(0.9)
            t = t + 0.9
        end
        
        -- إغلاق
        tween(glass, 0.5, { Size = UDim2.new(0, 400, 0, 0), Position = UDim2.new(0.5, -200, 0.5, 0) }):Play()
        task.wait(0.5)
        tween(bg1, 0.3, { BackgroundTransparency = 1 }):Play()
        blur.Size = 0
        task.wait(0.3)
        blur:Destroy()
        screen:Destroy()
    end)
    
    return screen
end

-- ═══ 3. Nova Update (تحديث - أنيق) ═══
function Library.BootUpdate(cfg)
    cfg = cfg or {}
    local bg = cfg.BackgroundColor or Color3.fromRGB(25, 20, 40)
    local accent = cfg.AccentColor or Color3.fromRGB(255, 100, 200)
    local title = cfg.Title or "Nova Hava"
    local version = cfg.Version or "v9.0"
    local image = cfg.Image
    local duration = cfg.Duration or 2.5
    local changelog = cfg.Changelog or {
        "✨ New themes added",
        "🎨 Improved UI",
        "🚀 Faster loading",
    }
    
    local screen = create("ScreenGui", {
        Name = "NovaBootUpdate_" .. math.random(1000, 9999),
        ResetOnSpawn = false,
        DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LocalPlayer:WaitForChild("PlayerGui")
    })
    
    local root = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = bg,
        BorderSizePixel = 0,
        Parent = screen
    })
    
    -- صورة خلفية
    if image then
        local bgImg = create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = image,
            ScaleType = Enum.ScaleType.Crop,
            ImageTransparency = 0.6,
            Parent = root
        })
    end
    
    -- Gradient background
    local gradient = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, bg),
            ColorSequenceKeypoint.new(1, accent:Lerp(bg, 0.7)),
        }),
        Rotation = 45,
        Parent = root
    })
    
    -- Header
    local header = create("Frame", {
        Size = UDim2.new(1, 0, 0, 120),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = root
    })
    
    -- Logo (animated)
    local logo = create("Frame", {
        Size = UDim2.new(0, 70, 0, 70),
        Position = UDim2.new(0.5, -35, 0, 30),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = header
    })
    corner(logo, 20)
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "⚡",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 36,
        Font = Enum.Font.GothamBold,
        Parent = logo
    })
    
    -- Title
    local titleLbl = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 26),
        Position = UDim2.new(0, 0, 0, 110),
        BackgroundTransparency = 1,
        Text = title .. "  " .. version,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        Parent = header
    })
    
    -- Changelog Frame
    local logFrame = create("Frame", {
        Size = UDim2.new(0, 400, 0, 0),
        Position = UDim2.new(0.5, -200, 0, 180),
        BackgroundColor3 = bg:Lerp(Color3.fromRGB(255, 255, 255), 0.1),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = root
    })
    corner(logFrame, 12)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        Parent = logFrame
    })
    
    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "🎉 What's New",
        TextColor3 = accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = logFrame
    })
    
    local logLayout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = logFrame
    })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 30),
        Parent = logFrame
    })
    
    for i, line in ipairs(changelog) do
        local lbl = create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = line,
            TextColor3 = Color3.fromRGB(220, 220, 240),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = i,
            TextTransparency = 1,
            Parent = logFrame
        })
        task.delay(i * 0.15, function()
            tween(lbl, 0.3, { TextTransparency = 0 }):Play()
        end)
    end
    
    -- Progress Bar
    local barBg = create("Frame", {
        Size = UDim2.new(0, 400, 0, 6),
        Position = UDim2.new(0.5, -200, 1, -50),
        BackgroundColor3 = Color3.fromRGB(40, 40, 60),
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
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, accent),
            ColorSequenceKeypoint.new(1, accent:Lerp(Color3.fromRGB(255, 255, 255), 0.4)),
        }),
        Parent = fill
    })
    
    -- Animations
    task.spawn(function()
        -- Pulse logo
        task.spawn(function()
            while logo.Parent do
                tween(logo, 1, { Size = UDim2.new(0, 80, 0, 80), Position = UDim2.new(0.5, -40, 0, 25) }):Play()
                task.wait(1)
                tween(logo, 1, { Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(0.5, -35, 0, 30) }):Play()
                task.wait(1)
            end
        end)
        
        -- Progress
        local steps = 30
        for i = 1, steps do
            local p = i / steps
            tween(fill, duration / steps, { Size = UDim2.new(p, 0, 1, 0) }):Play()
            task.wait(duration / steps)
        end
        task.wait(0.5)
        
        -- Close
        tween(root, 0.6, { BackgroundTransparency = 1 }):Play()
        for _, c in ipairs(root:GetDescendants()) do
            if c:IsA("TextLabel") then tween(c, 0.6, { TextTransparency = 1 }):Play() end
            if c:IsA("Frame") then tween(c, 0.6, { BackgroundTransparency = 1 }):Play() end
            if c:IsA("ImageLabel") then tween(c, 0.6, { ImageTransparency = 1 }):Play() end
        end
        task.wait(0.6)
        screen:Destroy()
    end)
    
    return screen
end

-- Alias - Boot يدعم الأنماط الثلاثة
function Library.Boot(cfg)
    cfg = cfg or {}
    local style = cfg.Style or "Old"
    
    if style == "Now" then
        return Library.BootNow(cfg)
    elseif style == "Update" then
        return Library.BootUpdate(cfg)
    else
        return Library.BootOld(cfg)
    end
end

-- ═══════════════════════════════════════════════════════════════════
--                     🔐 Key System
-- ═══════════════════════════════════════════════════════════════════
function Library.KeySystem(cfg)
    cfg = cfg or {}
    local keys = cfg.Keys or {"NovaKey"}
    local title = cfg.Title or "Key System"
    local sub = cfg.Subtitle or "Enter your key"
    local link = cfg.Link or "https://discord.gg/your-server"
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
    
    -- Copy Link Button
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
    
    local input = create("TextBox", {
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 145),
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
        Position = UDim2.new(0, 20, 0, 195),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(220, 60, 60),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Parent = box
    })
    
    local submit = create("TextButton", {
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 225),
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
--                     🎬 Slider محسّن مع أنيميشن
-- ═══════════════════════════════════════════════════════════════════
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
    if Library.Theme.GlassMode then
        stroke(c, Library.Theme.Stroke, 1).Transparency = 0.7
    end
    
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
    
    -- Glow effect
    local glow = create("ImageLabel", {
        Size = UDim2.new(1, 20, 3, 20),
        Position = UDim2.new(0, -10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Library.Theme.Glow,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = fill
    })
    
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
            tween(knob, 0.15, { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(knob.Position.X.Scale, -11, 0.5, -11) }):Play()
            tween(glow, 0.15, { ImageTransparency = 0.4 }):Play()
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
                tween(knob, 0.2, { Size = UDim2.new(0, 18, 0, 18) }):Play()
                tween(glow, 0.2, { ImageTransparency = 0.7 }):Play()
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
    
    table.insert(Library.Elements, el)
    return el
end

-- ═══════════════════════════════════════════════════════════════════
--                     🖼️ Image Slider (جديد)
-- ═══════════════════════════════════════════════════════════════════
function Library:AddImageSlider(tab, images, interval)
    interval = interval or 3
    local currentIndex = 1
    
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
        Image = images[1] or "",
        ScaleType = Enum.ScaleType.Crop,
        Parent = c
    })
    
    -- Dots indicator
    local dotsFrame = create("Frame", {
        Size = UDim2.new(0, #images * 16, 0, 20),
        Position = UDim2.new(0.5, -#images * 8, 1, -25),
        BackgroundTransparency = 1,
        Parent = c
    })
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Parent = dotsFrame
    })
    
    local dots = {}
    for i = 1, #images do
        local dot = create("Frame", {
            Size = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = i == 1 and Library.Theme.Accent or Color3.fromRGB(100, 100, 100),
            BorderSizePixel = 0,
            Parent = dotsFrame
        })
        corner(dot, 4)
        table.insert(dots, dot)
    end
    
    -- Auto cycle
    task.spawn(function()
        while img.Parent do
            task.wait(interval)
            currentIndex = currentIndex + 1
            if currentIndex > #images then currentIndex = 1 end
            
            tween(img, 0.5, { ImageTransparency = 1 }):Play()
            task.wait(0.5)
            img.Image = images[currentIndex]
            tween(img, 0.5, { ImageTransparency = 0 }):Play()
            
            for i, dot in ipairs(dots) do
                tween(dot, 0.3, { 
                    BackgroundColor3 = i == currentIndex and Library.Theme.Accent or Color3.fromRGB(100, 100, 100)
                }):Play()
            end
        end
    end)
    
    return c
end

-- ═══════════════════════════════════════════════════════════════════
--                     📱 Resize Handle (زاوية تفاعلية)
-- ═══════════════════════════════════════════════════════════════════
local function createResizeHandle(win, minSize)
    minSize = minSize or Vector2.new(300, 200)
    
    local handle = create("Frame", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -24, 1, -24),
        BackgroundTransparency = 1,
        Active = true,
        Parent = win
    })
    
    -- Visual (3 lines)
    local lines = create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -16, 1, -16),
        BackgroundTransparency = 1,
        Parent = handle
    })
    
    for i = 1, 3 do
        create("Frame", {
            Size = UDim2.new(0, 8 - i * 2, 0, 2),
            Position = UDim2.new(1, -(8 - i * 2), 1, -i * 4),
            BackgroundColor3 = Library.Theme.Accent,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Parent = lines
        })
    end
    
    -- Glow on hover
    local glow = create("ImageLabel", {
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Library.Theme.Glow,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = handle
    })
    
    local dragging = false
    local dragStart, startSize
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = win.AbsoluteSize
            tween(glow, 0.2, { ImageTransparency = 0.3 }):Play()
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            tween(glow, 0.2, { ImageTransparency = 1 }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newSizeX = math.max(minSize.X, startSize.X + delta.X)
            local newSizeY = math.max(minSize.Y, startSize.Y + delta.Y)
            win.Size = UDim2.new(0, newSizeX, 0, newSizeY)
        end
    end)
    
    return handle
end

-- ═══════════════════════════════════════════════════════════════════
--                     Notify
-- ═══════════════════════════════════════════════════════════════════
function Library:Notify(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Notification"
    local content = cfg.Content or ""
    local duration = cfg.Duration or 5
    
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
        BackgroundTransparency = Library.Theme.GlassMode and 0.3 or 0,
        BorderSizePixel = 0,
        Parent = gui
    })
    corner(frame, 12)
    stroke(frame, Library.Theme.Accent, 1.5)
    
    create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.new(0, 15, 0, 12),
        BackgroundTransparency = 1,
        Text = title,
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
        Text = content,
        TextColor3 = Library.Theme.SubText,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = frame
    })
    
    tween(frame, 0.4, { Position = UDim2.new(1, -340, 0, 100) }, Enum.EasingStyle.Back):Play()
    
    task.delay(duration, function()
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
--                     إنشاء النافذة
-- ═══════════════════════════════════════════════════════════════════
function Library.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Library)
    self.Title = cfg.Title or "Nova Hava"
    self.Subtitle = cfg.Subtitle or "v9.0"
    self.Icon = cfg.Icon or "⚡"
    self.Size = cfg.Size or UDim2.new(0, 540, 0, 380)
    self.ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.IsOpen = false
    self.Tabs = {}
    self.CurrentTab = nil
    
    self.ScreenGui = create("ScreenGui", {
        Name = "NovaHava_" .. tostring(math.random(1000, 9999)),
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
    
    table.insert(Library.Windows, self)
    return self
end

function Library:_buildWindow()
    local win = create("Frame", {
        Name = "Window",
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
    corner(win, Library.Theme.CornerRadius or 10)
    stroke(win, Library.Theme.Accent, 1.5)
    self.Window = win
    
    -- Sidebar
    local sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = Library.Theme.Sidebar,
        BackgroundTransparency = Library.Theme.GlassMode and 0.2 or 0,
        BorderSizePixel = 0,
        Active = true,
        Parent = win
    })
    corner(sidebar, Library.Theme.CornerRadius or 10)
    
    local header = create("Frame", {
        Name = "Header",
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
        Name = "Tabs",
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
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = tabs
    })
    self.TabHolder = tabs
    
    -- Content
    local content = create("ScrollingFrame", {
        Name = "Content",
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
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = content
    })
    self.Content = content
    
    -- Close button
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
    
    -- Resize handle
    createResizeHandle(win)
    
    -- Drag
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
        Name = "Toggle",
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

-- ═══════════════════════════════════════════════════════════════════
--                     Tabs
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
    
    local isImage = icon ~= nil and typeof(icon) == "string" and icon:match("^rbxasset") ~= nil
    local iconLbl
    
    if isImage then
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
            Font = Enum.Font.GothamBold,
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
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = btn
    })
    
    tab.Button, tab.Label, tab.Icon, tab.IsImage, tab.Indicator = btn, lbl, iconLbl, isImage, indicator
    
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
        if t.IsImage then
            tween(t.Icon, 0.15, { ImageColor3 = Library.Theme.SubText }):Play()
        else
            tween(t.Icon, 0.15, { TextColor3 = Library.Theme.SubText }):Play()
        end
        tween(t.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 0) }):Play()
    end
    tab.Page.Visible = true
    tween(tab.Button, 0.15, { BackgroundTransparency = 0 }):Play()
    tab.Button.BackgroundColor3 = Library.Theme.Element
    tween(tab.Label, 0.15, { TextColor3 = Library.Theme.Text }):Play()
    if tab.IsImage then
        tween(tab.Icon, 0.15, { ImageColor3 = Library.Theme.Accent }):Play()
    else
        tween(tab.Icon, 0.15, { TextColor3 = Library.Theme.Accent }):Play()
    end
    tween(tab.Indicator, 0.15, { Size = UDim2.new(0, 3, 0, 18) }):Play()
    self.CurrentTab = tab
end

-- ═══════════════════════════════════════════════════════════════════
--                     عناصر أساسية (Section, Label, Paragraph, Divider)
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
    create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = c
    })
    create("UIListLayout", {
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
            Font = Enum.Font.GothamBold,
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
        Font = Enum.Font.Gotham,
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

-- ═══════════════════════════════════════════════════════════════════
--                     Toggle محسّن
-- ═══════════════════════════════════════════════════════════════════
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
    if Library.Theme.GlassMode then
        stroke(c, Library.Theme.Stroke, 1).Transparency = 0.7
    end
    
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
        tween(dot, 0.2, { 
            BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Element
        }, Enum.EasingStyle.Back):Play()
        tween(knob, 0.25, { 
            Position = state and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            Size = UDim2.new(0, 16, 0, 16),
        }, Enum.EasingStyle.Back):Play()
        task.wait(0.1)
        tween(knob, 0.15, { Size = UDim2.new(0, 14, 0, 14) }):Play()
        
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
    
    table.insert(Library.Elements, el)
    return el
end

-- ═══════════════════════════════════════════════════════════════════
--                     EnableToggle
-- ═══════════════════════════════════════════════════════════════════
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
        TextColor3 = Color3.fromRGB(255, 255, 255),
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
        tween(c, 0.2, { 
            BackgroundColor3 = state and Color3.fromRGB(0, 200, 110) or Color3.fromRGB(220, 60, 60)
        }):Play()
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
--                     Dropdown
-- ═══════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════
--                     Input
-- ═══════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════
--                     List
-- ═══════════════════════════════════════════════════════════════════
function Library:AddList(tab, label, options, defaultSelected, flag, callback)
    local selected = defaultSelected or {}
    local el = { enabled = true, flag = flag }
    
    local maxHeight = 180
    local listHeight = math.min(#options * 22, maxHeight)
    local useScroll = (#options * 22) > maxHeight
    
    local c = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40 + listHeight),
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

-- ═══════════════════════════════════════════════════════════════════
--                     🎨 Color Picker متقدم
-- ═══════════════════════════════════════════════════════════════════
function Library:AddColorPicker(tab, label, default, flag, callback)
    local color = default or Color3.fromRGB(138, 43, 226)
    local el = { enabled = true, gradient = false, color2 = color, flag = flag }
    
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
    
    local gradient = create("UIGradient", {
        Color = ColorSequence.new(color, color),
        Parent = preview
    })
    
    -- Panel
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
    
    -- SV Canvas
    local svHolder = create("Frame", {
        Size = UDim2.new(1, -16, 0, 100),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Color3.new(1, 0, 0),
        BorderSizePixel = 0,
        Active = true,
        Parent = panel
    })
    corner(svHolder, 6)
    
    local whiteGrad = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1, 0):Lerp(Color3.new(1,1,1), 0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = svHolder
    })
    
    local blackGrad = create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
        Parent = svHolder
    })
    
    -- Hue Bar
    local hueHolder = create("Frame", {
        Size = UDim2.new(1, -16, 0, 16),
        Position = UDim2.new(0, 8, 0, 114),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Active = true,
        Parent = panel
    })
    corner(hueHolder, 8)
    
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
        Parent = hueHolder
    })
    
    -- Hex input
    local hexBox = create("TextBox", {
        Size = UDim2.new(0.6, 0, 0, 24),
        Position = UDim2.new(0, 8, 0, 136),
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
    
    -- Apply Button
    local applyBtn = create("TextButton", {
        Size = UDim2.new(0.4, -16, 0, 24),
        Position = UDim2.new(0.6, 8, 0, 136),
        BackgroundColor3 = Library.Theme.Accent,
        Text = "تطبيق",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = panel
    })
    corner(applyBtn, 4)
    
    -- Gradient Toggle
    local gradBtn = create("TextButton", {
        Size = UDim2.new(1, -16, 0, 24),
        Position = UDim2.new(0, 8, 0, 166),
        BackgroundColor3 = Library.Theme.Card,
        Text = "🎨 تفعيل التدرج",
        TextColor3 = Library.Theme.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        Parent = panel
    })
    corner(gradBtn, 4)
    
    local hue, sat, val = color:ToHSV()
    local activeDrag = nil
    
    local function applyColor()
        color = Color3.fromHSV(hue, sat, val)
        preview.BackgroundColor3 = color
        hexBox.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
        gradient.Color = ColorSequence.new(el.gradient and el.color2 or color, color)
        svHolder.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        if flag then Library.Flags[flag] = color end
        if callback then
            if el.gradient then
                pcall(callback, color, el.color2)
            else
                pcall(callback, color)
            end
        end
    end
    
    -- SV Control
    svHolder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = "sv"
            sat = math.clamp((input.Position.X - svHolder.AbsolutePosition.X) / svHolder.AbsoluteSize.X, 0, 1)
            val = 1 - math.clamp((input.Position.Y - svHolder.AbsolutePosition.Y) / svHolder.AbsoluteSize.Y, 0, 1)
            applyColor()
        end
    end)
    
    hueHolder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = "hue"
            hue = math.clamp((input.Position.X - hueHolder.AbsolutePosition.X) / hueHolder.AbsoluteSize.X, 0, 1)
            applyColor()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            if activeDrag == "sv" then
                sat = math.clamp((input.Position.X - svHolder.AbsolutePosition.X) / svHolder.AbsoluteSize.X, 0, 1)
                val = 1 - math.clamp((input.Position.Y - svHolder.AbsolutePosition.Y) / svHolder.AbsoluteSize.Y, 0, 1)
            elseif activeDrag == "hue" then
                hue = math.clamp((input.Position.X - hueHolder.AbsolutePosition.X) / hueHolder.AbsoluteSize.X, 0, 1)
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
    
    applyBtn.Activated:Connect(function()
        local hex = hexBox.Text:gsub("#", "")
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        if r and g and b then
            color = Color3.fromRGB(r, g, b)
            hue, sat, val = color:ToHSV()
            applyColor()
        end
    end)
    
    gradBtn.Activated:Connect(function()
        el.gradient = not el.gradient
        gradBtn.Text = el.gradient and "🎨 التدرج مفعّل" or "🎨 تفعيل التدرج"
        gradBtn.BackgroundColor3 = el.gradient and Library.Theme.Accent or Library.Theme.Card
        applyColor()
    end)
    
    local expanded = false
    preview.Activated:Connect(function()
        expanded = not expanded
        panel.Visible = expanded
        if expanded then
            panel.Size = UDim2.new(1, -24, 0, 200)
            tween(c, 0.3, { Size = UDim2.new(1, 0, 0, 270) }):Play()
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
        applyColor()
    end
    el.Get = function() return color end
    el.SetEnabled = function(s)
        el.enabled = s
        c.BackgroundTransparency = s and Library.Theme.BackgroundTrans or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

-- ═══════════════════════════════════════════════════════════════════
--                     Keybind
-- ═══════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════
--                     Button
-- ═══════════════════════════════════════════════════════════════════
function Library:AddButton(tab, label, callback, color, icon)
    color = color or Library.Theme.Accent
    local el = { enabled = true }
    
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = color,
        BackgroundTransparency = Library.Theme.GlassMode and 0.2 or 0,
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
        btn.BackgroundTransparency = s and (Library.Theme.GlassMode and 0.2 or 0) or 0.5
    end
    
    table.insert(Library.Elements, el)
    return el
end

-- ═══════════════════════════════════════════════════════════════════
--                     Update Theme (تحديث كل النافذة)
-- ═══════════════════════════════════════════════════════════════════
function Library:UpdateTheme()
    if not self.Window then return end
    local win = self.Window
    
    tween(win, 0.3, {
        BackgroundColor3 = Library.Theme.Background,
        BackgroundTransparency = Library.Theme.BackgroundTrans,
    }):Play()
    
    for _, desc in ipairs(win:GetDescendants()) do
        if desc:IsA("Frame") and desc.Name == "Sidebar" then
            tween(desc, 0.3, {
                BackgroundColor3 = Library.Theme.Sidebar,
                BackgroundTransparency = Library.Theme.GlassMode and 0.2 or 0,
            }):Play()
        end
    end
end

return Library
