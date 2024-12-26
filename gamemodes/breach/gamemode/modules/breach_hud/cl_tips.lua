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

-- Stacker table.
local TipPanels = {}

local UpdateDelay = 0

net.Receive( "TipSend", function()

  if ( !LocalPlayer():GetActive() ) then return end

  local str1 = net.ReadString()
  local col1 = net.ReadColor()
  local str2 = net.ReadString()
  local col2 = net.ReadColor()

  timer.Simple( UpdateDelay, function()

    MakeTip( str1, col1, str2, col2 )

    if ( UpdateDelay != 1 ) then

      UpdateDelay = math.Clamp( UpdateDelay - 1, 0, 100 )

    end

  end )

  UpdateDelay = UpdateDelay + 1

end)

local boxclr = Color( 48, 49, 54, 155 )
local maticon = Material( "nextoren/gui/icons/notifications/breachiconfortips.png" )

local UpdateDelay = 0

net.Receive( "Shaky_TipSend", function()

  local icontype = net.ReadUInt( 2 )
  local str1 = net.ReadString()
  local col1 = net.ReadColor()
  local str2 = net.ReadString()
  local col2 = net.ReadColor()

   str2 = BREACH.TranslateString(str2)

  timer.Simple( UpdateDelay, function()

    MakeTip( icontype, str1, col1, str2, col2 )

    if ( UpdateDelay != 1 ) then

      UpdateDelay = math.Clamp( UpdateDelay - 1, 0, 100 )

    end

  end )

  UpdateDelay = UpdateDelay + 1

end)

TipPanels = TipPanels || {}

function MakeTip( icontype, str1, col1, str2, col2 )

  local lang1 = str1
  local lang2 = str2

  surface.SetFont( "Cyb_HudTEXT" )
  local s1 = surface.GetTextSize( lang1 )
  local s2 = surface.GetTextSize( lang2 )

  if ( lang2 == "" ) then

    s2 = 0

  end

  local tippanel = vgui.Create( "DPanel" )

  TipPanels[ #TipPanels + 1 ] = tippanel

  tippanel:SetSize( s1 + s2 + 80, 64 )

  local screenwidth = ScrW()
  local screenheight = ScrH()

  local pos = 70
  tippanel:SetPos( screenwidth - ( s1 + s2 + 100 ), screenheight )
  tippanel:MoveTo( screenwidth - ( s1 + s2 + 100 ), screenheight - 150 - pos, 0.5, 0, -10, function( data, self ) self.Moving = false end )
  tippanel.Moving = true

  for _, frame in ipairs( TipPanels ) do

    if ( frame.Moving ) then continue end
    local x, y = frame:GetPos()
    frame.yPos = y - 70

    frame.Moving = true
    frame:MoveTo( x, frame.yPos, .5, 0, -1, function() frame.Moving = false end )

  end

  timer.Simple( 5, function()

    if ( !IsValid( tippanel ) ) then return end
    tippanel.Moving = true

    local _, y = tippanel:GetPos()

    tippanel:MoveTo( screenwidth, y, .5, 0, -1, function( data, self )

      if ( self && self:IsValid() ) then

        table.RemoveByValue( TipPanels, self )
        self:Remove()

      end

    end )

  end )

  col1 = col1 || color_white
  col2 = col2 || color_white

  local col3 = Color(0,0,0,135)

  tippanel.Paint = function( self, w )

    draw.RoundedBox( 8, 0, 7, w, 50, boxclr )
    draw.RoundedBoxEx( 8, 0, 7, 55, 50, col3, true, false, true, false )

    draw.SimpleText( lang1, "Cyb_HudTEXT", 65, 32, col1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    if ( lang2 != "" ) then

      draw.SimpleText( " " .. lang2, "Cyb_HudTEXT", 65 + s1, 32, col2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

    end

  end

  local tipicon = vgui.Create( "DImage", tippanel )
  tipicon:SetMaterial( maticon )
  tipicon:SetSize( 54, 54 )
  tipicon:SetPos(0,6)

end
