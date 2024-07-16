AddCSLuaFile()

ENT.Base        = "base_entity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model       = Model( "models/cult_props/entity/generator.mdl" )

function ENT:SetupDataTables()

  self:NetworkVar( "Bool", 0, "Activated" )

end

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_NONE )
  self:SetSolid( SOLID_NONE )
  self:SetActivated( false )
  self:SetSolidFlags( bit.bor( FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS ) )
  self:SetPlaybackRate( 1.0 )
  self.Activated = false
  self.Opened = false

  self.idlesound = CreateSound( self, "nextoren/others/generator_sounds/generator_idle_off.wav" )
  self.idlesound:Play()

  if ( SERVER ) then

    self:SetUseType( SIMPLE_USE )

  end

  if ( GetGlobalInt( "ActivatedGenerators" ) != 0 ) then

    SetGlobalInt( "ActivatedGenerators", 0 )

  end

end

function ENT:OnRemove()

  if ( self.idlesound ) then

    self.idlesound:Stop()

  end

  if ( self.idlesound2 ) then

    self.idlesound2:Stop()

  end

end

function ENT:Think()

  self:NextThink( CurTime() )

  if ( !self.idlesound2 && self:GetActivated() ) then

    self.idlesound:Stop()

    self.idlesound2 = CreateSound( self, "nextoren/others/generator_sounds/generator_idle_on.wav" )
    self.idlesound2:Play()

  end

  if ( CLIENT ) then

    if ( GetGlobalInt( "ActivatedGenerators" ) != self.OldGeneratorsValue ) then

      if ( GetGlobalInt( "ActivatedGenerators" ) == 5 && !self.GeneratorsActivated ) then

        self.GeneratorsActivated = true

        local client = LocalPlayer()

        client:ScreenFade(SCREENFADE.IN, color_black, 2, 4)

        timer.Simple( 2, function()

          BREACH.Round.GeneratorsActivated = true

        end )

      end

    end

    self.OldGeneratorsValue = GetGlobalInt( "ActivatedGenerators" )

  end

end

ENT.RepairSounds = {

  "nextoren/others/generator_sounds/generator_repair_1.ogg",
  "nextoren/others/generator_sounds/generator_repair_2.ogg",
  "nextoren/others/generator_sounds/generator_repair_3.ogg"

}

local clr_red = Color( 255, 0, 0 )

function ENT:Use( caller )

  if ( ( self.NextUse || 0 ) > CurTime() ) then return end

  if ( !self.Opened ) then

    self:SetSequence( "open" )
    self:EmitSound( "nextoren/others/generator_sounds/generator_open.ogg" )
    self.Opened = true
    self.NextUse = CurTime() + 1

    return

  elseif ( self.Opened && self:GetActivated() ) then

    self.Opened = false
    self:SetSequence( "close" )
    self:EmitSound( "nextoren/others/generator_sounds/generator_close.ogg" )
    self.NextUse = CurTime() + 2

  end

  --[[if ( !self:GetActivated() && !caller:HasWeapon( "item_toolkit" ) && caller:GetRoleName() != "MTF_Engi" ) then

    if ( SERVER ) then

      caller:Tip( 3, "Вы не можете починить генератор без набора инструментов", ColorAlpha( clr_red, 180 ) )

    end
    self.NextUse = CurTime() + 2
    return
  end]]

  if ( caller:GTeam() == TEAM_SCP ) then

    if ( SERVER ) then

      caller:AresNotify( "l:you_cant_repair_generator" )

    end

    return
  end

  if ( !caller:HasWeapon( "item_toolkit" ) && caller:GetRoleName() != role.MTF_Engi ) then

    if ( SERVER ) then

      caller:AresNotify( "l:you_need_toolkit" )

    end

    return
  end

  if ( self.Opened && !self:GetActivated() ) then

    if ( SERVER ) then

      caller:BrProgressBar( "l:repairing_generator", 5, "nextoren/gui/icons/tool_kit.png", self, false, function()

        if ( self:GetActivated() ) then return end

        if ( caller:HasWeapon( "item_toolkit" ) ) then

          caller:GetWeapon( "item_toolkit" ):Remove()

        elseif ( !caller:HasWeapon( "item_toolkit" ) && caller:GetRoleName() != role.MTF_Engi ) then

          BREACH.Players:ChatPrint( caller, true, true, "l:generator_toolkit_abuse" )

          return
        end

        caller:AddToStatistics( "l:repair_bonus", 110 )
        SetGlobalInt( "ActivatedGenerators", GetGlobalInt( "ActivatedGenerators" ) + 1 )
        self:SetActivated( true )

        for i, v in pairs(player.GetAll()) do
          if v:GTeam() != TEAM_SPEC then
            v:BrTip(0, "[Ares Breach]", Color(255,0,0), "l:repaired_generators_count " .. GetGlobalInt( "ActivatedGenerators" ) .. "/5!", color_white)
          end
        end

        --net.Start( "ForcePlaySound" )

          PlayAnnouncer( "nextoren/round_sounds/generators/" .. GetGlobalInt( "ActivatedGenerators" ) .. "of5.ogg" )

        --net.Broadcast()

      end )

    end

  end

end

local clr_green = Color( 0, 255, 0 )

function ENT:Draw()

  self:DrawModel()

  if ( LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > ( 250 * 250 ) ) then return end

  local opos = self:GetPos()
  local oang = self:GetAngles()

  local ang = self:GetAngles()
  local pos = self:GetPos()

  ang:RotateAroundAxis( oang:Up(), 90 )
  ang:RotateAroundAxis( oang:Right(), -90 )

  cam.Start3D2D( pos + oang:Forward() * 6.1 + oang:Up() * 28 + oang:Right() * 15, ang, 0.1 )

    if ( !self:GetActivated() ) then

      draw.SimpleText( "OFFLINE", "RadioOFFONFont", 0, 0, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    else

      draw.SimpleText( "ACTIVE", "RadioOFFONFont", 0, 0, clr_green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

  cam.End3D2D()

end
