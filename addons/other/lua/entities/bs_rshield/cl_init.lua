--[[


addons/[weapons]_ballistic_shields/lua/entities/bs_rshield/cl_init.lua

--]]

include('shared.lua')
include( "ballistic_shields/cl_bs_util.lua" ) 
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()  
	if(bshields.config.rShieldTexture == "") then self:DrawModel() return end
	local webmat = surface.GetURL(bshields.config.rShieldTexture, 256, 256)
	
	if ( self.Mat ) then
		render.MaterialOverrideByIndex( 1, self.Mat )
	end 
	local html_mat = webmat
	local matdata =
	{
        ["$basetexture"]=html_mat:GetName(),
        ["$decal"] = 1,
        ["$translucent"] = 1
	}

	local uid = string.Replace( html_mat:GetName(), "__vgui_texture_", "" )

	self.Mat = CreateMaterial( "bshields_webmat_"..uid, "VertexLitGeneric", matdata )
	self:DrawModel()
	render.ModelMaterialOverride( nil )
end   