SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-2012"
SWEP.WorldModel = "models/cultist/scp/scp2012/scp_sword.mdl"
SWEP.ViewModel = "models/cultist/scp/scp2012/v_2h_sword.mdl"
SWEP.HoldType = "scp2012"

SWEP.droppable		= false

SWEP.ViewModelFOV = 45

SWEP.UseHands = true

SWEP.Base = "breach_scp_base"

SWEP.AbilityIcons = {

  [ 1 ] = {

    [ 1 ] = {

      Name = "Two-handed sword",
      Description = "No description provided",
      Cooldown = 10,
      CooldownTime = 0,
      KEY = _G[ "KEY_R" ],
      Icon = "nextoren/gui/special_abilities/2012/2012_2h.png"

    },
    [ 2 ] = {

      Name = "Shield Block",
      Description = "Raise your shield, blocking all frontal attacks against you for 10 sec",
      Cooldown = 25,
      CooldownTime = 0,
      activetime = 10,
      KEY = "RMB",
      Icon = "nextoren/gui/special_abilities/2012/2012_1h_ability_shieldblock.png"

    },
    [ 3 ] = {

      Name = "Crossbow",
      Description = "Don't let them escape",
      Cooldown = 90,
      CooldownTime = 0,
      KEY = _G[ "KEY_H" ],
      Icon = "nextoren/gui/special_abilities/2012/2012_crossbow.png"

    }

  },
  [ 2 ] = {

    [ 1 ] = {

      Name = "Shield Wall",
      Description = "Defend yourself against enemies with a shield",
      Cooldown = 10,
      CooldownTime = 0,
      KEY = _G[ "KEY_R" ],
      Icon = "nextoren/gui/special_abilities/2012/2012_1h.png"

    },
    [ 2 ] = {

      Name = "Charge",
      Description = "Bring your enemies down",
      Cooldown = 40,
      CooldownTime = 0,
      activetime = 15,
      KEY = "RMB",
      Icon = "nextoren/gui/special_abilities/2012/2012_2h_ability_charge.png"

    },
    [ 3 ] = {

      Name = "Crossbow",
      Description = "Don't let them escape",
      Cooldown = 90,
      CooldownTime = 0,
      KEY = _G[ "KEY_H" ],
      Icon = "nextoren/gui/special_abilities/2012/2012_crossbow.png"

    }

  }

}

SWEP.Stance_Animations = {

  {

    [ "idle" ] = "scp_2012_1h_idle_2",
    [ "walk" ] = "scp_2012_1h_walk",
    [ "run" ] = "scp_2012_1h_run",
    [ "attack" ] = {

      "scp_2012_1h_slash_01",
      "scp_2012_1h_slash_02"

    }

  },
  {

    [ "idle" ] = "scp_2012_2h_idle_2",
    [ "walk" ] = "scp_2012_2h_walk",
    [ "run" ] = "scp_2012_2h_run",
    [ "attack" ] = {

      "scp_2012_2h_slash_01",
      "scp_2012_2h_slash_02"

    }

  }

}

SWEP.ViewModelAnimations = {

  [ "attack" ] = {

    {

      3, 4, 5

    },

    {

      3, 4

    }

  },

  [ "idle" ] = {

    [ 1 ] = 2,
    [ 2 ] = 0

  }

}

sound.Add( {

  channel = CHAN_WEAPON,
  name = "1h_sword.draw",
  level = 66,
  sound = {

    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_1.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_2.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_3.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_4.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_5.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_6.ogg"

  },
  volume = 1.0,
  pitch = { 98, 118 }

} )

sound.Add( {

  channel = CHAN_WEAPON,
  name = "2h_sword.draw",
  level = 66,
  sound = {

    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_1.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_2.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_3.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_4.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_5.ogg",
    "nextoren/scp/2012/1h_sword/movement/draw/bladedmedium_slide_start_6.ogg"

  },
  volume = 1.0,
  pitch = { 70, 88 }

} )

sound.Add( {

  channel = CHAN_WEAPON,
  name = "1h_sword.woosh",
  level = 90,
  sound = {

    "nextoren/scp/2012/1h_sword/woosh/woosh_blade_1.ogg",
    "nextoren/scp/2012/1h_sword/woosh/woosh_blade_2.ogg",
    "nextoren/scp/2012/1h_sword/woosh/woosh_blade_3.ogg"

  },
  volume = 1.0,
  pitch = { 70, 90 }

} )

sound.Add( {

  channel = CHAN_WEAPON,
  name = "1h_sword.hit",
  level = 80,
  sound = {

    "nextoren/scp/2012/1h_sword/hits/hit_blade_1.ogg",
    "nextoren/scp/2012/1h_sword/hits/hit_blade_2.ogg",
    "nextoren/scp/2012/1h_sword/hits/hit_blade_3.ogg",
    "nextoren/scp/2012/1h_sword/hits/hit_blade_4.ogg",
    "nextoren/scp/2012/1h_sword/hits/hit_blade_5.ogg",
    "nextoren/scp/2012/1h_sword/hits/hit_blade_6.ogg",
    "nextoren/scp/2012/1h_sword/hits/hit_blade_7.ogg"

  },
  volume = 1.0,
  pitch = { 80, 98 }

} )

sound.Add( {

  channel = CHAN_WEAPON,
  name = "2h_sword.woosh",
  level = 100,
  sound = {

    "nextoren/scp/2012/2h_sword/woosh/woosh_blade_1.ogg",
    "nextoren/scp/2012/2h_sword/woosh/woosh_blade_2.ogg",
    "nextoren/scp/2012/2h_sword/woosh/woosh_blade_3.ogg",
    "nextoren/scp/2012/2h_sword/woosh/woosh_blade_4.ogg",
    "nextoren/scp/2012/2h_sword/woosh/woosh_blade_5.ogg",
    "nextoren/scp/2012/2h_sword/woosh/woosh_blade_6.ogg"

  },
  volume = 1.0,
  pitch = { 95, 105 }

} )

sound.Add( {

  channel = CHAN_STATIC,
  name = "2h_sword.hit",
  level = 110,
  sound = {

    "nextoren/scp/2012/2h_sword/hits/hit_blade_1.ogg",
    "nextoren/scp/2012/2h_sword/hits/hit_blade_2.ogg",
    "nextoren/scp/2012/2h_sword/hits/hit_blade_3.ogg",
    "nextoren/scp/2012/2h_sword/hits/hit_blade_4.ogg"

  },
  volume = 1.0,
  pitch = { 95, 108 }

} )

SWEP.ViewModels = {

  Model( "models/cultist/scp/scp2012/v_sword.mdl" ),
  Model( "models/cultist/scp/scp2012/v_2h_sword.mdl" )

}

function SWEP:SetupDataTables()

  self:NetworkVar( "Int", 1, "Stance" )
  self:NetworkVar( "Bool", 1, "StanceChanging" )
  self:NetworkVar( "Bool", 2, "BlockUp" )
  self:NetworkVar( "Bool", 3, "Charging" )

  self:SetStance( 2 )

  self:SetStanceChanging( false )
  self:SetBlockUp( false )
  self:SetCharging( false )

end

function SWEP:Deploy()

  self.NextIdle = CurTime() + 1.25

  local current_stance = self:GetStance()

  self:SetNextPrimaryFire( self.NextIdle )
  self:SetNextSecondaryFire( self.AbilityIcons[ current_stance ][ 2 ].CooldownTime || self.NextIdle )

  if ( self.AbilityIcons[ 2 ][ 1 ].CooldownTime == 0 ) then

    self:SetStanceChanging( true )
    self:StanceChanged( current_stance, nil, true )

  end

  if ( SERVER ) then

    hook.Remove( "PlayerButtonDown", "SCP2012_Crossbow_ChangeWeapon" )
    self.Owner.AlreadyChanging = nil

    hook.Add( "PlayerButtonDown", "SCP2012_ChangeWeapon", function( player, button )

      if ( player:GetRoleName() != "SCP2012" ) then return end

      local wep = player:GetActiveWeapon()

      if ( wep:GetBlockUp() || wep:GetCharging() ) then return end

      if ( button == KEY_H && !player.AlreadyChanging && self.AbilityIcons[ wep:GetStance() ][ 3 ].CooldownTime < CurTime() ) then

        player.AlreadyChanging = true

        wep.NextIdle = CurTime() + 2.6

        wep:SetNextPrimaryFire( CurTime() + 3 )
        wep:SetNextSecondaryFire( CurTime() + 3 )

        wep:PlaySequence( "holster" )

        wep:SetStanceChanging( false )

        timer.Simple( 1.25, function()

          if ( !( player && player:IsValid() ) || player:GetRoleName() != "SCP2012" ) then return end

          if ( !player:HasWeapon( "weapon_scp_2012_crossbow" ) ) then

            player:Give( "weapon_scp_2012_crossbow" )

            timer.Simple( 0, function()

              player:SelectWeapon( "weapon_scp_2012_crossbow" )

            end )

          else

            player:SelectWeapon( "weapon_scp_2012_crossbow" )

          end

        end )

      end

    end )

  end

end

local offset_angle_idle = Angle( 215, -25, 205 )

function SWEP:CreateShield()

  if ( self.Shield && self.Shield:IsValid() ) then return end

  self.Shield = ents.Create( "scp_2012_shield" )
  self.Shield:SetParent( self.Owner, 40 )
  self.Shield:SetOwner( self.Owner )
  self.Shield:SetTransmitWithParent( true )

  local attach_data = self.Owner:GetAttachment( 40 )

  self.Shield:SetPos( attach_data.Pos )

  self.Shield:SetLocalAngles( offset_angle_idle )

  self.Shield:Spawn()

  self.Shield.ResetAngles = function( self )

    self:SetLocalAngles( offset_angle_idle )
    self:SetLocalPos( vector_origin )

  end

  self.Shield.Think = function( self )

    self:NextThink( CurTime() )

    local parent = self:GetParent()

    if ( !( parent && parent:IsValid() ) || parent:Health() <= 0 || parent:GetRoleName() != "SCP2012" || ( parent:GetActiveWeapon().GetStance && parent:GetActiveWeapon():GetStance() != 1 ) ) then

      self:Remove()

    end

  end

end

function SWEP:StanceChanged( stance_id, anim_client, firstdeploy )

  for name, v in pairs( self.Stance_Animations[ stance_id ] ) do

    if ( !istable( v ) ) then

      if ( name:find( "walk" ) ) then

        self.Owner.SafeModeWalk = self.Owner:LookupSequence(v)

      elseif ( name:find( "idle" ) ) then

        self.Owner.IdleSafemode = self.Owner:LookupSequence(v)

      else

        self.Owner.SafeRun = self.Owner:LookupSequence(v)

      end

    else

      self.Owner.AttackAnimations = v
      self.Owner.AttackAnimations[1] = self.Owner:LookupSequence(self.Owner.AttackAnimations[1])
      self.Owner.AttackAnimations[2] = self.Owner:LookupSequence(self.Owner.AttackAnimations[2])

    end

  end

  if ( anim_client ) then return end

  self:SetStance( stance_id )

  if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) && ( self.Owner:GetViewModel() && self.Owner:GetViewModel():IsValid() ) ) then

    self.Owner:GetViewModel():SetWeaponModel( self.ViewModels[ stance_id ], self )

  end

  if ( CLIENT && LocalPlayer():GetRoleName() == "SCP2012" ) then

    self:ChooseAbility( self.AbilityIcons[ stance_id ] )

  end

  self:SetNextPrimaryFire( CurTime() + 1 )
  self:SetNextSecondaryFire( CurTime() + 1 )

  if ( stance_id == 1 ) then

    self:EmitSound( "1h_sword.draw" )

  else

    self:EmitSound( "2h_sword.draw" )

  end

  if ( !firstdeploy ) then

    self.AbilityIcons[ stance_id ][ 1 ].CooldownTime = CurTime() + 10

  end

  timer.Simple( .25, function()

    self:PlaySequence( "draw" )

    timer.Simple( .1, function()

      if ( !( self && self:IsValid() ) ) then return end
      
      self:SetStanceChanging( false )

    end )

  end )

  if ( SERVER ) then

    if ( stance_id == 1 ) then

      self.Owner:SetWalkSpeed( 120 )
      self.Owner:SetRunSpeed( 120 )

    else

      self.Owner:SetWalkSpeed( 200 )
      self.Owner:SetRunSpeed( 200 )

    end

  end

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:Holster()

  for i = 1, 2 do

    self.AbilityIcons[ i ][ 3 ].CooldownTime = CurTime() + 90

  end

  if ( SERVER ) then

    hook.Remove( "PlayerButtonDown", "SCP2012_ChangeWeapon" )

    if ( self.Shield && self.Shield:IsValid() ) then

      self.Shield:Remove()

    end

  elseif ( CLIENT ) then

    timer.Simple( .5, function()

      if ( !( self && self:IsValid() ) ) then return end

      if ( self.Owner != LocalPlayer() ) then return end

      local wep = self.Owner:GetWeapon( "weapon_scp_2012_crossbow" )

      if ( wep && wep:IsValid() ) then

        wep:Deploy()

      end

    end )

  end

  return true

end

function SWEP:Reload()

  if ( ( self.AbilityIcons[ self:GetStance() ][ 1 ].CooldownTime || 0 ) > CurTime() ) then return end

  if ( self:GetBlockUp() || self:GetCharging() ) then return end

  if ( ( self.NextIdle || 0 ) > CurTime() ) then return end

  self.NextIdle = CurTime() + 3
  self:PlaySequence( "holster" )

  self:SetNextPrimaryFire( CurTime() + 1.5 )
  self:SetNextSecondaryFire( CurTime() + 1.5 )

  timer.Simple( 1.25, function()

    if ( !( self && self:IsValid() ) ) then return end

    self:SetStanceChanging( true )

    if ( IsFirstTimePredicted() ) then

      if ( self:GetStance() != 1 ) then

        self:StanceChanged( 1 )

      else

        self:StanceChanged( 2 )

      end

    end

  end )

end

if ( SERVER ) then

  function SWEP:Think()

    if ( self:GetStance() == 1 && !( self.Shield && self.Shield:IsValid() ) ) then

      self:CreateShield()

    end

    if ( !self:GetBlockUp() ) then

      if ( ( self.NextIdle || 0 ) < CurTime() && !self.IdlePlaying ) then

        self.IdlePlaying = true
        self:PlaySequence( self.ViewModelAnimations.idle[ self:GetStance() ], true )

      end

    end

  end

end

if ( CLIENT ) then

  function SWEP:DrawWorldModel()

	  self:DrawModel()

    if ( self:GetStance() == 1 && self.Owner.SafeModeWalk != self.Owner:LookupSequence("scp_2012_1h_walk") ) then

      self:StanceChanged( 1, true )

    elseif ( self:GetStance() == 2 && self.Owner.SafeModeWalk != self.Owner:LookupSequence("scp_2012_2h_walk")  ) then

      self:StanceChanged( 2, true )

    end

  end

  function SWEP:Think()

    if ( self:GetStance() == 1 && self.Owner.SafeModeWalk != self.Owner:LookupSequence("scp_2012_1h_walk") ) then

      self:StanceChanged( 1 )

    elseif ( self:GetStance() == 2 && self.Owner.SafeModeWalk != self.Owner:LookupSequence("scp_2012_2h_walk") ) then

      self:StanceChanged( 2 )

    end

  end

  function SWEP:ShouldDrawViewModel()

    return !self:GetStanceChanging()

  end

  local background_icon_clr = Color( 10, 10, 40, 240 )

  function SWEP:DrawHUD()

    if ( !self.EquipTime ) then

      self.EquipTime = CurTime()

    end

    if ( !self.AbilityTableID && self.EquipTime <= CurTime() - 2 ) then

      self.AbilityTableID = 2
      self:ChooseAbility( self.AbilityIcons[ self.AbilityTableID ] )

    end

    if ( self:GetBlockUp() || self:GetCharging() ) then

      local parameters_tbl = self.AbilityIcons[ self:GetStance() ][ 2 ]

      if ( !self.CurrentIcon || self.CurrentIcon:GetName() != parameters_tbl.Icon ) then -- Icon doesn't exist, create it || Current icon isn't correct, change it

        self.CurrentIcon = Material( parameters_tbl.Icon )

      end

      local percent = ( ( parameters_tbl.CooldownTime - CurTime() ) + parameters_tbl.activetime - parameters_tbl.Cooldown ) / parameters_tbl.activetime

      if ( percent < 0 ) then return end

      local middle_w = ScrW() / 2
      local screen_h = ScrH()

      local y = screen_h * .7

      local quad_vec = Vector( middle_w, y )

      render.SetMaterial( self.CurrentIcon )

      render.DrawQuadEasy( quad_vec,

        -vector_up,
        64, 64,
        background_icon_clr,
        -90

      )

      render.SetScissorRect( middle_w + 30, y + 64 * .5 - 64 * percent, 197, screen_h, true )

      -- same material
      render.DrawQuadEasy( quad_vec,

        -vector_up,
        64, 64,
        color_white,
        -90

      )

      render.SetScissorRect( 0, y + ( 64 * .5 ), 197, screen_h, false )

    end

  end

  function SWEP:DrawHUDBackground()

    if ( BREACH.Abilities && BREACH.Abilities.AbilityIcons && BREACH.Abilities.AbilityIcons != self.AbilityIcons[ self:GetStance() ] ) then

      self:ChooseAbility( self.AbilityIcons[ self:GetStance() ] )

    end

  end

end

local maxs = Vector( 10, 8, 32 )

local anim_1_viewangles = Angle( 15, 30, 0 )
local anim_2_viewangles = Angle( -30, 0, 0 )

function SWEP:PrimaryAttack()

  if ( self:GetBlockUp() || self:GetStanceChanging() ) then return end

  self:SetNextPrimaryFire( CurTime() + 2.25 )

  self.Owner:SetAnimation( PLAYER_ATTACK1 )

  if ( IsFirstTimePredicted() ) then

    local trace = {}
    trace.start = self.Owner:GetShootPos()

    if ( self:GetStance() != 1 ) then

      trace.endpos = trace.start + self.Owner:GetAngles():Forward() * 80

    else

      trace.endpos = trace.start + self.Owner:GetAngles():Forward() * 60

    end

    if ( self:GetStance() == 1 ) then

      trace.filter = { self.Shield, self.Owner }

    else

      trace.filter = self.Owner

    end

    trace.mins = -maxs
    trace.maxs = maxs

    self.Owner:LagCompensation( true )

    trace = util.TraceHull( trace )

    self.Owner:LagCompensation( false )

    if ( self:GetStance() != 1 ) then

      self:EmitSound( "2h_sword.woosh" )

    else

      self:EmitSound( "1h_sword.woosh" )

    end

    local ent = trace.Entity

    if ( ent && ent:IsValid() && ent:IsPlayer() && ent:GTeam() != TEAM_SCP ) then

      if ( SERVER ) then

        local dmginfo = DamageInfo()
        dmginfo:SetDamage( ent:GetMaxHealth() * .5 )
        dmginfo:SetDamageForce( math.min( 300, 50 ) * 80 * self.Owner:GetAimVector()  )
        dmginfo:SetAttacker( self.Owner )
        dmginfo:SetInflictor( self )
        dmginfo:SetDamageType( DMG_SLASH )

        ent:TakeDamageInfo( dmginfo )

        if ( self:GetStance() != 1 ) then

          self.Owner:EmitSound( "2h_sword.hit" )

        else

          self.Owner:EmitSound( "1h_sword.hit" )

        end

      end

      local impact_effect = EffectData()
      impact_effect:SetOrigin( trace.HitPos )
      impact_effect:SetNormal( trace.HitNormal )
      impact_effect:SetColor( BLOOD_COLOR_RED )

      util.Effect( "BloodImpact", impact_effect )

    end

    local anim_table = self.ViewModelAnimations.attack[ self:GetStance() ]

    if ( anim_table ) then

      local id = math.random( 1, #anim_table )

      if ( id == 1 ) then

        self.Owner:ViewPunch( anim_1_viewangles )

      else

        self.Owner:ViewPunch( anim_2_viewangles )

      end

      local attack_animation = anim_table[ id ]

      if ( attack_animation ) then

        self.NextIdle = CurTime() + 1.25
        self:SetNextPrimaryFire( self.NextIdle )

        self.IdlePlaying = nil

        self:PlaySequence( attack_animation )

      end

    end

  end

end

local shield_offset_pos = Vector( 0, -6, -6 )
local shield_offset_angles_up = Angle( -117, 5, 145 )

function SWEP:SecondaryAttack()

  local t_cd = CurTime() + self.AbilityIcons[ self:GetStance() ][ 2 ].Cooldown

  self:SetNextSecondaryFire( t_cd )

  self.AbilityIcons[ self:GetStance() ][ 2 ].CooldownTime = t_cd

  if ( self:GetStance() == 1 ) then

    self:SetBlockUp( true )

    self:PlaySequence( "idle_to_blocked" )

    if ( SERVER ) then

      self.Shield:SetLocalPos( shield_offset_pos )
      self.Shield:SetLocalAngles( shield_offset_angles_up )

      net.Start( "GestureClientNetworking" )

        net.WriteEntity( self.Owner )
        net.WriteString( "scp_2012_1h_block_fast" )
        net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
        net.WriteBool( true )

      net.Broadcast()

    end

    timer.Simple( self.Owner:SequenceDuration( 5305 ) - 1, function()

      if ( SERVER ) then

        if ( !( self && self:IsValid() ) ) then return end

        net.Start( "GestureClientNetworking" )

          net.WriteEntity( self.Owner )
          net.WriteString("scp_2012_1h_block_up_idle")
          net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
          net.WriteBool( false )

        net.Broadcast()

      end

      self:PlaySequence( "blocked_idle" )

    end )

    timer.Simple( 10, function()

      if ( SERVER ) then

        if ( !( self && self:IsValid() ) ) then return end

        net.Start( "GestureClientNetworking" )

          net.WriteEntity( self.Owner )
          net.WriteString("scp_2012_1h_block_down")
          net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
          net.WriteBool( true )

        net.Broadcast()

      end

      self:PlaySequence( "blocked_to_idle" )

      if ( SERVER ) then

        timer.Simple( self.Owner:SequenceDuration( 50306 ) - .25, function()

          if ( !( self && self:IsValid() ) ) then return end

          self.Shield:ResetAngles()
          self:SetBlockUp( false )

        end )

      end

    end )

  else

    self:SetCharging( true )

    self.Owner:SetWalkSpeed( 255 )
    self.Owner:SetRunSpeed( 255 )

    timer.Simple( 15, function()

      if ( !( self && self:IsValid() ) ) then return end

      self:SetCharging( false )

      self.Owner:SetWalkSpeed( 200 )
      self.Owner:SetRunSpeed( 200 )

    end )

  end

end
