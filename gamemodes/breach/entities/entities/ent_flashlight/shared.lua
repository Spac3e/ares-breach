AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )
ENT.Type = "anim"
ENT.PrintName = "cw flashlight"

function ENT:Initialize()

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()
		self.Enabled = true

	end

	if ( SERVER ) then

		self:PhysicsInit( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )

	end

end

if SERVER then return end

local matLight = Material( "sprites/light_ignorez" )
local mathclamp = math.Clamp
local renderdrawsprite = render.DrawSprite
local rendersetmaterial = render.SetMaterial
local pixvis = util.PixelVisible
function ENT:DrawEffects()
	if !self.Enabled then return end

	local LightNrm = self:GetAngles():Forward()
	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * -1 )
	local LightPos = self:GetPos() + LightNrm * 5

	if ( ViewDot >= 0 ) then

		rendersetmaterial( matLight )
		local Visibile = pixvis( LightPos, 50, self.PixVis )

		if ( !Visibile ) then return end

		Size = mathclamp( Distance * Visibile * ViewDot * 1.5, 64, 512 )
		local dist = mathclamp( Distance, 32, 930)
		if dist > 250 then
			Size = ((1000 -dist) * Visibile * ViewDot / 2)
		end
		Distance = mathclamp( Distance, 32, 800 )

		local Alpha = mathclamp( ( 1000 - Distance ) * Visibile * ViewDot, 0, 100 )

		local Col = self:GetColor()
		Col.a = Alpha

		renderdrawsprite( LightPos, Size, Size, Col )
		renderdrawsprite( LightPos, Size, Size, Col )
		renderdrawsprite( LightPos, Size, Size, Col )
		renderdrawsprite( LightPos, Size, Size, Col )

	end

end

-- We have to do this to ensure DrawTranslucent is called for Opaque only models to draw our effects
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:DrawTranslucent( flags )
	BaseClass.DrawTranslucent( self, flags )
	self:DrawEffects()
end

function ENT:Draw()
end