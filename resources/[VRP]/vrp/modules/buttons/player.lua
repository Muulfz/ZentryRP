---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/6/2018 23:22
---
local lang = vRP.lang
--toggle service
choice_service = {function(player,choice)
    local user_id = vRP.getUserId(player)
    local service = lang.service.group()
    if user_id ~= nil then
        if vRP.hasGroup(user_id,service) then
            vRP.removeUserGroup(user_id,service)
            if vRP.hasMission(player) then
                vRP.stopMission(player)
            end
            vRPclient._notify(player,lang.service.off())
        else
            vRP.addUserGroup(user_id,service)
            vRPclient._notify(player,lang.service.on())
        end
    end
end, lang.service.desc()}

--loot corpse
choice_loot = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local nplayer = vRPclient.getNearestPlayer(player,10)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            local in_coma = vRPclient.isInComa(nplayer)
            if in_coma then
                local revive_seq = {
                    {"amb@medic@standing@kneel@enter","enter",1},
                    {"amb@medic@standing@kneel@idle_a","idle_a",1},
                    {"amb@medic@standing@kneel@exit","exit",1}
                }
                vRPclient.playAnim(player,false,revive_seq,false) -- anim
                SetTimeout(15000, function()
                    local ndata = vRP.getUserDataTable(nuser_id)
                    if ndata ~= nil then
                        if ndata.inventory ~= nil then -- gives inventory items
                            vRP.clearInventory(nuser_id)
                            for k,v in pairs(ndata.inventory) do
                                vRP.giveInventoryItem(user_id,k,v.amount,true)
                            end
                        end
                    end
                    local nmoney = vRP.getMoney(nuser_id)
                    if vRP.tryPayment(nuser_id,nmoney) then
                        vRP.giveMoney(user_id,nmoney)
                    end
                end)
                vRPclient.stopAnim(player,false)
            else
                vRPclient._notify(player,lang.emergency.menu.revive.not_in_coma())
            end
        else
            vRPclient._notify(player,lang.common.no_player_near())
        end
    end
end,lang.loot.desc()}

-- hack player
ch_hack = {function(player,choice)
    -- get nearest player
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local nplayer = vRPclient.getNearestPlayer(player,25)
        if nplayer ~= nil then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil then
                -- prompt number
                local nbank = vRP.getBankMoney(nuser_id)
                local amount = math.floor(nbank*0.01)
                local nvalue = nbank - amount
                if math.random(1,100) == 1 then
                    vRP.setBankMoney(nuser_id,nvalue)
                    vRPclient._notify(nplayer,lang.hacker.hacked({amount}))
                    vRP.giveInventoryItem(user_id,"dirty_money",amount,true)
                else
                    vRPclient._notify(nplayer,lang.hacker.failed.good())
                    vRPclient._notify(player,lang.hacker.failed.bad())
                end
            else
                vRPclient._notify(player,lang.common.no_player_near())
            end
        else
            vRPclient._notify(player,lang.common.no_player_near())
        end
    end
end,lang.hacker.desc()}

-- mug player
ch_mug = {function(player,choice)
    -- get nearest player
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local nplayer = vRPclient.getNearestPlayer(player,10)
        if nplayer ~= nil then
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil then
                -- prompt number
                local nmoney = vRP.getMoney(nuser_id)
                local amount = nmoney
                if math.random(1,3) == 1 then
                    if vRP.tryPayment(nuser_id,amount) then
                        vRPclient._notify(nplayer,lang.mugger.mugged({amount}))
                        vRP.giveInventoryItem(user_id,"dirty_money",amount,true)
                    else
                        vRPclient._notify(player,lang.money.not_enough())
                    end
                else
                    vRPclient._notify(nplayer,lang.mugger.failed.good())
                    vRPclient._notify(player,lang.mugger.failed.bad())
                end
            else
                vRPclient._notify(player,lang.common.no_player_near())
            end
        else
            vRPclient._notify(player,lang.common.no_player_near())
        end
    end
end, lang.mugger.desc()}

-- lockpick vehicle
ch_lockpickveh = {function(player,choice)
    vRPclient.lockpickVehicle(player,20,true) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
end,lang.lockpick.desc()}

-- fix barbershop green hair for now
ch_fixhair = {function(player,choice)
    local custom = {}
    local user_id = vRP.getUserId(player)
    local value = vRP.getUData(user_id,"vRP:head:overlay")
    if value ~= nil then
        custom = json.decode(value)
        vRPclient.setOverlay(player,custom,true)
    end
end, lang.fixhaircut.desc()}

-- store armor
choice_store_armor = {function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local armour = vRPclient.getArmour(player)
        if armour > 95 then
            vRP.giveInventoryItem(user_id, lang.bodyarmor.id(), 1, true)
            -- clear armor
            vRPclient.setArmour(player,0,false)
        else
            vRPclient._notify(player, lang.bodyarmor.damaged())
        end
    end
end, lang.bodyarmor.store.desc()}

--store money
choice_store_money = {function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local amount = vRP.getMoney(user_id)
        if vRP.tryPayment(user_id, amount) then -- unpack the money
            vRP.giveInventoryItem(user_id, "money", amount, true)
        end
    end
end, lang.money.store.desc()}

-- player check
choice_player_check = {function(player,choice)
    local nplayer = vRPclient.getNearestPlayer(player,5)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
        vRPclient._notify(nplayer,lang.police.menu.check.checked())
        local weapons = vRPclient.getWeapons(nplayer)
        -- prepare display data (money, items, weapons)
        local money = vRP.getMoney(nuser_id)
        local items = ""
        local data = vRP.getUserDataTable(nuser_id)
        if data and data.inventory then
            for k,v in pairs(data.inventory) do
                local item_name = vRP.getItemName(k)
                if item_name then
                    items = items.."<br />"..item_name.." ("..v.amount..")"
                end
            end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
            weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        vRPclient.setDiv(player,"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info}))
        -- request to hide div
        local ok = vRP.request(player, lang.police.menu.check.request_hide(), 1000)
        vRPclient.removeDiv(player,"police_check")
    else
        vRPclient._notify(player,lang.common.no_player_near())
    end
end, lang.inspect.desc()}

-- player store weapons
choice_store_weapons = {function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local weapons = vRPclient.getWeapons(player)
        for k,v in pairs(weapons) do
            -- convert weapons to parametric weapon items
            vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
            if v.ammo > 0 then
                vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
            end
        end

        -- clear all weapons
        vRPclient.giveWeapons(player,{},true)
    end
end, lang.weapons.store.desc()}

player_lists = {}
ch_userlist = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        if player_lists[player] then -- hide
            player_lists[player] = nil
            vRPclient.removeDiv(player,"user_list")
        else -- show
            local content = "<span class=\"id\">"..lang.userlist.id().."</span><span class=\"pseudo\">"..lang.userlist.nickname().."</span><span class=\"name\">"..lang.userlist.rpname().."</span><span class=\"job\">"..lang.userlist.job().."</span>"
            local count = 0
            local users = vRP.getUsers()
            for k,v in pairs(users) do
                count = count+1
                local source = vRP.getUserSource(k)
                local identity = vRP.getUserIdentity(k)
                if source ~= nil then
                    content = content.."<br /><span class=\"id\">"..k.."</span><span class=\"pseudo\">"..vRP.getPlayerName(source).."</span>"
                    if identity then
                        content = content.."<span class=\"name\">"..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).."</span><span class=\"job\">"..vRP.getUserGroupByType(k,"job").."</span>"
                    end
                end

                -- check end
                count = count-1
                if count == 0 then
                    player_lists[player] = true
                    local css = [[
              .div_user_list{
                margin: auto;
				text-align: left;
                padding: 8px;
                width: 650px;
                margin-top: 100px;
                background: rgba(50,50,50,0.0);
                color: white;
                font-weight: bold;
                font-size: 1.1em;
              }
              .div_user_list span{
				display: inline-block;
				text-align: center;
              }
              .div_user_list .id{
                color: rgb(255, 255, 255);
                width: 45px;
              }
              .div_user_list .pseudo{
                color: rgb(66, 244, 107);
                width: 145px;
              }
              .div_user_list .name{
                color: rgb(92, 170, 249);
                width: 295px;
              }
			  .div_user_list .job{
                color: rgb(247, 193, 93);
                width: 145px;
			  }
            ]]
                    vRPclient.setDiv(player,"user_list", css, content)
                end
            end
        end
    end
end, lang.userlist.desc()}