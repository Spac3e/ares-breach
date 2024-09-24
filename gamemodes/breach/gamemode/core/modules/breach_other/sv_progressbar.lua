local mply = FindMetaTable("Player")
util.AddNetworkString("StartBreachProgressBar")
util.AddNetworkString("progressbarstate")

function mply:BrProgressBar( name, time, icon, target, canmove, finishcallback, startcallback, stopcallback )
	if istable(self.ProgressBarData) and self.ProgressBarData.name == name then 
        return 
    end
    
    local timername = "BREACH_ProgressBar"..self:SteamID64()
    if timer.Exists(timername) then 
        timer.Remove(timername) 
    end

    if canmove == nil then 
        canmove = true 
    end

    self.ProgressBarData = {
    	name = name,
        target = target,
        canmove = canmove,
        stopcallback = stopcallback,
    }
    
	net.Start( "StartBreachProgressBar" )
	    net.WriteString( name )
		net.WriteFloat( time )
		net.WriteString( icon )
	net.Send( self )

    if isfunction(startcallback) then 
        startcallback()
    end

    timer.Create(timername, time, 1, function()
        if isfunction(finishcallback) then
            finishcallback()
        end
        self.ProgressBarData = nil
    end)
end

function mply:BrStopProgressBar()
    self.PressedUse = false
    self:ConCommand("stopprogress")

    if self.ProgressBarData and isfunction(self.ProgressBarData.stopcallback) then
        self.ProgressBarData.stopcallback()
    end

    self.ProgressBarData = nil

    timer.Remove("BREACH_ProgressBar"..self:SteamID64())
end

local BREACH_DISTANCEREACH = 150

hook.Add("PlayerTick", "BREACH_ProgressBarCheck", function( ply )
    if not ply.ProgressBarData then
        return 
    end

    if not ply.ProgressBarData.canmove then
        if ply:GetVelocity():LengthSqr() > 0.0625 then
            ply:BrStopProgressBar()
        end
    end

    if ply.ProgressBarData and IsValid(ply.ProgressBarData.target) then
        local dist = BREACH_DISTANCEREACH * BREACH_DISTANCEREACH

        if not ( ply:GetEyeTrace().Entity == ply.ProgressBarData.target ) or ply.ProgressBarData.target:GetPos():DistToSqr(ply:GetPos()) > dist then
            -- or (IsValid(ply.ProgressBarData.target) and ply.ProgressBarData.target:GetPos():DistToSqr(ply:GetPos()) < dist) then
            ply:BrStopProgressBar()
        end
    end

    if ply:GTeam() == TEAM_SPEC or not ply:Alive() then 
        ply:BrStopProgressBar() 
    end
end)