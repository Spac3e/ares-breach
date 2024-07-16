
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local candealdmg = {
	[TEAM_GUARD] = true,
	[TEAM_NTF] = true,
	[TEAM_SCI] = true,
	[TEAM_SECURITY] = true,
	[TEAM_SPECIAL] = true,
	[TEAM_CLASSD] = true,
	[TEAM_OSN] = true,
	[TEAM_QRT] = true
}

local evacteams = {
	[TEAM_CHAOS] = true,
	[TEAM_CLASSD] = true	
}

function ENT:Initialize()
    self:SetModel("models/scp_chaos_jeep/chaos_jeep.mdl")

	self:SetPos(Vector(2430, 7498, 1515))
	self:SetAngles(Angle(0, 90, 0))

    self:StartMotionController()

	for _ ,v in pairs(ents.FindInSphere((Vector(2435, 7194, 1607)), 100)) do
		if v:GetClass() == "func_door" then v:Fire("Open") end
	end

    self:SetCollisionGroup(COLLISION_GROUP_VEHICLE)
    self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetRenderMode(RENDERMODE_NORMAL)
    self:SetSolidFlags(bit.bor(FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS))

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:EnableCollisions(true)
        phys:EnableDrag(false)
    end

    self:SetSequence("driving")
    self:ResetSequenceInfo()
    self:SetCycle(0)
    self:SetPlaybackRate(1)

	self:LinearMotion(Vector(2442, 6847, 1515), 65, function()
        self:ResetSequenceInfo()
        self:SetCycle(0)
        self:SetPlaybackRate(0)

		self:SetBodygroup(1, 1)
	end)

    self.CreationTimeThink = 0
    self.CreationTime = 0

    self:SetHealth(15250)
end

function ENT:LinearMotion(endpos, speed, onComplete)
    if not IsValid(self) then return end

    self.LinearMotionCache = self.LinearMotionCache or {}
    self.LinearMotionCache[self:GetClass()] = self.LinearMotionCache[self:GetClass()] or {}

    local motionData = self.LinearMotionCache[self:GetClass()]
    local ratio = 0
    local startpos = self:GetPos()
    local distance = (endpos - startpos):Length()
    local duration = distance / speed

    if duration <= 0 then
        if onComplete then onComplete() end
        return
    end

    timer.Create(self:GetClass() .. "_Vector_motion", 0, 0, function()
        if not IsValid(self) then return end

        ratio = ratio + engine.TickInterval() / duration
        ratio = math.Clamp(ratio, 0, 1)

        self:SetPos(LerpVector(ratio, startpos, endpos))

        if ratio >= 1 then
            self:SetPos(endpos)
            timer.Remove(self:GetClass() .. "_Vector_motion")
            
            if onComplete then onComplete() end
        end
    end)
end

function ENT:AngleMotion(endAngles, speed, onComplete)
    if not IsValid(self) then return end

    self.AngleMotionCache = self.AngleMotionCache or {}
    self.AngleMotionCache[self:GetClass()] = self.AngleMotionCache[self:GetClass()] or {}

    local motionData = self.AngleMotionCache[self:GetClass()]
    local ratio = 0
    local startAngles = self:GetAngles()

    local angDiffYaw = math.AngleDifference(endAngles.yaw, startAngles.yaw)
    local angDiffPitch = math.AngleDifference(endAngles.pitch, startAngles.pitch)
    local angDiffRoll = math.AngleDifference(endAngles.roll, startAngles.roll)
    local maxAngleDiff = math.max(math.abs(angDiffYaw), math.abs(angDiffPitch), math.abs(angDiffRoll))
    local duration = maxAngleDiff / speed

    if duration <= 0 then
        if onComplete then onComplete() end
        return
    end

    timer.Create(self:GetClass() .. "_Angle_motion", 0, 0, function()
        if not IsValid(self) then return end

        ratio = ratio + engine.TickInterval() / duration
        ratio = math.Clamp(ratio, 0, 1)

        local lerpedAngles = Angle(
            Lerp(ratio, startAngles.pitch, endAngles.pitch),
            Lerp(ratio, startAngles.yaw, endAngles.yaw),
            Lerp(ratio, startAngles.roll, endAngles.roll)
        )

        self:SetAngles(lerpedAngles)

        if ratio >= 1 then
            self:SetAngles(endAngles)
            timer.Remove(self:GetClass() .. "_Angle_motion")
            
            if onComplete then onComplete() end
        end
    end)
end

function ENT:StopMotions()
    if timer.Exists(self:GetClass() .. "_Vector_motion") then
        timer.Remove(self:GetClass() .. "_Vector_motion")
    end

    if timer.Exists(self:GetClass() .. "_Angle_motion") then
        timer.Remove(self:GetClass() .. "_Angle_motion")
    end

    self.LinearMotionCache = nil
    self.AngMotionCache = nil
end

function ENT:Think()
    if (self.CreationTimeThink or 0) < CurTime() then
        self.CreationTimeThink = CurTime() + 1
        self.CreationTime = self.CreationTime + 1
    end

    if self.CreationTime == 98 then
		self:SetSequence("driving")
		self:ResetSequenceInfo()
		self:SetCycle(0)
		self:SetPlaybackRate(1)

		self:SetBodygroup(1, 0)

        for _ ,v in pairs(ents.FindInSphere((Vector(2435, 7194, 1607)), 100)) do
            if v:GetClass() == "func_door" then v:Fire("Open") end
        end    

		self:Evacuate()

		self:LinearMotion(Vector(2430, 7498, 1515), 65, function()
			self:Remove()
		end)
    end

    self:NextThink(CurTime())
    return true
end
 
function ENT:Explode()
    self:StopMotions()

	local pos = self:GetPos()

	self:EmitSound("nextoren/others/helicopter/explode1.wav")

	net.Start( "CreateParticleAtPos" )
		net.WriteString( "missile_hit_seFluidExplosio" )
		net.WriteVector( pos )
	net.Broadcast()

	local explosion_damage = DamageInfo()
	explosion_damage:SetDamageType(DMG_BLAST)
	explosion_damage:SetDamage(500)
	explosion_damage:SetInflictor(self)
	explosion_damage:SetAttacker(game.GetWorld())

	util.BlastDamageInfo(explosion_damage, pos, 1500)

	self:Remove()
end

function ENT:Evacuate()
    local perclassd = 50

    local classds = 0

    for _, ply in ipairs(ents.FindInBox(Vector(2258, 7037, 1512), Vector(2666, 6681, 1694))) do
        if not IsValid(ply) or not ply:IsPlayer() then continue end
        if not evacteams[ply:GTeam()] then continue end

        if ply:GTeam() == TEAM_CLASSD then
            classds = classds + 1
        end

        if ply:GTeam() == TEAM_CHAOS then
            if classds > 0 then
                local xpfordeshkus = perclassd * classds
                ply:AddToStatistics("l:sci_evac", xpfordeshkus)
            end
        end

        ply:Evacuate()
        ply:EndingHUD("Evacuated by CI")
    end
end

function ENT:OnTakeDamage(dmginfo)
    if dmginfo:GetAttacker() and dmginfo:GetAttacker():IsPlayer() and candealdmg[dmginfo:GetAttacker():GetGTeam()] then
        
        if self:Health() <= 0  or dmginfo:GetDamageType() == DMG_BLAST then
            self:Explode()
            
            return
        end

        self:SetHealth(self:Health() - dmginfo:GetDamage())
    end

    return
end

scripted_ents.Register(ENT, "apc")