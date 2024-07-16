AddCSLuaFile()

SWEP.AbilityIcons = {

	{

		["Name"] = "Directed Psy-Attack",
		["Description"] = "",
		["Cooldown"] = 24,
		["CooldownTime"] = 0,
		["KEY"] = "LMB",
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/scp_106_dimensionteleport.png"

	},

	{

		["Name"] = "Mass Psy-Attack",
		["Description"] = "",
		["Cooldown"] = 120,
		["CooldownTime"] = 0,
		["KEY"] = "RMB",
		["Using"] = false,
		["Icon"] = "nextoren/gui/special_abilities/special_scarlet_enemy_scan.png"

	},

}

SWEP.PrintName				= "SCP-1903"

SWEP.ViewModelFOV 			= 56
SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false
SWEP.Author             	= "RXSEND"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay          = 2
SWEP.Primary.Automatic	    = true
SWEP.Primary.Ammo	     	= "None"
SWEP.Sound					= "nice_sound.ogg"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay		= 3
SWEP.Secondary.Ammo		    = "None"

SWEP.Delay 					= "2, 7"

SWEP.Base 					= "breach_scp_base"

SWEP.droppable				= false
SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.ViewModel				= ""
SWEP.WorldModel				= ""
SWEP.HoldType 				= "normal"



function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
end

local prim_maxs = Vector( 12, 2, 32 )

function SWEP:PrimaryAttack()

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 550
	trace.filter = self.Owner
	trace.mins = -prim_maxs
	trace.maxs = prim_maxs

	trace = util.TraceHull( trace )

	local tar = trace.Entity

	if IsValid(tar) and tar:IsPlayer() and tar:GTeam() != TEAM_SCP then

		self:SetNextPrimaryFire(CurTime() + self.AbilityIcons[1].Cooldown)
		self.AbilityIcons[1].CooldownTime = CurTime() + self.AbilityIcons[1].Cooldown

		if SERVER then

			self.Owner:ScreenFade(SCREENFADE.IN, Color(255,0,0, 100), 1, 0)
			self:Cooldown(1, self.AbilityIcons[1].Cooldown)

			net.Start("ForcePlaySound")
			net.WriteString("nextoren/scp/scp_1903/ability_"..math.random(1,7)..".mp3")
			net.Send({tar, self.Owner})

			local uniquename = "PSYCHO_DAMAGE"..tar:SteamID64()

			if SERVER then
				tar:ScreenFade(SCREENFADE.IN, Color(0,0,0, 255), 1, 5)
				timer.Create(uniquename, FrameTime(), math.floor(tar:GetMaxHealth() * .9), function()

					if !IsValid(self.Owner) or self.Owner:Health() <= 0 or !IsValid(tar) or tar:Health() <= 0 then
						timer.Remove(uniquename)
						return
					end
					local DMGINFO = DamageInfo()
					DMGINFO:SetDamage(1)
					DMGINFO:SetDamageType(DMG_DIRECT)
					DMGINFO:SetDamageForce(Vector(0,0,0))
					DMGINFO:SetAttacker(self.Owner)
					DMGINFO:SetInflictor(self)

					tar:TakeDamageInfo(DMGINFO)

				end)
			end

		end

	end

end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + self.AbilityIcons[2].Cooldown)

	self.AbilityIcons[2].CooldownTime = CurTime() + self.AbilityIcons[2].Cooldown

	local Ents = ents.FindInSphere(self.Owner:GetPos(), 460)

	local affected = {}

	for i = 1, #Ents do

		local ply = Ents[i]

		if IsValid(ply) and ply:IsPlayer() and ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP then

			affected[#affected + 1] = ply

			if SERVER then
				ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 10)
				local uniquename = "PSYCHO_DAMAGE"..ply:SteamID64()

				timer.Create(uniquename, FrameTime(), math.floor(ply:GetMaxHealth() * .9), function()

					if !IsValid(self.Owner) or self.Owner:Health() <= 0 or !IsValid(ply) or ply:Health() <= 0 then
						timer.Remove(uniquename)
						return
					end
					local DMGINFO = DamageInfo()
					DMGINFO:SetDamage(1)
					DMGINFO:SetDamageType(DMG_DIRECT)
					DMGINFO:SetDamageForce(Vector(0,0,0))
					DMGINFO:SetAttacker(self.Owner)
					DMGINFO:SetInflictor(self)

					ply:TakeDamageInfo(DMGINFO)

				end)
			end

		end

	end

	if SERVER then

		affected[#affected + 1] = self.Owner

		net.Start("ForcePlaySound")
		net.WriteString("nextoren/scp/scp_1903/ability_"..math.random(1,7)..".mp3")
		net.Send(affected)

	end

	if CLIENT then

		hook.Add("HUDPaint", "SCP_1903_VISION", function()

			local cl = LocalPlayer()

			if cl:GetRoleName() != "SCP1903" or cl:Health() <= 0 then
				hook.Remove("HUDPaint", "SCP_1903_VISION")
				return
			end

			local todraw_tab = {}

			for i = 1, #affected do
				local tar = affected[i]
				if !IsValid(tar) then continue end
				if tar:Health() <= 0 then continue end
				if tar:GTeam() == TEAM_SPEC then continue end
				todraw_tab[#todraw_tab + 1] = tar
			end

			outline.Add( todraw_tab, Color(255,255,0), OUTLINE_MODE_BOTH )

		end)
		timer.Create("Jackie_Halo", 6, 1, function()
			hook.Remove("HUDPaint", "SCP_1903_VISION")
		end)

	end

end
