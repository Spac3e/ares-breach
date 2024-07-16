AddCSLuaFile()

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/hand_key.png" )

end

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= "models/cultist/items/hand_keycard/hand_keycard.mdl"
SWEP.PrintName		= "Рука"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "items"
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

SWEP.Pos = Vector( -3, 3, -4 )
SWEP.Ang = Angle( 240, -90, 240 )

function SWEP:Deploy()

  self.Owner:DrawViewModel( false )

end

function SWEP:OpenDoor( ent )

	ent:EmitSound( "nextoren/others/chaos_radio_open.wav" )

	timer.Simple( 3, function()

		ent:Fire( "Press" )

		timer.Simple( 6, function()

			ent:Fire( "Press" )

		end )

	end )

end

local button_pos = Vector( -7030.770020, -769.390015, 1781.000000 )

function SWEP:Think()

	if ( CLIENT ) then return end

	if ( self.Owner:KeyDown( IN_USE ) ) then

		local ent = self.Owner:GetEyeTrace().Entity

		if ( ent && ent:IsValid() && ent:GetClass() == "func_button" && ent:GetPos() == button_pos ) then

			self:Remove()
			self:OpenDoor( ent )

		end

	end

end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 1 )

	if ( CLIENT ) then return end

	local ent = self.Owner:GetEyeTrace().Entity

	if ( ent && ent:IsValid() && ent:GetClass() == "func_button" && ent:GetPos() == button_pos ) then

		self:Remove()
		self:OpenDoor( ent )

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

function SWEP:Think() end

function SWEP:CanSecondaryAttack()

	return false

end
