local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Cinema"
MODULE.Name     = "Video Queued"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("PostVideoQueued", "videoqueued", function(vid, cinema)
		MODULE:LogPhrase("cinema_video_queued", GAS.Logging:FormatPlayer(vid:GetOwner()), GAS.Logging:Highlight(vid:Title()), GAS.Logging:Highlight(cinema:Name()))
	end)
end)

GAS.Logging:AddModule(MODULE)
