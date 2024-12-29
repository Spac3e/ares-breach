local mply = FindMetaTable( "Player" )
local ment = FindMetaTable( "Entity" )

function mply:EndingHUD(status)
	net.Start("Ending_HUD")
	net.WriteString(status)
	net.Send(self)
end

function mply:AddToMVP(name, amount)
    if not self.mvpstatistics then 
		self.mvpstatistics = {} 
	end

    local keyr = "l:" .. name
    local found = false

	if name == "heal" then keyr = "l:scp999_healing_bonus" end --  uhhh

    for i, stat in ipairs(self.mvpstatistics) do
        if stat.reason == keyr then
            stat.value = stat.value + amount
            found = true
            break
        end
    end

    if not found then
        table.insert(self.mvpstatistics, {reason = keyr, value = amount})
    end
end

function mply:Evacuate()
	local exptoget = 0
	local exptbl = {}
	local rtime = timer.TimeLeft("RoundTime")

	if rtime != nil then
		exptoget = (CurTime() - rtime) * 0.05
	else
		exptoget = 10
	end

	table.insert(exptbl, {reason = "l:survival_bonus", value = exptoget})

	if self.mvpstatistics then
		for _, v in ipairs(self.mvpstatistics) do
			table.insert(exptbl, {reason = v.reason, value = v.value})
		end

		self.mvpstatistics = {}
	end

	for _, wep in pairs(self:GetWeapons()) do
		if wep:GetClass() == "item_cheemer" then
			table.insert(exptbl, {reason = "l:cheemer_rescue", value = 1000})
			exptoget = exptoget + 1000
		end
	end

	if self:GTeam() == TEAM_USA and (m_UIUCanEscape == false or m_UIUCanEscape == nil) then
		self:EndingHUD("l:ending_mission_failed")
	elseif self:GTeam() == TEAM_USA and m_UIUCanEscape == true then
		table.insert(exptbl, {reason = "l:uiu_obj_bonus", value = 500})
		self:EndingHUD("l:ending_mission_complete")
	end
	
	if (self.kills and self.kills <= 0) or (self.teamkills and self.teamkills <= 0) then
		table.insert(exptbl, {reason = "l:pacifist", value = 100})
		exptoget = exptoget + 100
	end
	
	if self.kills and self.kills != 0 then 
		table.insert(exptbl, {reason = "l:enemykill", value = (self.kills * 25)})
		exptoget = exptoget + (self.kills * 25)
	end
	
	if self.teamkills and self.teamkills != 0 then 
		table.insert(exptbl, {reason = "l:teamkill", value = (self.teamkills * -250)})
		exptoget = exptoget + (self.teamkills * -250)
	end

	if self:IsPremium() then
		local positivexp = 0
		for _, xp in ipairs(exptbl) do
			if xp.value > 0 then
				positivexp = positivexp + xp.value
			end
		end
		table.insert(exptbl, {reason = "l:prem_bonus", value = positivexp})
		exptoget = exptoget + positivexp
	end

	net.Start("LevelBar")
	net.WriteTable(exptbl)
	net.WriteUInt(self:GetNEXP(), 32)
	net.Send(self)

	self:SetupNormal()
	self:SetSpectator(true)

	self:AddExp(exptoget)
end

function mply:LevelBar()
	local exptoget = 0
	local exptbl = {}
	local rtime = timer.TimeLeft("RoundTime")

	if rtime != nil then
		exptoget = (CurTime() - rtime) * 0.05
	else
		exptoget = 10
	end

	table.insert(exptbl, {reason = "l:survival_bonus", value = exptoget})

	if self.mvpstatistics then
		for _, v in ipairs(self.mvpstatistics) do
			table.insert(exptbl, {reason = v.reason, value = v.value})
		end

		self.mvpstatistics = {}
	end
	
	if (self.kills and self.kills < 0) or (self.teamkills and self.teamkills < 0) then
		table.insert(exptbl, {reason = "l:pacifist", value = 100})
		exptoget = exptoget + 100
	end
	
	if self.kills and self.kills != 0 then 
		table.insert(exptbl, {reason = "l:enemykill", value = (self.kills * 25)})
		exptoget = exptoget + (self.kills * 25)
	end
	
	if self.teamkills and self.teamkills != 0 then 
		table.insert(exptbl, {reason = "l:teamkill", value = (self.teamkills * -250)})
		exptoget = exptoget + (self.teamkills * -250)
	end
	
	if self:IsPremium() then
		local positivexp = 0
		for _, xp in ipairs(exptbl) do
			if xp.value > 0 then
				positivexp = positivexp + xp.value
			end
		end
		table.insert(exptbl, {reason = "l:prem_bonus", value = positivexp})
		exptoget = exptoget + positivexp
	end

	net.Start("LevelBar")
	net.WriteTable(exptbl)
	net.WriteUInt(self:GetNEXP(), 32)
	net.Send(self)

	self:AddExp(exptoget)
end

function mply:AddToStatistics(reason, value)
	if not self.mvpstatistics then
		self.mvpstatistics = {}
	end

	table.insert(self.mvpstatistics, {reason = reason, value = value})
end

function mply:SetForcedAnimation(sequence, endtime, startcallback, finishcallback, stopcallback)
	if sequence == false then
		self:StopForcedAnimation()
		return
	end	
	  
	if isstring(sequence) then sequence = self:LookupSequence(sequence) end
	self:SetCycle(0)
	self.ForceAnimSequence = sequence
	
	time = endtime
	
	if endtime == nil then
		time = self:SequenceDuration(sequence)
	end		  

	net.Start("BREACH_SetForcedAnimSync")
	net.WriteEntity(self)
	net.WriteUInt(sequence, 20) -- seq cock
	net.Broadcast()
	
	if isfunction(startcallback) then startcallback() end
	
	self.StopFAnimCallback = stopcallback
	
	timer.Create("SeqF"..self:EntIndex(), time, 1, function()
		if (IsValid(self)) then
			self.ForceAnimSequence = nil
			
			net.Start("BREACH_EndForcedAnimSync")
			net.WriteEntity(self)
			net.Broadcast()
			
			self.StopFAnimCallback = nil
			
			if isfunction(finishcallback) then
				finishcallback()
			end
		end
	end)
end

function mply:AddSpyDocument()
	self:SetNWInt("CollectedDocument", 1)
end

function mply:IgniteSequence(time)
    local steamid = self:SteamID64()
    local startfireshow = "StartingFireShow" .. steamid
    local endfireshow = "EndingFireShow" .. steamid
	local burningout = "BurningOut" .. steamid
	local funnehdmg = math.random(8, 17)

	self:SetNWBool("FireParticles", true)

	if self:GTeam() == TEAM_SPEC or self:GetMoveType() == MOVETYPE_NOCLIP or not self:Alive() then
		return self:StopIgniteSequence()
	end

    timer.Create(startfireshow, 0, 0, function()
        if IsValid(self) and self:Alive() then

			if (self.burncd or 0) > CurTime() then
				return
			end

			self.burncd = CurTime() + 1.3

			if timer.Exists(burningout) then
				timer.Remove(startfireshow)
				timer.Remove(endfireshow)
				return
			end

			if self:Health() <= 24 and self:Alive() then
				if self:GTeam() == TEAM_SCP then
					return self:Kill()
				end

                self:Extinguish()
                self:GodEnable()
                self:SetMoveType(MOVETYPE_OBSERVER)
                self:SetNWEntity("NTF1Entity", self)
                self:SetNWBool("FireParticles", true)
                self:SelectWeapon("br_holster")
                self:SetForcedAnimation("mpf_idleonfire", 20)

				self:Voice("burn")

				timer.Create(burningout , 3.8, 1, function()
                    if not IsValid(self) then return end

					self:StopForcedAnimation()
					self:SetNWEntity("NTF1Entity", NULL)
					self:SetNWAngle("ViewAngles", Angle(0, 0, 0))
					self:SetMoveType(MOVETYPE_WALK)
					self:SetModel("models/cultist/humans/corpse.mdl")
					self:StopSound(self.burnSound or "")

					self.burnttodeath = true
					self.burnSound = nil

					self:GodDisable()
					self:Kill()

					self:SetNWBool("FireParticles", false)
					self:StopParticles()

					for _, v in pairs(self:LookupBonemerges()) do
						v:Remove()
					end

					timer.Remove(endfireshow)
					timer.Remove(startfireshow)
					timer.Remove(burningout)

					--timer.Simple(.7, function() -- in sv_lootbox
						--if IsValid(self) then
							--self.burnttodeath = nil
						--end
					--end)			
                end)

                return
            end

			self:Voice("burning")
			self:TakeDamage(funnehdmg, self, DMG_BURN)
		end
    end)

    timer.Create(endfireshow, time, 1, function()
        if IsValid(self) then
            timer.Remove(endfireshow)
            timer.Remove(startfireshow)

            self:SetNWBool("FireParticles", false)
            self:StopParticles()
        end
    end)
end

function mply:StopIgniteSequence()
	if IsValid(self) then
		local steamid = self:SteamID64()
		local startfireshow = "StartingFireShow" .. steamid
		local endfireshow = "EndingFireShow" .. steamid
		local burningout = "BurningOut" .. steamid

		if timer.Exists(startfireshow) then
			timer.Remove(startfireshow)
		elseif timer.Exists(endfireshow) then
			timer.Remove(endfireshow)
		elseif timer.Exists(burningout) then
			timer.Remove(burningout)
		end

		if self.burnSound then
			self:StopSound(self.burnSound)
			self.burnSound = nil
		end

		self:SetNWBool("FireParticles", false)
		self:StopParticles()
		self:Extinguish()
	end
end

function mply:ClearBodyGroups()
	for i = 0, self:GetNumBodyGroups() - 1 do
		self:SetBodygroup(i, 0)
	end
end

function GM:PlayerSpray(ply)
    return true
end

function mply:AddToAchievementPoint()
end

function GetAlivePlayers()
	local players = {}
	for k,v in player.Iterator() do
		if v:GTeam() != TEAM_SPEC then
			if v:Alive() then
				table.ForceInsert(players, v)
			end
		end
	end
	return players
end

function mply:TakeHealth(number)
	local hp = self:Health()
	local new = hp - number
	if new <= 0 then
		self:Kill()
		return
	end
	self:SetHealth(new)
end

function mply:AddHealth(number)
	local health, max = self:Health(), self:GetMaxHealth()
	local new = health + number
	self:SetHealth(math.min(new, max))
end

function mply:AnimatedHeal(amount)
    local maxHealth = self:GetMaxHealth()
    local targetHealth = math.min(self:Health() + amount, maxHealth)
    local startTime = CurTime()
    local timerName = "AnimatedHeal_" .. self:EntIndex()

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end

    timer.Create(timerName, 0.1, 3 / 0.1, function()
        local elapsedTime = CurTime() - startTime

        local currentHealth = Lerp(elapsedTime / 3, self:Health(), targetHealth)

        self:SetHealth(math.min(math.Round(currentHealth), maxHealth))

        if elapsedTime >= 3 then
            timer.Remove(timerName)
        end
    end)
end
function mply:UnUseBag()
    if self:GetUsingBag() == "" then return end
    local tbl_bonemerged = ents.FindByClassAndParent("breach_bonemerge", self)
    for i = 1, #tbl_bonemerged do
        local bonemerge = tbl_bonemerged[i]
        print(bonemerge:GetModel())
        if bonemerge:GetModel() == "models/cultist/backpacks/bonemerge/backpack_big.mdl" or bonemerge:GetModel() == "models/cultist/backpacks/bonemerge/backpack_small.mdl" then bonemerge:Remove() end
        local item = ents.Create(self:GetUsingBag(self:GetClass()))
        if IsValid(item) then
            item:Spawn()
            item:SetPos(self:GetPos())
        end

        self:SetUsingBag("")
    end
end

function mply:UnUseBro()
    if self:GetUsingArmor() == "" then return end
    local tbl_bonemerged = ents.FindByClassAndParent("breach_bonemerge", self)
    for i = 1, #tbl_bonemerged do
        local bonemerge = tbl_bonemerged[i]
        print(bonemerge:GetModel())
        if bonemerge:GetModel() == "models/cultist/armor_pickable/bone_merge/heavy_armor.mdl" or bonemerge:GetModel() == "models/cultist/armor_pickable/bone_merge/light_armor.mdl" then bonemerge:Remove() end
        local item = ents.Create(self:GetUsingArmor(self:GetClass()))
        if IsValid(item) then
            item:Spawn()
            item:SetPos(self:GetPos())
        end

        self:SetUsingArmor("")
    end
end

function mply:UnUseHat()
    if self:GetUsingHelmet() == "" then return end
    local tbl_bonemerged = ents.FindByClassAndParent("breach_bonemerge", self)
    for i = 1, #tbl_bonemerged do
        local bonemerge = tbl_bonemerged[i]
        print(bonemerge:GetModel())
        if bonemerge:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" or bonemerge:GetModel() == "models/cultist/humans/security/head_gear/helmet.mdl" then bonemerge:Remove() end
        local item = ents.Create(self:GetUsingHelmet(self:GetClass()))
        if IsValid(item) then
            item:Spawn()
            item:SetPos(self:GetPos())
        end

        self:SetUsingHelmet("")
    end
end

function mply:ForceDropWeapon( class )
	if not self:HasWeapon(class) then
		return
	end

	local wep = self:GetWeapon( class )

	if IsValid( wep ) then
		local atype = wep:GetPrimaryAmmoType()

		if atype > 0 then
			wep.SavedAmmo = wep:Clip1()
		end

		self:DropWeapon( wep )

		wep:PhysWake()
	end
end

// just for finding a bad spawns :p
function mply:FindClosest(tab, num)
	local allradiuses = {}
	for k,v in pairs(tab) do
		table.ForceInsert(allradiuses, {v:Distance(self:GetPos()), v})
	end
	table.sort( allradiuses, function( a, b ) return a[1] < b[1] end )
	local rtab = {}
	for i=1, num do
		if i <= #allradiuses then
			table.ForceInsert(rtab, allradiuses[i])
		end
	end
	return rtab
end

function mply:GiveRandomWep(tab)
	local mainwep = table.Random(tab)
	self:Give(mainwep)
	local getwep = self:GetWeapon(mainwep)
	if getwep.Primary == nil then
		print("ERROR: weapon: " .. mainwep)
		print(getwep)
		return
	end
	getwep:SetClip1(getwep.Primary.ClipSize)
	self:SelectWeapon(mainwep)
	self:GiveAmmo((getwep.Primary.ClipSize * 4), getwep.Primary.Ammo, false)
end

function mply:DeleteItems()
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 150 )) do
		if v:IsWeapon() then
			if !IsValid(v.Owner) then
				v:Remove()
			end
		end
	end
end

function mply:UnUseArmor()
	if self:GetUsingCloth() == "armor_goc" or self:GetModel():find("goc.mdl") or self:GetUsingCloth() == "" then return end
	self:SetModel(self.OldModel)
	self:SetSkin(self.OldSkin)
	self:SetupHands()

	for k,v in pairs(self:LookupBonemerges()) do
		if v:GetModel() == "models/cultist/humans/mog/head_gear/mog_helmet.mdl" or v:GetModel() == "models/cultist/humans/balaclavas_new/balaclava_full.mdl" then v:Remove() end
		v:SetInvisible(false)
	end

	self:SetBodyGroups(self.OldBodygroups)
	local item = ents.Create( self:GetUsingCloth(self:GetClass()) )
	if IsValid( item ) then
		item:Spawn()
		item:SetPos( self:GetPos() )
	end
	self:SetUsingCloth("")
end

function mply:SetupNormal()
	for _, v in pairs(self:LookupBonemerges()) do
		v:Remove()
	end

	self:SetNWBool("observerLight", false)

	self:StopIgniteSequence()
	self:ClearBodyGroups()

	self:SetSkin(0)
	self.weaponfromclient = nil
	self.IsZombie = false
	self.recoilmultiplier = nil
	self:StripWeapons()
	self:StripAmmo()
	self:SetNW2Bool("Breach:CanAttach", false)
	self:SetUsingBag("")
	self:SetUsingCloth("")
	self:SetUsingArmor("")
	self:SetUsingHelmet("")
	self:SetStamina(200)
	self:SetNWBool("Have_docs", false)
	self:Flashlight(false)
	self:SetBoosted(false)
	self:SetEnergized(false)
	self:SetForcedAnimation(false)
	self:SetMaxSlots(8)
	self:SetInDimension(false)

	self:SetNWEntity("NTF1Entity", NULL)
	self:SetNWAngle("ViewAngles", Angle(0, 0, 0))

	self:SetSpecialMax(0)
	self:SetNWString("AbilityName", "")
	self.AbilityTAB = nil
	self:SendLua("if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecialButt) then BREACH.Abilities.HumanSpecialButt:Remove() end if BREACH.Abilities and IsValid(BREACH.Abilities.HumanSpecial) then BREACH.Abilities.HumanSpecial:Remove() end")

	if timer.Exists("decease" .. self:SteamID64()) then
		timer.Remove("decease" .. self:SteamID64())
	end

	for i, material in pairs(self:GetMaterials()) do
		i = i -1

		self:SetSubMaterial(i, 0)
	end

	self.used1025 = false
	self.ntfsposobka = CurTime() + 1
	self.kills = 0
	self.teamkills = 0
	self.TempValues = {}
	self.HeadResist = nil
	self.ChestResist = nil
	self.GearResist = nil
	self.StomachResist = nil
	self.RightLegResist = nil
	self.LeftLegResist = nil
	self.RightArmResist = nil
	self.LeftArmResist = nil
	self.Infected409 = nil
	self.ScaleDamage = {}
	
	self.BaseStats = nil
	self.UsingArmor = nil
	self.handsmodel = nil
	self:UnSpectate()
	self:Spawn()
	self:GodDisable()
	self:SetNoDraw(false)
	self:SetNoTarget(false)
	self:SetupHands()
	self:RemoveAllAmmo()
	self:StripWeapons()
	self.canblink = true
	self.noragdoll = false
	self.scp1471stacks = 1
end

function UIUSpy_MakeDocuments(totaldocs)
    local priority = {}
    local plytable = {}

    local priorityroles = {
        ["Head of Facility"] = true,
        ["MTF Security"] = true,
        ["Head of Security"] = true,
        ["Head of Personnel"] = true,
        ["Ethics Comitee"] = true,
		["Security Chief"] = true
    }

    for _, ply in ipairs(player.GetAll()) do
        local role = ply:GetRoleName()
        
        if ply:GTeam() != TEAM_SCP and ply:GTeam() != TEAM_SPEC and role != "UIU Spy" and ply:GTeam() != TEAM_CLASSD and ply:Alive() then
            if priorityroles[role] then
                table.insert(priority, ply)
            else
                table.insert(plytable, ply)
            end
        end
    end

    local function ShowNotify(ply)
        ply:Give("item_special_document")
        ply:AresNotify("Вы являетесь важным сотрудником фонда! У при себе важные документы Фонда которые содержут в себе данные об многих исследованиях в Зоне-19 а также о самой Зоне-19, вы обязаны доставить их в целостности и не умереть.")
        ply:SetNWBool("Have_docs", true)
    end

    local function GiveDocuments(players, num)
        for i = 1, num do
            if #players == 0 then 
                break
            end

            local index = math.random(1, #players)
            local target = players[index]

            ShowNotify(target)
            table.remove(players, index)
        end
    end

    local docs = math.min(#priority, totaldocs)
    GiveDocuments(priority, docs)

    local remainingdocs = totaldocs - docs
    if remainingdocs > 0 then
        GiveDocuments(plytable, remainingdocs)
    end
end

function ment:MakeZombieTexture()
	for i, material in pairs(self:GetMaterials()) do
		i = i -1
		if !table.HasValue(BREACH.ZombieTextureMaterials, material) then
			if string.StartWith(material, "models/all_scp_models/") then
				local str = string.sub(material, #"models/all_scp_models//")
				str = "models/all_scp_models/zombies/"..str
				self:SetSubMaterial(i, str)
			end
		else
			self:SetSubMaterial(i, "!ZombieTexture")
		end
	end
end

function ment:MakeZombie()
	self:MakeZombieTexture()

	for _, v in ipairs(self:LookupBonemerges()) do
		local model = v:GetModel()

		local zombiehead = "!ZombieTexture"
		
		if model:find("head") or model:find("balaclava") then
			if CORRUPTED_HEADS[model] then
				v:SetSubMaterial(1, zombiehead)
			else
				v:SetSubMaterial(0, zombiehead)
			end
		else
			v:MakeZombieTexture()
		end
	end
end

function mply:SetupZombie()
	local victim = self
	victim:SetNoDraw(false)
	victim:SetDSP(1)
	victim:SetNWEntity("NTF1Entity", victim)
	victim:SetGTeam(TEAM_SCP)
	victim.IsZombie = true
	victim:Freeze(true)
	victim.ScaleDamage = {
		["HITGROUP_HEAD"] = .35,
		["HITGROUP_CHEST"] = .35,
		["HITGROUP_LEFTARM"] = .35,
		["HITGROUP_RIGHTARM"] = .35,
		["HITGROUP_STOMACH"] = .35,
		["HITGROUP_GEAR"] = .35,
		["HITGROUP_LEFTLEG"] = .35,
		["HITGROUP_RIGHTLEG"] = .35
	}

	victim:AddToStatistics("'Вылечен' способом SCP-049", 310)
	victim:MakeZombie()
	victim.Stamina = 100
	victim:SetMaxHealth(victim:GetMaxHealth() * 2)
	victim:SetHealth(victim:GetMaxHealth())
	victim:StripWeapons()
	victim:BreachGive("weapon_scp_049_2")
	timer.Create("Safe_WEAPON_SELECT_"..victim:SteamID64(), FrameTime(), 99999, function()
		if !IsValid(victim:GetActiveWeapon()) or victim:GetActiveWeapon():GetClass() != "weapon_scp_049_2" then
			victim:SelectWeapon("weapon_scp_049_2")
		else
			timer.Remove("Safe_WEAPON_SELECT_"..victim:SteamID64())
		end
	end)
	victim:SetForcedAnimation("breach_zombie_getup", victim:SequenceDuration(victim:LookupSequence("breach_zombie_getup")), nil, function()
		victim:SetMoveType(MOVETYPE_WALK)
		victim:Freeze(false)
		victim:SetNotSolid(false)
		victim:SetNWEntity("NTF1Entity", NULL)
	end)
end

function mply:SetStamina(float)
	net.Start("SetStamina", true)
	net.WriteFloat(float)
	net.WriteBool(false)
	net.Send(self)
end

function mply:AddStamina(float)
	net.Start("SetStamina", true)
	net.WriteFloat(float)
	net.WriteBool(true)
	net.Send(self)
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	if ply.IsZombie == true then
		local vel = ply:GetVelocity():Length2DSqr()
		if ( vel > 22500 ) then
			if IsValid(ply:GetActiveWeapon()) then
				ply:EmitSound( "^nextoren/charactersounds/zombie/foot"..math.random(1,3)..".wav", 75, math.random( 100, 120 ), volume * .8 )
			else
				ply:EmitSound( "^nextoren/charactersounds/zombie/foot"..math.random(1,3)..".wav", 75, math.random( 100, 120 ), volume * .8 )
			end
		end
	end
end

function mply:SetupCISpy()
    local rand = math.random(1, 3)
    if rand == 1 then
        self:SetBodygroup(3, 7)
        self:SetBodygroup(4, 1)
        self:StripWeapons()
        Bonemerge(BREACH_ROLES.SECURITY.security.roles[1].headgear, self)
        for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[1].weapons) do
            self:Give(v)
            self:Give("breach_keycard_security_1")
            self:Give("item_tazer")
            self:StripAmmo()
            self:GetWeapon("item_tazer"):SetClip1(20)
        end
    elseif rand == 2 then
        for k, v in pairs(self:LookupBonemerges()) do
            v:Remove()
        end
        self:SetBodygroup(3, 4)
        self:SetBodygroup(5, 2)
        Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].head, self)
        Bonemerge(BREACH_ROLES.SECURITY.security.roles[3].headgear, self)
        self:StripWeapons()
        for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[3].weapons) do
            self:Give(v)
            self:Give("breach_keycard_security_2")
            self:Give("item_tazer")
            self:StripAmmo()
            self:GetWeapon("item_tazer"):SetClip1(20)
        end
    else
        for k, v in pairs(self:LookupBonemerges()) do
            v:Remove()
        end
        self:SetBodygroup(3, 5)
        self:SetBodygroup(5, 1)
        Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].head, self)
        Bonemerge(BREACH_ROLES.SECURITY.security.roles[7].headgear, self)
        self:StripWeapons()
        for k, v in pairs(BREACH_ROLES.SECURITY.security.roles[7].weapons) do
            self:Give(v)
            self:Give("item_tazer")
            self:Give("breach_keycard_security_2")
            self:StripAmmo()
            self:GetWeapon("item_tazer"):SetClip1(20)
		end
	end
end

function SetupRadio(ply,gteam,role)
	timer.Simple(0.1,function()
		net.Start("SetFrequency")
		net.WriteEntity(ply:GetWeapon("item_radio"))
		net.WriteFloat(Radio_GetChannel(gteam,role))
		net.Send(ply)
		ply:GetWeapon("item_radio").Channel = Radio_GetChannel(gteam,role)
	end)
end

local shittyenum = {
	["HITGROUP_HEAD"] = HITGROUP_HEAD,
	["HITGROUP_CHEST"] = HITGROUP_CHEST,
	["HITGROUP_LEFTARM"] = HITGROUP_LEFTARM,
	["HITGROUP_RIGHTARM"] = HITGROUP_RIGHTARM,
	["HITGROUP_STOMACH"] = HITGROUP_STOMACH,
	["HITGROUP_GEAR"] = HITGROUP_GEAR,
	["HITGROUP_LEFTLEG"] = HITGROUP_LEFTLEG,
	["HITGROUP_RIGHTLEG"] = HITGROUP_RIGHTLEG
}

function mply:ApplyRoleStats(role)
	BroadcastStopMusic(self)

	self:SendLua("HideEQ()")
	self:SetupNormal()
	self:SetRoleName( role.name )
	self:SetGTeam( role.team )

	local isblack = math.random(1,5) == 1

	if role.white == true then isblack = false end

	local HeadModel = istable(role["head"]) and table.Random(role["head"]) or role["head"]

	if role.models and role.fmodels then
		local selfmodel

		if math.random(0, 1) == 0 then
			selfmodel = role.fmodels
		else
			selfmodel = role.models
		end

		local finalselfmodel = selfmodel[math.random(1, #selfmodel)]

		self:SetModel(finalselfmodel)
	else
		if role.models then
			local finalselfmodel = role.models[math.random(1, #role.models)]
			self:SetModel(finalselfmodel)
		elseif role.fmodels then
			local finalselfmodel = role.fmodels[math.random(1, #role.fmodels)]
			self:SetModel(finalselfmodel)
		end
	end

	if role.head then Bonemerge(HeadModel,self) end

	if role["usehead"] then
		if role["randomizehead"] then
			if self:GetRoleName() == "Class-D Bor" then return end
			if !self:IsFemale() then
				Bonemerge(PickHeadModel(self:SteamID64()), self)
			elseif self:IsFemale() then
				Bonemerge(PickHeadModel(self:SteamID64(), true), self)
			end
		else
			Bonemerge("models/cultist/heads/male/male_head_1.mdl", self)
		end
	end

	if role["randomizeface"] or !role["white"] then
		for k,v in pairs(self:LookupBonemerges()) do
			if CORRUPTED_HEADS[v:GetModel()] then v:SetSubMaterial(1, PickFaceSkin(isblack,self:SteamID64(),false)) end
			if v:GetModel():find("fat_heads") or v:GetModel():find("bor_heads") then continue end
			if v:GetModel():find("heads") or v:GetModel():find("balaclavas_new") then
				if !self:IsFemale() then
				v:SetSubMaterial(0, PickFaceSkin(isblack,self:SteamID64(),false))
			elseif
			  self:IsFemale() then
				v:SetSubMaterial(0, PickFaceSkin(isblack,self:SteamID64(),true))
			  end
			end
		end
	end

	local HairModel = nil
	if math.random(1, 5) > 1 then
		if isblack and !self:IsFemale() and role["blackhairm"] then
			HairModel = role["blackhairm"][math.random(1, #role["blackhairm"])]
		elseif role["hairm"] and !self:IsFemale() then
			HairModel = role["hairm"][math.random(1, #role["hairm"])]
		elseif role["hairf"] and self:IsFemale() then
			HairModel = role["hairf"][math.random(1, #role["hairf"])]
		end
	end

	if HairModel then
		if self:GetRoleName() == "Medic" and !self:IsFemale() then return end
		Bonemerge(HairModel,self)
	end

	if isblack and self:GetModel():find("class_d") then
		self:SetSkin(1)
	end

	if isblack and self:GetRoleName() == "Class-D Bor" then
		for k,v in pairs(self:LookupBonemerges()) do
			if v:GetModel():find("bor_heads") then
				v:SetSkin(1)
			end
		end
	end

	if role.skin then
		self:SetSkin(role.skin)
	elseif !isblack then
		self:SetSkin(0)
	end

	for i = 0, self:GetNumBodyGroups() do
		self:SetBodygroup( i, 0 )
	end

	if role.headgear then Bonemerge(role.headgear, self) end
	if role.hackerhat then Bonemerge(role.hackerhat, self) end
	if role.bodygroups then for k,v in pairs(role.bodygroups) do self:SetBodyGroups(v) end end

	for i = 0, 9 do
        local bodygroupKey = "bodygroup" .. i
        if role[bodygroupKey] then
            self:SetBodygroup(i, role[bodygroupKey])
        end
    end

	if role.cispy then
		self:SetupCISpy()
	end

    if role.weapons and role.weapons != "" then
        for _, weapon in pairs(role.weapons) do
            self:Give(weapon)
			if weapon == "item_radio" then
				SetupRadio(self,self:GTeam(),self:GetRoleName())
			end	
			if weapon == "item_tazer" then
				self:GetWeapon("item_tazer"):SetClip1(20)
			end
        end
    end

	if role.keycard and role.keycard != "" then 
		self:Give("breach_keycard_"..role.keycard)
	end

    self:StripAmmo()

    if role.ammo and role.ammo != "" then
        for _, ammo in pairs(role.ammo) do
            self:GiveAmmo(ammo[2], self:GetWeapon(ammo[1]):GetPrimaryAmmoType(), true)
        end
    end

	self:Namesurvivor()

	if role.damage_modifiers then
		for hitgroup, modifier in pairs(role.damage_modifiers) do
			local enumval = shittyenum[hitgroup]
			if enumval then
				self.ScaleDamage[enumval] = modifier
			end
		end
	end

	if role.ability then
		net.Start("SpecialSCIHUD")
			net.WriteString(role["ability"][1])
			net.WriteUInt(role["ability"][2], 9)
			net.WriteString(role["ability"][3])
			net.WriteString(role["ability"][4])
			net.WriteBool(role["ability"][5])
		net.Send(self)

		self:SetNWString("AbilityName", (role["ability"][1]))
		self:SetSpecialCD(0)

		self.AbilityTAB = {
			[1] = role["ability"][1],
			[2] = role["ability"][2],
			[3] = role["ability"][3],
			[4] = role["ability"][4],
			[5] = role["ability"][5]
		}
	end

    if role.ability_max then
		self:SetSpecialMax( role["ability_max"] )
    end

	self:SetHealth(role.health)
	self:SetMaxHealth(role.health)

	local defaultwalkspeed = 90
	local defaultrunspeed = 183

	if role.walkspeed then
		self:SetWalkSpeed(defaultwalkspeed + role.walkspeed / 3)
	else
		self:SetWalkSpeed(91)
	end

	if role.runspeed then
		self:SetRunSpeed(defaultrunspeed + role.runspeed / 3)
	else
		self:SetRunSpeed(defaultrunspeed)
	end

	self:SetSlowWalkSpeed( self:GetWalkSpeed() - 40 )
	self:SetLadderClimbSpeed(140)

	if self:GetRoleName() == "Class-D Fast" then
		self:SetRunSpeed(231)
	end

	if role.jumppower then
		self:SetJumpPower(190 * (role.jumppower or 1))
    else
  		self:SetJumpPower(190)
	end

	if role.stamina then 
		self:SetStaminaScale(role.stamina)
	end

	if role.maxslots then 
		self:SetMaxSlots(role.maxslots) 
	end

	if self:GTeam() == TEAM_CLASSD and self:IsPremium() then
        self:SetBodygroup(0, math.random(0, 4))
    end
		
	net.Start("RolesSelected")
	net.Send(self)

	self:SetupHands()

	if self:GetRoleName() == "UIU Spy" and timer.Exists("RoundTime") then
		UIUSpy_MakeDocuments(3)
	end

	if role.recoilmultiplier then
		self.recoilmultiplier = role.recoilmult
	end

	self.voicePitch = math.random(90, 110)
end

function mply:SaveExp()
    local steamid = self:SteamID64()
    local exp = self:GetExp()
    local query = string.format("UPDATE breach_data SET exp = %d WHERE steamid = %s", exp, steamid)

	if self:IsBot() then
		return
	end

    BREACH.DataBaseSystem:Query(query)
end

function mply:SaveLevel()
    local steamid = self:SteamID64()
    local level = self:GetLevel()
    local query = string.format("UPDATE breach_data SET level = %d WHERE steamid = %s", level, steamid)

	if self:IsBot() then
		return
	end

    BREACH.DataBaseSystem:Query(query)
end

function mply:AddExp(amount, msg)
    amount = math.Round(amount)
    self:SetNEXP(self:GetNEXP() + amount)

    local xp = self:GetNEXP()
    local lvl = self:GetNLevel()

    if xp > (680 * math.max(1, self:GetNLevel())) then
        self:SetNEXP(xp - (680 * math.max(1, self:GetNLevel())))
        self:SetNLevel(self:GetNLevel() + 1)
    end

    if self:GetNEXP() < 0 then
        self:SetNEXP(1)
    end

    self:SaveExp()
    self:SaveLevel()
end

function mply:AddLevel(amount)
    if not self.GetNLevel then
        player_manager.RunClass(self, "SetupDataTables")
    end
    if self.GetNLevel and self.SetNLevel then
        self:SetNLevel(self:GetNLevel() + amount)
        self:SaveLevel()
    else
        if self.SetNLevel then
            self:SetNLevel(0)
        else
            ErrorNoHalt("Cannot set the exp, SetNLevel invalid")
        end
    end
end

local ment = FindMetaTable('Entity')

function mply:Make409Statue()

	if self.Used500 then return end

	local ragdoll

	if self:HasWeapon("item_special_document") then
		local document = ents.Create("item_special_document")
		document:SetPos(self:GetPos() + Vector(0,0,20))
		document:Spawn()
		document:GetPhysicsObject():SetVelocity(Vector(table.Random({-100,100}),table.Random({-100,100}),175))
	end

		ragdoll = ents.Create("prop_ragdoll")
		ragdoll:SetModel(self:GetModel())
		ragdoll:SetSkin(self:GetSkin())

		ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		for i = 0, 9 do
			ragdoll:SetBodygroup(i, self:GetBodygroup(i))
		end
		
		ragdoll:SetPos(self:GetPos())
		ragdoll:Spawn()

		BreachParticleEffectAttach("steam_manhole", PATTACH_ABSORIGIN_FOLLOW, ragdoll, 1)
		
		ragdoll:SetMaterial("nextoren/ice_material/icefloor_01_new")

		if ( ragdoll && ragdoll:IsValid() ) then

				for i = 1, ragdoll:GetPhysicsObjectCount() do

					local physicsObject = ragdoll:GetPhysicsObjectNum( i )
					local boneIndex = ragdoll:TranslatePhysBoneToBone( i )
					local position, angle = self:GetBonePosition( boneIndex )

					if ( physicsObject && physicsObject:IsValid() ) then

						physicsObject:SetPos( position )
						physicsObject:SetMass( 65 )
						physicsObject:SetAngles( angle )
						physicsObject:EnableMotion(false)
						physicsObject:Wake()

				end
			end

		end

		ragdoll.Think = function(self)
			self:NextThink(CurTime() + .25)

			for _, v in ipairs(ents.FindInSphere(self:GetPos(), 240)) do
				if v:IsPlayer() and v:Health() > 0 and not (v:GTeam() == TEAM_SPEC or v:GetRoleName() == role.ClassD_FartInhaler or v:GTeam() == TEAM_SCP or v:GetRoleName() == role.DZ_Gas) and not v:HasHazmat() and (v:GTeam() != TEAM_GOC or v:GetRoleName() == role.ClassD_GOCSpy) and not v.GASMASK_Equiped then if not v.Infected409 
					then v:Start409Infected() end 
				end
			end
		end

		local bonemerges = ents.FindByClassAndParent("breach_bonemerge", self)
		if istable(bonemerges) then
			for _, bnmrg in pairs(bonemerges) do
				if IsValid(bnmrg) and !bnmrg:GetNoDraw() then
					local bnmrg_rag = Bonemerge(bnmrg:GetModel(), ragdoll)
					bnmrg_rag:SetMaterial("nextoren/ice_material/icefloor_01_new")
				end
		end

	end

	self:AddToStatistics("l:scp409_death", -100)
	self:LevelBar()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	self:SetupNormal()
	self:SetSpectator()

	return ragdoll
end

function mply:SCP409Infect()
	self.Infected409 = true

	self:Make409Statue()

	timer.Simple(1, function()
		self.Infected409 = nil
	end)
	
end

function mply:Start409Infected()
	if !IsValid(self) and !self:IsPlayer() then return end
	self.Infected409 = true
	print("заразився 409 "..self:Name())
	self:SetBottomMessage("l:scp409_1st_stage")
	timer.Create("MEGAINFECTEDMESSAGE"..self:SteamID(), math.random(30,35), 1, function()
		self:SetBottomMessage("l:scp409_2nd_stage")
		self:ScreenFade( SCREENFADE.IN, Color( 21, 108, 221, 190), 0.5, 0.5 )
		timer.Remove("MEGAINFECTEDMESSAGE"..self:SteamID())
	end)
	timer.Create("INFECTED"..self:SteamID(), math.random(134,146), 1, function()
		self:ScreenFade( SCREENFADE.IN, Color( 21, 108, 221, 190), 16, 10 )

		net.Start("ForcePlaySound")
		net.WriteString("nextoren/others/freeze_sound.ogg")
		net.Send(self)

		timer.Simple(16, function()
			self:Make409Statue()

		self.Infected409 = nil
		timer.Remove("INFECTED"..self:SteamID())
		end)
	end)
end

util.AddNetworkString("Shaky_TipSend")

function mply:BrTip(icontype, str1, col1, str2, col2)
  net.Start("Shaky_TipSend", true)
	net.WriteUInt(icontype, 2)
	net.WriteString(str1)
	net.WriteColor(col1)
	net.WriteString(str2)
	net.WriteColor(col2)
  net.Send(self)
end

function mply:StopGestureSlot(slot)
    self:AnimRestartGesture(slot, 0)
end

function mply:bSendLua(code)
	net.Start("bettersendlua")
	net.WriteString(code)
	net.Send(self)
end

function mply:SlowDown()
	self.beingShot = true

	timer.Create('RemoveShotEffect'..self:SteamID64(), math.random(1, 3), 1, function()
		if IsValid(self) then
			self.beingShot = false
		end
	end)
end

hook.Add("PlayerInitialSpawn", "Breach:PrecacheResources", function(ply) ply:bSendLua("PrecachePlayerSounds()") end)