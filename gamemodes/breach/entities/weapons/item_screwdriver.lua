AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/screw_driver.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/cultist/items/blue_screwdriver/w_screwdriver.mdl"
SWEP.PrintName		= "Отвёртка"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "knife"
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
SWEP.UseHands = true

SWEP.Pos = Vector( 0, -2, 4 )
SWEP.Ang = Angle( 60, -180, 240 )

function SWEP:Deploy()

  self.Owner:DrawViewModel( false )

end

function SWEP:PrimaryAttack()

  if ( SERVER ) then

		local tr = self.Owner:GetEyeTrace()
		local ent = tr.Entity

		if ( ent && ent:IsValid() && ent:GetClass() == "func_breakable" ) then

			local time = 115

			if self.Owner:GetRoleName() == role.ClassD_Pron then time = time/2 end

			self.Owner:BrProgressBar( "l:hacking_cell", time, "nextoren/gui/icons/screw_driver.png", ent, false, function()

			self:Remove()

		    ent:Fire( "Break" );
		    self.Owner:SetBottomMessage( "l:screwdriver_used" )
		    self.Owner:StripWeapon("item_screwdriver")

	    end)

		end

  end

end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:DrawWorldModel()

	local pl = self:GetOwner()

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )

		if ( !bone ) then return end

		local pos, ang = self.Owner:GetBonePosition( bone )
		local wm = self:CreateWorldModel()

		if ( wm && wm:IsValid() ) then

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )
			wm:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

	end

end

function SWEP:CanSecondaryAttack()

  return false

end

function SWEP:Think() end
