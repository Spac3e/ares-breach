local MODULE = GAS.Logging:MODULE()

MODULE.Category = "TTT"
MODULE.Name     = "Karma Kicking"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	GAS.Logging:InferiorHook("TTTKarmaLow", "tttkarmakick", function(ply)
		MODULE:LogPhrase("ttt_karma", GAS.Logging:FormatPlayer(ply))
	end)
end)

GAS.Logging:AddModule(MODULE)
