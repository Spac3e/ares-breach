BREACHLEGS = BREACHLEGS or {}
BREACHLEGS.legEnt = BREACHLEGS.legEnt or nil
BREACHLEGS.playBackRate = 1
BREACHLEGS.sequence = nil
BREACHLEGS.velocity = 0
BREACHLEGS.oldWeapon = nil
BREACHLEGS.breathScale = 0.5
BREACHLEGS.nextBreath = 0
BREACHLEGS.renderAngle = nil
BREACHLEGS.biaisAngle = nil
BREACHLEGS.radAngle = nil
BREACHLEGS.renderPos = nil
BREACHLEGS.renderColor = {}
BREACHLEGS.clipVector = vector_up * -1
BREACHLEGS.forwardOffset = -20
BREACHLEGS.nextMatSet = CurTime()
BREACHLEGS.lastRoleName = BREACHLEGS.lastRoleName or 0
BREACHLEGS.lastCharName = BREACHLEGS.lastCharName or 0

local hiddenBones = {"ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Neck1", "ValveBiped.Bip01_Head1", "ValveBiped.forward", "ValveBiped.Bip01_R_Clavicle", "ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand", "ValveBiped.Anim_Attachment_RH", "ValveBiped.Bip01_L_Clavicle", "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand", "ValveBiped.Anim_Attachment_LH", "ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42", "ValveBiped.Bip01_L_Finger3", "ValveBiped.Bip01_L_Finger31", "ValveBiped.Bip01_L_Finger32", "ValveBiped.Bip01_L_Finger2", "ValveBiped.Bip01_L_Finger21", "ValveBiped.Bip01_L_Finger22", "ValveBiped.Bip01_L_Finger1", "ValveBiped.Bip01_L_Finger11", "ValveBiped.Bip01_L_Finger12", "ValveBiped.Bip01_L_Finger0", "ValveBiped.Bip01_L_Finger01", "ValveBiped.Bip01_L_Finger02", "ValveBiped.Bip01_R_Finger4", "ValveBiped.Bip01_R_Finger41", "ValveBiped.Bip01_R_Finger42", "ValveBiped.Bip01_R_Finger3", "ValveBiped.Bip01_R_Finger31", "ValveBiped.Bip01_R_Finger32", "ValveBiped.Bip01_R_Finger2", "ValveBiped.Bip01_R_Finger21", "ValveBiped.Bip01_R_Finger22", "ValveBiped.Bip01_R_Finger1", "ValveBiped.Bip01_R_Finger11", "ValveBiped.Bip01_R_Finger12", "ValveBiped.Bip01_R_Finger0", "ValveBiped.Bip01_R_Finger01", "ValveBiped.Bip01_R_Finger02", "ValveBiped.baton_parent"}
local META = FindMetaTable("Player")
function META:ShouldDrawLegs()
    return BREACHLEGS.legEnt and BREACHLEGS.legEnt:IsValid() and self:Alive() and not self:InVehicle() and self:GetViewEntity() == self and not self:ShouldDrawLocalPlayer() and not self:GetNoDraw() and self:GetObserverTarget() == NULL and GetConVar("breach_config_draw_legs"):GetBool() and EyeAngles().p > 0
end

function BREACHLEGS:CreateLegs()
    local ply = LocalPlayer()
    local legEnt = ClientsideModel(ply:GetModel(), RENDERGROUP_TRANSLUCENT)
    legEnt:SetNoDraw(true)
    legEnt:SetSkin(ply:GetSkin() or 0)
    legEnt:SetMaterial(ply:GetMaterial())
    legEnt:SetColor(ply:GetColor())
    for _, v in ipairs(ply:GetBodyGroups()) do
        legEnt:SetBodygroup(v.id, ply:GetBodygroup(v.id))
    end

    for k, v in pairs(ply:GetMaterials()) do
        legEnt:SetSubMaterial(k - 1, ply:GetSubMaterial(k - 1))
    end

    legEnt.LastTick = 0
    self.lastCharName = ply:GetNamesurvivor() or "none"
    self.lastRoleName = ply:GetRoleName() or "none"
    self.legEnt = legEnt
end

local up_vector = Vector(1, 1, 1)
local stay_vector = vector_origin
local vector_manipulate = Vector(5, -10, 0)
function BREACHLEGS:PlayerWeaponChanged(ply, weapon)
    if self.legEnt and self.legEnt:IsValid() then
        local legEnt = self.legEnt
        for i = 0, legEnt:GetBoneCount() do
            legEnt:ManipulateBoneScale(i, up_vector)
            legEnt:ManipulateBonePosition(i, stay_vector)
        end

        for _, v in ipairs(hiddenBones) do
            local bone = legEnt:LookupBone(v)
            if bone then
                legEnt:ManipulateBoneScale(bone, vector_origin)
                legEnt:ManipulateBonePosition(bone, vector_manipulate)
            end
        end
    end
end

function ClientBoneMerge(ent, model)
    local bonemerge_ent = ents.CreateClientside("breach_bonemerge")
    bonemerge_ent:SetModel(model)
    bonemerge_ent:SetSkin(ent:GetSkin() or 0)
    bonemerge_ent:Spawn()
    bonemerge_ent:SetParent(ent, 0)
    bonemerge_ent:SetLocalPos(vector_origin)
    bonemerge_ent:SetLocalAngles(angle_zero)
    bonemerge_ent:AddEffects(EF_BONEMERGE)
    if not ent.BoneMergedEnts then ent.BoneMergedEnts = {} end
    ent.BoneMergedEnts[#ent.BoneMergedEnts + 1] = bonemerge_ent
end

function BREACHLEGS:LegsWork(ply, speed)
    if not ply:ShouldDrawLegs() then return end
    if not ply:Alive() then
        self:CreateLegs()
        return
    end

    if not (self.legEnt and self.legEnt:IsValid()) then return end
    if self.lastCharName ~= ply:GetNamesurvivor() or self.lastRoleName ~= ply:GetRoleName() then
        self.legEnt:Remove()
        self:CreateLegs()
        self.playBackRate = 1
        self.sequence = nil
        self.velocity = 0
        self.oldWeapon = nil
        self.breathScale = .5
        self.nextBreath = 0
        self.renderAngle = nil
        self.biaisAngle = nil
        self.radAngle = nil
        self.renderPos = nil
        self.renderColor = {}
        self.clipVector = vector_up * -1
        self.forwardOffset = -20
        self.nextMatSet = CurTime() + 10
        self.lastCharName = ply:GetNamesurvivor()
    end

    local legEnt = self.legEnt
    local curTime = CurTime()
    if ply:GetActiveWeapon() ~= self.oldWeapon then
        self.oldWeapon = ply:GetActiveWeapon()
        self:PlayerWeaponChanged(ply, self.oldWeapon)
    end

    if (ply.CheckModelParameters or 0) < CurTime() then
        ply.CheckModelParameters = CurTime() + 1
        if legEnt:GetModel() ~= ply:GetModel() then
            legEnt:SetModel(ply:GetModel())
            legEnt.ModelChanged = true
        end

        if legEnt:GetMaterial() ~= ply:GetMaterial() then legEnt:SetMaterial(ply:GetMaterial()) end
        if legEnt:GetSkin() ~= ply:GetSkin() then legEnt:SetSkin(ply:GetSkin()) end
    end

    if (ply.NextCheckBodygroups or 0) < CurTime() then
        ply.NextCheckBodygroups = CurTime() + 2
        for _, v in ipairs(ply:GetBodyGroups()) do
            legEnt:SetBodygroup(v.id, ply:GetBodygroup(v.id))
        end
    end

    if (self.BoneMergeCheck or 0) <= CurTime() then
        self.BoneMergeCheck = CurTime() + 10
        if ply.BoneMergedEnts then
            if self.OldBoneMergeTable ~= ply.BoneMergedEnts then
                for _, v in ipairs(ply.BoneMergedEnts) do
                    if not (v and v:IsValid()) then continue end
                    if v:GetModel():find("body") or v:GetModel():find("armor") then ClientBoneMerge(self.legEnt, v:GetModel()) end
                end
            end

            self.OldBoneMergeTable = ply.BoneMergedEnts
        end
    end

    self.velocity = ply:GetVelocity():Length2DSqr()     --[[if ( ( self.nextMatSet || 0 ) <= CurTime() ) then

    for k in pairs( ply:GetMaterials() ) do

      legEnt:SetSubMaterial( k - 1, ply:GetSubMaterial( k - 1 ) )

    end

    self.nextMatSet = CurTime() + 10

  end]]
    self.playBackRate = 1
    if self.velocity > .5 then self.playBackRate = math.min(math.sqrt(self.velocity) / speed, 2) end
    legEnt:SetPlaybackRate(self.playBackRate)
    self.sequence = ply:GetSequence()
    if legEnt.Anim ~= self.sequence or legEnt.ModelChanged then
        if legEnt.ModelChanged then legEnt.ModelChanged = nil end
        legEnt.Anim = self.sequence
        legEnt:ResetSequence(self.sequence)
    end

    legEnt:FrameAdvance(curTime - legEnt.LastTick)
    legEnt.LastTick = curTime
    self.breathScale = .5
    if self.nextBreath <= curTime then
        self.nextBreath = curTime + 1.95 / self.breathScale
        legEnt:SetPoseParameter("breathing", self.breathScale)
    end

    legEnt:SetPoseParameter("move_x", (ply:GetPoseParameter("move_x") * 2) - 1)
    legEnt:SetPoseParameter("move_y", (ply:GetPoseParameter("move_y") * 2) - 1)
    legEnt:SetPoseParameter("move_yaw", (ply:GetPoseParameter("move_yaw") * 360) - 180)
    legEnt:SetPoseParameter("body_yaw", (ply:GetPoseParameter("body_yaw") * 180) - 90)
    legEnt:SetPoseParameter("spine_yaw", (ply:GetPoseParameter("spine_yaw") * 180) - 90)
    legEnt:SetCycle(ply:GetCycle())
    if ply:InVehicle() then
        legEnt:SetColor(color_transparent)
        legEnt:SetPoseParameter("vehicle_steer", (ply:GetVehicle():GetPoseParameter("vehicle_steer") * 2) - 1)
    end
end

local team_index_scp = TEAM_SCP
local allowedscp = {
    ["SCP062DE"] = true,
    ["SCP2012"] = true,
    ["SCP076"] = true,
    ["SCP049"] = true,
    ["SCP542"] = true,
    ["SCP973"] = true,
}

local math = math
local cam = cam
local mathrad = math.rad
local mathcos = math.cos
local mathsin = math.sin
function BREACHLEGS:RenderScreenspaceEffects()
    local ply = LocalPlayer()
    local plytable = ply:GetTable()
    if not ply:IsSolid() or (ply:GTeam() == team_index_scp and not plytable.IsZombie and not allowedscp[ply:GetRoleName()]) then return end
    local self = BREACHLEGS
    cam.Start3D(EyePos(), EyeAngles())
    if ply:ShouldDrawLegs() then
        self.renderPos = ply:GetPos()
        if ply:InVehicle() then
            self.renderAngle = ply:GetVehicle():GetAngles()
            self.renderAngle:RotateAroundAxis(self.renderAngle:Up(), 90)
        else
            self.biaisAngles = ply:EyeAngles()
            self.renderAngle = Angle(0, self.biaisAngles.y, 0)
            self.radAngle = mathrad(self.biaisAngles.y)
            self.forwardOffset = -22
            self.renderPos.x = self.renderPos.x + mathcos(self.radAngle) * self.forwardOffset --print(  math.cos( self.radAngle ), math.sin( self.radAngle ) )
            self.renderPos.y = self.renderPos.y + mathsin(self.radAngle) * self.forwardOffset
            if ply:GetGroundEntity() == NULL then self.renderPos.z = self.renderPos.z + 8 end
        end

        local legEnt = self.legEnt --self.renderColor = ply:GetColor() --local enabled = render.EnableClipping( true )
        if legEnt:GetRenderOrigin() ~= self.renderPos then --render.PushCustomClipPlane( self.clipVector, self.clipVector:Dot( EyePos() ) ) --render.SetColorModulation( self.renderColor.r / 255, self.renderColor.g / 255, self.renderColor.b / 255 ) --render.SetBlend( self.renderColor.a / 255 )
            legEnt:SetRenderOrigin(self.renderPos)
        end

        if legEnt:GetRenderAngles() ~= self.renderAngle then legEnt:SetRenderAngles(self.renderAngle) end
        legEnt:DrawModel()
    end

    cam.End3D() --legEnt:SetRenderOrigin() --legEnt:SetRenderAngles()
    --[[if ( legEnt.BoneMergedEnts ) then

        for _, v in ipairs( legEnt.BoneMergedEnts ) do

          v:DrawModel()

        end

      end]] --render.SetBlend( 1 ) --render.SetColorModulation( 1, 1, 1 ) --render.PopCustomClipPlane() --render.EnableClipping( enabled )
end

hook.Add("PostDrawOpaqueRenderables", "Legs_ScreenSpaceEffects", BREACHLEGS.RenderScreenspaceEffects)