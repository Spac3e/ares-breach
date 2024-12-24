local PLAYER = FindMetaTable("Player")

local voices = {
    male = {die = {}, diefast = {}, neckshot = {}, hit = {}, burning = {}, burn = {}},
    female = {die = {}, hit = {}, burning = {}, burn = {}},
    military = {alert = {}, alertcmd = {}, die = {}, diefast = {}, neckshot = {}, hit = {}, burning = {}, burn = {}},
    goc = {},
    russian = {alert = {}, die = {}, diefast = {}, neckshot = {}, hit = {}, burning = {}, burn = {}},
    zombie = {die = {}, hit = {}, burning = {}}
}

function PLAYER:GetVoiceTable()
    local model = self:GetModel():lower()

    if model:find("mog") and not self.Zombie then
        return voices.military
    end

    if model:find("gru") then
        return voices.russian
    end

    if model:find("goc") and self:GetRoleName() != "GOC Spy" then
        return voices.goc
    end

    if self:IsFemale() then
        return voices.female
    end

    if self:GTeam() == TEAM_SCP then
        return self.Zombie and voices.zombie or nil
    end

    return voices.male
end

function PLAYER:GetVoice(id)
    local voicetable = self:GetVoiceTable()
    if not voicetable then return nil end

    local sounds = voicetable[id]
    if not sounds then return nil end

    if istable(sounds) then
        return sounds[math.random(#sounds)]
    else
        return sounds
    end
end

function PLAYER:Voice(id, lvl, ignore, cooldown)
    if self.nextVoiceTime and self.nextVoiceTime >= CurTime() and not ignore then
        return
    end

    if not self:Alive() then
        return
    end

    local voice = self:GetVoice(id)

    if self.lastVoice then
        self:StopSound(self.lastVoice)
    end

    if voice then
        self:EmitSound(voice, lvl or 65, self.voicePitch or 100, 1, CHAN_VOICE)
    end

    if id == "burn" then
        self.burnSound = voice
    end

    self.lastVoice = voice
    self.nextVoiceTime = CurTime() + (isnumber(cooldown) and cooldown or 2)
end

do
    local basepath = "nextoren/vo/"
    local charpath = "nextoren/charactersounds/"

    local function addSounds(tbl, prefix, count, formatStr, format)
        format = format or ".wav"
        formatStr = formatStr or "%d"
        for i = 1, count do
            local soundPath = prefix .. string.format(formatStr, i) .. format
            table.insert(tbl, Sound(soundPath))
        end
    end

    -- Male
    addSounds(voices.male.hit, charpath .. "hurtsounds/male/hurt_", 39)
    addSounds(voices.male.hit, charpath .. "hurtsounds/male/death_", 58, nil, ".mp3")
    addSounds(voices.male.diefast, charpath .. "hurtsounds/male/death_fast_", 6, nil, ".mp3")
    addSounds(voices.male.neckshot, charpath .. "hurtsounds/male/neck_shot_", 18)
    addSounds(voices.male.burning, charpath .. "hurtsounds/fire/pl_burnpain0", 6)
    addSounds(voices.male.burn, charpath .. "hurtsounds/hg_onfire0", 4)

    -- Female
    addSounds(voices.female.hit, charpath .. "hurtsounds/sfemale/hurt_", 66)
    addSounds(voices.female.die, charpath .. "hurtsounds/sfemale/death_", 75)
    addSounds(voices.female.burning, charpath .. "hurtsounds/fire/pl_burnpain0", 6)
    addSounds(voices.female.burn, charpath .. "hurtsounds/hg_onfire0", 4)

    -- Russian
    addSounds(voices.russian.hit, basepath .. "gru/pain0", 9, "%d")
    addSounds(voices.russian.hit, basepath .. "gru/pain", 2, "%d", 10)
    addSounds(voices.russian.die, charpath .. "hurtsounds/male/death_", 58)
    addSounds(voices.russian.diefast, charpath .. "hurtsounds/male/death_fast_", 6)
    addSounds(voices.russian.neckshot, charpath .. "hurtsounds/male/neck_shot_", 18)
    addSounds(voices.russian.burn, charpath .. "hurtsounds/hg_onfire0", 4)
    addSounds(voices.russian.burn, charpath .. "hurtsounds/hg_onfire0", 4)
    addSounds(voices.russian.alert, basepath .. "gru/spot", 7)

    -- Military
    addSounds(voices.military.hit, basepath .. "mtf/mtf_hit_", 23)
    addSounds(voices.military.die, charpath .. "hurtsounds/male/death_", 58, nil, ".mp3")
    addSounds(voices.military.neckshot, charpath .. "hurtsounds/male/neck_shot_", 18)
    addSounds(voices.military.diefast, charpath .. "hurtsounds/male/death_fast_", 6, nil, ".mp3")
    addSounds(voices.military.burning, charpath .. "hurtsounds/fire/pl_burnpain0", 6)
    addSounds(voices.military.burn, charpath .. "hurtsounds/hg_onfire0", 4)
    addSounds(voices.military.alert, basepath .. "mtf/mtf_alert_", 5)
    addSounds(voices.military.alertcmd, basepath .. "mtf/cmd_mtf_alert_", 3)

    -- Zombie
    addSounds(voices.zombie.hit, charpath .. "zombie/pain", 6)
    addSounds(voices.zombie.die, charpath .. "zombie/die", 5)
    addSounds(voices.zombie.burning, charpath .. "zombie/pain", 6)
end