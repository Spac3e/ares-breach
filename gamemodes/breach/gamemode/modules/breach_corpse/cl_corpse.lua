net.Receive("ParticleAttach", function()
	local particle_name = net.ReadString()
	local attach_entity = net.ReadEntity()
	local bone_id = net.ReadUInt( 4 )

	ParticleEffectAttach(particle_name, PATTACH_POINT_FOLLOW, attach_entity, bone_id || 3)
end)

net.Receive("Breach_DrawEffect", function()
    local ent = net.ReadEntity()
    local name = net.ReadString()
    local bone_id = net.ReadUInt(8)

    local ed = EffectData()

    if IsValid(ent) then
        ed:SetEntity(ent)
    else
        return
    end

    ed:SetMagnitude(bone_id)
    ed:SetColor(BLOOD_COLOR_RED)
	
    util.Effect(name, ed, true, true)
end)