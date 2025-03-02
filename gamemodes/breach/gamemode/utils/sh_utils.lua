local RunConsoleCommand = RunConsoleCommand
local FindMetaTable = FindMetaTable
local CurTime = CurTime
local pairs = pairs
local string = string
local table = table
local timer = timer
local hook = hook
local math = math
local pcall = pcall
local unpack = unpack
local tonumber = tonumber
local tostring = tostring
local ents = ents
local ErrorNoHalt = ErrorNoHalt
local DeriveGamemode = DeriveGamemode
local util = util
local net = net
local player = player

local blurScreen = Material("pp/blurscreen")
local EMeta = FindMetaTable("Entity")
local WMeta = FindMetaTable("Weapon")
local PMeta = FindMetaTable("Player")
local vec = FindMetaTable("Vector")

local string_len = utf8.len
local string_sub = utf8.sub
local string_find = string.find

function utf8.StringToTable(str)
    local tbl = {}
    for i = 1, string_len(str) do
        tbl[i] = string_sub(str, i, i)
    end
    return tbl
end

local utftotable = utf8.StringToTable
function utf8.Explode(separator, str, withpattern)
    if separator == "" then return utftotable(str) end
    if withpattern == nil then withpattern = false end
    local ret = {}
    local current_pos = 1
    for i = 1, string_len(str) do
        local start_pos, end_pos = string_find(str, separator, current_pos, not withpattern)
        if not start_pos then break end
        ret[i] = string_sub(str, current_pos, start_pos - 1)
        current_pos = end_pos + 1
    end

    ret[#ret + 1] = string_sub(str, current_pos)
    return ret
end

function vec:Copy()
    return Vector(self.x, self.y, self.z)
end

function math.TimedSinWave(freq, min, max)
    min = (min + max) / 2
    local wave = math.SinWave(RealTime(), freq, min - max, min)
    return wave
end

function math.SinWave(x, freq, amp, offset)
    local wave = math.sin(2 * math.pi * freq * x) * amp + offset
    return wave
end

function EMeta:GetBodyGroupsString()
    local bodygroups = self:GetBodyGroups()
    local curstr = ""
    for _, bg in ipairs(bodygroups) do
        curstr = curstr .. tostring(self:GetBodygroup(bg.id))
    end
    return curstr
end

function PMeta:ClearBodyGroups()
    self:SetBodyGroups(string.rep('0', self:GetNumBodyGroups())) -- string.rep работает быстрее нумеричного метода
end

function WMeta:PlaySequence(seq_id, idle)
    if not idle then self.IdlePlaying = false end
    if not (self and self:IsValid()) or not (self.Owner and self.Owner:IsValid()) then return end
    local vm = self.Owner:GetViewModel()
    if not (vm and vm:IsValid()) then return end
    if isstring(seq_id) then seq_id = vm:LookupSequence(seq_id) end
    vm:SetCycle(0)
    vm:SetPlaybackRate(1.0)
    vm:SendViewModelMatchingSequence(seq_id)
end

if CLIENT then
    function surface.DrawRing(x, y, radius, thick, angle, segments, fill, rotation)
        angle = math.Clamp(angle or 360, 1, 360)
        fill = math.Clamp(fill or 1, 0, 1)
        rotation = rotation or 0
        local segmentstodraw = {}
        local segang = angle / segments
        local bigradius = radius + thick
        for i = 1, math.Round(segments * fill) do
            local ang1 = math.rad(rotation + (i - 1) * segang)
            local ang2 = math.rad(rotation + i * segang)
            local sin1 = math.sin(ang1)
            local cos1 = -math.cos(ang1)
            local sin2 = math.sin(ang2)
            local cos2 = -math.cos(ang2)
            surface.DrawPoly({
                {
                    x = x + sin1 * radius,
                    y = y + cos1 * radius
                },
                {
                    x = x + sin1 * bigradius,
                    y = y + cos1 * bigradius
                },
                {
                    x = x + sin2 * bigradius,
                    y = y + cos2 * bigradius
                },
                {
                    x = x + sin2 * radius,
                    y = y + cos2 * radius
                }
            })
        end
    end

    function BDerma_BackGround(panel, starttime)
        local Fraction = 1
        if starttime then Fraction = math.Clamp((SysTime() - starttime) / 1, 0, 1) end
        DisableClipping(true)
        local X, Y = 0, 0
        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)
        for i = 0.33, 1, 0.33 do
            blur:SetFloat("$blur", (i / 3) * (amount or 6))
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            render.SetScissorRect(x, y, x + w, y + h, true)
            surface.DrawTexturedRect(X * -1, Y * -1, scrW, scrH)
            render.SetScissorRect(0, 0, 0, 0, false)
        end
    end    
end

function BREACH.FindPlayer(name)
    name = string.lower(name)
    for _, v in player.Iterator() do
        if string.find(string.lower(v:Nick()), name) then return v end
        if string.lower(v:SteamID()) == name then return v end
    end
end

BREACH.Utils = {}
BREACH.Utils.TimeUnits = {}

do
    local minuteSecond = 60
    local hourSecond = 60 * minuteSecond
    local daySecond = 24 * hourSecond
    local weekSecond = 7 * daySecond
    local monthSecond = 30 * daySecond
    local yearSecond = 12 * monthSecond
    local centurySecond = 100 * yearSecond
    local millenniumSecond = 10 * centurySecond
    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "mi",
        NameSignular = "millennium",
        NamePlural = "millennia",
        Seconds = millenniumSecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "c",
        NameSignular = "century",
        NamePlural = "centuries",
        Seconds = centurySecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "y",
        NameSignular = "year",
        NamePlural = "years",
        Seconds = yearSecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "M",
        NameSignular = "month",
        NamePlural = "months",
        Seconds = monthSecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "w",
        NameSignular = "week",
        NamePlural = "weeks",
        Seconds = weekSecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "d",
        NameSignular = "day",
        NamePlural = "days",
        Seconds = daySecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "h",
        NameSignular = "hour",
        NamePlural = "hours",
        Seconds = hourSecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "m",
        NameSignular = "minute",
        NamePlural = "minutes",
        Seconds = minuteSecond
    })

    table.insert(BREACH.Utils.TimeUnits, {
        NameSingle = "s",
        NameSignular = "second",
        NamePlural = "seconds",
        Seconds = 1
    })
end

function util.FormatTime(seconds, depth)
    if not isnumber(seconds) then return seconds end
    local units = BREACH.Utils.TimeUnits
    if seconds < units[#units].Seconds then return "zero " .. units[#units].NameSignular end
    depth = depth or 0
    local txt = {}
    for _, v in ipairs(units) do
        if seconds >= v.Seconds then
            local count = math.floor(seconds / v.Seconds)
            seconds = seconds - count * v.Seconds
            if count > 1 then
                txt[#txt + 1] = count .. " " .. v.NamePlural
            else
                txt[#txt + 1] = "one " .. v.NameSignular
            end

            if depth > 0 then
                depth = depth - 1
                if depth < 1 then break end
            end
        end
    end

    local str = table.concat(txt, ", ", 1, #txt - 1)
    if #str > 0 then str = str .. " and " end
    return str .. txt[#txt]
end

function string.ConvertToTime(str)
    local units = BREACH.Utils.TimeUnits
    local seconds = 0
    local valid = false
    for unit, timeUnit in string.gmatch(str, "([%d-]+)%s*(%a+)") do
        unit = tonumber(unit)
        if not unit then return end
        for _, v in pairs(units) do
            if timeUnit == v.NameSingle or timeUnit == v.NameSignular or timeUnit == v.NamePlural then
                valid = true
                seconds = seconds + unit * v.Seconds
            end
        end

        if not valid then return end
    end

    if not valid then return end
    return seconds
end

function string.GetArguments(txt, limit)
    local args = {}
    for k, v in pairs(string.Explode('"', txt)) do
        if (k % 2) == 0 then
            table.insert(args, v)
        else
            for _, v in ipairs(string.Explode(" ", v)) do
                if #v > 0 then table.insert(args, v) end
            end
        end
    end

    if limit and #args > limit then
        args[limit] = table.concat(args, " ", limit)
        for i = limit + 1, #args do
            args[i] = nil
        end
    end
    return args
end

function string.UpperizeFirst(str)
    return string.upper(str[1]) .. str:sub(2)
end

function table.NiceConcat(tab)
    if #tab > 1 then
        local str = tab[1]
        for i = 2, #tab - 1 do
            str = str .. ", " .. tab[i]
        end
        return str .. " and " .. tab[#tab]
    elseif #tab == 1 then
        return tab[1]
    else
        return ""
    end
end

function util.DoNothing()
end

if EMeta then
    local modelBoneCache = {}
    if SERVER then
        function EMeta:SetupBones()
        end
    end

    function EMeta:GetClosestBone(pos)
        local biggestDist = math.huge
        local b
        for i = 0, self:GetBoneCount() - 1 do
            local p = self:GetBoneCenter(i)
            local d = pos:Distance(p)
            if d < biggestDist then
                biggestDist = d
                d = i
            end
        end
        return b
    end

    function EMeta:GetClosestPhysicsEnabledBone(pos)
        local bonelist = {}
        for i = 0, self:GetBoneCount() - 1 do
            local p = self:GetBoneCenter(i)
            local d = pos:Distance(p)
            if d < biggestDist then
                biggestDist = d
                b = i
            end
        end
        return b
    end

    function EMeta:GetClosestPhysicsEnabledBone(pos)
        local bonelist = {}
        for i = 0, self:GetBoneCount() - 1 do
            local phys = self:TranslateBoneToPhysBone(i)
            if not table.HasValue(bonelist, phys) then bonelist[#bonelist + 1] = i end
        end
        return self:GetClosestBoneInList(pos, bonelist)
    end

    function EMeta:GetClosestBoneInList(pos, list)
        if not list then return self:GetClosestBone(pos) end
        local biggestDist = math.huge
        local b = parentBone
        for _, boneName in ipairs(list) do
            local bone = self:LookupBone(boneName)
            if bone then
                local p = self:GetBoneCenter(bone)
                local d = pos:Distance(p)
                if d < biggestDist then
                    biggestDist = d
                    b = bone
                end
            end
        end

        if not b then return self:GetClosestBone(pos) end
        return b
    end

    function EMeta:GetBoneCenter(bone)
        self:SetupBones()
        local rootpos, rootang = self:GetBonePosition(bone)
        local t = self:GetChildBones(bone)
        if #t == 1 then
            local p = self:GetBonePosition(t[1])
            if self:BoneHasFlag(t[1], BONE_USED_BY_VERTEX_MASK) then return end
        else
            local par = self:GetBoneParent(bone)
            if par and par ~= -1 then
                local parpos = self:GetBonePosition(par)
                return rootpos + self:BoneLength(bone) * (rootpos - parpos):GetNormalized() / 2
            end
        end
        return rootpos + self:BoneLength(bone) * rootang:Forward() / 2
    end

    function EMeta:GetChildBonesRecursive(bone)
        local mdl = self:GetModel()
        if not modelBoneCache[mdl] then modelBoneCache[mdl] = {} end
        local mdlT = modelBoneCache[mdl]
        if mdlT[bone] then
            return mdlT[bone]
        else
            if isstring(bone) then
                bone = self:LookupBone(bone)
                if not bone then
                    mdlT[bone] = {}
                    return mdlT[bone]
                end
            end

            self:SetupBones()
            local t = {}
            t[#t + 1] = bone
            local childBones = self:GetChildBones(bone)
            for _, childBone in ipairs(childBones) do
                local tAppend = self:GetChildBonesRecursive(childBone)
                for _, b in ipairs(tAppend) do
                    t[#t + 1] = b
                end
            end

            mdlT[bone] = t
            return t
        end
    end
end