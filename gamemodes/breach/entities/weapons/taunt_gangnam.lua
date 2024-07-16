AddCSLuaFile()

SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
SWEP.AdminOnly = false -- (Boolean) Admin only spawnable

SWEP.WeaponName = "v92_eq_unarmed" -- (String) Name of the weapon script
SWEP.PrintName = "funny dance" -- (String) Printed name on menu

SWEP.ViewModelFOV = 90 -- (Integer) First-person field of view

SWEP.droppable				= false

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false

end

SWEP.UnDroppable = true
SWEP.UseHands = true
SWEP.ViewModel = Model( "models/jessev92/weapons/unarmed_c.mdl" )
SWEP.WorldModel = ""
SWEP.HoldType = "normal"


SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = -1

SWEP.Primary.Automatic = true

SWEP.Primary.Ammo = "none"



SWEP.Secondary.ClipSize = -1

SWEP.Secondary.DefaultClip = -1

SWEP.Secondary.Automatic = true

SWEP.Secondary.Ammo = "none"

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:Think()
	if CLIENT and self.Owner:GetNWBool("Taunt_ThirdPerson") then
		local dlight = DynamicLight(self:EntIndex())
		if ( dlight ) then
			dlight.pos = self.Owner:GetPos() + Vector(0,0,35) + self.Owner:GetAngles():Forward()*-25
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.brightness = 2
			dlight.Decay = 1000
			dlight.Size = 100
			dlight.DieTime = CurTime() + 1
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack( right )

	self:SetNextPrimaryFire(CurTime() +1)

	if SERVER then

		if self.Owner.ForceAnimSequence == self.Owner:LookupSequence("0_gangnam") then

			self.Owner:StopForcedAnimation()

		elseif self.Owner.ForceAnimSequence == nil and self.Owner:GetMoveType() == MOVETYPE_WALK then

			local rememberowner = self.Owner

			local function stop()

				if rememberowner:Alive() then

					rememberowner:SetNWAngle("ViewAngles", Angle(0,0,0))
					rememberowner:SetNWBool("Taunt_ThirdPerson", false)
					rememberowner:SetMoveType(MOVETYPE_WALK)
					rememberowner:EmitSound("garrysmod/save_load1.wav", 55, 100, 0, CHAN_VOICE, nil, 3)

				end

			end

			self.Owner:EmitSound("rxsend_april_event/fanny/fun"..math.random(1,35)..".ogg", 55, 100, 1, CHAN_VOICE, nil, 1)

			self.Owner:SetForcedAnimation('0_gangnam', math.huge, function()
				self.Owner:SetNWAngle("ViewAngles", self.Owner:GetAngles())
				self.Owner:SetMoveType(MOVETYPE_OBSERVER)
			end, stop, stop)
			self.Owner:SetNWBool("Taunt_ThirdPerson", true)

		end

	end

end


function SWEP:CanSecondaryAttack( )

	return false

end

function SWEP:Reload() end

function SWEP:Deploy( )

end

function SWEP:OnDrop( )

	if ( self && self:IsValid() ) then

		self:Remove( )

	end

end
