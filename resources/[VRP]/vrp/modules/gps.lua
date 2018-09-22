--Credits Marmota#2533

local perm = vRP.permlang
local lang = vRP.lang
local cfg = module("cfg/gps")

local gps_menu = {name=lang.gps.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
local function setMarker(player,choice)
    vRPclient._setGPS(player,cfg.gps[choice][2],cfg.gps[choice][3])
end
for k, v in pairs(cfg.gps) do
    gps_menu[k] = {setMarker,cfg.gps[k][1]}
end

SetTimeout(10000, function()
    local menu = vRP.buildMenu("gps", {})
    for k,v in pairs(menu) do
        gps_menu[k] = v
    end
end)

vRP.registerMenuBuilder("main", function(add, data)
    local player = data.player
    local choices = {}
    choices[lang.gps.title()] = {function() vRP.openMenu(player,gps_menu) end}

    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.player.gps()) then
        add(choices)
    end
end)



