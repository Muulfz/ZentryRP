---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/8/2018 13:53
---

-- unfreeze on spawn
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    vRPclient.loadFreeze(source)
end)