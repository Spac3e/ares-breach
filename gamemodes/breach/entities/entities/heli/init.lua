
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local candealdmg = {
    [TEAM_CHAOS] = true
}

local evacteams = {
    [TEAM_GUARD] = true,
    [TEAM_NTF] = true,
    [TEAM_SCI] = true,
    [TEAM_SECURITY] = true,
    [TEAM_SPECIAL] = true,
    [TEAM_CLASSD] = true,
    [TEAM_OSN] = true,
    [TEAM_QRT] = true
}

function ENT:Initialize()
    self:SetModel("models/scp_helicopter/resque_helicopter.mdl")

    self:SetPos(Vector(439, 4600, 3311.947998))
	self:SetAngles(Angle(0, 90, -15))

    self:StartMotionController()

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

    self:SetSequence("rotating")
    self:ResetSequenceInfo()
    self:SetCycle(0)
    self:SetPlaybackRate(1)

    self:SetBodygroup(2, 3)
    self:SetBodygroup(3, 0)

	self:LinearMotion(Vector(-2773, 4717, 3147), 175, function()
        self:AngleMotion(Angle(0,0,0), 25)

        self:LinearMotion(Vector(-3475, 4778, 2507), 75, function()
            self:EmitSound("nextoren/vo/chopper/chopper_evacuate_start_" .. math.random(1,7) .. ".wav")

            self:AddGestureSequence(self:LookupSequence("door_open"), true)

            timer.Simple(0.190, function()
                self:AddGestureSequence(self:LookupSequence("door_opened"), false)
            end)
        end)
    end)

    self.CreationTimeThink = 0
    self.CreationTime = 0

    self:SetHealth(8250)
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

    if self:Health() < 3000 then
        if not self.damaged_snd then
            self.damaged_snd = CreateSound(self, "nextoren/others/helicopter/apache_damage_alarm.wav")
            self.damaged_snd:Play()
        end
    end

    if self.CreationTime == 55 then
        self.CreationTime = self.CreationTime + 1

        self:EmitSound("nextoren/vo/chopper/chopper_thirty_left.wav")
    elseif self.CreationTime == 85 then
        self.CreationTime = self.CreationTime + 1
        self:EmitSound("nextoren/vo/chopper/chopper_ten_left.wav")
    elseif self.CreationTime == 95 then
        self.CreationTime = self.CreationTime + 1
        self:StopMotions()
        
        self:Evacuate()

        timer.Simple(2, function()
            self:AngleMotion(Angle(0,0,-15), 25)
        end)

        self:AddGestureSequence(self:LookupSequence("door_close"), true)

        timer.Simple(0.190, function()
            self:AddGestureSequence(self:LookupSequence("door_closed"), false)
        end)

        self:EmitSound("nextoren/vo/chopper/chopper_evacuate_end.wav")
        self:SetBodygroup(3, 2)

        self:LinearMotion(Vector(-3465, 9961, 3655), 165, function()
            self:Remove()
        end)
    end

    self:NextThink(CurTime())
    return true
end
 
function ENT:Explode()
    self:StopMotions()

    for _, ply in ipairs(player.GetAll()) do
        if ply:GTeam() == TEAM_CHAOS and ply:Alive() then
            ply:AddToStatistics("l:choppa_bonus", 700)
            BREACH.Players:ChatPrint(ply, true, true, "l:ci_choppa_down")
        end
    end
    
    self:Ignite(15)
    
    self.fall_snd = CreateSound(self, "nextoren/others/helicopter/helicopter_explosion_start.wav")
    self.fall_snd:Play()

    local hitpos = GroundPos(self:GetPos())

    self:LinearMotion(hitpos, 150, function()
        local pos = self:GetPos()

        self:Extinguish()

        self:EmitSound("nextoren/others/helicopter/helicopter_explosion.wav")

        net.Start( "CreateParticleAtPos" )
            net.WriteString( "missile_hit_seFluidExplosio" )
            net.WriteVector( pos )
        net.Broadcast()

        if self.fall_snd then
            self.fall_snd:Stop()
        end

        local explosion_damage = DamageInfo()
        explosion_damage:SetDamageType(DMG_BLAST)
        explosion_damage:SetDamage(500)
        explosion_damage:SetInflictor(self)
        explosion_damage:SetAttacker(game.GetWorld())

        util.BlastDamageInfo(explosion_damage, hitpos, 500)

        self:Remove()
    end, "easeOut")
end

function ENT:Evacuate()
    local persci = 50
    local perspecial = 150

    local scientists = 0
    local specials = 0

    for _, ply in ipairs(ents.FindInBox(Vector(-3164, 4517, 2491), Vector(-3909, 5186, 2839))) do
        if not IsValid(ply) or not ply:IsPlayer() then continue end
        if not evacteams[ply:GTeam()] then continue end

        if ply:GTeam() == TEAM_CLASSD and not (ply:GetUsingCloth() == "armor_sci" or ply:GetUsingCloth() == "armor_medic") then return end

        if ply:GTeam() == TEAM_SCI and not ply:GetRoleName() == "Head of Personnel" then
            scientists = scientists + 1
        elseif ply:GTeam() == TEAM_SPECIAL or ply:GetRoleName() == "Head of Personnel" or ply:GetRoleName() == "Head of Facility" then
            specials = specials + 1
        end

        if ply:HasWeapon("item_special_document") then
            ply:AddToStatistics("Доставка особо важных документов фонда.", 1200)
        end

        if ply:GTeam() == TEAM_NTF or ply:GTeam() == TEAM_GUARD and not ply:GetRoleName() == "Head of Facility" then
            if scientists > 0 then
                local xpforuchiki = persci * scientists
                ply:AddToStatistics("l:sci_evac", xpforuchiki)
            elseif specials > 0 then
                local xpforspecials = perspecial * specials
                ply:AddToStatistics("l:sci_evac", xpforspecials)
            end
        end

        ply:Evacuate()
        ply:EndingHUD("Evacuated by Helicopter")
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

function ENT:OnRemove()
    if self.damaged_snd then
        self.damaged_snd:Stop()
    end
end

scripted_ents.Register(ENT, "helicopter")