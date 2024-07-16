AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/scp/427.png" )

end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/cultist/scp_items/427/scp_427.mdl"
SWEP.PrintName		= "SCP-427"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.15
SWEP.droppable				= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Percent = 100
SWEP.IsUsing = false
SWEP.Healthd = 1


local NextPercent = 0
local NextRandom = 0

function SWEP:Equip()

  self.Healthd = self.Owner:Health()

end

local UserHealth = 5
function SWEP:PrimaryAttack()

	if ( ( self.NextToggle || 0 ) > CurTime() ) then return end

	self.NextToggle = CurTime() + 2

  if ( !self.IsUsing ) then

		if ( SERVER ) then

			self.Owner:BrTip( 3, "[Ares Breach]", Color( 0, 255, 0, 180 ), "l:scp427_regenerates_health", color_white )

		end

    UserHealth = self.Owner:Health()
    self.IsUsing = true

  else

		if ( SERVER ) then

			self.Owner:BrTip( 3, "[Ares Breach]", Color( 255, 0, 0, 180 ), "l:you_took_off_scp427", color_white )

		end

    self.IsUsing = false

  end

end

function SWEP:Think()

	if ( !( self.Owner && self.Owner:IsValid() ) ) then return end

	if ( self.Owner:Health() <= 0 && self.Owner:Alive() ) then

		self.Owner:Kill()
		return
	end

  if ( self.Owner:Health() <= 0 || CLIENT ) then return end

  if ( !self.IsUsing ) then return end

  if ( self.Owner:Health() < self.Owner:GetMaxHealth() ) then

    UserHealth = math.Approach( UserHealth, self.Owner:GetMaxHealth(), FrameTime() * 16 )
    self.Owner:SetHealth( UserHealth )

  end

  if ( NextPercent < CurTime() ) then

    NextPercent = CurTime() + math.random( 1, 3 )
    self.Percent = self.Percent - 2

  end

  if ( NextRandom < CurTime() && self.Percent <= 75 ) then

    NextRandom = CurTime() + 2

		if ( !self.Tip ) then

			self.Tip = true
			self.Owner:Tip( 3, "[Ares Breach]", Color( 255, 0, 0, 180 ), "Вы стали странно себя ощущать. Наверное, стоит прекратить использование SCP-427?", color_white )

		end

    if ( math.log( math.random( 1, self.Percent ), self.Percent ) > 0.85 ) then

      self.Owner:Kill()

    end

  end

  return true
end

function SWEP:CanSecondaryAttack()

	return false

end
