AddCSLuaFile()

ENT.Type        = "anim"
ENT.Category    = "Breach"

ENT.Model       = Model( "models/breach/items/ammocrate_full.mdl" )

ENT.Ammo_Quantity = {

  SMG1 = 600,
  AR2 = 600,
  Shotgun = 240,
  Revolver = 120,
  Pistol = 150,
  Sniper = 60,
  ["RPG_Rocket"] = 2,

}

ENT.SecurityLIST = {}

local maxs = {

	Pistol = 60,
	Revolver = 30,
	SMG1 = 120,
	AR2 = 120,
	Shotgun = 80,
  Sniper = 30,
  ["RPG_Rocket"] = 2,

}

function ENT:Initialize()

  if ( SERVER ) then

    self:SetModel( self.Model )
    self:SetMoveType( MOVETYPE_NONE )

  end

  self:SetAutomaticFrameAdvance( true )
  self:ResetSequence( 0 )
  self:SetPlaybackRate( 1.0 )
  self:SetCycle( 0 )

  self:SetSolid( SOLID_VPHYSICS )

end

if ( SERVER ) then

  function ENT:Use( survivor )

    if ( ( self.NextUse || 0 ) > CurTime() ) then return end

    if ( survivor:GTeam() == TEAM_SECURITY or survivor:GetRoleName() == "CI Spy" ) and !table.HasValue(self.SecurityLIST, survivor:GetNamesurvivor()) then
      self.SecurityLIST[#self.SecurityLIST + 1] = survivor:GetNamesurvivor()
      survivor:GiveAmmo(300, "pistol")
      survivor:GiveAmmo(300, "revolver")
      survivor:EmitSound( "nextoren/equipment/ammo_pickup.wav", 75, math.random( 95, 105 ), .75, CHAN_STATIC )
      self:ResetSequence( 1 )
      return
    end

    self.NextUse = CurTime() + .25

    if ( survivor:GTeam() == TEAM_SCP ) then return end

    if ( self:GetSequence() == 0 ) then

      local wep = survivor:GetActiveWeapon()

      if ( wep != NULL && wep.CW20Weapon ) then

        local current_ammo = survivor:GetAmmoCount( wep.Primary.Ammo )

        if ( !current_ammo ) then return end

        local max_ammo = maxs[ wep.Primary.Ammo ]

        if survivor:GetRoleName() == role.ClassD_Banned then max_ammo = math.floor(max_ammo/2) end

        if ( current_ammo >= max_ammo ) then

          BREACH.Players:ChatPrint( survivor, true, true, "l:ammocrate_max_ammo" )

          return

        elseif ( self.Ammo_Quantity[ wep.Primary.Ammo ] <= 0 ) then

          BREACH.Players:ChatPrint( survivor, true, true, "l:ammocrate_no_ammo" )

          return
        end

        self.CloseTime = CurTime() + 1
        self:ResetSequence( 1 )

        local have_ammo = self.Ammo_Quantity[ wep.Primary.Ammo ]
        local need_ammo = math.max( max_ammo - current_ammo, max_ammo )

        if ( need_ammo > have_ammo ) then

          need_ammo = have_ammo

        end

        survivor:SetAmmo( need_ammo, wep.Primary.Ammo )
        survivor:EmitSound( "nextoren/equipment/ammo_pickup.wav", 75, math.random( 95, 105 ), .75, CHAN_STATIC )

        self.Ammo_Quantity[ wep.Primary.Ammo ] = self.Ammo_Quantity[ wep.Primary.Ammo ] - need_ammo

      else

        BREACH.Players:ChatPrint( survivor, true, true, "l:ammocrate_weapon_needed" )

      end

    end

  end

  function ENT:Think()

    self:NextThink( CurTime() + .1 )

    local int_curseq = self:GetSequence()

    if ( ( self.CloseTime || 0 ) < CurTime() && int_curseq == 1 ) then

      self:ResetSequence( 2 )

    elseif ( int_curseq == 2 && self:IsSequenceFinished() ) then

      self:ResetSequence( 0 )

    end

  end

end

if ( CLIENT ) then

  function ENT:Draw()

    self:DrawModel()

  end

end
