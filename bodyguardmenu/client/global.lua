-- Arrays/Vars
local bodyguards = {} -- Array of bodyguards
local size = 0

-- Functions

function createbody(model) -- Function to create the ped
	if size < 7 then
		existsInTable = false
		RequestModel(model)
		while not HasModelLoaded(model) do
		  Citizen.Wait(1)
		end
		ploc = GetEntityCoords(PlayerPedId())
		ped = CreatePed(3, model, ploc.x+2, ploc.y+2, ploc.z, GetEntityHeading(PlayerPedId()), true, true)
		pgroup = GetPlayerGroup(PlayerId())
		SetPedAsGroupLeader(PlayerPedId(), pgroup)
		SetPedAsGroupMember(ped, pgroup)
		SetGroupFormation(pgroup, 1 - 1)
		SetGroupSeparationRange(pgroup, 999999.9)
		SetPedNeverLeavesGroup(ped, true)
		SetPedFleeAttributes(ped, 0, 0)
		SetEntityInvincible(ped, Config.godmode)
		SetPedCanBeTargetted(ped, false)
		TaskCombatHatedTargetsAroundPed(ped, 20, 0)
		SetPedDropsWeaponsWhenDead(ped, false)
		SetModelAsNoLongerNeeded(model)
		id = NetworkGetNetworkIdFromEntity(ped)
		bodybip = AddBlipForEntity(ped)
		SetBlipSprite(bodybip, Config.blip)
		SetBlipColour(bodybip, Config.color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Body Guard")
		EndTextCommandSetBlipName(bodybip)
		for k, v in pairs(bodyguards) do
			if v == ped then
				existsInTable = true
			end
		end
		if not existsInTable then
			table.insert(bodyguards, ped)
		end
		ShowNotification('Bodyguard spawned.')
	else
	ShowNotification('You have reached the max amount of bodyguards.')
	end
end

function cloneped() -- Cloneyourself
	model = GetEntityModel(PlayerPedId())
	createbody(model)
end

function delguards() -- Function to remove the bodyguards
	pgroup = GetPlayerGroup(PlayerId())
	for k, v in pairs(bodyguards) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
			RemoveGroup(pgroup)
			bodyguards [k] = nil
			size = 0
			ShowNotification('All Bodyguards have been removed.')
        end
	end
end

function giveweap(model) -- Function to give weapons to the body guards
	for k, v in pairs(bodyguards) do
        if DoesEntityExist(v) then
			GiveWeaponToPed(v, model, 9000, true, true)
			ShowNotification('Weapon added.')
        end
	end
end

function removeweap() -- Function to remove weapons from the bodyguards
	for k, v in pairs(bodyguards) do
        if DoesEntityExist(v) then
			RemoveAllPedWeapons(v)
			ShowNotification('Weapon/s removed.')
        end
	end
end

function ShowNotification(text) -- Function to send notifications
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- Threads

Citizen.CreateThread(function() --Bodyguard Teleport
	while true do
		Citizen.Wait(0)
		ploc = GetEntityCoords(PlayerPedId())
		playerPedPos = GetEntityCoords(GetPlayerPed(-1), true)
		GroupHandle = GetPlayerGroup(PlayerId())
		for k, v in pairs(bodyguards) do
			if DoesEntityExist(v) then
				bodyloc = GetEntityCoords(v, true)
				if (Vdist(ploc.x, ploc.y, ploc.z, bodyloc.x, bodyloc.y, bodyloc.z) >= 50) then
					SetEntityCoords(v, ploc.x+2, ploc.y+2, ploc.z, false, false, false, true)
					SetEntityVisible(v, true, 0)
				end
			end
		end
		_menuPool:ProcessMenus()
        if IsControlJustPressed(1, 170) then
            mainMenu:Visible(not mainMenu:Visible())
        end
		for k, v in pairs(bodyguards) do 
			size = k
		end	
		--print(size)
		
	end
end)
