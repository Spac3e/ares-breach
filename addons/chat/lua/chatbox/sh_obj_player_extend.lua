--[[


addons/[chat]_sh_lounge_chatbox/lua/chatbox/sh_obj_player_extend.lua

--]]

local meta = FindMetaTable("Player")

-- who overrides this?
meta.IsTyping = meta.OldIsTyping or meta.IsTyping

function meta:IsTyping()
	return self:GetNWBool("LOUNGE_CHAT.Typing")
end