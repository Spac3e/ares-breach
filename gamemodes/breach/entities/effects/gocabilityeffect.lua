AddCSLuaFile()

local matRefract = Material("sprites/heatwave")
local matLight	= Material("models/effects/vol_light001")

local particles = {}
particles.model = "models/hunter/tubes/circle2x2c.mdl"
particles.scale = 1
particles.xSpeed = 20
particles.ySpeed = 20
particles.zSpeed = 20
particles.solid = SOLID_NONE
particles.ent = "prop_physics"
particles.move = MOVETYPE_FLY
--particles.material = matRefract

--[[---------------------------------------------------------
Initializes the effect. The data is a table of data
which was passed from the server.
-----------------------------------------------------------]]
function EFFECT:Init( data )
	-- This is how long the spawn effect
	-- takes from start to finish.

	self.Time = 2
	self.LifeTime = CurTime() + self.Time

	local ent = data:GetEntity()
	if ( ent.IsInfected ) then

		self.Reversed = true

	else

		self.Reverse = false

	end

	self.Fraction = 0

	--[[local pos = ent:EyePos()

	if pos:DistToSqr(data:GetOrigin()) < 0.3 then
		self.Reverse = true
	end]]

	if ( !IsValid( ent ) ) then return end
	if ( !ent:GetModel() ) then return end

	self.ParentEntity = ent
	self:SetModel( ent:GetModel() )
	self:SetPos( ent:GetPos() )
	self:SetAngles( ent:GetAngles() )
	self:SetParent( ent )

	self.ParentEntity.RenderOverride = self.RenderParent
	self.ParentEntity.SpawnEffect = self
end


--[[---------------------------------------------------------
THINK
Returning false makes the entity die
-----------------------------------------------------------]]
function EFFECT:Think( )

	if ( !IsValid( self.ParentEntity ) ) then return false end

	local PPos = self.ParentEntity:GetPos();
	self:SetPos( PPos + (EyePos() - PPos):GetNormal() )

	if ( self.LifeTime > CurTime() ) then return true end

	self.ParentEntity.RenderOverride = nil
	self.ParentEntity.SpawnEffect = nil

	return false

end

function EFFECT:Render() end
--[[---------------------------------------------------------
Draw the effect
-----------------------------------------------------------]]
function EFFECT:RenderOverlay( entity )

	local Fraction = (self.LifeTime - CurTime()) / self.Time
	local ColFrac = (Fraction-0.5) * 2

	Fraction = math.Clamp( Fraction, 0, 1 )
	ColFrac = math.Clamp( ColFrac, 0, 1 )


	-- Place the camera a tiny bit closer to the entity.
	-- It will draw a big bigger and we will skip any z buffer problems

	local Pos
	if ( entity:IsPlayer() ) then

		local EyeNormal = entity:GetPos() - EyePos()
		local Distance = EyeNormal:Length()
		EyeNormal:Normalize()

		Pos = EyePos() + EyeNormal * Distance * 0.01

	else

		Pos = entity:GetPos()

	end

	-- Start the new 3d camera position
	local bClipping = self:StartClip( entity, 1.2 )
	cam.Start3D( Pos, EyeAngles() )

	-- If our card is DX8 or above draw the refraction effect
	if ( render.GetDXLevel() >= 80 ) then

		-- Update the refraction texture with whatever is drawn right now
		render.UpdateRefractTexture()

		--matRefract:SetFloat( "$refractamount", Fraction * 0.1 )

		-- Draw model with refraction texture
		render.MaterialOverride( matRefract )
		entity:DrawModel()
		render.MaterialOverride( 0 )

	end

	-- Set the camera back to how it was
	cam.End3D()
	render.PopCustomClipPlane()
	render.EnableClipping( bClipping );

end


function EFFECT:RenderParent()
--gamemodes/breach/entities/effects/gocabilityeffect.lua:141: attempt to call method 'StartClip' (a nil value)

	local bClipping = self.SpawnEffect:StartClip( self, 1 )
	self:DrawModel()
	render.PopCustomClipPlane()
	render.EnableClipping( bClipping );

	self.SpawnEffect:RenderOverlay( self )

end


function EFFECT:StartClip( model, spd )

	local mn, mx = model:GetRenderBounds()
	local Up = (mx-mn):GetNormal()
	local Bottom = model:GetPos() + mn;
	local Top = model:GetPos() + mx;

	--local Fraction = (self.LifeTime - CurTime()) / self.Time
	--Fraction = math.Clamp( Fraction / spd, 0, 1 )
	self.Fraction = math.Approach( self.Fraction, 1, FrameTime() * 0.1 )

	local Lerped = nil
	if self.Reverse then
		Lerped = LerpVector( self.Fraction, Top, Bottom )
	else
		Lerped = LerpVector( self.Fraction, Bottom, Top )
	end

	local normal = Up
	local distance = normal:Dot( Lerped );

	local bEnabled = render.EnableClipping( true );
	render.PushCustomClipPlane( normal, distance );

	return bEnabled

end
