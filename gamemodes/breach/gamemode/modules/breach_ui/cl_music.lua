local surface = surface
local Material = Material
local draw = draw
local DrawBloom = DrawBloom
local DrawSharpen = DrawSharpen
local DrawToyTown = DrawToyTown
local Derma_StringRequest = Derma_StringRequest
local RunConsoleCommand = RunConsoleCommand
local tonumber = tonumber
local tostring = tostring
local CurTime = CurTime
local Entity = Entity
local unpack = unpack
local table = table
local pairs = pairs
local ScrW = ScrW
local ScrH = ScrH
local concommand = concommand
local timer = timer
local ents = ents
local hook = hook
local math = math
local draw = draw
local pcall = pcall
local ErrorNoHalt = ErrorNoHalt
local DeriveGamemode = DeriveGamemode
local vgui = vgui
local util = util
local net = net
local player = player

BREACH.Music.GlobalVolume = BREACH.Music.GlobalVolume or 1
BREACH.Music.AudioVolume = BREACH.Music.AudioVolume or 1

BREACH.EF = {}

NextActionMusicTime = NextActionMusicTime or 0
SongEnd = SongEnd or 0
NextSeeSCPs = NextSeeSCPs or 0
VOLUME_MODIFY = VOLUME_MODIFY or 0

BREACH.Dead = BREACH.Dead or false
BREACH.DieStart = BREACH.DieStart or 0
BREACH.NTFEnter = BREACH.NTFEnter or 0

local BreachNextThink = 0
local thinkRate = 0.15
local volumes = {
    misc = "breach_config_music_misc_volume",
    spawn = "breach_config_music_spawn_volume",
    ambience = "breach_config_music_ambient_volume",
    panic = "breach_config_music_panic_volume",
}

local music_table = include(GM.FolderName .. "/gamemode/modules/breach_ui/music.lua")
local mainmusic = GetConVar("breach_config_overall_music_volume")

local cvarscachetbl = {}
for k, v in pairs(volumes) do
    cvarscachetbl[k] = GetConVar(v)
end

function BREACH.Music:GetVolume(n)
    local currentTime = SysTime()
    if not self._volumecache or currentTime > (self.VolumeThink or 0) then
        self._volumecache = {}
        local overall = mainmusic:GetFloat() / 100
        for k, conVar in pairs(cvarscachetbl) do
            self._volumecache[k] = (conVar:GetFloat() * overall) / 100
        end
        self.VolumeThink = currentTime + thinkRate
    end
    return self._volumecache[n] or 0
end

function BREACH.Music:Play(music_id, start, skipstart, loopskip)
    if not start then start = 0 end
    timer.Remove("Music_PlayAfter")
    self.NextGeneric = SysTime() + 60
    self.NoAutoMusic = true
    local m_tab = music_table[music_id]
    timer.Remove("Music_fade")
    if not loopskip then self.GlobalVolume = 1 end
    self._pickedalreadysong = nil
    self._time = start
    self._queue = music_id
    self._mustplayafter = m_tab.playwhenend
    if m_tab.playwhenend then BREACH.Music.IgnoreThinkRate = true end
    self._skipstart = skipstart
    self.StartAt = SysTime()
    if not loopskip then self.ActualStartAt = SysTime() end
    self._endAt = m_tab.EndAt
    self.fade = m_tab.fade
    if m_tab.IsPercentEndAt then self._endAt = nil end
    self._loop = m_tab.loop
    BreachNextThink = 0
    self.VolumeThink = 0
    self.NoAutoMusic = false
end

function BREACH.Music:Stop(fade)
    self.NoAutoMusic = true
    timer.Simple(1, function() self.NoAutoMusic = false end)
    self._endAt = nil

    if fade then
        self.IsFading = true
        local startVolume = self.GlobalVolume
        local fadeStart = CurTime()
        local fadeEnd = fadeStart + fade

        timer.Create("Music_fade", 0.01, 0, function()
            local now = CurTime()
            if now >= fadeEnd then
                if self.MusicPatch and self.MusicPatch:IsValid() then 
                    self.MusicPatch:Stop() 
                end
                self._loop = false
                self.GlobalVolume = 1
                self.IsFading = false
                timer.Remove("Music_fade")
            else
                self.GlobalVolume = Lerp((now - fadeStart) / fade, startVolume, 0)
                if self.MusicPatch and self.MusicPatch:IsValid() then 
                    self.MusicPatch:SetVolume(self:GetVolume(self.CurrentMusic.volumetype) * self.GlobalVolume * self.AudioVolume) 
                end
            end
        end)
    else
        if self.MusicPatch and self.MusicPatch:IsValid() then
            self.MusicPatch:Stop()
        end
        self._loop = false
    end
end

function StopMusic(fadelen)
    BREACH.Music:Stop(fadelen or 0)
end

local function StartMusic()
    local s_music = net.ReadUInt(32)
    BREACH.Music:Play(s_music)
end

net.Receive("ClientPlayMusic", StartMusic)
net.Receive("ClientStopMusic", StopMusic)

concommand.Add("debug_music_test", function() BREACH.Music:Play(BR_MUSIC_FBI_AGENTS_ESCAPE) end)

function BREACH.Music:ShouldMusicPlayAtTheMoment()
    return (self.CurrentMusic and self.StartAt and self._endAt and (SysTime() - self.StartAt) < self._endAt) or self.IsFading
end

function BREACH.Music:CanPlayGenericMusic()
    local client = LocalPlayer()
    if client:Health() <= 0 then return false end
    if client:GTeam() == TEAM_SPEC then return false end
    if GetGlobalBool("Evacuation", false) then return false end
    if self.NoAutoMusic == true then return false end
    return true
end

local action_banned = {
    [TEAM_SCP] = true,
    [TEAM_DZ] = true,
    [TEAM_SPEC] = true
}

function BREACH.Music:ShouldPlayAction()
    local gteam = LocalPlayer():GTeam()

    return not action_banned[gteam]
end

local generic_cd = 60

function BREACH.Music:PickGenericSong()
    if self:ShouldMusicPlayAtTheMoment() or self:GetVolume("ambience") == 0 or not self:CanPlayGenericMusic() or self._mustplayafter or self.NoAutoMusic then
        return
    end

    self.NextGeneric = self.NextGeneric or 0
    if self.NextGeneric >= SysTime() then return end

    local client = LocalPlayer()
    if not IsValid(client) then return end

    local track
    if client:GetInDimension() then
        track = BR_MUSIC_DIMENSION_SCP106
    elseif client:IsLZ() then
        track = BR_MUSIC_AMBIENT_LZ
    elseif client:IsEntrance() then
        track = BR_MUSIC_AMBIENT_OFFICE
    elseif client:IsHardZone() then
        track = BR_MUSIC_AMBIENT_HZ
    elseif client:Outside() then
        track = BR_MUSIC_AMBIENT_OUTSIDE
    end

    if track then
        self:Play(track)
    end

    self.NextGeneric = SysTime() + generic_cd
end

function BREACH.Music:PickActionSong()
    if self:GetVolume("panic") == 0 then return end
    local client = LocalPlayer()
    if client:IsLZ() then
        self:Play(BR_MUSIC_ACTION_LZ)
    elseif client:IsEntrance() then
        self:Play(BR_MUSIC_ACTION_OFFICE)
    elseif client:IsHardZone() then
        self:Play(BR_MUSIC_ACTION_HZ)
    elseif client:Outside() then
        self:Play(BR_MUSIC_ACTION_OUTSIDE)
    else
        self:Play(BR_MUSIC_ACTION_LZ)
    end
end

function BREACH.Music:Think()
    local client = LocalPlayer()

    if self._endAt and self.ActualStartAt and (SysTime() - self.ActualStartAt) >= self._endAt then
        self:Stop(self.fade)
    end

    if self._queue then
        local m_tab = music_table[self._queue]
        if self.MusicPatch and self.MusicPatch:IsValid() then
            self.MusicPatch:Stop()
        end

        local snd = self._pickedalreadysong or (istable(m_tab.soundname) and m_tab.soundname[math.random(#m_tab.soundname)] or m_tab.soundname)
        self._pickedalreadysong = snd

        local filename = string.GetFileFromFilename(snd)
        self.AudioVolume = self.Custom_Volumes[filename] or 1

        sound.PlayFile(snd, "noplay", function(music)
            if IsValid(music) and not self.music_created then
                self.music_created = true
                music:SetVolume(self:GetVolume(m_tab.volumetype) * self.GlobalVolume * self.AudioVolume)
                music:SetTime(self._time)
                self.CurrentMusic = m_tab
                self.MusicDuration = music:GetLength()

                if self._mustplayafter then
                    timer.Create("Music_PlayAfter", 0, 0, function()
                        if SysTime() >= self.StartAt + self.MusicDuration - FrameTime() then
                            timer.Remove("Music_PlayAfter")
                            self.NextGeneric = SysTime() + generic_cd
                            self:Play(self._mustplayafter)
                        end
                    end)
                end

                self._endAt = m_tab.IsPercentEndAt and self.MusicDuration * m_tab.EndAt or (self._loop and math.huge or self.MusicDuration)
                music:EnableLooping(self._loop or false)

                self.MusicPatch = music
                music:Play()
            end
        end)

        self.music_created = false
        self._queue = nil
    end

    if self.MusicPatch and self.MusicPatch:IsValid() and self.CurrentMusic then
        self.MusicPatch:SetVolume(self:GetVolume(self.CurrentMusic.volumetype) * self.GlobalVolume * self.AudioVolume)
    end

    if not self.NoAutoMusic then self:PickGenericSong() end
    if NextSeeSCPs > CurTime() then return end
    if action_banned[client:GTeam()] or GetGlobalBool("Evacuation", false) or client:Health() <= 0 then return end

    local minDotProduct = 0.5235987755983

    for _, v in ipairs(ents.FindInSphere(client:GetPos(), 550)) do
        if v:IsPlayer() and v ~= client and not v:GetNoDraw() and v:GetModel():find("/scp/") and v:GetRoleName() ~= SCP999 and v:GTeam() == TEAM_SCP then
            local tr = util.TraceLine({ start = client:EyePos(), endpos = v:EyePos(), filter = {client, v} })
            if tr.Fraction == 1 then
                local aim_vector = client:GetAimVector()
                local ent_vector = (v:GetPos() - client:GetShootPos()):GetNormalized()
                if aim_vector:Dot(ent_vector) > minDotProduct then
                    surface.PlaySound("nextoren/charactersounds/panic.mp3")
                    self:PickActionSong()
                    NextSeeSCPs = CurTime() + math.random(30, 40)
                    break
                end
            end
        end
    end
end

hook.Add("Think", "music_think", function()
    if (CurTime() >= BreachNextThink) or (BREACH.Music._loop and BREACH.Music.StartAt and BREACH.Music.MusicDuration and SysTime() >= BREACH.Music.StartAt + BREACH.Music.MusicDuration) then
        BREACH.Music:Think()
        BreachNextThink = CurTime() + thinkRate
    end
end)