--[[


addons/[chat]_sh_lounge_chatbox/lua/chatbox_emoticons.lua

--]]

/**
* Derma Emoticons 
**/

-- Enable Derma emoticons?
-- You can see the full list here: http://www.famfamfam.com/lab/icons/silk/previews/index_abc.png
LOUNGE_CHAT.EnableDermaEmoticons = true

-- Restrict Derma emoticons?
-- You can configure the restrictions in the "DermaEmoticonsRestrictions" option.
-- "false" means derma emoticons can be used by anyone.
LOUNGE_CHAT.RestrictDermaEmoticons = true

-- Here you can decide on restrictions for players to be able to use Derma emoticons in their messages.
-- Only works if the "RestrictDermaEmoticons" option is set to true
LOUNGE_CHAT.DermaEmoticonsRestrictions = {
	-- This means only admins, superadmins and players with the specific SteamID/SteamID64 can use Derma emoticons.
	usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
	--steamids = {"STEAM_0:1:8039869", "76561197976345467"}
}

/**
* Custom Emoticons 
**/

-- Add your custom emoticons here!
-- Two examples are provided for you to copy.
LOUNGE_CHAT.CustomEmoticons = {
	-- This creates a "grin" emoticon with the material "vgui/face/grin"
	["breachisreal3"] = {
		url = "https://i.imgur.com/CkNwlxh.png",
		w = 70/1.6,
		h = 112/1.6,
	},
	["breachisreal2"] = {
		url = "https://i.imgur.com/WxL74l6.png",
		w = 192/2,
		h = 108/2,
	},
	["breachisreal"] = {
		url = "https://i.imgur.com/iwwCuCf.png",
		w = 44,
		h = 62,
	},
	["yeet"] = {
		url = "https://i.imgur.com/6ojDGvL.png",
		w = 22,
		h = 22,
	},
	["grin"] = {
		path = "vgui/face/grin",
		w = 64,
		h = 32,
	},

	-- This creates a "awesomeface" emoticon with the URL "http://i.imgur.com/YBUpyZg.png"
	["awesomeface"] = {
		url = "http://i.imgur.com/YBUpyZg.png",
		w = 32,
		h = 32,
	},

	// FA emoticons
	["kami"] = {
		url = "https://vgy.me/pzfz8k.png",
		w = 32,
		h = 32,
	},
	["kosmugi"] = {
		url = "http://i.imgur.com/fWxbVLv.png",
		w = 32,
		h = 32,
	},
	["chaika"] = {
		url = "http://i.imgur.com/h25fTDE.png",
		w = 32,
		h = 32,
	},
	["thatcat"] = {
		url = "http://i.imgur.com/00Xaj13.png",
		w = 32,
		h = 32,
	},
	["nerdbob"] = {
		url = "https://i.imgur.com/OQD4cnF.jpg",
		w = 32,
		h = 32,
	},
	["glaze"] = {
		url = "https://i.imgur.com/ckrw1pj.png",
		w = 32,
		h = 32
	},
	["begotten"] = {
		url = "https://i.imgur.com/PGue00w.png",
		w = 32,
		h = 32
	},
	["fuckfuckfuck"] = {
		url = "https://i.imgur.com/NWQqxLC.png",
		w = 32,
		h = 32
	},
	["fuckerjoe"] = {
		url = "https://i.imgur.com/1JvZNJg.png",
		w = 32,
		h = 32
	},
	["holyhierarchy"] = {
		url = "https://i.imgur.com/N4Ml1UY.png",
		w = 32,
		h = 32
	},
	["rjomba"] = {
		url = "https://i.imgur.com/j2uUb4h.jpg",
		w = 32,
		h = 32,
	},
	["bogdan"] = {
		url = "https://i.imgur.com/oUtCJ48.png",
		w = 50,
		h = 55,
	},
	["vanya1"] = {
		url = "https://i.imgur.com/MQvth85.jpg",
		w = 50,
		h = 55,
	},
	["vanya2"] = {
		url = "https://i.imgur.com/HHyvUqy.png",
		w = 42,
		h = 42
	},
	["umoritelno"] = {
		url = "https://i.imgur.com/NAo3Zrt.png",
		w = 32,
		h = 32,
	},
	["solyanka"] = {
		url = "https://i.imgur.com/PBuQSgU.png",
		w = 50,
		h = 42,
	},
	["jasonluv"] = {
		url = "https://i.imgur.com/2N5rEUU.png",
		w = 45,
		h = 45,
	},
	["dreamybull"] = {
		url = "https://i.imgur.com/1f0AtKn.png",
		w = 45,
		h = 45,
	},
	["durakonline"] = {
		url = "https://i.imgur.com/on7oX1e.png",
		w = 64,
		h = 64,
	},
}

-- Here you can decide whether an emoticon can only be used by a specific usergroup/SteamID
LOUNGE_CHAT.EmoticonRestriction = {
	-- This restricts the "awesomeface" emoticon so that it can only be used by:
	-- * "admin" and "superadmin" usergroups
	-- * players with the SteamID "STEAM_0:1:8039869" or SteamID64 "76561197976345467"
	["awesomeface"] = {
		usergroups = {"headadmin", "superadmin", "spectator", "admin", "premium"},
		--steamids = {"STEAM_0:1:8039869", "76561197976345467"}
	},
}

/**
* End of configuration
**/

LOUNGE_CHAT.Emoticons = {}

function LOUNGE_CHAT:RegisterEmoticon(id, path, url, w, h, restrict)
	self.Emoticons[id] = {
		path = path,
		url = url,
		w = w or 16,
		h = h or 16,
		restrict = restrict,
	}
end

if (LOUNGE_CHAT.EnableDermaEmoticons) then
	local fil = file.Find("materials/icon16/*.png", "GAME")
	for _, f in pairs (fil) do
		local restrict
		if (LOUNGE_CHAT.RestrictDermaEmoticons) then
			restrict = LOUNGE_CHAT.DermaEmoticonsRestrictions
		end

		LOUNGE_CHAT:RegisterEmoticon(string.StripExtension(f), "icon16/" .. f, nil, 16, 16, restrict)
	end
end

for id, em in pairs (LOUNGE_CHAT.CustomEmoticons) do
	LOUNGE_CHAT:RegisterEmoticon(id, em.path, em.url, em.w, em.h, LOUNGE_CHAT.EmoticonRestriction[id])
end