include('shared.lua')

function ENT:Initialize()
	local bounds = Vector(4096,4096,4096)
	self:SetRenderBounds( -bounds, bounds, bounds )
	self.shakeScale = 0
end

function ENT:Draw()
	if LocalPlayer():GTeam() == TEAM_SPEC then return end
	if LocalPlayer():GTeam() == TEAM_COTSK then return end
	local tr = util.TraceLine({
		start = EyePos(),
		endpos = self:GetPos(),
		filter = {LocalPlayer(), self, Entity(0)}
	})
	if not tr.Hit and self:GetPos() != Vector(-676.172058, 6937.478027, 2070.031250) then
		local oldAng = EyeAngles()
		local newAng = (self:GetPos() - EyePos()):Angle()
		local lerpAng = LerpAngle(FrameTime() * 10,oldAng,newAng)
		LocalPlayer():SetEyeAngles(lerpAng)
		self.shakeScale = math.min(self.shakeScale + (FrameTime() * 1), 1)
	else
		if EyeAngles().r ~= 0 then
			LocalPlayer():SetEyeAngles(Angle(EyeAngles().p, EyeAngles().y, 0))
		end
		self.shakeScale = math.max(self.shakeScale - (FrameTime() * 0.5), 0)
	end
	util.ScreenShake( EyePos(), self.shakeScale, 60, 0.2, 256 )
end