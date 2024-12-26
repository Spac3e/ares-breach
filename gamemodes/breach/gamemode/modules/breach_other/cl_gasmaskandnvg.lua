local meta = FindMetaTable("Player")
function meta:GASMASK_PlayAnim(anim)
  local mask = self.GASMASK_HudModel
  if mask and IsValid(mask) then
    mask:ResetSequence(anim)
    mask:SetCycle(0)
    mask:SetPlaybackRate(1)
  end
end

function meta:GASMASK_DelayedFunc(time, func)
  timer.Simple(time, function() if !IsValid(self) or !self:Alive() then return end func(self) end)
end

net.Receive("GASMASK_RequestToggle", function()
  local ply = LocalPlayer()
  local state = net.ReadBool()
  
  if state then
    ply:GASMASK_PlayAnim("draw")
    ply:EmitSound("GASMASK_DrawHolster")
    ply:GASMASK_DelayedFunc(0.3, function() ply:GASMASK_PlayAnim("put_on") ply:EmitSound("GASMASK_Foley") end)
    ply:GASMASK_DelayedFunc(0.6, function() ply:EmitSound("GASMASK_Inhale") end)
    ply:GASMASK_DelayedFunc(1.2, function() ply:EmitSound("GASMASK_OnOff") end)
    ply:GASMASK_DelayedFunc(1.79, function() ply:GASMASK_PlayAnim("idle_on") end)
  else
    ply:GASMASK_PlayAnim("take_off")
    ply:EmitSound("GASMASK_OnOff")
    ply:GASMASK_DelayedFunc(0.3, function() ply:EmitSound("GASMASK_Foley") end)
    ply:GASMASK_DelayedFunc(0.45, function() ply:EmitSound("GASMASK_Exhale") end)
    ply:GASMASK_DelayedFunc(1.2, function() ply:EmitSound("GASMASK_DrawHolster") end)
    ply:GASMASK_DelayedFunc(1.25, function() ply:GASMASK_PlayAnim("holster") end)
  end
end)

net.Receive("GASMASK_SendEquippedStatus", function()
  LocalPlayer().GASMASK_Equiped = net.ReadBool()
end)

local function GASMASK_CalcHorizontalFromVerticalFOV( num ) // calculates the camera FOV depending on viewmodel FOV
  local r = ScrW() / ScrH() // our resolution
  r =  r / (4/3) // 4/3 is base Source resolution, so we have do divide our resolution by that
  local tan, atan, deg, rad = math.tan, math.atan, math.deg, math.rad
  
  local vFoV = rad(num)
  local hFoV = deg( 2 * atan(tan(vFoV/2)*r) ) // this was a bitch
  
  return hFoV
end

local function GASMASK_GetPlayerColor()
  local owner = LocalPlayer()
  if owner:IsValid() and owner:IsPlayer() and owner.GetPlayerColor then
    return owner:GetPlayerColor()
  end

  return Vector(1, 1, 1)
end

local function GASMASK_CopyBodyGroups(source, target)
  for num, _ in pairs(source:GetBodyGroups()) do
    target:SetBodygroup(num-1, source:GetBodygroup(num-1))
    target:SetSkin(source:GetSkin())
  end
end

local function GASMASK_DrawInHud()
  local ply = LocalPlayer()
  if !IsValid(ply) then return end
  
  if !ply.GASMASK_HudModel or !IsValid(ply.GASMASK_HudModel) then
    ply.GASMASK_HudModel = ClientsideModel("models/gmod4phun/c_contagion_gasmask.mdl", RENDERGROUP_BOTH)
    ply.GASMASK_HudModel:SetNoDraw(true)
    ply:GASMASK_PlayAnim("idle_holstered")
  end
  
  local mask = ply.GASMASK_HudModel
  if !IsValid(mask) then return end
  
  if !ply.GASMASK_HandsModel or !IsValid(ply.GASMASK_HandsModel) then
    local gmhands = ply:GetHands()
    if IsValid(gmhands) then
      ply.GASMASK_HandsModel = ClientsideModel(gmhands:GetModel(), RENDERGROUP_BOTH)
      ply.GASMASK_HandsModel:SetNoDraw(true)
      ply.GASMASK_HandsModel:SetParent(mask)
      ply.GASMASK_HandsModel:AddEffects(EF_BONEMERGE)
      GASMASK_CopyBodyGroups(gmhands, ply.GASMASK_HandsModel)
      ply.GASMASK_HandsModel.GetPlayerColor = GASMASK_GetPlayerColor
    end
  end
  
  local hands = ply.GASMASK_HandsModel
  
  if !ply:Alive() then
    ply:GASMASK_PlayAnim("idle_holstered")
  end
  
  local pos, ang = EyePos(), EyeAngles()
  local maskwep = weapons.GetStored("gasmask")
  local camFOV = GASMASK_CalcHorizontalFromVerticalFOV(maskwep.ViewModelFOV)
  local scrw, scrh = ScrW(), ScrH() 
  local FT = FrameTime()
  local wep = ply:GetActiveWeapon()
  
  cam.Start3D( pos, ang, camFOV, 0, 0, scrw, scrh, 1, 100)
    cam.IgnoreZ(false)
      render.SuppressEngineLighting( false )
        mask:SetPos(pos)
        mask:SetAngles(ang)
        mask:FrameAdvance(FT)
        mask:SetupBones()
        if ply.GASMASK_Equiped or (IsValid(wep) and wep:GetClass() == "g4p_gasmask") then
          if ply:GetViewEntity() == ply then
            // first draw hands, then mask
            if IsValid(hands) then
              hands:DrawModel()
            end
            mask:DrawModel()
          end
        end
      render.SuppressEngineLighting( false )
    cam.IgnoreZ(false)
  cam.End3D()
end

hook.Add("HUDPaintBackground", "GASMASK_HUDPaintDrawing", function()
  GASMASK_DrawInHud()
end)

local maskbreathsounds = {
  [1] = "GASMASK_BreathingLoop",
  [2] = "GASMASK_BreathingLoop2",
  [3] = "GASMASK_BreathingMetroLight",
  [4] = "GASMASK_BreathingMetroMiddle",
  [5] = "GASMASK_BreathingMetroHard",
}

local function GASMASK_BreathThink()
  local ply = LocalPlayer()
  if !IsValid(ply) then return end
  
  local sndtype = 2
  
  local mask = ply.GASMASK_HudModel
  if !IsValid(mask) then return end
  
  if !ply.GASMASK_BreathSound and sndtype > 0 then
    ply.GASMASK_BreathSound = CreateSound(ply, maskbreathsounds[sndtype])
  end
  
  local shouldplay = mask:GetSequenceName(mask:GetSequence()) == "idle_on" and sndtype > 0
  
  --[[
  local snd = ply.GASMASK_BreathSound
  if snd then
    snd:ChangePitch(snd:GetPitch() + 0.01) // fix for stopsound
    snd:ChangePitch(math.Clamp(game.GetTimeScale() * 100, 75, 120))
    snd:ChangeVolume(shouldplay and 1 or 0, 0.5)
  
    if !snd:IsPlaying() and shouldplay then snd:Play() end
  end
  --]]
end

hook.Add("Think", "GASMASK_BreathSoundThink", function()
  GASMASK_BreathThink()
end)