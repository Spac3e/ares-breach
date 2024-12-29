function Bonemerge(mdl, ent, skin, submaterial, bodygroups, shadow, nodraw)
    if not IsValid(ent) then
        return
    end

    if not ent.BoneMergedEnts then
        ent.BoneMergedEnts = {}
    end

    local parent = ent

    local bonemerge = ents.Create("breach_bonemerge")
    bonemerge:SetModel(mdl)
    bonemerge:Spawn()
    bonemerge:SetOwner(ent)
    bonemerge:SetParent(parent)
    bonemerge:SetLocalPos(vector_origin)
    bonemerge:SetLocalAngles(angle_zero)
    bonemerge:SetMoveType(MOVETYPE_NONE)
    bonemerge:AddEffects(EF_BONEMERGE)
    bonemerge:AddEffects(EF_BONEMERGE_FASTCULL)
    bonemerge:AddEffects(EF_PARENT_ANIMATES)
    bonemerge:SetSkin(skin or 0)
    bonemerge:DrawShadow(shadow or true)

    for k, v in pairs(bodygroups or {}) do
        bonemerge:SetBodygroup(k, v)
    end

    if not mdl:find("head_gear") and (mdl:find("head") or mdl:find("balaclava")) and not (mdl:find("hair")) then
        if submaterial then
            local index = 0

            if strfind(bonemerge:GetMaterials()[1], "eye") then
                index = 1
            end

            bonemerge:SetSubMaterial(index, submaterial)
        end

        ent.HeadEnt = bonemerge
    end

    ent.BoneMergedEnts[#ent.BoneMergedEnts + 1] = bonemerge

    return bonemerge
end