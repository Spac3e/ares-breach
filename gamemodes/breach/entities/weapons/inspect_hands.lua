AddCSLuaFile()

SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= Model( "models/weapons/c_handlooker.mdl" )
SWEP.WorldModel			= ""

SWEP.ViewModelFOV		= 90

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "script_weapon"
SWEP.UnDroppable = true
SWEP.Slot				= 0
SWEP.SlotPos			= 5
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.HoldType = "normal"

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextIdle" )

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetNextIdle( 0 )

end

local DeployRandomAnimations = {

	"seq_admire", "seq_admire_bms_old"

}

function SWEP:SecondaryAttack()

	local vm = self.Owner:GetViewModel()

	if ( !( vm && vm:IsValid() ) ) then return end
	
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "seq_admire_bms_old" ) )
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )

end

function SWEP:ShouldDrawViewModel()

	return self:GetNextIdle() > CurTime()

end

function SWEP:Think()

	local vm = self.Owner:GetViewModel()

	if ( self:GetNextIdle() != 0 && self:GetNextIdle() < CurTime() ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "reference" ) )
		self:SetNextIdle( 0 )

	end

end

if ( SERVER ) then

	function SWEP:Holster()

		if ( self && self:IsValid() ) then

			self:Remove()

		end

	end

end

function SWEP:Deploy()

	if ( !IsFirstTimePredicted() ) then return end

	local vm = self.Owner:GetViewModel()

	if ( !( vm && vm:IsValid() ) ) then return end

	vm:SendViewModelMatchingSequence( vm:LookupSequence( "reference" ) )

	timer.Simple( .1, function()

		if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( DeployRandomAnimations[ math.random( 1, #DeployRandomAnimations ) ] ) )
		self:SetNextIdle( CurTime() + vm:SequenceDuration() )

		if ( SERVER ) then

			timer.Simple( vm:SequenceDuration(), function()

				if ( self && self:IsValid() && ( self.Owner && self.Owner:IsValid() ) && self.Owner:Health() > 0 ) then

					if ( self.weapon_to_select ) then

						self.Owner.weapon_to_select = self.weapon_to_select

						CreatePlayerTimer( self.Owner, "SelectOldWeapon", .25, 3, function( player )

							if ( !( player && player:IsValid() ) ) then return end

							player:SelectWeapon( player.weapon_to_select )

							timer.Simple( 1, function()

								if ( player && player:IsValid() ) then

									player.weapon_to_select = nil

								end

							end )

						end )

						self:Holster()

					else

						self.Owner:SelectWeapon( "v92_eq_unarmed" )

					end

				end

			end )

		end

	end )

	return true
end
