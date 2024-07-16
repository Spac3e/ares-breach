local mply = FindMetaTable("Player")

function mply:SetSpectator(spawn)
    self:Flashlight(false)
    self:AllowFlashlight(false)
    self:StripWeapons()
    self:RemoveAllAmmo()
    self:SetRoleName(role.Spectator)
    self:SetGTeam(TEAM_SPEC)
    self:SetModel("models/props_junk/watermelon01.mdl")
    self:SetNoDraw(true)
    self:SetNoTarget(true)
    self:SetMoveType(MOVETYPE_NOCLIP)
    self:InvalidatePlayerForSpectate()

    if spawn then
        local spawnpos = table.Random(BREACH.MainMenu_Spawns)
        self:SetPos(spawnpos[1])
        self:SetEyeAngles(spawnpos[2])
    end

    self:Spectate(OBS_MODE_ROAMING)
    self:SetObserverMode(OBS_MODE_ROAMING)

    self.Active = true
    self.BaseStats = nil
    self.UsingArmor = nil
    self.canblink = false
    self.handsmodel = nil
    self.alreadyselectedscp = false
end

function mply:InvalidatePlayerForSpectate()
    local roam = #self:GetValidSpectateTargets() < 1
    for k, v in pairs(player.GetAll()) do
        if v:GTeam() == TEAM_SPEC then
            if v != self then
                if v:GetObserverTarget() == self then
                    if roam then
                        v:UnSpectate()
                        v:Spectate(OBS_MODE_ROAMING)
                        v:SetObserverMode(OBS_MODE_ROAMING)
                    else
                        v:SpectatePlayer(1)
                    end
                end
            end
        end
    end
end

function mply:GetValidSpectateTargets(all)
    local plys = {}

    for k, v in pairs(player.GetAll()) do
        if all then
            table.insert(plys, v)
        else
            if v:GTeam() != TEAM_SPEC and not v.supported then
                table.insert(plys, v)
            end
        end
    end

    return plys
end

function mply:SpectatePlayer(offset)
    if self:GTeam() ~= TEAM_SPEC then return end

    self:SetMoveType(MOVETYPE_NOCLIP)

    local plys = self:GetValidSpectateTargets()
    if self:GetObserverMode() == OBS_MODE_ROAMING and #plys > 0 then
        self:Spectate(OBS_MODE_CHASE)
        self:SetObserverMode(OBS_MODE_CHASE)
    elseif #plys < 1 then
        self:UnSpectate()
        self:Spectate(OBS_MODE_ROAMING)
        self:SetObserverMode(OBS_MODE_ROAMING)
        return
    end

    local cur_target = self:GetObserverTarget()
    local index = 1

    if IsValid(cur_target) then
        for i, v in ipairs(plys) do
            if v == cur_target then
                index = i + offset
                break
            end
        end
    end

    if index < 1 then
        index = #plys
    elseif index > #plys then
        index = 1
    end

    local target = plys[index]

    if target ~= cur_target then
        self:SpectateEntity(target)
    else
        self:SpectateEntity(nil)
    end
end

function mply:ChangeSpectateMode()
    if self:GTeam() != TEAM_SPEC then return end

    local cur_mode = self:GetObserverMode()

    if #self:GetValidSpectateTargets() < 1 then
        if cur_mode != OBS_MODE_ROAMING then
            self:UnSpectate()
            self:Spectate(OBS_MODE_ROAMING)
            self:SetObserverMode(OBS_MODE_ROAMING)
            self:SetMoveType(MOVETYPE_NOCLIP)
        end
        return
    end

    if cur_mode == OBS_MODE_ROAMING then
        self:Spectate(OBS_MODE_CHASE)
        self:SetObserverMode(OBS_MODE_CHASE)
        self:SpectatePlayer(1)
        self:SetMoveType(MOVETYPE_NOCLIP)
    elseif cur_mode == OBS_MODE_CHASE then
		self:SendLua("current_observer = nil")
		self:UnSpectate()
		self:Spectate(OBS_MODE_ROAMING)
		self:SetObserverMode(OBS_MODE_ROAMING)
		self:SpectateEntity(nil)
    end
end

function GM:KeyPress(ply, key)
    if ply:GTeam() != TEAM_SPEC or ply:IsBot() then return end

    local movetype = ply:GetMoveType()
    if movetype != MOVETYPE_NOCLIP then
        ply:SetMoveType(MOVETYPE_NOCLIP)
    end

    if key == IN_ATTACK then
        ply:SpectatePlayer(1)
    elseif key == IN_ATTACK2 then
        ply:SpectatePlayer(-1)
    elseif key == IN_RELOAD then
        ply:ChangeSpectateMode()
    end
end

