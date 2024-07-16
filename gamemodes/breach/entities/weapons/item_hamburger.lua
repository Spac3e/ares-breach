if ( CLIENT ) then

	SWEP.InvIcon = Material( "nextoren/gui/icons/hamburger.png" )

end

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false

SWEP.PrintName		= "Гамбургер"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.WorldModel = "models/cultist/items/hamburger/w_hamburger.mdl"
SWEP.ViewModel = "models/cultist/items/hamburger/v_hamburger.mdl"
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
SWEP.Pos = Vector( -3, 2, -2 )
SWEP.Ang = Angle( 70, 240, 20 )

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

		local wm = self:CreateWorldModel()
		local pos, ang = self.Owner:GetBonePosition( bone )

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

function SWEP:Deploy()

	self.HolsterDelay = nil
	self.IdleDelay = CurTime() + 1
	self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )
	self:PlaySequence( "painpills_holster" )

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "painpills_idle", true )

	end

end

function SWEP:Holster()

	if ( self.CantHolster ) then return false end

	if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1
		self.IdleDelay = CurTime() + 1
		self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )
		self:PlaySequence( "painpills_draw" )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then

		return true

	end

end

local punch_angle = Angle( 2, 2, 2 )

function SWEP:PrimaryAttack()

	local tr = self.Owner:GetEyeTrace()

	local ent = tr.Entity

  if ( ( self.NextCall || 0 ) >= CurTime() ) then return end

  self.NextCall = CurTime() + 3

	self.CantHolster = true

	self.IdleDelay = CurTime() + 1
	self:PlaySequence( "eq_painpills_use" )

  timer.Simple( .7, function()

    if ( self && self:IsValid() ) then

      self.Owner:ViewPunch( punch_angle )

    end

  end )

  timer.Simple( 1, function()

    if ( SERVER ) then

      if ( self && self:IsValid() ) then

        if ( self.Owner:GetRoleName():find( "Fat" ) ) then

          self.Owner:SetHealth( self.Owner:GetMaxHealth() )
          self.Owner:BrTip( 0, "[Ares Breach]", Color(255,0,0, 210), "l:you_ate_burger", color_white )

        else

					local clamp_health = math.Clamp( self.Owner:Health() + ( self.Owner:GetMaxHealth() * .3 ), 0, self.Owner:GetMaxHealth() )
					local show_health = clamp_health - self.Owner:Health()
          self.Owner:SetHealth( clamp_health )
          self.Owner:BrTip( 0, "[Ares Breach]", Color(255,0,0, 210), "l:you_ate_burger_hp_regenerated_pt1 " .. show_health .. " l:you_ate_burger_hp_regenerated_pt2", color_white )

        end

				self:Remove()

      end

    end

  end )

end

function SWEP:SecondaryAttack()

  return false

end
