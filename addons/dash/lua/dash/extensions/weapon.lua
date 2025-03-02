local WEAPON, ENTITY = FindMetaTable 'Weapon', FindMetaTable 'Entity'
local GetTable = ENTITY.GetTable
local GetOwner = ENTITY.GetOwner

local ownerkey = 'Owner'
function WEAPON:__index(key)
    local val = WEAPON[key]
    if val ~= nil then return val end
    val = ENTITY[key]
    if val ~= nil then return val end
    local tab = GetTable(self)

    if tab ~= nil then
        val = tab[key]
        if val ~= nil then return val end
    end

    if key == ownerkey then return GetOwner(self) end
end