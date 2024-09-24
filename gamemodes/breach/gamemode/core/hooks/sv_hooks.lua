function GM:Initialize()
	SetGlobalInt("RoundUntilRestart", 15)
	Radio_RandomizeChannels()
end

function GM:PlayerShouldTaunt(ply)
	return ply:IsSuperAdmin()
end