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

ESX.RegisterServerCallback("esx_school:learn", function(source, cb, skill_name, skill_points)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
		if result == nil or #result == 0 then return end
		local user = result[1]

		local skills, correct_skill
		local previous_skill = false
		local skill_started_now = false

		if user.skill_experience ~= nil and #json.decode(user.skill_experience) > 0 then --has some skill in something
			skills = json.decode(user.skill_experience)
			for i=1, #skills, 1 do
				if(skills[i].skill_name == skill_name) then
					previous_skill = true
					skills[i].skill_points = skills[i].skill_points + skill_points
				end
			end
		elseif #json.decode(user.skill_experience) == 0 then -- this is the beginning of the users skill building
			skill_started_now = true
			skills = {{skill_name = skill_name, skill_points = skill_points}}
		end

		if not previous_skill and not skill_started_now then
			skills[#skills + 1] = {skill_name = skill_name, skill_points = skill_points}
		end

		MySQL.update('UPDATE users SET skill_experience = @skills WHERE identifier = @identifier', {
			['@skills'] = json.encode(skills),
			['@identifier'] = xPlayer.identifier
		})

		cb(true)
	end)
end)