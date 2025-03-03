AddCSLuaFile()
ENT.Base = "base_gmodentity"
ENT.Category = "Breach"
--ENT.Type        = "anim"
ENT.Model = Model("models/cult_props/tesla_new.mdl")
ENT.Shock_ghostmodel = Model("models/hunter/blocks/cube4x4x025.mdl")
ENT.Vector = nil
function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    if SERVER then
        local filter = RecipientFilter()
        filter:AddAllPlayers()
        self.ShockUp_snd = CreateSound(self, "nextoren/others/tesla/windup.ogg", filter)
    end

    self.Reloading = 0
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Active")
    self:SetActive(false)
end

function ENT:Think()
    self:NextThink(CurTime() + 1)
    if SERVER then
        local found_players = {}
        local scpfound = false

        for _, v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
            if v:IsPlayer() and v:Health() > 0 and v:IsSolid() and v:GetMoveType() != MOVETYPE_NOCLIP then
                local trace = util.TraceLine({
                    start = self:GetPos(),
                    endpos = v:EyePos(),
                    filter = self,
                    mask = MASK_SOLID
                })

                if trace.Hit and trace.Entity != v then
                    continue
                end

                if v:GTeam() == TEAM_SCP then
                    scpfound = true
                end

                if v:GTeam() == TEAM_NTF and not SUPPORTTABLE["ntf"] then
                    continue
                end

                found_players[#found_players + 1] = v
            end
        end

        if #found_players > 0 then
            if not self:GetActive() then
                self:SetActive(true)
                self.ShockUp_snd:Stop()
                self.Reloading = CurTime() + 0.5
            end
        else
            if self:GetActive() then
                self.ShockUp_snd:Stop()
                self:SetActive(false)
            end
        end

        if self:GetActive() and self.Reloading < CurTime() then
            self.ShockUp_snd:Stop()
            self:EmitSound( "nextoren/others/tesla/shock.ogg", 75, math.random( 80, 110 ), 1, CHAN_STATIC )

            if scpfound then
                self.Reloading = CurTime() + 3
            else
                self.Reloading = CurTime() + 2.1
            end

            local damage_entity = ents.Create("base_gmodentity")
            damage_entity:SetModel(self.Shock_ghostmodel)
            damage_entity:SetPos(self:GetPos() - Vector(0, 0, 25))
            damage_entity:SetAngles(self:GetAngles() + Angle(90, 0, 0))
            damage_entity:PhysicsInit(SOLID_VPHYSICS)
            damage_entity:SetParent(self)
            damage_entity:SetMoveType(MOVETYPE_VPHYSICS)
            damage_entity:SetSolid(SOLID_VPHYSICS)
            damage_entity:SetTrigger(true)
            damage_entity:Spawn()
            damage_entity:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
            local physobj = damage_entity:GetPhysicsObject()
            if physobj:IsValid() then
                physobj:Wake()
                physobj:EnableMotion(false)
            end

            damage_entity.Touch = function(ent, collider)
                if collider:IsPlayer() and not collider.GainDamage then
                    collider.GainDamage = true
                    local dmginfo = DamageInfo()
                    if collider:GTeam() != TEAM_SCP then
                        dmginfo:SetDamage(collider:GetMaxHealth() * 2)
                    else
                        dmginfo:SetDamage(collider:GetMaxHealth() * math.Rand(.3, 1))
                    end

                    dmginfo:SetDamageType(DMG_DISSOLVE)
                    dmginfo:SetDamageForce(collider:GetAimVector() * 80)
                    collider:TakeDamageInfo(dmginfo)
                    timer.Simple(.1, function() if collider and collider:IsValid() and collider.GainDamage then collider.GainDamage = nil end end)
                end
                return true
            end

            timer.Simple(1, function() if damage_entity and damage_entity:IsValid() then damage_entity:Remove() end end)
        end
    end

    if self:GetActive() and self.Reloading > CurTime() and self.Reloading < CurTime() + 1.1 then if not self.ShockUp_snd:IsPlaying() then self.ShockUp_snd:Play() end end
end

function ENT:OnRemove()
end

if CLIENT then
  local SHIELD_MATERIAL = Material("nextoren/objects/tesla/tesla_gate")

  function ENT:Draw()
      if self:GetActive() then
          local childrens = self:GetChildren()
          for i = 1, #childrens do
              local children = childrens[i]
              if children and children:IsValid() and children:GetModel() == self.Shock_ghostmodel and not children.AlreadyHaveFunc then
                  children.AlreadyHaveFunc = true
                  children.Draw = function(self)
                      local pos = self:GetPos()

                      render.SetMaterial(SHIELD_MATERIAL)
                      render.DrawQuadEasy(pos, self:GetUp(), 190, 190, Color(50, 100, 255, 200))

                      local dynamic_light = DynamicLight(self:EntIndex())
                      if not self.SmoothSize then self.SmoothSize = math.random(400, 512) end
                      self.SmoothSize = math.Approach(self.SmoothSize, math.random(480, 564), 2.5)
                      if dynamic_light then
                          dynamic_light.Pos = pos
                          dynamic_light.r = 50
                          dynamic_light.g = 150
                          dynamic_light.b = 255
                          dynamic_light.Brightness = 3
                          dynamic_light.Size = self.SmoothSize
                          dynamic_light.Decay = 3000
                          dynamic_light.DieTime = CurTime() + FrameTime() * 3
                      end
                  end

                  break
              end
          end
      end

      self:DrawModel()
  end
end
