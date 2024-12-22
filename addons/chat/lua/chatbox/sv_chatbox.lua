/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

util.AddNetworkString("LOUNGE_CHAT.Typing")
util.AddNetworkString("LOUNGE_CHAT.TTTRadio")

net.Receive("LOUNGE_CHAT.Typing", function(len, ply)
	ply:SetNWBool("LOUNGE_CHAT.Typing", net.ReadBool())
end)

-- shitty override for a shitty gamemode
hook.Add("TTTPlayerRadioCommand", "LOUNGE_CHAT.TTTPlayerRadioCommand", function(ply, msg_name, msg_target)
	local name = ""

	local ent = msg_target
	if (IsValid(msg_target)) then
		if (ent:IsPlayer()) then
			name = ent:Nick()
		elseif (ent:GetClass() == "prop_ragdoll") then
			name = LANG.NameParam("quick_corpse_id")
			rag_name = CORPSE.GetPlayerNick(ent, "A Terrorist")
		end
	end

	net.Start("LOUNGE_CHAT.TTTRadio")
		net.WriteEntity(ply)
		net.WriteString(msg_name)
		net.WriteString(name)
		if (rag_name) then
			net.WriteString(rag_name)
		end
	net.Broadcast()

	return true
end)