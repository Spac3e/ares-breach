--from nextoren 1.0
local ANGLE = FindMetaTable("Angle")

function ANGLE:CalculateVectorDot( vec )
	local x = self:Forward():DotProduct( vec )
	local y = self:Right():DotProduct( vec )
	local z = self:Up():DotProduct( vec )

	return Vector( x, y, z )
end

--[[ HeadBob  Functions ]]--

local step = 0
local MovementDot = { x = 0, y = 0, z = 0 }
local vel = 0
local cos = 0
local plane = 0
local scale = 1
local y = 0

local team_spec_index, team_scp_index = TEAM_SPEC, TEAM_SCP

local forbidden_teams = {

	[ TEAM_SPEC ] = true,
	[ TEAM_SCP ] = true

}

hook.Add( "Think", "ViewBob_Think", function()

	local client = LocalPlayer()

	if ( !forbidden_teams[ client:GTeam() ] && client:Health() > 0 && client:GetMoveType() != MOVETYPE_NOCLIP ) then

		vel = client:GetVelocity()
		MovementDot = EyeAngles():CalculateVectorDot( vel )
		--print( MovementDot )
		step = 18

		if ( client:Health() < client:GetMaxHealth() * .3 ) then

			scale = 2
			step = 20

		end

		cos = math.cos( SysTime() * step )
		plane = ( math.max( math.abs( MovementDot.x ) - 100, 0 ) + math.max( math.abs( MovementDot.y ) - 100, 0 ) ) / 128

		y = math.cos( SysTime() * step / 2 ) * plane * scale

	end

end )

local vec_zero = vector_origin

hook.Add( "CalcViewModelView", "CalcViewModel", function( wep, v, oldPos, oldAng, ipos, iang )

	local client = LocalPlayer()

	if client:GetInDimension() then return end

	if ( !forbidden_teams[ client:GTeam() ] && client:Health() > 0 && ( ( !isnumber( vel ) && vel:Length2DSqr() > .25 ) || client:GetVelocity():Length2DSqr() > .25 ) && client:GetMoveType() != MOVETYPE_NOCLIP ) then

		local pos, ang

		if ( isfunction( wep.GetViewModelPosition ) ) then

			pos, ang = wep:GetViewModelPosition( ipos, iang )

		else

			pos = ipos
			ang = iang

		end

		local origin = Vector( 0, y, ( cos * plane ) * scale )
		origin:Rotate( ang )

		return origin + pos - ( transition != 0 && Vector( 0, 0, transition ) || vec_zero ), ang

	end

end )


local cam_1_lerp = 0
local cam_wait = 0
local cam_mode = 0

function GM:CalcView( ply, origin, angles, fov )

	local data = {}
	data.origin = origin
	data.angles = angles
	data.fov = fov
	data.drawviewer = false

	if ply:GetInDimension() and ply:GTeam() != TEAM_SCP then
		data.angles = angles + Angle(math.Rand(-0.5,0.5),math.Rand(-0.5,0.5),0)
		return data
	end
	
	if ply:GetTable()["br_camera_mode"] then
		my_cam_fov = math.Approach(my_cam_fov, cam_fov, FrameTime()*30)
		data.fov = my_cam_fov
		data.angles.p = data.angles.p + 20
		if cam_wait == 0 then
			if cam_mode == 1 then
				cam_1_lerp = math.Approach(cam_1_lerp, -30, FrameTime()*8)
				if cam_1_lerp == -30 then
					cam_wait = 2
					cam_mode = 0
				end
			else
				cam_1_lerp = math.Approach(cam_1_lerp, 30, FrameTime()*8)
				if cam_1_lerp == 30 then
					cam_wait = 2
					cam_mode = 1
				end
			end
		else
			cam_wait = math.Approach(cam_wait, 0, FrameTime())
		end
		data.angles.y = data.angles.y - cam_1_lerp
		return data
	end

	if ( !forbidden_teams[ ply:GTeam() ] && ply:Health() > 0 && ( ( !isnumber( vel ) && vel:Length2DSqr() > .25 ) || ply:GetVelocity():Length2DSqr() > .25 ) && ply:GetMoveType() != MOVETYPE_NOCLIP ) then

		local pos = Vector( 0, y, ( cos * plane ) * scale )
		pos:Rotate( EyeAngles() )

		data.origin.x = origin.x + pos.x
		data.origin.y = origin.y + pos.y
		data.origin.z = origin.z + pos.z

		data.angles.p = angles.p + ( math.abs( math.cos( SysTime() * step / 2 ) ) * ( MovementDot.x || 1 ) / 400 ) * scale
		data.angles.y = angles.y + ( y / 6.4 )
		data.angles.r = angles.r + ( y / 4 ) * scale

	end

	local wep = ply:GetActiveWeapon()

	if ( wep != NULL && wep.CalcView ) then

		local vec, ang, ifov = wep:CalcView( ply, origin, angles, fov )

		data.origin = vec
		data.angles = ang
		data.fov = ifov

	end

	if ( ply.RealLean != 0 && ply:IsSolid() ) then

		if ( !ply.RealLean ) then

			ply.RealLean = 0

			return
		end

		local lean = ply.RealLean

		data.angles:RotateAroundAxis( data.angles:Forward(), lean )
		data.origin = data.origin + data.angles:Right() * lean

	end

	if ( ply.FOVTest && ply.FOVTest > 0 ) then

		if ( ply.FOVStartDecrease ) then

			ply.FOVTest = math.Approach( ply.FOVTest, 0, RealFrameTime() * 10 )

		end

		data.fov = data.fov - ply.FOVTest

	end

	--data.drawviewer = true
	--dir = dir || vector_origin

	--data.origin = ply:GetPos() + Vector( 0, -80, 74 )
	--data.angles = Angle( 10, 90, 0 )

	if ply:GTeam() == TEAM_SPEC then
		data.angles.r = 0
	end

	return data

end
