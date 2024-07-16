SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.PrintName = "SCP-294"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.WorldModel = "models/vinrax/props/cup_294.mdl"
SWEP.ViewModel = "models/shaky/items/scp/scp294/v_scp294.mdl"
SWEP.InvIcon = Material( "nextoren/gui/icons/scp294.png", "noclamp smooth" )
SWEP.HoldType = "items"
SWEP.UseHands = true
SWEP.IsDrinking = nil

SWEP.Pos = Vector( -4, -3, 0 )
SWEP.Ang = Angle( -180, 0, 90 )

if CLIENT then

  function draw.Circle( x, y, radius, seg )

    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )

    for i = 0, seg do

      local a = math.rad( ( i / seg ) * -360 )

      table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    end

    local a = math.rad( 0 ) 

    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )

  end

end

function SWEP:CreateWorldModel()

	if ( !self.WModel ) then

		self.WModel = ClientsideModel( self.WorldModel, RENDERGROUP_OPAQUE )
		self.WModel:SetNoDraw( true )

	end

	return self.WModel

end

function SWEP:Equip(owner)

  if self.drink == "tnt" then


    local self = owner

    owner:CompleteAchievement("tnt")

    local current_pos = self:GetPos()

    self.abouttoexplode = nil

    self.burnttodeath = true

      local dmg_info = DamageInfo()
      dmg_info:SetDamage( 2000 )
      dmg_info:SetDamageType( DMG_BLAST )
      dmg_info:SetAttacker( self )
      dmg_info:SetDamageForce( -self:GetAimVector() * 40 )

      util.BlastDamageInfo( dmg_info, self:GetPos(), 400 )

      sound.Play("nextoren/others/explosion_ambient_" .. math.random( 1, 2 ) .. ".ogg", current_pos, 100, 100, 100)

      net.Start( "CreateParticleAtPos" )

        net.WriteString( "pillardust" )
        net.WriteVector( current_pos )

      net.Broadcast()

      net.Start( "CreateParticleAtPos" )

        net.WriteString( "gas_explosion_main" )
        net.WriteVector( current_pos )

      net.Broadcast()

  end

end

function SWEP:OnTakeDamage(dmginfo)

  if self.drink == "tnt" then


    local self = dmginfo:GetAttacker()

    owner:CompleteAchievement("tnt")

    local current_pos = self:GetPos()

    self.abouttoexplode = nil

    self.burnttodeath = true

      local dmg_info = DamageInfo()
      dmg_info:SetDamage( 2000 )
      dmg_info:SetDamageType( DMG_BLAST )
      dmg_info:SetAttacker( self )
      dmg_info:SetDamageForce( -self:GetAimVector() * 40 )

      util.BlastDamageInfo( dmg_info, self:GetPos(), 400 )

      sound.Play("nextoren/others/explosion_ambient_" .. math.random( 1, 2 ) .. ".ogg", current_pos, 100, 100, 100)

      net.Start( "CreateParticleAtPos" )

        net.WriteString( "pillardust" )
        net.WriteVector( current_pos )

      net.Broadcast()

      net.Start( "CreateParticleAtPos" )

        net.WriteString( "gas_explosion_main" )
        net.WriteVector( current_pos )

      net.Broadcast()

  end

  self:Remove()

end

function SWEP:Initialize()

  self:SetHoldType( self.HoldType )

  self:AddEFlags(EFL_NO_DAMAGE_FORCES)

  self.drink_color = Color(255,255,255)

  self.BlockDrag = true

  timer.Simple(0, function()
    local col = Color(self:GetNWInt("r", 255),self:GetNWInt("g", 255),self:GetNWInt("b", 255))
    self.drink_color = col
  end)

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

      local draw_pos = pos + ang:Right() * self.Pos.x + ang:Forward() * self.Pos.y + ang:Up() * self.Pos.z

			wm:SetRenderOrigin( draw_pos )
			wm:SetRenderAngles( ang )
			wm:DrawModel()

      cam.Start3D2D( draw_pos + ang:Up()*3.2, ang, 1 )

        surface.SetDrawColor( self.drink_color )

        draw.NoTexture()

        draw.Circle( 0, 0, 2, 20 )

      cam.End3D2D()

		end

	else

		self:DrawModel()

	end

end

function SWEP:Deploy()

  if ( !IsFirstTimePredicted() ) then return end

  local col = Color(self:GetNWInt("r", 255),self:GetNWInt("g", 255),self:GetNWInt("b", 255))
  self.drink_color = col

  self.IdleDelay = CurTime() + .5
  self.HolsterDelay = nil
  self:PlaySequence( "deploy" )
  timer.Simple( .25, function()

    if ( self && self:IsValid() ) then

      self:EmitSound( "weapons/m249/handling/m249_armmovement_02.wav", 75, math.random( 100, 120 ), 1, CHAN_WEAPON )

    end

  end )

end

function SWEP:Think()

	if ( ( self.IdleDelay || 0 ) < CurTime() && !self.IdlePlaying ) then

		self.IdlePlaying = true
		self:PlaySequence( "idle", true )

	end

end

local siptosound = {
  "ahh",
  "beurk",
  "burn",
  "cough",
  "slurp",
  "spit",
}

local view_punch_angle = Angle( -15, 0, 0 )

function SWEP:PrimaryAttack()

  if ( self.IsDrinking ) then return end
  self.IsDrinking = true

  self.IdleDelay = CurTime() + 4

  self:PlaySequence( "use" )

  timer.Simple( .5, function()

    if ( !( self && self:IsValid() ) ) then return end
    if ( !( self.Owner && self.Owner:IsValid() ) ) then return end

    self.Owner:ViewPunch( view_punch_angle )

  end )

  if ( CLIENT ) then return end

  if SERVER then
    self.Owner:EmitSound("scp294/"..self.sip..".ogg")
  end

  timer.Simple( 1, function()

    if ( !( self && self:IsValid() ) ) then return end
    if ( !( self.Owner && self.Owner:IsValid() ) ) then return end

    if self.effect then
    	self.effect(self.Owner, self.SCP294)
    end

    timer.Simple( .25, function()

      if ( self && self:IsValid() ) then

        self:Remove()

      end

    end )

  end )

end

function SWEP:Holster()

  if ( self.IsDrinking ) then return false end

  if ( !self.HolsterDelay ) then

		self.HolsterDelay = CurTime() + 1
    self.IdleDelay = CurTime() + 1.5
    self:EmitSound( "weapons/m249/handling/m249_armmovement_01.wav", 75, math.random( 80, 100 ), 1, CHAN_WEAPON )
    self:PlaySequence( "holster" )

	end

	if ( ( self.HolsterDelay || 0 ) < CurTime() ) then return true end

end

function SWEP:SecondaryAttack()

  return false

end
