AddCSLuaFile()

ENT.Type = "anim"
ENT.AmmoID = 0
ENT.AmmoType = "Pistol"
ENT.PName = "Pistol Ammo"
ENT.AmmoAmount = 1
ENT.MaxUses = 1
ENT.Bodygroup = 0
ENT.Model = Model( "models/cultist/items/ammo_boxes/ammo_box.mdl" )

function ENT:Initialize()

	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetBodygroup( 0, self.Bodygroup )

end

local maxs = {

	Pistol = 100,
	Revolver = 40,
	SMG1 = 180,
	AR2 = 180,
	Shotgun = 90

}

function ENT:Use( activator, caller )
	if ( ( caller.NextAmmoPickup || 0 ) > CurTime() ) then return end

	caller.NextAmmoPickup = CurTime() + 1.5

	if ( caller:GTeam() != TEAM_SCP or caller:GTeam() != TEAM_SPEC ) then

		local wep = caller:GetActiveWeapon()

		if ( wep != NULL ) then

			local ammo = wep.Primary.Ammo

			if ( ammo == self.AmmoType ) then

				if ( caller:GetAmmoCount( ammo ) >= ( maxs[ ammo ] || 90 ) ) then

					caller:SetBottomMessage( "l:ammo_maximum" )

					return
				end

				self:Remove()
				caller:EmitSound( "nextoren/equipment/ammo_pickup.wav", 80, 100, 1, CHAN_STATIC )
				caller:GiveAmmo( self.AmmoAmount, self.AmmoType, true )

			else

				caller:SetBottomMessage( "l:ammo_not_suitable" )
			end

		end

	end

end

local clr_green = Color( 0, 210, 0, 210 )
local clr_red = Color( 210, 0, 0, 190 )

function ENT:Draw()

	self:DrawModel()

	local client = LocalPlayer()

	if ( client:GetPos():DistToSqr( self:GetPos() ) > 10000 ) then return end

	local ent = client:GetEyeTrace().Entity

	if ( ent == self ) then

		local wep = client:GetActiveWeapon()

		if ( wep != NULL && wep.CW20Weapon ) then

			if ( wep.Primary.Ammo == self.AmmoType ) then

				outline.Add( { self }, clr_green, OUTLINE_MODE_VISIBLE )

			else

				outline.Add( { self }, clr_red, OUTLINE_MODE_VISIBLE )

			end

		end

	end

end
