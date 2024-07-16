function EFFECT:Init(data)

	self.Position = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()

	local emitter = ParticleEmitter(self.Position)
		
		local particle = emitter:Add("sprites/heatwave", self.Position)
		particle:SetVelocity((100*self.Forward + 25*VectorRand())*math.sqrt(self.Scale))
		particle:SetDieTime(math.Rand(0.15,0.2))
		particle:SetStartSize(math.Rand(20,25)*self.Scale)
		particle:SetEndSize(10*self.Scale)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetAirResistance(160)

		for i=0,1 do
		local particle = emitter:Add("particle/smokesprites_000"..math.random(1,9), self.Position)
		particle:SetVelocity(100*i*self.Forward*math.sqrt(self.Scale))
		particle:SetDieTime(math.Rand(0.2,0.3))
		particle:SetStartAlpha(math.Rand(20,25))
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(3,4)*self.Scale)
		particle:SetEndSize(math.Rand(15,20)*self.Scale)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-3,3))
		particle:SetColor(220,220,220)
		particle:SetAirResistance(150)
		end

		for i=0,5 do
		local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position+(self.Forward*i*2))
		particle:SetVelocity(self.Forward*i*120*math.sqrt(self.Scale))
		particle:SetDieTime(0.075)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(199)
		particle:SetStartSize(35-i*self.Scale)
		particle:SetEndSize((50-i)*self.Scale)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,255,255)
		end

		for i=-2,2 do
		local particle = emitter:Add("effects/muzzleflash"..math.random(1,4), self.Position+(self.Forward*i*2))
		particle:SetVelocity(self.Right*i*35*math.sqrt(self.Scale))
		particle:SetDieTime(0.075)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(199)
		particle:SetStartSize((35-i)*self.Scale)
		particle:SetEndSize((50-i)*self.Scale)
		particle:SetRoll(math.Rand(180,480))
		particle:SetRollDelta(math.Rand(-1,1))
		particle:SetColor(255,255,255)
		end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end