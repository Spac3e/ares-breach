function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local scale = data:GetScale()

	local emitter = ParticleEmitter(pos)

	for i=0,4 do
		local particle = emitter:Add("particle/smokesprites_000"..math.random(1,9), pos)
		particle:SetVelocity(Vector(math.Rand(-2,2), math.Rand(-2,2), math.Rand(20,75)))
		particle:SetDieTime(math.Rand(2,7))
		particle:SetStartAlpha(45)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3,4)*scale)
		particle:SetEndSize(math.Rand(5,15)*scale)
		particle:SetRoll(math.Rand(180,255))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,12,12)
		particle:SetAirResistance(150)
	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
