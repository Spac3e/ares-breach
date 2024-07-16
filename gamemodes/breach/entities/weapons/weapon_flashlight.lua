SWEP.Spawnable = true
SWEP.UseHands = true

if ( CLIENT ) then

	SWEP.BounceWeaponIcon = false
	SWEP.InvIcon = Material( "nextoren/gui/icons/flashlight.png" )

end

SWEP.PrintName = "Flashlight"
SWEP.ViewModel			= "models/cultist/items/flashlight/v_item_maglite.mdl"
SWEP.ViewModelFOV = 54
SWEP.WorldModel			= "models/cultist/items/flashlight/w_item_maglite.mdl"
SWEP.HoldType = "items"

SWEP.Pos = Vector( 3, 4, -1)
SWEP.Ang = Angle(0, 0, -25)

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

  	self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
  	self.WModel:SetNoDraw( true )
  	self.WModel:SetBodygroup( 1, 1 )

	end

  return self.WModel
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Active" )

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
		self:SetModelScale( 1.1, 0 )

		if ( self.projectedLight ) then

			self.projectedLight:SetNearZ( 0 )
			self.projectedLight:Update()
			self.projectedLight:Remove()

		end

	end

end

SWEP.Primary.Blunt = true
SWEP.Primary.Damage = 25
SWEP.droppable				= true
SWEP.Primary.Reach = 40
SWEP.Primary.RPM = 90
SWEP.Primary.SoundDelay = 0
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.ClipSize	= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.ClipSize	= 0
SWEP.Primary.Delay = 0.3
SWEP.Primary.Window = 0.2
SWEP.Primary.Automatic = false

SWEP.AllowViewAttachment = false

function SWEP:Initialize()

end

function SWEP:Deploy()

	self.HolsterDelay = nil
	self.b_IdleSequence = nil
	self.IdleDelay = CurTime() + .75
	self:PlaySequence( "DrawOn" )
	self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )
	self:SetHoldType(self.HoldType)

	if CLIENT then
		hook.Remove("PreRender", "ManualFlashLightThink")
	end

	if SERVER then if IsValid(self.bnmrg) then self.bnmrg:SetInvisible(false) end end

end

function shkest()
	CreateParticleSystem( Entity(1), "aircraft_landing_light02", PATTACH_POINT_FOLLOW, 3 )
end

local rememberang = angle_zero

function SWEP:Think()

	--if CLIENT and LocalPlayer():IsSuperAdmin() then print("CHECK") end

	if ( CLIENT && self:GetActive() ) then

		if ( !IsValid( self.projectedLight ) ) then

			self:BuildLight()

		end

		if ( !self.att_ViewModel ) then

			self.att_ViewModel = self.Owner:GetViewModel()

		end

		local att = self.att_ViewModel:GetAttachment( 1 )

		if ( att and LocalPlayer():GetActiveWeapon() == self ) then

			self.projectedLight:SetPos( att.Pos )
			self.projectedLight:SetAngles( att.Ang )
			rememberang = att.ang

		end

		if ( self.projectedLight:GetNearZ() != 1 ) then

			self.projectedLight:SetNearZ( 1 )

		end

		self.projectedLight:Update()

	elseif ( CLIENT && !self:GetActive() ) then

		if ( IsValid( self.projectedLight ) ) then

			self.projectedLight:SetNearZ( 0 )
			self.projectedLight:Update()

		end

	end

	local speed = self.Owner:GetVelocity():LengthSqr()

	if ( speed > 1000 && speed < 22500 ) then

		self.IdleSequence = "walk"

	elseif ( speed >= 22500 ) then

		self.IdleSequence = "Sprint"

	else

		self.IdleSequence = "Idle"

	end

	if ( ( self.IdleDelay || 0 ) < CurTime() || self.b_IdleSequence && self.IdleSequence != self.Old_IdleSequence ) then

		self.IdleDelay = CurTime() + 2
		self:PlaySequence( self.IdleSequence )

		self.b_IdleSequence = true
		self.Old_IdleSequence = self.IdleSequence

	end

end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 1.5 )

	self.IdleDelay = CurTime() + 1
	self.b_IdleSequence = nil
	self:PlaySequence( "ToggleLight" )

	timer.Simple( .25, function()

		if ( !( self && self:IsValid() ) ) then return end

		if ( self:GetActive() ) then

			self:EmitSound( "nextoren/weapons/items/flashlight/flashlight_off.wav", 75, 100, 0.6, CHAN_WEAPON )

		else

			self:EmitSound( "nextoren/weapons/items/flashlight/flashlight_on.wav", 90, 100, 0.6, CHAN_WEAPON )

		end

		if ( CLIENT ) then

			if ( !IsValid( self.projectedLight ) ) then

				self:BuildLight()

			end

			return
		end

		if ( self:GetActive() ) then

			self:SetActive( false )

		else

			self:SetActive( true )

		end

	end )

end

function SWEP:Holster()

	if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + .45
		self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )
		self:PlaySequence( "Holster" )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

		if ( CLIENT ) then

			if ( IsValid( self.projectedLight ) && self.projectedLight:GetNearZ() != 0 ) then

				self.projectedLight:SetNearZ( 0 )
				self.projectedLight:Update()

			end

			hook.Add("PreRender", "ManualFlashLightThink", function()
				if !LocalPlayer():HasWeapon("weapon_flashlight") or !IsValid(self) or self:GetOwner() != LocalPlayer() then
					hook.Remove("PreRender", "ManualFlashLightThink")
					return
				end

				if LocalPlayer():GetActiveWeapon() != self then

					if ( !IsValid( self.projectedLight ) ) then

							self:BuildLight()

						end

					local bone = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone("ValveBiped.Bip01_Pelvis") )
					local ang = LocalPlayer():EyeAngles()

					ang.p = 0
					ang.y = ang.y+2

					self.projectedLight:SetPos( bone+ang:Right()*7 )
					self.projectedLight:SetAngles( ang )

				if ( self.projectedLight:GetNearZ() != 1 ) then

							self.projectedLight:SetNearZ( 1 )

						end

					--self.projectedLight:Update()

				end


			end)

		else

			if SERVER then if IsValid(self.bnmrg) then self.bnmrg:SetInvisible(false) end end

		end

		return true

	end

	self.IdleDelay = CurTime() + .5
	self.b_IdleSequence = nil

end

function SWEP:Equip(Owner)

	if !IsValid(Owner.FlashLightBonemerge) then
		Owner.FlashLightBonemerge = Bonemerge("models/cultist/items/flashlight/bonemerge.mdl", Owner)
		self.bnmrg = Owner.FlashLightBonemerge
	else
		self.bnmrg = Owner.FlashLightBonemerge
	end

end

local light_clr = Color( 198, 198, 198, 250 )

function SWEP:BuildLight()

	self.projectedLight = ProjectedTexture()
	self.projectedLight:SetEnableShadows( false )
	self.projectedLight:SetFarZ( 885 )
	self.projectedLight:SetBrightness(2.2)
	self.projectedLight:SetFOV( 76 )
	self.projectedLight:SetColor( color_white )
	self.projectedLight:SetTexture( "nextoren/flashlight/flashlight001" )

end

function SWEP:OnDrop()

	if ( CLIENT && self.projectedLight ) then

		self.projectedLight:SetNearZ( 0 )
		self.projectedLight:Update()

	end

	if SERVER then
		if IsValid(self.bnmrg) then
			self.bnmrg:Remove()
		end
	end

end


function SWEP:OnRemove()

	if ( CLIENT && self.projectedLight ) then

		self.projectedLight:SetNearZ( 0 )
		self.projectedLight:Update()
		self.projectedLight:Remove()
		hook.Remove("PreRender", "ManualFlashLightThink")

	end

	if IsValid(self.bnmrg) then self.bnmrg:Remove() end

	return true

end

function SWEP:CanSecondaryAttack()

  return false

end

--function SWEP:CalcViewModelView( ent, oldPos, oldAng, pos, ang ) end
