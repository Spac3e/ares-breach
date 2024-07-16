AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model       = Model( "models/props_lab/binderredlabel.mdl" )

local randomspawnpos = {
  Vector(7494.283203, -557.115295, 0.031250),
  Vector(7002.476563, 2226.275635, 64.031250),
  Vector(3380.750488, 3108.498291, -123.968758),
  Vector(3380.750488, 3108.498291, -127.968758)
}

function ENT:SetupDataTables()
  self:NetworkVar("Bool", 0, "Enabled")
  self:SetEnabled(false)
end

if CLIENT then
  local scarletmat = Material("nextoren_hud/faction_icons/scarletspec.png")
  local cam = cam
  local surface = surface
  local math = math
  local ents = ents

  local shawms = shawms or {}

  hook.Add("OnEntityCreated", "COTSK_SoftEntityList", function(ent)
	  if ent:GetClass() == "ent_cult_book" then
	  	table.insert(shawms, ent)
	  end
  end)

  hook.Add("EntityRemoved", "COTSK_SoftEntityList", function(ent)
	  if ent:GetClass() == "ent_cult_book" then
		  for k, v in pairs(shawms) do
			  if !IsValid(v) then
				  table.remove(shawms, k)
			  end
		  end
	  end
  end)

  hook.Add( "PostDrawTranslucentRenderables", "cult_draw_mark", function( bDepth, bSkybox )
    local client = LocalPlayer()
    for i=1, #shawms do
      local entity = shawms[i]
      if !IsValid(entity) then
        return
      end
      local capos = entity:GetPos()
      local ang = client:EyeAngles()
      ang:RotateAroundAxis( ang:Forward(), 90 )
      ang:RotateAroundAxis( ang:Right(), 90 )
      capos = capos + Vector(0,0, 50)
      local dist = client:GetPos():Distance(entity:GetPos())
      local size = 140 * (math.Clamp(dist * .005, 1, 30))
      if entity:GetEnabled() or client:GTeam() == TEAM_COTSK then
        cam.Start3D2D( capos, ang, 0.1 )
        cam.IgnoreZ(true)
          surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
          surface.SetMaterial(scarletmat)
          surface.DrawTexturedRect(-(size/2), -(size/2), size, size);
        cam.End3D2D()
        cam.IgnoreZ(false)
      end
    end
  end)
end

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )
  self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

  if SERVER then self:SetUseType(SIMPLE_USE) end

  self:SetPos(GroundPos(randomspawnpos[math.random(1, #randomspawnpos)]))

  --self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

  local physobject = self:GetPhysicsObject()

  if ( physobject:IsValid() ) then

    physobject:EnableMotion( false )

  end

end

function ENT:UpdateTransmitState()
  return TRANSMIT_ALWAYS
end

function ENT:Detonate()
  local cutsc = ents.Create("ntf_cutscene")
  cutsc:Spawn()
end

function ENT:Use( activator, caller )

  if CLIENT then return end

  if activator:GTeam() == TEAM_SCP then return end

  if self:GetEnabled() and activator:GTeam() != TEAM_COTSK then
    
    local function finish()
      for i = 1, #player.GetHumans() do
        local ply = player.GetHumans()[i]
        if ply:GTeam() == TEAM_COTSK then
          BREACH.Players:ChatPrint( ply, true, true, "l:cultbook_ritual_distrupted" )
        end
      end

      RoundResumeTimers()

      timer.Remove("cultist_detonation")

      BroadcastLua("cltime = "..tostring(timer.TimeLeft("RoundTime")))
      self:SetEnabled(false)
      SetGlobalBool( "Evacuation_HUD", false )
      net.Start( "ForcePlaySound" )
        net.WriteString( "nextoren/entities/intercom/start.mp3" )
      net.Broadcast()

      BREACH.Players:ChatPrint( player.GetAll(), true, true, "l:cultbook_ritual_stopped" )
    end

    activator:BrProgressBar("Прерываем ритуал...", 5, "nextoren/gui/icons/notifications/breachiconfortips.png", self, false, finish, nil, nil)

  end
  if !self:GetEnabled() and activator:HasWeapon("ritual_paper") then
    if GetGlobalBool("Evacuation", false) then return end
    if preparing then return end
    if postround then return end
    if !timer.Exists("Evacuation") then return end
    if activator:GetActiveWeapon() and activator:GetActiveWeapon():GetClass() != "ritual_paper" then
      activator:AresNotify("l:quran_needed")
      return
    end
    local function finishcallback()
      if GetGlobalBool("Evacuation", false) then return end
	  if preparing then return end
	  if postround then return end
	  if !timer.Exists("Evacuation") then return end
      self:SetEnabled(true)
      activator:SetNWEntity("NTF1Entity", NULL)

      activator:CompleteAchievement("scarlet")
      
      net.Start( "ForcePlaySound" )
        net.WriteString( "nextoren/entities/intercom/start.mp3" )
      net.Broadcast()

      BREACH.Players:ChatPrint( player.GetAll(), true, true, "l:cultbook_ritual_start_pt1" )
      BREACH.Players:ChatPrint( player.GetAll(), true, true, "l:cultbook_ritual_start_pt2" )

      RoundPauseTimers()

      SetGlobalBool( "Evacuation_HUD", true )

      timer.Create("cultist_detonation", 120, 1, function()
        self:Detonate()
      end)
    end
    local function startcallback()
      activator:SetNWEntity("NTF1Entity", activator)
      activator.RitualTalkSound = CreateSound(activator, "nextoren/ending/good_ending_bad.ogg")
      local snd = activator.RitualTalkSound
      snd:SetDSP(4)
      snd:Play()
    end
    local function stopcallback()
      activator:StopForcedAnimation()
      activator:SetNWEntity("NTF1Entity", NULL)
      activator.RitualTalkSound:Stop()
    end
    activator:BrProgressBar("l:bismillah", 14, "nextoren/gui/icons/notifications/breachiconfortips.png", self, false, finishcallback, startcallback, stopcallback)
    activator:SetForcedAnimation("0_cult_ritual", 14)
  end

end


  function ENT:Think()

  end

local red = Color(255, 0, 0)
  function ENT:Draw()

    local client = LocalPlayer()
    local clientteam = client:GTeam()

    if ( clientteam == TEAM_SPEC or clientteam == TEAM_COTSK ) and !self:GetEnabled() then
      self:DrawModel()
      outline.Add( {self}, red, OUTLINE_MODE_VISIBLE )
    end

    if self:GetEnabled() then
      self:DrawModel()
      --local capos = self:GetPos()
      --local ang = client:EyeAngles()
      --ang:RotateAroundAxis( ang:Forward(), 90 )
      --ang:RotateAroundAxis( ang:Right(), 90 )
      --capos = capos + Vector(0,0, 50)
      --local dist = client:GetPos():Distance(self:GetPos())
      --local size = 140 * (math.Clamp(dist * .005, 1, 30))
    --if dist > 222 then
      --[[
      cam.Start3D2D( capos, Angle( ang.x, ang.y, ang.z ), 0.1 )
      cam.IgnoreZ(true)
        surface.SetDrawColor(ColorAlpha(color_white, 255 - Pulsate(5) * 40))
        surface.SetMaterial(Material("nextoren_hud/faction_icons/scarletspec.png"))
        surface.DrawTexturedRect(-(size/2), -(size/2), size, size);
      cam.End3D2D()
      cam.IgnoreZ(false)]]
    --else
      outline.Add( {self}, red, OUTLINE_MODE_VISIBLE )
    --end
    end

  end