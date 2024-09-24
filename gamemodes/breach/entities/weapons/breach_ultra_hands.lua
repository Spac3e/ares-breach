AddCSLuaFile()

SWEP.PrintName = "Руки Базуки" -- (String) Printed name on menu
if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/hand.png" )

end
SWEP.UnDroppable = true
SWEP.Author = ""
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.HoldType		= "fist"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 48

sound.Add( {

	name = "rukibazuki.miss",
	channel = CHAN_AUTO,
	volume = 1,
	level = 90,
	pitch = { 80, 110 },
	sound = "rxsend_april_event/chemist_miss.ogg",

} )

sound.Add( {

	name = "rukibazuki.hit",
	channel = CHAN_AUTO,
	volume = .9,
	level = 90,
	pitch = { 95, 105 },
	sound = "rxsend_april_event/chemist_attack.ogg",

} )

local SwingSound = Sound( "rukibazuki.miss" )
local HitSound = Sound( "rukibazuki.hit" )

function SWEP:Initialize()

	self:SetHoldType( "fist" )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

local nextanim = "fists_left"

function SWEP:PrimaryAttack( right )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = nextanim
	if anim == "fists_left" then
		nextanim = "fists_right"
	else
		nextanim = "fists_left"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	if SERVER then
		local door = util.TraceLine({
			filter = self.Owner,
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*50,
		})
		if IsValid(door.Entity) and !preparing and SCPLockDownHasStarted == true then
			if door.Entity.GetParent and IsValid(door.Entity:GetParent()) and door.Entity:GetParent():GetClass() == "func_door" then door.Entity = door.Entity:GetParent() end
			if (IsValid(door.Entity) and door.Entity:GetClass() == "func_door") then
				timer.Simple(0.2, function()
					door.Entity:PhysicsInit(SOLID_VPHYSICS)
					door.Entity:SetSolid(SOLID_VPHYSICS)
					door.Entity:SetMoveType(MOVETYPE_VPHYSICS)
					door.Entity:PhysWake()
					door.Entity:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*1000)
					door.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
					SafeRemoveEntityDelayed(door.Entity, 1)
				end)
			end
		end
	end

	timer.Simple(0.2, function()
		if SERVER then util.ScreenShake(self.Owner:GetPos(), 5, 5, 1, 255 ) end
	end)

	self:EmitSound( SwingSound )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.2 )

	self:SetNextPrimaryFire( CurTime() + 0.2 )
	self:SetNextSecondaryFire( CurTime() + 0.2 )

end

function SWEP:SecondaryAttack()

	self:PrimaryAttack( true )

end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		if IsValid(tr.Entity) and tr.Entity.GTeam and tr.Entity:GTeam() == TEAM_SCP then
			dmginfo:SetDamage( math.random( 8, 12 ) )
		else
			dmginfo:SetDamage( math.random( 8, 12 )*20 )
		end


		dmginfo:SetDamageForce( self.Owner:GetForward() * 9989 * scale )

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( self.Owner )

		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function SWEP:Deploy()

	if SERVER then
		self.Owner:EmitSound("rxsend_april_event/chemist_line.ogg", nil, nil, nil, CHAN_VOICE)
	end

	local speed = GetConVarNumber( "sv_defaultdeployspeed" )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	vm:SetPlaybackRate( speed )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
	self:UpdateNextIdle()

	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	return true

end

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )

	return true

end

function SWEP:Think()

	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )

		self:UpdateNextIdle()

	end

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end

	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then

		self:SetCombo( 0 )

	end

end
