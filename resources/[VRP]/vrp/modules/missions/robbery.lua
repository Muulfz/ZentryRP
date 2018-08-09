---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/8/2018 14:33
---
local lang = vRP.lang
local cfg = module("cfg/missions/robbery")
robbers = {}
lastrobbed = {}

function vRP.cancelRobbery(robb)
    if(robbers[source])then
        robbers[source] = nil
        TriggerClientEvent('chatMessage', -1, lang.robbery.title.news(), {255, 0, 0}, lang.robbery.robbery.canceled({cfg.robbery[robb].name}))
    end
end

function vRP.startRobbery(robb)
    local canceled = false
    local player = source
    local user_id = vRP.getUserId(player)
    local cops = vRP.getUsersByPermission(cfg.cops)
    local robbery = cfg.robbery[robb]
    if vRP.hasPermission(user_id,cfg.cops) then
        vRPclient.robberyComplete(player)
        vRPclient.notify(player,lang.robbery.cops.cant_rob())
    else
        if robbery then
            if #cops >= robbery.cops then
                if lastrobbed[robb] then
                    local past = os.time() - lastrobbed[robb]
                    local wait = robbery.rob + robbery.wait
                    if past <  wait then
                        vRPclient.robberyComplete(player)
                        TriggerClientEvent('chatMessage', player, lang.robbery.title.robbery(), {255, 0, 0}, lang.robbery.robbery.wait({wait - past}))
                        canceled = true
                    end
                end
                if not canceled then
                    TriggerClientEvent('chatMessage', -1, lang.robbery.title.news(), {255, 0, 0}, lang.robbery.robbery.progress({robbery.name}))
                    TriggerClientEvent('chatMessage', player, lang.robbery.title.system(), {255, 0, 0}, lang.robbery.robbery.started({robbery.name}))
                    TriggerClientEvent('chatMessage', player, lang.robbery.title.system(), {255, 0, 0}, lang.robbery.robbery.hold({math.ceil(robbery.rob/60)}))
                    lastrobbed[robb] = os.time()
                    robbers[player] = robb
                    local savedSource = player
                    SetTimeout(robbery.rob*1000, function()
                        if(robbers[savedSource])then
                            if(user_id)then
                                local reward = math.random(robbery.min,robbery.max)
                                vRP.giveInventoryItem(user_id,"dirty_money",reward,true)
                                TriggerClientEvent('chatMessage', -1, lang.robbery.title.news(), {255, 0, 0}, lang.robbery.robbery.over({robbery.name}))
                                TriggerClientEvent('chatMessage', savedSource, lang.robbery.title.system(), {255, 0, 0}, lang.robbery.robbery.done({reward}))
                                vRPclient.robberyComplete(savedSource)
                            end
                        end
                    end)
                end
            else
                vRPclient.robberyComplete(player)
                vRPclient.notify(player,lang.robbery.cops.not_enough({robbery.cops}))
            end
        end
    end
end