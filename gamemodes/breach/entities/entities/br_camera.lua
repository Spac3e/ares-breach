AddCSLuaFile()

ENT.Base        = "base_gmodentity"

ENT.Type        = "anim"
ENT.Category    = "Breach"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Model       = Model( "models/props_glackmesa/securitycamera.mdl" )

function ENT:SetupDataTables()
  self:NetworkVar("Bool", 0, "Broken")
  self:NetworkVar("Bool", 1, "Enabled")
end

function ENT:Initialize()

  self:SetModel( self.Model )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )

  self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

  local physobject = self:GetPhysicsObject()

  if ( physobject:IsValid() ) then

    physobject:EnableMotion( false )

  end

end

if SERVER then
  function ENT:Think()
    if IsValid(self:GetOwner()) then
      local owner = self:GetOwner()
      if owner:IsPlayer() and (owner:GTeam() == TEAM_SPEC or owner:Health() <= 0 or owner:GetViewEntity() != self) then
        self:SetEnabled(false)
        self:SetOwner(NULL)
      end
    end
  end
end

local glow = Material("sprites/lgtning")
function ENT:Draw()
  self:DrawModel()
  if self:GetEnabled() then
    local dlight = DynamicLight( self:EntIndex() )

    local drawpos = self:GetPos()
    local ang = self:GetAngles()

    drawpos = drawpos + ang:Forward()*16.5 + ang:Up()*9.5 + ang:Right()*1.85
    if ( dlight ) then
      dlight.pos = drawpos
      dlight.r = 255
      dlight.g = 0
      dlight.b = 0
      dlight.brightness = 1
      dlight.Decay = 1000
      dlight.Size = 60
      dlight.DieTime = CurTime() + 1
    end

    render.SetColorMaterial()
    render.DrawSphere(drawpos, 0.5, 15, 15, Color( 255, 0, 0 ))
  end
end