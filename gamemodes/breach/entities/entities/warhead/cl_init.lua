include("shared.lua")

--[[
net.Receive( "TurnSound", function()

	local time = net.ReadUInt( 8 )
	local sound = net.ReadString()

	timer.Create( "NukeTimer", time - 1, 1, function() end)

	surface.PlaySound( sound )

end)]]

net.Receive("AlphaWarheadTimer_CLIENTSIDE", function()
	local time = tonumber(net.ReadString())
	local remove = net.ReadBool()
	
	if remove then
		timer.Remove("NukeTimer")
	else
		timer.Create("NukeTimer", time - 1, 1, function() end)
	end
end)

function ENT:Draw()
   --self:DrawModel()
end