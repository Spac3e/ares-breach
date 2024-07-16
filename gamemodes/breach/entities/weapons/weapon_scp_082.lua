SWEP.Category = "BREACH SCP"
SWEP.PrintName = "SCP-082"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.WorldModel = ""
SWEP.HoldType = "bogdan"
SWEP.AlertWindow = false
SWEP.AbillityID = 0
SWEP.maxs = Vector( 8, 10, 5 )
SWEP.Rage = false
SWEP.Damage = 300
SWEP.ViewModelFOV = 58

SWEP.ViewModel = Model("models/cultist/scp/scp_082_hands.mdl")

SWEP.droppable = false
SWEP.Primary.Delay = 3

SWEP.Secondary.Delay = 6

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "RageNumber" )

	self:SetRageNumber( 0 )

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:AnimationsChange( rage )

	if ( SERVER ) then

		net.Start( "ChangeAnimations" )

			net.WriteEntity( self.Owner )
			net.WriteBool( rage )

		net.Broadcast()

	end

	if ( rage ) then

		self.Owner.SafeModelWalk = 39
		self.Owner.SafeRun = 37
		self.Owner.IdleSafemode = 35

	else

		self.Owner.SafeModelWalk = 31
		self.Owner.SafeRun = 29
		self.Owner.IdleSafemode = 27

	end

end

function SWEP:ApplyMeleeDamage( hitent, tr, damage )

	if ( !IsFirstTimePredicted() ) then return end

	local owner = self.Owner

	if ( self.Rage ) then

		damage = self.Damage * 2

	end

	local dmginfo = DamageInfo()
	dmginfo:SetDamagePosition( tr.HitPos )
	dmginfo:SetAttacker( owner )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamageType( DMG_SLASH )
	dmginfo:SetDamage( damage )
	dmginfo:SetDamageForce( math.min( damage, 50 ) * 50 * owner:GetAimVector() )

	local vel;

	if ( hitent:IsPlayer() ) then

		if ( SERVER ) then

			hitent:SetLastHitGroup( tr.HitGroup )

			if ( tr.HitGroup == HITGROUP_HEAD ) then

				hitent:SetWasHitInHead()

			end

			if ( hitent:WouldDieFrom( damage, tr.HitPos ) ) then

				dmginfo:SetDamageForce( math.min( damage, 50 ) * 400 * owner:GetAimVector() )
				self.Owner:EmitSound( "nextoren/scp/082/kill_" .. math.random( 1, 8 ) .. ".mp3" )

			end

		end

		vel = hitent:GetVelocity()

		if ( SERVER ) then

			hitent:EmitSound( "nextoren/scp/082/attack_hit.mp3" )
			hitent:TakeDamageInfo( dmginfo )

		end

	end

	if ( vel ) then

		hitent:SetLocalVelocity( vel )

	end

end

function SWEP:Deploy()

	--self.Owner:DrawViewModel( false )

	if ( SERVER ) then

		self.Owner:DrawWorldModel( false )

	end

end

local friendly_teams = {

	[ TEAM_SPEC ] = true,
	[ TEAM_DZ ] = true,
	[ TEAM_SCP ] = true

}

local BannedDoors = {

	[ 5323 ] = true,
	[ 4022 ] = true,
	[ 4394 ] = true

}

SWEP.ViewModelFlip = false

local sequencelist = {
    ["attack_1"] = Angle(-5,-10,0),
    ["attack_2"] = Angle(10,10,0),
}

function SWEP:PrimaryAttack()
    local sequence = "attack_2"

    if self.Rage then
        self:SetNextPrimaryFire(CurTime() + 0.5)
    else
        self:SetNextPrimaryFire(CurTime() + 1)
    end

    self.Owner:LagCompensation(true)

    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + self.Owner:GetAimVector() * 80
    trace.filter = self.Owner
    trace.mins = -self.maxs
    trace.maxs = self.maxs

    trace = util.TraceHull(trace)

    self.Owner:LagCompensation(false)

    self.Owner:SetAnimation(PLAYER_ATTACK1)

    local ent = trace.Entity

    if (SERVER && ent && ent:IsValid() && ent:GetClass() == "prop_dynamic") then
        self:EmitSound("nextoren/scp/082/attack_miss.mp3")

        local door = ent:GetParent()

        if (door && door:IsValid() && door:GetClass() == "func_door" && !door.OpenedBySCP096 && !preparing && !BannedDoors[door:MapCreationID()] && SCPLockDownHasStarted == true && !door:GetInternalVariable("noise2"):find("elevator") && !door:GetInternalVariable("parentname"):find("914_door") && !door:GetInternalVariable("m_iName"):find("gate")) then
            door.OpenedBySCP096 = true
            door:EmitSound("npc/antlion/shell_impact4.wav")
            door:EmitSound("nextoren/scp/096/metal_break3.wav")
            door:Fire("Unlock")
            door:Fire("Open")

            timer.Simple(6, function()
                door.OpenedBySCP096 = false
            end)

            return
        end
    end

    if (!ent:IsPlayer()) then
        self:EmitSound("nextoren/scp/082/attack_miss.mp3")
    else
        sequence = "attack_1"
    end

    self.ViewModelFlip = not self.ViewModelFlip
    if SERVER then
        self:PlaySequence(sequence)
    end

    local seq = self.Owner:GetViewModel():GetSequenceName(self.Owner:GetViewModel():GetSequence())

    if seq == "ragdoll" then
        seq = sequencelist["attack_2"]
    else
        seq = sequencelist[sequence]
    end

    if seq then
        local velocity = seq

        if self.ViewModelFlip then
            velocity.y = -velocity.y
        end

        self.Owner:ViewPunch(velocity)

        if (ent:IsPlayer()) then
            if (not friendly_teams[ent:GTeam()]) then
                self.Owner:SetHealth(math.min(self.Owner:Health() + math.random(100, 200), self.Owner:GetMaxHealth()))
                ent:ThrowFromPositionSetZ(self.Owner:GetPos(), 80)
                ent:MeleeViewPunch(self.Damage)
                self:ApplyMeleeDamage(ent, trace, self.Damage)
            end
        end
    end
end

local BannedDoors = {

	[ 2142 ] = true,
	[ 2141 ] = true,
	[ 4394 ] = true

}

if ( SERVER ) then

	function SWEP:Think()

		if !self.Rage and self.Owner:GetRunSpeed() > 100 then
			self.Owner:SetRunSpeed(100)
			self.Owner:SetWalkSpeed(100)
		end

		if ( self:GetRageNumber() >= 100 && !self.Rage ) then

			self.Rage = true

			self:AnimationsChange( true )

			local filter = RecipientFilter()
			filter:AddAllPlayers()

			local snd = CreateSound( self, "nextoren/scp/082/rage.mp3", filter )
			snd:SetDSP( 17 )
			snd:Play()

			if ( SERVER ) then

				self.Owner:Freeze( true )
				self.Owner:SetWalkSpeed( 340 )
				self.Owner:SetRunSpeed( 380 )
				self.Owner:SetCrouchedWalkSpeed( 340 )

				net.Start( "ThirdPersonCutscene" )

					net.WriteUInt( 2, 4 )

				net.Send( self.Owner )

				self.Owner:SetForcedAnimation( "roar", 2, nil, function()

					self.Owner:Freeze( false )

				end)

			end

			timer.Simple( 8, function()

				self.smoothminus = true

			end )

		elseif ( self:GetRageNumber() > 0 && self.Rage && self.smoothminus ) then

			self:SetRageNumber( math.Approach( self:GetRageNumber(), 0, FrameTime() * 32 ) )

			if ( self:GetRageNumber() == 0 ) then

				self.smoothminus = false
				self.Rage = false

				self:AnimationsChange( false )

				self.Owner:SetWalkSpeed( 100 )
				self.Owner:SetRunSpeed( 100 )
				self.Owner:SetCrouchedWalkSpeed( 100 )

			end

		end

		for _, ents in ipairs( ents.FindInSphere( self.Owner:GetPos(), 1024 ) ) do

			if ( ents:IsPlayer() && ents != self.Owner && ents:Alive() && !friendly_teams[ ents:GTeam() ] && self.Owner:IsLineOfSightClear( ents:GetPos() ) ) then

				if ( self.Owner:GetAimVector():Dot( ( ents:GetPos() - self.Owner:GetPos() ):GetNormalized() ) > 0.7 ) then

					self:SetRageNumber( math.Approach( self:GetRageNumber(), 100, FrameTime() * 3 ) )

				end

			end

		end

		if self.Rage then
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

end

if ( CLIENT ) then

	local w = 64
	local h = 64
	local padding = 133

	local RageIcon = Material( "nextoren/gui/special_abilities/scp_082_rage_redux.png", "smooth" )

	local icon_clr = Color( 10, 10, 40, 240 )
	local vec_offset = Vector( 0, 0, -1 )

	local red_percent = Color( 255, 0, 0 )
	local yellow_percent = Color( 200, 220, 0 )
	local percent_clr = Color( 200, 200, 200 )

	local percentclr

	function SWEP:DrawHUD()

		local percent = self:GetRageNumber() / 100
		local actualpercent = math.Round( percent * 100 )

		local screenheight = ScrH()
		local screenwidth_one_half = ScrW() / 2

		local y = screenheight - 175

		local quad_pos = Vector( screenwidth_one_half, y )

		local color = color_white

		if ( actualpercent >= 40 && actualpercent < 70 ) then

			percentclr = yellow_percent

		elseif ( actualpercent >= 70 ) then

			percentclr = red_percent

		else

			percentclr = percent_cl

		end

		if ( actualpercent >= 100 ) then

			color = Color( Pulsate( 2 ) * 180, 0, 0 )

		end

		render.SetMaterial( RageIcon )
		render.DrawQuadEasy( quad_pos,

			vec_offset,
			w, h,
			icon_clr,
			-90

		)

		render.SetScissorRect( screenwidth_one_half + 30, y + 32 - ( h * percent ), padding + w, screenheight, true )

		render.DrawQuadEasy( quad_pos,

			vec_offset,
			w, h,
			color,
			-90

		)
		render.SetScissorRect( 0, y + 32, padding + w, screenheight, false )


		if ( actualpercent < 100 ) then

			draw.SimpleText( actualpercent, "char_title24", screenwidth_one_half, y, percentclr, 1, 1 )

		end

	end

end

function SWEP:CanSecondaryAttack()

	return false

end
