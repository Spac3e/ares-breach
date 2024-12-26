local surface = surface
local math = math
local table = table
local hook = hook
local mathRound = math.Round
local table_Merge = table.Merge
local surface_CreateFont = surface.CreateFont
local BREACH = BREACH

do
    local ratio = ScrH() / 1080
    hook.Add("OnScreenSizeChanged", "ScreenScaleBreach", function() ratio = ScrH() end)
    function BREACH.ScreenScale(px)
        return mathRound(px * ratio)
    end
end

function BREACH.CreateFont(name, font, size, dataoverride, scale)
    local fontdata = {
        font = font,
        size = (scale ~= false) and BREACH.ScreenScale(size) or size,
        weight = size * 20,
        extended = true,
    }

    if dataoverride then
        table_Merge(fontdata, dataoverride)
    end

    surface_CreateFont(name, fontdata)
end

if not BREACH.FontsCreated then
    local lorimer, bauhausru, univeres, lztext, segoui, segouibold, conduit, arial = "Lorimer No 2 Stencil", "Bauhaus LT(RUS BY LYAJKA)", "Univers LT Std 47 Cn Lt", "lztextinfo(RUS BY LYAJKA)", "Segoe UI", "Segoe UI Bold", "Conduit ITC", "Arial"

    BREACH.CreateFont("BudgetNewMini", arial, 16, {
        weight = 100,
        scanlines = 0
    })

    BREACH.CreateFont("TimeMisterFreeman", "B52", 24, {
        antialias = true,
        shadow = false
    })

    BREACH.CreateFont("Buba", lorimer, 60, {
        weight = 900,
        antialias = true
    })

    BREACH.CreateFont("Buba7", lorimer, 19, {
        weight = 300,
        antialias = true
    })

    BREACH.CreateFont("Buba6", lorimer, 20, {
        weight = 500,
        antialias = true
    })

    BREACH.CreateFont("Buba5", lorimer, 30, {
        weight = 500,
        scanlines = 3,
        antialias = true
    })

    BREACH.CreateFont("BubaChat", lorimer, 18, {
        weight = 500,
        scanlines = 3,
        antialias = true
    })

    BREACH.CreateFont("Buba55", lorimer, 45, {
        weight = 500,
        scanlines = 2,
        antialias = true
    })

    BREACH.CreateFont("Buba3", "Righteous", 30, {
        weight = 400,
        antialias = true
    })

    BREACH.CreateFont("Buba2", "LittleMerry", 48, {
        weight = 800,
        shadow = true,
        antialias = true
    })

    BREACH.CreateFont("HUDFontHead", bauhausru, 36, {
        weight = 100,
        antialias = true
    })

    BREACH.CreateFont("UiBold", "Verdana", 16, {
        weight = 800,
        antialias = true
    })

    BREACH.CreateFont("LiveTabMainFont", lztext, 45, {
        weight = 700,
        antialias = true
    })

    BREACH.CreateFont("LiveTabMainFont_small", lztext, 35, {
        weight = 700,
        antialias = true
    })

    BREACH.CreateFont("LiveTabMainFont_verysmall", lztext, 15, {
        weight = 700,
        antialias = true
    })

    BREACH.CreateFont("JuneFont", "Junegull", 16, {
        weight = 500,
        antialias = true
    })

    BREACH.CreateFont("rolemenu_desc", univeres, 20, {
        weight = 500,
        antialias = true
    })

    BREACH.CreateFont("MainMenuFontmini_russian", univeres, 26, {
        extended = true,
        weight = 800,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("MainMenuFont_russian", univeres, 24, {
        extended = true,
        weight = 800,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("MainMenuFontmini", conduit, 26, {
        weight = 800,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("MainMenuFont_new_russian", univeres, 35, {
        extended = true,
        weight = 800,
        blursize = 0,
        scanlines = 3,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("MainMenuFont_new", conduit, 35, {
        weight = 800,
        blursize = 0,
        scanlines = 3,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("MainMenuFont", conduit, 24, {
        weight = 800,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("Cyb_HudTEXT", segoui, 25, {
        weight = 550
    })

    BREACH.CreateFont("Cyb_HudTEXTSmall", segoui, 12, {
        weight = 550
    })

    BREACH.CreateFont("Cyb_Inv_Bar", segoui, 18, {
        weight = 500
    })

    BREACH.CreateFont("Cyb_Inv_Label", segoui, 14, {
        weight = 400
    })

    BREACH.CreateFont("LZText", lztext, 35, {
        weight = 700,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("LZTextBig", lztext, 70, {
        weight = 2,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("LZTextSmall", lztext, 20, {
        weight = 2,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("LZTextVerySmall", lztext, 16, {
        weight = 2,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("char_title", segoui, 48, {
        extended = true,
        antialias = true,
    })

    BREACH.CreateFont("ImpactBig", "Impact", 45, {
        scanlines = 3,
        weight = 700
    })

    BREACH.CreateFont("ImpactSmall", "Impact", 30, {
        scanlines = 3,
        weight = 700
    })

    BREACH.CreateFont("RadioFont", "Impact", 26, {
        weight = 7000,
        scanlines = 2,
        antialias = true
    })

    BREACH.CreateFont("dev_desc", univeres, 16, {
        antialias = true
    })

    BREACH.CreateFont("dev_name", univeres, 21, {
        antialias = true
    })

    BREACH.CreateFont("SCP106_TEXT", segoui, 35, {
        italic = true,
        blursize = 1,
        outline = true,
        antialias = true
    })

    BREACH.CreateFont("SpectatorTimer", conduit, 28, {
        weight = 800,
        shadow = true,
        antialias = true
    })

    BREACH.CreateFont("char_title36", segouibold, 17, {
        antialias = true
    })

    BREACH.CreateFont("char_title24", segouibold, 24, {
        antialias = true
    })

    BREACH.CreateFont("char_title20", segouibold, 20, {
        antialias = true
    })

    BREACH.CreateFont("LevelBar", bauhausru, 18, {
        extended = true,
        weight = 100,
        blursize = 0,
        scanlines = 0,
        antialias = true,
    })

    BREACH.CreateFont("LevelBarLittle", bauhausru, 14, {
        extended = true,
        weight = 100,
        blursize = 0,
        scanlines = 0,
        antialias = true,
    })

    BREACH.CreateFont("BudgetNewSmall2", arial, 17, {
        weight = 100,
        scanlines = 0
    })

    BREACH.CreateFont("BudgetNew", arial, 30, {
        weight = 400,
        scanlines = 3
    })

    BREACH.CreateFont("BudgetNewBig", arial, 45, {
        weight = 400,
        scanlines = 3
    })

    BREACH.CreateFont("HUDFontTitle", bauhausru, 25, {
        extended = true,
        weight = 100,
        underline = true,
        antialias = true,
    })

    BREACH.CreateFont("ScoreboardHeader", bauhausru, 35, {
        extended = true,
        weight = 1000,
        scanlines = 2,
    })

    BREACH.CreateFont("SubScoreboardHeader", bauhausru, 22, {
        extended = true,
        weight = 1000,
        scanlines = 2,
    })

    BREACH.CreateFont("ScoreboardContent", bauhausru, 16, {
        extended = true,
        weight = 1000,
    })

    BREACH.CreateFont("Scoreboardtext", bauhausru, 26, {
        extended = true,
        weight = 1000,
    })

    BREACH.CreateFont("MsgFont", arial, 19, {
        extended = true,
        weight = 300,
        antialias = true,
        shadow = true,
    })

    BREACH.CreateFont("ChatFont_new", univeres, 18, {
        extended = true,
        weight = 0,
        antialias = true,
    })

    BREACH.CreateFont("tazer_font", univeres, 21, {
        extended = true,
        weight = 0,
        scanlines = 3,
        outline = true,
    })

    BREACH.CreateFont("killfeed_font", segoui, 17, {
        extended = true,
        weight = 100,
        antialias = false,
    })

    BREACH.CreateFont("HUDFont", bauhausru, 16, {
        extended = true,
        weight = 100,
        scanlines = 10,
        antialias = true,
    })

    BREACH.CreateFont("MVP_Font", bauhausru, 20, {
        extended = true,
        weight = 100,
        scanlines = 3,
        antialias = true,
    })

    BREACH.CreateFont("MenuHUDFont", bauhausru, 26, {
        extended = true,
        weight = 100,
        scanlines = 3,
        antialias = true,
    })

    BREACH.CreateFont("TimeLeft", "Trebuchet24", 24, {
        weight = 800
    })

    BREACH.CreateFont("bauhaus_14", bauhausru, 14, {
        weight = 500,
        antialias = true,
        extended = true,
        shadow = false,
        outline = false,
    })

    BREACH.CreateFont("bauhaus_16", bauhausru, 16, {
        weight = 500,
        antialias = true,
        extended = true,
        shadow = false,
        outline = false,
    })

    BREACH.CreateFont("bauhaus_18", bauhausru, 18, {
        weight = 500,
        antialias = true,
        extended = true,
        shadow = false,
        outline = false,
    })

    BREACH.CreateFont("exo_16", "Exo", 16, {
        weight = 600,
        extended = true,
    })
end

BREACH.FontsCreated = true