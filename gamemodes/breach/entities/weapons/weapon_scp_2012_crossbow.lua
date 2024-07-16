
SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-2012 Crossbow"
SWEP.WorldModel = "models/cultist/scp/scp2012/w_crossbow.mdl"
SWEP.ViewModel = "models/cultist/scp/scp2012/v_crossbow.mdl"
SWEP.HoldType = "crossbow"

SWEP.droppable = false

SWEP.UseHands = false

SWEP.Base = "breach_scp_base"

SWEP.AbilityIcons = {

  {

    Name = "Two-handed sword",
    Description = "No description provided",
    Cooldown = 3,
    KEY = _G[ "KEY_H" ],
    Icon = "nextoren/gui/special_abilities/2012/2012_2h.png"

  },
  {

    Name = "Shield Wall",
    Description = "Defend yourself against enemies with a shield",
    Cooldown = 3,
    KEY = _G[ "KEY_R" ],
    Icon = "nextoren/gui/special_abilities/2012/2012_1h.png"

  },
  --[[
  {

    Name = "Fire Arrows",
    Description = "Loads yours crossbow with a fire arrows",
    Cooldown = 110,
    KEY = "RMB",
    Icon = "nextoren/gui/special_abilities/2012/2012_crossbow_ability_flamearrow.png"

  }]]

}

sound.Add( {

  name = "crossbow.projectile",
  volume = 1,
  channel = CHAN_WEAPON,
  pitch = { 98, 102 },
  sound = {

    "nextoren/scp/2012/crossbow/projectile/projectile_1.wav",
    "nextoren/scp/2012/crossbow/projectile/projectile_2.wav"

  }

} )

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:SetupDataTables()

  self:NetworkVar( "Int", 0, "Arrows" )
  self:NetworkVar( "Bool", 0, "FireArrows" )

  self:SetFireArrows( false )

end

function SWEP:HolsterProccess( custom_stance )

  if ( ( self.IdleDelay || 0 ) > CurTime() ) then return end

  self.IdleDelay = CurTime() + 4
  self:PlaySequence( "holster" )

  if ( self.Owner:GTeam() != TEAM_SCP ) then return end

  timer.Simple( 1.25, function()

    if ( !( self && self:IsValid() ) ) then return end

    local main_wep = self.Owner:GetWeapon( "weapon_scp_2012" )

    if ( custom_stance ) then

      main_wep:SetStance( custom_stance )

    end

    self.Owner:SelectWeapon( "weapon_scp_2012" )

  end )

end

function SWEP:Deploy()

  self:SetNextPrimaryFire( CurTime() + 2 )
  self:SetNextSecondaryFire( CurTime() + 2 )

  self.IdleDelay = CurTime() + 2
  self:PlaySequence( "draw" )
  self:SetFireArrows( false )

  self:SetArrows( 4 )

  if ( CLIENT && LocalPlayer():GetRoleName() == "SCP2012" ) then

    self.Owner.SafeModeWalk = 2
    self:ChooseAbility( self.AbilityIcons )

  end

  if ( SERVER ) then

    hook.Add( "PlayerButtonDown", "SCP2012_Crossbow_ChangeWeapon", function( player, button )

      if ( player:GetRoleName() != "SCP2012" ) then return end

      if ( button == KEY_H ) then

        player:GetActiveWeapon():HolsterProccess( 2 )

      end

    end )

  end

  self.InitialDeploy = true

end

if ( SERVER ) then

  function SWEP:Think()

    if ( ( self.IdleDelay || 0 ) < CurTime() && !self.InitialDeploy && !self.IdlePlaying && self:GetArrows() > 0 && ( self.OldArrows || 0 ) > self:GetArrows() ) then

      self.IdleDelay = CurTime() + 3.25
      self:PlaySequence( "reload" )

      self.OldArrows = self:GetArrows()

    elseif ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

      self.IdlePlaying = true
      self.InitialDeploy = nil

      if ( self:GetArrows() > 0 ) then

        self:PlaySequence( "idle", true )

      else

        self:HolsterProccess()

      end

      self.OldArrows = self:GetArrows()

    end

  end

  function SWEP:Reload()

    if ( ( self.NextReloadCall || 0 ) > CurTime() ) then return end

    self.NextReloadCall = CurTime() + 3

    self:HolsterProccess( 1 )

  end

end

if ( CLIENT ) then

  function SWEP:Holster()

    timer.Simple( .25, function()

      if ( self && self:IsValid() ) then

        self.Owner:GetActiveWeapon():Deploy()

      end

    end )

  end

  function SWEP:DrawHUD()

    draw.RoundedBox( 8, ScrW() / 2 - 3, ScrH() / 2 - 3, 6, 6, color_white )

  end

  function SWEP:PostDrawViewModel( vm, wep ) end

end

local punch_angle = Angle( -2, 0, 0 )

function SWEP:PrimaryAttack()

  self:SetNextPrimaryFire( CurTime() + 5 )

  self.IdleDelay = CurTime() + 1
  self:PlaySequence( "fire" )

  self:EmitSound( "crossbow.projectile" )

  if ( SERVER ) then

    self:SetArrows( self:GetArrows() - 1 )

    local current_angles = self.Owner:GetAngles()

    local arrow = ents.Create( "ent_scp_arrow" )
    arrow:SetOwner( self.Owner )
    arrow:SetPos( self.Owner:GetShootPos() + current_angles:Forward() * 48 )
    arrow:SetAngles( current_angles )
    arrow:SetVelocity( self.Owner:GetAimVector() * 2100 )
    arrow:SetGravity( .05 )
    arrow:Spawn()
    arrow:SetIsOnFire( self:GetFireArrows() )

    if ( self:GetFireArrows() ) then

      self:SetFireArrows( false )

    end

    self.Owner:ViewPunch( punch_angle )

  end

end

function SWEP:SecondaryAttack()
  --[[
  self.AbilityIcons[ 3 ].CooldownTime = CurTime() + 80

  self:SetNextSecondaryFire( self.AbilityIcons[ 3 ].CooldownTime )

  self:SetFireArrows( true )]]

end
