if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/medic_id.png" )

end

SWEP.PrintName = "ID-Карта \"Медицинский персонал\""

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false
SWEP.Droppable = true

SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/cultist/items/id_cards/id_card_medic.mdl"
SWEP.WorldModel = "models/cultist/items/id_cards/id_w_card_medic.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.HoldType = "pass"

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Pos = Vector( 2, -5, 5 )
SWEP.Ang = Angle( -90, 0, 90 )


function SWEP:CreateWorldModel()

  if ( !self.WModel ) then

    self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
    self.WModel:SetNoDraw(true)
		self.WModel:AddEffects( EF_NORECEIVESHADOW )

  end

  return self.WModel

end

local vec_offset = Vector( 2, -5, 5 )
local angle_offset = Angle( -90, 0, 90 )

function SWEP:Think()

	if ( self.Owner:GetVelocity():Length() <= 0 && !self.Owner:Crouching() ) then

		self.Pos = vec_offset
		self.Ang = angle_offset

  elseif ( self.Owner:GetVelocity():Length() > 0 && self.Owner:OnGround() ) then

		self.Pos = vec_offset
		self.Ang = angle_offset

  end

end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:DrawWorldModel()

	if ( ( self.Owner && self.Owner:IsValid() ) ) then

	 	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")

		if ( !bone ) then return end

	 	local pos, ang = self.Owner:GetBonePosition(bone)

		local wm = self:CreateWorldModel()

	  if ( wm && wm:IsValid() ) then

	    ang:RotateAroundAxis(ang:Right(), self.Ang.p)
	    ang:RotateAroundAxis(ang:Forward(), self.Ang.y)
	    ang:RotateAroundAxis(ang:Up(), self.Ang.r)
	    wm:SetRenderOrigin(pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z)
	    wm:SetRenderAngles(ang)
	    wm:DrawModel()

	 	end

	else

		self:DrawModel()

	end

end

function SWEP:CanPrimaryAttack()

	return false

end

function SWEP:CanSecondaryAttack()

	return false

end
