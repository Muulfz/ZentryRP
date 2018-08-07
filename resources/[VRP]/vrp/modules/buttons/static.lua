---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/6/2018 23:32
---

--police weapons // comment out the weapons if you dont want to give weapons.
police_weapons = {}
police_weapons["Equip"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    vRPclient.giveWeapons(player,{
        ["WEAPON_COMBATPISTOL"] = {ammo=500},
        ["WEAPON_PUMPSHOTGUN"] = {ammo=500},
        ["WEAPON_PISTOL"] = {ammo=500},
        ["WEAPON_CARBINERIFLE"] = {ammo=500},
        ["WEAPON_NIGHTSTICK"] = {ammo=1},
        ["WEAPON_STUNGUN"] = {ammo=500},
        ["WEAPON_SPECIALCARBINE"] = {ammo=500},
        ["WEAPON_BULLPUPRIFLE"] = {ammo=500},
        ["WEAPON_COMBATPDW"] = {ammo=500},
        ["WEAPON_ADVANCEDRIFLE"] = {ammo=500},
        ["WEAPON_FLASHLIGHT"] = {ammo=1},
        ["WEAPON_SMG"] = {ammo=500},
        ["WEAPON_MICROSMG"] = {ammo=500},
        ["WEAPON_STUNGUN"] = {ammo=500}
    }, true)
    vRPclient.setArmour(player,1000,true)
    vRPclient._notify(player,"You received ~ g ~ received medical equipment")
end}

emergency_medkit = {}
emergency_medkit["Take"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if  vRP.tryPayment(user_id,100,false)then
        vRP.giveInventoryItem(user_id,"medkit",1,true)
        vRP.giveInventoryItem(user_id,"pills",1,true)
        vRPclient._notify(player,"You received ~ g ~ received medical equipment")
    else
        vRPclient._notify(player," ~r~ You do not have enough money to pick up your equipment")
    end
end}

--heal me
emergency_heal = {}
emergency_heal["Heal"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if  vRP.tryPayment(user_id,100,false)then
        vRPclient.setHealth(player,1000)
        vRPclient._notify(player,"You were ~ g ~ healed by 100")
    else
        vRPclient._notify(player," ~r~ You do not have enough money for the quick-cure SUS system")
    end
end}

