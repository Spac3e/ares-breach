include("shared.lua")

function ENT:Draw()
	self:SetRenderAngles(Angle(0,0,0))
	self:DrawModel()
end
