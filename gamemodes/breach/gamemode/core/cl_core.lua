net.Receive('PlayClientSound', function()
	local cs_sound = net.ReadString()

	surface.PlaySound(cs_sound)
end)

function OUTSIDE_BUFF( pos )
	if pos.z > 1350 then
		return true
	end
end