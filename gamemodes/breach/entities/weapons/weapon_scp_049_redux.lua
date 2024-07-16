if ( CLIENT ) then

	net.Receive( "SCP049_PlayerScreenManipulations", function()

		--[[
		local n_type = net.ReadUInt( 2 )
		local b_activate = net.ReadBool()

		local client = LocalPlayer()

		if ( n_type == 1 ) then

			client:BlurScreen( b_activate )

		elseif ( n_type == 2 ) then

			client:BlurScreen( b_activate )
			client.BlackScreen = b_activate

		else

			client.BlackScreen = b_activate

		end]]

	end )

end

if ( SERVER ) then

	util.AddNetworkString( "SCP049_PlayerScreenManipulations" )

end

if CLIENT then
	CreateMaterial( "ZombieTexture", "VertexLitGeneric", {
		["$basetexture"] = "models/cultist/heads/zombie_face",
		["$model"] = 1,
		["&nocull"] = 1,
		["$phong"] = 1,
		["$phongboost"] = 0.5,
		["$lightwarptexture"] = "models/all_scp_models/shared/Clothes_wrp",
		["$phongexponenttexture"] = "models/all_scp_models/shared/exp",
	  } )  
end

SWEP.AbilityIcons = {

	{

		["Name"] = "Zombie Buff",
		["Description"] = "Using this ability gives all zombies extra power.",
		["Cooldown"] = "100",
		["CooldownTime"] = 0,
		["KEY"] = "RMB",
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_049_zombiebuff.png",
		["Abillity"] = nil

	},

}

SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-049"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.HoldType = "scp049"
SWEP.Base = "breach_scp_base"
SWEP.AlertWindow = false
SWEP.AbillityID = 0
SWEP.mins = Vector( -8, -10, -5 )
SWEP.maxs = Vector( 8, 10, 5 )

SWEP.droppable = false
SWEP.Primary.Delay = 3

SWEP.Secondary.Delay = 6
  
SWEP.Outline_Color = Color( 0, 180, 0, 190 )

SWEP.Speed = 100


function SWEP:Deploy()

	self.Owner:DrawViewModel( false )

	if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

		timer.Simple( .25, function()

			if ( ( self && self:IsValid() ) && ( self.Owner && self.Owner:IsValid() ) ) then

				self.Speed = self.Owner:GetWalkSpeed()

			end

		end )

	end

	if SERVER then

		hook.Add("PlayerButtonDown", "SCP_049_CONTROLS", function(ply, butt)
			if ply:GetRoleName() != "SCP049" then return end

			local rag = ply:GetEyeTrace().Entity

			if !( IsValid(rag) and rag:GetPos():DistToSqr(ply:GetPos()) <= 20000 and rag:GetClass() == "prop_ragdoll" and rag.SCP049Victim ) then return end

			if butt == KEY_E then
				local victim = rag.SCP049User
				ply:BrProgressBar("l:creating_zombie", 5, "nextoren/gui/icons/notifications/breachiconfortips.png", rag, false, function()
					if IsValid(rag.SCP049User) and rag.SCP049User:GTeam() == TEAM_SPEC then return end
					if IsValid(rag.SCP049User) and rag.SCP049User:IsPlayer() then
						local victim = rag.SCP049User
						if !timer.Exists("Death_SCP049_"..victim:SteamID64()) then
							ply:AresNotify("l:scp049_too_late")
							return
						end
						ply:AddToAchievementPoint("scp049", 1)
						rag:Remove()
						timer.Remove("Death_SCP049_"..victim:SteamID64())
						victim:SetNoDraw(false)
						victim:SetDSP(1)
						victim:SetNWEntity("NTF1Entity", victim)
						victim:SetGTeam(TEAM_SCP)
						victim.IsZombie = true
						victim.ScaleDamage = {
							 ["HITGROUP_HEAD"] = .35,
							 ["HITGROUP_CHEST"] = .35,
							 ["HITGROUP_LEFTARM"] = .35,
							 ["HITGROUP_RIGHTARM"] = .35,
							 ["HITGROUP_STOMACH"] = .35,
							 ["HITGROUP_GEAR"] = .35,
							 ["HITGROUP_LEFTLEG"] = .35,
							 ["HITGROUP_RIGHTLEG"] = .35
						}
						victim.Stamina = 100
						victim:SetMaxHealth(victim:GetMaxHealth() * 2)
						victim:SetHealth(victim:GetMaxHealth())
						victim:MakeZombie()
						victim:BreachGive("weapon_scp_049_2")
						victim:CompleteAchievement("scp0492")
						timer.Create("Safe_WEAPON_SELECT_"..victim:SteamID64(), FrameTime(), 99999, function()
							if !IsValid(victim:GetActiveWeapon()) or victim:GetActiveWeapon():GetClass() != "weapon_scp_049_2" then
								victim:SelectWeapon("weapon_scp_049_2")
							else
								timer.Remove("Safe_WEAPON_SELECT_"..victim:SteamID64())
							end
						end)
						victim:SetForcedAnimation("breach_zombie_getup", victim:SequenceDuration(victim:LookupSequence("breach_zombie_getup")), nil, function()
							victim:SetMoveType(MOVETYPE_WALK)
							victim:Freeze(false)
							victim:SetNotSolid(false)
							victim:SetNWEntity("NTF1Entity", NULL)
						end)
					end
				end)
			elseif butt == KEY_R then
				local victim = rag.SCP049User
				if !IsValid(victim) or !timer.Exists("Death_SCP049_"..victim:SteamID64()) then return end
				ply:BrProgressBar("l:drinking_blood", 4.5, "nextoren/gui/icons/notifications/breachiconfortips.png", rag, false, function()
					if IsValid(rag.SCP049User) and rag.SCP049User:IsPlayer() then
						local victim = rag.SCP049User
						ply:AnimatedHeal(math.random(150,200))
						timer.Remove("Death_SCP049_"..victim:SteamID64())
						victim:LevelBar()
						victim:SetupNormal()
						victim:SetSpectator()
					end
				end)
			end
		end)

	end

	if ( CLIENT ) then

		hook.Add( "PreDrawOutlines", "SCP049_BodyOutline", function()

			local client = LocalPlayer()

			if ( client:GTeam() != TEAM_SCP || client:Health() <= 0 || client:GetRoleName() != "SCP049" ) then

				hook.Remove( "PreDrawOutlines", "SCP049_BodyOutline" )
				return
			end

			local radius_entites = ents.FindInSphere( client:GetPos(), 200 )

			local to_draw = {}

			for i = 1, #radius_entites do

				local ent = radius_entites[ i ]

				if ( ent:GetClass() == "prop_ragdoll" && ent:GetIsVictimAlive() ) then

					to_draw[ #to_draw + 1 ] = ent

				end

			end

			outline.Add( to_draw, self.Outline_Color, OUTLINE_MODE_VISIBLE )

		end )

	end

  self:SetHoldType( self.HoldType )

end

local vec_zero = vector_origin

function SWEP:VictimOverlay( target )

	target:SetNWEntity( "NTF1Entity", NULL )
	self.Owner:SetNWEntity( "NTF1Entity", NULL )

	for _, v in pairs( ents.FindInSphere( target:GetPos(), 40 ) ) do

		if ( v:GetClass() == "prop_ragdoll" && v:GetVictimHealth() ) then

			target:SetNWEntity( "NTF1Entity", v )

			if ( SERVER ) then

				net.Start( "SCP049_PlayerScreenManipulations" )

					net.WriteUInt( 0, 2 )
					net.WriteBool( true )

				net.Send( target )

				if ( target:IsFemale() ) then

					net.Start( "ForcePlaySound" )

						net.WriteString( "nextoren/charactersounds/breathing/breathing_female.wav" )

					net.Send( target )

				else

					net.Start( "ForcePlaySound" )

						net.WriteString( "nextoren/others/player_breathing_knockout01.wav" )

					net.Send( target )

				end

			end

		end

	end

end

function SWEP:GrabVictim( victim )

	self.GesturePlaying = nil
	self.Owner:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )

	if ( CLIENT ) then return end

	local activeweapon = victim:GetActiveWeapon()

	if ( activeweapon != NULL ) then

  	activeweapon:SetNoDraw( true )

	end

	victim:SetMoveType( MOVETYPE_OBSERVER )
	self.Owner:SetMoveType( MOVETYPE_OBSERVER )

	local uniqueID = "GetBothStatus" .. self.Owner:EntIndex()

	timer.Create( uniqueID, 0, 0, function()

		if ( !( victim && victim:IsValid() ) || victim:Health() <= 0 ) then

			self.Owner:StopForcedAnimation()
			self.Owner:Freeze( false )
			self.Owner:SetMoveType( MOVETYPE_WALK )
			self.Owner:SetNWAngle( "ViewAngles", angle_zero )
			self.Owner:SetNWEntity( "NTF1Entity", NULL )

			victim:StopForcedAnimation()
			victim:Freeze( false )
			victim:SetDSP( 1 )

			net.Start( "SCP049_PlayerScreenManipulations" )

				net.WriteUInt( 2, 2 )
				net.WriteBool( false )

			net.Send( victim )

			victim:SetNWAngle( "ViewAngles", angle_zero )
			victim:SetNWEntity( "NTF1Entity", NULL )

			timer.Remove( uniqueID )

			return
		end

		if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) || self.Owner:Health() <= 0 ) then

			if ( victim && victim:IsValid() ) then

				victim:StopForcedAnimation()
				victim:Freeze( false )
				victim:SetNWEntity( "NTF1Entity", NULL )
				victim:SetDSP( 1 )
				victim:SetNWAngle( "ViewAngles", angle_zero )

				net.Start( "SCP049_PlayerScreenManipulations" )

					net.WriteUInt( 2, 2 )
					net.WriteBool( false )

				net.Send( victim )

			end

			self.Owner:StopForcedAnimation()
			self.Owner:Freeze( false )
			self.Owner:SetMoveType( MOVETYPE_WALK )
			self.Owner:SetNWAngle( "ViewAngles", angle_zero )
			self.Owner:SetNWEntity( "NTF1Entity", NULL )

			timer.Remove( uniqueID )

			return
		end

	end )

	victim:Freeze( true )
	self.Owner:Freeze( true )

	victim:SetNWEntity( "NTF1Entity", victim )
	self.Owner:SetNWEntity( "NTF1Entity", self.Owner )

	self.Owner:SetForcedAnimation( "0_049_struggle_start", 1.3, nil, function()

		self.Owner:GodEnable()

		self.Owner:SetForcedAnimation( "0_049_struggle_loop", 4, nil, function()

			self.Owner:SetForcedAnimation( "0_049_struggle_end", 1.5, nil, function()

				self.Owner:GodDisable()

				self.Owner:SetNWAngle( "ViewAngles", angle_zero )
				victim:SetNWAngle( "ViewAngles", angle_zero )

				self.Owner:SetMoveType( MOVETYPE_WALK )
				self.Owner:Freeze( false )

				timer.Remove( uniqueID )

			end )

		end )

	end )

	victim:SetForcedAnimation( "0_049_victum_struggle_start", 1.3, nil, function()

		victim:GodEnable()

		victim:SetDSP( 16 )
		net.Start( "SCP049_PlayerScreenManipulations" )

			net.WriteUInt( 1, 2 )
			net.WriteBool( true )

		net.Send( victim )

		victim:SetForcedAnimation( "0_049_victum_struggle_loop", 4, nil, function()

			timer.Simple( victim:SequenceDuration( 5443 ) - .1, function()

				victim.AffectedBy049 = true
				victim:SetNoDraw( true )
				victim:SetNotSolid( true )
				victim:DrawWorldModel( false )

				local FIX = DamageInfo()
				FIX:SetInflictor(self)
				FIX:SetAttacker(self.Owner)
				FIX:SetDamage(100)
				FIX:SetDamageType(DMG_SLASH)

				local body = CreateLootBox( victim, self, self.Owner, false, FIX )

				victim:GodDisable()

				victim:SetSpecialMax(0)
				victim:SetNWString("AbilityName", "")
				victim.AbilityTAB = nil
				victim:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")

				--[[
				local uid = "SETUP_CAMERA_GUY_"..victim:SteamID64()
				timer.Create(uid, FrameTime(), 9999, function()
					if victim:GetNWEntity("NTF1Entity") != body and victim.AffectedBy049 then]]
				victim:SetNWEntity("NTF1Entity", body)
						--[[
					end
				end)]]


				local savename = victim:GetNamesurvivor()

				timer.Create("Death_SCP049_"..victim:SteamID64(), 50, 1, function()
					if victim:GetNamesurvivor() == savename then
						victim:LevelBar()
						victim:SetupNormal()
						victim:SetDSP( 1 )
						victim:SetSpectator()
						victim.AffectedBy049 = nil
						self.Owner:SetNWEntity("NTF1Entity", NULL)
						victim:AresNotify("l:scp049_time_out_pt1 ", gteams.GetColor(TEAM_SCP),"SCP-049",color_white," l:scp049_time_out_pt2")
						if IsValid(body) then body.SCP049Victim = false end
					end
				end)

				--self:VictimOverlay( victim )

			end )
			victim:SetForcedAnimation( "0_049_victum_struggle_end", 1.5, nil, function() end )

		end )

	end  )

	timer.Simple( .1, function()

		victim:SetNWAngle( "ViewAngles", ( victim:GetShootPos() - self.Owner:EyePos() ):Angle() )
		self.Owner:SetNWAngle( "ViewAngles", ( victim:GetShootPos() - self.Owner:EyePos() ):Angle() )

		local shoot_pos = self.Owner:GetShootPos()

		local vec_pos = shoot_pos + ( victim:GetShootPos() - self.Owner:EyePos() ):Angle():Forward() * 1.5

		vec_pos.z = GroundPos( vec_pos ).z

		victim:SetPos( vec_pos )

		timer.Simple( .25, function()

			if ( victim && victim:IsValid() && victim:Health() > 0 ) then

				victim:SetPos( vec_pos )

			end

		end )

	end )

end

if ( SERVER ) then

	function SWEP:PlayHandGesture( play )

		if ( !self.OldGestureBool ) then

			self.OldGestureBool = play

		end

		if ( self.OldGestureBool != play ) then

			local gesture_id = play && "0_049_hand_up_gesture" || "0_049_hand_down_gesture"

			net.Start( "GestureClientNetworking" )

				net.WriteEntity( self.Owner )
				net.WriteString( gesture_id, 13 )
				net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
				net.WriteBool( true )

			net.Broadcast()

			if ( play ) then

				timer.Simple( self.Owner:SequenceDuration( 5250 ) - .2, function()

					net.Start( "GestureClientNetworking" )

						net.WriteEntity( self.Owner )
						net.WriteString("0_049_hand_gesture")
						net.WriteUInt( GESTURE_SLOT_CUSTOM, 3 )
						net.WriteBool( false )

					net.Broadcast()

				end )

			end

			self.OldGestureBool = play

		end

	end

end

SWEP.NextVoiceLine = 0
SWEP.NextGestureCheck = 0

function SWEP:VoiceLine( s_sound )

  if ( self.Voice_Line && self.Voice_Line:IsPlaying() ) then

    self.Voice_Line:Stop()

  end

  self.Voice_Line = CreateSound( self.Owner, s_sound )
  self.Voice_Line:SetDSP( 17 )
  self.Voice_Line:Play()

end

if ( SERVER ) then

	local friendly_teams = {

		[ TEAM_SPEC ] = true,
		[ TEAM_DZ ] = true,
		[ TEAM_SCP ] = true

	}

	function SWEP:Think()

		if ( ( self.t_NextThink || 0 ) > CurTime() ) then return end
		self.t_NextThink = CurTime() + 1.5

		if self.Owner:GetMoveType() == MOVETYPE_WALK then
			self.Owner:SetNWEntity("NTF1Entity", NULL)
		end

		if ( self.Owner:GetMoveType() == MOVETYPE_OBSERVER ) then return end

		if ( self.NextVoiceLine < CurTime() || self.NextGestureCheck < CurTime() ) then

			local entities = ents.FindInSphere( self.Owner:GetPos(), 400 )
			local players = 0

			for _, v in ipairs( entities ) do

				if ( v:IsPlayer() && !friendly_teams[ v:GTeam() ] && self.Owner:IsLineOfSightClear( v ) && !v:GetNoDraw() ) then

					if ( self.NextVoiceLine < CurTime() ) then

						self.NextVoiceLine = CurTime() + 50
						self:VoiceLine( "nextoren/scp/049/spotted" .. math.random( 1, 7 ) .. ".ogg" )

					end

					players = players + 1

					self.Owner:SetWalkSpeed( self.Speed * 1.5 )
					self.Owner:SetRunSpeed( self.Speed * 1.5 )

				end

			end

			if ( self.NextGestureCheck <= CurTime() ) then

				if ( players <= 0 ) then

					self.Owner:SetWalkSpeed( self.Speed )
					self.Owner:SetRunSpeed( self.Speed )

				end

				self.NextGestureCheck = CurTime() + 8
				self:PlayHandGesture( players > 0 )

			end

		end

	end

end

local prim_maxs =  Vector( 12, 4, 32 )

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + .25 )

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 90
	trace.filter = self.Owner
	trace.mins = -prim_maxs
	trace.maxs = prim_maxs

	trace = util.TraceHull( trace )

	local target = trace.Entity

	if ( !( target && target:IsValid() ) ) then return end

	if ( target.IsZombie ) then

		self.Owner:SetHealth( math.min( self.Owner:Health() + target:Health(), self.Owner:GetMaxHealth() ) )
		target:Kill()
		return
	end

	if ( target:IsPlayer() && target:Health() > 0 && target:GTeam() != TEAM_SCP && target:GetMoveType() != MOVETYPE_OBSERVER && !self.ForceAnimSequence ) then

		self:SetNextPrimaryFire( CurTime() + 1.25 )

		if ( SERVER ) then

			self:VoiceLine( "nextoren/scp/049/kidnap" .. math.random( 1, 2 ) .. ".ogg" )

		end

		self.NextGestureCheck = CurTime() + 8

		self:GrabVictim( target )

	end

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire( CurTime() + self.AbilityIcons[ 1 ].Cooldown )

	self.AbilityIcons[ 1 ].CooldownTime = CurTime() + tonumber( self.AbilityIcons[ 1 ].Cooldown )

	if ( CLIENT ) then return end

	local players = player.GetAll()

	for i = 1, #players do

		local player = players[ i ]

		if ( player.IsZombie && player:Health() > 0 ) then

			player:AnimatedHeal(player:GetMaxHealth() - player:Health())
			player:SetArmor(50)

			timer.Simple( 20, function()

				if ( player && player:IsValid() ) then

					player:SetArmor(0)

				end

			end )

		end

	end

end