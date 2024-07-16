AddCSLuaFile()

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.PrintName		= "scp_new_hands.lua"
SWEP.Author = "UracosVereches"
SWEP.Purpose = "to create shitty loot/player positions\nshittythingsbecometrue = true"
SWEP.Instructions	= "+reload - change mode\n+attack1 - create spawn position\nvectors are located in garrysmod/data/ksaikok_*.txt"
SWEP.Category = "Breach"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= true
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= false
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false


SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.UseHands = true

SWEP.droppable				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

SWEP.Enabled = false
SWEP.NextChange = 0

SWEP.Mode = "loot"

SWEP.LootPositions = 0
SWEP.PlayerPositions = 0

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

	if CLIENT then
		if !file.Exists("ksaikok_loot.txt", "DATA") then
			file.Write("ksaikok_loot.txt", "this is the loot spawns file")
		end

		if !file.Exists("ksaikok_player.txt", "DATA") then
			file.Write("ksaikok_player.txt", "this is the player spawns file")
		end
	end

end

function SWEP:Reload()
	if !IsFirstTimePredicted() then return end -- shitty thing doesn't work wtf
	self:ThisIsTheFunction()
end

function SWEP:ThisIsTheFunction()
	self.LootPositions = 0
	self.PlayerPositions = 0
end

function SWEP:PrimaryAttack()
	if CLIENT and IsFirstTimePredicted() then
		if !file.Exists("ksaikok_loot.txt", "DATA") then
			file.Write("ksaikok_loot.txt", "this is the loot spawns file")
		end
	
		if !file.Exists("ksaikok_player.txt", "DATA") then
			file.Write("ksaikok_player.txt", "this is the player spawns file")
		end

			local tr = util.TraceLine( {
				start = LocalPlayer():EyePos(),
				endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 10000,
				mask = MASK_ALL,
				filter = function(ent)
					if ent == LocalPlayer() then
						return false
					end
				end
			} )

			tr.HitPos.z = tr.HitPos.z + 10

			prop_occupied = ents.CreateClientProp()
			prop_occupied:SetPos(tr.HitPos)
			prop_occupied:SetModel("models/hunter/plates/plate.mdl")
			--prop_occupied:SetParent(ply)
			prop_occupied:SetColor(Color(255, 255, 0))
			prop_occupied:Spawn()

			file.Append("ksaikok_loot.txt", "\nVector("..tr.HitPos.x..", "..tr.HitPos.y..", "..tr.HitPos.z.."),")
			print("Vector("..tr.HitPos.x..", "..tr.HitPos.y..", "..tr.HitPos.z.."),")
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "Successfully saved loot position")
			self.LootPositions = self.LootPositions + 1

		end

end

function SWEP:OnRemove()

end

function SWEP:Holster()
	if IsValid(prop_check) then
		prop_check:Remove()
	end

	if IsValid(prop_check_crosshair) then
		prop_check_crosshair:Remove()
	end

	return true
end

function SWEP:SecondaryAttack()
	if CLIENT and IsFirstTimePredicted() then
		if !file.Exists("ksaikok_loot.txt", "DATA") then
			file.Write("ksaikok_loot.txt", "this is the loot spawns file")
		end

		if !file.Exists("ksaikok_player.txt", "DATA") then
			file.Write("ksaikok_player.txt", "this is the player spawns file")
		end
		
		spawn_occupied = ents.CreateClientProp()
		spawn_occupied:SetPos(LocalPlayer():GetPos())
		spawn_occupied:SetModel("models/editor/playerstart.mdl")
		spawn_occupied:Spawn()

		file.Append("ksaikok_player.txt", "\nVector("..LocalPlayer():GetPos().x..", "..LocalPlayer():GetPos().y..", "..LocalPlayer():GetPos().z.."),") -- ez
		print("Vector("..LocalPlayer():GetPos().x..", "..LocalPlayer():GetPos().y..", "..LocalPlayer():GetPos().z.."),")
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "Successfully saved player position")
		self.PlayerPositions = self.PlayerPositions + 1
	end
end

function SWEP:CanPrimaryAttack()
end

function SWEP:Think()
	if CLIENT then
		if IsValid(prop_check_crosshair) then
				prop_check_crosshair:Remove()
		end

		local tr = util.TraceLine( {
			start = LocalPlayer():EyePos(),
			endpos = LocalPlayer():EyePos() + EyeAngles():Forward() * 10000,
			mask = MASK_ALL,
			filter = function(ent)
				if ent == LocalPlayer() then
					return false
				end
			end
		} )

			tr.HitPos.z = tr.HitPos.z + 10

		prop_check_crosshair = ents.CreateClientProp()
		prop_check_crosshair:SetPos(tr.HitPos)
		prop_check_crosshair:SetModel("models/hunter/plates/plate.mdl")
		--prop_check_crosshair:SetParent(ply)
		prop_check_crosshair:SetRenderMode(RENDERMODE_TRANSCOLOR)
		prop_check_crosshair:SetColor(Color(255, 255, 255, 150))
		prop_check_crosshair:Spawn()
	end
end

function SWEP:DrawHUD()
	draw.SimpleTextOutlined("Loot positions: "..self.LootPositions, "DermaDefault", ScrW() * 0.5, ScrH() * 0.78, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.7, Color(0, 0, 0))
	draw.SimpleTextOutlined("Player positions: "..self.PlayerPositions, "DermaDefault", ScrW() * 0.5, ScrH() * 0.8, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.7, Color(0, 0, 0))
end