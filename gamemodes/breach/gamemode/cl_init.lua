function OUTSIDE_BUFF( pos )
	if pos.z > 1350 then
		return true
	end
end

-- [[ Include Gamemode files ]] --
include("core/sh_core.lua")
include("shared.lua")