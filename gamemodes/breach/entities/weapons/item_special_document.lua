AddCSLuaFile()

SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
SWEP.AdminOnly = false -- (Boolean) Admin only spawnable

SWEP.PrintName = "Документ" -- (String) Printed name on menu

SWEP.ViewModelFOV = 90 -- (Integer) First-person field of view

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/others/fbidocs_ico.png" )

end

SWEP.UnDroppable = true
SWEP.UseHands = false

SWEP.ViewModel = Model( "models/jessev92/weapons/unarmed_c.mdl" )
SWEP.WorldModel = "models/props_lab/clipboard.mdl"
SWEP.HoldType = "normal"

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:CanPrimaryAttack()

	return true

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanSecondaryAttack( )

	return false

end

function SWEP:DrawWorldModel()
	local client = LocalPlayer()
	if client:GetRoleName() == role.SCI_SpyUSA then
		self:DrawModel()
		outline.Add(self, color_white, 2)
	end
end

function SWEP:Reload() end

function SWEP:Equip(Own)
	if Own:GetRoleName() == role.SCI_SpyUSA then
		Own:AddSpyDocument()
		self:Remove()
	end
end

function SWEP:OnDrop( )

end
