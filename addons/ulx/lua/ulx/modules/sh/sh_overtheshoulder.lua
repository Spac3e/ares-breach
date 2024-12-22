local function ThirdPerson(ply, pos, ang)
	local data = {}
    data.drawviewer = true 

    local targetpos = pos + ang:Forward() * -70 + ang:Right() * 24 + ang:Up() * 4

    local trace = {}
    trace.start = pos
    trace.endpos = targetpos
    trace.mins = Vector(-5, -5, -5)
    trace.maxs = Vector(5, 5, 5)
    trace.filter = ply
    trace.mask = MASK_VISIBLE
    local tr = util.TraceHull(trace)
    if tr.Hit then
        data.origin = tr.HitPos
    else
        data.origin = targetpos
    end
	return data
end

local meta = FindMetaTable("Player")
oldShootPos = oldShootPos or meta.GetShootPos 
function meta:GetShootPos()
    if self.IsInThirdPerson then
        local data = ThirdPerson(self, oldShootPos(self), self:EyeAngles())
        return data.origin
    else
        return oldShootPos(self)
    end
end
meta.EyePos = meta.GetShootPos
local function OverrideFireBullets(ent, data)
    if ent:IsPlayer() and ent.IsInThirdPerson then
        local origin = data.Src
        local eyes = ent:GetShootPos()
        local dir = data.Dir
        local trace = {}
        trace.start = eyes
        trace.endpos = eyes + (dir * 8 * 4096)
        trace.filter = ent
        trace.mask = MASK_SHOT
        local tr = util.TraceLine(trace)
        local finaldir = tr.HitPos - origin
        finaldir:Normalize()
        data.Dir = finaldir
    end
    return true
end
hook.Add("EntityFireBullets", "ots_bullets", OverrideFireBullets)

--Net stuff
if SERVER then
    util.AddNetworkString("ots_on")
    util.AddNetworkString("ots_off")
end
if CLIENT then
    net.Receive("ots_on", function() 
        hook.Add("CalcView", "OverTheShoulderThirdPerson", ThirdPerson) 
        LocalPlayer().IsInThirdPerson = true
    end)
    net.Receive("ots_off", function()
        hook.Remove("CalcView", "OverTheShoulderThirdPerson")
        LocalPlayer().IsInThirdPerson = false
    end)
end
--ULX integration

local function ThirdPersonOn(no, ply)
    net.Start("ots_on")
    net.Send(ply) --Tell the player to enable thirdperson. Usually we'd write values here but we only need the message's name, no contents.
    ply.IsInThirdPerson = true --Make a note that this player is in third person, to be used in the aiming overrides.
end
local function ThirdPersonOff(no, ply)
	net.Start("ots_off")
    net.Send(ply)
    ply.IsInThirdPerson = false
end

local cmd = ulx.command("Fun", "ulx thirdperson", ThirdPersonOn, "!thirdperson", false)
cmd:addParam{
    type = ULib.cmds.PlayersArg,
    hint = "Enables third person on targetted player(s)", --Hint in the autocomplete dropdown.
}
 
cmd:defaultAccess(ULib.ACCESS_SUPERADMIN) --Must ACCESS_SUPERADMIN, ADMIN, or USER.
cmd:help("Enables third person on targetted player(s)") -- Description text for command.

local cmd = ulx.command("Fun", "ulx firstperson", ThirdPersonOff, "!firstperson", false)
cmd:addParam{
    type = ULib.cmds.PlayersArg,
    hint = "Disables third person on targetted player(s)", --Hint in the autocomplete dropdown.
}
 
cmd:defaultAccess(ULib.ACCESS_SUPERADMIN) --Must ACCESS_SUPERADMIN, ADMIN, or USER.
cmd:help("Disables third person on targetted player(s)") -- Description text for command.