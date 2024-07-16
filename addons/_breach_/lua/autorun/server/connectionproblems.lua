util.AddNetworkString( "Checkingserverup" )

timer.Create( "Pingtimer", 1, 0, function()
    net.Start( "Checkingserverup" )
    net.Broadcast()
end)