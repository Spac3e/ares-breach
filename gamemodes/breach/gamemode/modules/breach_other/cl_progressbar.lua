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

ProgressName = ProgressName || "N/A"
ProgressTime = ProgressTime || 0
ProgressRunning = ProgressRunning || false

function MakeProgressBar()

  ProgressName = BREACH.TranslateString(net.ReadString())
  ProgressTime = net.ReadFloat()
  ProgressIcon = net.ReadString()

  --[[timer.Create( "ClientTime" .. LocalPlayer():SteamID64(), ProgressTime, 1, function()

    timer.Create( "DeleteProgressBar" .. LocalPlayer():SteamID64(), 1, 1, function()

      progressbar:Remove()
      progressbaricon:Remove()

    end )

  end )]]

  PaintProgress()

end
net.Receive( "StartBreachProgressBar", MakeProgressBar )

net.Receive( "progressbarstate", function()

  local client = LocalPlayer()
  
  if ( !IsValid( client.progressbar ) ) then return end

  local state = net.ReadBool()

  if ( state ) then

    client.progressbar.progress_time = 100

  else

    client.progressbar.failed = true

  end

end )

local successclr = Color( 0, 255, 0, 180 )
local stopclr = Color( 255, 0, 0 )
local valuesicons = Material( "nextoren_hud/ico_index2.png" )

local function CreateProgressBar( client, screenwidth, screenheight, time )

  ProgressRunning = true

  client.progressbar = vgui.Create( "DPanel" )
  client.progressbar:SetSize( 400, 45 )
  client.progressbar:SetPos( screenwidth / 2 - 200, screenheight - 250 )
  client.progressbar.name = ProgressName
  client.progressbar.Color = color_white
  client.progressbar.progress_time = 0
  client.progressbar.end_time = CurTime()
  client.progressbar.time_reach = time
  client.progressbar.complete = false
  client.progressbar.failed = false

  client.progressbar.Paint = function( self, w, h )

    if ( screenwidth != ScrW() || screenheight != ScrH() ) then

      screenwidth = ScrW()
      screenheight = ScrH()

    end
    --if ( progress_time < 100 ) then endingds = 210 end

    surface.SetDrawColor( 255, 255, 255, 220 );
    surface.DrawOutlinedRect( 5, h-30, w-18, 29 );
    surface.DrawOutlinedRect( 6, h-29, w-20, 27 );

    surface.SetDrawColor( color_white )
    surface.SetMaterial( valuesicons )

    if ( ProgressRunning ) then

      self.progress_time = math.Clamp( -( self.end_time - CurTime() ) / self.time_reach * 100, 0, 100 )

    end

    if ( ProgressRunning && self.progress_time == 100 ) then

      self.name = L"l:progress_done"
      self.Color = successclr
      ProgressRunning = nil

      if ( !self.complete ) then

        self.complete = true

        timer.Create( "RemoveProgressBar", 1, 1, function()

          if ( IsValid( self ) && self.complete ) then

            self:SetVisible( false )

          end

        end )

      end

    elseif ( ProgressRunning && self.failed ) then

      self.name = BREACH.TranslateString("l:progress_stopped")
      self.Color = stopclr
      ProgressRunning = nil

      timer.Create( "RemoveProgressBar", 1, 1, function()

        if ( IsValid( self ) && self.failed ) then

          self:SetVisible( false )

        end

      end )

    end

    draw.SimpleText( self.name, "DermaDefault", 5, 1, self.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

    for i = 1, 29 * ( self.progress_time / 100 ) do

      surface.DrawTexturedRect( 8 + ( i - 1 ) * 13, h - 27, 12, 24 );

    end

  end

  client.progressbaricon = vgui.Create( "DPanel" )
  client.progressbaricon:SetSize( 64, 64 )
  client.progressbaricon:SetPos( screenwidth / 2 - 265, screenheight - 262 )
  client.progressbaricon:SetBackgroundColor( color_black )
  client.progressbaricon.icon = Material( ProgressIcon )

  client.progressbaricon.Paint = function( self, w, h )

    if ( !client.progressbar:IsVisible() ) then

      self:SetVisible( false )

    end

    surface.SetDrawColor( 255,  255,  255, endings )
    surface.SetMaterial( self.icon || "nextoren/gui/icons/notifications/breachiconfortips.png" )
    surface.DrawTexturedRect( 0, 0, w, h )

    draw.RoundedBox( 0, 0, 0, 10, 2, color_black )
    draw.RoundedBox( 0, 0, 0, 2, 10, color_black )
    draw.RoundedBox( 0, 0, h-2, 10, 2, color_black )
    draw.RoundedBox( 0, 0, h-10, 2, 10, color_black )

    draw.RoundedBox( 0, w-10, 0, 10, 2, color_black )
    draw.RoundedBox( 0, w-2, 0, 2, 10, color_black )

    draw.RoundedBox( 0, w-10, h-2, 10, 2, color_black )
    draw.RoundedBox( 0,  w-2, h-10, 2, 10, color_black )

  end

end

function PaintProgress()

  local name, time = ProgressName, ProgressTime
  local screenwidth, screenheight = ScrW(), ScrH()

  local client = LocalPlayer()

  if ( !IsValid( client.progressbar ) ) then

    CreateProgressBar( client, screenwidth, screenheight, time )

  else

    client.progressbar.failed = false
    client.progressbar.complete = false
    client.progressbar.Color = color_white
    client.progressbar.progress_time = 0
    client.progressbar.name = name
    client.progressbar.time_reach = time
    client.progressbar.end_time = CurTime()
    client.progressbar:SetVisible( true )

    client.progressbaricon.icon = Material( ProgressIcon )
    client.progressbaricon:SetVisible( true )

    ProgressRunning = true

  end

  --timer.Remove( "RemoveProgressBar" )

  --[[client.progressbar = vgui.Create( "DPanel" )
  client.progressbar:SetSize( 400, 45 )
  client.progressbar:SetPos( screenwidth / 2 - 200, screenheight - 250 )
  client.progressbar.name = name
  client.progressbar.Color = color_white
  client.progressbar.progress_time = 0
  client.progressbar.complete = false
  client.progressbar.failed = false

  function client.progressbar:Paint( w, h )

    local self = client.progressbar
    --if ( progress_time < 100 ) then endingds = 210 end

    surface.SetDrawColor( 255, 255, 255, 220 );
    surface.DrawOutlinedRect( 5, h-30, w-18, 29 );
    surface.DrawOutlinedRect( 6, h-29, w-20, 27 );

    surface.SetDrawColor( color_white )
    surface.SetMaterial( valuesicons )

    if ( self.progress_time == 100 ) then

      self.name = L"l:progress_done"
      self.Color = successclr
      ProgressRunning = nil

      if ( !self.complete ) then

        self.complete = true

        timer.Simple( 1, function()

          if ( IsValid( self ) ) then

            self:Remove()

          end

        end )

      end

    elseif ( self.failed ) then

      self.name = BREACH.TranslateString("l:progress_stopped")
      self.Color = stopclr
      ProgressRunning = nil

      timer.Simple( 1, function()

        if ( IsValid( self ) ) then

          self:Remove()

        end

      end )

    end

    draw.SimpleText( self.name, "DermaDefault", 5, 1, self.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

    if ( ProgressRunning ) then

      self.progress_time = math.Clamp( -( end_time - CurTime() ) / time * 100, 0, 100 )

    end

    for i = 1, 29 * ( self.progress_time / 100 ) do

      surface.DrawTexturedRect( 8 + ( i - 1 ) * 13, h - 27, 12, 24 );

    end

  end

  client.progressbaricon = vgui.Create( "DPanel" )
  client.progressbaricon:SetSize( 64, 64 )
  client.progressbaricon:SetPos( screenwidth / 2 - 265, screenheight - 262 )
  client.progressbaricon:SetBackgroundColor( color_black )

  local progressicons = Material( ProgressIcon )
  client.progressbaricon.Paint = function( self, w, h )

    if ( !IsValid( client.progressbar ) ) then

      self:Remove()

    end

    surface.SetDrawColor( 255,  255,  255, endings )
    surface.SetMaterial( progressicons )
    surface.DrawTexturedRect( 0, 0, w, h )

    draw.RoundedBox( 0, 0, 0, 10, 2, color_black )
    draw.RoundedBox( 0, 0, 0, 2, 10, color_black )
    draw.RoundedBox( 0, 0, h-2, 10, 2, color_black )
    draw.RoundedBox( 0, 0, h-10, 2, 10, color_black )

    draw.RoundedBox( 0, w-10, 0, 10, 2, color_black )
    draw.RoundedBox( 0, w-2, 0, 2, 10, color_black )

    draw.RoundedBox( 0, w-10, h-2, 10, 2, color_black )
    draw.RoundedBox( 0,  w-2, h-10, 2, 10, color_black )

  end]]

end

function StopProgressBar()

  ProgressRunning = nil

  local client = LocalPlayer()

  if ( client.progressbar && client.progressbar:IsValid() ) then

    client.progressbar.name = BREACH.TranslateString("l:progress_stopped")
    client.progressbar.Color = stopclr

    timer.Create( "RemoveProgressBar", .8, 1, function()

      if ( client.progressbar && client.progressbar:IsValid() && !ProgressRunning && client.progressbar.name == BREACH.TranslateString("l:progress_stopped") ) then

        client.progressbar:Remove()
        client.progressbaricon:Remove()

      end

    end )

  end

end

net.Receive( "StopBreachProgressBar", StopProgressBar )

concommand.Add("stopprogress", function()
  StopProgressBar()
end)