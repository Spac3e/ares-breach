local folderList = file.Find( "hab/modules/*.lua", "LUA" )

AddCSLuaFile( "hab/modules/base.lua" )
include( "hab/modules/base.lua" )
hab.modules[ 0 ] = "base.lua"

for i, f in pairs(folderList) do
	if f != "base.lua" then -- base is loaded separatley
		AddCSLuaFile( "hab/modules/" .. f )
		include( "hab/modules/" .. f )

		hab.modules[i] = f
	end
end