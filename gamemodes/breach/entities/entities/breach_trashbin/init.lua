AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local randommodels = {
    --"models/props_beneric/trashbin002.mdl",
    "models/props_canteen/canteenbin.mdl",
    "models/props_residue/trashcan01.mdl",
    "models/props_gffice/metalbin01.mdl"
}

function ENT:Initialize()
    local model = randommodels[math.random(#randommodels)]
    self:SetModel(model)
    self:DropToFloor()
    self:PhysWake()
    self:SetSolid(SOLID_VPHYSICS)
    self:SetSolidFlags(bit.bor(FSOLID_TRIGGER, FSOLID_USE_TRIGGER_BOUNDS))

    if model == "models/props_beneric/trashbin002.mdl" then
        self:SetAngles(Angle(90, 0, 0))
    end
end

local loottable = {
    {weapon = "item_adrenaline", name = "Шприц с адреналином", chance = 0.3},
    {weapon = "item_cheemer", name = "... Собаку?", chance = 0.5},
    {weapon = "item_drink_coffee", name = "Стакан недопитого кофе", chance = 0.2},
    {weapon = nil, chance = 0.1} -- hehe
}

local function RandomWeapon(ply)
    local totalchance = 0
    for _, data in pairs(loottable) do
        totalchance = totalchance + data.chance
    end

    local randchance = math.random() * totalchance
    local selected = nil
    for _, data in pairs(loottable) do
        if randchance <= data.chance then
            selected = data
            break
        else
            randchance = randchance - data.chance
        end
    end

    if selected and selected.weapon then
        ply:Give(selected.weapon)
        ply:AresNotify("l:trashbin_loot_end")
        ply:SetBottomMessage("Порывшись в мусорке, вы нашли " .. selected.name)
    else
        ply:AresNotify("Вы ничего не нашли.")
    end
end

function ENT:Use(ply)
    if ply:GetRoleName() != "Cleaner" then
        return
    end

    if (ply.nextusetrash or 0) > CurTime() then
        return
    end

    ply.nextusetrash = CurTime() + 3

    if self.looted then
        return ply:AresNotify("l:trashbin_empty")
    end

    ply:BrProgressBar("l:looting_trash_can", 10, "nextoren/gui/icons/hand.png", self, false, function()
        local trent = ply:GetEyeTrace().Entity
        if trent == self then
            RandomWeapon(ply)
            self.looted = true
        end
    end)
end
