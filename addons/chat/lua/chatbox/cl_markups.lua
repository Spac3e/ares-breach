--[[


addons/[chat]_sh_lounge_chatbox/lua/chatbox/cl_markups.lua

--]]

local matError = Material("icon16/error.png")
local matHourglass = Material("icon16/hourglass.png")
local matImage = Material("icon16/image.png")

local chat_hide_images = CreateClientConVar("lounge_chat_hide_images", 0, true, false)
local chat_hide_avatars = CreateClientConVar("lounge_chat_hide_avatars", 0, true, false)
local chat_disable_flashes = CreateClientConVar("lounge_chat_disable_flashes", 0, true, false)
local chat_no_url_parsing = CreateClientConVar("lounge_chat_no_url_parsing", 0, true, false)
local chat_imgurl_autoload = CreateClientConVar("lounge_chat_imgurl_autoload", 0, true, false)

LOUNGE_CHAT.ChatMarkups = {}

function LOUNGE_CHAT:RegisterChatMarkup(perm, match, func)
	table.insert(self.ChatMarkups, {
		perm = perm,
		match = match,
		func = func,
	})
end

local function noparse(s)
	return {{noparse = true}, s, {noparse = false}}
end

LOUNGE_CHAT:RegisterChatMarkup("lua", "<luabtn=(%d+),(%d+)>(.-)</luabtn>", function(data)
	local id = tonumber(data.args[1])
	local hover = tonumber(data.args[2]) == 1
	local text = (data.args[3] or ""):Trim()
	if (text == "" or !LOUNGE_CHAT.LuaButtons[id]) then
		return end
	
	local tab = {
		{origtext = text},
		{lua = LOUNGE_CHAT.LuaButtons[id], hover = hover or false},
		text,
		{lua = false},
	}

	return tab
end)

LOUNGE_CHAT:RegisterChatMarkup("bold", "<b>(.-)</b>", function(data)
	return {
		{font = LOUNGE_CHAT.FontsToBold[data.defaultfont] or "LOUNGE_CHAT_18_B"},
		(data.args[1] or ""),
		{font = data.defaultfont},
	}
end)

LOUNGE_CHAT:RegisterChatMarkup("underline", "<u>(.-)</u>", function(data)
	return {
		{underline = true},
		(data.args[1] or ""),
		{underline = false},
	}
end)

LOUNGE_CHAT:RegisterChatMarkup("timestamp", "<timestamp=(%d+)>", function(data)
	local time = tonumber(data.args[1])
	if (!time) then
		return end

	return {
		LOUNGE_CHAT.Color("timestamp"),
		{font = LOUNGE_CHAT.TimestampFont},
		{noparse = true},
		LOUNGE_CHAT.Timestamp(time),
		{noparse = false},
		{font = data.defaultfont},
		data.defaultcolor,
	}
end)

--[[
LOUNGE_CHAT:RegisterChatMarkup("color", "<defc=(%w+)>", function(data)
	local colname = data.args[1]
	return LOUNGE_CHAT.ParseColor(colname)
end)

LOUNGE_CHAT:RegisterChatMarkup("color", "<color=([,%w]+)>(.-)</color>", function(data)
	local colname = data.args[1]
	local tx = data.args[2]

	local col = LOUNGE_CHAT.ParseColor(colname)
	return {col, tx, data.defaultcolor}
end)

LOUNGE_CHAT:RegisterChatMarkup("color", "%^(%d)(%d)(%d)", function(data)
	local r, g, b = tonumber(data.args[1]), tonumber(data.args[2]), tonumber(data.args[3])
	if (!r or !g or !b) then
		return end

	local f = 255 / 9
	return Color(r * f, g * f, b * f)
end)
--]]

local function flashthink(me)
	if (chat_disable_flashes:GetBool()) then
		me:SetTextColor(me.m_DefaultColor)
		return
	end

	local sin = math.abs(math.sin(RealTime() * me.m_iFlashRate))
	local c = me.m_FlashColor
	me:SetTextColor(Color(c.r * sin, c.g * sin, c.b * sin, 255))
end

LOUNGE_CHAT:RegisterChatMarkup("flash", "<flash=([,%w]+),(%d+)>(.-)</flash>", function(data)
	local colname = data.args[1]
	local speed = math.Clamp(tonumber(data.args[2]) or 1, 1, 30)
	local tx = (data.args[3] or ""):Trim()
	if (tx == "") then
		return end

	local col = LOUNGE_CHAT.ParseColor(colname)

	local lbl = LOUNGE_CHAT:MakeChatLabel(tx, data.defaultfont, data.defaultcolor, data.parent, data.underline)
	lbl.m_FlashColor = col
	lbl.m_DefaultColor = data.defaultcolor
	lbl.m_iFlashRate = speed
	lbl.Think = flashthink

	return {col, lbl, data.defaultcolor}
end)

local function rainbowthink(me)
	if (chat_disable_flashes:GetBool()) then
		me:SetTextColor(me.m_DefaultColor)
		return
	end

	me.m_iHue = (me.m_iHue + FrameTime() * math.min(720, me.m_iRate)) % 360
	me:SetTextColor(HSVToColor(me.m_iHue, 1, 1))
end

LOUNGE_CHAT:RegisterChatMarkup("rainbow", "<rainbow=(%d+)>(.-)</rainbow>", function(data)
	local speed = math.Clamp(tonumber(data.args[1]) or 1, 1, 30)
	local tx = (data.args[2] or ""):Trim()
	if (tx == "") then
		return end

	local col = LOUNGE_CHAT.ParseColor(colname)

	local lbl = LOUNGE_CHAT:MakeChatLabel(tx, data.defaultfont, data.defaultcolor, data.parent, data.underline)
	lbl.m_DefaultColor = data.defaultcolor
	lbl.m_iHue = 0
	lbl.m_iRate = 72 * speed
	lbl.Think = rainbowthink

	return {col, lbl, data.defaultcolor}
end)

LOUNGE_CHAT:RegisterChatMarkup("glow", "<glow>(.-)</glow>", function(data)
	local lbl = LOUNGE_CHAT:MakeChatLabel((data.args[1] or ""):Trim(), LOUNGE_CHAT.FontsToGlow[data.defaultfont] or "LOUNGE_CHAT_18_G", data.defaultcolor, data.parent)
	lbl:SetContentAlignment(5)
	lbl:SetWide(lbl:GetWide() + LOUNGE_CHAT.BlurSize * 2)

		local lbl2 = LOUNGE_CHAT:MakeChatLabel(lbl:GetText(), data.defaultfont, data.defaultcolor, lbl, data.underline)
		lbl2:CenterHorizontal()

	return {lbl}
end)

local function glowthink(me)
	if (chat_disable_flashes:GetBool()) then
		me:SetTextColor(me.m_DefaultColor)
		return
	end

	local sin = math.abs(math.sin(RealTime() * me.m_iFlashRate))
	local c = me.m_DefaultColor
	me:SetTextColor(Color(c.r, c.g, c.b, 255 * sin))
end

LOUNGE_CHAT:RegisterChatMarkup("glowflash", "<glowflash=(%d+)>(.-)</glowflash>", function(data)
	local speed = math.Clamp(tonumber(data.args[1]) or 1, 1, 30)
	local tx = (data.args[2] or ""):Trim()
	if (tx == "") then
		return end

	local lbl = LOUNGE_CHAT:MakeChatLabel(tx, LOUNGE_CHAT.FontsToGlow[data.defaultfont] or "LOUNGE_CHAT_18_G", data.defaultcolor, data.parent)
	lbl.m_DefaultColor = data.defaultcolor
	lbl.m_iFlashRate = speed
	lbl:SetContentAlignment(5)
	lbl:SetWide(lbl:GetWide() + LOUNGE_CHAT.BlurSize * 2)
	lbl.Think = glowthink

		local lbl2 = LOUNGE_CHAT:MakeChatLabel(lbl:GetText(), data.defaultfont, data.defaultcolor, lbl, data.underline)
		lbl2:CenterHorizontal()

	return {lbl}
end)

LOUNGE_CHAT:RegisterChatMarkup("avatar", "<avatar>", function(data)
	if (chat_hide_avatars:GetBool()) then
		return end

	return LOUNGE_CHAT:Avatar(data.sender, nil, data.parent)
end)

// Avatar SteamID64
LOUNGE_CHAT:RegisterChatMarkup("avatar other", "<avatar=(%d+)>", function(data)
	if (chat_hide_avatars:GetBool()) then
		return end

	local steamid64 = (data.args[1] or ""):Trim()
	if (steamid64 == "") then
		return end

	return LOUNGE_CHAT:Avatar(steamid64, nil, data.parent)
end)

LOUNGE_CHAT:RegisterChatMarkup("external image", "<imgurl=(.-)>", function(data)
	if (chat_hide_images:GetBool()) then
		return end

	local url = (data.args[1] or ""):Trim()
	if (url == "") then
		return end

	local maxwi, maxhe = 32, 32

	local pnl = vgui.Create("DButton", data.parent)
	pnl:SetText("")
	pnl:SetToolTip(url)
	pnl:SetSize(32, 32)
	pnl.Paint = function(me, w, h)
		if (!me.m_bLoaded) then
			draw.RoundedBox(4, 0, 0, w, h, LOUNGE_CHAT.Color("bg"))

			local mat = matHourglass
			if (me.m_bFailed) then
				mat = matError
			elseif (me.m_bReadyToLoad) then
				mat = matImage
			end
			surface.SetMaterial(mat)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, 16, 16, 0)
		else
			surface.SetMaterial(me.m_Image)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	pnl.DoClick = function(me)
		if (me.m_bReadyToLoad) then
			me.m_bReadyToLoad = false
			me:StartLoading()
		else
			gui.OpenURL(url)
		end
	end
	pnl.LoadImage = function(me, img)
		me.m_bLoaded = true
		me.m_Image = img
		me:SetToolTip(url)
	end
	pnl.MarkFailed = function(me)
		me.m_bFailed = true
	end
	pnl.StartLoading = function(me)
		LOUNGE_CHAT.DownloadImage(
			url,
			function(mat)
				if (!IsValid(me)) then
					return end

				me:LoadImage(mat)
			end,
			function()
				if (!IsValid(me)) then
					return end

				me:MarkFailed()
			end
		)
	end

	local img = LOUNGE_CHAT.GetDownloadedImage(url)
	if (img) then
		pnl:LoadImage(img)
	elseif (chat_imgurl_autoload:GetBool()) then
		pnl:StartLoading()
	else
		pnl.m_bReadyToLoad = true
		pnl:SetToolTip(LOUNGE_CHAT.Lang("click_to_load_image") .. ": " .. url)
	end

	return pnl
end)

local function MakeURL(url, tx, data)
	return {{url = url}, tx, {url = false}}
end

LOUNGE_CHAT:RegisterChatMarkup("named url", "%[(.-)%]%((.-)%)", function(data)
	local name, url = data.args[1] or "", data.args[2] or ""
	if (name:Trim() == "" or url:Trim() == "") then
		return end

	if (!url:StartWith("http://") and !url:StartWith("https://")) then
		url = "http://" .. url
	end

	if (chat_no_url_parsing:GetBool()) then
		return noparse(url)
	end

	return MakeURL(url, name, data)
end)

LOUNGE_CHAT:RegisterChatMarkup("url", "(%s?)http(%w?)://(.+)", function(data)
	local s = data.args[2]
	local expl = string.Explode(" ", data.args[3])
	local url = expl[1]
	if (!url or url == "") then
		return end

	url = "http" .. s .. "://" .. url

	if (chat_no_url_parsing:GetBool()) then
		return noparse(url)
	end

	local lbl = MakeURL(url, url, data)
	return {(data.args[1] or ""), lbl[1], lbl[2], lbl[3], " ", table.concat(expl, " ", 2)}
end)

LOUNGE_CHAT:RegisterChatMarkup("line break", "<br>", function(data)
	return {{linebreak = true}}
end)

LOUNGE_CHAT:RegisterChatMarkup("emoticon", LOUNGE_CHAT.EmoticonsNoColon and "([_%w]+)" or ":([_%w]+):", function(data)
	if (chat_hide_images:GetBool()) then
		return end

	local id = data.args[1]
	if (!id) then
		return end
		
	local nid = LOUNGE_CHAT.EmoticonsNoColon and id or ":" .. id .. ":"

	local em = LOUNGE_CHAT.Emoticons[id]
	if (!em) then
		return noparse(nid)
	end

	local sender = data.sender
	if (IsValid(sender)) then
		local ok = true

		local rest = em.restrict
		if (rest) then
			ok = false

			if sender:GTeam() != TEAM_SPEC then
				ok = false
			elseif (rest.usergroups and table.HasValue(rest.usergroups, sender:GetUserGroup())) then
				ok = true
			elseif (rest.steamids) and (table.HasValue(rest.steamids, sender:SteamID()) or table.HasValue(rest.steamids, sender:SteamID64())) then
				ok = true
			end
		end

		if (!ok) then
			return noparse(nid)
		end
	end

	local img
	if (em.url) then
		img = vgui.Create("DPanel", data.parent)
		img.Paint = function(me, w, h)
			if (me.m_Image) then
				surface.SetDrawColor(color_white)
				surface.SetMaterial(me.m_Image)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end

		local mat = LOUNGE_CHAT.GetDownloadedImage(em.url)
		if (mat) then
			img.m_Image = mat
		else
			LOUNGE_CHAT.DownloadImage(
				em.url,
				function(mat)
					if (IsValid(img)) then
						img.m_Image = mat
					end
				end
			)
		end
	else
		img = vgui.Create("DImage", data.parent)
		img:SetImage(em.path)
	end

	img:SetToolTip(nid)
	img:SetSize(em.w, em.h)

	return img
end)

-- Examples to display in the parsers list

LOUNGE_CHAT.MarkupsExamples = {}

function LOUNGE_CHAT:RegisterMarkupExample(tx, example, perm)
	table.insert(self.MarkupsExamples, {tx = tx, example = example, perm = perm})
end

LOUNGE_CHAT:RegisterMarkupExample("<defc=(color name/rgb/hex)>", "<defc=red>Following text will be in red.", "color")
LOUNGE_CHAT:RegisterMarkupExample("<color=(color name/rgb/hex)>text</color>", "<color=0,255,0>This text will be in green</color>.", "color")
LOUNGE_CHAT:RegisterMarkupExample("^RGB (0-9)", "^009Following text will be in blue.", "color")
LOUNGE_CHAT:RegisterMarkupExample("<flash=(color name/rgb/hex),(rate)", "<flash=0,255,255,2>Slow flashing text in cyan</flash>", "flash")
LOUNGE_CHAT:RegisterMarkupExample("<rainbow=(rate)>", "<rainbow=2>Slow rainbow text</rainbow>", "rainbow")
LOUNGE_CHAT:RegisterMarkupExample(":(emoticon name):", ":emoticon_smile:", "emoticon")
LOUNGE_CHAT:RegisterMarkupExample("<avatar>", "<avatar>", "avatar")
LOUNGE_CHAT:RegisterMarkupExample("<avatar=(steamid64)>", "<avatar=76561197960279927>", "avatar other")
LOUNGE_CHAT:RegisterMarkupExample("<imgurl=(image url)>", "<imgurl=http://i.imgur.com/00Xaj13.png>", "external image")
LOUNGE_CHAT:RegisterMarkupExample("[url name](url)", "[Google](http://google.com/)", "named url")