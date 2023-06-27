ESX.RegisterServerCallback('esx_school:enroll', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 5000 then
		xPlayer.removeMoney(5000, "ULSA Enrollment")

		TriggerEvent('esx_license:addLicense', source, 'ULSA', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)