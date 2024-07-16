AddCSLuaFile()


if ( CLIENT ) then

  SWEP.Category = "[NextOren] Melee"
  SWEP.PrintName = "SCP-973"
  SWEP.Slot = 1
  SWEP.ViewModelFOV = 70
  SWEP.DrawSecondaryAmmo = false
  SWEP.DrawAmmo = false

end

SWEP.AbilityIcons = {

  {

		["Name"] = "Stun gun",
		["Description"] = "Оглушение текущей цели",
		["Cooldown"] = 25,
		["CooldownTime"] = 0,
		["KEY"] = "RMB",
		["Using"] = false,
    ["Forbidden"] = true,
		["Icon"] = "nextoren/gui/special_abilities/scp_973_stun.png"

	},

  {

    ["Name"] = "Shotgun",
    ["Description"] = "",
    ["Cooldown"] = 75,
    ["CooldownTime"] = 0,
    ["KEY"] = _G[ "KEY_R" ],
    ["Using"] = false,
    ["Forbidden"] = true,
    ["Icon"] = "nextoren/gui/special_abilities/scp_973_weapon.png"

  },

  {

    ["Name"] = "Revolver",
    ["Description"] = "",
    ["Cooldown"] = 50,
    ["CooldownTime"] = 0,
    ["KEY"] = _G[ "KEY_G" ],
    ["Using"] = false,
    ["Forbidden"] = true,
    ["Icon"] = "nextoren/gui/special_abilities/scp_973_weapon.png"

  }

}

SWEP.Base = "breach_scp_base"

SWEP.ViewModel = "models/cultist/scp/scp_973/weapons/v_stun_batton.mdl"
SWEP.WorldModel = "models/cultist/scp/scp_973/weapons/w_stun_batton.mdl"
SWEP.HoldType = "tonfa"

SWEP.Pos = Vector( -1, 4, 8 )
SWEP.Ang = Angle( 175, 0, 200 )

SWEP.UseHands = true

SWEP.Target_Rage = 0

SWEP.NextVoiceLine = 0

function SWEP:VoiceLine( s_sound )

  if ( self.Voice_Line && self.Voice_Line:IsPlaying() ) then

    self.Voice_Line:Stop()

  end

  self.Voice_Line = CreateSound( self.Owner, s_sound )
  self.Voice_Line:SetDSP( 17 )
  self.Voice_Line:SetSoundLevel( 80 )
  self.Voice_Line:Play()

end

function SWEP:SetupDataTables()

  self:NetworkVar( "Int", 0, "Rage" )

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )
  if ( SERVER ) then

		local filter = RecipientFilter()
		filter:AddAllPlayers()

		self.tazersound = CreateSound( self, "weapons/tazer_sound.wav", filter )
		self.tazersound:Stop()

	end

end

function SWEP:Deploy_Rage()

  self.Target_Rage = self.Target_Rage - 50

  if ( SERVER ) then

    self.Owner:BreachGive( "weapon_scp_973_rage" )

  end

  if ( SERVER ) then

    self:VoiceLine( "nextoren/scp/973/rage_" .. math.random( 1, 2 ) .. ".ogg" )

  end

  self.Owner:SetWalkSpeed( 220 )
  self.Owner:SetRunSpeed( 220 )

  self.Owner:SelectWeapon( "weapon_scp_973_rage" )

  timer.Simple( 8, function()

    if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

      self.Owner:SelectWeapon( "weapon_scp_973" )
      self.Owner:SetWalkSpeed( 125 )
      self.Owner:SetRunSpeed( 125 )

    end

  end )

  local rage = 0

  timer.Create( "SCP_973_CheckRage", 0, 0, function()

    local wep = self.Owner:GetActiveWeapon()

    if ( wep == NULL ) then

      timer.Remove( "SCP_973_CheckRage" )

      return
    end

    if ( wep:GetClass() == "weapon_scp_973" ) then

      if ( SERVER ) then

        self.Owner:GetWeapon( "weapon_scp_973_rage" ):Remove()

      end

      timer.Remove( "SCP_973_CheckRage" )

      return
    end

    local primary_swep = self.Owner:GetWeapon( "weapon_scp_973" )

    if ( SERVER ) then

      if ( primary_swep.Target_Rage != primary_swep:GetRage() ) then

        if ( rage == 0 ) then

          rage = primary_swep:GetRage()

        end

        rage = math.Approach( rage, primary_swep.Target_Rage, FrameTime() * 12 )

        primary_swep:SetRage( rage )

      end

    end

    if ( CLIENT ) then

      if ( primary_swep:GetRage() >= 25 && primary_swep.AbilityIcons[ 1 ].Forbidden ) then

        primary_swep.AbilityIcons[ 1 ].Forbidden = false

      elseif ( primary_swep:GetRage() < 25 && !primary_swep.AbilityIcons[ 1 ].Forbidden ) then

        primary_swep.AbilityIcons[ 1 ].Forbidden = true

      elseif ( primary_swep:GetRage() >= 75 && primary_swep.AbilityIcons[ 2 ].Forbidden ) then

        primary_swep.AbilityIcons[ 2 ].Forbidden = false

      elseif ( primary_swep:GetRage() < 75 && !primary_swep.AbilityIcons[ 2 ].Forbidden ) then

        primary_swep.AbilityIcons[ 2 ].Forbidden = true

      end

    end

  end )

end

function SWEP:Deploy_Shotgun()

  if ( SERVER ) then

    self.Owner:BreachGive( "cw_kk_scp_973" )

  end

  self.Owner:SelectWeapon( "cw_kk_scp_973" )

  local rage = 0

  timer.Create( "SCP_973_CheckAmmo", 0, 0, function()

    local wep = self.Owner:GetActiveWeapon()

    if ( wep == NULL ) then

      timer.Remove( "SCP_973_CheckAmmo" )

      return
    end

    if ( wep:GetClass() == "weapon_scp_973" ) then

      if ( SERVER ) then

        self.Owner:GetWeapon( "cw_kk_scp_973" ):Remove()

      end

      timer.Remove( "SCP_973_CheckAmmo" )

      return
    end

    local primary_swep = self.Owner:GetWeapon( "weapon_scp_973" )

    if ( SERVER ) then

      if ( primary_swep.Target_Rage != primary_swep:GetRage() ) then

        if ( rage == 0 ) then

          rage = primary_swep:GetRage()

        end

        rage = math.Approach( rage, primary_swep.Target_Rage, FrameTime() * 12 )

        primary_swep:SetRage( rage )

      end

    end

    if ( CLIENT ) then

      if ( !primary_swep.GetRage ) then return end

      if ( primary_swep:GetRage() >= 25 && primary_swep.AbilityIcons[ 1 ].Forbidden ) then

        primary_swep.AbilityIcons[ 1 ].Forbidden = false

      elseif ( primary_swep:GetRage() < 25 && !primary_swep.AbilityIcons[ 1 ].Forbidden ) then

        primary_swep.AbilityIcons[ 1 ].Forbidden = true

      elseif ( primary_swep:GetRage() >= 75 && primary_swep.AbilityIcons[ 2 ].Forbidden ) then

        primary_swep.AbilityIcons[ 2 ].Forbidden = false

      elseif ( primary_swep:GetRage() < 75 && !primary_swep.AbilityIcons[ 2 ].Forbidden ) then

        primary_swep.AbilityIcons[ 2 ].Forbidden = true

      end

    end

    local wep_ammo = wep:Clip1()

    if ( wep_ammo == 0 ) then

      self.Owner:SelectWeapon( "weapon_scp_973" )

    end

  end )

end

function SWEP:Deploy_Revolver()

  if ( SERVER ) then

    self.Owner:BreachGive( "cw_kk_scp_973_pistol" )

    self.Owner:SetAmmo(0, "Pistol")

  end

  self.Owner:SelectWeapon( "cw_kk_scp_973_pistol" )

  local rage = 0

  timer.Create( "SCP_973_CheckAmmo", 0, 0, function()

    local wep = self.Owner:GetActiveWeapon()

    if ( wep == NULL ) then

      timer.Remove( "SCP_973_CheckAmmo" )

      return
    end

    if ( wep:GetClass() == "weapon_scp_973" ) then

      if ( SERVER ) then

        self.Owner:GetWeapon( "cw_kk_scp_973_pistol" ):Remove()

      end

      timer.Remove( "SCP_973_CheckAmmo" )

      return
    end

    local primary_swep = self.Owner:GetWeapon( "weapon_scp_973" )

    if ( SERVER ) then

      if ( primary_swep.Target_Rage != primary_swep:GetRage() ) then

        if ( rage == 0 ) then

          rage = primary_swep:GetRage()

        end

        rage = math.Approach( rage, primary_swep.Target_Rage, FrameTime() * 12 )

        primary_swep:SetRage( rage )

      end

    end

    if ( CLIENT ) then

      if ( !primary_swep.GetRage ) then return end

      if ( primary_swep:GetRage() >= 25 && primary_swep.AbilityIcons[ 1 ].Forbidden ) then

        primary_swep.AbilityIcons[ 1 ].Forbidden = false

      elseif ( primary_swep:GetRage() < 25 && !primary_swep.AbilityIcons[ 1 ].Forbidden ) then

        primary_swep.AbilityIcons[ 1 ].Forbidden = true

      elseif ( primary_swep:GetRage() >= 75 && primary_swep.AbilityIcons[ 2 ].Forbidden ) then

        primary_swep.AbilityIcons[ 2 ].Forbidden = false

      elseif ( primary_swep:GetRage() < 75 && !primary_swep.AbilityIcons[ 2 ].Forbidden ) then

        primary_swep.AbilityIcons[ 2 ].Forbidden = true

      end

    end

    local wep_ammo = wep:Clip1()

    if ( wep_ammo == 0 ) then

      self.Owner:SelectWeapon( "weapon_scp_973" )

    end

  end )

end

function SWEP:Reload()

  if ( self:GetRage() < 75 ) then return end
  if ( !IsFirstTimePredicted() ) then return end

  self.Target_Rage = self.Target_Rage - 75

  self:Deploy_Shotgun()

  if ( SERVER ) then

    self:VoiceLine( "nextoren/scp/973/shotgun_" .. math.random( 1, 2 ) .. ".ogg" )

  end

end

local w = 64
local h = 64
local padding = 133

local RageIcon = Material( "nextoren/gui/special_abilities/scp_973_rage.png", "smooth" )

local function DrawHUD()

  local client = LocalPlayer()

  if ( !client:HasWeapon( "weapon_scp_973" ) ) then

    hook.Remove( "HUDPaint", "SCP_973_HUD" )

    return
  end

	local percent = client:GetWeapon( "weapon_scp_973" ):GetRage() / 100
	local actualpercent = math.Round( percent * 100 )
	local percentclr = Color( 200, 200, 200, 255 )

	local y = ScrH() * .8
	local color = color_white

	if ( actualpercent >= 25 && actualpercent < 40 ) then

		percentclr = Color( 200, 220, 0, 255 )

	elseif ( actualpercent >= 40 ) then

		percentclr = Color( 255, 0, 0, 255 )

	end

	if ( actualpercent >= 50 ) then

		color = Color( Pulsate( 2 ) * 180, 0, 0, 255 )

	end

	render.SetMaterial( RageIcon )
	render.DrawQuadEasy( Vector( ScrW() / 2, y ),

		Vector( 0, 0, -1 ),
		w, h,
		Color( 10, 10, 40, 240 ),
		-90

	)

	render.SetScissorRect( ScrW() / 2 + 30, y + h / 2 - ( h * percent ), padding + w, ScrH(), true )
	render.SetMaterial( RageIcon )
	render.DrawQuadEasy( Vector( ScrW() / 2, y),

		Vector( 0, 0, -1 ),
		w, h,
		color,
		-90

	)
	render.SetScissorRect( 0, y + h / 2, padding + w, ScrH(), false )


	if ( actualpercent < 100 ) then

		--draw.SimpleText( actualpercent, "char_title24", ScrW() / 2, y, percentclr, 1, 1, .5, Color( 0, 0, 0, 255 ) )
		draw.SimpleText( actualpercent, "char_title24", ScrW() / 2, y, percentclr, 1, 1 )

    if ( actualpercent >= 50 ) then

      draw.SimpleText( "T", "char_title20", ScrW() / 2, y - 16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    end

  else

    draw.SimpleText( "T", "char_title24", ScrW() / 2, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

end

local rage = 0

function SWEP:Deploy()

  self.Deployed = true
  self.IdleDelay = CurTime() + 1
  self:PlaySequence( "deploy" )

  rage = 0

  if ( SERVER ) then

    self:EmitSound( "nextoren/scp/973/weapon/drawn.wav", 85, 100, 1, CHAN_WEAPON )

    --[[timer.Simple( 1.25, function()

      if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

        self.Owner:SendLua( 'LocalPlayer():GetActiveWeapon():Deploy()' )

      end

    end )]]

  end

  hook.Add( "PlayerButtonDown", "RageButton", function( player, butt )

    if ( player:GetRoleName() == "SCP973" ) then

      local wep = player:GetActiveWeapon()

      if ( wep != NULL && wep:GetClass() == "weapon_scp_973" && wep:GetRage() >= 50 && butt == KEY_T ) then

        wep:Deploy_Rage()

      elseif ( wep != NULL && wep:GetClass() == "weapon_scp_973" && wep:GetRage() >= 50 && butt == KEY_G ) then

        wep.Target_Rage = wep.Target_Rage - 50

        wep:Deploy_Revolver()

      end

    end

  end )

  if ( CLIENT ) then

    hook.Add( "HUDPaint", "SCP_973_HUD", DrawHUD )

  end

end

SWEP.NextPrimaryAttack = 0

local prim_mins, prim_maxs = Vector( -20, -10, -32 ), Vector( 20, 10, 32 )

function SWEP:PrimaryAttack()

  if ( self.NextPrimaryAttack > CurTime() ) then return end
  self.NextPrimaryAttack = CurTime() + 1.2

  self.Owner:MeleeViewPunch( 5 )

  self.Owner:SetAnimation( PLAYER_ATTACK1 )

  self.IdleDelay = CurTime() + .7
  self:PlaySequence( "attack_0" .. math.random( 1, 3 ) )

  self:EmitSound( "nextoren/scp/973/weapon/swingn" .. math.random( 1, 4 ) .. ".wav", 85, math.random( 80, 100 ), 1, CHAN_WEAPON )
  self:EmitSound( "nextoren/scp/973/weapon/chargeswing" .. math.random( 1, 2 ) .. ".wav", 85, math.random( 80, 100 ), 1, CHAN_WEAPON )

  self.Owner:LagCompensation( true )

  local tr = {

    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 130,
    filter = { self, self.Owner },
    mins = prim_mins,
    maxs = prim_maxs

  }

  local trace = util.TraceHull( tr )

  self.Owner:LagCompensation( false )

  local ent = trace.Entity

  if ( ent && ent:IsValid() && ent:IsPlayer() && ent:GTeam() != TEAM_SCP ) then

    if ( SERVER ) then

      local damage_info = DamageInfo()
      damage_info:SetDamage( ent:GetMaxHealth() * .4 )
      damage_info:SetDamageForce( ent:GetAimVector() * 48 )
      damage_info:SetInflictor( self )
      damage_info:SetDamageType( DMG_SLASH )
      damage_info:SetAttacker( self.Owner )

      if ( ent:Health() - damage_info:GetDamage() <= 0 ) then

        self:VoiceLine( "nextoren/scp/973/kill_" .. math.random( 1, 4 ) .. ".ogg" )

      else

        if ( math.random( 1, 4 ) > 2 ) then

          self:VoiceLine( "nextoren/scp/973/lauth_" .. math.random( 1, 2 ) .. ".ogg" )

        end

      end

      sound.Play( "nextoren/scp/973/weapon/nhit" .. math.random( 1, 8 ) .. ".wav", trace.HitPos, 85, math.random( 80, 100 ), 1 )

      ent:TakeDamageInfo( damage_info )

      self.Target_Rage = math.Clamp( self.Target_Rage + 20, 0, 100 )

    end

    local effectData = EffectData()
    effectData:SetOrigin( trace.HitPos )
    effectData:SetEntity( ent )

    util.Effect( "BloodImpact", effectData )

    ent:MeleeViewPunch( 40 )

  end

end

SWEP.NextSecondaryAttack = 0

function SWEP:SecondaryAttack()

  if ( self:GetRage() < 25 ) then return end

  local tr = {

    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
    filter = { self, self.Owner },
    mins = Vector( -32, -32, -32 ),
    maxs = Vector( 32, 32, 32 )

  }

  local trace = util.TraceHull( tr )

  local ent = trace.Entity

  if ( !( ent:IsPlayer() && ent:GTeam() != TEAM_SCP ) ) then return end

  if ( self.NextSecondaryAttack > CurTime() ) then return end
  self.NextSecondaryAttack = CurTime() + 4

  self.IdleDelay = CurTime() + .5
  self:PlaySequence( "seconary_attack" )

  self.Target_Rage = self.Target_Rage - 25
  if SERVER then
  self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, self.Owner:LookupSequence( "0_973_attack_stun_gesture" ), 0, true )
  BroadcastLua("Entity("..self.Owner:EntIndex().."):AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, Entity("..self.Owner:EntIndex().."):LookupSequence( \"0_973_attack_stun_gesture\" ), 0, true )") end

  if ( SERVER ) then

    ent:Freeze( true )

    ent:SetForcedAnimation( "0_SCP_542_lifedrain", 3.25, nil, function()

      ent:Freeze( false )

    end )

    self.tazersound:Play()

    timer.Simple( .25, function()

      self.tazersound:Stop()

    end )

    local zap = ents.Create("point_tesla")
    zap:SetKeyValue("targetname","teslab")
    zap:SetKeyValue("m_SoundName","")
    zap:SetKeyValue("texture","sprites/physbeam.spr")
    zap:SetKeyValue("m_Color","210 200 255")
    zap:SetKeyValue("m_flRadius","15")
    zap:SetKeyValue("beamcount_min","1")
    zap:SetKeyValue("beamcount_max","2")
    zap:SetKeyValue("thick_min",".1")
    zap:SetKeyValue("thick_max",".2")
    zap:SetKeyValue("lifetime_min",".01")
    zap:SetKeyValue("lifetime_max",".35")
    zap:SetKeyValue("interval_min",".01")
    zap:SetKeyValue("interval_max",".05")
    zap:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 + self.Owner:GetRight() * 5 - self.Owner:GetUp() * 4 )
    zap:Spawn()
    zap:Fire("DoSpark","",0)
    zap:Fire("kill","",.1)

  end

  ParticleEffect( "electrical_arc_01_cp0", self.Owner:GetShootPos() + self.Owner:GetAimVector() * 40 + self.Owner:GetRight() * 5 - self.Owner:GetUp() * 4, ent:GetAngles(), ent )

end

function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
    self.WModel:SetNoDraw( true )

  end

  return self.WModel

end

SWEP.NextVoiceLine = 0

local friendly_teams = {

  [ TEAM_SPEC ] = true,
  [ TEAM_SCP ] = true,
  [ TEAM_DZ ] = true

}

function SWEP:Think()

  if ( SERVER ) then

    if ( self.Target_Rage != self:GetRage() ) then

      if ( rage == 0 ) then

        rage = self:GetRage()

      end

      rage = math.Approach( rage, self.Target_Rage, FrameTime() * 12 )

      self:SetRage( rage )

    end

  end

  local rage_value = self:GetRage()

  if ( CLIENT && rage_value >= 50 && !self.Tip_Sended ) then

    self.Tip_Sended = true

    BREACH.Player:ChatPrint( true, true, "l:scp973_frenzy" )

  end

  if ( rage_value >= 25 && self.AbilityIcons[ 1 ].Forbidden ) then

    self.AbilityIcons[ 1 ].Forbidden = false

  elseif ( rage_value < 25 && !self.AbilityIcons[ 1 ].Forbidden ) then

    self.AbilityIcons[ 1 ].Forbidden = true

  elseif ( rage_value >= 75 && self.AbilityIcons[ 2 ].Forbidden ) then

    self.AbilityIcons[ 2 ].Forbidden = false

  elseif ( rage_value < 75 && !self.AbilityIcons[ 2 ].Forbidden ) then

    self.AbilityIcons[ 2 ].Forbidden = true

  end

  if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

  if ( self.NextVoiceLine < CurTime() ) then

		local entities = ents.FindInSphere( self.Owner:GetPos(), 400 )

		for _, v in ipairs( entities ) do

			if ( v:IsPlayer() && !friendly_teams[ v:GTeam() ] && self.Owner:CanSee( v ) && !v:GetNoDraw() ) then

				if ( self.NextVoiceLine < CurTime() ) then

					self.NextVoiceLine = CurTime() + 60

					if ( SERVER ) then

						self:VoiceLine( "nextoren/scp/973/spotted_" .. math.random( 1, 6 ) .. ".ogg" )

					end

				end

			end

		end

	end

end

function SWEP:DrawHUDBackground()

  if ( !self.Deployed ) then

    self:Deploy()

  end

end

function SWEP:DrawWorldModel()

  local pl = self:GetOwner()

  if ( pl && pl:IsValid() ) then

    local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )

    if ( !bone ) then return end
    local pos, ang = self.Owner:GetBonePosition( bone )

    local wm = self:CreateWorldModel()

    if ( wm && wm:IsValid() ) then

      ang:RotateAroundAxis( ang:Right(), self.Ang.p )
      ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
      ang:RotateAroundAxis( ang:Up(), self.Ang.r )
      wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
      wm:SetRenderAngles( ang )
      wm:DrawModel()

    end

  else

    self:SetRenderOrigin( nil )
    self:SetRenderAngles( nil )
    self:DrawModel()

  end

end
