-- convinience function: is a position solid
local function IsSolid(pos)
	return bit.band(util.PointContents(pos), CONTENTS_SOLID) == CONTENTS_SOLID
end

-- convinience function: gets maximum size of a blood pool at a given pos
-- ensures that blood pools don't appear floating in the air
local function GetMaximumPoolSize(pos, normal, limit)
	local limit = limit or 50
	
	--if GetConVar("bloodpool_cheap"):GetInt() == 1 then return limit end

	local fraction = 1
	
	-- how far down we're allowed to go before failing the check
	local dn_dist = 4

	for size=1,limit,fraction do
		local dir = size
		-- this looks very silly, but it works.
		local spots = {
			pos + Vector(0, dir, 0),
			pos + Vector(dir, 0, 0),
			pos + Vector(dir, dir, 0),
			pos + Vector(dir, -dir, 0),
			pos + Vector(0, -dir, 0),
			pos + Vector(-dir, -dir, 0),
			pos + Vector(-dir, 0, 0),
			pos + Vector(-dir, dir, 0)
		}
	
		for i=1,#spots do
			local spos = spots[i] + Vector(0,0,1)
			local epos = spots[i] + Vector(0,0,-dn_dist)
			
			-- if the startpos is solid we're probably in a wall.
			if not IsSolid(spos) then
				local tr = util.TraceLine({start=spos, endpos=epos, mask=MASK_DEADSOLID})
				
				if not tr.Hit then
					return (size-fraction)
				end
			end
		end
	end
	
	return limit
end

function EFFECT:Init(data)	
	local bone = data:GetAttachment() or 0
	local flags = data:GetFlags() or 0 -- 1: ttt mode, no fading
	local color = data:GetColor()

	local ent = data:GetEntity()
	self.Entity = ent
	
	if flags == 0 then
		local lifetime = 100000
		self.LifeTime = CurTime() + lifetime
	end

	--[[
	self.Entity = ent
	self.BoneID = bone]]
	self.BloodColor = color
	--[[
	self.LastPos = ent:GetPos()]]
	self.Origin = data:GetOrigin()

	self.BloodTime = CurTime() + math.random(2,5)
	self.MaxBloodTime = CurTime() + 20 -- we don't want to loop our calculations for potentially ever
	
	-- weird bug: think function happens before all the variables are set
	self.Initialized = true
	self.Iteration = CL_BLOOD_POOL_ITERATION

end

function EFFECT:Think()
	if not self.Initialized then return true end

	if (self.LifeTime and self.LifeTime < CurTime()) or (not self.Iteration or self.Iteration ~= CL_BLOOD_POOL_ITERATION) then
		-- todo: make dying blood pools fade
		if self.BloodPool then
			self.BloodPool:SetLifeTime(0)
			self.BloodPool:SetDieTime(0.05)
			self.BloodPool:SetStartSize(0)
			self.BloodPool:SetEndSize(0)
		end
		
		if self.ParticleEmitter and self.ParticleEmitter:IsValid() then
			self.ParticleEmitter:SetNoDraw(true)
			self.ParticleEmitter:Finish()
		end
		
		return false
	end

	local pos = self.Origin

	if not self.BloodPool then
		if not self.ParticleEmitter then
			self.ParticleEmitter = ParticleEmitter(pos, true)
		end

		if CurTime() >= self.BloodTime and CurTime() < self.MaxBloodTime then
			local tr = util.TraceLine({start=pos + Vector(0,0,32), endpos=pos + Vector(0,0,-128), mask=MASK_DEADSOLID})

			if tr.Hit then
				-- pull out of the ground a bit
				local pos = tr.HitPos + tr.HitNormal * 0.005
				
				local minsize = 50
				local maxsize = 75

				if IsValid(self.ent) and self.ent:IsPlayer() and self.ent:Health() > 0 then
					minsize = 30
					maxsize = minsize
				end
				
				if minsize > maxsize then
					minsize = maxsize
				end
				
				local size = GetMaximumPoolSize(pos, tr.HitNormal, math.random(minsize,maxsize))
				
				-- don't bother unless we can get a decent pool
				if size > 5 then
					self.StartBleedingTime = CurTime()
					self.EndSize = size

					local pos = tr.HitPos
					local ang = tr.HitNormal:Angle()
					
					ang.roll = math.random(0,360)
					
					local maxtime = (self.EndSize/50) * 10
					
					local textures = BLOOD_POOL_TEXTURES[self.BloodColor]
					
					if not textures then return end
					
					local particle = self.ParticleEmitter:Add(table.Random(textures), tr.HitPos)
					particle:SetStartSize(0)
					particle:SetEndSize(self.EndSize * 1.2)
					particle:SetDieTime(maxtime * 1.2)
					particle:SetStartAlpha(225)
					particle:SetEndAlpha(225)
					particle:SetPos(pos)
					particle:SetAngles(ang)

					self.BloodPool = particle
				else
					-- wait a bit before trying again
					self.BloodTime = CurTime() + 1.0
				end
			end
		end
	else
		if self.ParticleEmitter and IsValid(self.ParticleEmitter) then
			self.ParticleEmitter:Finish()
		end
		
		-- keep the particle alive.
		local maxtime = (self.EndSize/50) * 10
		local timer = maxtime - ((self.StartBleedingTime + maxtime) - CurTime())

		local particle = self.BloodPool
		particle:SetLifeTime(math.min(timer, maxtime))
	end

	return true
end

function EFFECT:Render()
	-- :)
end