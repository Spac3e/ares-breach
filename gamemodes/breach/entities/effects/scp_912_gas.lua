function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local scale = data:GetScale()

	local emitter = ParticleEmitter(pos)

	for i=0,100 do
		local particle = emitter:Add("particle/smokesprites_000"..math.random(1,9), pos)
		particle:SetVelocity(Vector(math.Rand(-20,20), math.Rand(-20,20), math.Rand(-2,30)))
		particle:SetDieTime(15)
		particle:SetStartAlpha(45)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(2,4)*scale)
		particle:SetEndSize(math.Rand(5,15)*scale)
		particle:SetRoll(math.Rand(1,50))
		particle:SetRollDelta(math.Rand(-0.2,0.2))
		particle:SetColor(0, 98, 0)
		particle:SetAirResistance(0)
	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
