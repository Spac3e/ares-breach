--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_base_main/o_cl_model.lua

--]]


local LocalPlayer = LocalPlayer
local IsValid = IsValid
local FrameTime = FrameTime
local CurTime = CurTime
local EyePos = EyePos
local EyeAngles = EyeAngles
local Lerp = Lerp

local _reg = debug.getregistry()
local _ent = _reg.Entity

local EntGetBoneMatrix = _ent.GetBoneMatrix
local EntGetAttachment = _ent.GetAttachment
local EntLookupBone = _ent.LookupBone

local _ang = _reg.Angle
local AngRotateAroundAxis = _ang.RotateAroundAxis
local AngUp = _ang.Up
local AngRight = _ang.Right
local AngForward = _ang.Forward

local _R = _G['debug']['getregistry']()
local setholdtype = _R['Weapon']['SetHoldType']
local gettable = _R['Entity']['GetTable']
local getowner = _R['Weapon']['GetOwner']
local gteam = _R['Player']['GTeam']
local isvalid = _R['Entity']['IsValid']

local _reg = debug.getregistry()
local _ent = _reg.Entity
local _ply = _reg.Player
local _wep = _reg.Weapon
local _enterthematrix = _reg.VMatrix

local stringfind = string.find
local entgetsequence = _ent.GetSequence
local entgetsequencename = _ent.GetSequenceName
local mgettranslation = _enterthematrix.GetTranslation
local mgetang = _enterthematrix.GetAngles
local entgetpos = _ent.GetPos
local entgetang = _ent.GetAngles
local entsetnodraw = _ent.SetNoDraw
local entsetupbones = _ent.SetupBones
local entsetpos = _ent.SetPos
local entsetang = _ent.SetAngles
local entdrawshadow = _ent.DrawShadow
local entdrawmodel = _ent.DrawModel
local camignorez = cam.IgnoreZ
local wepdrawinteractionmenu = _wep.drawInteractionMenu
local lply = LocalPlayer()
local entframeadvance = _ent.FrameAdvance
local math = math
local mathapproach = math.Approach
local entgetparent = _ent.GetParent
local entsetparent = _ent.SetParent

//-----------------------------------------------------------------------------
// getMuzzlePosition edited to be usable in third person
//-----------------------------------------------------------------------------

local att, vm

local muz = {}

function SWEP:getMuzzlePosition()
	if self.Owner:ShouldDrawLocalPlayer() then
		muz.Pos = EntGetAttachment(self.WMEnt, 1).Pos
		muz.Ang = EyeAngles()
		return muz
	end

	if self.MuzzleAttachment != 0 then
		return EntGetAttachment(self.CW_VM, self.MuzzleAttachment)
	end

	muz.Pos = self.Owner:EyePos()
	muz.Ang = self.Owner:EyeAngles()
	return muz
end

//-----------------------------------------------------------------------------
// LookupBone("[__INVALIDBONE__]") returns nil
// so I store int that I used with GetBoneName
//-----------------------------------------------------------------------------

function SWEP:buildBoneTable()
	local vm = self.CW_VM

	for i = 0, vm:GetBoneCount() - 1 do
		local boneName = vm:GetBoneName(i)
		local bone

		if boneName then
			bone = EntLookupBone(vm, boneName)
		end

		-- some ins models have [__INVALIDBONE__]s so to prevent nilpointerexceptions bone = 1
		self.vmBones[i + 1] = {boneName = boneName, bone = i, curPos = Vector(), curAng = Angle(), targetPos = Vector(), targetAng = Angle()}
	end
end

//-----------------------------------------------------------------------------
// createCustomVM edited to initialize additional models
//-----------------------------------------------------------------------------

function SWEP:createCustomVM(mdl)
	self.CW_VM = self:createManagedCModel(mdl, RENDERGROUP_BOTH)
	self.CW_VM:SetNoDraw(true)
	self.CW_VM:SetupBones()
	self.CW_VM:SelectWeightedSequence(ACT_VM_HOLSTER)
	self.CW_VM:SetCycle(1)

	self.CW_KK_HANDS = self:createManagedCModel(self.CW_KK_HANDS_MDL, RENDERGROUP_BOTH)
	self.CW_KK_HANDS:SetNoDraw(true)
	self.CW_KK_HANDS:SetupBones()
	self.CW_KK_HANDS:SetParent(self.CW_VM)
	self.CW_KK_HANDS:AddEffects(EF_BONEMERGE)
	self.CW_KK_HANDS:AddEffects(EF_BONEMERGE_FASTCULL)

	if self.Viewmodel_OffsetBones then
		for i, v in pairs(self.Viewmodel_OffsetBones) do
			self.CW_KK_HANDS:ManipulateBonePosition(i, v)
		end
	end

	self.CW_GREN = self:createManagedCModel(self.CW_GREN_TWEAK.vm, RENDERGROUP_BOTH)
	self.CW_GREN:SetNoDraw(true)
	self.CW_GREN:SetupBones()

	self.CW_KK_KNIFE = self:createManagedCModel(self.CW_KK_KNIFE_TWEAK.vm, RENDERGROUP_BOTH)
	self.CW_KK_KNIFE:SetNoDraw(true)
	self.CW_KK_KNIFE:SetupBones()

	// not rly a viewmodel but still need to stick it somewhere

	self.WMEnt = self:createManagedCModel(self.WorldModel, RENDERGROUP_BOTH)
	self.WMEnt:SetNoDraw(true)
	self.WMEnt:SetupBones()
end

//-----------------------------------------------------------------------------
// drawViewModel edited to draw quick knife viewmodel
//-----------------------------------------------------------------------------

function SWEP:drawViewModel()
	local selftable = gettable(self)

	if not selftable.CW_VM then
		return
	end

	selftable:offsetBones()

	local FT = FrameTime()

	selftable.LuaVMRecoilIntensity = mathapproach(selftable.LuaVMRecoilIntensity, 0, FT * 10 * selftable.LuaVMRecoilIntensity)
	selftable.LuaVMRecoilLowerSpeed = mathapproach(selftable.LuaVMRecoilIntensity, 1, FT * 2)

	self:applyOffsetToVM()
	self:_drawViewModel()

	self:drawGrenade()
	self:drawKKKnife()
end

function SWEP:drawQuickViewModel(vm)
	local pos, ang = EyePos(), EyeAngles()
	local FT = FrameTime()

	self.GrenadePos.z = Lerp(FT * 10, self.GrenadePos.z, 0)

	pos = pos + AngUp(ang) * self.GrenadePos.z
	pos = pos + AngForward(ang) * 2

	vm:SetPos(pos)
	vm:SetAngles(ang)
	vm:FrameAdvance(FT)

	cam.IgnoreZ(true)
		vm:DrawModel()
		self:DrawVMHandsModel()
	cam.IgnoreZ(false)
end

//-----------------------------------------------------------------------------
// _drawViewModel edited to draw hands-model entity and viewmodel shells
//-----------------------------------------------------------------------------

local cvAmmoHud = GetConVar("cw_customhud_ammo")
local cvSVM = CustomizableWeaponry_KK.ins2.conVars.main["cw_kk_ins2_shell_vm"]

function SWEP:_drawViewModel()
local selftable = gettable(self)

if !selftable._KK_INS2_PickedUp then return end
	selftable.CW_VM:FrameAdvance(FrameTime())
	selftable.CW_VM:SetupBones()

	local overrideVM = false
	for _,e in pairs(selftable.AttachmentModelsVM) do
		overrideVM = overrideVM or (e.active and e.hideVM)
		if overrideVM then break end
	end

	if not overrideVM then
		entdrawmodel(selftable.CW_VM)
	end

	local CT = CurTime()

	if CT > selftable.grenadeTime and CT > selftable.knifeTime then
		if entgetparent(selftable.CW_KK_HANDS) != selftable.CW_VM then
			entsetparent(selftable.CW_KK_HANDS, selftable.CW_VM)
		end

		self:DrawVMHandsModel()
	end

	if cvSVM:GetInt() == 1 then
		self:drawVMShells()
	end

	self:drawAttachments()
	self:drawInteractionMenu()

	if selftable.reticleFunc then
		selftable.reticleFunc(self)
	end

	if cvAmmoHud:GetInt() >= 1 then
		self:draw3D2DHUD()
	end
end

//-----------------------------------------------------------------------------
// createGrenadeModel contents moved to createCustomVM
//-----------------------------------------------------------------------------

function SWEP:createGrenadeModel() end

//-----------------------------------------------------------------------------
// drawGrenade edited to draw hands-model entity
//-----------------------------------------------------------------------------

function SWEP:drawGrenade()
	if CurTime() > self.grenadeTime then
		return
	end

	local pos, ang = EyePos(), EyeAngles()
	local FT = FrameTime()

	self.GrenadePos.z = Lerp(FT * 10, self.GrenadePos.z, 0)

	pos = pos + AngUp(ang) * self.GrenadePos.z
	pos = pos + AngForward(ang) * 2

	self.CW_GREN:SetPos(pos)
	self.CW_GREN:SetAngles(ang)
	self.CW_GREN:FrameAdvance(FT)

	cam.IgnoreZ(true)
		self.CW_GREN:DrawModel()
		self:DrawVMHandsModel()
	cam.IgnoreZ(false)
end

//-----------------------------------------------------------------------------
// drawKKKnife is exactly same as drawGrenade
//-----------------------------------------------------------------------------

function SWEP:drawKKKnife()
	if CurTime() > self.knifeTime then
		return
	end

	local pos, ang = EyePos(), EyeAngles()
	local FT = FrameTime()

	self.GrenadePos.z = Lerp(FT * 10, self.GrenadePos.z, 0)

	pos = pos + AngUp(ang) * self.GrenadePos.z
	pos = pos + AngForward(ang) * 2

	self.CW_KK_KNIFE:SetPos(pos)
	self.CW_KK_KNIFE:SetAngles(ang)
	self.CW_KK_KNIFE:FrameAdvance(FT)

	cam.IgnoreZ(true)
		self.CW_KK_KNIFE:DrawModel()
		self:DrawVMHandsModel()
	cam.IgnoreZ(false)
end

//-----------------------------------------------------------------------------
// setupAttachmentModels edited to support
// - custom attach points, bone-merging
// - globally pre-set sub-material override
// - individually set material and sub-material override
// - WElement init
//-----------------------------------------------------------------------------

function SWEP:setupAttachmentModels()
	if self.AttachmentModelsVM then
		for k, v in pairs(self.AttachmentModelsVM) do
			if v.models then
				for key, data in ipairs(v.models) do
					self:_setupAttachmentModel(data)
				end
			else
				self:_setupAttachmentModel(v)
			end
		end

		for k, v in pairs(self.AttachmentModelsVM) do
			if v.models then
				for key, data in ipairs(v.models) do
					self:_setupAttachmentModelMerge(data)
				end
			else
				self:_setupAttachmentModelMerge(v)
			end
		end
	end

	self:setupAttachmentWModels()
end

function SWEP:_setupAttachmentModel(v)
	v.ent = self:createManagedCModel(v.model, RENDERGROUP_BOTH)
	v.ent:SetNoDraw(true)

	v.active = v.active or false
	v.nodraw = v.nodraw or false

	v.matrix = Matrix()

	if v.size then
		v.matrix:Scale(v.size)
	end

	v.ent:EnableMatrix("RenderMultiply", v.matrix)

	if v.bodygroups then
		for main, sec in pairs(v.bodygroups) do
			v.ent:SetBodygroup(main, sec)
		end
	end

	if v.skin then
		v:SetSkin(v.skin)
	end

	v.ent:SetupBones()

	-- if v.merge then
		-- v.ent:SetParent(self.CW_VM)
		-- v.ent:AddEffects(EF_BONEMERGE)
		-- v.ent:AddEffects(EF_BONEMERGE_FASTCULL)
	-- end

	if v.attachment then
		v._attachment = self.CW_VM:LookupAttachment(v.attachment)
	end

	if v.bone then
		v._bone = EntLookupBone(self.CW_VM, v.bone)
	end

	for i,mat in pairs(v.ent:GetMaterials()) do
		if CustomizableWeaponry_KK.ins2.nodrawMat[mat] then
			v.ent:SetSubMaterial(i - 1, CustomizableWeaponry_KK.ins2.nodrawMatPath)
		end
	end

	if v.material then
		v.ent:SetMaterial(v.material)
	elseif v.materials then
		for i,path in pairs(v.materials) do
			v.ent:SetSubMaterial(i - 1, path)
		end
	end
end

function SWEP:_setupAttachmentModelMerge(v)
	if v.merge then
		if v.rel and self.AttachmentModelsVM[v.rel] then
			v.ent:SetParent(self.AttachmentModelsVM[v.rel].ent)
		else
			v.ent:SetParent(self.CW_VM)
		end

		v.ent:AddEffects(EF_BONEMERGE)
		v.ent:AddEffects(EF_BONEMERGE_FASTCULL)
	end
end

//-----------------------------------------------------------------------------
// drawAttachments edited to support custom attach points and lighting recomp.
//-----------------------------------------------------------------------------

function SWEP:drawAttachments()
	local selftable = gettable(self)
	local attachments = selftable.AttachmentModelsVM

	if not attachments then
		return false
	end

	local FT = FrameTime()

	for k, v in pairs(attachments) do
		if v.active and selftable._skipDrawingScope != k then
			self:_drawAttachmentModels(v)
		end
	end

	for k, v in pairs(selftable.elementRender) do
		v(self)
	end

	return true
end

local nFront, nRight, nTop = Vector(1,0,0), Vector(0,1,0), Vector(0,0,1)
local nBack, nLeft, nBottom = -1 * nFront, -1 * nRight, -1 * nTop

local function recomputeLighting(i, pos, ang)
	if i == 1 then
		render.SuppressEngineLighting(true)

		local lFront = render.ComputeLighting(pos, nFront)
		local lBack = render.ComputeLighting(pos, nBack)

		local lRight = render.ComputeLighting(pos, nRight)
		local lLeft = render.ComputeLighting(pos, nLeft)

		local lTop = render.ComputeLighting(pos, nTop)
		local lBottom = render.ComputeLighting(pos, nBottom)

		render.SetModelLighting(BOX_FRONT, lFront.x, lFront.y, lFront.z)
		render.SetModelLighting(BOX_BACK, lBack.x, lBack.y, lBack.z)

		render.SetModelLighting(BOX_RIGHT, lRight.x, lRight.y, lRight.z)
		render.SetModelLighting(BOX_LEFT, lLeft.x, lLeft.y, lLeft.z)

		render.SetModelLighting(BOX_TOP, lTop.x, lTop.y, lTop.z)
		render.SetModelLighting(BOX_BOTTOM, lBottom.x, lBottom.y, lBottom.z)
	else
		render.SuppressEngineLighting(false)
	end
end

local cvarFixScopes = CustomizableWeaponry_KK.ins2.conVars.main["cw_kk_ins2_scopelightingfix"]

local active, pos, ang, m, vma, model, doRecompute, parent

function SWEP:_drawAttachmentModel(v)
	local v = v
	if not v.ent then
		return
	end

	local selftable = gettable(self)
	local attmodelsvm = selftable.AttachmentModelsVM

	if v.rel and attmodelsvm[v.rel] then
		parent = attmodelsvm[v.rel].ent
	else
		parent = selftable.CW_VM
	end

	model = v.ent

	pos = entgetpos(parent)
	ang = entgetang(parent)

	if v.merge then
		-- if model:GetParent() != parent then
			-- model:SetParent(parent)
		-- end
	else
		if v._attachment then
			vma = EntGetAttachment(parent, v._attachment)
			pos = vma.Pos
			ang = vma.Ang
		elseif v._bone then
			m = EntGetBoneMatrix(parent, v._bone)
			pos = mgettranslation(m)
			ang = mgetang(m)
		end

		pos = pos + AngForward(ang) * v.pos.x + AngRight(ang) * v.pos.y + AngUp(ang) * v.pos.z

		AngRotateAroundAxis(ang, AngUp(ang), v.angle.y)
		AngRotateAroundAxis(ang, AngRight(ang), v.angle.p)
		AngRotateAroundAxis(ang, AngForward(ang), v.angle.r)

		entsetpos(model, pos)
		entsetang(model, ang)
	end

	if v.animated then
		entframeadvance(model, FrameTime())
		entsetupbones(model)
	end

	if !v.nodraw then
		doRecompute = v.rLight and cvarFixScopes:GetInt() == 1
		recomputeLighting(doRecompute and 1 or false, pos, ang)
			entdrawmodel(model)
		recomputeLighting(true or whatever, pos, ang)
	end
end

//-----------------------------------------------------------------------------
// DrawWorldModel edited to support
// - attachment world models (WElements)
// - 3rd person 3D2D HUD
//-----------------------------------------------------------------------------

local custom_angle = Vector( 10, 0, 180 )
local aim_angle = Vector( 10, -5, 180 )
local origin_angle = Vector( -10, 0, 180 )
local team_spec_id = TEAM_SPEC

function SWEP:DrawWorldModel()
	local selftable = gettable(self)

	local state = selftable.dt.State
	local runholdtype = selftable.RunHoldType
	local normalholdtype = selftable.NormalHoldType
	local choldtype = selftable.CHoldType

	if selftable.dt.Safe then

		if choldtype != runholdtype then

			setholdtype(self, runholdtype)
			selftable.CHoldType = runholdtype

		end

	else

		if selftable.IsNadeWeapon then
			if selftable.dt.ReadyToThrow then
				setholdtype(self, "throw")
				selftable.CHoldType = "throw"
			else
				setholdtype(self, normalholdtype)
				selftable.CHoldType = normalholdtype
			end
		elseif state == CW_RUNNING or state == CW_ACTION then
			if choldtype != runholdtype then
				setholdtype(self, runholdtype)
				selftable.CHoldType = runholdtype
			end
		else
			if choldtype != normalholdtype then
				setholdtype(self, normalholdtype)
				selftable.CHoldType = normalholdtype
			end
		end

	end

	local owner = getowner(self)

	if owner && isvalid(owner) && gteam(owner) != team_spec_id then
		if not selftable.OwnerAttachBoneID then
			selftable.OwnerAttachBoneID = EntLookupBone(owner, "ValveBiped.Bip01_R_Hand" || 0 )
		end

		if ( !selftable.OwnerAttachBoneID ) then return end
		m = EntGetBoneMatrix(owner, selftable.OwnerAttachBoneID)

		if ( !m ) then

			m = EntGetBoneMatrix( owner, EntLookupBone( owner, "ValveBiped.Bip01_R_Hand" ) || 0 )

			if ( !m ) then return end

		end

		if ( owner ) then

			local id = entgetsequence(owner)
			local name = entgetsequencename(owner, id)

			if ( stringfind(name, "Aim_MP40") || stringfind(name, "ZOOMED") ) then

				if ( selftable.OwnerAttachBoneID != 16 ) then

					selftable.WMAng = aim_angle

				end

			elseif ( stringfind( name, "DOD_" ) || stringfind( name, "AHL_" ) ) then

				if ( selftable.OwnerAttachBoneID != 16 ) then

					selftable.WMAng = custom_angle

				end

			else

				selftable.WMAng = origin_angle

			end

		end

		pos = mgettranslation(m)
		ang = mgetang(m)

		pos = pos + AngForward(ang) * selftable.WMPos.x + AngRight(ang) * selftable.WMPos.y + AngUp(ang) * selftable.WMPos.z

		AngRotateAroundAxis(ang, AngUp(ang), selftable.WMAng.y)
		AngRotateAroundAxis(ang, AngRight(ang), selftable.WMAng.x)
		AngRotateAroundAxis(ang, AngForward(ang), selftable.WMAng.z)

	else

		selftable.OwnerAttachBoneID = false

		pos = entgetpos(self)
		ang = entgetang(self)

	end

	if ( !( selftable.WMEnt && isvalid(selftable.WMEnt) ) ) then

		selftable.WMEnt = self:createManagedCModel(selftable.WorldModel, RENDERGROUP_BOTH)
		entsetnodraw(selftable.WMEnt, true)
		entsetupbones(selftable.WMEnt)

	end

	local wment = selftable.WMEnt

	entsetpos(wment, pos)
	entsetang(wment, ang)

	entdrawshadow(wment, false)

	local overrideVM = false
	local attachments = selftable.AttachmentModelsWM
	if attachments then
		for i = 1, #attachments do
			local e = attachments[i]
			if !isvalid(e) then continue end
			overrideVM = overrideVM || (e.active && e.hideVM)
			if overrideVM then break end
		end
	end

	if not overrideVM then
		entdrawmodel(wment)
	end

	self:drawAttachmentsWorld(wment)

	selftable.HUD_3D2DScale = selftable.HUD_3D2DScale * 1.5
	selftable.CustomizationMenuScale = selftable.CustomizationMenuScale * 1.5

	if owner && isvalid(owner) && owner == lply then

		camignorez(true)

		self:drawInteractionMenu()

		camignorez(false)

	end

	selftable.HUD_3D2DScale = selftable.HUD_3D2DScale / 1.5
	selftable.CustomizationMenuScale = selftable.CustomizationMenuScale / 1.5
end

//-----------------------------------------------------------------------------
// initialize attachment world models (WElements)
//-----------------------------------------------------------------------------

function SWEP:setupAttachmentWModels()
	if self.AttachmentModelsWM then
		local parent = self
		if IsValid(self.WMEnt) then
			parent = self.WMEnt
		end

		parent:SetupBones()

		for k, v in pairs(self.AttachmentModelsWM) do
			v.ent = self:createManagedCModel(v.model, RENDERGROUP_BOTH)
			v.ent:SetNoDraw(true)

			v.active = v.active or false

			if v.size then
				v.matrix = Matrix()

				v.matrix:Scale(v.size)
				v.ent:EnableMatrix("RenderMultiply", v.matrix)
			end

			if v.bodygroups then
				for main, sec in pairs(v.bodygroups) do
					v.ent:SetBodygroup(main, sec)
				end
			end

			if v.skin then
				v:SetSkin(v.skin)
			end

			if v.merge then
				v.ent:SetParent(parent)
				v.ent:AddEffects(EF_BONEMERGE)
				v.ent:AddEffects(EF_BONEMERGE_FASTCULL)
			end

			if v.attachment then
				v._attachment = parent:LookupAttachment(v.attachment)
			end

			if v.bone then
				v._bone = EntLookupBone(parent, v.bone)
			end

			for i,mat in pairs(v.ent:GetMaterials()) do
				if CustomizableWeaponry_KK.ins2.nodrawMat[mat] then
					v.ent:SetSubMaterial(i - 1, CustomizableWeaponry_KK.ins2.nodrawMatPath)
				end
			end

			if v.material then
				v.ent:SetMaterial(v.material)
			elseif v.materials then
				for i,path in pairs(v.materials) do
					v.ent:SetSubMaterial(i - 1, path)
				end
			end

			v.ent:SetupBones()
		end
	end
end

//-----------------------------------------------------------------------------
// draw attachment world models (WElements)
//-----------------------------------------------------------------------------

function SWEP:drawAttachmentsWorld(parent)
	local selftable = gettable(self)
	local attachmentswm = selftable.AttachmentModelsWM

	if !isvalid(parent) then
		return
	end

	if attachmentswm then
		for k, v in pairs(attachmentswm) do
			if v.ent and v.active then
				model = v.ent

				if v.merge then
					-- if model:GetParent() != parent then
						-- model:SetParent(parent)
					-- end
				else
					pos = entgetpos(parent)
					ang = entgetang(parent)

					if v._attachment then
						vma = EntGetAttachment(parent, v._attachment)
						pos = vma.Pos
						ang = vma.Ang
					elseif v._bone then
						m = EntGetBoneMatrix(parent, v._bone)
						pos = mgettranslation(m)
						ang = mgetang(m)
					end

					pos = pos + AngForward(ang) * v.pos.x + AngRight(ang) * v.pos.y + AngUp(ang) * v.pos.z

					AngRotateAroundAxis(ang, AngUp(ang), v.angle.y)
					AngRotateAroundAxis(ang, AngRight(ang), v.angle.p)
					AngRotateAroundAxis(ang, AngForward(ang), v.angle.r)

					if isvalid(model) then
						entsetpos(model, pos)
						entsetang(model, ang)
					end
				end

				if !v.nodraw and isvalid(model) then
					entdrawmodel(model)
				end
			end
		end
	end
end

//-----------------------------------------------------------------------------
// processFOVChanges edited to take dt.INS2GLActive into account
//-----------------------------------------------------------------------------

function SWEP:processFOVChanges(deltaTime)
	if self.dt.State == CW_AIMING then
		if self.dt.INS2GLActive then
			self.CurVMFOV = LerpCW20(deltaTime * 10, self.CurVMFOV, 60)
		else
			if self.AimPos == self.SightBackUpPos and self.AimAng == self.SightBackUpAng then
				self.CurVMFOV = LerpCW20(deltaTime * 10, self.CurVMFOV, self.AimViewModelFOV_Orig)
			else
				if self.SimpleTelescopicsFOV then
					self.CurVMFOV = LerpCW20(deltaTime * 10, self.CurVMFOV, self.AimViewModelFOV)
				else
					self.CurVMFOV = LerpCW20(deltaTime * 10, self.CurVMFOV, GetConVar("breach_config_cw_viewmodel_fov"):GetFloat())
				end
			end
		end
	else
		self.CurVMFOV = LerpCW20(deltaTime * 10, self.CurVMFOV, GetConVar("breach_config_cw_viewmodel_fov"):GetFloat())
	end

	self.ViewModelFOV = self.CurVMFOV
end

//-----------------------------------------------------------------------------
// scaleMovement edited to use sprint state dependent base values
//-----------------------------------------------------------------------------

local sth = CustomizableWeaponry_KK.ins2.conVars.main["cw_kk_ins2_sprint"]

function SWEP:scaleMovement(val, mod)
	local scale = self.ViewModelMovementScale

	if sth:GetInt() == 1 then
		if self.Sequence:find("sprint") then
			return 0
		else
			return val * self.ViewModelMovementScale_base * mod
		end
	end

	if self.Slot != 2 and self.Slot != 3 then
		if self.Sequence:find("sprint") then
			scale = self.ViewModelMovementScale_sprint
		else
			scale = self.ViewModelMovementScale_base
		end
	end

	if self.ActiveAttachments.kk_ins2_ww2_knife or self.ActiveAttachments.kk_ins2_ww2_knife_fat then
		if self.Sequence:find("sprint") then
			scale = self.ViewModelMovementScale_base / 4
		else
			scale = self.ViewModelMovementScale_base
		end
	end

	return val * scale * mod
end

//-----------------------------------------------------------------------------
// DrawVMHandsModel detached from and shared between
// _drawViewModel, drawGrenade and drawKKKnife
//-----------------------------------------------------------------------------

function SWEP:DrawVMHandsModel()
	local gm = self.Owner:GetHands()

	if !IsValid(gm) then
		self.CW_KK_HANDS:DrawModel()
		return
	end

	if self.UseGMHands then
		if gm:GetParent() != self.CW_KK_HANDS then
			gm:SetParent(self.CW_KK_HANDS)
			gm:AddEffects(EF_BONEMERGE)
			gm:AddEffects(EF_BONEMERGE_FASTCULL)
		end

		gm:DrawModel()
	else
		if gm:GetParent() == self.CW_KK_HANDS then
			gm:SetParent(nil)
		end

		self.CW_KK_HANDS:DrawModel()
	end
end
