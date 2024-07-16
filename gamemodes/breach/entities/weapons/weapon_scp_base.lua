AddCSLuaFile()

SWEP.PrintName				= "BASE SCP"

SWEP.DrawAmmo				= false
SWEP.BounceWeaponIcon		= false
SWEP.DrawCrosshair			= false

SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= ""

SWEP.ISSCP 					= true
SWEP.droppable				= false
SWEP.teams					= { 1 }

SWEP.Lang = nil
SWEP.FreezePlayer = false
SWEP.ShouldFreezePlayer = false

function SWEP:InitializeLanguage( name )
	if CLIENT then
		self.Lang = GetWeaponLang()[name]
		if self.Lang then
			self.Author			= self.Lang.author
			self.Contact		= self.Lang.contact
			self.Purpose		= self.Lang.purpose
			self.Instructions	= self.Lang.instructions
		end
	end
end

function SWEP:Deploy()
	self:HideModels()
end

function SWEP:HideModels()
	if IsValid( self.Owner ) then
		self.Owner:DrawWorldModel( false )
		self.Owner:DrawViewModel( false )
	end
end

function SWEP:PlayerFreeze()
	if !SERVER then return end

	if preparing and self.ShouldFreezePlayer and !self.FreezePlayer then
		self.FreezePlayer = true
		self.OldStats = {
			jump = self.Owner:GetJumpPower(),
			walk = self.Owner:GetWalkSpeed(),
			run = self.Owner:GetRunSpeed(),
			crouch = self.Owner:GetCrouchedWalkSpeed()
		}
		self.Owner:SetJumpPower( 0 )
		self.Owner:SetCrouchedWalkSpeed( 0 )
		self.Owner:SetWalkSpeed( 0 )
		self.Owner:SetRunSpeed( 0 )
	end

	if preparing or postround then return end

	if self.FreezePlayer then
		self.FreezePlayer = false

		self.Owner:SetCrouchedWalkSpeed( self.OldStats.crouch )
		self.Owner:SetJumpPower( self.OldStats.jump )
		self.Owner:SetWalkSpeed( self.OldStats.walk )
		self.Owner:SetRunSpeed( self.OldStats.run )
	end
end

function SWEP:Think()
	self:PlayerFreeze()
end

function SWEP:SCPDamageEvent( ent, dmg )
	if SERVER then
		hook.Run( "BreachSCPDamage", self.Owner, ent, dmg )
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end