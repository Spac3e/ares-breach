--[[


addons/[weapons]_ballistic_shields/lua/ballistic_shields/cl_bs_util.lua

--]]

if SERVER then return end
include( "bs_config.lua" )

net.Receive( "bs_shield_info", function( len, pl )
	LocalPlayer().bs_shieldIndex = net.ReadUInt(16)	
end )

local Delay = 0
function bshields_materials_reload()
	for _,v in pairs(bshields.materialstoload) do
		Delay = Delay + 0.2
		timer.Simple( Delay, function() surface.GetURL(v[1], v[2], v[3]) end )
	end

	bshields.hshield_webmat = surface.GetURL(bshields.config.hShieldTexture, 256, 256)
	bshields.rshield_webmat = surface.GetURL(bshields.config.rShieldTexture, 256, 256)
	bshields.dshield_webmat = surface.GetURL(bshields.config.dShieldTexture, 256, 256)
end

bshields.materialstoload = {
	{bshields.config.hShieldTexture, 256, 256},
	{bshields.config.rShieldTexture, 256, 256},
	{bshields.config.dShieldTexture, 256, 256}
}

hook.Add( "InitPostEntity", "bshields_init_client", function()
	bshields_materials_reload()
end)
      
surface.CreateFont( "bshields.HudFont", {
	font = "BFHud",
	size = ScrH()/1080*18
})