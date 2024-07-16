AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false

	net.Receive( "GetVictimsTable", function( len )

		local tvictim = net.ReadTable()

		LocalPlayer():GetActiveWeapon().victims = tvictim

	end )

	net.Receive( "ChangeAnimations", function()

		local entity = net.ReadEntity()
		local rage = net.ReadBool()

		if ( entity && entity:IsValid() ) then

			local wep = entity:GetActiveWeapon()

			if ( wep != NULL && wep.AnimationsChange ) then

				wep:AnimationsChange( rage )

			end

		end

	end )

	function SWEP:DrawHUD()

		if ( !self.Deployed ) then

			self:Deploy()

		end

	end

end

if ( SERVER ) then

	util.AddNetworkString( "GetVictimsTable" )
	util.AddNetworkString( "ChangeAnimations" )

end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"

SWEP.PrintName		= "SCP-096"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.HoldType		= "melee2"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.ScreamSound = nil

SWEP.AttackDelay	= 0.10
SWEP.droppable		= false
SWEP.NextAttackW	= 0

SWEP.IsInRage 		= false
SWEP.IsCrying		= false

function SWEP:Deploy()

	self.Deployed = true

	if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

	end

	self.Owner:DrawViewModel( false )

	if ( CLIENT ) then

		local victim_clr = Color( 255, 80, 0, 210 )
		hook.Add( "PreDrawOutlines", "DrawVictims", function()

			local client = LocalPlayer()

			if ( client:GTeam() != TEAM_SCP && client:GetRoleName() != "SCP096" && client:Health() <= 0 ) then

				hook.Remove( "PreDrawOutlines", "DrawVictims" )

				return
			end

			local wep = client:GetActiveWeapon()

			if ( wep == NULL || !wep.victims ) then return end

			local victimstab = {}

			for victimsid, victimsv in ipairs( wep.victims ) do

				if ( victimsv && victimsv:IsValid() && victimsv:Health() > 0 && victimsv:GTeam() != TEAM_SPEC ) then

					victimstab[ #victimstab + 1 ] = victimsv
					local bnm = victimsv:LookupBonemerges()
					for i = 1, #bnm do
						victimstab[ #victimstab + 1 ] = bnm[i]
					end

				else

					table.RemoveByValue( wep.victims, victimsv )

				end

			end

			outline.Add( victimstab, victim_clr, 0 )

		end )

	end

	self:SetHoldType( self.HoldType )

	if ( SERVER ) then

		local filter = RecipientFilter()
		filter:AddAllPlayers()
		self.ScreamSound = CreateSound( self, "nextoren/scp/096/scream.wav", filter )

	end

end

function SWEP:DrawWorldModel() end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:CanPrimaryAttack()

	return true

end

local bannedTeams = {

	[TEAM_SCP] = true,
	[TEAM_SPEC] = true,
	[TEAM_DZ] = true

}

--[[sound.Add( {
	name = "scream",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 95, 110 },
	sound = "nextoren/scp/096/scream.wav"
} )]]

function SWEP:SecondaryAttack()

	return false

end

function SWEP:Holster()

	table.Empty( self.victims )

	if ( SERVER && self.Owner && self.Owner:IsValid() && self.ScreamSound && self.ScreamSound:IsPlaying() ) then

		self.ScreamSound:Stop()

	end

end

function SWEP:OnRemove()

	table.Empty( self.victims )

	if ( SERVER && self.Owner && self.Owner:IsValid() && self.ScreamSound && self.ScreamSound:IsPlaying() ) then

		self.ScreamSound:Stop()

	end

end

SWEP.victims = {}

function SWEP:IsLookingAt( ply, targ )

	local yes;

	if ( ply != self.Owner ) then

		yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() ):GetNormalized() )
		return ( yes > 0.9 )

	elseif ( targ && targ:IsValid() && ply == self.Owner ) then

		yes = ply:GetAimVector():Dot( ( targ:GetPos() - ply:GetPos() ):GetNormalized() ) + .35
		return ( yes > 0.9 )

	end

	return false

end

function SWEP:PrimaryAttack()

	if ( !IsFirstTimePredicted() ) then return end

	if ( self.NextAttackW >= CurTime() ) then return end
	self.NextAttackW = CurTime() + self.AttackDelay

	if ( SERVER ) then

		if ( self.IsInRage ) then

			local tr = {

				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 90,
				filter = self.Owner,
				mins = Vector( -15, -15, -5 ),
				maxs = Vector( 15, 15, 5 )

			}

			local trace = util.TraceHull( tr )

			local ent = trace.Entity

			if ( !ent:IsPlayer() ) then return end

			if !table.HasValue(self.victims, ent) then return end

			ent:Kill()
			self.ScreamSound:Stop()

			net.Start( "GetVictimsTable" )

				net.WriteTable( self.victims )

			net.Send( self.Owner )

			self.Owner:Freeze( true )
			self.Owner:SetForcedAnimation( "GESTURE_FLINCH_HEAD", 4, nil, function()

				if ( self && self:IsValid() ) then

					self.Owner:Freeze( false )

					if ( #self.victims > 0 ) then

						self.ScreamSound:Play()

					end

				end

			end )

			timer.Simple( .1, function()

				if ( ent:GetNWEntity( "RagdollEntityNO" ) && ent:GetNWEntity( "RagdollEntityNO" ):IsValid() ) then

					local ragdoll_pos = ent:GetPos()

					--sound.Play( "nextoren/charactersounds/hurtsounds/male/gore_"..math.random( 1, 4 )..".mp3", ragdoll_pos )

					local snd = CreateSound( ent, "nextoren/charactersounds/hurtsounds/male/gore_" .. math.random( 1, 4 ) .. ".mp3" )
					snd:SetDSP( 17 )
					snd:Play()

					if ( #self.victims > 0 ) then

						self:AnimationsChange( true )

					end

					ParticleEffect( "tank_gore_c", ragdoll_pos, ent:GetAngles() )
					ent:GetNWEntity( "RagdollEntityNO" ):Remove()

				end

			end )

			table.RemoveByValue( self.victims, ent )

			if ( #self.victims <= 0 ) then

				self.IsInRage = false
				self.Owner:SetWalkSpeed( 40 )
				self.Owner:SetMaxSpeed( 40 )
				self.Owner:SetRunSpeed( 40 )
				self.Owner:DoAnimationEvent( ACT_GESTURE_MELEE_ATTACK1 )
				self.ScreamSound:Stop()
				self.ScreamSound = nil
				local filter = RecipientFilter()
				filter:AddAllPlayers()
				self.ScreamSound = CreateSound( self, "nextoren/scp/096/scream.wav", filter )
				self:AnimationsChange( false )

			end

		end

	end

end

function SWEP:AnimationsChange( rage )

	if ( SERVER ) then

		net.Start( "ChangeAnimations" )

			net.WriteEntity( self.Owner )
			net.WriteBool( rage )

		net.Broadcast()

	end

	if ( rage ) then

		self.Owner:SetCustomCollisionCheck( true )
		self.Owner.SafeModelWalk = self.Owner:LookupSequence( "walk_MELEE" )
		self.Owner.SafeRun = self.Owner:LookupSequence( "run_MELEE" )
		self.Owner.IdleSafemode = self.Owner:LookupSequence( "idle_MELEE" )

	else

		self.Owner:SetCustomCollisionCheck( false )
		self.Owner.SafeModelWalk = self.Owner:LookupSequence( "walk_melee2" )
		self.Owner.SafeRun = self.Owner:LookupSequence( "run_melee2" )
		self.Owner.IdleSafemode = self.Owner:LookupSequence( "idle_melee2" )

	end

end

function SWEP:StartWatching()

	self.IsCrying = true
	self.Owner:Freeze( true )
	self.Owner:EmitSound( "nextoren/scp/096/start_crying.wav" )
	self.Owner.DamageModifier = 0.01

	self:AnimationsChange( true )

	--[[timer.Simple( 1.5, function()

		if ( self && self:IsValid() ) then

			hook.Run( "PlayerSwitchWeapon", self.Owner, self, self )

		end

	end )]]

	timer.Create( "CryTime" ..self.Owner:SteamID(), 30, 1, function()

		if ( self && self:IsValid() ) then

			self.KeepRageUntil = CurTime() + 60

			self.IsCrying = false
			self.IsInRage = true

			if ( SERVER ) then

				self.ScreamSound:Play()

			end

			self.Owner:Freeze( false )
			self.Owner:SetWalkSpeed( 350 )
			self.Owner:SetRunSpeed( 350 )
			self.Owner:SetMaxSpeed( 350 )
			self.Owner.DamageModifier = 0.1

		end

	end)

end

local BannedDoors = {

	[ 5323 ] = true,
	[ 4022 ] = true,
	[ 4394 ] = true

}

function SWEP:Think()

	if ( CLIENT ) then return end

	if ( !self.Owner:Alive() ) then return end

	if ( self.IsInRage ) then

		for _, v in ipairs( ents.FindInSphere( self.Owner:GetPos(), 60 ) ) do

			if ( v:GetClass() == "func_door" && !v.OpenedBySCP096 && self.Owner:GetVelocity():Length2D() > .25 && !BannedDoors[ v:MapCreationID() ] && !v:GetInternalVariable( "noise2" ):find( "elevator" ) && !v:GetInternalVariable( "parentname" ):find( "914_door" ) && !v:GetInternalVariable( "m_iName" ):find( "gate" )  ) then

				v.OpenedBySCP096 = true
				v:EmitSound( "nextoren/scp/096/metal_break3.wav" )
				v:Fire( "Unlock" )
				v:Fire( "Open" )
				timer.Simple( 6, function()

					v:SetCustomCollisionCheck(false)
					v.OpenedBySCP096 = false

				end )

			end

		end

	end

	local watching = false

	if !self.KeepRageUntil or !self.IsInRage or self.KeepRageUntil <= CurTime() then

		if ( self.IsInRage && #self.victims <= 0 ) then

			--
			self.IsInRage = false
			self.Owner:SetWalkSpeed( 40 )
			self.Owner:SetMaxSpeed( 40 )
			self.Owner:SetRunSpeed( 40 )
			self.Owner:DoAnimationEvent( ACT_GESTURE_MELEE_ATTACK1 )
			self.ScreamSound:Stop()
			self:AnimationsChange( false )

			--[[timer.Simple( 1.5, function()

				if ( self && self:IsValid() ) then

					hook.Run( "PlayerSwitchWeapon", self.Owner, self, self )

				end

			end )]]

		else

			for i = 1, #self.victims do

				local v = self.victims[i]

				if ( !( v && v:IsValid() ) || v:Health() <= 0 || v:GTeam() == TEAM_SPEC || v.AffectedBy049 || v.SCP096TimeElapse <= CurTime() ) then

					table.RemoveByValue( self.victims, v )
					net.Start( "GetVictimsTable" )

						net.WriteTable( self.victims )

					net.Send( self.Owner )

				end

			end

		end

	end

	local List = ents.FindInSphere( self.Owner:GetPos(), 2048 )

	for i = 1, #List do

		local v = List[i]

		if ( !v:IsPlayer() || !v && !v:IsValid() || !v:Alive() || !v:CanSee( self.Owner ) || table.HasValue( self.victims, v ) ) then continue end

		if ( bannedTeams[ v:GTeam() ] ) then continue end

		local tr_eyes = util.TraceLine( {

			start = v:EyePos() + v:EyeAngles():Forward() * 15,
			endpos = self.Owner:EyePos()

		} )

		if ( tr_eyes.Entity && tr_eyes.Entity:IsValid() && tr_eyes.Entity == self.Owner ) then

			if ( self.Owner:CanSee( v ) && self:IsLookingAt( v ) && self:IsLookingAt( self.Owner, v ) && !v:IsFrozen() ) then

				watching = true

				v.SCP096TimeElapse = CurTime() + 60

				table.insert( self.victims, v )

				net.Start( "GetVictimsTable" )

					net.WriteTable( self.victims )

				net.Send( self.Owner )

				break
			end

		end

	end

	if ( watching && !self.IsInRage && !self.IsCrying ) then

		self:StartWatching()

	end

end
