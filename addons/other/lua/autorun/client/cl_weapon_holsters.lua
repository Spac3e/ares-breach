CreateClientConVar("cl_weapon_holsters", "1", true, false, "Enable Weapon Holsters (client side)")

WepHolster = WepHolster or {}
WepHolster.wepInfo = WepHolster.wepInfo or {}

net.Receive("sendWholeWHData", function(len)
	WepHolster.wepInfo = net.ReadTable()
end)

net.Receive("sendWHData", function(len)
	local class = net.ReadString()
	local tbl = net.ReadTable()
	WepHolster.wepInfo[class] = tbl.Model and tbl or nil

	if not tbl.Model then
		for pl, weps in pairs(WepHolster.HolsteredWeps) do
			local ply = Entity(pl)

			for cls, wep in pairs(weps) do
				if cls == class then
					wep:Remove()
					WepHolster.HolsteredWeps[pl][cls] = nil
				end
			end
		end
	end
end)

WepHolster.HolsteredWeps = WepHolster.HolsteredWeps or {}

local function CalcOffset(pos, ang, off)
	return pos + ang:Right() * off.x + ang:Forward() * off.y + ang:Up() * off.z
end

local function cdwh()
	return WepHolster.wepInfo and WepHolster.HolsteredWeps
end

hook.Add("PostPlayerDraw", "WeaponHolster", function(ply)
	--if !GetConVar("breach_config_holsters"):GetBool() then
		--return
	--end

	if not cdwh() then
		return
	end

	if ply:IsDormant() then
		return
	end

	if ply:GetObserverMode() == OBS_MODE_NONE and ply:Health() >= 0 and ply:IsLineOfSightClear(LocalPlayer():GetShootPos()) then
		local wepinfo = WepHolster.wepInfo
		local plyt = ply:GetTable()

		local holsteredweps = ply:GetWeapons()

		for i = 1, #holsteredweps do
			local v = holsteredweps[i]

			if !IsValid(v) then continue end
			local vt = v:GetTable()
			if vt.NoCSModel then continue end

			local actwep = ply:GetActiveWeapon()

			if actwep and v == actwep then
				if actwep.WepHolsterCreatedCSModel then
					actwep.WepHolsterCreatedCSModel:Remove()
				end
				continue
			end

			local wepclass = v:GetClass()
			if !wepinfo[wepclass] then
				continue
			end

			if !vt.BoneForWepHolster then
				local bone = ply:LookupBone(wepinfo[wepclass].Bone)

				if not bone then
					return
				end

				vt.BoneForWepHolster = bone
			end

			local matrix = ply:GetBoneMatrix(vt.BoneForWepHolster)

			if not matrix then
				return
			end

			if !IsValid(vt.WepHolsterCreatedCSModel) then
				vt.WepHolsterCreatedCSModel = ClientsideModel(v:GetModel())
				if vt.WepHolsterCreatedCSModel then
					vt.WepHolsterCreatedCSModel:SetMoveType(MOVETYPE_NONE)
					vt.WepHolsterCreatedCSModel:SetParent(ply)
					vt.WepHolsterCreatedCSModel.IsWepHolster = true

					if !plyt.WepHolsterCSModels then
						plyt.WepHolsterCSModels = {}
					end

					table.insert(plyt.WepHolsterCSModels, vt.WepHolsterCreatedCSModel)
				else
					vt.NoCSModel = true
					continue
				end
			end

			local boneoffset = wepinfo[wepclass].BoneOffset

			local boneoffset1 = boneoffset[1]
			local boneoffset2 = boneoffset[2]
			local boneoffset2p = boneoffset2.p
			local boneoffset2y = boneoffset2.y
			local boneoffset2r = boneoffset2.r

			local ang = matrix:GetAngles()
			local pos = matrix:GetTranslation()

			if !vt.AngForWepHolster then
				ang:RotateAroundAxis(ang:Forward(), boneoffset2p)
				ang:RotateAroundAxis(ang:Up(), boneoffset2y)
				ang:RotateAroundAxis(ang:Right(), boneoffset2r)
				vt.AngForWepHolster = ang
			end

			pos = CalcOffset(pos, ang, boneoffset1)
			ang:RotateAroundAxis(ang:Forward(), boneoffset2p)
			ang:RotateAroundAxis(ang:Up(), boneoffset2y)
			ang:RotateAroundAxis(ang:Right(), boneoffset2r)
			vt.WepHolsterCreatedCSModel:SetRenderOrigin(pos)
			vt.WepHolsterCreatedCSModel:SetRenderAngles(ang)
			vt.WepHolsterCreatedCSModel:DrawModel()

		end
	else
		local holsteredweps = ply:GetWeapons()

		for i = 1, #holsteredweps do
			local v = holsteredweps[i]
			local vt = v:GetTable()

			if vt.WepHolsterCreatedCSModel then
				vt.WepHolsterCreatedCSModel:Remove()
			end
		end
	end
end)

net.Receive("OptimizedWeaponHolsters_WeaponDrop", function()
	local ply = net.ReadEntity()
	local wep = net.ReadEntity()

	if !IsValid(ply) then return end
	if !IsValid(wep) then return end

	if wep.WepHolsterCreatedCSModel then
		wep.WepHolsterCreatedCSModel:Remove()
	end
end)

hook.Add("PlayerSwitchedWeapon", "OptimizedWeaponHolsters", function(ply, old, new)
	for k, v in ipairs(ply:GetWeapons()) do
		if ply.GetActiveWeapon then
			if ply:GetActiveWeapon() == v then
				if v.WepHolsterCreatedCSModel then
					v.WepHolsterCreatedCSModel:Remove()
				end
			end
		end
	end
end)

hook.Add("PostCleanupMap", "OptimizedWeaponHolsters", function()
	for k, v in ipairs(ents.FindByClass("class C_BaseFlex")) do
		if v.IsWepHolster then
			v:Remove()
		end
	end
end)

gameevent.Listen( "entity_killed" )
hook.Add("entity_killed", "OptimizedWeaponHolsters", function(data)
	local inflictor_index = data.entindex_inflictor		// Same as Weapon:EntIndex() / weapon used to kill victim
	local attacker_index = data.entindex_attacker		// Same as Player/Entity:EntIndex() / person or entity who did the damage
	local damagebits = data.damagebits			// DAMAGE_TYPE - use BIT operations to decipher damage types...
	local victim_index = data.entindex_killed		// Same as Victim:EntIndex() / the entity / player victim

	local ply = Entity(victim_index)

	if !IsValid(ply) then return end

	if ply.WepHolsterCSModels then
		for k, v in ipairs(ply.WepHolsterCSModels) do
			if v and IsValid(v) then
				v:Remove()
			end
		end
	end
end)

hook.Add("Think", "WeaponHolster", function()
	if not cdwh() then
		return
	end

	local wepinfo = WepHolster.wepInfo

	local plys = player.GetAll()
	for i = 1, #plys do
		local ply = plys[i]

		if ply:IsDormant() then continue end

		if ply:GetObserverMode() == OBS_MODE_NONE and ply:Health() >= 0 then
			local weps = ply:GetWeapons()
			for i = 1, #weps do
				local v = weps[i]
				local class = v:GetClass()
				local plyid = ply:EntIndex()
				WepHolster.HolsteredWeps[plyid] = WepHolster.HolsteredWeps[plyid] or {}

				if wepinfo[class] and ply:GetActiveWeapon() ~= v and not WepHolster.HolsteredWeps[plyid][class] then
					WepHolster.HolsteredWeps[plyid][class] = ClientsideModel(wepinfo[class].Model, RENDERGROUP_OPAQUE)
					if wepinfo[class].Skin then
						WepHolster.HolsteredWeps[plyid][class]:SetSkin(wepinfo[class].Skin)
					end

					if not IsValid(WepHolster.HolsteredWeps[plyid][class]) then
						SafeRemoveEntity(WepHolster.HolsteredWeps[plyid][class]) -- just in case.
						WepHolster.HolsteredWeps[plyid][class] = nil

						return
					end

					WepHolster.HolsteredWeps[plyid][class]:SetNoDraw(true)

					if wepinfo[class].isEditing then
						WepHolster.HolsteredWeps[plyid][class]:SetMaterial("models/wireframe")
						--print("wireframe화 think")
						--print(wepinfo[class].isEditing)
					end
				end
			end
		end
	end

	-- 필요없는 CSEnt 찾아서 삭제
	for pl, weps in pairs(WepHolster.HolsteredWeps) do
		local ply = Entity(pl)

		for class, wep in pairs(weps) do
			if not IsValid(ply) or not ply:IsPlayer() or ply:GetObserverMode() != OBS_MODE_NONE and ply:Health() < 0 or (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == class) or not IsValid(ply:GetWeapon(class)) then
				wep:Remove() -- 삭제
				WepHolster.HolsteredWeps[pl][class] = nil

				return
			end
		end
	end
end)