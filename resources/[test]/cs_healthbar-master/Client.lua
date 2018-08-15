Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
     local ped = GetPlayerPed(-1)
     local health = GetEntityHealth(ped)
     local armor = GetPedArmour(ped)
     SendNUIMessage({
     	heal = health,
     	armor = armor
     });
	--SendNUIMessage({heal,})
  end
end)
 GetPedNearbyVehicles()

GetPedNearbyPeds()