local CATEGORY_NAME = "Admin"

function ulx.giveweapon(calling_ply, target_plys, weapon)
    local affected_plys = {}
    for i = 1, #target_plys do
        local v = target_plys[i]
        if not v:Alive() then
            ULib.tsayError(calling_ply, v:Nick() .. " ты дебил он мертв", true)
        else
            v.IsLooting = true
            local wep = v:Give(weapon)
            if weapon == "weapon_physgun" then
                wep.HoldType = "gauss"
                wep:SetHoldType("gauss")
                BroadcastLua("print(Entity(" .. tostring(wep:EntIndex()) .. ")) Entity(" .. tostring(wep:EntIndex()) .. "):SetHoldType(\"gauss\") Entity(" .. tostring(wep:EntIndex()) .. ").HoldType = \"gauss\"")
            end

            v.IsLooting = false
            table.insert(affected_plys, v)
        end
    end

    ulx.fancyLogAdmin(calling_ply, "#A gave #T weapon #s", affected_plys, weapon)
end

local giveweapon = ulx.command(CATEGORY_NAME, "ulx giveweapon", ulx.giveweapon, {"!give", "!giveweapon"})
giveweapon:addParam{type = ULib.cmds.PlayersArg}

giveweapon:addParam{type = ULib.cmds.StringArg, hint = "weapon name"}

giveweapon:defaultAccess(ULib.ACCESS_ADMIN)
giveweapon:help("Ага абузер ебанный используй - !giveweapon")
function ulx.sgiveweapon(calling_ply, target_plys, weapon)
    local affected_plys = {}
    for i = 1, #target_plys do
        local v = target_plys[i]
        if not v:Alive() then
            ULib.tsayError(calling_ply, v:Nick() .. " ты дебил он мертв", true)
        else
            v.IsLooting = true
            v:Give(weapon)
            v.IsLooting = false
            table.insert(affected_plys, v)
        end
    end
end

local sgiveweapon = ulx.command(CATEGORY_NAME, "ulx sgiveweapon", ulx.sgiveweapon)
sgiveweapon:addParam{type = ULib.cmds.PlayersArg}

sgiveweapon:addParam{type = ULib.cmds.StringArg, hint = "weapon name"}

sgiveweapon:defaultAccess(ULib.ACCESS_ADMIN)
sgiveweapon:help("Ага абузер ебанный так и знал")