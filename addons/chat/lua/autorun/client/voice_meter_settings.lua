--[[


addons/[chat]_voicechatmeter/lua/autorun/client/voice_meter_settings.lua

--]]

--[[
addons/lua_crap/lua/autorun/client/voice_meter_settings.lua
--]]

/* ----------------------
  -- Script created by --
  ------- Jackool -------
  -- for CoderHire.com --
  -----------------------
  
  This product has lifetime support and updates.
  
  Having troubles? Contact Jackool at any time:
  http://steamcommunity.com/id/thejackool
*/

VoiceChatMeter = VoiceChatMeter || {}

VoiceChatMeter.IsTTT = false // SET THIS TO TRUE IF YOU ARE RUNNING A TTT SERVER!
// This will put the voice backgrounds in the top left.
// You could also customize it as much as you want below:

VoiceChatMeter.DarkRPSelfSquare = false // Do you want the voice chat indicator to show when you yourself talk (for DarkRP)

VoiceChatMeter.SizeX = 250 // The width for voice chat
VoiceChatMeter.SizeY = 40 // The height for voice chat
VoiceChatMeter.FontSize = 17 // The font size for player names on the voice chat
VoiceChatMeter.Radius = 4 // How round you want the voice chat square to be (0 = square)
VoiceChatMeter.FadeAm = .1 // How fast the voice chat square fades in and out. 1 = Instant, .01 = fade in really slow
VoiceChatMeter.SlideOut = true // Should the chat meter do a "slide out" animation
VoiceChatMeter.SlideTime = .1 // How much time it takes for voice chat box to "slide out" (if above is on)

// A bit more advanced options
VoiceChatMeter.PosX = .97 // The position based on your screen width for voice chat box. Choose between 0 and 1
VoiceChatMeter.PosY = .76 // The position based on screen height for the voice chat box. Choose between 0 and 1
VoiceChatMeter.Align = 0 // How should the voice chat align? For align right, choose 0. For align left, choose 1
VoiceChatMeter.StackUp = true // If more people up, should the voice chat boxes go upwards?

VoiceChatMeter.UseTags = true // Should we use tags? This will put [SA] or [A] infront of superadmins/admins. Remember commas!
VoiceChatMeter.Tags = {
	--[[
	["superadmin"] = "[RXTEAM]",
	["spectator"] = "[Warden]",
	["admin"] = "[Admin]",
	["premium"] = "[Premium]"]]
}

// Autoset positioning if IsTTT is true. Don't edit this unless you really need to.
if (VoiceChatMeter.IsTTT) then
	VoiceChatMeter.SizeX = 220
	VoiceChatMeter.SizeY = 40
	VoiceChatMeter.PosX = .02
	VoiceChatMeter.PosY = .03
	VoiceChatMeter.Align = 1
	VoiceChatMeter.StackUp = false
end

include("voicemeter/cl_voice_meter.lua")

