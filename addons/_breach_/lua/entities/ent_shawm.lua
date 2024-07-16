AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Shawm"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Mordhau"
ENT.Editable = true

function ENT:Initialize()

	self:SetModel( "models/uracos/shawm.mdl" )
    self:SetShouldPlayPickupSound(false)
    self:SetColor(Color(121, 100, 88))
    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
        phys:SetMass(10)
	    phys:Wake()
	end

end

function ENT:OnMassChanged(name, old, new)
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
        phys:SetMass(new)
	end
end

function ENT:OnColorChanged(name, old, new)
    self:SetColor(new)
end

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ShawmMass", {
        KeyName = "mass",
        Edit = {
            type = "Float",
            order = 1,
            min = 0,
            max = 50000
        }
    })
	self:NetworkVar("Vector", 0, "ShawmColor", {
        KeyName = "color",
        Edit = {
            type = "VectorColor",
            order = 2
        }
    })
    self:NetworkVarNotify("ShawmMass", self.OnMassChanged)
    self:NetworkVarNotify("ShawmColor", self.OnColorChanged)
end

local suppress_sounds = false
function ENT:Use(activator)
    suppress_sounds = true
    if activator:IsPlayer() and IsFirstTimePredicted() and !self:IsPlayerHolding() then

        activator:PickupObject(self)

        local chance = math.random(1, 2)
        if chance == 1 then
            self:EmitSound("^oldshawm/sw_shawm_c"..math.random(2, 5)..".ogg", 75, math.random(100, 104), 1, CHAN_WEAPON)
        else
            local snd = math.random(1, 10)
            if snd == 10 then
                snd = "10"
            else
                snd = "0"..snd
            end
            self:EmitSound("^oldshawm/sw_shawmphrase"..snd..".ogg", 75, 100, 1, CHAN_WEAPON)
        end
    end
end

hook.Add("EntityEmitSound", "ShawmSound", function(data)
    if data.SoundName:find("physics/metal/metal_solid_impact_soft") and data.Entity:IsWorld() and suppress_sounds then
        suppress_sounds = false
        return false
    end
end)