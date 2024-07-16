--[[—————————————————————————————————————————————————————————————————————————

		Да, я знаю что это лютый говно код но мне честно говоря поебать
			Це писалось на скорую руку и для личного использования

—————————————————————————————————————————————————————————————————————————]]--

SWEP.Category 				= "Инструменты"
SWEP.PrintName				= "Incredible Selection SWEP"	
SWEP.Author					= "Be1zebub"
SWEP.Contact				= "Beelzebub#0281 </> beelzebub@incredible-gmod.ru"
SWEP.Instructions			= ""
SWEP.ViewModelFOV 			= 90
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= true
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay          = 1
SWEP.Secondary.Delay        = 0.4
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"
SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.IdleAnim				= true
SWEP.ViewModel				= ""
SWEP.WorldModel				= ""
SWEP.IconLetter				= "w"
SWEP.Primary.Sound 			= ("") 
SWEP.HoldType 				= "fist"
SWEP.IsSelectionSwep = true --Для быстрой проверки свепа (за место LocalPlayer():GetActiveWeapon:GetClass() == "swep_class")

if SERVER then return end

function SWEP:Deploy()
	self.BoxPosition = nil
	self.BoxSize = nil
end

function SWEP:PrimaryAttack()
	/*
	if (self.AttackDelay or 0) > CurTime() then return end
	self.AttackDelay = CurTime()+0.1
	*/

	if LocalPlayer():KeyDown(IN_SPEED) then
		self.BoxPosition = LocalPlayer():GetPos()
	else
		self.BoxPosition = LocalPlayer():GetEyeTrace().HitPos
	end
end

function SWEP:SecondaryAttack()
	/*
	if (self.SecAttackDelay or 0) > CurTime() then return end
	self.SecAttackDelay = CurTime()+0.1
	*/

	if LocalPlayer():KeyDown(IN_SPEED) then
		self.BoxSize = LocalPlayer():GetPos()
	else
		self.BoxSize = LocalPlayer():GetEyeTrace().HitPos
	end
end

function SWEP:Reload()
	--Эту хуибалу по хорошему было бы перенести в KeyPress хук в cl файлике, но на самом деле и тааак сойдёт :)
	if (self.ReloadDelay or 0) > CurTime() then return end
	self.ReloadDelay = CurTime()+0.5

	local trace_hit  = LocalPlayer():GetEyeTrace().HitPos
	trace_hit = Vector(math.Round(trace_hit.x), math.Round(trace_hit.y), math.Round(trace_hit.z))

	local sting_hit = "Vector("..(trace_hit.x)..", "..(trace_hit.y)..", "..(trace_hit.z)..")"
	chat.AddText(Color(40, 149, 220), "[HitPos] ", Color(255,255,255), sting_hit.." скопирован в буфер обмена!")
	SetClipboardText(sting_hit)
end

local color_white, color_red = Color(255, 255, 255, 255), Color(255, 50, 50)

function SWEP:DrawHUD()
	local Sw, Sh = ScrW(), ScrH()
	local lply = LocalPlayer()

	draw.SimpleText("Incredible Selection SWEP:", "IncSelectionHudInfo", Sw/2, Sh*0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText("[LMB]: Create First Box Corner", "IncSelectionHudInfo", Sw/2, Sh*0.105, ( ( lply:KeyDown(IN_ATTACK) and not lply:KeyDown(IN_SPEED) ) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("[RMB]: Create Two Box Corner", "IncSelectionHudInfo", Sw/2, Sh*0.13, ( ( lply:KeyDown(IN_ATTACK2)  and not lply:KeyDown(IN_SPEED) ) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText("[SHIFT+LMB]: Create First Box Corner on youself position", "IncSelectionHudInfo", Sw/2, Sh*0.155, ( ( lply:KeyDown(IN_ATTACK) and lply:KeyDown(IN_SPEED) ) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("[SHIFT+RMB]: Create Two Box Corner on youself position", "IncSelectionHudInfo", Sw/2, Sh*0.18, ( ( lply:KeyDown(IN_ATTACK2) and lply:KeyDown(IN_SPEED) ) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


	draw.SimpleText("[E]: Copy Box Corners Positions", "IncSelectionHudInfo", Sw/2, Sh*0.205, ( lply:KeyDown(IN_USE) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("[R]: Copy Trace Hit-Position", "IncSelectionHudInfo", Sw/2, Sh*0.23, ( lply:KeyDown(IN_RELOAD) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText("["..string.upper( input.LookupBinding("+zoom", true) or "bind g +zoom" ).."]: Copy Entity Info", "IncSelectionHudInfo", Sw/2, Sh*0.255, ( lply:KeyDown(IN_ZOOM) and color_red or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end





surface.CreateFont( "IncSelectionHudInfo", {
	font = "Roboto",
	size = 26,
	weight = 500,
	extended = true,
})

surface.CreateFont( "IncSelectionBoxSize", {
	font = "Roboto",
	size = 100,
	weight = 500,
	extended = true,
})

local BoxMaterial = Material("debug/debughitbox")
local LineMaterial = Material("cable/new_cable_lit")
local SpriteMaterial = Material("sprites/gmdm_pickups/light")

local boxColor = Color(35, 35, 35, 225)
local lineColor = Color(50, 128, 100, 255)

local colorForLines = lineColor

local hit_check = Vector(0, 0, 0)
local hit_check_delay = CurTime()

local surface_angles = {
	bottom = {
		Angle(0, 0, 180),
		Vector(0,-8.4,-8.4)
	},
	top = {
		Angle(0, 0, 0)
	},
	sur3 = {
		Angle(0, 0, 90),
		Vector(0,-8.4,0)
	},
	sur4 = {
		Angle( 0, -90, 90)
	},
	sur5 = {
		Angle(0, -180, 90),
		Vector(8.4,0,0)
	},
	sur6 = {
		Angle(0, -270, 90),
		Vector(8.4,-8.4,0)
	}
}

hook.Add("PostDrawOpaqueRenderables", "IncSelectionOverlay", function()
	local ply_swep = LocalPlayer():GetActiveWeapon()
	if not ply_swep.IsSelectionSwep then return end

	local trhit  = LocalPlayer():GetEyeTrace().HitPos
	local trace_hit = trhit-Vector(4,-4,-4)

	colorForLines = lineColor

	if trace_hit == hit_check then
		colorForLines = Color( 128, 50, 100, 255 )
	end

	cam.Start3D2D( trace_hit, Angle(0, -180, 90), 0.15 )
		render.SetMaterial(LineMaterial)
		render.DrawBeam( Vector( -26, 26, -99999 ), Vector(-26, -4, 999999), 4, 0, 12, colorForLines )
		render.DrawBeam( Vector( -26, -99999, -4 ), Vector( -26, 999999, -4 ), 0.75, 0, 12, colorForLines )
		render.DrawBeam( Vector( -99999, 26, -4 ), Vector( 999999, 28, -4 ), 0.75, 0, 12, colorForLines )

		render.DrawLine( Vector( -26, -384, -4 ), Vector( -26, 512, -4 ), colorForLines, true )
		render.DrawLine( Vector( -384, 26, -4 ), Vector( 512, 28, -4 ), colorForLines, true )
		render.DrawLine( Vector( -26, 26, -384 ), Vector(-26, 26, 512), colorForLines, true )
	cam.End3D2D()	

	if hit_check_delay < CurTime() then
		hit_check = trace_hit
		hit_check_delay = CurTime() + 0.5
	end

	for _, tab in pairs(surface_angles) do
		cam.Start3D2D( trace_hit+( tab[2] or Vector(0, 0, 0) ), tab[1], 0.15 )
			surface.SetDrawColor(boxColor)
			surface.DrawRect( 0, 0, 56, 56 )
		cam.End3D2D()
	end

	for _, tab in pairs(surface_angles) do
		cam.Start3D2D( trace_hit+( tab[2] or Vector(0, 0, 0) ), tab[1], 0.15 )
			local textColor = Color(255, 255, 255, 255)
			if colorForLines == Color(50, 128, 100, 255) then
				textColor = colorForLines
			end

			draw.SimpleText("x: "..math.Round(trhit.x), "Trebuchet18", 28, 14, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("y: "..math.Round(trhit.y), "Trebuchet18", 28, 28, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("z: "..math.Round(trhit.z), "Trebuchet18", 28, 42, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end



	cam.Start3D()
		render.SetMaterial(SpriteMaterial)
		if ply_swep.BoxPosition then
			render.DrawSprite( ply_swep.BoxPosition, 64, 64, Color(175, 255, 255, 255) )
			if ply_swep.BoxSize then
				render.DrawSprite( ply_swep.BoxSize, 64, 64, Color(175, 255, 255, 255) )

				render.SetMaterial(BoxMaterial)
				render.DrawBox( ( ply_swep.BoxPosition or Vector(0, 0, 0) ), Angle(0, 0, 0), Vector(0, 0, 0), ( Vector(-ply_swep.BoxPosition.x, -ply_swep.BoxPosition.y, -ply_swep.BoxPosition.z) + ply_swep.BoxSize or Vector(0, 0, 0) ), Color( 0, 0, 0, 175 ) )
--[[
				На самом деле Линии можно было бы сделать повторным боксом по верх спрайтов с материалом Wireframe, но мне так как то по более нравиться))

				render.SetMaterial( Material("models/wireframe") )
				render.DrawBox( ( ply_swep.BoxPosition or Vector(0, 0, 0) ), Angle(0, 0, 0), Vector(0, 0, 0), ( Vector(-ply_swep.BoxPosition.x, -ply_swep.BoxPosition.y, -ply_swep.BoxPosition.z) + ply_swep.BoxSize or Vector(0, 0, 0) ), Color( 0, 0, 0, 175 ) )
]]--

				render.DrawLine( ( ply_swep.BoxPosition or Vector(0, 0, 0) ), ( ply_swep.BoxSize or Vector(0, 0, 0) ), color_white, true)

				render.DrawLine( ( ply_swep.BoxPosition or Vector(0, 0, 0) ), Vector( (ply_swep.BoxSize.x or 0), (ply_swep.BoxPosition.y or 0), (ply_swep.BoxPosition.z or 0) ), color_white, true)
				render.DrawLine( ( ply_swep.BoxPosition or Vector(0, 0, 0) ), Vector( (ply_swep.BoxPosition.x or 0), (ply_swep.BoxSize.y or 0), (ply_swep.BoxPosition.z or 0) ), color_white, true)
				render.DrawLine( ( ply_swep.BoxPosition or Vector(0, 0, 0) ), Vector( (ply_swep.BoxPosition.x or 0), (ply_swep.BoxPosition.y or 0), (ply_swep.BoxSize.z or 0) ), color_white, true)

				render.DrawLine( ( ply_swep.BoxSize or Vector(0, 0, 0) ), Vector( (ply_swep.BoxPosition.x or 0), (ply_swep.BoxSize.y or 0), (ply_swep.BoxSize.z or 0) ), color_white, true)
				render.DrawLine( ( ply_swep.BoxSize or Vector(0, 0, 0) ), Vector( (ply_swep.BoxSize.x or 0), (ply_swep.BoxPosition.y or 0), (ply_swep.BoxSize.z or 0) ), color_white, true)
				render.DrawLine( ( ply_swep.BoxSize or Vector(0, 0, 0) ), Vector( (ply_swep.BoxSize.x or 0), (ply_swep.BoxSize.y or 0), (ply_swep.BoxPosition.z or 0) ), color_white, true)
			end
		end
	cam.End3D()
end)
--[[
Я хуй знает почему оно не робит, мне в падлу с этим долго сидеть так что похуй..
Вообще эта штучка должна писать скалируемый текст в середине селешн-бокса который меняет размеры в зависимости от расстояния центра бокса до игрока, угол поворота текста так же должен следовать за камерой игрока.
Если кому то не в падлу, фиксите и юзайте :)

hook.Add("HUDPaint", "IncSelectionDisplayBoxSize", function()
	local ply_swep = LocalPlayer():GetActiveWeapon()
	if not ply_swep.IsSelectionSwep then return end

	local box_center = ply_swep.BoxPosition + ply_swep.BoxSize/2

	local TextPos = box_center:ToScreen()
    draw.SimpleText( "Hello World!", "IncSelectionBoxSize", TextPos.x, TextPos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
end)
]]--

function VecAngRound(vec, dec)
	local norm = function(num)
		return math.Round(num, (dec or 0) )
	end

	if isvector(vec) then
		return "Vector("..norm(vec.x)..", "..norm(vec.y)..", "..norm(vec.z)..")"
	elseif isangle(vec) then
		return "Angle("..norm(vec.p)..", "..norm(vec.y)..", "..norm(vec.r)..")"
	end
end

hook.Add("KeyPress", "IncSelectionUseBoxCorners" , function(ply, key)
	local ply_swep = LocalPlayer():GetActiveWeapon()
	if not ply_swep.IsSelectionSwep then return end
			
	if key == IN_USE then
		if (ply_swep.UseDelay or 0) > CurTime() then return end
		ply_swep.UseDelay = CurTime()+0.1

		if not ply_swep.BoxPosition or not ply_swep.BoxSize then return end

		local box_pos = Vector(math.Round(ply_swep.BoxPosition.x), math.Round(ply_swep.BoxPosition.y), math.Round(ply_swep.BoxPosition.z))
		box_pos = "Vector("..(box_pos.x)..", "..(box_pos.y)..", "..(box_pos.z)..")"

		local box_sz = Vector(math.Round(ply_swep.BoxSize.x), math.Round(ply_swep.BoxSize.y), math.Round(ply_swep.BoxSize.z))
		box_sz = "Vector("..(box_sz.x)..", "..(box_sz.y)..", "..(box_sz.z)..")"

		chat.AddText(Color(40, 149, 220), "[BoxCorners] ", Color(255,255,255), box_pos..", "..box_sz.." скопированны в буфер обмена!")
		SetClipboardText([[{
		]]..box_pos..[[, 
		]]..box_sz..[[

	},]])
	elseif key == IN_ZOOM then
		if (ply_swep.ZoomDelay or 0) > CurTime() then return end
		ply_swep.ZoomDelay = CurTime()+0.1

		local trace_entity = LocalPlayer():GetEyeTrace().Entity

		local ent_info_tab = {
			pos = trace_entity:GetPos(),
			ang = trace_entity:GetAngles(),
			class = trace_entity:GetClass(),
			mdl = trace_entity:GetModel(),
			mat = trace_entity:GetMaterial(),
		}

		chat.AddText(Color(40, 149, 220), "[EntityInfo] ", Color(255,255,255), "Таблица с информацией о trace-entity скопированна в буфер обмена!")


		SetClipboardText([[{
		]]..VecAngRound( trace_entity:GetPos(), 3 )..[[,
		]]..VecAngRound( trace_entity:GetAngles(), 3 )..[[

	}]])
	end
end)