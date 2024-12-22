CustomizableWeaponry_KK.ins2.flashlight = CustomizableWeaponry_KK.ins2.flashlight or {}

function CustomizableWeaponry_KK.ins2.flashlight:IsValid()
    return true
end

CustomizableWeaponry_KK.ins2.flashlight.__index = CustomizableWeaponry_KK.ins2.flashlight
CustomizableWeaponry_KK.ins2.flashlight.atts = {
    ["kk_ins2_anpeq15"] = 2,
    ["kk_ins2_m6x"] = 2,
    ["kk_ins2_fl_kombo"] = 3,
    ["kk_ins2_flashlight"] = 1,
    ["kk_ins2_lam"] = 1,
}

function CustomizableWeaponry_KK.ins2.flashlight:hasFL(wep)
    for k, _ in pairs(self.atts) do
        if wep.ActiveAttachments[k] then return k end
    end
end

local CW2_ATTS = CustomizableWeaponry.registeredAttachmentsSKey
function CustomizableWeaponry_KK.ins2.flashlight:getFL(wep)
    local k = self:hasFL(wep)
    return (k and CW2_ATTS[k] and CW2_ATTS[k].getLEMState) and CW2_ATTS[k]
end

if CLIENT then
    function CustomizableWeaponry_KK.ins2.flashlight:PlayerBindPress(ply, bind, pressed)
        if not pressed then return end
        if not bind:find("impulse 100") then return end
        local wep = ply:GetActiveWeapon()
        if not IsValid(wep) or not wep.CW20Weapon then return end
        local hasFL = self:hasFL(wep)
        if not hasFL then return end

        if ply:KeyDown(IN_USE) then
            RunConsoleCommand("_cw_kk_cyclelam", "r")
        else
            RunConsoleCommand("_cw_kk_cyclelam")
        end
        return true
    end

    hook.Add("PlayerBindPress", "CW_KK_INS2_FlashlightBind", function(...) return CustomizableWeaponry_KK.ins2.flashlight:PlayerBindPress(...) end)
end

if SERVER then
    function CustomizableWeaponry_KK.ins2.flashlight:PlayerBindPress(ply, cmd, args)
        if not IsValid(ply) then return end
        local wep = ply:GetActiveWeapon()
        if not IsValid(wep) or not wep.CW20Weapon then return end
        local hasFL = self:hasFL(wep)
        if not hasFL then return end

        local max = self.atts[hasFL]
        local mode = wep:GetNWInt("INS2LAMMode")

        if #args > 0 then
            mode = mode - 1
        else
            mode = mode + 1
        end

        if mode > max then
            mode = 0
        elseif mode < 0 then
            mode = max
        end

        wep:SetNWInt("INS2LAMMode", mode)
        wep:EmitSound("CW_KK_INS2_UMP45_FIRESELECT")
    end

    concommand.Add("_cw_kk_cyclelam", function(...) CustomizableWeaponry_KK.ins2.flashlight:PlayerBindPress(...) end)
end
