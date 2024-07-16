local MODULE = GAS.Logging:MODULE()

MODULE.Category = "DarkRP"
MODULE.Name     = "Lottery"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("lotteryStarted", "lotteryStarted", function(ply, price)
		MODULE:LogPhrase("darkrp_lottery_started", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatMoney(price))
	end)
	MODULE:Hook("lotteryEnded", "lotteryEnded", function(_, winner, amnt)
		MODULE:LogPhrase("darkrp_lottery_ended", GAS.Logging:FormatPlayer(winner), GAS.Logging:FormatMoney(amnt))
	end)
end)

GAS.Logging:AddModule(MODULE)
