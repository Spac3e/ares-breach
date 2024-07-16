AddCSLuaFile()

if ( CLIENT ) then

  SWEP.InvIcon = Material( "nextoren/gui/icons/scp/409.png" )

end

SWEP.Category = "NextOren"
SWEP.PrintName = "SCP-409"
SWEP.ViewModel = "models/cultist/scp_items/409/v_scp_409.mdl"
SWEP.WorldModel = "models/cultist/scp_items/409/w_scp_409.mdl"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Weight = 12
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.HoldType = "knife"

SWEP.UseHands = true
SWEP.AttackDelay = 1

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Equip()

  if ( self.Owner && !self.Owner.Infected409 && !( self.Owner:HasHazmat() || self.Owner:GetRoleName() == role.ClassD_FartInhaler || self.Owner:GetRoleName() == role.MTF_Chem || self.Owner:GetRoleName() == role.DZ_Gas ) ) then

    self.Owner:Start409Infected()

  end

end

function SWEP:Deploy()

  self:SendWeaponAnim( ACT_VM_DRAW )

  if ( self.Owner && !self.Owner.Infected409 && !( self.Owner:HasHazmat() || self.Owner:GetRoleName() == role.ClassD_FartInhaler || self.Owner:GetRoleName() == role.MTF_Chem || self.Owner:GetRoleName() == role.DZ_Gas ) ) then

    self.Owner:Start409Infected()

  end

end

function SWEP:Think()

  if ( ( self.NextThinkt || 0 ) >= CurTime() ) then return end

  self.NextThinkt = CurTime() + 1.2
  self:SendWeaponAnim( ACT_VM_IDLE )

end

local traceData = { }

function SWEP:PrimaryAttack()

  if ( ( self.NextAttack || 0 ) >= CurTime() ) then return end

  self.NextAttack = CurTime() + 1.2
  self.NextThinkt = CurTime() + 1.2

  self.Owner:LagCompensation( true )

    local eyeAngles = self.Owner:EyeAngles()
    local forward = eyeAngles:Forward()

    traceData.start = self.Owner:GetShootPos()
    traceData.endpos = traceData.start + forward * 68

    traceData.mins = Vector( -15, -15, -15 )
    traceData.maxs = Vector( 30, 30, 30 )

    traceData.filter = { self.Owner }

    local trace = util.TraceHull( traceData )

  self.Owner:LagCompensation( false )

  if ( trace.Hit ) then

    local ent = trace.Entity
    self:SendWeaponAnim( ACT_VM_SWINGHIT )

    if ( !ent:IsPlayer() ) then return end

    if ent:GetRoleName() == "SCP173" then return end

    if ( CLIENT ) then

      timer.Simple( .1, function()

        for _, v in ipairs( ents.FindInSphere( self.Owner:GetPos(), 60 ) ) do

          if ( v:GetClass() == "prop_ragdoll" && v:GetMaterial() == "ice_tool/ice_texture" ) then

            ParticleEffectAttach( "steam_manhole", PATTACH_ABSORIGIN_FOLLOW, v, 1 )

          end

        end

      end )

    end

    if ( SERVER ) then

      if ( ent:GTeam() == TEAM_SCP ) then

        ent:Start409Infected()

      else

        ent:SCP409Infect()

      end

      timer.Simple( .2, function()

        self:Remove()

      end )

    end

  else

    self:SendWeaponAnim( ACT_VM_MISSCENTER )

  end

end

function SWEP:CanSecondaryAttack()

  return false

end
