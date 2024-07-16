AddCSLuaFile()
ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self:SetModel("models/hunter/plates/plate4x24.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	self:SetRenderMode( 1 )

	if ( SERVER ) then

		self:SetTrigger( true )

	end

end

function ENT:Think()

  if ( CLIENT ) then return end

  return true

end

function ENT:ShouldCollide( ply )

	if ( self.approved_teams[ ply:Team() ] ) then

		return false

	else

		return true

	end

end

function ENT:StartTouch( ply )

	if ( !ply:IsPlayer() ) then return end

	if ( !self:ShouldCollide( ply ) ) then return end

	ply:SetVelocity( -ply:GetVelocity() * 12 )

	if ( ( ply.SZTipTime || 0 ) > CurTime() ) then return end
	ply.SZTipTime = CurTime() + 3

	ply:Tip( 3, "[Ares Breach]", Color( 210, 0, 0, 180 ), "Вам незачем туда идти, выполняйте основную задачу.", color_white )

end

function ENT:Draw()

	--self:DrawModel()
	self:DestroyShadow()

	--[[local pl = LocalPlayer()

	if ( !self:ShouldCollide( pl ) ) then return end

	local pos = self:GetRotatedVec(self.Entity:GetPos() + self.Entity:GetUp() * 54 + self.Entity:GetRight() * -32)
	local dir = self.Entity:GetForward()

	local mins, maxs = self:GetCollisionBounds()

	local w = math.floor(math.max(maxs.x, maxs.y) / 32)

	for i = 1, w, 1 do

		if ( w == 1 ) then

			i = 1.15

		end

		local pos = self.Entity:GetPos() + self.Entity:GetUp() * 2

	end]]

end
