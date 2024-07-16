AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Fake Skybox"

local mats = {
	Material("skybox/bartuc_grey_sky_ft"),
	Material("skybox/bartuc_grey_sky_bk"),
	Material("skybox/bartuc_grey_sky_up"),
	Material("skybox/bartuc_grey_sky_dn"),
	Material("skybox/bartuc_grey_sky_lf"),
	Material("skybox/bartuc_grey_sky_rt")
}

function ENT:Initialize()

	self:SetModel("models/hunter/blocks/cube8x8x8.mdl")
	self:SetModelScale(6)

	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:PhysicsInit(SOLID_NONE)

	if CLIENT then
		hook.Add("PreDrawViewModels", "FAKE_SKYBOX", function()
			if !IsValid(self) or LocalPlayer():GTeam() == TEAM_SPEC then
				hook.Remove("PreDrawViewModels", "FAKE_SKYBOX")
				return
			end

			if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 2000000 then
				return
			end

			local mins, maxs = self:OBBMins(), self:OBBMaxs()

			local size = -mins.z + maxs.z

			local pos = EyePos() - Vector(0,0,size/2)
			local ang = self:GetAngles()

			cam.Start3D()
				render.SetMaterial(mats[3])
				render.DrawQuadEasy(pos+Vector(0,0,maxs.z), -ang:Up(), size, size, color_white, -90)
				render.SetMaterial(mats[4])
				render.DrawQuadEasy(pos+Vector(0,0,mins.z), ang:Up(), size, size, color_white, 90)
				render.SetMaterial(mats[6])
				render.DrawQuadEasy(pos+Vector(0,0,maxs.z)-Vector(0,0,size/2)+-ang:Right()*(size/2), ang:Right(), size, size, color_white, 180)
				render.SetMaterial(mats[5])
				render.DrawQuadEasy(pos+Vector(0,0,maxs.z)-Vector(0,size,size/2)+-ang:Right()*(size/2), -ang:Right(), size, size, color_white, 180)
				render.SetMaterial(mats[1])
				render.DrawQuadEasy(pos+Vector(0,0,maxs.z)-Vector(-size/2,size/2,size/2)+-ang:Right()*(size/2), -ang:Forward(), size, size, color_white, 180)
				render.SetMaterial(mats[2])
				render.DrawQuadEasy(pos+Vector(0,0,maxs.z)-Vector(size/2,size/2,size/2)+-ang:Right()*(size/2), ang:Forward(), size, size, color_white, 180)
				local entlist = ents.GetAll()
				for i = 1, #entlist do
					local item = entlist[i]
					if !item:GetNoDraw() and LocalPlayer():IsLineOfSightClear(item) and ( item:IsPlayer() or item:GetClass() == "breach_bonemerge" or item:GetClass() == "prop_dynamic" or item:GetClass() == "prop_physics" ) then
						item:DrawModel()
					end
				end
			cam.End3D()
		end)
	end

end

function ENT:Draw()

end