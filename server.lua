local Core = exports['core']:GetCoreObject()

function doesweaponexist(weapon)
	for i = 1,#Config.Weapons do
		if Config.Weapons[i].weapon == weapon then
			return Config.Weapons[i]
		end
	end
	return nil
end

RegisterNetEvent("gunCatalogue:Purchase", function(data)
	local src = source
	local Player = Core.Functions.GetPlayer(src)
	local cash = Player.PlayerData.money.cash
	local cost = tonumber(data.cost)
	local weaponData = doesweaponexist(data.weapon)
	if weaponData then
		if tonumber(data.isammo) ~= 1 then
			if cash >= cost then
				if Player.Functions.AddItem(weaponData.weapon, 1) then
					TriggerClientEvent('core:client:TopNotification', src, 'Purchased', 5000, weaponData.label..' for $'.. cost)
					Player.Functions.RemoveMoney("cash", cost, "Gun Store: Weapons")
				end
			else
				TriggerClientEvent('core:client:TopNotification', src, 'No Service', 5000, 'You do not have enough money to buy this weapon')
			end
		else
			local Ammocost = (data.isammo * data.cost)
			if cash >= Ammocost then
				if Player.Functions.AddItem(weaponData.ammohash, 1) then
					TriggerClientEvent('core:client:TopNotification', src, 'Purchased', 5000, weaponData.ammolabel..' for $'..Ammocost)
					Player.Functions.RemoveMoney("cash", Ammocost, "Gun Store: Ammo")
				end
			else
				TriggerClientEvent('core:client:TopNotification', src, 'No Service', 5000, 'You do not have enough money to buy this ammo')
			end
		end
	end
end)