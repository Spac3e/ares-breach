--[[
addons/294/lua/entities/scp294cup/cl_init.lua
--]]
include("shared.lua")

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

function ENT:Draw()
	self:DrawModel()
	
	if not self:GetNWBool("WasDrunk")  then
		local ang = self:GetAngles()
		local col = self.FluidColor
		cam.Start3D2D( self:GetPos() + ang:Up()*3.2, ang, 1 )
			surface.SetDrawColor( col.r, col.g, col.b, col.a )
			draw.NoTexture()
			draw.Circle( 0, 0, 2, 20 )
		cam.End3D2D()
	end
end  
 
function ENT:Think()

end


