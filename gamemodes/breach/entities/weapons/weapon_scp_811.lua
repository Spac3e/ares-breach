SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-811"
SWEP.HoldType = "scp811"
SWEP.ViewModel = ""
SWEP.WorldModel = "models/cultist/items/blue_screwdriver/w_screwdriver.mdl"

SWEP.Base = "breach_scp_base"

SWEP.AbilityIcons = {

  {

    Name = "Acid Bomb",
    Description = "None provided",
    Cooldown = 3,
    CooldownTime = 0,
    Acid = 30,
    KEY = "LMB",
    Icon = "nextoren/gui/special_abilities/811/811_acid_bomb.png"

  },
  {

    Name = "Acid Bomb Long",
    Description = "None provided",
    Cooldown = 5,
    CooldownTime = 0,
    Acid = 40,
    KEY = "RMB",
    Icon = "nextoren/gui/special_abilities/811/811_long_spit.png"

  },
  {

    Name = "Acid trap",
    Description = "None provided",
    Cooldown = 15,
    CooldownTime = 0,
    Acid = 70,
    max = 3,
    KEY = _G[ "KEY_R" ],
    Icon = "nextoren/gui/special_abilities/811/811_acid_mine.png"

  },
  {

    Name = "Vomit",
    Description = "None provided",
    Cooldown = 20,
    CooldownTime = 0,
    Acid = 70,
    KEY = _G[ "KEY_T" ],
    Icon = "nextoren/gui/special_abilities/811/811_acid_puke.png"

  },
  {

    Name = "Acid Bomb",
    Description = "",
    Cooldown = 90,
    CooldownTime = 0,
    Acid = 100,
    KEY = _G[ "KEY_F" ],
    Icon = "nextoren/gui/special_abilities/811/811_close_spreading.png"

  }

}

if ( SERVER ) then

  sound.Add( {

    name = "scp811.attack",
    channel = CHAN_STATIC,
    volume = .5,
    pitch = { 90, 100 },
    sound = {

      "nextoren/scp/811/main_attack_1.wav",
      "nextoren/scp/811/main_attack_2.wav"

    }

  } )

  sound.Add( {

    name = "scp811.attack_long",
    channel = CHAN_STATIC,
    volume = .65,
    pitch = { 70, 80 },
    sound = {

      "nextoren/scp/811/main_attack_1.wav",
      "nextoren/scp/811/main_attack_2.wav"

    }

  } )

  sound.Add( {

    name = "scp811.vomit",
    channel = CHAN_STATIC,
    volume = .8,
    level = 90,
    pitch = { 90, 100 },
    sound = "nextoren/scp/811/abilities/vomit.wav"

  } )

  sound.Add( {

    name = "scp811.spreading",
    channel = CHAN_STATIC,
    volume = .85,
    level = 90,
    pitch = { 90, 100 },
    sound = "nextoren/scp/811/abilities/acid_bomb.wav"

  } )

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

end

function SWEP:SetupDataTables()

  self:NetworkVar( "Float", 0, "AcidAmount" )
  self:NetworkVar( "Bool", 0, "Vomiting" )

  self:SetAcidAmount( 100 )
  self:SetVomiting( false )

end

function SWEP:Deploy()

  self.Deployed = true

	hook.Add( "EntityTakeDamage", "SCP_811_EntityTakeDamage", function( target, dmginfo )
		local attacker = dmginfo:GetAttacker()

		if ( target:IsPlayer() and target:GTeam() == TEAM_SCP and IsValid(attacker) and attacker:IsPlayer() and attacker:GetRoleName() == "SCP811" ) then
			return true
		end
	end )

  hook.Add( "PlayerButtonDown", "SCP_811_ButtonTrigger", function( player, button )

    if ( player:GetRoleName() != "SCP811" ) then return end

    local wep = player:GetActiveWeapon()

    if ( wep == NULL ) then return end

    if ( button == KEY_F ) then

      if ( ( wep.AbilityIcons[ 5 ].CooldownTime || 0 ) > CurTime() ) then return end

      wep.AbilityIcons[ 5 ].CooldownTime = CurTime() + wep.AbilityIcons[ 5 ].Cooldown

      if ( SERVER ) then

        wep:AOEExplode()

      end

    elseif ( button == KEY_T ) then

      if ( ( wep.AbilityIcons[ 4 ].CooldownTime || 0 ) > CurTime() ) then return end

      wep.AbilityIcons[ 4 ].CooldownTime = CurTime() + wep.AbilityIcons[ 4 ].Cooldown

      if ( SERVER ) then

        wep:Vomit()

      end

    end

  end )

  if ( CLIENT ) then

    local clr_green = Color( 0, 200, 0, 225 )
    local clr_red = Color( 200, 0, 0, 225 )
    local darkgray = Color( 105, 105, 105 )

    timer.Simple( 1, function()

      if ( !( self && self:IsValid() ) ) then return end

      if ( !BREACH.Abilities ) then return end

      for i = 1, #self.AbilityIcons do

        BREACH.Abilities.Buttons[ i ].PaintOverride = function( self, w, h )

          local clr_to_draw = clr_green
          local ability_table = BREACH.Abilities.AbilityIcons[ i ]
          local need_acid = ability_table.Acid

          local client = LocalPlayer()

          local wep = client:GetActiveWeapon()

          if ( wep != NULL && wep.GetAcidAmount && wep:GetAcidAmount() < need_acid && ability_table.CooldownTime <= CurTime() ) then

            clr_to_draw = clr_red
            draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( darkgray, 190 ) )

          end

          if ( ability_table.max ) then

      			local n_max = ability_table.max || 0

      			draw.SimpleTextOutlined( tostring( n_max ), "HUDFont", 8, 4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, color_black )

      			if ( n_max <= 0 ) then

      				draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( darkgray, 190 ) )

      			end

      		end

          draw.SimpleText( ability_table.Acid, "HUDFont", 33, 33, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
          draw.SimpleText( ability_table.Acid, "HUDFont", 32, 32, clr_to_draw, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

          if ( ability_table.CooldownTime > CurTime() ) then

            draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( darkgray, 190 ) )
            draw.RoundedBox( 0, 0, h - ( h * ( 1 * ( ( ability_table.CooldownTime - CurTime() ) / ability_table.Cooldown ) ) ), w, h, ColorAlpha( clr_red, 190 ) )

          end

        end

      end

    end )

  else

    self.Owner:SetSpecialMax( 3 )

  end

end

function SWEP:Reload()

  if ( self.Owner:GetSpecialMax() <= 0 ) then return end

  if ( self:GetAcidAmount() < self.AbilityIcons[ 3 ].Acid ) then return end

  if ( ( self.AbilityIcons[ 3 ].CooldownTime || 0 ) > CurTime() ) then return end

  self.AbilityIcons[ 3 ].CooldownTime = CurTime() + self.AbilityIcons[ 3 ].Cooldown

  if ( CLIENT ) then return end

  self:SetAcidAmount( self:GetAcidAmount() - self.AbilityIcons[ 3 ].Acid )
  self.Owner:SetSpecialMax( self.Owner:GetSpecialMax() - 1 )

  local trace = {}
  trace.start = self.Owner:GetShootPos()
  trace.endpos = trace.start + self.Owner:GetAimVector() * 80
  trace.filter = { self, self.Owner }
  trace.mask = MASK_SHOT

  trace = util.TraceLine( trace )

  local trap = ents.Create( "ent_scp811_trap" )
  trap:SetPos( trace.HitPos )
  trap:SetOwner( self.Owner )
  trap:Spawn()

end

function SWEP:AOEExplode()

  if ( CLIENT ) then return end

  if ( self:GetAcidAmount() < self.AbilityIcons[ 5 ].Acid ) then return end

  self:SetAcidAmount( self:GetAcidAmount() - self.AbilityIcons[ 5 ].Acid )
  self.Owner:EmitSound( "scp811.spreading" )

  net.Start( "CreateClientParticleSystem" )

    net.WriteEntity( self.Owner )
    net.WriteString( "death_comeout" )
    net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
    net.WriteUInt( 0, 7 )

  net.Broadcast()

  net.Start( "CreateClientParticleSystem" )

    net.WriteEntity( self )
    net.WriteString( "kul_landing_updownSmoke" )
    net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
    net.WriteUInt( 0, 7 )

  net.Broadcast()

  local explode_dmginfo = DamageInfo()
  explode_dmginfo:SetDamage( math.random( 400, 500 ) )
  explode_dmginfo:SetDamageType( DMG_BLAST )
  explode_dmginfo:SetAttacker( self.Owner )
  explode_dmginfo:SetInflictor( self )

  util.BlastDamageInfo( explode_dmginfo, self:GetPos(), 400 )

end

function SWEP:OnRemove()

  local players = player.GetAll()

  for i = 1, #players do

    local player = players[ i ]

    if ( player && player:IsValid() && player:GetRoleName() == "SCP811" ) then return end

  end

  hook.Remove( "PlayerButtonDown", "SCP_811_ButtonTrigger" )

  hook.Remove( "EntityTakeDamage", "SCP_811_EntityTakeDamage" )

end

function SWEP:Vomit()

  if ( CLIENT ) then return end

  if ( self:GetAcidAmount() < self.AbilityIcons[ 4 ].Acid ) then return end

  self:SetAcidAmount( self:GetAcidAmount() - self.AbilityIcons[ 4 ].Acid )

  self.Owner:SetForcedAnimation( "811_attack", 2, function()

    self.Owner:SetMoveType( MOVETYPE_OBSERVER )
    self.Owner:EmitSound( "scp811.vomit" )

    self:SetVomiting( true )

    net.Start( "ThirdPersonCutscene" )

      net.WriteUInt( 2, 4 )
      net.WriteBool( false )

    net.Send( self.Owner )

  end, function()

    if ( !( self && self:IsValid() ) ) then return end

    self:SetVomiting( false )

    if ( self.Owner:Health() > 0 && self.Owner:GetRoleName() == "SCP811" ) then

      self.Owner:SetMoveType( MOVETYPE_WALK )

    end

  end )

  net.Start( "CreateClientParticleSystem" )

    net.WriteEntity( self.Owner )
    net.WriteString( "boomer_vomit" )
    net.WriteUInt( PATTACH_POINT_FOLLOW, 3 )
    net.WriteUInt( 2, 7 )
    net.WriteVector( self.Owner:GetAngles():Forward() )

  net.Broadcast()

  for i = 1, 10 do

    timer.Simple( .2 * i, function()

      local pos = self.Owner:GetShootPos()
      local entities_cone = ents.FindInCone( pos, self.Owner:GetAimVector(), 200, 0.70710678118655 ) -- 90 degrees

      for i = 1, #entities_cone do

        local ent = entities_cone[ i ]

        if ( ent:IsPlayer() && ent:Health() > 0 && ent:IsSolid() ) then

          local vomit_damage = DamageInfo()
          vomit_damage:SetDamageType( DMG_BUCKSHOT )
          vomit_damage:SetDamage( 25 * ( 40000 / ( pos:DistToSqr( ent:GetPos() ) ) ) ) -- 200 * 200
          vomit_damage:SetDamageForce( ent:GetAimVector() * 2 )
          vomit_damage:SetAttacker( self.Owner )
          vomit_damage:SetInflictor( self )

          ent:SetHealth( ent:Health() - vomit_damage:GetDamage() )

          hook.Run( "PlayerHurt", ent )

          if ( ent:Health() <= 0 && !ent.Death_ByAcid ) then

            ent.Death_ByAcid = true
            ent:Kill()

          end

        end

      end

    end )

  end

end

function SWEP:PrimaryAttack()

  if ( self:GetAcidAmount() < self.AbilityIcons[ 1 ].Acid ) then return end

  local CT = CurTime()
  self:SetNextPrimaryFire( CT + self.AbilityIcons[ 1 ].Cooldown )
  self:SetNextSecondaryFire( CT + 1.25 )

  self.AbilityIcons[ 1 ].CooldownTime = CurTime() + self.AbilityIcons[ 1 ].Cooldown

  if ( CLIENT ) then return end

  self.Owner:EmitSound( "scp811.attack" )

  self:SetAcidAmount( self:GetAcidAmount() - self.AbilityIcons[ 1 ].Acid )

  local player_angles = self.Owner:GetAngles()

  local poison_ball = ents.Create( "ent_scp811_poisonball" )
  poison_ball:SetPos( self.Owner:GetShootPos() + player_angles:Forward() * 36 )
  poison_ball:SetAngles( player_angles )
  poison_ball:SetOwner( self.Owner )
  poison_ball:SetVelocity( self.Owner:GetAimVector() * 500 )
  poison_ball:Spawn()
  poison_ball:SetGravity( .9 )

end

function SWEP:SecondaryAttack()

  if ( self:GetAcidAmount() < self.AbilityIcons[ 2 ].Acid ) then return end

  local CT = CurTime()
  self:SetNextSecondaryFire( CT + self.AbilityIcons[ 2 ].Cooldown )
  self:SetNextPrimaryFire( CT + 1.25 )

  self.AbilityIcons[ 2 ].CooldownTime = CurTime() + self.AbilityIcons[ 2 ].Cooldown

  if ( CLIENT ) then return end

  self:SetAcidAmount( self:GetAcidAmount() - self.AbilityIcons[ 2 ].Acid )

  self.Owner:EmitSound( "scp811.attack_long" )

  local player_angles = self.Owner:GetAngles()

  local poison_ball = ents.Create( "ent_scp811_poisonball" )
  poison_ball:SetPos( self.Owner:GetShootPos() + player_angles:Forward() * 34 )
  poison_ball:SetAngles( player_angles )
  poison_ball:SetOwner( self.Owner )
  poison_ball:SetVelocity( self.Owner:GetAimVector() * 800 )
  poison_ball.Distant = true
  poison_ball:Spawn()
  poison_ball:SetGravity( .2 )

end

if ( SERVER ) then

  function SWEP:Think()

    if ( self:GetAcidAmount() < 100 ) then

      self:SetAcidAmount( math.Approach( self:GetAcidAmount(), 100, FrameTime() * 4 ) )

    end

  end

else

  function SWEP:DrawWorldModel()

    if ( self:GetVomiting() ) then

      local dynamic_light = DynamicLight( self:EntIndex() )

      if ( dynamic_light ) then

        dynamic_light.Pos = self:GetPos() + self.Owner:GetForward() * 80
        dynamic_light.Brightness = 1.5
        dynamic_light.r = 0
        dynamic_light.g = 80
        dynamic_light.b = 0
        dynamic_light.Size = 180
        dynamic_light.Decay = 1200
        dynamic_light.DieTime = CurTime() + .1

      end

    end

  end

  local clr_green = Color( 0, 140, 0 )
  local slime_water = Material( "nature/water_a1_intro3", "smooth" )

  function SWEP:DrawHUDBackground()

    if ( !self.Deployed ) then

      self:Deploy()

    end

    local acid_amount = self:GetAcidAmount()
    local scrh = ScrH()

    local x, y = ScrW() / 2 - ( 32 * #self.AbilityIcons ), ScrH() / 1.2
    local w = 64 * #self.AbilityIcons

    local multiplier = acid_amount / 100

    local current_percent = math.Round( 100 * multiplier )

    draw.RoundedBox( 6, x, y - 14, w, 12, color_black )
    draw.RoundedBox( 6, x, y - 14, w * ( 1 * multiplier ), 12, clr_green )

    draw.SimpleText( current_percent, "ChatFont_new", x + w / 2, y - 8, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if ( self.Owner:GetSpecialMax() != self.AbilityIcons[ 3 ].max ) then

      self.AbilityIcons[ 3 ].max = self.Owner:GetSpecialMax()

    end

  end

end
