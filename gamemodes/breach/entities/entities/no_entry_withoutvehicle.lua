AddCSLuaFile()
ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT
ENT.SZClipZone			= true

--local cyb_mat = Material("overlays/fbi_openup")

function ENT:Initialize()

	self:SetModel("models/hunter/plates/plate4x24.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

	self:SetRenderMode( 1 )

	if ( SERVER ) then

		self:SetTrigger( true )

	end

end

function ENT:GetRotatedVec(vec)

	local v = self:WorldToLocal(vec)
	v:Rotate(self:GetAngles())

	return self:LocalToWorld( v )
end

local approved_Teams = {

	[ TEAM_CLASSD ] = true,
	[ TEAM_SCI ] = true,
	[ TEAM_SPECIAL ] = true,
	[ TEAM_CHAOS ] = true,
	[ TEAM_DZ ] = true,
	[ TEAM_GOC ] = true

}

function ENT:ShouldCollide(ply)

	if ( ply:IsPlayer() ) then

		if ( ply:InVehicle() && approved_Teams[ ply:Team() ] ) then

	    return false

	  else

	    return true

	  end

	end

	return false

end

function ENT:StartTouch( ply )

	if ( self:ShouldCollide( ply ) ) then

		local vel = ply:GetVelocity() * -8
		vel[3] = math.Clamp(vel[3], 0, 10)

		ply:SetVelocity( vel )

		ply.SZTipTime = ply.SZTipTime || 0

		if ply.SZTipTime > CurTime() then return end

		--[[Started Touch]]--
		ply.SZTipTime = CurTime() + 5

		if ( !ply:InVehicle() ) then

    	ply:Tip(3, "Пытаться сбежать пешком быссмысленно, Вам нужна машина", Color( 255, 0, 0 ) )

		else

			ply:Tip(3, "Вам нельзя спастись этим методом!", Color( 255, 0, 0 ) )
			ply:ExitVehicle()
			ply:SetVelocity( vel * -25 )

		end

	end

end

function ENT:Draw()

	self:DestroyShadow()


end
