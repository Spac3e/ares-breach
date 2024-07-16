local CrashReason = nil
local Registred = false
local HasCrashed = false
local LastPong = RealTime()

local clr_red = Color( 255, 0, 0 )
local clr_green = Color( 0, 255, 0 )

net.Receive( "Checkingserverup", function( len )
	if !IsValid(LocalPlayer()) then return end
	if LocalPlayer():GetNWBool("Player_IsPlaying") == false then return end

	LastPong = RealTime()
	
	if ( !Registred ) then
		Registred = true
		hook.Add( "Think", "CrashHook", function()
			if ( RealTime() - LastPong > 15 && !HasCrashed ) then
				OnCrash()
			end
		end )
	end
	
	if ( HasCrashed ) then
		HasCrashed = false
		BREACH.Player:ChatPrint( true, true, clr_green, "Соединение было восстановлено!" )
		LastCrash = RealTime()
	end
end)

function OnCrash()
	HasCrashed = true

	local messages = {
		{Text = {"Эй, ", LocalPlayer(), ", похоже соединение с сервером было ", clr_red, "потеряно.", color_white }, Delay = 6},
		{Text = "Не беспокойтесь, мы попытаемся автоматически переподключить Вас к игровому серверу.", Delay = 8},
		{Text = {"Я попробую присоединиться к серверу через ", Color(255, 255, 100), "15 секунд.", color_white }, Delay = 8},
		{Text = "Заметка: Если после подключения возникнет ошибка \"Bad Challenge\", то нужно попытаться зайти ещё раз, вероятнее всего сервер уже работает.", Delay = 6},
		{Text = "Присоединение через три секунды...", Delay = 3},
		{Delay = 5, Func = function() if ( HasCrashed ) then RunConsoleCommand( "retry" ) end end},
		{Text = "Что-то пошло не так, попробуйте ввести \"retry\" в игровую консоль самостоятельно.", Delay = 1, Func = function () hook.Remove( "Think", "CrashMessage" ) end},
	}
	
	local lastMessage = RealTime()
	local delay = -1
	local message = 1

	hook.Add( "Think", "CrashMessage", function()
		if ( ( RealTime() - lastMessage > delay ) && HasCrashed ) then
	
		local msg = messages[ message ]
	
		if ( istable( msg.Text ) ) then
			BREACH.Player:ChatPrint( true, true, unpack( msg.Text ) )
		elseif ( isstring( msg.Text ) ) then
			BREACH.Player:ChatPrint( true, true, msg.Text )
		elseif ( isfunction( msg.Text ) ) then
			BREACH.Player:ChatPrint( true, true, msg.Text() )
		end
	
		delay = msg.Delay
	
		if ( msg.Func ) then
			msg.Func()
		end
	
		message = message + 1
		lastMessage = RealTime()
		end
	end)
end