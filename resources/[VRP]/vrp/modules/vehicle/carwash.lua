---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/9/2018 04:14
---
local cfg = module("cfg/vehicle/carwash")
local lang = vRP.lang
--- LANG TO MAKE

function vRP.cleanVehicle(source)
    local user_id = vRP.getUserId(source)
    local in_vehicle = vRPclient.isInAnyVehicle(source)
    if in_vehicle then
        local dirt = vRPclient.getDirtLevel(source)
        if parseFloat(dirt) > parseFloat(1.0) then
            local total = parseInt(parseFloat(dirt)*cfg.price)
            if vRP.tryPayment(user_id,math.floor(total)) then
                vRPclient.cleanVehicle(source)
                vRPclient.notify(source, lang.money.paid({total}))
            else
                vRPclient.notify(source, lang.money.not_enough())
            end
        else
            vRPclient.notify(source, cfg.lang.cleaned)
        end
    else
        vRPclient.notify(source, cfg.lang.no_veh)
    end
end

local function build_client_carwash(source)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        for k,v in pairs(cfg.carwash) do
            local x,y,z = table.unpack(v)

            local carwash_enter = function(source)
                vRP.cleanVehicle(source)
            end

            local function carwash_leave(source)
                vRPclient.notify(source,cfg.lang.goodbye)
            end

            vRPclient.addBlip(source,x,y,z,cfg.blip.id,cfg.blip.color,cfg.lang.title)
            vRPclient.addMarker(source,x,y,z-1,3,3,0.7,125,125,255,255,150)

            vRP.setArea(source,"vRP:carwash"..k,x,y,z,3,1.5,carwash_enter,carwash_leave)
        end
    end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    if first_spawn then
        build_client_carwash(source)
    end
end)