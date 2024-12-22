--[[


addons/[weapons]_no_260_kk_ins2/lua/weapons/cw_kk_ins2_base_main/o_sh_think.lua

--]]


//-----------------------------------------------------------------------------
// Think edited to finish shotgun reload using separate function
// SWEP:finishReloadShotgun()
//-----------------------------------------------------------------------------

local math = math

local SP = game.SinglePlayer()

local vm, CT, aim, cone, vel

local reg = debug.getregistry()
local GetVelocity = reg.Entity.GetVelocity
local Length = reg.Vector.Length

local IFTP
local wl, ws

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
if CLIENT then
local camignorez = cam.IgnoreZ
end
local wepdrawinteractionmenu = _wep.drawInteractionMenu
local entframeadvance = _ent.FrameAdvance
local math = math
local mathapproach = math.Approach
local entgetparent = _ent.GetParent
local entsetparent = _ent.SetParent
local plyinvehicle = _ply.InVehicle
local plygetallowweaponsinvehicle = _ply.GetAllowWeaponsInVehicle

function SWEP:Think()
	local owner = getowner(self)
	local selftable = gettable(self)

	-- in vehicle? can't do anything, also prevent needless calculations of stuff
	if plyinvehicle(owner) and not plygetallowweaponsinvehicle(owner) then
		selftable.dt.State = CW_ACTION
		return
	end

	CustomizableWeaponry.actionSequence.process(self)

	if selftable.dt.State == CW_HOLSTER_START then
		return
	end

	CT = CurTime()

	if CLIENT then
		if selftable.SubCustomizationCycleTime then
			if UnPredictedCurTime() > selftable.SubCustomizationCycleTime then
				CustomizableWeaponry.cycleSubCustomization(self)
			end
		end
	end

	if selftable.HoldToAim then
		if (SP and SERVER) or not SP then
			if selftable.dt.State == CW_AIMING then
				if not owner:OnGround() or Length(GetVelocity(owner)) >= owner:GetWalkSpeed() * selftable.LoseAimVelocity or not owner:KeyDown(IN_ATTACK2) then
					selftable.dt.State = CW_IDLE
					self:SetNextSecondaryFire(CT + 0.2)
					self:EmitSound("CW_LOWERAIM")
					self:aimIdleAnimFunc()
				end
			end
		end
	end

	if selftable.IndividualThink then
		self:IndividualThink()

		if not IsValid(self) or not IsValid(owner) then
			return
		end
	end

	vel = Length(GetVelocity(owner))
	IFTP = IsFirstTimePredicted()

	if (not SP and IFTP) or SP then
		self:CalculateSpread(vel, FrameTime())
	end

	if CT > selftable.GlobalDelay then
		wl = owner:WaterLevel()

		if owner:OnGround() then
			if wl >= 3 and selftable.HolsterUnderwater then
				if selftable.ShotgunReloadState == 1 then
					selftable.ShotgunReloadState = 2
				end

				selftable.dt.State = CW_ACTION
				selftable.FromActionToNormalWait = CT + 0.3
			else
				ws = owner:GetWalkSpeed()

				if ((vel > ws * selftable.RunStateVelocity and owner:KeyDown(IN_SPEED)) or vel > ws * 3 or (selftable.ForceRunStateVelocity and vel > selftable.ForceRunStateVelocity)) and selftable.SprintingEnabled then
					selftable.dt.State = CW_RUNNING
				else
					if selftable.dt.State != CW_AIMING and selftable.dt.State != CW_CUSTOMIZE then
						if CT > selftable.FromActionToNormalWait then
							if selftable.dt.State != CW_IDLE then
								selftable.dt.State = CW_IDLE

								if not selftable.ReloadDelay then
									self:SetNextPrimaryFire(CT + 0.3)
									self:SetNextSecondaryFire(CT + 0.3)
									selftable.ReloadWait = CT + 0.3
								end
							end
						end
					end
				end
			end
		else
			if (wl > 1 and selftable.HolsterUnderwater) or (owner:GetMoveType() == MOVETYPE_LADDER and selftable.HolsterOnLadder) then
				if selftable.ShotgunReloadState == 1 then
					selftable.ShotgunReloadState = 2
				end

				selftable.dt.State = CW_ACTION
				selftable.FromActionToNormalWait = CT + 0.3
			else
				if CT > selftable.FromActionToNormalWait then
					if selftable.dt.State != CW_IDLE then
						selftable.dt.State = CW_IDLE
						self:SetNextPrimaryFire(CT + 0.3)
						self:SetNextSecondaryFire(CT + 0.3)
						selftable.ReloadWait = CT + 0.3
					end
				end
			end
		end
	end

	if SERVER then
		if selftable.CurSoundTable then
			local t = selftable.CurSoundTable[selftable.CurSoundEntry]

			--[[if CLIENT then
				if CT >= selftable.SoundTime + t.time / selftable.SoundSpeed then
					self:EmitSound(t.sound, 70, 100)
					if selftable.CurSoundTable[selftable.CurSoundEntry + 1] then
						selftable.CurSoundEntry = selftable.CurSoundEntry + 1
					else
						selftable.CurSoundTable = nil
						selftable.CurSoundEntry = nil
						selftable.SoundTime = nil
					end
				end
			else]]--
			if CT >= selftable.SoundTime + t.time / selftable.SoundSpeed then
				self:EmitSound(t.sound, 70, 100)

				if selftable.CurSoundTable[selftable.CurSoundEntry + 1] then
					selftable.CurSoundEntry = selftable.CurSoundEntry + 1
				else
					selftable.CurSoundTable = nil
					selftable.CurSoundEntry = nil
					selftable.SoundTime = nil
				end
			end
			--end
		end
	end

	if selftable.dt.Shots > 0 then
		if not owner:KeyDown(IN_ATTACK) then
			if selftable.BurstAmount and selftable.BurstAmount > 0 then
				selftable.dt.Shots = 0
				self:SetNextPrimaryFire(CT + selftable.FireDelay * selftable.BurstCooldownMul)
				selftable.ReloadWait = CT + selftable.FireDelay * selftable.BurstCooldownMul
			end
		end
	end

	if not selftable.ShotgunReload then
		if selftable.ReloadDelay and CT >= selftable.ReloadDelay then
			self:finishReload() -- more like finnishReload ;0
		end
	end

	if IFTP then
		self:finishReloadShotgun()
	end

	if SERVER then
		if selftable.dt.Safe then
			if selftable.CHoldType != selftable.RunHoldType then
				self:SetHoldType(selftable.RunHoldType)
				selftable.CHoldType = selftable.RunHoldType
			end
		else
			if selftable.dt.State == CW_RUNNING or selftable.dt.State == CW_ACTION then
				if selftable.CHoldType != selftable.RunHoldType then
					self:SetHoldType(selftable.RunHoldType)
					selftable.CHoldType = selftable.RunHoldType
				end
			else
				if selftable.CHoldType != selftable.NormalHoldType then
					self:SetHoldType(selftable.NormalHoldType)
					selftable.CHoldType = selftable.NormalHoldType
				end
			end
		end
	end

	if (SP and SERVER) or not SP then -- if it's SP, then we run it only on the server (otherwise shit gets fucked); if it's MP we predict it
		-- if the bipod DT var is true, or if we have a bipod deploy angle
		if selftable.dt.BipodDeployed or selftable.DeployAngle then
			-- check whether the bipod can be placed on the current surface (so we don't end up placing on nothing)

			if not self:CanRestWeapon(selftable.BipodDeployHeightRequirement) then
				selftable.dt.BipodDeployed = false
				selftable.DeployAngle = nil

				if not selftable.ReloadDelay then
					if CT > selftable.BipodDelay then
						self:performBipodDelay(selftable.BipodUndeployTime)
					else
						selftable.BipodUnDeployPost = true
					end
				else
					selftable.BipodUnDeployPost = true
				end
			end
		end

		if not selftable.ReloadDelay then
			if selftable.BipodUnDeployPost then
				if CT > selftable.BipodDelay then
					if not self:CanRestWeapon(selftable.BipodDeployHeightRequirement) then
						self:performBipodDelay(selftable.BipodUndeployTime)
						selftable.BipodUnDeployPost = false
					else
						selftable.dt.BipodDeployed = true

						self:setupBipodVars()
						selftable.BipodUnDeployPost = false
					end
				end
			end

			if owner:KeyPressed(IN_USE) then
				if CT > selftable.BipodDelay and CT > selftable.ReloadWait then
					if selftable.BipodInstalled then
						if selftable.dt.BipodDeployed then
							selftable.dt.BipodDeployed = false
							selftable.DeployAngle = nil

							self:performBipodDelay(selftable.BipodUndeployTime)
						else
							selftable.dt.BipodDeployed = self:CanRestWeapon(selftable.BipodDeployHeightRequirement)

							if selftable.dt.BipodDeployed then
								self:performBipodDelay(selftable.BipodDeployTime)
								self:setupBipodVars()
							end
						end
					end
				end
			end
		end
	end

	if selftable.forcedState then
		if CT < selftable.ForcedStateTime then
			selftable.dt.State = selftable.forcedState
		else
			selftable.forcedState = nil
		end
	end
end
