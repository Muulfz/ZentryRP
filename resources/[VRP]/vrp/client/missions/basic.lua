---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/7/2018 01:07
---


local lang = tvRP.clientlang

function tvRP.isPlayerInVehicleModel(model)
    if (IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey(model))) then -- just a function you can use to see if your player is in a taxi or any other car model (use the tunnel)
        return true
    else
        return false
    end
end

function tvRP.isInAnyVehicle()
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        return true
    else
        return false
    end
end

function tvRP.getVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

function tvRP.deleteVehicleByOffset(offset)
    local ped = GetPlayerPed(-1)
    veh = tvRP.getVehicleInDirection(GetEntityCoords(ped, 1), GetOffsetFromEntityInWorldCoords(ped, 0.0, offset, 0.0))

    if IsEntityAVehicle(veh) then
        SetVehicleHasBeenOwnedByPlayer(veh,false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, veh, false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
        tvRP.notify("~g~Vehicle deleted.")
    else
        tvRP.notify("~r~Too far away from vehicle.")
    end
end

function tvRP.deleteVehicleModelByOffset(model,offset)
    local ped = GetPlayerPed(-1)
    veh = tvRP.getVehicleInDirection(GetEntityCoords(ped, 1), GetOffsetFromEntityInWorldCoords(ped, 0.0, offset, 0.0))

    if IsEntityAVehicle(veh) and IsVehicleModel(veh, GetHashKey(model)) then
        SetVehicleHasBeenOwnedByPlayer(veh,false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, veh, false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
        tvRP.notify("~g~Vehicle deleted.")
    else
        tvRP.notify("~r~Too far away from vehicle.")
    end
end

-- Ped Types: Any ped = -1 | Player = 1 | Male = 4 | Female = 5 | Cop = 6 | Human = 26 | SWAT = 27 | Animal = 28 | Army = 29
function tvRP.isClosestPedType(radius, pedType)
    local outPed = {}
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local found = GetClosestPed(x+0.0001, y+0.0001, z+0.0001,radius+0.0001, 1, 0, outPed, 1, 1, pedType)
    if found then
        return true
    end
    return false
end

function tvRP.isClosestPedModel(radius, model)
    local outPed = {}
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local found = GetClosestPed(x+0.0001, y+0.0001, z+0.0001,radius+0.0001, 1, 0, outPed, 1, 1, -1)
    if found then
        if IsPedModel(outPed, GetHashKey(model)) then
            return true
        end
    end
    return false
end

function tvRP.freezePed(flag)
    FreezeEntityPosition(GetPlayerPed(-1),flag)
end

function tvRP.getPlayerName(player)
    return GetPlayerName(player)
end

function tvRP.freezePedVehicle(flag)
    FreezeEntityPosition(GetVehiclePedIsIn(GetPlayerPed(-1),false),flag)
end

function tvRP.deleteVehiclePedIsIn()
    local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    SetVehicleHasBeenOwnedByPlayer(v,false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
end

function tvRP.deleteNearestVehicle(radius)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local v = GetClosestVehicle( x+0.0001, y+0.0001, z+0.0001,radius+0.0001,0,70)
    SetVehicleHasBeenOwnedByPlayer(v,false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
end

function tvRP.deleteNearestVehicleModel(radius, model)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local v = GetClosestVehicle( x+0.0001, y+0.0001, z+0.0001,radius+0.0001,GetHashKey(model),70)
    if IsVehicleModel(v, GetHashKey(model)) then
        SetVehicleHasBeenOwnedByPlayer(v,false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
        return true
    else
        return false
    end
end

function tvRP.deleteTowedVehicleModel(offset,model)
    local player = GetPlayerPed( -1 )
    local pos = GetEntityCoords(player)
    local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, -offset, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, player, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
    if vehicleHandle ~= nil then
        if IsVehicleModel(vehicleHandle, GetHashKey(model)) then
            SetVehicleHasBeenOwnedByPlayer(vehicleHandle,false)
            Citizen.InvokeNative(0xAD738C3085FE7E11, vehicleHandle, false, true) -- set not as mission entity
            SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicleHandle))
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicleHandle))
            return true
        else
            return false
        end
    else
        return false
    end
end

function tvRP.deleteTowedVehicle(offset)
    local player = GetPlayerPed( -1 )
    local pos = GetEntityCoords(player)
    local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, -offset, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, player, 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
    if vehicleHandle ~= nil then
        SetVehicleHasBeenOwnedByPlayer(vehicleHandle,false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, vehicleHandle, false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicleHandle))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicleHandle))
        return true
    else
        return false
    end
end

function tvRP.getVehiclePedIsInPlateText()
    local p = ""
    local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    p = GetVehicleNumberPlateText(v)
    return p
end

function tvRP.isPedVehicleOwner()
    local r = true
    local v = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    GetVehicleOwner(v,function(o)
        if IsEntityAVehicle(o) then
            r = false
        end
    end)
    return r
end

function tvRP.getNearestVehiclePlateText(radius)
    local p = ""
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local v = GetClosestVehicle( x+0.0001, y+0.0001, z+0.0001,radius+0.0001,0,70)
    p = GetVehicleNumberPlateText(v)
    return p
end

