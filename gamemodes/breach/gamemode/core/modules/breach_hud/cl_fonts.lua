local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest;
local RunConsoleCommand = RunConsoleCommand;
local tonumber = tonumber;
local tostring = tostring;
local CurTime = CurTime;
local Entity = Entity;
local unpack = unpack;
local table = table;
local pairs = pairs;
local ScrW = ScrW;
local ScrH = ScrH;
local concommand = concommand;
local timer = timer;
local ents = ents;
local hook = hook;
local math = math;
local draw = draw;
local pcall = pcall;
local ErrorNoHalt = ErrorNoHalt;
local DeriveGamemode = DeriveGamemode;
local vgui = vgui;
local util = util
local net = net
local player = player

BREACH.FontsCreated = BREACH.FontsCreated or false

BREACH.FontsCreated = true

surface.CreateFont( "char_title", { font = "Arial", size = 48, antialias = true })

surface.CreateFont( "char_title24", { font = "Segoe UI Bold", size = 24, antialias = true })

surface.CreateFont( "BudgetNewMini", {

	font = "Arial",

	size = 16,
	
	weight = 100,

	scanlines = 0,

})

surface.CreateFont("MainMenuFontmini_russian", {

	font = "Univers LT Std 47 Cn Lt",
	size = 26,
	extended = true,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("MainMenuFont_russian", {

	font = "Univers LT Std 47 Cn Lt",
	size = 24,
	extended = true,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("MainMenuFontmini", {

	font = "Conduit ITC",
	size = 26,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("MainMenuFont_new_russian", {

	font = "Univers LT Std 47 Cn Lt",
	size = 35,
	extended = true,
	weight = 800,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("MainMenuFont_new", {

	font = "Conduit ITC",
	size = 35,
	weight = 800,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("MainMenuFont_new_mini", {

	font = "Conduit ITC",
	size = 20,
	weight = 800,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("MainMenuFont", {

	font = "Conduit ITC",
	size = 24,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false
  
})

surface.CreateFont("BrSoul20", {
	font = "brsellyoursoul(RUS BY LYAJKA)",
	size = 16,
	weight = 500,
	antialias = true,
	additive = true
})

surface.CreateFont( "Cyb_LOGO",
{
	font = "Segoe UI",
	size = 80,
	weight = 1100,
})

surface.CreateFont( "Cyb_HudTEXT",
{
	font = "Segoe UI",
	size = 25,
	weight = 550,
})

surface.CreateFont( "Cyb_HudTEXTSmall",
{
	font = "Segoe UI",
	size = 12,
	weight = 550,
})

surface.CreateFont( "Cyb_Inv_ToolTip",
{
	font = "Segoe UI",
	size = 16,
	weight = 500,
})

surface.CreateFont( "Cyb_Inv_Bar",
{
	font = "Segoe UI",
	size = 18,
	weight = 500,
})
surface.CreateFont( "Cyb_Inv_Label",
{
	font = "Segoe UI",
	size = 14,
	weight = 400,
})

surface.CreateFont( "LZText", {

	font = "lztextinfo(RUS BY LYAJKA)",
	size = 35,
	weight = 700,
	antialias = true,
	shadow = true,
	outline = false
  
})

surface.CreateFont( "LZTextBig", {

	font = "lztextinfo(RUS BY LYAJKA)",
	size = 70,
	weight = 2,
	antialias = true,
	shadow = true,
	outline = false
  
})

surface.CreateFont( "173font", {
	font = "TargetID",
	extended = false,
	size = 18,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function BetterScreenScale()
	return math.max( math.min( ScrH(), 1080 ) / 1080, .851 )
end

surface.CreateFont( "MainMenuDescription", {
	font = "Arial",
	size = 24 * BetterScreenScale(),
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont( "BudgetNewSmall", {

	font = "Arial",

	size = 18,
	
	weight = 400,

	scanlines = 0,

})

surface.CreateFont( "LZTextSmall", {

  font = "lztextinfo(RUS BY LYAJKA)",
  size = 20,
  weight = 2,
  antialias = true,
  shadow = true,
  outline = false

})

surface.CreateFont( "LZTextVerySmall", {

  font = "lztextinfo(RUS BY LYAJKA)",
  size = 16,
  weight = 2,
  antialias = true,
  shadow = true,
  outline = false

})

surface.CreateFont( "char_title", { font = "Segoe UI", extended = true, size = 48, antialias = true })
surface.CreateFont( "char_title1", { font = "Segoe UI Bold", size = 40, antialias = true })
surface.CreateFont( "char_title64", { font = "Segoe UI Bold", size = 64, antialias = true })
surface.CreateFont( "char_title36", { font = "Segoe UI Bold", size = 17, antialias = true })
surface.CreateFont( "char_title24", { font = "Segoe UI Bold", size = 24, antialias = true })
surface.CreateFont( "char_title24a", { font = "Segoe UI Bold", size = 24 })
surface.CreateFont( "char_titleescape3", { font = "Segoe UI", size = 36, weight = 1200, antialias = true })
surface.CreateFont( "char_title20", { font = "Segoe UI Bold", size = 20, antialias = true })
surface.CreateFont( "char_title18", { font = "Segoe UI Bold", size = 18, antialias = true })
surface.CreateFont( "char_title16", { font = "Segoe UI Bold", size = 16, antialias = true })
surface.CreateFont( "char_title14", { font = "Segoe UI Bold", size = 14, antialias = true })
surface.CreateFont( "char_title12", { font = "Segoe UI Bold", size = 12, antialias = true })
surface.CreateFont( "char_title8", { font = "Segoe UI Bold", size = 8, antialias = true })

surface.CreateFont( "LevelBar", {
    font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	size = 18,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "LevelBarLittle", {
    font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	size = 14,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "BudgetNewSmall2", {

	font = "Arial",

	size = 17,
	
	weight = 100,

	scanlines = 0,

})

surface.CreateFont( "BudgetNew", {

	font = "Arial",

	size = 30,
	
	weight = 400,

	scanlines = 3,

})

surface.CreateFont( "BudgetNewBig", {

	font = "Arial",

	size = 45,
	
	weight = 400,

	scanlines = 3,

})

surface.CreateFont( "HUDFontTitle", {

    font = "Bauhaus LT(RUS BY LYAJKA)",

	extended = true,

	size = 25,

	weight = 100,

	blursize = 0,

	scanlines = 0,

	antialias = true,

	underline = true,

	italic = false,

	strikeout = false,

	symbol = false,

	rotary = false,

	shadow = false,

	additive = false,

	outline = false,

})

surface.CreateFont( "tipfont", {
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = false,
	size = 24,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "Description_Font", {
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	size = 24,
	weight = 500,
	antialias = true,
	extended = true,
	shadow = false,
	outline = false,
})

surface.CreateFont( "ScoreboardHeader",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 35,
	scanlines = 2,
})

surface.CreateFont( "ScoreboardHeaderNoLines",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 35,
	scanlines = 0,
})

surface.CreateFont( "SubScoreboardHeader",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 22 * BetterScreenScale(),
	scanlines = 2
})

surface.CreateFont( "ScoreboardContent",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 16,
})

surface.CreateFont( "WikiFont",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 20,
})

surface.CreateFont( "WikiFontSelected",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 20,
	blursize = 1,
})

surface.CreateFont( "Scoreboardtext",
{
	font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	weight = 1000,
	size = 26,
})

surface.CreateFont( "MsgFont", {
	font = "Arial",
	extended = true,
	size = 19,
	weight = 300,
	antialias = true,
	extended = true,
	shadow = true,
	outline = false,
  
})

surface.CreateFont( "ChatFont_new", {
	font = "Univers LT Std 47 Cn Lt",
	size = 18,
	weight = 0,
	antialias = true,
	extended = true,
	shadow = false,
	outline = false,
  
})

surface.CreateFont( "tazer_font", {
	font = "Univers LT Std 47 Cn Lt",
	size = 21,
	weight = 0,
	antialias = true,
	extended = true,
	shadow = false,
	outline = true,
	scanlines = 3,
  
})

surface.CreateFont( "ChatFont_properties", {

  font = "Univers LT Std 47 Cn Lt",
  size = 22,
  weight = 500,
  antialias = false,
	extended = false,
  shadow = false,
  outline = false

})

surface.CreateFont( "killfeed_font", {
    font = "Segoe UI",    
	extended = true,
	size = 17,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFont", {
    font = "Bauhaus LT(RUS BY LYAJKA)",
	extended = true,
	size = 16,
	weight = 100,
	blursize = 0,
	scanlines = 10,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFont3", {
    font = "Bauhaus LT(RUS BY LYAJKA)",    
	extended = true,
	size = 60,
	weight = 100,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "MVP_Font", {
    font = "Bauhaus LT(RUS BY LYAJKA)",   
	extended = true, 
	size = 20,
	weight = 100,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont( "HUDFont4", {
    font = "Bauhaus LT(RUS BY LYAJKA)",    
	extended = true,
	size = 30,
	weight = 100,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFont2", {
    font = "Bauhaus LT(RUS BY LYAJKA)",  
	extended = true,  
	size = 16,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "MenuHUDFont", {
    font = "Bauhaus LT(RUS BY LYAJKA)",   
	extended = true, 
	size = 26,
	weight = 100,
	blursize = 0,
	scanlines = 3,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontVery", {
    font = "Bauhaus LT(RUS BY LYAJKA)",   
	extended = true, 
	size = 20,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontLittle", {
    font = "Bauhaus LT(RUS BY LYAJKA)",  
	extended = true,  
	size = 19,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontTitle", {
    font = "Bauhaus LT(RUS BY LYAJKA)", 
	extended = true,   
	size = 25,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = true,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontBig", {
    font = "Bauhaus LT(RUS BY LYAJKA)", 
	extended = true,   
	size = 36,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontMedium", {
    font = "Bauhaus LT(RUS BY LYAJKA)", 
	extended = true,   
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont( "HUDFontMediumL", {
    font = "Bauhaus LT(RUS BY LYAJKA)",    
	extended = true,
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = true,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local minSize = 3
local maxSize = 255

for i = minSize, maxSize do
	surface.CreateFont( "exo_"..i, {
		font = "Exo",
		extended = true,
		size = i,
		weight = 600,
	} )
end

for i = minSize, maxSize do
	surface.CreateFont( "bauhaus_"..i, {
		font = "Bauhaus LT(RUS BY LYAJKA)",
		size = i,
		weight = 500,
		antialias = true,
		extended = true,
		shadow = false,
		outline = false,
	} )
end

surface.CreateFont("ClassName", {font = "Trebuchet24",
                                    size = 28,
                                    weight = 1000})
surface.CreateFont("TimeLeft",     {font = "Trebuchet24",
                                    size = 24,
                                    weight = 800})
surface.CreateFont("HealthAmmo",   {font = "Trebuchet24",
                                    size = 24,
                                    weight = 750})
