---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/7/2018 11:16
---

local cfg = module("cfg/drugs")


Citizen.CreateThread(function()
    for k,v in pairs(cfg.drugs) do
        vRP.defInventoryItem(k,v.name,v.desc,v.choices,v.weight)
    end
end)