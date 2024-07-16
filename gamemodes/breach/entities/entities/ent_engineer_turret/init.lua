AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/codbo/other/autoturret.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:CollisionRulesChanged()

    self:SetAutomaticFrameAdvance(true)

    if self:GetOwner() == NULL then self:SetOwner(self) end
    
	self.fLastTargetCheck = CurTime()
	self.fNextFire = CurTime()

    self:SetTargetVisible(false)
	self:SetLastTargetLock(0)
	self:SetFOVLimit(360)
    self:Activate()

	self.udari = 0
	self.maxudari = 5
end

function ENT:Use(caller)
    if (caller == self:GetOwner()) then
        caller:SetSpecialMax(caller:GetSpecialMax() + 1)
        caller:SetSpecialCD(CurTime() + 3)
        self:Remove()
    end

	if (caller.nextuseturret or 0) > CurTime() then
		return
	end

	caller.nextuseturret = CurTime() + 0.5

	if caller:GTeam() == TEAM_SCP and not caller.IsZombie then
		self.udari = self.udari + 1

		self:EmitSound("nextoren/doors/door_break.wav", 75, 100, 1, CHAN_AUTO)
	end

	if self.udari >= self.maxudari then
		self:Remove()
	end
end

function ENT:ResetGun()
	self:ManipulateBoneAngles(3, Angle(0,0,0))
end

function ENT:StartScanning()
	self.bIsScanning = true

    self:ResetGun()
end

function ENT:StopScanning()
	self.bIsScanning = false
end

function ENT:IsScanning()
	return self.bIsScanning
end

function ENT:GetGunPos()
    return self:GetBonePosition(3)
end

function ENT:GetTargetPos()
	if (!IsValid(self:GetTarget())) then return Vector(0,0,0) end

	local targettorsopos = self:GetTarget():GetBonePosition(2, 0)
	return targettorsopos and targettorsopos or self:GetTarget():WorldSpaceCenter()
end

function ENT:GetGunAngle()
	return (self:GetTargetPos() - self:GetGunPos()):Angle()
end

/*
function ENT:GetDamage()
	if (6 > 1 and nzRound and isfunction(nzRound.GetNumber)) then
		local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
		local health = nzCurves.GenerateHealthCurve(round)

		if (isnumber(health)) then
			return health / 6
		end
	end

	return IsValid(self:GetTarget()) and self:GetTarget():Health() * 2 or 500
end
*/

function ENT:Think()
	if self.fLastTargetCheck + 0.5 < CurTime() and not self:HasValidTarget() then
		self:SetTarget(self:GetPriorityTarget())
	end

	if not self:HasValidTarget() then 
		if (CurTime() - self:GetLastTargetLock() > 1) then
			if not self:IsScanning() then
				self:StartScanning()
			end

			self:ResetSequence(1)
		end
		
		if SERVER and self:GetTargetVisible() then
			self:SetTargetVisible(false)
		end
		return
	end

	self:SetLastTargetLock(CurTime())
	self:ResetSequence(0)

	if (self:IsScanning()) then
		self:StopScanning()
	end

	local gunangles = self:WorldToLocalAngles(self:GetGunAngle())
	if !self:CanRotate(gunangles) then return end

    self:ManipulateBoneAngles(3, gunangles)

    if self.fNextFire < CurTime() then
        if not self.NextTracerEffect or (self.NextTracerEffect and CurTime() > self.NextTracerEffect) then
            self.NextTracerEffect = CurTime() + 0.15

            --local effectData = EffectData()
            --effectData:SetEntity(self)
            --effectData:SetOrigin(self:GetTargetPos())
            --effectData:SetStart((self:GetGunPos()) + Vector(0,0,10))
            --effectData:SetAngles(self:GetGunAngle())
            --effectData:SetScale(5000)
            --util.Effect("AR2Tracer", effectData, false)

            local effectData = EffectData()
            effectData:SetEntity(self)
            effectData:SetOrigin((self:GetGunPos() + Vector(0,0,8)) + self:GetGunAngle():Forward() * 40)
            effectData:SetScale(0.3)
            util.Effect("MuzzleEffect", effectData)
        end
    end

	if SERVER then
		if self.fNextFire < CurTime() then

            local bullet = {
				Attacker = self,
				Damage = 50,
				Force = 3,
				Src = self:GetGunPos(),
				Dir = self:GetGunAngle():Forward(),
				Distance = 1200 * 2,
				Spread = Vector(0.1, 0.1, 0),
				Tracer = 99999
			}

            self:EmitSound("engi_turret/turret_fire.wav")
			self:FireBullets(bullet)

			self.fNextFire = CurTime() + math.Rand(0.2, 0.4)
		end
	end
end

function ENT:SetTarget(target)
	self.eTarget = target
end

function ENT:GetTarget()
	return self.eTarget
end

function ENT:HasValidTarget()
	return IsValid(self:GetTarget()) and self:GetTarget():GTeam() == TEAM_SCP and self:GetPos():Distance(self.eTarget:GetPos()) < 1200 and self.eTarget:Health() > 0 and self:GetEnemyVisible(self.eTarget)
end

function ENT:CanRotate(angles)
	if !angles then return false end

	local deg = math.abs(angles[2]) 
	if deg > self:GetFOVLimit() then return false end
	
	return true
end

function ENT:GetEnemyVisible(ent)
    if SERVER then
        local trace = util.TraceLine({
            start = self:GetGunPos(),
            endpos = ent:WorldSpaceCenter(),
            filter = self
        })
        local vis = trace.Entity == ent
        self:SetTargetVisible(vis)
        return vis
    end
end

function ENT:GetPriorityTarget()
	self.fLastTargetCheck = CurTime()

	local possibleTargets = ents.FindInSphere(self:GetPos(), 1200)

	local players = {}

	for _, ent in pairs(possibleTargets) do
		if ent:IsPlayer() and ent:GTeam() == TEAM_SCP then
			table.insert(players, ent)
		end
	end

	return players[math.floor(util.SharedRandom("TurretTarg" .. self:EntIndex(), 1, #players))]
end