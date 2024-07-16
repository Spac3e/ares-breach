--[[


addons/[begotten]_advmelee/lua/weapons/adv_melee_base/shared.lua

--]]

/********************************
MELEE CONFIG
********************************/
SWEP.PrintName		= "advanced melee base"
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.Base = "weapon_base"

SWEP.ViewModelFOV	= 90
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= Model("models/aoc_weapon/v_mace2.mdl")
SWEP.WorldModel		= Model("models/aoc_weapon/w_mace2.mdl")

SWEP.Spawnable		= true
SWEP.AdminOnly		= false

SWEP.UseHands = false

SWEP.SwingWindUp = 600 --ms
SWEP.SwingRelease = 475 --ms
SWEP.SwingRecovery = 600 --ms

SWEP.StabWindUp = 550 --ms
SWEP.StabRelease = 350 --ms
SWEP.StabRecovery = 600 --ms

SWEP.ParryCooldown = 700 --ms
SWEP.ParryWindow = 325 --ms

SWEP.Length = 60 --cm

SWEP.MissCost = 10
SWEP.FeintCost = 10
SWEP.MorphCost = 7
SWEP.StaminaDrain = 19
SWEP.ParryDrainNegation = 13

SWEP.SwingDamage = 40
SWEP.SwingDamageType = DMG_CLUB
SWEP.StabDamage = 20
SWEP.StabDamageType = DMG_CLUB

SWEP.HoldType = "melee2" --just for anim base, should be the same as SWEP.MainHoldType
SWEP.MainHoldType = "melee2" --we will fall back on this
SWEP.SwingHoldType = "melee2"
SWEP.StabHoldType = "knife"

SWEP.IdleAnimVM = "deflect" --for feint or flinch

SWEP.ParryAnim = "range_melee_shove_2hand"
SWEP.ParryAnimWeight = 0.9
SWEP.ParryAnimSpeed = 0.7
SWEP.ParryAnimVM = {"block"}

SWEP.SwingAnim = "range_melee2_b"
SWEP.SwingAnimWeight = 1
SWEP.SwingAnimWindUpMultiplier = 2.5
SWEP.SwingAnimVM = {"swing1", "swing2"}

SWEP.AttackSounds = {
	"mordhau/weapons/wooshes/bluntmedium/woosh_bluntmedium-01.wav",
	"mordhau/weapons/wooshes/bluntmedium/woosh_bluntmedium-02.wav",
	"mordhau/weapons/wooshes/bluntmedium/woosh_bluntmedium-03.wav",
	"mordhau/weapons/wooshes/bluntmedium/woosh_bluntmedium-04.wav",
}

--we hit world
SWEP.HitSolidSounds = {
	"mordhau/weapons/impacts/quarterstaff_metal_hit_01.wav",
	"mordhau/weapons/impacts/quarterstaff_metal_hit_02.wav",
}

SWEP.HitParry = {
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_01.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_02.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_03.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_04.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_05.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_06.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_07.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_08.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_09.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_10.wav",
	"mordhau/weapons/block/combined/bladedmedium/sw_blademedium_block_11.wav",
}

--sounds from our weapon when we parry
SWEP.ParrySounds = {
	"mordhau/weapons/block/combined/sw_bladedmedium_wasblocked_01.wav",
	"mordhau/weapons/block/combined/sw_bladedmedium_wasblocked_02.wav",
	"mordhau/weapons/block/combined/sw_bladedmedium_wasblocked_03.wav",
}

SWEP.StabWindUpAnim = "aoc_flamberge_stab.smd"
SWEP.StabAnim = "aoc_flamberge_stab.smd"
SWEP.StabAnimWeight = 1
SWEP.StabAnimWindUpMultiplier = 3
SWEP.StabAnimVM = {"stab"}

--sounds when we hit someone with swing
SWEP.GoreSwingSounds = {
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_1.wav",
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_2.wav",
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_3.wav",
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_4.wav",
}

--sounds when we hit someone with stab
SWEP.GoreStabSounds = {
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_1.wav",
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_2.wav",
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_3.wav",
	"mordhau/weapons/hits/bluntmedium/hit_bluntmedium_4.wav",
}
/********************************
CONFIG END
********************************/

/********************************
MELEE MAIN FUNCTIONS
********************************/

if CLIENT then
gameevent.Listen("player_hurt")
hook.Add("player_hurt", "advmelee:RedParry", function(data) 
	local health = data.health				// Remaining health after injury
	local priority = SERVER and data.Priority or 5 		// Priority ??
	local id = data.userid					// Same as Player:UserID()
	local attackerid = data.attacker			// Same as Player:UserID() but it's the attacker id.

	local attacker = Player(attackerid)
	local victim = Player(id)

	local client = LocalPlayer()

	if victim != client then
		return
	end

	if !client.GetActiveWeapon then
		return
	end

	local actwep = client:GetActiveWeapon()

	if !IsValid(actwep) then
		return
	end

	if actwep:GetClass() != "adv_melee_base" then
		if !weapons.IsBasedOn(actwep:GetClass(), "adv_melee_base") then
			return
		end
	end

	if actwep.WeArePARRYING and !actwep:IsBackstab(attacker) then
		local ping = CurTime() - actwep.LastParryTime
		if ping < 0 then
			ping = ping * -1
		end
		print("Parry("..math.Round(ping * 1000).." ms ago) did not reach server in time!")
		actwep:AddRedParry(math.Round(ping * 1000))
	end
end)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Parrying")
	self:NetworkVar("Bool", 1, "ParryCooldown")
	self:NetworkVar("Bool", 2, "WindUp")
	self:NetworkVar("Bool", 3, "AttackRecovery")
	self:NetworkVar("Bool", 4, "Swinging")
	self:NetworkVar("Bool", 5, "Stabbing")
	self:NetworkVar("Bool", 6, "FullRelease")
	self:NetworkVar("Bool", 7, "Feint")
	self:NetworkVar("Bool", 8, "SwingQueued")
	self:NetworkVar("Bool", 9, "StabQueued")
	self:NetworkVar("Bool", 10, "Riposte")
	self:NetworkVar("Bool", 11, "CanRiposte")
	self:NetworkVar("Bool", 12, "Flinched")
	self:NetworkVar("Float", 0, "FlinchWeight")
	self:NetworkVar("Float", 1, "FeintWeight")
end

function SWEP:PlayFlinchOnPlayer(ply, gesture, weight, speed)
	if SERVER then
		self:BroadcastAndPlayFlinch(ply, gesture, weight, speed)
	end

	if CLIENT then
		ply:AnimResetGestureSlot(GESTURE_SLOT_FLINCH)
		ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, ply:LookupSequence(gesture), 0, true)
		ply:AnimSetGestureWeight(GESTURE_SLOT_FLINCH, weight)
		ply:SetLayerDuration(GESTURE_SLOT_FLINCH, speed)
	end
end

if CLIENT then
	net.Receive("advmelee:PlayFlinchOnPlayer", function()
		local ply = net.ReadEntity()
		if !IsValid(ply) then
			return
		end
	
		local gesture = net.ReadString()
		local weight = net.ReadFloat()
		local speed = net.ReadFloat()
	
		ply:AnimResetGestureSlot(GESTURE_SLOT_FLINCH)
		ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, ply:LookupSequence(gesture), 0, true)
		ply:AnimSetGestureWeight(GESTURE_SLOT_FLINCH, weight)
		ply:SetLayerDuration(GESTURE_SLOT_FLINCH, speed)
	end)
end

function SWEP:Flinch()
	if self:GetRiposte() then
		return
	end

	local owner = self:GetOwner()

	if self:GetSwinging() then
		self:SetFlinchWeight(self.SwingAnimWeight)
	end

	if self:GetStabbing() then
		self:SetFlinchWeight(self.StabAnimWeight)
	end

	local vm = owner:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(vm:LookupSequence(self.IdleAnimVM))
	end

	timer.Remove("advmelee:Swing_"..self:EntIndex())
	timer.Remove("advmelee:Stab_"..self:EntIndex())

	self:SetSwinging(false)
	self:SetStabbing(false)
	self:SetWindUp(false)
	self:SetFlinched(true)

	self:PlayFlinchOnPlayer(owner, "flinch_0"..math.random(1, 2), 1, 1)

	timer.Simple(325 / 1000, function()
		if !(IsValid(self) and IsValid(self:GetOwner())) then
			return
		end

		self:SetFlinched(false)
	end)
end

hook.Add("SetupMove", "advmelee:LimitMovement", function(ply, mv, cmd)
	local client = ply
	if !client.GetActiveWeapon then
		return
	end

	local wep = client:GetActiveWeapon()

	if !IsValid(wep) then
		return
	end

	if wep:GetClass() != "adv_melee_base" then
		if !weapons.IsBasedOn(wep:GetClass(), "adv_melee_base") then
			return
		end
	end

	if mv:KeyDown(IN_BACK) then
		mv:SetButtons(mv:GetButtons() - IN_RUN)
		mv:SetButtons(mv:GetButtons() - IN_SPEED)
		cmd:RemoveKey(IN_RUN)
		mv:SetMaxClientSpeed(100)
		mv:SetMaxSpeed(100)
	end

	if mv:KeyDown(IN_MOVELEFT) then
		mv:SetButtons(mv:GetButtons() - IN_RUN)
		mv:SetButtons(mv:GetButtons() - IN_SPEED)
		cmd:RemoveKey(IN_RUN)
		mv:SetMaxClientSpeed(100)
		mv:SetMaxSpeed(100)
	end

	if mv:KeyDown(IN_MOVERIGHT) then
		mv:SetButtons(mv:GetButtons() - IN_RUN)
		mv:SetButtons(mv:GetButtons() - IN_SPEED)
		cmd:RemoveKey(IN_RUN)
		mv:SetMaxClientSpeed(100)
		mv:SetMaxSpeed(100)
	end
end)

if CLIENT then
function SWEP:AddRedParry(time)
	if !self.RedParryTable then
		self.RedParryTable = {}
	end

	table.insert(self.RedParryTable, {tostring(time), LocalPlayer():Ping()})

	timer.Simple(5, function()
		if !(IsValid(self) and IsValid(self:GetOwner())) then
			return
		end

		for k, v in ipairs(self.RedParryTable) do
			if tostring(time) == v[1] then
				table.remove(self.RedParryTable, k)
			end
		end
	end)
end
end

local yellow = Color(255, 255, 0)
local black = Color(0, 0, 0)
local red = Color(255, 0, 0)
hook.Add("HUDPaint", "advmelee:DrawHUD", function()
	local client = LocalPlayer()
	if !client.GetActiveWeapon then
		return
	end

	local wep = client:GetActiveWeapon()

	if !IsValid(wep) then
		return
	end

	if wep:GetClass() != "adv_melee_base" then
		if !weapons.IsBasedOn(wep:GetClass(), "adv_melee_base") then
			return
		end
	end

	local scrw = ScrW()
	local scrh = ScrH()
	draw.SimpleTextOutlined("Alpha version", "BudgetLabel", scrw * 0.4, scrh/1.01, yellow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.4, black)

	if wep.RedParryTable then
		for k, v in ipairs(wep.RedParryTable) do
			local time = v[1]
			local ping = v[2]
			draw.SimpleTextOutlined("Parry("..time.." ms ago) did not reach server in time! Ping: "..ping.." ms", "BudgetLabel", scrw * 0.12, scrh * 0.1 - k*15, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.4, black)
		end
	end
end)

function SWEP:HitSolidDLight(ent, pos)
	if CLIENT then
		local dlight = DynamicLight(ent:EntIndex())
		if dlight then
			dlight.pos = pos
			dlight.r = 255
			dlight.g = 240
			dlight.b = 70
			dlight.brightness = 1
			dlight.Decay = 4000
			dlight.Size = 128
			dlight.DieTime = CurTime() + 1
		end
	end
end

function SWEP:IsBackstab(ent)
	local angles = self:GetOwner():EyeAngles()
	angles.p = 0
	angles = angles:Forward()

	local ang = ent:EyeAngles()
	ang.p = 0
	ang = ang:Forward()

	local back = ang:DotProduct(angles) >= 0.7

	return back
end

function SWEP:GetHitBone(ply, radius)
	local weapon = self
	local startpos = ply:GetShootPos()
	local dir = ply:GetAimVector()
	local len = advmelee.CMtoHU(weapon.Length)
	local sphere_pos_trace = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = ply,
		mask = MASK_SHOT_HULL
	} )
	local sphere_ents = ents.FindInSphere(sphere_pos_trace.HitPos, radius)
	local closest_ent
	for k, v in ipairs(sphere_ents) do
		--we don't want to hit ourselves
		if ply == v then
			continue
		end

		--we don't want to hit spectators
		if v.GetObserverMode then
			if v:GetObserverMode() != OBS_MODE_NONE then
				continue
			end
		end

		--we want to hit something alive
		if !(v:IsNPC() or v:IsPlayer()) then
			continue
		end

		--our closest entity is not set yet
		if !IsValid(closest_ent) then
			closest_ent = v
		end

		--replace closest ent if we found even closest one
		if v:GetPos():DistToSqr(sphere_pos_trace.HitPos) < closest_ent:GetPos():DistToSqr(sphere_pos_trace.HitPos) then
			closest_ent = v
		end

	end

	--we hit nobody
	if !closest_ent then
		return
	end

	--check if entity can have bones
	local closest_bone
	local closest_bone_pos
	if closest_ent.GetBoneCount then
		for i = 0, closest_ent:GetBoneCount() - 1 do
			--our closest entity is not set yet
			if closest_bone == nil then
				closest_bone = i
			end

			--these bones are always being returned, our calculation will only be better without them
			local bonename = closest_ent:GetBoneName(i)
			if bonename:find("_Hand") or bonename:find("_Shoulder") or bonename:find("_UpperArm") then
				continue
			end

			--get bone position
			local pos = closest_ent:GetBonePosition(i)

			--our closest bone position is not set yet
			if closest_bone_pos == nil then
				closest_bone_pos = pos
			end

        	if pos:DistToSqr(sphere_pos_trace.HitPos) < closest_bone_pos:DistToSqr(sphere_pos_trace.HitPos) then
				closest_bone = i
				closest_bone_pos = pos
			end
    	end
    end

    return closest_ent, closest_bone, closest_bone_pos
end

function SWEP:Feint()
	if !self:GetWindUp() then
		return
	end

	local owner = self:GetOwner()

	if self:GetSwinging() then
		self:SetFeintWeight(self.SwingAnimWeight)
	end

	if self:GetStabbing() then
		self:SetFeintWeight(self.StabAnimWeight)
	end

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.IdleAnimVM))

	timer.Remove("advmelee:Swing_"..self:EntIndex())
	timer.Remove("advmelee:Stab_"..self:EntIndex())

	self:SetSwinging(false)
	self:SetStabbing(false)
	self:SetWindUp(false)
	self:SetFeint(true)
end

function SWEP:Morph()

end

function SWEP:PlayGestureOnPlayer(ply, gesture, weight, speed)
	if SERVER then
		self:BroadcastAndPlayGesture(ply, gesture, weight, speed)
	end

	if CLIENT then
		ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(gesture), 0, true)
		ply:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, weight)
		ply:SetLayerDuration(GESTURE_SLOT_ATTACK_AND_RELOAD, speed)
	end
end

if CLIENT then
net.Receive("advmelee:PlayWeightedGestureOnPlayer", function()
	local ply = net.ReadEntity()
	if !IsValid(ply) then
		return
	end

	local gesture = net.ReadString()
	local weight = net.ReadFloat()
	local speed = net.ReadFloat()

	ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
	ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(gesture), 0, true)
	ply:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, weight)
	ply:SetLayerDuration(GESTURE_SLOT_ATTACK_AND_RELOAD, speed)
end)
end

function SWEP:ConfigureGestures(ply, weight, speed)
	if SERVER then
		self:BroadcastAndConfigureGestures(ply, weight, speed)
	end

	if CLIENT then
		ply:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, weight)
		ply:SetLayerDuration(GESTURE_SLOT_ATTACK_AND_RELOAD, speed)
	end
end

if CLIENT then
net.Receive("advmelee:ConfigureGestures", function()
	local ply = net.ReadEntity()
	if !IsValid(ply) then
		return
	end

	local weight = net.ReadFloat()
	local speed = net.ReadFloat()

	ply:AnimSetGestureWeight(GESTURE_SLOT_ATTACK_AND_RELOAD, weight)
	ply:SetLayerDuration(GESTURE_SLOT_ATTACK_AND_RELOAD, speed)
end)
end

function SWEP:CanParry()
	local owner = self:GetOwner()

	if self:GetParrying() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't parry cus parrying")
		return false
	end

	if self:GetRiposte() then
		return true
	end

	if self:GetParryCooldown() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't parry cus cd")
		return false
	end

	if self:GetSwinging() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't parry cus swinging")
		return false
	end

	if self:GetStabbing() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't parry cus stabbing")
		return false
	end

	return true
end

function SWEP:Parry()
	if !self:CanParry() then
		return
	end

	self.LastParryTime = CurTime()
	self.WeArePARRYING = true

	local owner = self:GetOwner()

	self:SetParrying(true)
	self:SetParryCooldown(true)
	self:SetSwinging(false)
	self:SetStabbing(false)
	self:SetWindUp(false)
	self:PlayGestureOnPlayer(owner, self.ParryAnim, self.ParryAnimWeight, self.ParryAnimSpeed)
	self:EmitSound("mordhau/foley/drawequipment/sw_drawequipmentgeneric0"..math.random(1, 7)..".wav")

	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.ParryAnimVM[math.random(1, #self.ParryAnimVM)]))

	--owner:PrintMessage(HUD_PRINTTALK, "parry")

	timer.Simple(self.ParryWindow / 1000, function()
		if !(IsValid(self) and IsValid(self:GetOwner())) then
			return
		end
		self:SetParrying(false)
		self.WeArePARRYING = false
		timer.Simple(self.ParryCooldown / 1000, function()
			if !(IsValid(self) and IsValid(self:GetOwner())) then
				return
			end

			self:SetParryCooldown(false)
		end)
	end)
end

function SWEP:CanAttack()
	local owner = self:GetOwner()

	if self:GetFlinched() then
		return
	end

	if self:GetParryCooldown() then
		return false
	end

	if self:GetSwinging() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't attack cus swinging")
		return false
	end

	if self:GetStabbing() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't attack cus stabbing")
		return false
	end

	if self:GetWindUp() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't attack cus windup")
		return false
	end

	if self:GetAttackRecovery() then
		--owner:PrintMessage(HUD_PRINTTALK, "can't attack cus recovering from an attack")
		return false
	end

	return true
end

function SWEP:IsAliveEnt(ent)
	if IsValid(ent) then
		if ent:IsNPC() or ent:IsPlayer() then
			return true
		end
	end

	return false
end

hook.Add("StartCommand", "advmelee:PlayerScrollUp", function(ply, cmd)
	local plytable = ply:GetTable()
	plytable.advmelee_mouse_scroll_up = cmd:GetMouseWheel() == 1
end)

function SWEP:Attack()
	if !self:CanAttack() then
		return
	end

	local owner = self:GetOwner()

	self:Slash()
end

function SWEP:Slash()
	if self:GetFeint() then
		self:SetSwingQueued(true)
		return
	end

	local owner = self:GetOwner()
	local vm = owner:GetViewModel()

	--owner:PrintMessage(HUD_PRINTTALK, "performing slash attack")

	self:SetWindUp(true)
	self:SetFeintWeight(self.SwingAnimWeight)
	self:SetHoldType(self.SwingHoldType)
	self.HoldType = self.SwingHoldType

	vm:SendViewModelMatchingSequence(vm:LookupSequence(self.SwingAnimVM[math.random(1, #self.SwingAnimVM)]))
	self:PlayGestureOnPlayer(owner, self.SwingAnim, self.SwingAnimWeight, (self.SwingWindUp / 1000) * self.SwingAnimWindUpMultiplier + self.SwingRelease / 1000)

	if self:GetParrying() and !self:GetParryCooldown() then
		self:SetRiposte(true)
	end

	timer.Create("advmelee:Swing_"..self:EntIndex(), self.SwingWindUp / 1000, 1, function()
		if !(IsValid(self) and IsValid(self:GetOwner())) then
			return
		end

		if self:GetParrying() or self:GetParryCooldown() then
			return
		end
		self:EmitSound(self.AttackSounds[math.random(1, #self.AttackSounds)], 75, math.random(98, 102), 1, CHAN_WEAPON)
		self:SetSwinging(true)
		self:SetWindUp(false)

		--give players some time to react before getting damage
		timer.Simple((self.SwingRelease / 1000) / 2, function()
			if !(IsValid(self) and IsValid(self:GetOwner())) then
				return
			end

			self:SetFullRelease(true)
			if CLIENT then
				self.WaitForSwingCalculation = true
			end
		end)

		timer.Simple(self.SwingRelease / 1000, function()
			if !(IsValid(self) and IsValid(self:GetOwner())) then
				return
			end

			--owner:PrintMessage(HUD_PRINTTALK, "slash attack end")
			self:SetFullRelease(false)
			if CLIENT then
				self.WaitForSwingCalculation = false
			end
			self:SetSwinging(false)
		end)
	end)
end

function SWEP:Stab()
	if self:GetFeint() then
		self:SetStabQueued(true)
		return
	end

	if self:GetFlinched() then
		return
	end

	local owner = self:GetOwner()
	--we need to lag compensate the player because it's not primary attack
	owner:LagCompensation(true)
		local vm = owner:GetViewModel()

		self:SetWindUp(true)
		self:SetFeintWeight(self.StabAnimWeight)
		self:SetHoldType(self.StabHoldType)
		--self.HoldType = self.StabHoldType --Fuck this shit

		vm:SendViewModelMatchingSequence(vm:LookupSequence(self.StabAnimVM[math.random(1, #self.StabAnimVM)]))
		self:PlayGestureOnPlayer(owner, self.SwingAnim, self.SwingAnimWeight, 1)
		self:PlayGestureOnPlayer(owner, self.StabAnim, self.StabAnimWeight, (self.StabWindUp / 1000) * self.StabAnimWindUpMultiplier + self.StabRelease / 1000)

		if self:GetParrying() and !self:GetParryCooldown() then
			self:SetRiposte(true)
		end

		timer.Create("advmelee:Stab_"..self:EntIndex(), self.StabWindUp / 1000, 1, function()
			if !(IsValid(self) and IsValid(self:GetOwner())) then
				return
			end

			if self:GetParrying() or self:GetParryCooldown() then
				return
			end

			self:EmitSound(self.AttackSounds[math.random(1, #self.AttackSounds)], 75, math.random(98, 102), 1, CHAN_WEAPON)
			self:SetStabbing(true)
			self:SetWindUp(false)
			self:SetHoldType(self.StabHoldType)

			--self.HoldType = self.StabHoldType --Fuck this shit
			--give players some time to react before getting damage
			timer.Simple((self.SwingRelease / 1000) / 2, function()
				if !(IsValid(self) and IsValid(self:GetOwner())) then
					return
				end

				self:SetFullRelease(true)
				if CLIENT then
					self.WaitForStabCalculation = true
				end
			end)

			timer.Simple(self.StabRelease / 1000, function()
				if !(IsValid(self) and IsValid(self:GetOwner())) then
					return
				end

				--owner:PrintMessage(HUD_PRINTTALK, "slash attack end")
				self:SetStabbing(false)
				self:SetFullRelease(false)
				if CLIENT then
					self.WaitForStabCalculation = false
				end
				if self:GetStabbing() then
					return
				end
				self:SetHoldType(self.MainHoldType)
			end)
		end)
	owner:LagCompensation(false)
end

function SWEP:CreateHitEffect(ent, pos, hitnormal)
	local effect = EffectData()
	effect:SetEntity(ent)
	effect:SetOrigin(pos)

	if self:IsAliveEnt(ent) then
		--effects from server are being sent through reliable channel and it's slow
		if CLIENT then
			util.Effect("BloodImpact", effect, true, true)
		end

		if SERVER then
			self:DoHitEffect(true, ent, pos, self)
		end
	else
		self:EmitSound(self.HitSolidSounds[math.random(1, #self.HitSolidSounds)], 75, math.random(50, 100), 1, CHAN_WEAPON)

		--effects from server are being sent through reliable channel and it's slow
		if CLIENT then
			local spark = EffectData()
			spark:SetEntity(ent_weapon)
			spark:SetOrigin(pos)
			spark:SetNormal(hitnormal)
			spark:SetAngles(angle_zero)
			spark:SetMagnitude(1)
			spark:SetRadius(1)
			spark:SetScale(1)

			util.Effect("Sparks", spark, nil, true)
			util.Effect("Impact", effect, true, true)
		end

		if SERVER then
			self:DoHitEffect(false, ent, pos, self, hitnormal)
		end

		if CLIENT then
			self:HitSolidDLight(self:GetOwner(), pos)
		end
	end
end

if CLIENT then
net.Receive("advmelee:PlayerHitSomething", function()
	local hit_alive = net.ReadBool()
	local ply = net.ReadEntity()
	local pos = net.ReadVector()

	local effect = EffectData()
	effect:SetEntity(ply)
	effect:SetOrigin(pos)

	if hit_alive then
		util.Effect("BloodImpact", effect, true, true)
	else
		local wep = net.ReadEntity()
		local normal = net.ReadNormal()

		local spark = EffectData()
		spark:SetEntity(wep)
		spark:SetOrigin(pos)
		spark:SetNormal(normal)
		spark:SetAngles(angle_zero)
		spark:SetMagnitude(1)
		spark:SetRadius(1)
		spark:SetScale(1)

		util.Effect("Sparks", spark, true, true)
		util.Effect("Impact", effect, true, true)

		if IsValid(wep) then
			wep:HitSolidDLight(ply, pos)
		end
	end
end)
end

--if we hit someone and we got parried by his weapon
function SWEP:GotParried(ent, ent_weapon)
	ent_weapon:EmitSound(ent_weapon.ParrySounds[math.random(1, #ent_weapon.ParrySounds)])
	self:EmitSound(self.HitSolidSounds[math.random(1, #self.HitSolidSounds)], 75, math.random(98, 102), 1, CHAN_WEAPON)

	local effect = EffectData()
	effect:SetEntity(ent_weapon)
	effect:SetOrigin(ent:GetBonePosition(ent:LookupBone("ValveBiped.Anim_Attachment_RH")) + (ent:GetAngles():Up() * advmelee.CMtoHU(self.Length)) / 3)
	effect:SetNormal(ent:GetAngles():Up())
	effect:SetAngles(ent:GetAngles())
	effect:SetMagnitude(1)
	effect:SetRadius(1)
	effect:SetScale(1)

	util.Effect("Sparks", effect, nil, true)

	--since it was just a prediction for client we have to send effects to everyone else
	if SERVER then
		self:DoParryEffect(ent, ent_weapon)
	end
end

if CLIENT then
net.Receive("advmelee:PlayerParried", function()
	local ply = net.ReadEntity()
	if !IsValid(ply) then
		return
	end

	local wep = net.ReadEntity()
	if !IsValid(wep) then
		return
	end

	local effect = EffectData()
	local pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Anim_Attachment_RH")) + (ply:GetAngles():Up() * advmelee.CMtoHU(wep.Length)) / 3
	effect:SetEntity(wep)
	effect:SetOrigin(pos)
	effect:SetNormal(ply:GetAngles():Up())
	effect:SetAngles(ply:GetAngles())
	effect:SetMagnitude(1)
	effect:SetRadius(1)
	effect:SetScale(1)

	wep:HitSolidDLight(ply, pos)
end)
end

--if we parry someone's hit
function SWEP:WeParry(ent, ent_weapon)
	ent_weapon:EmitSound(ent_weapon.ParrySounds[math.random(1, #ent_weapon.ParrySounds)])
	self:EmitSound(self.HitSolidSounds[math.random(1, #self.HitSolidSounds)], 75, math.random(98, 102), 1, CHAN_WEAPON)

	if CLIENT then
		if ent == LocalPlayer() then
			return
		end
	end
	local effect = EffectData()
	effect:SetEntity(ent_weapon)
	effect:SetOrigin(self:GetOwner():GetShootPos() + (self:GetOwner():GetAimVector() * advmelee.CMtoHU(self.Length)) / 3)
	effect:SetNormal(ent:GetAngles():Up())
	effect:SetAngles(ent:GetAngles())
	effect:SetMagnitude(1)
	effect:SetRadius(1)
	effect:SetScale(1)

	util.Effect("Sparks", effect, nil, true)
end

function SWEP:CalculateSwingAttack()
	local owner = self:GetOwner()
	--we need to lag compensate the player because it's not primary attack
	owner:LagCompensation(true)
	--firstly we want to calculate direct attack
	local startpos = owner:GetShootPos()
	local dir = owner:GetAimVector()
	local point_trace = {}
	point_trace.start = startpos
	point_trace.endpos = startpos + dir * advmelee.CMtoHU(self.Length)
	point_trace.mask = MASK_SOLID
	point_trace.filter = owner

	tr = util.TraceLine(point_trace)
	if tr.Hit then
		local hiswep = false
		if tr.Entity.GetActiveWeapon then
			local ent_actwep = tr.Entity:GetActiveWeapon()

			--checking for our weapon
			if IsValid(ent_actwep) then
				if ent_actwep:GetClass() == "adv_melee_base" or weapons.IsBasedOn(ent_actwep:GetClass(), "adv_melee_base") then
					hiswep = ent_actwep
					if ent_actwep:GetParrying() and !self:IsBackstab(tr.Entity) then
						--reset cd for successful parry
						ent_actwep:SetParryCooldown(false)
						self:GotParried(tr.Entity, ent_actwep)
						return true, tr.Entity
					end
				end
			end
		end

		if hiswep then
			hiswep:Flinch()
		end

		--predicted hit effects
		self:CreateHitEffect(tr.Entity, tr.HitPos, tr.HitNormal)

		if SERVER then
			self:CalculateSwingDamage(tr.Entity, tr.HitPos)
		end

		owner:LagCompensation(false)
		return true, tr.Entity --tell think function to stop swing
	end

	--if we hit nothing - find nearest bone
	local ent, bone, bone_pos = self:GetHitBone(owner, 20)
	if IsValid(ent) then
		local hiswep = false
		if ent.GetActiveWeapon then
			local ent_actwep = ent:GetActiveWeapon()

			--checking for our weapon
			if IsValid(ent_actwep) then
				if ent_actwep:GetClass() == "adv_melee_base" or weapons.IsBasedOn(ent_actwep:GetClass(), "adv_melee_base") then
					hiswep = ent_actwep
					if ent_actwep:GetParrying() and !self:IsBackstab(ent) then
						--reset cd for successful parry
						ent_actwep:SetParryCooldown(false)
						self:GotParried(ent, ent_actwep)
						return true, ent
					end
				end
			end
		end

		if hiswep then
			hiswep:Flinch()
		end

		--predicted hit effects
		self:CreateHitEffect(ent, bone_pos)

		if SERVER then
			self:CalculateSwingDamage(ent, bone_pos)
		end

		owner:LagCompensation(false)
		return true, ent --tell think function to stop swing
	end
	owner:LagCompensation(false)
end

function SWEP:CalculateStabAttack()
	local owner = self:GetOwner()
	--we need to lag compensate the player because it's not primary attack
	owner:LagCompensation(true)
	--firstly we want to calculate direct attack
	local startpos = owner:GetShootPos()
	local dir = owner:GetAimVector()
	local point_trace = {}
	point_trace.start = startpos
	point_trace.endpos = startpos + dir * advmelee.CMtoHU(self.Length + 10) --bonus 10cm for stabbing
	point_trace.mask = MASK_SOLID
	point_trace.filter = owner

	tr = util.TraceLine(point_trace)
	if tr.Hit then
		hiswep = false
		if tr.Entity.GetActiveWeapon then
			local ent_actwep = tr.Entity:GetActiveWeapon()

			--checking for our weapon
			if IsValid(ent_actwep) then
				if ent_actwep:GetClass() == "adv_melee_base" or weapons.IsBasedOn(ent_actwep:GetClass(), "adv_melee_base") then
					hiswep = ent_actwep
					if ent_actwep:GetParrying() and !self:IsBackstab(tr.Entity) then
						--reset cd for successful parry
						ent_actwep:SetParryCooldown(false)
						self:GotParried(tr.Entity, ent_actwep)
						return true, tr.Entity
					end
				end
			end
		end

		if hiswep then
			hiswep:Flinch()
		end

		--predicted hit effects
		self:CreateHitEffect(tr.Entity, tr.HitPos, tr.HitNormal)

		if SERVER then
			self:CalculateStabDamage(tr.Entity, tr.HitPos)
		end

		owner:LagCompensation(false)
		return true, tr.Entity --tell think function to stop swing
	end

	--if we hit nothing - find nearest bone
	local ent, bone, bone_pos = self:GetHitBone(owner, 10) --you have to be precise with stabs
	if IsValid(ent) then
		local hiswep = false
		if ent.GetActiveWeapon then
			local ent_actwep = ent:GetActiveWeapon()

			--checking for our weapon
			if IsValid(ent_actwep) then
				if ent_actwep:GetClass() == "adv_melee_base" or weapons.IsBasedOn(ent_actwep:GetClass(), "adv_melee_base") then
					hiswep = ent_actwep
					if ent_actwep:GetParrying() and !self:IsBackstab(ent) then
						--reset cd for successful parry
						ent_actwep:SetParryCooldown(false)
						self:GotParried(ent, ent_actwep)
						return true, ent
					end
				end
			end
		end

		if hiswep then
			hiswep:Flinch()
		end

		--predicted hit effects
		self:CreateHitEffect(ent, bone_pos)

		if SERVER then
			self:CalculateStabDamage(ent, bone_pos)
		end

		owner:LagCompensation(false)
		return true, ent --tell think function to stop swing
	end
	owner:LagCompensation(false)
end

function SWEP:Think()
	local owner = self:GetOwner()

	--DON'T FORGET TO CHANGE SERVERSIDE CODE
	if CLIENT then
		--FUUUUUUCK THIS IS SO NASTY
		if self.WaitForSwingCalculation then
			local hit, ent = self:CalculateSwingAttack()

			if hit then
				self:SetSwinging(false)
				self:SetFullRelease(false)
				self.WaitForSwingCalculation = false
				self:SetRiposte(false)
			end

			self:SetAttackRecovery(true)
			self:ConfigureGestures(owner, self.SwingAnimWeight, 0.8)
			self:SetRiposte(false)
			timer.Simple(self.SwingRecovery / 1000, function()
				if !(IsValid(self) and IsValid(self:GetOwner())) then
					return
				end

				self:SetAttackRecovery(false)
			end)
		end

		--FUUUUUUCK THIS IS SO NASTY
		if self.WaitForStabCalculation then
			self:SetHoldType(self.StabHoldType)
			--self.HoldType = self.StabHoldType --Fuck this shit

			local hit, ent = self:CalculateStabAttack()

			if hit then
				self:SetStabbing(false)
				self:SetFullRelease(false)
				self.WaitForStabCalculation = false
				self:SetRiposte(false)
			end

			self:SetAttackRecovery(true)
			self:ConfigureGestures(owner, self.StabAnimWeight, 0.8)
			self:SetRiposte(false)
			timer.Simple(self.StabRecovery / 1000, function()
				if !(IsValid(self) and IsValid(self:GetOwner())) then
					return
				end

				self:SetAttackRecovery(false)
				if !self:GetStabbing() then
					self:SetHoldType(self.MainHoldType)
				end
			end)
		end
	end

	--DON'T FORGET TO CHANGE CLIENTSIDE PREDICTION
	if self:GetFullRelease() then
		if self:GetSwinging() then
			local hit, ent = self:CalculateSwingAttack()

			if hit then
				self:SetSwinging(false)
				self:SetFullRelease(false)
				self:SetRiposte(false)
			end

			self:SetAttackRecovery(true)
			self:ConfigureGestures(owner, self.SwingAnimWeight, 0.8)
			self:SetRiposte(false)
			timer.Simple(self.SwingRecovery / 1000, function()
				if !(IsValid(self) and IsValid(self:GetOwner())) then
					return
				end

				self:SetAttackRecovery(false)
			end)
		end

		if self:GetStabbing() then
			self:SetHoldType(self.StabHoldType)
			--self.HoldType = self.StabHoldType --Fuck this shit

			local hit, ent = self:CalculateStabAttack()

			if hit then
				self:SetStabbing(false)
				self:SetFullRelease(false)
				self:SetRiposte(false)
			end

			self:SetAttackRecovery(true)
			self:ConfigureGestures(owner, self.StabAnimWeight, 0.8)
			self:SetRiposte(false)
			timer.Simple(self.StabRecovery / 1000, function()
				if !(IsValid(self) and IsValid(self:GetOwner())) then
					return
				end

				self:SetAttackRecovery(false)
				if !self:GetStabbing() then
					self:SetHoldType(self.MainHoldType)
				end
			end)
		end
	end

	local owner_table = owner:GetTable()
	if owner_table.advmelee_mouse_scroll_up then
		if self:CanAttack() then
			self:Stab()
		end
	end

	if self:GetFeint() then
		local weight = math.Approach(self:GetFeintWeight(), 0, 0.05)
		self:SetFeintWeight(weight)
		self:ConfigureGestures(owner, weight, 3)

		--bug fix
		if self:GetWindUp() then
			timer.Remove("advmelee:Swing_"..self:EntIndex())
			timer.Remove("advmelee:Stab_"..self:EntIndex())

			local vm = owner:GetViewModel()
			vm:SendViewModelMatchingSequence(vm:LookupSequence(self.IdleAnimVM))

			self:SetWindUp(false)
		end

		if weight == 0 then
			self:SetFeint(false)

			if self:GetSwingQueued() then
				self:Slash()
				self:SetSwingQueued(false)
			elseif self:GetStabQueued() then
				self:Stab()
				self:SetStabQueued(false)
			end
		end
	end

	if self:GetFlinched() then
		local weight = math.Approach(self:GetFlinchWeight(), 0, 0.05)
		self:SetFlinchWeight(weight)
		self:ConfigureGestures(owner, weight, 3)
	end
end

--[[---------------------------------------------------------
	Name: SWEP:Initialize()
	Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType(self.MainHoldType)
end

--[[---------------------------------------------------------
	Name: SWEP:PrimaryAttack()
	Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self:Attack()
end

--[[---------------------------------------------------------
	Name: SWEP:SecondaryAttack()
	Desc: +attack2 has been pressed
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
	self:Parry()
end

--[[---------------------------------------------------------
	Name: SWEP:Reload()
	Desc: Reload is being pressed
-----------------------------------------------------------]]
function SWEP:Reload()
	if IsFirstTimePredicted() then
		self:Feint()
	end
end

function SWEP:ResetNetVars()
	self:SetParrying(false)
	self:SetParryCooldown(false)
	self:SetWindUp(false)
	self:SetAttackRecovery(false)
	self:SetSwinging(false)
	self:SetStabbing(false)
	self:SetFullRelease(false)
	self:SetFeint(false)
	self:SetSwingQueued(false)
	self:SetStabQueued(false)
	self:SetFlinched(false)
	self:SetRiposte(false)
	self:SetFlinchWeight(0)
	self:SetFeintWeight(0)
	if CLIENT then
		self.WaitForSwingCalculation = false
		self.WaitForStabCalculation = false
	end
end

function SWEP:Holster( wep )
	self:ResetNetVars()
	return true
end

function SWEP:Deploy()
	self:ResetNetVars()
	return true
end

/********************************
MAIN FUNCTIONS END
********************************/

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

--[[---------------------------------------------------------
	Name: OnRemove
	Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end

--[[---------------------------------------------------------
	Name: OwnerChanged
	Desc: When weapon is dropped or picked up by a new player
-----------------------------------------------------------]]
function SWEP:OwnerChanged()
end

--[[---------------------------------------------------------
	Name: SetDeploySpeed
	Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
-----------------------------------------------------------]]
function SWEP:SetDeploySpeed( speed )
	self.m_WeaponDeploySpeed = tonumber( speed )
end

SWEP:SetDeploySpeed(1)

--[[---------------------------------------------------------
	Name: DoImpactEffect
	Desc: Callback so the weapon can override the impact effects it makes
		 return true to not do the default thing - which is to call UTIL_ImpactTrace in c++
-----------------------------------------------------------]]
function SWEP:DoImpactEffect( tr, nDamageType )

	return false

end

--[[
--default sequences
0	=	idle
1	=	ragdoll
2	=	reference
3	=	idle_all_01
4	=	idle_all_02
5	=	idle_all_angry
6	=	idle_all_scared
7	=	idle_all_cower
8	=	cidle_all
9	=	swim_idle_all
10	=	sit
11	=	menu_walk
12	=	menu_combine
13	=	menu_gman
14	=	walk_all
15	=	cwalk_all
16	=	run_all_01
17	=	run_all_02
18	=	run_all_panicked_01
19	=	run_all_panicked_02
20	=	run_all_panicked_03
21	=	run_all_protected
22	=	run_all_charging
23	=	swimming_all
24	=	walk_suitcase
25	=	aimlayer_magic_delta_ref
26	=	aimlayer_magic_delta
27	=	soldier_Aim_9_directions
28	=	weapons_Aim_9_directions
29	=	weapons_Aim_9_directions_Alert
30	=	aimlayer_ar2
31	=	aimlayer_camera
32	=	aimlayer_camera_crouch
33	=	aimlayer_crossbow
34	=	aimlayer_dual
35	=	aimlayer_dual_crouch
36	=	aimlayer_dual_walk
37	=	aimlayer_dual_run
38	=	aimlayer_knife
39	=	aimlayer_knife_crouch
40	=	aimlayer_knife_walk
41	=	aimlayer_magic
42	=	aimlayer_magic_crouch
43	=	aimlayer_melee
44	=	aimlayer_melee2
45	=	aimlayer_melee2_crouch
46	=	aimlayer_physgun
47	=	aimlayer_physgun_crouch
48	=	aimlayer_physgun_run
49	=	aimlayer_pistol
50	=	aimlayer_pistol_crouch
51	=	aimlayer_pistol_walk
52	=	aimlayer_pistol_run
53	=	aimlayer_rpg
54	=	aimlayer_rpg_crouch
55	=	aimlayer_revolver
56	=	aimlayer_revolver_walk
57	=	aimlayer_revolver_run
58	=	aimlayer_slam
59	=	aimlayer_slam_crouch
60	=	aimlayer_shotgun
61	=	aimlayer_smg
62	=	cidle_ar2
63	=	cidle_crossbow
64	=	cidle_camera
65	=	cidle_dual
66	=	cidle_fist
67	=	cidle_grenade
68	=	cidle_knife
69	=	cidle_magic
70	=	cidle_melee
71	=	cidle_melee2
72	=	cidle_passive
73	=	cidle_physgun
74	=	cidle_pistol
75	=	cidle_revolver
76	=	cidle_rpg
77	=	cidle_shotgun
78	=	cidle_slam
79	=	cidle_smg1
80	=	cwalk_ar2
81	=	cwalk_camera
82	=	cwalk_crossbow
83	=	cwalk_dual
84	=	cwalk_fist
85	=	cwalk_knife
86	=	cwalk_magic
87	=	cwalk_melee2
88	=	cwalk_passive
89	=	cwalk_pistol
90	=	cwalk_physgun
91	=	cwalk_revolver
92	=	cwalk_rpg
93	=	cwalk_shotgun
94	=	cwalk_smg1
95	=	cwalk_grenade
96	=	cwalk_melee
97	=	cwalk_slam
98	=	idle_ar2
99	=	idle_camera
100	=	idle_crossbow
101	=	idle_dual
102	=	idle_knife
103	=	idle_grenade
104	=	idle_magic
105	=	idle_melee
106	=	idle_melee2
107	=	idle_passive
108	=	idle_pistol
109	=	idle_physgun
110	=	idle_revolver
111	=	idle_rpg
112	=	idle_shotgun
113	=	idle_slam
114	=	idle_smg1
115	=	jump_ar2
116	=	jump_camera
117	=	jump_crossbow
118	=	jump_dual
119	=	jump_fist
120	=	jump_grenade
121	=	jump_knife
122	=	jump_magic
123	=	jump_melee
124	=	jump_melee2
125	=	jump_passive
126	=	jump_pistol
127	=	jump_physgun
128	=	jump_revolver
129	=	jump_rpg
130	=	jump_shotgun
131	=	jump_slam
132	=	jump_smg1
133	=	run_ar2
134	=	run_camera
135	=	run_crossbow
136	=	run_dual
137	=	run_fist
138	=	run_knife
139	=	run_magic
140	=	run_melee2
141	=	run_passive
142	=	run_physgun
143	=	run_revolver
144	=	run_rpg
145	=	run_shotgun
146	=	run_smg1
147	=	run_grenade
148	=	run_melee
149	=	run_pistol
150	=	run_slam
151	=	sit_ar2
152	=	sit_camera
153	=	sit_crossbow
154	=	sit_duel
155	=	sit_fist
156	=	sit_grenade
157	=	sit_knife
158	=	sit_melee
159	=	sit_melee2
160	=	sit_pistol
161	=	sit_shotgun
162	=	sit_smg1
163	=	sit_physgun
164	=	sit_rpg
165	=	sit_passive
166	=	sit_slam
167	=	swim_idle_ar2
168	=	swim_idle_camera
169	=	swim_idle_crossbow
170	=	swim_idle_duel
171	=	swim_idle_fist
172	=	swim_idle_gravgun
173	=	swim_idle_grenade
174	=	swim_idle_knife
175	=	swim_idle_magic
176	=	swim_idle_melee
177	=	swim_idle_melee2
178	=	swim_idle_passive
179	=	swim_idle_pistol
180	=	swim_idle_revolver
181	=	swim_idle_rpg
182	=	swim_idle_shotgun
183	=	swim_idle_slam
184	=	swim_idle_smg1
185	=	swimming_ar2
186	=	swimming_camera
187	=	swimming_crossbow
188	=	swimming_duel
189	=	swimming_fist
190	=	swimming_gravgun
191	=	swimming_magic
192	=	swimming_melee2
193	=	swimming_passive
194	=	swimming_revolver
195	=	swimming_rpg
196	=	swimming_shotgun
197	=	swimming_smg1
198	=	swimming_grenade
199	=	swimming_knife
200	=	swimming_melee
201	=	swimming_pistol
202	=	swimming_slam
203	=	walk_ar2
204	=	walk_camera
205	=	walk_crossbow
206	=	walk_dual
207	=	walk_fist
208	=	walk_knife
209	=	walk_magic
210	=	walk_melee2
211	=	walk_passive
212	=	walk_physgun
213	=	walk_revolver
214	=	walk_rpg
215	=	walk_shotgun
216	=	walk_smg1
217	=	walk_grenade
218	=	walk_melee
219	=	walk_pistol
220	=	walk_slam
221	=	death_01
222	=	death_02
223	=	death_03
224	=	death_04
225	=	idle_melee_angry
226	=	idle_suitcase
227	=	sit_zen
228	=	pose_standing_01
229	=	pose_standing_02
230	=	pose_standing_03
231	=	pose_standing_04
232	=	pose_ducking_01
233	=	pose_ducking_02
234	=	seq_cower
235	=	seq_preskewer
236	=	seq_baton_swing
237	=	seq_meleeattack01
238	=	seq_throw
239	=	seq_wave_smg1
240	=	idle_layer
241	=	idle_layer_alt
242	=	idle_layer_alt_nofeetlock
243	=	idle_layer_lock_right
244	=	gmod_breath_layer
245	=	gmod_breath_layer_lock_right
246	=	gmod_breath_layer_lock_hands
247	=	gmod_breath_layer_sitting
248	=	gmod_breath_noclip_layer
249	=	gmod_jump_delta
250	=	jump_land
251	=	gesture_voicechat
252	=	gesture_agree_original
253	=	gesture_agree_pelvis_layer
254	=	gesture_agree_base_layer
255	=	gesture_agree
256	=	gesture_bow_original
257	=	gesture_bow_pelvis_layer
258	=	gesture_bow_base_layer
259	=	gesture_bow
260	=	gesture_becon_original
261	=	gesture_becon_pelvis_layer
262	=	gesture_becon_base_layer
263	=	gesture_becon
264	=	gesture_disagree_original
265	=	gesture_disagree_pelvis_layer
266	=	gesture_disagree_base_layer
267	=	gesture_disagree
268	=	gesture_salute_original
269	=	gesture_salute_pelvis_layer
270	=	gesture_salute_base_layer
271	=	gesture_salute
272	=	gesture_wave_original
273	=	gesture_wave_pelvis_layer
274	=	gesture_wave_base_layer
275	=	gesture_wave
276	=	gesture_item_drop_original
277	=	gesture_item_drop_pelvis_layer
278	=	gesture_item_drop_base_layer
279	=	gesture_item_drop
280	=	gesture_item_give_original
281	=	gesture_item_give_pelvis_layer
282	=	gesture_item_give_base_layer
283	=	gesture_item_give
284	=	gesture_item_place_original
285	=	gesture_item_place_pelvis_layer
286	=	gesture_item_place_base_layer
287	=	gesture_item_place
288	=	gesture_item_throw_original
289	=	gesture_item_throw_pelvis_layer
290	=	gesture_item_throw_base_layer
291	=	gesture_item_throw
292	=	gesture_signal_forward_original
293	=	gesture_signal_forward_pelvis_layer
294	=	gesture_signal_forward_base_layer
295	=	gesture_signal_forward
296	=	gesture_signal_halt_original
297	=	gesture_signal_halt_pelvis_layer
298	=	gesture_signal_halt_base_layer
299	=	gesture_signal_halt
300	=	gesture_signal_group_original
301	=	gesture_signal_group_pelvis_layer
302	=	gesture_signal_group_base_layer
303	=	gesture_signal_group
304	=	taunt_cheer_base
305	=	taunt_cheer
306	=	taunt_dance_base
307	=	taunt_dance
308	=	taunt_laugh_base
309	=	taunt_laugh
310	=	taunt_muscle_base
311	=	taunt_muscle
312	=	taunt_robot_base
313	=	taunt_robot
314	=	taunt_persistence_base
315	=	taunt_persistence
316	=	shotgun_pump
317	=	fist_block
318	=	range_ar2
319	=	range_crossbow
320	=	range_dual_r
321	=	range_dual_l
322	=	range_gravgun
323	=	range_grenade
324	=	range_knife
325	=	range_melee
326	=	range_melee2_b
327	=	range_pistol
328	=	range_revolver
329	=	range_rpg
330	=	range_shotgun
331	=	range_slam
332	=	range_smg1
333	=	reload_ar2_original
334	=	reload_ar2_pelvis_layer
335	=	reload_ar2_base_layer
336	=	reload_ar2
337	=	reload_pistol_original
338	=	reload_pistol_pelvis_layer
339	=	reload_pistol_base_layer
340	=	reload_pistol
341	=	reload_smg1_original
342	=	reload_smg1_pelvis_layer
343	=	reload_smg1_base_layer
344	=	reload_smg1
345	=	reload_smg1_alt_original
346	=	reload_smg1_alt_pelvis_layer
347	=	reload_smg1_alt_base_layer
348	=	reload_smg1_alt
349	=	reload_dual_original
350	=	reload_dual_pelvis_layer
351	=	reload_dual_base_layer
352	=	reload_dual
353	=	reload_revolver_original
354	=	reload_revolver_pelvis_layer
355	=	reload_revolver_base_layer
356	=	reload_revolver
357	=	reload_shotgun_original
358	=	reload_shotgun_pelvis_layer
359	=	reload_shotgun_base_layer
360	=	reload_shotgun
361	=	range_melee_shove_2hand_original
362	=	range_melee_shove_2hand_pelvis_layer
363	=	range_melee_shove_2hand_base_layer
364	=	range_melee_shove_2hand
365	=	range_melee_shove_1hand_original
366	=	range_melee_shove_1hand_pelvis_layer
367	=	range_melee_shove_1hand_base_layer
368	=	range_melee_shove_1hand
369	=	range_melee_shove
370	=	flinch_01
371	=	flinch_02
372	=	flinch_back_01
373	=	flinch_head_01
374	=	flinch_head_02
375	=	flinch_phys_01
376	=	flinch_phys_02
377	=	flinch_shoulder_l
378	=	flinch_shoulder_r
379	=	flinch_stomach_01
380	=	flinch_stomach_02
381	=	idle_fist
382	=	idle_fist_layer
383	=	idle_fist_layer_weak
384	=	idle_fist_layer_rt
385	=	range_fists_r
386	=	range_fists_l
387	=	drive_pd
388	=	sit_rollercoaster
389	=	drive_airboat
390	=	drive_jeep
391	=	zombie_anim_fix_pelvis_layer
392	=	zombie_anim_fix_base_layer
393	=	zombie_anim_fix
394	=	zombie_crouch_layer_pelvis
395	=	zombie_idle_01
396	=	zombie_cidle_01
397	=	zombie_cidle_02
398	=	zombie_walk_01
399	=	zombie_walk_02
400	=	zombie_walk_03
401	=	zombie_walk_04
402	=	zombie_walk_05
403	=	zombie_cwalk_01
404	=	zombie_cwalk_02
405	=	zombie_cwalk_03
406	=	zombie_cwalk_04
407	=	zombie_cwalk_05
408	=	zombie_walk_06
409	=	zombie_run_upperbody_layer
410	=	zombie_run
411	=	zombie_run_fast
412	=	zombie_attack_01_original
413	=	zombie_attack_01_pelvis_layer
414	=	zombie_attack_01_base_layer
415	=	zombie_attack_01
416	=	zombie_attack_02_original
417	=	zombie_attack_02_pelvis_layer
418	=	zombie_attack_02_base_layer
419	=	zombie_attack_02
420	=	zombie_attack_03_original
421	=	zombie_attack_03_pelvis_layer
422	=	zombie_attack_03_base_layer
423	=	zombie_attack_03
424	=	zombie_attack_04_original
425	=	zombie_attack_04_pelvis_layer
426	=	zombie_attack_04_base_layer
427	=	zombie_attack_04
428	=	zombie_attack_05_original
429	=	zombie_attack_05_pelvis_layer
430	=	zombie_attack_05_base_layer
431	=	zombie_attack_05
432	=	zombie_attack_06_original
433	=	zombie_attack_06_pelvis_layer
434	=	zombie_attack_06_base_layer
435	=	zombie_attack_06
436	=	zombie_attack_07_original
437	=	zombie_attack_07_pelvis_layer
438	=	zombie_attack_07_base_layer
439	=	zombie_attack_07
440	=	zombie_attack_special_original
441	=	zombie_attack_special_pelvis_layer
442	=	zombie_attack_special_base_layer
443	=	zombie_attack_special
444	=	zombie_attack_frenzy_original
445	=	zombie_attack_frenzy_pelvis_layer
446	=	zombie_attack_frenzy_base_layer
447	=	zombie_attack_frenzy
448	=	taunt_zombie_original
449	=	taunt_zombie_pelvis_layer
450	=	taunt_zombie_base_layer
451	=	taunt_zombie
452	=	menu_zombie_01
453	=	zombie_climb_start
454	=	zombie_climb_loop
455	=	zombie_climb_end
456	=	zombie_leap_start
457	=	zombie_leap_mid
458	=	zombie_slump_idle_02
459	=	zombie_slump_rise_02_fast
460	=	zombie_slump_rise_02_slow
461	=	zombie_slump_idle_01
462	=	zombie_slump_rise_01
463	=	body_rot_z
464	=	head_rot_z
465	=	head_rot_y
]]