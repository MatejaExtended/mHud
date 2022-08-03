ESX = nil
local lastJob = nil


Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
  Citizen.Wait(3000)
    if PlayerData == nil or PlayerData.job == nil then
	  	PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  SetRadarBigmapEnabled(false, false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local isMenuPaused = false

function menuPaused()
	SendNUIMessage({
		action = 'disableHud',
		data = isMenuPaused
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		ESX.TriggerServerCallback('mHud:TakeAccounts', function(data)
			SendNUIMessage({
				action = 'setMoney',
				cash = data.cash,
				bank = data.bank,
				black_money = data.black_money,
			})
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(800)
		if(PlayerData ~= nil) then
			local jobName = PlayerData.job.label
			if(lastJob ~= jobName) then
				lastJob = jobName
				SendNUIMessage({
					action = 'setJob',
					data = jobName
				})
			end
		end
	end
end)

local Hide = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if not Hide then

			if IsPauseMenuActive() then
				if not isMenuPaused then
					isMenuPaused = true
					menuPaused()
				end
			elseif isMenuPaused then
				isMenuPaused = false
				menuPaused()
			end

		else
			Wait(1000)
		end
	end
end)

local isMenuPaused2 = false

function menuPaused2()
	if isMenuPaused2 then
		DisplayRadar(true)
	else
		DisplayRadar(false)
	end
end

local Hide2 = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if not Hide2 then

			if IsPauseMenuActive() then
				if not isMenuPaused2 then
					isMenuPaused2 = true
					menuPaused2()
				end
			elseif isMenuPaused2 then
				isMenuPaused2 = false
				menuPaused2()
			end

		else
			Wait(1000)
		end
	end
end)

exports("info", function()

	if state and (state == true or state == false) then 
		Hide = state
		isMenuPaused = state
	else
		Hide = not Hide
		isMenuPaused = not isMenuPaused
	end

	menuPaused()
end)

local HideAll = false

RegisterCommand(Config.HideHudCommand, function(source, args)
	local type = args[1]

	if not type then
		HideAll = not HideAll
		exports.mHud:info(HideAll)
	else

		if type == "info" then
			exports.mHud:info()
		end

	end
end)