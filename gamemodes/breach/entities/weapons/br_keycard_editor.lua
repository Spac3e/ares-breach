AddCSLuaFile()

SWEP.PrintName			= "KEYCARD EDITOR"			

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 1
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo		= "None"

SWEP.droppable				= false

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/c_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"
SWEP.IconLetter			= "Remover"
SWEP.SelectFont			= "DermaLarge"
SWEP.HoldType 			= "normal"

local DoorAccesses = DoorAccesses || {

}

--if (CLIENT) then
	--SWEP.WepSelectIcon	= surface.GetTextureID( "vgui/entities/weapon_scp096" )
	--SWEP.BounceWeaponIcon = false
	--killicon.Add( "kill_icon_scp096", "vgui/icons/kill_icon_scp096", Color( 255, 255, 255, 255 ) )
--end

function SWEP:Initialize()
	if CLIENT then
		self.Author		= "SHAKY"
	end
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		--self.Owner:DrawWorldModel( false )
		--self.Owner:DrawViewModel( false )
	end
end

function SWEP:Holster()
	return true
end

if CLIENT then
	function SWEP:KEYCARDSELECTED(ent)
		if istable(BREACH.KeycardSelector) then
					for i, v in pairs(BREACH.KeycardSelector) do
						if IsValid(v) then v:Remove() end
					end
				end
				BREACH.KeycardSelector = BREACH.KeycardSelector || {}
                local clrgray = Color( 198, 198, 198 )
                local clrgray2 = Color( 180, 180, 180 )
                local clrred = Color( 255, 0, 0 )
                local clrred2 = Color( 50,205,50 )
                local gradienttt = Material( "vgui/gradient-r" )

				local teams_table = {
			
				}


				for i, v in pairs(weapons.GetList()) do
					if v.Base == "breach_keycard_base" then
						local tbl = {
							name = v.PrintName,
							func = function()
									local tablet = {
										pos = ent:GetPos(),
										name = "",
										access = table.Copy(v.CLevels)
									}
									table.insert(DoorAccesses, tablet)
							end
						}
						table.insert(teams_table, tbl)
					end
				end
			
			
				BREACH.KeycardSelector.MainPanel = vgui.Create( "DPanel" )
				BREACH.KeycardSelector.MainPanel:SetSize( 256, 256 )
				BREACH.KeycardSelector.MainPanel:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 128 )
				BREACH.KeycardSelector.MainPanel:SetText( "" )
				BREACH.KeycardSelector.MainPanel.Paint = function( self, w, h )
			
					if ( !vgui.CursorVisible() ) then
			
						gui.EnableScreenClicker( true )
			
					end
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
					if ( input.IsKeyDown( KEY_BACKSPACE ) ) then
			
						self:Remove()
						BREACH.KeycardSelector.MainPanel.Disclaimer:Remove()
						gui.EnableScreenClicker( false )
			
					end
			
				end
			
				BREACH.KeycardSelector.MainPanel.Disclaimer = vgui.Create( "DPanel" )
				BREACH.KeycardSelector.MainPanel.Disclaimer:SetSize( 256, 64 )
				BREACH.KeycardSelector.MainPanel.Disclaimer:SetPos( ScrW() / 2 - 128, ScrH() / 2 - 192 )
				BREACH.KeycardSelector.MainPanel.Disclaimer:SetText( "" )
			
				local client = LocalPlayer()
			
				BREACH.KeycardSelector.MainPanel.Disclaimer.Paint = function( self, w, h )
			
					draw.RoundedBox( 0, 0, 0, w, h, ColorAlpha( color_white, 120 ) )
					draw.OutlinedBox( 0, 0, w, h, 1.5, color_black )
			
					draw.DrawText( "Выбор Ключ-Карты", "ChatFont_new", w / 2, h / 2 - 16, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
					if ( client:Health() <= 0 ) then
			
						if ( IsValid( BREACH.KeycardSelector.MainPanel ) ) then
			
							BREACH.KeycardSelector.MainPanel:Remove()
			
						end
			
						self:Remove()
			
						gui.EnableScreenClicker( false )
			
					end
			
				end
			
				BREACH.KeycardSelector.ScrollPanel = vgui.Create( "DScrollPanel", BREACH.KeycardSelector.MainPanel )
				BREACH.KeycardSelector.ScrollPanel:Dock( FILL )
			
				for i = 1, #teams_table do
			
					BREACH.KeycardSelector.Users = BREACH.KeycardSelector.ScrollPanel:Add( "DButton" )
					BREACH.KeycardSelector.Users:SetText( "" )
					BREACH.KeycardSelector.Users:Dock( TOP )
					BREACH.KeycardSelector.Users:SetSize( 256, 64 )
					BREACH.KeycardSelector.Users:DockMargin( 0, 0, 0, 2 )
					BREACH.KeycardSelector.Users.CursorOnPanel = false
					BREACH.KeycardSelector.Users.gradientalpha = 0
			
					BREACH.KeycardSelector.Users.Paint = function( self, w, h )
			
						if ( self.CursorOnPanel ) then
			
							self.gradientalpha = math.Approach( self.gradientalpha, 255, FrameTime() * 128 )
			
						else
			
							self.gradientalpha = math.Approach( self.gradientalpha, 0, FrameTime() * 256 )
			
						end
			
						draw.RoundedBox( 0, 0, 0, w, h, color_black )
						draw.OutlinedBox( 0, 0, w, h, 1.5, clrgray )
			
						surface.SetDrawColor( ColorAlpha( color_white, self.gradientalpha ) )
						surface.SetMaterial( gradienttt )
						surface.DrawTexturedRect( 0, 0, w, h )
			
						draw.SimpleText( teams_table[ i ].name, "ChatFont_new", w / 2, h / 2, clrgray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
					end
			
					BREACH.KeycardSelector.Users.OnCursorEntered = function( self )
			
						self.CursorOnPanel = true
			
					end
			
					BREACH.KeycardSelector.Users.OnCursorExited = function( self )
			
						self.CursorOnPanel = false
			
					end
			
					BREACH.KeycardSelector.Users.DoClick = function( self )

						teams_table[ i ].func()
			
						BREACH.KeycardSelector.MainPanel:Remove()
						BREACH.KeycardSelector.MainPanel.Disclaimer:Remove()
						gui.EnableScreenClicker( false )
			
					end
			
				end
	end
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if SERVER then return end
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if IsValid( ent ) then
		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:KEYCARDSELECTED(ent)
	end
end

function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if SERVER then return end
	DoorAccesses = {}
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	if SERVER then return end
	for i, v in pairs(DoorAccesses) do
		print("{")
		print("	name = \""..v.name.."\",")
		print("	pos = Vector("..tostring(v.pos.x)..", "..tostring(v.pos.y)..", "..tostring(v.pos.z).."),")
		print("	access = {")
		for name, acc in pairs(v.access) do
			print("		"..name.." = "..tostring(acc)..",")
		end
		print("	}")
		print("},")
	end
end

function SWEP:DrawHUD()
	/*local tr = self.Owner:GetEyeTrace()
	local pos = tr.HitPos:ToScreen()
	local spos = tr.StartPos:ToScreen()
	surface.SetDrawColor( Color( 25, 25, 200, 255 ) )
	surface.DrawLine( spos.x, spos.y, pos.x, pos.y )*/
end