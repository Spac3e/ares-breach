
SWEP.AbilityIcons = {

	{

		["Name"] = "Armor",
		["Description"] = "None provided",
		["Cooldown"] = 100,
		["CooldownTime"] = 0,
		["KEY"] = _G[ "KEY_1" ],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_682_regen.png"


	},
	{

		["Name"] = "Speed up",
		["Description"] = "None provided",
		["Cooldown"] = 180,
		["CooldownTime"] = 0,
		["KEY"] = _G[ "KEY_2" ],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_682_speedup.png"

	},
	{

		["Name"] = "Regeneration",
		["Description"] = "None provided",
		["Cooldown"] = 80,
		["CooldownTime"] = 0,
		["KEY"] = _G[ "KEY_3" ],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_682_armor.png"


	},
	{

		["Name"] = "Sonic Scream",
		["Description"] = "None provided",
		["Cooldown"] = 55,
		["CooldownTime"] = 0,
		["KEY"] = _G[ "KEY_4" ],
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_682_roar.png"

	}

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-682"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "scp682"
SWEP.Base = "breach_scp_base"

SWEP.maxs = Vector( 8, 10, 5 )
SWEP.droppable		= false

SWEP.Phase = 0

function SWEP:VoiceLine( s_sound )

  if ( self.Voice_Line && self.Voice_Line:IsPlaying() ) then

    self.Voice_Line:Stop()

  end

  self.Voice_Line = CreateSound( self.Owner, s_sound )
	self.Voice_Line:ChangePitch( math.random( 60, 100 ), 0 )
	self.Voice_Line:SetSoundLevel( 140 )
  self.Voice_Line:SetDSP( 17 )
  self.Voice_Line:Play()

end

local function Special1( player )

	if ( CLIENT ) then

		local wep = player:GetActiveWeapon()
		wep.UsingSpecialAbility = true
		wep.SpecialIcon = Material( wep.AbilityIcons[ 1 ].Icon )
		wep.n_SpecialAbilityTime = 15
		wep.n_SpecialAbilityEndTime = CurTime() + 15

		return
	end

	player.AdditionalScaleDamage = .3

	timer.Simple( 15, function()

		if ( player && player:IsValid() ) then

			player.AdditionalScaleDamage = nil

		end

	end )

end

local function Special2( player )

	if ( CLIENT ) then

		local wep = player:GetActiveWeapon()
		wep.UsingSpecialAbility = true
		wep.SpecialIcon = Material( wep.AbilityIcons[ 2 ].Icon )
		wep.n_SpecialAbilityTime = 7
		wep.n_SpecialAbilityEndTime = CurTime() + 7

		return
	end

	player:SetWalkSpeed( player:GetWalkSpeed() * 3 )
	player:SetRunSpeed( player:GetRunSpeed() * 3 )
	player:SetCrouchedWalkSpeed( player:GetCrouchedWalkSpeed() * 3 )
	player:SetCustomCollisionCheck( true )

	timer.Simple( 7, function()

		if ( player && player:IsValid() && player:GetRoleName() == "SCP682" && player:GetActiveWeapon():GetClass() == "weapon_scp_682" ) then

			player:SetCustomCollisionCheck( false )
			player:SetWalkSpeed( 100 )
			player:SetRunSpeed( 100 )
			player:SetCrouchedWalkSpeed( 100 )
			player:Freeze( true )

			timer.Simple( .25, function()

				if ( player && player:IsValid() ) then

					player:Freeze( false )

				end

			end )

		end

	end )

end

local function Special3( player )

	if ( CLIENT ) then return end

	if ( player:Health() != player:GetMaxHealth() ) then

		local amount_to_restore = player:GetMaxHealth() * .2
		local health = 0

		local unique_id = "SCP682_Regeneration" .. player:SteamID64()

		timer.Create( unique_id, 0, 0, function()

			if ( amount_to_restore > 0 && player:Health() != player:GetMaxHealth() && player:Health() > 0 && player:GetActiveWeapon() != NULL && player:GetActiveWeapon():GetClass() == "weapon_scp_682" ) then

				health = math.Approach( player:Health(), player:Health() + 1, FrameTime() * 128 )
				player:SetHealth( health )
				amount_to_restore = amount_to_restore - 1

			else

				timer.Remove( unique_id )

			end

		end )

	end

end

local clr_gray = Color( 198, 198, 198, 60 )

local function Special4( player )

	if ( CLIENT ) then return end

	player:Freeze( true )

	player:SetForcedAnimation( "0_EmoteRoar_40", 3, nil, function()

		player:Freeze( false )

	end )

	net.Start( "ThirdPersonCutscene" )

		net.WriteUInt( 3, 4 )

	net.Send( player )

	timer.Simple( 1.75, function()

		player:GetActiveWeapon():VoiceLine( "nextoren/scp/682/scp_682_stunscream_1.ogg" )

		for _, v in ipairs( ents.FindInSphere( player:GetPos(), 650 ) ) do

			if ( v:IsPlayer() && v != player && !( v:GTeam() == TEAM_SPEC || v:GTeam() == TEAM_SCP ) ) then

				v:SetNWInt( "Custom_Sensitivity", .2 )

				v:ScreenFade( SCREENFADE.OUT, clr_gray, .2, 8 )
				v:ScreenFade( SCREENFADE.IN, ColorAlpha( color_white, 40 ), 7.9, .2 )
				v:ScreenFade( SCREENFADE.OUT, ColorAlpha( color_white, 30 ), 8.1, 2 )

				net.Start( "ForcePlaySound" )

					net.WriteString( "nextoren/others/player_breathing_knockout01.wav" )

				net.Send( v )

				v:SetDSP( 15, true )

				timer.Simple( 11, function()

					if ( v && v:IsValid() ) then

						v:SetDSP( 0, true )

					end

				end )

				timer.Simple( 15, function()

					if ( v && v:IsValid() ) then

						v:SetNWInt( "Custom_Sensitivity", -1 )

					end

				end )

			end

		end

	end )

end

local Button_table = {

	[ KEY_1 ] = function( player ) Special1( player ) end,
	[ KEY_2 ] = function( player ) Special2( player ) end,
	[ KEY_3 ] = function( player ) Special3( player ) end,
	[ KEY_4 ] = function( player ) Special4( player ) end

}

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()

	self.Deployed = true

	if SERVER then
		self.Owner:SetWalkSpeed( 100 )
		self.Owner:SetRunSpeed( 100 )
		self.Owner:SetCrouchedWalkSpeed( 100 )
	end

	self.Owner:DrawViewModel( false )

	if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

	end

	hook.Add( "PlayerButtonDown", "SCP_682_SpecialAbilities", function( ply, butt )

		if ( ply:GetRoleName() != "SCP682" ) then return end

		if ( Button_table[ butt ] ) then

			local wep = ply:GetActiveWeapon()

			if ( ( wep.AbilityIcons[ butt - 1 ].CooldownTime || 0 ) > CurTime() ) then return end

			for i = 1, #wep.AbilityIcons do

				if ( ( wep.AbilityIcons[ i ].CooldownTime || 0 ) < CurTime() ) then

					wep.AbilityIcons[ i ].CooldownTime = CurTime() + tonumber( wep.AbilityIcons[ butt - 1 ].Cooldown ) / 2

				end

			end

			wep.AbilityIcons[ butt - 1 ].CooldownTime = CurTime() + tonumber( wep.AbilityIcons[ butt - 1 ].Cooldown )

			Button_table[ butt ]( ply )

		end

	end )

end

local BannedDoors = {

	[ 2142 ] = true,
	[ 2141 ] = true,
	[ 4394 ] = true

}

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 1.6 )

  local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 165
	trace.filter = self.Owner
	trace.mins = -self.maxs
	trace.maxs = self.maxs

	trace = util.TraceHull( trace )

  local target = trace.Entity
  if ( CLIENT ) then

    if ( target && target:IsValid() && target:IsPlayer() && target:GTeam() != TEAM_SCP ) then

      local effectData = EffectData()
      effectData:SetOrigin( trace.HitPos )
      effectData:SetEntity( target )

      util.Effect( "BloodImpact", effectData )

    end

    return
  end

	if ( target && target:IsValid() && target:GetClass() == "prop_dynamic" ) then

		local door = target:GetParent()

		if ( door && door:IsValid() && door:GetClass() == "func_door" && !door.OpenedBySCP096 && !preparing && !BannedDoors[ door:MapCreationID() ] && SCPLockDownHasStarted == true && !door:GetInternalVariable( "noise2" ):find( "elevator" ) && !door:GetInternalVariable( "parentname" ):find( "914_door" ) && !door:GetInternalVariable( "m_iName" ):find( "gate" ) ) then

			door.OpenedBySCP096 = true
			self:VoiceLine( "nextoren/scp/682/attack_" .. math.random( 1, 3 ) .. ".ogg" )
			door:EmitSound( "npc/antlion/shell_impact4.wav" )
			door:EmitSound( "nextoren/scp/096/metal_break3.wav" )
			door:Fire( "Unlock" )
			door:Fire( "Open" )

			timer.Simple( 6, function()

				door.OpenedBySCP096 = false

			end )

			return
		end

	end

  if ( target && target:IsValid() && target:IsPlayer() && target:Health() > 0 && target:GTeam() != TEAM_SCP ) then

    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    self.dmginfo = DamageInfo()
    self.dmginfo:SetDamageType( DMG_SLASH )
    self.dmginfo:SetDamage( math.random( 300, 350 ) )
    self.dmginfo:SetDamageForce( target:GetAimVector() * 120 )
    self.dmginfo:SetInflictor( self )
    self.dmginfo:SetAttacker( self.Owner )

		self:VoiceLine( "nextoren/scp/682/attack_" .. math.random( 1, 3 ) .. ".ogg" )
    target:EmitSound( "npc/antlion/shell_impact4.wav" )
    self.Owner:MeleeViewPunch( self.dmginfo:GetDamage() )


    target:MeleeViewPunch( self.dmginfo:GetDamage() )
    target:TakeDamageInfo( self.dmginfo )

  else

    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self:VoiceLine( "nextoren/scp/682/attack_" .. math.random( 1, 3 ) .. ".ogg" )
    self.Owner:ViewPunch( AngleRand( 10, 2, 10 ) )

  end

end

if ( SERVER ) then

	function SWEP:Think()

		if ( self.Owner:Health() <= 0 ) then return end

		if ( self.Owner:GetRunSpeed() != 100 ) then

			for _, v in ipairs( ents.FindInSphere( self.Owner:GetPos(), 60 ) ) do

				if ( !preparing && SCPLockDownHasStarted == true && v:GetClass() == "func_door" && !v.OpenedBySCP096 && self.Owner:GetVelocity():Length2DSqr() > .25 && !BannedDoors[ v:MapCreationID() ] ) then

					v.OpenedBySCP096 = true
					v:EmitSound( "nextoren/scp/096/metal_break3.wav" )
					v:Fire( "Unlock" )
					v:Fire( "Open" )
					v:Fire( "Lock" )
					timer.Simple( 6, function()

						v:Fire( "Unlock" )
						v.OpenedBySCP096 = false

					end )

				end

			end

		end

	end

else

	local icon_clr = Color( 10, 10, 40, 240 )

	function SWEP:DrawHUDBackground()

		if ( !self.Deployed ) then

			self:Deploy()

		end

		if ( self.UsingSpecialAbility ) then

			local w = 64
			local h = 64
			local padding = 133

			local screenheight = ScrH()

			local y = screenheight - 240

			local clr = color_white
			local percent = ( self.n_SpecialAbilityEndTime - CurTime() ) / self.n_SpecialAbilityTime

			local actualpercent = math.Round( percent * 100 )

			if ( actualpercent < 0 ) then

				self.UsingSpecialAbility = nil

			end

			local screenwidth_one_half = ScrW() / 2
			local quad_pos = Vector( screenwidth_one_half, y )

			render.SetMaterial( self.SpecialIcon )
			render.DrawQuadEasy( quad_pos,

				-vector_up,
				w, h,
				icon_clr,
				-90

			)

			render.SetScissorRect( screenwidth_one_half + 30, y + 32 - ( h * percent ), padding + w, screenheight, true )

			render.DrawQuadEasy( quad_pos,

				-vector_up,
				w, h,
				clr,
				-90

			)
			render.SetScissorRect( 0, y + 32, padding + w, screenheight, false )

		end

	end

end

function SWEP:OnRemove()

  local players = player.GetAll()

  for i = 1, #players do

    local player = players[ i ]

    if ( player && player:IsValid() && player:GetRoleName() == "SCP682" ) then return end

  end

  hook.Remove( "PlayerButtonDown", "SCP_682_SpecialAbilities" )

end

function SWEP:CanSecondaryAttack() return false end
