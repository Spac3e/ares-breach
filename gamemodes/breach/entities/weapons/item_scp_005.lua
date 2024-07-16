AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/005.png" )

end

SWEP.PrintName = "SCP-005"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.WorldModel = "models/cultist/scp_items/005/scp_005.mdl"
SWEP.ViewModel = "models/cultist/scp_items/005/v_scp_005.mdl"
SWEP.HoldType = "items"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.DoorsBlacklist = {
	{Vector(-7016.3979492188, -737.99383544922, 1818.2813720703), Vector(-7047.037109375, -808.10424804688, 1751.0594482422)},
	{Vector(-2052.1374511719, 6432.9228515625, 1750.9797363281), Vector(-1914.3638916016, 6342.7861328125, 1647.3489990234)},	
}

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.UseHands = true

SWEP.Pos = Vector( -2, 6, 1 )
SWEP.Ang = Angle( 60, 90, 240 )

function SWEP:Deploy()

  self.IdleDelay = CurTime() + .5
  self.HolsterDelay = nil
  self:PlaySequence( "draw" )

  if ( self.Skin ) then

    self.Owner:GetViewModel():SetSkin( self.Skin )

  end

end

function SWEP:Initialize()

  self:SetHoldType( "items" )

end

function SWEP:Think()

  if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

function SWEP:PrimaryAttack()

  if ( SERVER ) then

    local tr = self.Owner:GetEyeTrace()

    local ent = tr.Entity

    if ( ent && ent:IsValid() || game.GetWorld() == ent ) then
    	for _, pos in pairs(self.DoorsBlacklist) do
    		if ent:GetPos():WithinAABox(pos[1], pos[2]) then return end
    	end
      self:OpenDoor( ent, tr )

    end

  end

end

function SWEP:OpenDoor( ent, tr )

  if ( ent:GetClass() == "func_button" ) then

    --if ( ent.CLevel ) then

      ent:Input( "Press", self.Owner, self.Owner ) -- Press button
      self.Owner:CompleteAchievement("scp005")
      self:Remove()

    --end

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

		if ( bone ) then

      local wm = self:CreateWorldModel()

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )
			wm:SetModelScale( .7 )
			wm:DrawModel()

		end

	else

		self:SetRenderOrigin( nil )
		self:SetRenderAngles( nil )
		self:DrawModel()

	end

end

function SWEP:SecondaryAttack()

  self:PrimaryAttack()

end

function SWEP:CanPrimaryAttack()

  return true

end
