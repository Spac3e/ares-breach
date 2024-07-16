AddCSLuaFile()

ENT.Type 			= "anim"
ENT.RenderGroup 		= RENDERGROUP_OPAQUE
ENT.NukeIcon 				= Material( "nextoren/nuke/nuke_monitor" )
ENT.Pos = Vector( -36.187725, -7187.614746, -2239.251465 )
ENT.Angles = Angle(90, 90, 0 )

ENT.Loading_Mat = Material( "nextoren/nuke/nuke_monitor" )
ENT.Main_Mat = Material( "nextoren/nuke/nuke_redux" )

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Loaded" )
	self:SetLoaded( false )

end

function ENT:Initialize()

	self:SetModel( "models/hunter/plates/plate4x24.mdl" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )

  self:SetAngles( self.Angles )
	self:SetPos( self.Pos )

	if ( SERVER ) then

	  timer.Simple( 10, function()

	    self:SetLoaded( true )

	  end )

	end

end

function ENT:GetRotatedVec(vec)

	local v = self:WorldToLocal( vec )
	v:Rotate( self:GetAngles() )

	return self:LocalToWorld( v )

end

local clr_red = Color( 255, 0, 0 )
local vec_offset = Vector( -2.1, 0, -35 )
local angle_offset = Angle( -90, 90, 90 )

function ENT:Draw()

  local oang = self:GetAngles()
  local opos = self:GetPos()

  local ang = self:GetAngles()
  local pos = self:GetPos()

  ang:RotateAroundAxis( oang:Up(), 90 )
  ang:RotateAroundAxis( oang:Right(), -90 )
  ang:RotateAroundAxis( oang:Up(), -0 )

  self:DestroyShadow()

	local pl = LocalPlayer()

	local up = self.Entity:GetUp()

	local pos = self:GetRotatedVec( self.Entity:GetPos() + up * 54 + self.Entity:GetRight() * -32)

	local mins, maxs = self:GetCollisionBounds()

	if ( self:GetLoaded() ) then

		self.NukeIcon = self.Main_Mat

	else

		self.NukeIcon = self.Loading_Mat

	end

	if ( !self.NukeIcon ) then return end

	local pos = self.Entity:GetPos() + up * 2
	render.SetMaterial( self.NukeIcon )
	render.DrawQuadEasy(
		pos,
		up,
		16, 16,
		color_white,
		180
	)

	render.SetMaterial( self.NukeIcon )
	render.DrawQuadEasy(
		pos,
		-up,
		16, 16,
		color_white,
		180
	)

  local DistanceFromMonitor = pl:GetPos():DistToSqr( self:GetPos() )

  if ( DistanceFromMonitor < 250000 && self:GetLoaded() && ( timer.TimeLeft( "NukeTimer" ) || 0 ) > 0 ) then

    cam.Start3D2D( self:GetPos() - vec_offset, self:GetAngles() + angle_offset, .1 )

      draw.SimpleText( string.ToMinutesSeconds( timer.TimeLeft( "NukeTimer" ) ), "RadioOFFONFont", 0, 400, clr_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    cam.End3D2D()

  end

end
