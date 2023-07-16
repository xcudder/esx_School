local cfg = Config.school_coordinates
local PlayerData = {}
local last_class = -1

setupBlip({
	title="University of San Andreas, Los Santos", colour=1, id=685,
	x=cfg.x, y=cfg.y, z=cfg.z
})

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerData.enrolled = 'unknown'
	ESX.TriggerServerCallback('esx_license:checkLicense', function(isEnrolled)
		if isEnrolled then
			PlayerData.enrolled = true
		else
			PlayerData.enrolled = false
		end
	end, GetPlayerServerId(PlayerId()), 'ULSA')
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if PlayerData.enrolled ~= 'unkown' and not PlayerData.enrolled then
			DrawSimpleMarker(cfg)
			if coordinates_close_enough(cfg) then
				DisplayHelpText("Press ~INPUT_CONTEXT~ to pay 5k and enroll into ULSA")
				if(IsControlJustReleased(1, 38)) then
					enroll_player()
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if PlayerData.enrolled ~= 'unkown' and PlayerData.enrolled then
			classes_available('law', 'San Andreas Law')
			classes_available('electrical_engineering', 'Electrical Engineering')
			classes_available('information_technology', 'Computer Science')
		end
	end
end)

function classes_available(class_name, friendly_name)
	DrawEntryMarker(Config.class_locations[class_name])
	if coordinates_close_enough(Config.class_locations[class_name]) then
		DisplayHelpText("Press ~INPUT_CONTEXT~ to attend the " .. friendly_name .. " class")
		if(IsControlJustReleased(1, 38)) then
			begin_class(class_name)
		end
	end
end

function begin_class(class_name)
	if last_class == GetClockDayOfWeek() then
		ESX.ShowNotification("Classes are over for today")
		return
	end
	last_class = GetClockDayOfWeek()
	FreezeEntityPosition(PlayerPedId(), true)
	if class_name == 'electrical_engineering' then electrical_engineering_class(1) end
end

function electrical_engineering_class(recursive_count)
	local learned = false
	local class_result = -1

	if recursive_count > 10 then
		FreezeEntityPosition(PlayerPedId(), false)
		return
	end
	
	TriggerEvent('ultra-voltlab', 30, function(result, reason) class_result = result end)
	while class_result == -1 do Wait(100) end
	Wait(4000) -- Safely wait for voltlab exit animations

	if class_result ~= 1 then 
		FreezeEntityPosition(PlayerPedId(), false)
		return
	end

	ESX.TriggerServerCallback('esx_school:learn', function() learned = true end, 'electrical_engineering', 100)
	while not learned do Wait(100) end
	electrical_engineering_class(recursive_count + 1)
end



function enroll_player()
	ESX.TriggerServerCallback('esx_school:enroll', function (enrolled)
		if enrolled then
			PlayerData.enrolled = enrolled
			ESX.ShowNotification("Congratuliations! You're now an ULSA student")
		else
			ESX.ShowNotification("Come back when you get some money, buddy ^^")
		end
	end)
end

RegisterCommand('voltlab', function(source, args)
	TriggerEvent('ultra-voltlab', args[1], function(result,reason)
		if result == 0 then
			ESX.ShowNotification('Hack failed')
		elseif result == 1 then
			ESX.ShowNotification('Hack successful')
		elseif result == 2 then
			ESX.ShowNotification('Timed out')
		elseif result == -1 then
			ESX.ShowNotification('Error occured')
		end
	end)
end)