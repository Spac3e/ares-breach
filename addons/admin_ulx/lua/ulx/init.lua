if not ulx then
	ulx = {}

	-- Get data folder up to speed
	include( "data.lua" )

	local sv_modules = file.Find( "ulx/modules/*.lua", "LUA" )
	local sh_modules = file.Find( "ulx/modules/sh/*.lua", "LUA" )
	local cl_modules = file.Find( "ulx/modules/cl/*.lua", "LUA" )


	include( "sh_defines.lua" )
	include( "lib.lua" )
	include( "base.lua" )
	include( "sh_base.lua" )
	include( "log.lua" )

	for _, file in ipairs( sv_modules ) do
		include( "modules/" .. file )
	end

	for _, file in ipairs( sh_modules ) do
		include( "modules/sh/" .. file )
	end

	include( "end.lua" )

	AddCSLuaFile( "ulx/cl_init.lua" )
	AddCSLuaFile( "ulx/sh_defines.lua" )
	AddCSLuaFile( "ulx/sh_base.lua" )
	AddCSLuaFile( "ulx/cl_lib.lua" )

	-- Find c-side modules and load them
	for _, file in ipairs( cl_modules ) do
		AddCSLuaFile( "ulx/modules/cl/" .. file )
	end

	for _, file in ipairs( sh_modules ) do
		AddCSLuaFile( "ulx/modules/sh/" .. file )
	end
end
