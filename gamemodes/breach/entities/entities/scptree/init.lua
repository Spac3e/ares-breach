AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.PrintName		= "Tree"
ENT.Author		    = ""
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Owner = nil
ENT.IsAttacking = false
ENT.CurrentTargets = {}
ENT.Attacks = 0
ENT.SnapSound = Sound( "snap.wav" )

function ENT:Initialize()
	self:SetModel("models/props_foliage/tree_deciduous_01a.mdl")
	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self.Copied = nil
	self.CopiedOut = nil
    self.Copied = {}
    self:SetPos(Vector(9085.486328, -1932.134644, 5.520229))
end

function LinearMotionModule(ent, endpos, speed)
    if !IsValid(ent) then return end
    local ratio = 0
    local time = 0
    local startpos = ent:GetPos()
    timer.Create(ent:GetClass().."_linear_motion", FrameTime(), 9999999999999, function()
        if !IsValid(ent) then return end
        ratio = speed + ratio
        time = time + FrameTime()
        ent:SetPos(LerpVector(ratio, startpos, endpos))
        if ent:GetPos():DistToSqr(endpos) < 1 then
            ent:SetPos(endpos)
        end
        if ent:GetPos() == endpos then
            timer.Remove(ent:GetClass().."_linear_motion")
        end
    end)

end


function ENT:Think()
    local nearbyEntities = ents.FindInBox(Vector(8873, -1791, -3),Vector(9296, -2052, 11), 150)

    if not IsValid(self) then
        return
    end

    for _, item in pairs(nearbyEntities) do
        if IsValid(item) and item:IsWeapon() and !IsValid(item:GetOwner()) and not item.Copied then
            local itemClass = item:GetClass()
            local itemPos = (item:GetPos())

            LinearMotionModule(item,item:GetPos() - Vector(0, 0, 10),0.005)

            if itemClass == "weapon_special_gaus" or item == self.Copied or item == self.CopiedOut then
                continue
            end

            item.Copied = true

            timer.Simple(3, function()
                if not (IsValid(self) or IsValid(item)) then
                    return
                end

                local copy = ents.Create(itemClass)
                copy:SetPos(itemPos)
                copy:Spawn()
                local copy2 = ents.Create(itemClass)
                copy2:SetPos(itemPos)
                copy2:Spawn()
                LinearMotionModule(copy,copy:GetPos() + Vector(0, 0, 0),0.05)
                LinearMotionModule(copy2,copy2:GetPos() + Vector(0, 0, 0),0.05)
                copy.Copied = true
                copy2.Copied = true
    
                item.Copied = true
    
                self.Copied = item
                self.CopiedOut = copy
                self.CopiedOut = copy2
                item:Remove()
            end)

            break
        end
    end

    self:NextThink(CurTime() + 1)
    return true
end