SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""

if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/car_keys.png" )

end

SWEP.PrintName		= "Ключи от машины"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.WorldModel = "models/weapons/carkeys/w_key.mdl"
SWEP.ViewModel = "models/weapons/carkeys/c_key.mdl"
SWEP.HoldType		= "slam"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.UseHands				= true

function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DRAW )
	self.NextThinkt = CurTime() + 2

end

function SWEP:Think()

	if ( ( self.NextThinkt || 0 ) <= CurTime() ) then

		self:SendWeaponAnim( ACT_VM_IDLE )

	end

end

function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()

	local ent = tr.Entity

	self.NextThinkt = CurTime() + 3
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	if ( ent:IsVehicle() && ent.Locked ) then

		self.Owner:BrProgressBar( "l:opening_car_door", 2, "nextoren/gui/icons/car_keys.png", ent, false, function()

			ent.Locked = false
			sound.Play( "nextoren/vehicle/car_unlocked.wav", ent:GetPos() )

		end, function()
			timer.Create("Key_Sound_"..self.Owner:UniqueID(), 0, 1, function()
				self:EmitSound("nextoren/vehicle/car_unlocking.wav")
			end)
			timer.Create("Key_Sound2_"..self.Owner:UniqueID(), 1, 1, function()
				self:EmitSound("nextoren/vehicle/car_unlocking.wav")
			end)
		end, function()
			timer.Remove("Key_Sound_"..self.Owner:UniqueID())
			timer.Remove("Key_Sound2_"..self.Owner:UniqueID())
		end)

	end

end

function SWEP:SecondaryAttack() return false end
