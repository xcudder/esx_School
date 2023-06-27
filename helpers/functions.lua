function setupBlip(info)
	info.blip = AddBlipForCoord(info.x, info.y, info.z)
	SetBlipSprite(info.blip, info.id)
	SetBlipDisplay(info.blip, 4)
	SetBlipScale(info.blip, 0.9)
	SetBlipColour(info.blip, info.colour)
	SetBlipAsShortRange(info.blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(info.title)
	EndTextCommandSetBlipName(info.blip)
end
function entity_close_enough(second_entity, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = GetEntityCoords(GetPlayerPed(-1), false)
	local B = GetEntityCoords(second_entity, false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end
function coordinates_close_enough(B, overwrite_radius)
	if not overwrite_radius then overwrite_radius = 1.5 end
	local A = GetEntityCoords(GetPlayerPed(-1), false)
	return Vdist(B.x, B.y, B.z, A.x, A.y, A.z) < 1.5
end
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function DrawSimpleMarker(v3)
	DrawMarker(1, v3.x, v3.y, v3.z,0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
end
function DrawEntryMarker(v3)
	DrawMarker(0, v3.x, v3.y, v3.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 244, 244, 23, 100, true, true, 2, true, false, false, false)
end