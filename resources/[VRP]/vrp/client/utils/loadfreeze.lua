---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/8/2018 13:56
---

local timeout = 0
local frozen = false
function tvRP.loadFreeze()
    timeout = 30
    while not IsPedModel(GetPlayerPed(-1),"mp_m_freemode_01") and not IsPedModel(GetPlayerPed(-1),"mp_f_freemode_01") and timeout > 0 do
        SetEntityInvincible(GetPlayerPed(-1),true)
        SetEntityVisible(GetPlayerPed(-1),false)
        FreezeEntityPosition(GetPlayerPed(-1),true)
        frozen = true
        Citizen.Wait(1)
    end
    SetEntityInvincible(GetPlayerPed(-1),false)
    SetEntityVisible(GetPlayerPed(-1),true)
    FreezeEntityPosition(GetPlayerPed(-1),false)
    frozen = false
end

Citizen.CreateThread(function()
    while true do
        if timeout > 0 then
            timeout = timeout - 1
        end
        Citizen.Wait(1000)
    end
end)

function tvRP.isFrozen()
    return frozen
end