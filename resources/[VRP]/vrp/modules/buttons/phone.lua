---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/6/2018 23:29
---

local lang = vRP.lang
-- mobilepay

ch_mobilepay = {function(player,choice)
    local user_id = vRP.getUserId(player)
    local menu = {}
    menu.name = lang.phone.directory.title()
    menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu
    menu[lang.mpay.type.button()] = {
        -- payment function
        function(player,choice)
            local phone = vRP.prompt(player,lang.mpay.type.prompt,"")
            if phone ~= nil and phone ~= "" then
                vRP.payPhoneNumber(user_id,phone)
            else
                vRPclient._notify(player,lang.common.invalid_value())
            end
        end,lang.mpay.type.desc()}
    local directory = vRP.getPhoneDirectory(user_id)
    for k,v in pairs(directory) do
        menu[k] = {
            -- payment function
            function(player,choice)
                vRP.payPhoneNumber(user_id,v)
            end
        ,v} -- number as description
    end
    vRP.openMenu(player, menu)
end,lang.mpay.desc()}

-- mobilecharge
ch_mobilecharge = {function(player,choice)
    local user_id = vRP.getUserId(player)
    local menu = {}
    menu.name = lang.phone.directory.title()
    menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu
    menu[lang.mcharge.type.button()] = {
        -- payment function
        function(player,choice)
            local phone = vRP.prompt(player,lang.mcharge.type.prompt(),"")
            if phone ~= nil and phone ~= "" then
                vRP.chargePhoneNumber(user_id,phone)
            else
                vRPclient._notify(player,lang.common.invalid_value())
            end
        end,lang.mcharge.type.desc()}
    local directory = vRP.getPhoneDirectory(user_id)
    for k,v in pairs(directory) do
        menu[k] = {
            -- payment function
            function(player,choice)
                vRP.chargePhoneNumber(user_id,v)
            end
        ,v} -- number as description
    end
    vRP.openMenu(player, menu)
end,lang.mcharge.desc()}