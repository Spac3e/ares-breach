BONEMERGE_HAIR_RESTRICTED = {
    ["head"] = true,
    ["helmet"] = true,
    ["headup"] = true,
    ["head_extra"] = true,
}

BONEMERGE_AUTO_PARENT = {
    ["gear"] = "body",
    ["backpack"] = "body"
}

function PickHeadModel(steamid64, isfemale)
    local model = "models/cultist/heads/male/male_head_" .. math.random(1, 215) .. ".mdl"
    if model == "models/cultist/heads/male/male_head_213.mdl" then model = "models/cultist/heads/male/male_head_1.mdl" end
    if steamid64 == "76561199064971307" then model = "models/cultist/heads/male/male_head_165.mdl" end
    if isfemale then model = "models/cultist/heads/female/female_head_" .. math.random(1, 52) .. ".mdl" end
    return model
end

function PickFaceSkin(black, steamid64, isfemale)
    if not isfemale then
        if steamid64 == "76561199064971307" then return "models/cultist/heads/male/black/male_face_black_281" end
        if not black then
            return "models/cultist/heads/male/male_face_" .. math.random(1, 700)
        else
            return "models/cultist/heads/male/black/male_face_black_" .. math.random(1, 300)
        end
    else
        if not black then
            return "models/cultist/heads/female/female_face_" .. math.random(1, 135)
        else
            return "models/cultist/heads/female/black/female_face_black_" .. math.random(1, 8)
        end
    end
end

CORRUPTED_HEADS = {
    ["models/cultist/heads/male/male_head_2.mdl"] = true,
    ["models/cultist/heads/male/male_head_3.mdl"] = true,
    ["models/cultist/heads/male/male_head_6.mdl"] = true
}

local PLAYER = FindMetaTable("Player")

function PLAYER:getRagdoll()
    return self:GetNWEntity("RagdollEntityNO")
end