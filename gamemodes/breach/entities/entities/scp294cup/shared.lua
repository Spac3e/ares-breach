--[[
addons/294/lua/entities/scp294cup/shared.lua
--]]
ENT.Type = "anim"

ENT.Base = "base_gmodentity"

ENT.PrintName = "SCP-294 Cup"

ENT.Category = "SCP Pack"

ENT.Spawnable = false

 

function ENT:Initialize()

	self.FluidColor = Color(0,0,0,0)

	timer.Simple(0.25, function()

		local Drink = SCP294.Drinks[self:GetNWString("Drink")];

		if Drink then

			self.FluidColor = SCP294.Drinks[self:GetNWString("Drink")].color

		else

			self.FluidColor = Color(40,30,20)

		end

	end)

end