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
--[[ *****************************************************************************
 *  Name: Music && Panic system
 *
 *  Description:  Here are the main functions for playing music
 *                and effects.
 *
 ******************************************************************************]]
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
local thinkRate = .15
local volumes = {
    ["misc"] = "breach_config_music_misc_volume",
    ["spawn"] = "breach_config_music_spawn_volume",
    ["ambience"] = "breach_config_music_ambient_volume",
    ["panic"] = "breach_config_music_panic_volume",
}

local music_table = include(GM.FolderName .. "/gamemode/core/modules/breach_ui/music.lua")
function BREACH.Music:GetVolume(n)
    if self._volumecache and self.VolumeThink > SysTime() then
        return self._volumecache[n]
    else
        if not self._volumecache then self._volumecache = {} end
        local overall = GetConVar("breach_config_overall_music_volume"):GetFloat() / 100
        for i, v in pairs(volumes) do
            self._volumecache[i] = (GetConVar(v):GetFloat() * overall) / 100
        end

        self.VolumeThink = SysTime() + self.VolumeThinkRate
        return self._volumecache[n]
    end
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

function StopMusic()
    BREACH.Music:Stop()
end

function FadeMusic(fadelen)
    BREACH.Music:Stop(fadelen)
end

local function StartMusic()
    local s_music = net.ReadUInt(32)
    BREACH.Music:Play(s_music)
end

net.Receive("ClientPlayMusic", StartMusic)

local function StopeMusic()
    BREACH.Music:Stop()
end

net.Receive("ClientStopMusic", StopeMusic)

concommand.Add("debug_music_test", function() BREACH.Music:Play(BR_MUSIC_FBI_AGENTS_ESCAPE) end)
function BREACH.Music:ShouldMusicPlayAtTheMoment()
    if self.StartAt and self._endAt and self.CurrentMusic then if (SysTime() - self.StartAt) < self._endAt then return true end end
    if self.IsFading then return true end
    return false
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
    local team = LocalPlayer():GTeam()
    if action_banned[team] then return false end
    return true
end

local generic_cd = 60
function BREACH.Music:PickGenericSong()
    if self:ShouldMusicPlayAtTheMoment() then return end
    if self:GetVolume("ambience") == 0 then return end
    if not self:CanPlayGenericMusic() then return end
    if not self.NextGeneric then self.NextGeneric = 0 end
    if self.NextGeneric >= SysTime() then return end
    if self._mustplayafter then return end
    if self.NoAutoMusic == true then return end
    local client = LocalPlayer()
    if not preparing then
        if client:IsLZ() then
            self:Play(BR_MUSIC_AMBIENT_LZ)
        elseif client:IsEntrance() then
            self:Play(BR_MUSIC_AMBIENT_OFFICE)
        elseif client:IsHardZone() then
            self:Play(BR_MUSIC_AMBIENT_HZ)
        elseif client:Outside() then
            self:Play(BR_MUSIC_AMBIENT_OUTSIDE)
        else
            self:Play(BR_MUSIC_AMBIENT_LZ)
        end
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

function PlayMusic(str, fadelen, volume)
    print(debug.traceback())
end

function BREACH.Music:Think()
    local client = LocalPlayer()
    if self._endAt and self.ActualStartAt and (SysTime() - self.ActualStartAt) >= self._endAt then self:Stop(self.fade) end
    if self._queue then
        local m_tab = music_table[self._queue]
        if self.MusicPatch and self.MusicPatch:IsValid() then self.MusicPatch:Stop() end
        local snd = m_tab.soundname
        if self._pickedalreadysong then
            snd = self._pickedalreadysong
        else
            if istable(snd) then snd = snd[math.random(#snd)] end
            self._pickedalreadysong = snd
        end

        local filename = string.GetFileFromFilename(snd)
        if self.Custom_Volumes[filename] then
            self.AudioVolume = self.Custom_Volumes[filename]
        else
            self.AudioVolume = 1
        end

        sound.PlayFile(snd, "noplay", function(music, errCode, errStr)
            if IsValid(music) and not self.music_created then
                self.music_created = true
                music:SetVolume(self:GetVolume(m_tab.volumetype) * self.GlobalVolume * self.AudioVolume)
                music:SetTime(self._time)
                self.CurrentMusic = m_tab
                self.MusicDuration = music:GetLength()
                if self._mustplayafter then
                    local tract = self._mustplayafter
                    local dur = self.MusicDuration
                    local start = self.StartAt
                    timer.Create("Music_PlayAfter", 0, 0, function()
                        if tract and SysTime() >= start + dur - FrameTime() then
                            timer.Remove("Music_PlayAfter")
                            self.NextGeneric = SysTime() + generic_cd
                            self:Play(tract)
                        end
                    end)
                end

                if m_tab.IsPercentEndAt then self._endAt = self.MusicDuration * m_tab.EndAt end
                if not self._endAt then
                    if self._loop then
                        music:EnableLooping(true)
                        self._endAt = math.huge
                    else
                        self._endAt = self.MusicDuration
                    end
                end

                self.MusicPatch = music
                music:Play()
            end
        end)

        self.music_created = false
        self._queue = nil
    end

    if self.MusicPatch and self.MusicPatch:IsValid() and self.CurrentMusic then self.MusicPatch:SetVolume(self:GetVolume(self.CurrentMusic.volumetype) * self.GlobalVolume * self.AudioVolume) end
    if not self.NoAutoMusic then self:PickGenericSong() end
    if NextSeeSCPs > CurTime() then return end
    if action_banned[client:GTeam()] or GetGlobalBool("Evacuation", false) or client:Health() <= 0 then return end
    for _, v in ipairs(ents.FindInSphere(client:GetPos(), 550)) do
        if not v:IsPlayer() then continue end
        if v == client or v:GetNoDraw() or not v:GetModel():find("/scp/") then continue end
        if v:GetRoleName() == SCP999 then continue end
        if v:GTeam() ~= TEAM_SCP then continue end
        local tr = util.TraceLine({
            start = client:EyePos(),
            endpos = v:EyePos(),
            filter = {client, v}
        })

        if tr.Fraction ~= 1 then continue end
        local aim_vector = client:GetAimVector()
        local ent_vector = v:GetPos() - client:GetShootPos()
        if aim_vector:Dot(ent_vector) / ent_vector:Length() > .5235987755983 then -- math.pi / 6 ( 30 degrees )
            surface.PlaySound("nextoren/charactersounds/panic.mp3")
            self:PickActionSong()
            NextSeeSCPs = CurTime() + math.random(30, 40)
            break
        end
    end
end

hook.Add("Think", "music_think", function()
    if (CurTime() >= BreachNextThink) or (BREACH.Music._loop and BREACH.Music.StartAt and BREACH.Music.MusicDuration and SysTime() >= BREACH.Music.StartAt + BREACH.Music.MusicDuration) then
        BREACH.Music:Think()
        BreachNextThink = CurTime() + thinkRate
    end
end)