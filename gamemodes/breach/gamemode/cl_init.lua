function OUTSIDE_BUFF( pos )
	if pos.z > 1350 then
		return true
	end
end

-- [[ Include Gamemode files ]] --
include("libraries/sh_boot.lua")
include("shared.lua")