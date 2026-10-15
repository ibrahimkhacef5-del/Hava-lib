<div align="center">

# ⚡ Nova Hava Library v11.2

### 🎨 مكتبة واجهات روبلوكس الاحترافية

![Version](https://img.shields.io/badge/version-11.2-blueviolet?style=for-the-badge)
![Platform](https://img.shields.io/badge/platform-Roblox-red?style=for-the-badge)
![Language](https://img.shields.io/badge/lang-Luau-yellow?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

**✨ 12 ثيمات • 🎬 5 Boot Screens • 🎯 25+ عنصر • 🎨 محرر ألوان مباشر**

[🚀 البدء](#-البدء-السريع) • [📖 التوثيق](#-التوثيق-الكامل) • [💡 أمثلة](#-أمثلة-كاملة)

</div>

---

## 📖 فهرس المحتويات

1. [نظرة عامة](#-نظرة-عامة)
2. [التثبيت والتحميل](#-التثبيت-والتحميل)
3. [شاشات البداية (Boot)](#-شاشات-البداية-boot)
4. [نظام المفاتيح (Key System)](#-نظام-المفاتيح-key-system)
5. [النافذة (Window)](#-النافذة-window)
6. [التابات (Tabs)](#-التابات-tabs)
7. [العناصر (Elements)](#-العناصر-elements)
8. [الثيمات (Themes)](#-الثيمات-themes)
9. [محرر الألوان](#-محرر-الألوان)
10. [الإشعارات (Notify)](#-الإشعارات-notify)
11. [الحفظ والتحميل](#-الحفظ-والتحميل)
12. [أمثلة كاملة](#-أمثلة-كاملة)
13. [الأنيميشن](#-الأنيميشن)
14. [دعم الجوال](#-دعم-الجوال)

---

## 🌟 نظرة عامة

**Nova Hava Library** هي مكتبة واجهات (UI Library) احترافية لـ **Roblox**، تتيح لك إنشاء واجهات جميلة وعصرية داخل الألعاب بسهولة تامة.

### ✨ المميزات

| الميزة | الوصف |
|--------|-------|
| 🎨 **12 ثيمات جاهزة** | من Classic إلى Cyberpunk |
| 🎬 **5 Boot Screens** | شاشات بداية احترافية |
| 🔐 **Key System مدمج** | حماية سكربتك بمفتاح |
| 🎨 **محرر ألوان مباشر** | عدّل الألوان في الوقت الفعلي |
| 🎯 **25+ عنصر** | كل ما تحتاجه في واجهة واحدة |
| 📱 **يدعم الجوال** | مصمم للأداء على الهاتف |
| ⚡ **أنيميشن ناعم** | بدون تقطيع |
| 🖼️ **دعم Decals** | صور rbxthumb + rbxassetid |
| 💾 **حفظ/تحميل** | JSON-based configs |

---

## 🚀 التثبيت والتحميل

### 📥 التحميل الأساسي

```lua
-- ═══════════════════════════════════════════════════════════
-- تحميل المكتبة من GitHub
-- ═══════════════════════════════════════════════════════════
local Library

local ok, result = pcall(function()
    return loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/ibrahimkhacef5-del/Hava-lib/refs/heads/main/ZHAVA.luau"
    ))()
end)

if ok and result then
    Library = result
    print("✅ Library loaded successfully!")
else
    warn("❌ فشل تحميل المكتبة")
    return
end
```

### 🔍 شرح كل سطر

| السطر | الوظيفة |
|-------|---------|
| `local Library` | متغير يخزن المكتبة |
| `local ok, result = pcall(...)` | pcall = try/catch (يحمي من الأخطاء) |
| `loadstring(...)` | يحول النص إلى كود قابل للتنفيذ |
| `game:HttpGet(...)` | يجيب الكود من الرابط |
| `if ok and result then` | إذا نجح التحميل |
| `Library = result` | خزّن المكتبة |
| `else return end` | إذا فشل، اخرج |

### 🎯 أول سكربت

```lua
-- ═══════════════════════════════════════════════════════════
-- 1. شاشة البداية
-- ═══════════════════════════════════════════════════════════
Library.Boot({
    Style = "Pro",
    Title = "My Script",
    Subtitle = "Loading...",
    Icon = "⚡",
    Duration = 2,
})

task.wait(2.3)

-- ═══════════════════════════════════════════════════════════
-- 2. النافذة
-- ═══════════════════════════════════════════════════════════
local Window = Library.new({
    Title = "My Script",
    Subtitle = "v1.0",
    Icon = "🎯",
    Size = UDim2.new(0, 640, 0, 400),
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ═══════════════════════════════════════════════════════════
-- 3. تاب
-- ═══════════════════════════════════════════════════════════
local MainTab = Window:AddTab("Main", "🏠")

-- ═══════════════════════════════════════════════════════════
-- 4. عناصر
-- ═══════════════════════════════════════════════════════════
Library:AddButton(MainTab, "اضغط هنا", function()
    Library:Notify({
        Title = "✅",
        Content = "تم الضغط!",
        Duration = 3,
    })
end, Color3.fromRGB(0, 200, 100), "▶️")
```

---

## 🎬 شاشات البداية (Boot)

### 📋 الدالة الموحّدة

```lua
Library.Boot(config)
```

### 🎨 الأنماط الخمسة

#### 1️⃣ BootPro — الأكثر احترافية

```
┌─────────────────────────────────────┐
│                                     │
│              ⚡                      │
│                                     │
│         ZHAVA HUB                   │
│      Loading Premium...             │
│                                     │
│  ████████████░░░░░░░░░░  60%       │
│                                     │
└─────────────────────────────────────┘
```

```lua
Library.Boot({
    Style = "Pro",
    Title = "ZHAVA",
    Subtitle = "Loading...",
    Icon = "⚡",
    Image = "rbxthumb://type=Asset&id=13281602348&w=420&h=420",
    AccentColor = Color3.fromRGB(138, 43, 226),
    Duration = 2.5,
})
```

**المميزات:**
- 🖼️ صورة خلفية (اختيارية)
- ⚡ إيموجي كبير
- 📊 شريط تحميل بنسبة %

---

#### 2️⃣ BootX — الحديث

```
┌─────────────────────────────────────┐
│                                     │
│         ┌───────────────┐           │
│         │      ⚡       │           │
│         │   HavaX       │           │
│         │  Modern UI    │           │
│         │   ● ● ●       │           │
│         └───────────────┘           │
│                                     │
└─────────────────────────────────────┘
```

```lua
Library.Boot({
    Style = "X",
    Title = "HavaX",
    Subtitle = "Modern UI",
    Icon = "🎯",
    AccentColor = Color3.fromRGB(0, 200, 255),
    Duration = 2.5,
})
```

---

#### 3️⃣ BootGlop — هالوين 🎃

```lua
Library.Boot({
    Style = "Glop",
    Title = "SPOOKY",
    Icon = "🎃",
    AccentColor = Color3.fromRGB(255, 120, 0),
    Duration = 2.5,
})
```

---

#### 4️⃣ BootWave — موجات 🌊

```lua
Library.Boot({
    Style = "Wave",
    Title = "HavaWave",
    AccentColor = Color3.fromRGB(100, 200, 255),
    Duration = 2.5,
})
```

---

#### 5️⃣ BootSimple — سريع ⚡

```lua
Library.Boot({
    Style = "Simple",
    Title = "Hava",
    Duration = 1.5,
})
```

### 📋 جدول المعاملات

| المفتاح | النوع | الوصف | افتراضي |
|---------|-------|-------|---------|
| `Style` | string | نوع البوت | `"Pro"` |
| `Title` | string | العنوان الرئيسي | `"Hava"` |
| `Subtitle` | string | العنوان الفرعي | حسب النوع |
| `Icon` | string | الإيموجي | `"⚡"` |
| `Image` | string/number | صورة خلفية | `nil` |
| `AccentColor` | Color3 | اللون الأساسي | `Library.Theme.Accent` |
| `Duration` | number | مدة البوت (ثواني) | `2.5` |

---

## 🔐 نظام المفاتيح (Key System)

### 📋 الدالة

```lua
Library.KeySystem(config)
```

### 🎯 الشكل

```
┌──────────────────────────────────┐
│                                  │
│      🔐 ZHAVA Key                │
│                                  │
│   أدخل مفتاحك للدخول             │
│                                  │
│   [🔗 نسخ الرابط]                │
│                                  │
│   [أدخل المفتاح هنا...]          │
│                                  │
│   [      دخول      ]             │
│                                  │
└──────────────────────────────────┘
```

### 📋 المعاملات

| المفتاح | النوع | الوصف | افتراضي |
|---------|-------|-------|---------|
| `Keys` | table | قائمة المفاتيح الصحيحة | `{"NovaKey"}` |
| `Title` | string | عنوان الشاشة | `"Key System"` |
| `Subtitle` | string | النص التوضيحي | `"Enter your key"` |
| `Link` | string | رابط للنسخ | `""` |
| `SaveKey` | boolean | حفظ المفتاح في ملف | `true` |
| `FileName` | string | اسم الملف | `"NovaKey"` |

### 💡 مثال كامل

```lua
Library.KeySystem({
    Keys = {"ZHAVA2024", "FREEKEY", "PREMIUM"},
    Title = "🔐 ZHAVA Key",
    Subtitle = "أدخل مفتاح للدخول",
    Link = "https://github.com/ibrahimkhacef5-del",
    SaveKey = true,
    FileName = "ZHAVA_Key.txt",
})

-- السكربت ينتظر هنا حتى يدخل المفتاح الصحيح
print("✅ تم الدخول!")
```

### 🔍 كيف يعمل

**المرحلة 1 — التحقق من الحفظ:**
```lua
-- إذا الملف موجود والمفتاح صحيح
if isfile(FileName) then
    if readfile(FileName) == any_key then
        return true  -- يفتح مباشرة
    end
end
```

**المرحلة 2 — عرض الشاشة:**
- صندوق إدخال المفتاح
- زر الدخول
- رسالة الخطأ إذا كان المفتاح خاطئ

**المرحلة 3 — عند الضغط على "دخول":**
- يتحقق إذا المفتاح في القائمة
- ✅ صحيح: يحفظه + يغلق الشاشة
- ❌ خطأ: "❌ مفتاح غير صحيح!"

**المرحلة 4 — زر نسخ الرابط:**
```lua
setclipboard(link)  -- ينسخ الرابط
-- ثم يغير النص إلى "✅ تم النسخ!"
-- بعد 1.5 ثانية يرجع "🔗 نسخ الرابط"
```

---

## 🪟 النافذة (Window)

### 📋 الدالة

```lua
local Window = Library.new(config)
```

### 📋 المعاملات

| المفتاح | النوع | الوصف | افتراضي |
|---------|-------|-------|---------|
| `Title` | string | عنوان النافذة | `"Hava"` |
| `Subtitle` | string | العنوان الفرعي | `"v11.2"` |
| `Icon` | string | أيقونة الزر العائم | `"⚡"` |
| `Size` | UDim2 | حجم النافذة | `560×400` |
| `ToggleKey` | KeyCode | مفتاح الفتح/الإغلاق | `RightShift` |

### 💡 مثال

```lua
local Window = Library.new({
    Title = "ZHAVA HUB",
    Subtitle = "v2.0 — Premium",
    Icon = "⚡",
    Size = UDim2.new(0, 640, 0, 340),
    ToggleKey = Enum.KeyCode.RightShift,
})
```

### 🎯 الأحجام الموصى بها

```lua
-- صغير (مناسب للجوال)
Size = UDim2.new(0, 480, 0, 300)

-- متوسط (افتراضي)
Size = UDim2.new(0, 560, 0, 400)

-- كبير
Size = UDim2.new(0, 700, 0, 500)

-- عريض قصير
Size = UDim2.new(0, 640, 0, 280)
```

### 🎮 دوال النافذة

```lua
Window:Open()      -- فتح النافذة
Window:Close()     -- إغلاق النافذة
Window:Toggle()    -- فتح/إغلاق
```

### 🎯 زر التوجل (Floating Button)

**زر عائم** في يسار الشاشة:
- ✅ قابل للسحب (Drag)
- ✅ يفتح النافذة عند الضغط
- ✅ أيقونة نابضة (Pulse Animation)

---

## 📑 التابات (Tabs)

### 📋 الدالة

```lua
local Tab = Window:AddTab(name, icon)
```

### 📋 المعاملات

| المعامل | النوع | الوصف |
|---------|-------|-------|
| `name` | string | اسم التاب |
| `icon` | string | إيموجي التاب |

### 💡 مثال

```lua
local MainTab = Window:AddTab("Main", "🏠")
local PlayerTab = Window:AddTab("Player", "🎮")
local VisualTab = Window:AddTab("Visuals", "🎨")
local SettingsTab = Window:AddTab("Settings", "⚙️")
```

### 🎨 الشكل

```
┌──────────────────┐
│ 🏠 Main          │ ← غير مفعّل
├──────────────────┤
│ 🎮 Player        │ ← مفعّل (شريط بنفسجي)
├──────────────────┤
│ 🎨 Visuals       │
├──────────────────┤
│ ⚙️ Settings      │
└──────────────────┘
```

---

## 🎯 العناصر (Elements)

> **جميع العناصر تحتاج `tab` كأول معامل**

### 📋 جدول سريع

| العنصر | الدالة |
|--------|--------|
| **Section** | `Library:AddSection(tab, text)` |
| **Label** | `Library:AddLabel(tab, text)` |
| **Paragraph** | `Library:AddParagraph(tab, title, text)` |
| **Divider** | `Library:AddDivider(tab)` |
| **Button** | `Library:AddButton(tab, label, callback, color, icon)` |
| **Toggle** | `Library:AddToggle(tab, label, default, flag, callback)` |
| **Slider** | `Library:AddSlider(tab, label, min, max, default, flag, callback)` |
| **Dropdown** | `Library:AddDropdown(tab, label, options, default, flag, callback)` |
| **Input** | `Library:AddInput(tab, label, default, isNumber, flag, callback)` |
| **ColorPicker** | `Library:AddColorPicker(tab, label, default, flag, callback)` |
| **List** | `Library:AddList(tab, label, options, defaults, flag, callback)` |
| **Keybind** | `Library:AddKeybind(tab, label, default, callback)` |
| **EnableToggle** | `Library:AddEnableToggle(tab, label, default, callback)` |
| **ImageSlider** | `Library:AddImageSlider(tab, images, interval)` |
| **NumberRange** | `Library:AddNumberRange(tab, label, min, max, defMin, defMax, flag, callback)` |

---

### 1️⃣ AddSection — قسم

```lua
Library:AddSection(tab, "Main Options")
```

**الشكل:**
```
▸ MAIN OPTIONS
```

---

### 2️⃣ AddLabel — نص

```lua
Library:AddLabel(tab, "هذا نص توضيحي")
```

**الشكل:**
```
┌──────────────────┐
│ هذا نص توضيحي    │
└──────────────────┘
```

---

### 3️⃣ AddParagraph — فقرة

```lua
Library:AddParagraph(tab, "العنوان", "النص الطويل هنا...")
```

**الشكل:**
```
┌──────────────────────┐
│ العنوان              │
│ النص الطويل هنا...   │
└──────────────────────┘
```

---

### 4️⃣ AddDivider — فاصل

```lua
Library:AddDivider(tab)
```

**الشكل:**
```
─────────────────────
```

---

### 5️⃣ AddButton — زر

```lua
Library:AddButton(
    tab,                                    -- التاب
    "اضغط هنا",                             -- النص
    function()                              -- callback
        Library:Notify({
            Title = "✅",
            Content = "تم الضغط!",
        })
    end,
    Color3.fromRGB(0, 200, 100),            -- اللون (اختياري)
    "▶️"                                    -- الإيموجي (اختياري)
)
```

**الشكل:**
```
┌──────────────────────┐
│  ▶️  اضغط هنا        │
└──────────────────────┘
```

**الدوال المخزنة:**
```lua
local btn = Library:AddButton(...)
btn.SetEnabled(true/false)
btn.SetColor(Color3.new(...))
```

---

### 6️⃣ AddToggle — مفتاح

```lua
Library:AddToggle(
    tab,
    "تفعيل ESP",
    false,                                  -- القيمة الافتراضية
    "espEnabled",                           -- Flag (لحفظ)
    function(state)
        print("الحالة:", state)
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ تفعيل ESP         ⚪️→⚫️  │
└───────────────────────────┘
```

**الدوال:**
```lua
local toggle = Library:AddToggle(...)
toggle.Set(true/false)      -- تعيين القيمة
toggle.Get()                -- الحصول على القيمة
toggle.SetEnabled(state)    -- تفعيل/تعطيل
toggle.SetColor(Color3)     -- لون الدائرة
```

---

### 7️⃣ AddSlider — شريط رقمي

```lua
Library:AddSlider(
    tab,
    "سرعة المشي",
    16,                                     -- min
    500,                                    -- max
    16,                                     -- default
    "walkSpeed",                            -- flag
    function(value)
        local hum = game.Players.LocalPlayer.Character
            :FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = value end
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ سرعة المشي         100    │
│ ▬▬▬▬▬▬▬▬●▬▬▬▬▬▬▬▬▬▬▬       │
└───────────────────────────┘
```

**الدوال:**
```lua
local slider = Library:AddSlider(...)
slider.Set(value)          -- تعيين
slider.Get()               -- الحصول
slider.SetEnabled(state)   -- تفعيل/تعطيل
slider.SetColor(Color3)    -- لون الشريط
```

---

### 8️⃣ AddDropdown — قائمة منسدلة

```lua
Library:AddDropdown(
    tab,
    "اختر الثيم",
    {"Default", "Cyberpunk", "Ocean"},
    "Default",                              -- الافتراضي
    "theme",                                -- flag
    function(selected)
        Library:SetTheme(selected)
    end
)
```

**الشكل المطوي:**
```
┌───────────────────────────┐
│ اختر الثيم                │
│ [Default          ▾]      │
└───────────────────────────┘
```

**الشكل المفتوح:**
```
┌───────────────────────────┐
│ اختر الثيم                │
│ [Default          ▴]      │
│ ┌─────────────────────┐   │
│ │ Default             │   │
│ │ Cyberpunk           │   │
│ │ Ocean               │   │
│ └─────────────────────┘   │
└───────────────────────────┘
```

**الدوال:**
```lua
dropdown.Set(value)        -- تعيين
dropdown.Get()             -- الحصول
dropdown.SetEnabled(state) -- تفعيل/تعطيل
```

---

### 9️⃣ AddInput — حقل إدخال

```lua
Library:AddInput(
    tab,
    "اسمك",
    "Player",                               -- الافتراضي
    false,                                  -- isNumber?
    "username",                             -- flag
    function(value)
        print("الاسم: " .. value)
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ اسمك                      │
│ [Player              ]    │
└───────────────────────────┘
```

---

### 🔟 AddColorPicker — منتقي الألوان

```lua
Library:AddColorPicker(
    tab,
    "لون ESP",
    Color3.fromRGB(255, 0, 0),             -- الافتراضي
    "espColor",                             -- flag
    function(color)
        print("اللون الجديد:", color)
    end
)
```

**الشكل المفتوح:**
```
┌───────────────────────────┐
│ لون ESP                   │
│ ┌───────────────────────┐ │
│ │ ████████████████████  │ │
│ └───────────────────────┘ │
│ ┌───────────────────────┐ │
│ │ ┌─────────────────┐   │ │
│ │ │   SV Canvas     │   │ │
│ │ └─────────────────┘   │ │
│ │ ▬▬▬▬●▬▬▬▬▬▬▬▬▬       │ │
│ │ [#FF0000         ]    │ │
│ └───────────────────────┘ │
└───────────────────────────┘
```

---

### 1️⃣1️⃣ AddList — قائمة متعددة

```lua
Library:AddList(
    tab,
    "اختر الميزات",
    {"ESP", "Aimbot", "Speed", "Fly"},
    {ESP = true, Speed = true},             -- الافتراضي
    "features",                             -- flag
    function(selected)
        for name, enabled in pairs(selected) do
            print(name, enabled)
        end
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ اختر الميزات              │
│ ┌───────────────────────┐ │
│ │ ☑ ESP                 │ │
│ │ ☐ Aimbot              │ │
│ │ ☑ Speed               │ │
│ │ ☐ Fly                 │ │
│ └───────────────────────┘ │
└───────────────────────────┘
```

---

### 1️⃣2️⃣ AddKeybind — اختصار مفتاح

```lua
Library:AddKeybind(
    tab,
    "مفتاح الطيران",
    Enum.KeyCode.F,                         -- المفتاح الافتراضي
    function()
        Library:Notify({Title = "✈️", Content = "تم الضغط!"})
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ مفتاح الطيران      [F]    │
└───────────────────────────┘
```

---

### 1️⃣3️⃣ AddEnableToggle — Toggle كبير

```lua
Library:AddEnableToggle(
    tab,
    "تفعيل السكربت",
    true,                                   -- الافتراضي
    function(state)
        Library:SetEnabled(state)
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ ✅ تفعيل السكربت          │ ← أخضر
└───────────────────────────┘
```

---

### 1️⃣4️⃣ AddImageSlider — صور متغيرة

```lua
Library:AddImageSlider(
    tab,
    {
        "rbxthumb://type=Asset&id=13281602348&w=420&h=420",
        "rbxassetid://13281645759",
        13281651596,
    },
    3                                       -- الفاصل الزمني (ثواني)
)
```

**الصيغ المدعومة:**
- ✅ `rbxthumb://type=Asset&id=ID&w=420&h=420`
- ✅ `rbxassetid://ID`
- ✅ رقم فقط: `123456789`
- ✅ نص رقمي: `"123456789"`

---

### 1️⃣5️⃣ AddNumberRange — نطاق رقمي

```lua
Library:AddNumberRange(
    tab,
    "نطاق الرؤية",
    0,                                      -- min
    5000,                                   -- max
    100,                                    -- defaultMin
    2000,                                   -- defaultMax
    "viewRange",                            -- flag
    function(minVal, maxVal)
        print("من:", minVal, "إلى:", maxVal)
    end
)
```

**الشكل:**
```
┌───────────────────────────┐
│ نطاق الرؤية               │
│ 100 - 2000                │
│ ▬▬▬●▬▬▬▬▬▬▬●▬▬▬▬▬▬▬       │
└───────────────────────────┘
```

---

## 🎨 الثيمات (Themes)

### 📋 الدالة

```lua
Library:SetTheme(name)
```

### 🎨 الثيمات الـ 12

| # | الاسم | اللون | الوصف |
|---|-------|-------|-------|
| 1 | `Default` | 🟣 | بنفسجي داكن (افتراضي) |
| 2 | `iOSGlass` | 🔵 | زجاج آيفون |
| 3 | `BlackShine` | ⚫ | أسود لامع |
| 4 | `RedWhite` | 🔴 | أحمر أبيض |
| 5 | `PurpleDream` | 💜 | بنفسجي حالم |
| 6 | `Halloween` | 🟠 | هالوين 🎃 |
| 7 | `Cyberpunk` | 🔷 | سايبربانك |
| 8 | `Ocean` | 🌊 | محيط |
| 9 | `Forest` | 🌲 | غابة |
| 10 | `Sunset` | 🌅 | غروب |
| 11 | `Candy` | 🍬 | حلوى |
| 12 | `Midnight` | 🌙 | منتصف الليل |

### 💡 مثال

```lua
-- تغيير الثيم
Library:SetTheme("Cyberpunk")

-- أو من Dropdown
Library:AddDropdown(tab, "اختر الثيم",
    {"Default", "Cyberpunk", "Ocean", "Sunset"},
    "Default", "theme", function(v)
        Library:SetTheme(v)
    end)
```

---

## 🎨 محرر الألوان

### 📋 الدالة

```lua
Library:OpenThemeEditor()
```

### 🎨 الشكل

```
┌─────────────────────────────────┐
│  🎨 Theme            [✕]        │
├─────────────────────────────────┤
│                                 │
│  Background    [████████]       │
│  Sidebar       [████████]       │
│  Card          [████████]       │
│  Element       [████████]       │
│  Hover         [████████]       │
│  Accent        [████████]       │
│  AccentAlt     [████████]       │
│  Text          [████████]       │
│  SubText       [████████]       │
│  Stroke        [████████]       │
│  Glow          [████████]       │
│                                 │
├─────────────────────────────────┤
│  ▸ Accent                       │
│  R [████████░░░░░]              │
│  G [█████░░░░░░░░]              │
│  B [██████████░░░]              │
│  [✓] [↺] [📋]                   │
├─────────────────────────────────┤
│  [🔄 Reset All]                 │
└─────────────────────────────────┘
```

### ✨ المميزات

| الزر | الوظيفة |
|------|---------|
| ✓ | تطبيق اللون |
| ↺ | إرجاع عنصر واحد |
| 📋 | نسخ Hex (`#RRGGBB`) |
| 🔄 | Reset كل الألوان |
| Drag | سحب النافذة |

### 💡 مثال

```lua
Library:OpenThemeEditor()
```

---

## 📢 الإشعارات (Notify)

### 📋 الدالة

```lua
Library:Notify(config)
```

### 📋 المعاملات

| المفتاح | النوع | الوصف | افتراضي |
|---------|-------|-------|---------|
| `Title` | string | عنوان الإشعار | `"Notification"` |
| `Content` | string | محتوى الإشعار | `""` |
| `Duration` | number | مدة الظهور | `5` |

### 💡 مثال

```lua
Library:Notify({
    Title = "✅ Success",
    Content = "تم تفعيل الميزة بنجاح!",
    Duration = 3,
})
```

### 🎬 الحركة

```
[الشاشة]
                    ┌────────────┐
                    │ ZHAVA      │  ← يظهر من اليمين
                    │ مفعل الآن  │
                    └────────────┘
```

**المراحل:**
1. **الدخول** (0.4s) — ينزلق من اليمين
2. **البقاء** (Duration ثواني)
3. **الخروج** (0.4s) — ينزلق لليمين
4. **الحذف** — ScreenGui يُحذف

### 🎯 إشعارات متعددة

```lua
for i = 1, 5 do
    task.delay(i * 0.3, function()
        Library:Notify({
            Title = "Notification #" .. i,
            Content = "رسالة رقم " .. i,
            Duration = 2,
        })
    end)
end
```

---

## 💾 الحفظ والتحميل

### 📋 الدوال

```lua
Library:SaveConfig(fileName)      -- حفظ
Library:LoadConfig(fileName)      -- تحميل
```

### 💡 مثال

```lua
-- حفظ الإعدادات
Library:SaveConfig("ZHAVA_Config.json")

-- تحميل الإعدادات
Library:LoadConfig("ZHAVA_Config.json")
```

### 📋 محتوى الملف

```json
{
    "walkSpeed": 100,
    "jumpPower": 150,
    "infJump": true,
    "espBox": true,
    "espColor": "Color3(1,0,0)"
}
```

### 🔍 كيف يعمل

**Save:**
1. يأخذ `Library.Flags` (كل القيم)
2. يحولها إلى JSON
3. يحفظها في ملف

**Load:**
1. يقرأ الملف
2. يحول JSON إلى table
3. يمر على كل عنصر
4. يستدعي `el.Set(value)` لكل عنصر

---

## 💡 أمثلة كاملة

### 🎯 مثال 1: سكربت بسيط

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ibrahimkhacef5-del/Hava-lib/refs/heads/main/ZHAVA.luau"
))()

local Window = Library.new({
    Title = "Simple Script",
    Size = UDim2.new(0, 500, 0, 350),
})

local Tab = Window:AddTab("Main", "🏠")

Library:AddButton(Tab, "Notification", function()
    Library:Notify({
        Title = "Hello",
        Content = "World!",
    })
end)
```

---

### 🎯 مثال 2: سكربت كامل

```lua
-- 1. تحميل
local Library
local ok, result = pcall(function()
    return loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/ibrahimkhacef5-del/Hava-lib/refs/heads/main/ZHAVA.luau"
    ))()
end)
if ok and result then Library = result else return end

-- 2. Boot Screen
Library.Boot({
    Style = "Pro",
    Title = "ZHAVA HUB",
    Subtitle = "Loading...",
    Icon = "⚡",
    Duration = 2.5,
})
task.wait(2.8)

-- 3. Key System
Library.KeySystem({
    Keys = {"TEST", "ZHAVA"},
    Title = "🔐 ZHAVA Key",
    Link = "https://github.com/ibrahimkhacef5-del",
})

-- 4. النافذة
local Window = Library.new({
    Title = "ZHAVA",
    Subtitle = "v1.0",
    Icon = "⚡",
    Size = UDim2.new(0, 640, 0, 400),
    ToggleKey = Enum.KeyCode.RightShift,
})

-- 5. التابات
local MainTab = Window:AddTab("Main", "🏠")
local SettingsTab = Window:AddTab("Settings", "⚙️")

-- 6. العناصر
Library:AddSection(MainTab, "Quick Actions")

Library:AddButton(MainTab, "تشغيل", function()
    Library:Notify({Title = "✅", Content = "تم!"})
end, Color3.fromRGB(0, 200, 100), "▶️")

Library:AddToggle(MainTab, "تفعيل", false, "test", function(state)
    print("Toggle:", state)
end)

Library:AddSlider(MainTab, "السرعة", 1, 100, 50, "speed", function(v)
    print("Speed:", v)
end)

Library:AddDropdown(MainTab, "الثيم",
    {"Default", "Cyberpunk", "Ocean"},
    "Default", "theme", function(v)
        Library:SetTheme(v)
    end)

Library:AddColorPicker(MainTab, "اللون", 
    Color3.fromRGB(255, 0, 0), "color", function(c)
        print("Color:", c)
    end)

Library:AddInput(MainTab, "الاسم", "Player", false, "name", function(v)
    print("Name:", v)
end)

Library:AddKeybind(MainTab, "المفتاح", Enum.KeyCode.F, function()
    print("F pressed")
end)

Library:AddImageSlider(MainTab, {
    "rbxthumb://type=Asset&id=13281602348&w=420&h=420",
}, 3)

-- 7. إشعار الترحيب
task.wait(0.5)
Library:Notify({
    Title = "⚡ ZHAVA",
    Content = "مرحباً!",
    Duration = 3,
})

-- 8. حفظ الإعدادات
Library:AddButton(SettingsTab, "💾 حفظ", function()
    Library:SaveConfig("ZHAVA_Config.json")
end, Color3.fromRGB(0, 200, 110))

Library:AddButton(SettingsTab, "📂 تحميل", function()
    Library:LoadConfig("ZHAVA_Config.json")
end, Color3.fromRGB(0, 122, 255))
```

---

### 🎯 مثال 3: ESP Script

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ibrahimkhacef5-del/Hava-lib/refs/heads/main/ZHAVA.luau"
))()

Library.Boot({
    Style = "Pro",
    Title = "ESP HUB",
    Icon = "👁️",
    Duration = 2,
})
task.wait(2.3)

local Window = Library.new({
    Title = "ESP Hub",
    Icon = "👁️",
    Size = UDim2.new(0, 600, 0, 400),
})

local ESPTab = Window:AddTab("ESP", "👁️")

Library:AddSection(ESPTab, "ESP Settings")

Library:AddToggle(ESPTab, "تفعيل ESP", false, "esp", function(state)
    -- ESP logic here
end)

Library:AddColorPicker(ESPTab, "لون ESP",
    Color3.fromRGB(255, 0, 0), "espColor", function(color)
        -- Update color here
    end)

Library:AddSlider(ESPTab, "المسافة", 100, 5000, 1000, "maxDist", function(v)
    -- Update max distance
end)
```

---

### 🎯 مثال 4: Aimbot Script

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ibrahimkhacef5-del/Hava-lib/refs/heads/main/ZHAVA.luau"
))()

local Window = Library.new({
    Title = "Aimbot",
    Icon = "🎯",
    Size = UDim2.new(0, 640, 0, 340),
})

local AimbotTab = Window:AddTab("Aimbot", "🎯")

Library:AddSection(AimbotTab, "Main")

Library:AddToggle(AimbotTab, "تفعيل Aimbot", false, "aim", function(s) 
    -- Enable/disable aimbot
end)

Library:AddSlider(AimbotTab, "FOV", 50, 500, 100, "fov", function(v)
    -- Update FOV
end)

Library:AddSlider(AimbotTab, "Smoothness", 0, 100, 85, "smooth", function(v)
    -- Update smoothness
end)

Library:AddDropdown(AimbotTab, "الهدف",
    {"Head", "Body"}, "Head", "target", function(v)
        -- Update target part
    end)
```

---

## 🎬 الأنيميشن

### ✨ أنواع الأنيميشن

| النوع | الوصف | المكان |
|------|-------|--------|
| 🎬 **Boot Fade** | ظهور/اختفاء ناعم | Boot Screens |
| 🎯 **Button Hover** | تكبير عند التمرير | Buttons |
| 🔘 **Toggle Slide** | انزلاق Knob | Toggles |
| 📊 **Progress Fill** | امتلاء شريط | BootPro |
| 🎨 **Window Scale** | تكبير/تصغير | Window |
| 🔔 **Notification Slide** | انزلاق | Notify |
| 💫 **Icon Pulse** | نبض الأيقونة | Floating Button |
| 🌊 **Wave Expand** | تمدد الموجات | BootWave |

### 🎯 مثال: أنيميشن مخصص

```lua
local TweenInfo = TweenInfo.new(
    0.3,                                    -- المدة
    Enum.EasingStyle.Back,                  -- النمط
    Enum.EasingDirection.Out,               -- الاتجاه
    0,                                      -- التكرار
    false,                                  -- يعكس
    0                                       -- التأخير
)

TweenService:Create(btn, TweenInfo, {
    Size = UDim2.new(1, 0, 0, 40)
}):Play()
```

---

## 📱 دعم الجوال

### ✨ المميزات

- 📱 **Touch Support** — كل العناصر تدعم اللمس
- 🎯 **Drag & Drop** — سحب النافذة والزر
- 📊 **Sizes محسّنة** — أحجام مناسبة للشاشات الصغيرة
- ⚡ **Performance** — يعمل بدون lag

### 📐 الأحجام الموصى بها

```lua
-- صغير جداً (جوال)
Size = UDim2.new(0, 420, 0, 280)

-- صغير (جوال)
Size = UDim2.new(0, 480, 0, 300)

-- متوسط
Size = UDim2.new(0, 560, 0, 380)

-- عريض (شاشة أفقية)
Size = UDim2.new(0, 640, 0, 280)
```

### 🎮 Executors المدعومة

| Executor | مدعوم |
|----------|:---:|
| Delta | ✅ |
| Arceus X | ✅ |
| Codex | ✅ |
| Hydrogen | ✅ |
| Vega X | ✅ |
| Fluxus | ✅ |
| Synapse X | ✅ |
| Krnl | ✅ |

---

## 🤝 المساهمة

نرحب بمساهماتك! للمساهمة:

1. 🍴 **Fork** المشروع
2. 🌿 أنشئ **Branch** جديد
3. ✏️ اكتب التعديلات
4. 📤 ارفع **Pull Request**

---

## 📝 الترخيص

هذا المشروع مرخص تحت **MIT License** — استخدمه بحرية!

```
MIT License

Copyright (c) 2024 Nova Hava Library

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 📞 التواصل

<div align="center">

[![GitHub](https://img.shields.io/badge/GitHub-000000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/ibrahimkhacef5-del)
[![Discord](https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/xxxxx)

</div>

---

## 🌟 شكر خاص

شكراً لكل من:

- 💜 استخدم المكتبة
- ⭐ أعطى نجمة
- 🐛 أبلغ عن أخطاء
- 💡 اقترح ميزات

---

<div align="center">

### ⚡ Nova Hava Library

**صُنع بـ ❤️ للمجتمع العربي**

```
═══════════════════════════════════════
    ⚡ NOVA HAVA — ULTRA PRECISION ⚡
         Version 11.2 — 2024
═══════════════════════════════════════
```

![Stars](https://img.shields.io/github/stars/ibrahimkhacef5-del/Hava-lib?style=social)
![Forks](https://img.shields.io/github/forks/ibrahimkhacef5-del/Hava-lib?style=social)

</div>
