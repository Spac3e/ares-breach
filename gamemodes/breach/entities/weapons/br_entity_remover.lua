AddCSLuaFile()

SWEP.PrintName			= "Entity Remover"			

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo		= "None"

SWEP.droppable				= false

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"
SWEP.IconLetter			= "Remover"
SWEP.SelectFont			= "DermaLarge"
SWEP.HoldType 			= "normal"

--if (CLIENT) then
	--SWEP.WepSelectIcon	= surface.GetTextureID( "vgui/entities/weapon_scp096" )
	--SWEP.BounceWeaponIcon = false
	--killicon.Add( "kill_icon_scp096", "vgui/icons/kill_icon_scp096", Color( 255, 255, 255, 255 ) )
--end

function SWEP:Initialize()
	if CLIENT then
		self.Author		= "danx91"
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		--self.Owner:DrawWorldModel( false )
		--self.Owner:DrawViewModel( false )
	end
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if IsValid( ent ) then
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		fxdata = EffectData()
		fxdata:SetEntity( self )
		fxdata:SetAttachment( 1 )
		fxdata:SetStart( self.Owner:GetShootPos() )
		fxdata:SetOrigin( tr.HitPos )
		fxdata:SetNormal( tr.HitNormal )
		if CLIENT then
			util.Effect("tooltracer", fxdata)
		end
		self:EmitSound( "NPC_CombineBall.Impact" )
		if !SERVER then return end
		ent:Remove()
	end
end

function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	--
end

function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	--
end

function SWEP:DrawHUD()
	/*local tr = self.Owner:GetEyeTrace()
	local pos = tr.HitPos:ToScreen()
	local spos = tr.StartPos:ToScreen()
	surface.SetDrawColor( Color( 25, 25, 200, 255 ) )
	surface.DrawLine( spos.x, spos.y, pos.x, pos.y )*/
end