AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/009.png" )

end

SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.UseHands			= true

SWEP.ViewModel			= "models/cultist/scp_items/009/v_scp009.mdl"
SWEP.WorldModel			= "models/cultist/scp_items/009/w_scp_009.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HoldType = "gren"
SWEP.UseHands = true

SWEP.ViewModelFOV = 69

SWEP.PrintName			= "SCP-009"
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.UseHands			= true

SWEP.Pos = Vector( -3, -2.5, 2 )
SWEP.Ang = Angle( -180, 0, 90 )

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Reload()
end

function SWEP:Equip()
	self.Attack = false
	self.throw = false
end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "molotov_idle", true )

	end

	if self.Attack and self.AttackDelay <= CurTime() and self.Owner then

		if !self.Owner:KeyDown(IN_ATTACK) and !self.Owner:KeyDown(IN_ATTACK2) and !self.throw then
			self.throw = true

			self:PlaySequence( "molotov_throw" )

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			if SERVER then
				
				local proj = ents.Create("projectile_scp_009")
				proj:SetOwner(self.Owner)
				proj:SetPos(self.Owner:EyePos())
				proj:SetAngles(self.Owner:EyeAngles())
				proj:Spawn()
				proj:PhysWake()
				self:SetNoDraw(true)
				local phy = proj:GetPhysicsObject()
				if IsValid(phy) then
					phy:SetVelocity(self.Owner:GetAimVector()*750*math.Clamp(CurTime() - self.StartHold*7, 1, 30))
					phy:SetAngleVelocity(Vector(math.random(-100,100),555,math.random(-100,100)))
				end

				timer.Simple(0.7, function()

					self.Owner:SelectWeapon("br_holster")

					self:Remove()

				end)

			end
		end

	end

end

function SWEP:PrimaryAttack()

	if !IsFirstTimePredicted() then return end

	if self.Attack then return end

	self.IdleDelay = CurTime() + 10000

	self.Attack = true

	self:PlaySequence( "molotov_pullpin" )

	self.StartHold = CurTime()

	self.AttackDelay = CurTime() + 0.15

end



function SWEP:PlaySequence( seq_id, idle )

  if ( !idle ) then

    self.IdlePlaying = false

  end

  if ( !( self && self:IsValid() ) || !( self.Owner && self.Owner:IsValid() ) ) then return end

	local vm = self.Owner:GetViewModel()

  if ( !( vm && vm:IsValid() ) ) then return end

	if ( isstring( seq_id ) ) then

		seq_id = vm:LookupSequence( seq_id )

	end

  vm:SetCycle( 0 )
  vm:SetPlaybackRate( 1.0 )
	vm:SendViewModelMatchingSequence( seq_id )

end

function SWEP:Deploy()
	if ( !IsFirstTimePredicted() ) then return end

	self:PlaySequence( "molotov_deploy" )
	self.HolsterDelay = nil
	self.IdleDelay = CurTime()
end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:DrawWorldModel()

	local pl = self.Owner

	if ( pl && pl:IsValid() ) then

		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if ( !bone ) then return end

		local wm = self:CreateWorldModel()
		local pos, ang = self.Owner:GetBonePosition( bone )

		if ( wm && wm:IsValid() ) then

			ang:RotateAroundAxis( ang:Right(), self.Ang.p )
			ang:RotateAroundAxis( ang:Forward(), self.Ang.y )
			ang:RotateAroundAxis( ang:Up(), self.Ang.r )

			wm:SetRenderOrigin( pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z )
			wm:SetRenderAngles( ang )
			if !self:GetNoDraw() then
				wm:DrawModel()
			end

		end

	else

		self:DrawModel()

	end

end

function SWEP:SecondaryAttack()
	if self.Attack or self.throw then
		self:PlaySequence( "molotov_idle", true )
		self.Attack = false
		self.throw = false
	end
end
