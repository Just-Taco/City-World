HT = {}
HT.Game = {}
HT.ServerCallbacks = {}
HT.CurrentRequestId = 0
HT.PlayerData      = {}
HT.UI = {}
HT.UI.Menu = {}
HT.UI.Menu.RegisteredTypes = {}
HT.UI.Menu.Opened = {}

HT.TimeoutCallbacks = {}

HT.Math = {}

HT.Streaming = {}

HT.Game.Utils = {}

HT.Game.GetPedMugshot = function(ped)
	local mugshot = RegisterPedheadshot(ped)
	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end
	return mugshot, GetPedheadshotTxdString(mugshot)
end

HT.TriggerServerCallback = function(name, cb, ...)
	HT.ServerCallbacks[HT.CurrentRequestId] = cb

	TriggerServerEvent('HT:triggerServerCallback', name, HT.CurrentRequestId, ...)

	if HT.CurrentRequestId < 65535 then
		HT.CurrentRequestId = HT.CurrentRequestId + 1
	else
		HT.CurrentRequestId = 0
	end
end

HT.UI.Menu.RegisterType = function(type, open, close)
	HT.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

HT.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}
	menu.type = type
	menu.namespace = namespace
	menu.name = name
	menu.data = data
	menu.submit = submit
	menu.cancel = cancel
	menu.change = change
	menu.close = function()
		HT.UI.Menu.RegisteredTypes[type].close(namespace, name)
		for i = 1, #HT.UI.Menu.Opened, 1 do
			if HT.UI.Menu.Opened[i] ~= nil then
				if HT.UI.Menu.Opened[i].type == type and HT.UI.Menu.Opened[i].namespace == namespace and HT.UI.Menu.Opened[i].name == name then
					HT.UI.Menu.Opened[i] = nil
				end
			end
		end
		if close ~= nil then
			close()
		end
	end
	menu.update = function(query, newData)
		for i = 1, #menu.data.elements, 1 do
			local match = true
			for k, v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end
			if match then
				for k, v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end
	end
	menu.refresh = function()
		HT.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end
	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end
	menu.setTitle = function(val)
		menu.data.title = val
	end
	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end
	table.insert(HT.UI.Menu.Opened, menu)
	HT.UI.Menu.RegisteredTypes[type].open(namespace, name, data)
	return menu
end

HT.Game.GetClosestVehicle = function(coords)
	local vehicles        = HT.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

HT.UI.Menu.Close = function(type, namespace, name)
	for i = 1, #HT.UI.Menu.Opened, 1 do
		if HT.UI.Menu.Opened[i] ~= nil then
			if HT.UI.Menu.Opened[i].type == type and HT.UI.Menu.Opened[i].namespace == namespace and HT.UI.Menu.Opened[i].name == name then
				HT.UI.Menu.Opened[i].close()
				HT.UI.Menu.Opened[i] = nil
			end
		end
	end
end


HT.GetJob = function()
    HT.TriggerServerCallback('HT:JobCallback', function(data)
		return data
	end)
end

HT.UI.Menu.CloseAll = function()
	for i = 1, #HT.UI.Menu.Opened, 1 do
		if HT.UI.Menu.Opened[i] ~= nil then
			HT.UI.Menu.Opened[i].close()
			HT.UI.Menu.Opened[i] = nil
		end
	end
end

HT.UI.Menu.GetOpened = function(type, namespace, name)
	for i = 1, #HT.UI.Menu.Opened, 1 do
		if HT.UI.Menu.Opened[i] ~= nil then
			if HT.UI.Menu.Opened[i].type == type and HT.UI.Menu.Opened[i].namespace == namespace and HT.UI.Menu.Opened[i].name == name then
				return HT.UI.Menu.Opened[i]
			end
		end
	end
end

HT.UI.Menu.GetOpenedMenus = function()
	return HT.UI.Menu.Opened
end

HT.UI.Menu.IsOpen = function(type, namespace, name)
	return HT.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

HT.SetTimeout = function(msec, cb)
	table.insert(HT.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #HT.TimeoutCallbacks
end

HT.ClearTimeout = function(i)
	HT.TimeoutCallbacks[i] = nil
end

HT.Math.Round = function(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

HT.Math.GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())..right
end

HT.Math.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

HT.Game.Utils.DrawText3D = function(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords = GetGameplayCamCoords()
	local dist = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size = size
	if size == nil then
		size = 1
	end
	local scale = (size / dist) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(x, y)
	end
end

function HT.Streaming.RequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

HT.Game.GetPlayers = function()
	local players = {}
	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)
		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end
	return players
end

HT.Game.GetPlayersInArea = function(coords, area)
	local players = HT.Game.GetPlayers()
	local playersInArea = {}
	for i = 1, #players, 1 do
		local target = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end
	return playersInArea
end

HT.Game.GetObjects = function()
	local objects = {}
	for object in EnumerateObjects() do
		table.insert(objects, object)
	end
	return objects
end

HT.Game.GetClosestObject = function(filter, coords)
	local objects = HT.Game.GetObjects()
	local closestDistance = -1
	local closestObject = -1
	local filter = filter
	local coords = coords
	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end
	if coords == nil then
			local playerPed = PlayerPedId()
			coords = GetEntityCoords(playerPed)
		end
		for i = 1, #objects, 1 do
			local foundObject = false
			if filter == nil or (type(filter) == 'table' and #filter == 0) then
				foundObject = true
			else
				local objectModel = GetEntityModel(objects[i])
				for j = 1, #filter, 1 do
					if objectModel == GetHashKey(filter[j]) then
						foundObject = true
					end
				end
			end
			if foundObject then
				local objectCoords = GetEntityCoords(objects[i])
				local distance = GetDistanceBetweenCoords(objectCoords, coords.x, coords.y, coords.z, true)
				if closestDistance == -1 or closestDistance > distance then
					closestObject = objects[i]
					closestDistance = distance
				end
			end
		end
		return closestObject, closestDistance
	end

	function HT.Streaming.RequestModel(modelHash, cb)
		modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end
	if cb ~= nil then
		cb()
	end
end

HT.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))
	Citizen.CreateThread(function()
		HT.Streaming.RequestModel(model)
		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end
		SetVehRadioStation(vehicle, 'OFF')
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

HT.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		HT.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

HT.Game.DeleteVehicle = function(vehicle)
	SetEntityAsMissionEntity(vehicle, false, true)
	DeleteVehicle(vehicle)
end

function HT.Streaming.RequestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

HT.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

HT.Game.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		HT.Streaming.RequestModel(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

HT.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

RegisterNetEvent('HT:serverCallback')
AddEventHandler('HT:serverCallback', function(requestId, ...)
	HT.ServerCallbacks[requestId](...)
	HT.ServerCallbacks[requestId] = nil
end)

AddEventHandler('HT_base:getBaseObjects', function(cb)
	cb(HT)
end)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

HT.Game.GetVehicleProperties = function(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	local tyres = {}
	tyres[1] = {burst = IsVehicleTyreBurst(vehicle, 0, false), id = 0}
	tyres[2] = {burst = IsVehicleTyreBurst(vehicle, 1, false), id = 1}
	tyres[3] = {burst = IsVehicleTyreBurst(vehicle, 4, false), id = 4}
	tyres[4] = {burst = IsVehicleTyreBurst(vehicle, 5, false), id = 5}

	local doors = {}
	for i = 0, 5, 1 do
		doors[tostring(i)] = IsVehicleDoorDamaged(vehicle, i)
	end

	local windows = {}
	for i = 0, 5, 1 do
		windows[tostring(i)] = IsVehicleWindowIntact(vehicle, i)
	end

	return {

		model             = GetEntityModel(vehicle),

		plate             = HT.Math.Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		health            = GetEntityHealth(vehicle),
		dirtLevel         = GetVehicleDirtLevel(vehicle),

		color1            = color1,
		color2            = color2,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),
		modHeadlight 	  = GetVehicleHeadlightsColour(vehicle),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modTires 		  = GetVehicleModVariation(vehicle, 23),
		modLivery         = GetVehicleLivery(vehicle),
		engine 			  =	GetVehicleEngineHealth(vehicle),
		body 			  = GetVehicleBodyHealth(vehicle),
		tyres			  = tyres,
		doors			  = doors,
		windows 		  = windows
	}
end

HT.Game.GetVehiclesInArea = function(coords, area)
	local vehicles       = HT.Game.GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

HT.Game.SetVehicleProperties = function(vehicle, props)
	SetVehicleModKit(vehicle, 0)

	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	if props.health ~= nil then
		SetEntityHealth(vehicle, props.health)
	end

	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel)
	end

	if props.color1 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.pearlescentColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras ~= nil then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modHeadlight ~= nil then
		SetVehicleHeadlightsColour(vehicle, props.modHeadlight)
	end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modTires)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, props.modTires)
	end

	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end

	if props.engine ~= nil then
		if props.engine < 980 then
			if props.engine < 400 then 
				SetVehicleEngineHealth(vehicle, 400.0)
			else
				SetVehicleEngineHealth(vehicle, tonumber(props.engine))
			end
		end	
	end

	if props.body ~= nil then
		if props.body < 980 then
			if props.body < 400 then 
				SetVehicleBodyHealth(vehicle, 400.0)
			else
				SetVehicleBodyHealth(vehicle, tonumber(props.body))
			end
		end	
	end

	if props.tyres ~= nil then
		for i,tyre in pairs(props.tyres) do
			if tyre.burst then
				SetVehicleTyreBurst(vehicle, tyre.id, 0, 1000.0)
			end
		end
	end

	if props.doors ~= nil then
		for i,door in pairs(props.doors) do
			if door then
				SetVehicleDoorBroken(vehicle, tonumber(i), true)
			end
		end
	end

	if props.windows ~= nil then
		for i,window in pairs(props.windows) do
			if window == false then
				SmashVehicleWindow(vehicle, tonumber(i))
			end
		end
	end

end

HT.GetPlayerData = function()
	return HT.PlayerData
end

HT.SetPlayerData = function(key, val)
	HT.PlayerData[key] = val
end

HT.ShowNotification = function(msg)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end

HT.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    SetNotificationMessage(icon, icon, false, iconType, title, subject)
    DrawNotification(false, false)
end

HT.ShowHelpNotification = function(msg)
    --if not IsHelpMessageBeingDisplayed() then
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandDisplayHelp(0, false, true, -1)
    --end
end

HT.Game.GetClosestPlayer = function(coords)
	local players         = HT.Game.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

HT.HasGroup = function(perm)
	HT.TriggerServerCallback('vrp-hasgroup', function(ok)
	  if ok == true then
	  end
 end, perm)
	return true
end