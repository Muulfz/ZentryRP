local lang = vRP.lang
local perm = vRP.permlang
local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

-- this module define some admin menu functions

local player_lists = {}

local function ch_list(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.player.player_list()) then
        if player_lists[player] then
            -- hide
            player_lists[player] = nil
            vRPclient._removeDiv(player, { "user_list" })
        else
            -- show
            local content = ""
            for k, v in pairs(vRP.rusers) do
                local source = vRP.getUserSource(k)
                local identity = vRP.getUserIdentity(k)
                if source then
                    content = content .. "<br />" .. k .. " => <span class=\"pseudo\">" .. vRP.getPlayerName(source) .. "</span> <span class=\"endpoint\">" .. vRP.getPlayerEndpoint(source) .. "</span>"
                    if identity then
                        content = content .. " <span class=\"name\">" .. htmlEntities.encode(identity.firstname) .. " " .. htmlEntities.encode(identity.name) .. "</span> <span class=\"reg\">" .. identity.registration .. "</span> <span class=\"phone\">" .. identity.phone .. "</span>"
                    end
                end
            end

            player_lists[player] = true
            local css = [[
.div_user_list{ 
  margin: auto; 
  padding: 8px; 
  width: 650px; 
  margin-top: 80px; 
  background: black; 
  color: white; 
  font-weight: bold; 
  font-size: 1.1em;
} 

.div_user_list .pseudo{ 
  color: rgb(0,255,125);
}

.div_user_list .endpoint{ 
  color: rgb(255,0,0);
}

.div_user_list .name{ 
  color: #309eff;
}

.div_user_list .reg{ 
  color: rgb(0,125,255);
}
              
.div_user_list .phone{ 
  color: rgb(211, 0, 255);
}
            ]]
            vRPclient._setDiv(player, "user_list", css, content)
        end
    end
end

local function ch_whitelist(player, choice)
    ---FIXED by add checkers
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.whitelist()) then
        local id = vRP.prompt(player, lang.admin.menu.whitelist.prompt(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            if not vRP.isWhitelisted(id) then
                vRP.setWhitelisted(id, true)
                vRPclient._notify(player, lang.admin.menu.whitelist.notify() .. id)
            else
                vRPclient._notify(player, lang.admin.menu.whitelist.already({ id }))
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_unwhitelist(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.unwhitelist()) then
        local id = vRP.prompt(player, lang.admin.menu.unwhitelist.prompt(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            if vRP.isWhitelisted(id) then

                vRP.setWhitelisted(id, false)
                vRPclient._notify(player, lang.admin.menu.unwhitelist.notify() .. id)
            else
                vRPclient._notify(player, lang.admin.menu.unwhitelist.already({ id }))
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_addgroup(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id, perm.admin.addgroup()) then
        local id = vRP.prompt(player, lang.admin.menu.prompt_id(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            local group = vRP.prompt(player, lang.admin.menu.addgroup.prompt(), "")
            if group then
                if not vRP.hasGroup(user_id, group) then
                    vRP.addUserGroup(id, group)
                    vRPclient._notify(player, lang.admin.menu.addgroup.notify({group,id}))
                else
                    vRPclient._notify(player, lang.admin.menu.addgroup.already())
                end
            else
                vRPclient._notify(player, lang.common.invalid_group())
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end

end

local function ch_removegroup(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.removegroup()) then
        local id = vRP.prompt(player, lang.admin.menu.removegroup.prompt(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            local group = vRP.prompt(player, lang.admin.menu.removegroup.prompt(), "")
            if group then
                if vRP.hasGroup(user_id, group) then
                    vRP.removeUserGroup(id, group)
                    vRPclient._notify(player, lang.admin.menu.removegroup.notify({group,id}))
                else
                    vRPclient._notify(player, lang.common.player_group_not_found())
                end
            else
                vRPclient._notify(player, lang.common.invalid_group())
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end

    end
end

local function ch_kick(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, lang.admin.kick()) then
        local id = vRP.prompt(player, lang.admin.menu.kick.prompt_id(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            if vRP.playerIsOnline(id) then
                local reason = vRP.prompt(player, lang.admin.menu.kick.prompt(), "")
                local source = vRP.getUserSource(id)
                if source then
                    vRP.kick(source, reason)
                    vRPclient._notify(player, lang.admin.menu.kick.notify() .. id)
                else
                    vRPclient._notify(player, lang.common.no_player())
                end
            else
                vRPclient._notify(player, lang.common.player_offline())
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_ban(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.ban()) then
        local id = vRP.prompt(player, lang.admin.menu.ban.prompt_id(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            if not vRP.isBanned(id) then
                local reason = vRP.prompt(player, lang.admin.menu.ban.prompt(), "")
                local source = vRP.getUserSource(id)
                if source then
                    vRP.ban(source, reason)
                    vRPclient._notify(player, lang.admin.menu.ban.notify() .. id)
                else
                    vRPclient._notify(player, lang.common.no_player())
                end
            else
                vRPclient._notify(player, lang.admin.menu.ban.already())
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_unban(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.unban()) then
        local id = vRP.prompt(player, lang.admin.menu.unban.prompt(), "")
        id = parseInt(id)
        if vRP.hasIDExist(id) then
            if vRP.isBanned(id) then
                vRP.setBanned(id, false)
                vRPclient._notify(player, lang.admin.menu.unban.notify() .. id)
            else
                vRPclient._notify(player, lang.admin.menu.unban.already() .. id)
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_emote(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.emote()) then
        local content = vRP.prompt(player, lang.admin.menu.emote.prompt(), "")
        local seq = {}
        for line in string.gmatch(content, "[^\n]+") do
            local args = {}
            for arg in string.gmatch(line, "[^%s]+") do
                table.insert(args, arg)
            end

            table.insert(seq, { args[1] or "", args[2] or "", args[3] or 1 })
        end

        vRPclient._playAnim(player, true, seq, false)
    end
end

local function ch_sound(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.sound()) then
        local content = vRP.prompt(player, lang.admin.menu.sound.prompt(), "")
        local args = {}
        for arg in string.gmatch(content, "[^%s]+") do
            table.insert(args, arg)
        end
        vRPclient._playSound(player, args[1] or "", args[2] or "")
    end
end

local function ch_coords(player, choice)
    local x, y, z = vRPclient.getPosition(player)
    vRP.prompt(player, lang.admin.menu.coords.prompt(), x .. "," .. y .. "," .. z)
end

local function ch_tptome(player, choice)
    local x, y, z = vRPclient.getPosition(player)
    local user_id = vRP.prompt(player, lang.admin.menu.tptome.prompt(), "")
    local tplayer = vRP.getUserSource(tonumber(user_id))
    if tplayer then
        vRPclient._teleport(tplayer, x, y, z)
    else
        vRPclient._notify(player, lang.common.no_player())
    end
end

local function ch_tpto(player, choice)
    local user_id = vRP.prompt(player, lang.admin.menu.tpto.prompt(), "")
    local tplayer = vRP.getUserSource(tonumber(user_id))
    if tplayer then
        vRPclient._teleport(player, vRPclient.getPosition(tplayer))
    else
        vRPclient._notify(player, lang.common.no_player())
    end
end

local function ch_tptocoords(player, choice)
    local fcoords = vRP.prompt(player, lang.admin.menu.tptocoords.prompt(), "")
    local coords = {}
    for coord in string.gmatch(fcoords or "0,0,0", "[^,]+") do
        table.insert(coords, tonumber(coord))
    end
    if coords[1] ~= nil and coords[2] ~= nil and coords[3] ~= nil then
        vRPclient._teleport(player, coords[1] or 0, coords[2] or 0, coords[3] or 0)
    else
        vRPclient._notify(player.lang.admin.menu.tptocoords.invalid_coords())
    end
end

local function ch_givemoney(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local amount = vRP.prompt(player, lang.admin.menu.givemoney.prompt(), "")
        amount = parseInt(amount)
        if amount <= 2147483647 then
            vRP.giveMoney(user_id, amount)
            vRPclient._notify(player, lang.admin.menu.givemoney.notify({ amount }))
        else
            vRPclient._notify(player, lang.admin.menu.givemoney.max_value())

        end
    end
end

local function ch_giveitem(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local idname = vRP.prompt(player, lang.admin.menu.giveitem.prompt_name(), "")
        idname = idname or ""
        local amount = vRP.prompt(player, lang.admin.menu.giveitem.prompt_amount(), "")
        amount = parseInt(amount)
        local name = vRP.getItemName(idname)
        if name then
            vRP.giveInventoryItem(user_id, idname, amount, true)
            vRPclient._notify(player, lang.admin.menu.giveitem.notify({ user_id ,name , amount }))
            vRPclient._notify(vRP.getUserSource(user_id), lang.admin.menu.giveitem.targetnotify({ name,amount }))
        else
            vRPclient._notify(player, lang.common.invalid_item())
        end
    end
end

local function ch_calladmin(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local playerok = vRP.request(player, lang.admin.menu.calladmin.playerok(), 60)
        if playerok then
            local desc = vRP.prompt(player, lang.admin.menu.calladmin.prompt(), "") or ""
            local date = os.date("%H:%M:%S %d/%m/%Y")
            local answered = false
            local players = {}
            for k, v in pairs(vRP.rusers) do
                local player = vRP.getUserSource(tonumber(k))
                -- check user
                if vRP.hasPermission(k, "admin.tickets") and player then
                    table.insert(players, player)
                end
            end

            if not players then
                vRP.execute("vRP/create_srv_ticket", { user_id = user_id, ticket = desc, date = date})
                vRPclient._notify(player, lang.admin.menu.calladmin.not_adm_online())
            else
                -- send notify and alert to all listening players
                for k, v in pairs(players) do
                    async(function()
                        local ok = vRP.request(v,lang.admin.menu.calladmin.admin_msg(user_id)  .. htmlEntities.encode(desc), 60)
                        if not ok then
                            vRP.execute("vRP/create_srv_ticket", { user_id = user_id, ticket = desc, date = date, ingame_accept = answered, solved = answered })
                        end
                        if ok then
                            -- take the call
                            if not answered then
                                -- answer the call
                                vRPclient._notify(player, lang.admin.menu.calladmin.player_msg())
                                vRPclient._teleport(v, vRPclient.getPosition(player))
                                answered = true
                            else
                                vRPclient._notify(v, lang.admin.menu.calladmin.sec_admin_msg())
                            end
                        end
                    end)
                end
            end
        end
    end
end

local player_customs = {}

local function ch_display_custom(player, choice)
    local custom = vRPclient.getCustomization(player)
    if player_customs[player] then
        -- hide
        player_customs[player] = nil
        vRPclient._removeDiv(player, "customization")
    else
        -- show
        local content = ""
        for k, v in pairs(custom) do
            content = content .. k .. " => " .. json.encode(v) .. "<br />"
        end

        player_customs[player] = true
        vRPclient._setDiv(player, "customization", ".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content)
    end
end

local function ch_noclip(player, choice)
    vRPclient._toggleNoclip(player)
end

local function ch_audiosource(player, choice)
    local infos = splitString(vRP.prompt(player, lang.admin.menu.audiosource.prompt(), ""), "=")
    local name = infos[1]
    local url = infos[2]

    if name and string.len(name) > 0 then
        if url and string.len(url) > 0 then
            local x, y, z = vRPclient.getPosition(player)
            vRPclient._setAudioSource(-1, "vRP:admin:" .. name, url, 0.5, x, y, z, 125)
        else
            vRPclient._removeAudioSource(-1, "vRP:admin:" .. name)
        end
    end
end

----------------------------------------------------------------------------
local function ch_player_givemoney(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, "admin.give.money") then
        local player_id = vRP.prompt(player,"ID","")
        if player_id then
            local amount = vRP.prompt(player, "Amount:", "")
            amount = parseDouble(amount)
            if amount <= 2147483647 then
                vRP.giveMoney(player_id, amount)
            else
                vRPclient._notify(player, "Valor acima do Permitido")
            end
        else
            vRPclient._notify(platyer, "JOGADOR N EXISTE")
        end

    end
end

local function ch_givemoney_USD(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local amount = vRP.prompt(player, "Amount:", "")
        amount = parseDouble(amount)
        if amount <= 2147483647 then
            vRP.giveMoneyUSD(user_id, amount)
        else
            vRPclient._notify(player, "Valor acima do Permitido")
        end
    end
end

local function ch_player_givemoney_USD(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, "admin.give.money") then
        local player_id = vRP.prompt(player,"ID","")
        player_id = parseInt(player_id)
        if vRP.hasIDExist(player_id) then
            local amount = vRP.prompt(player, "Amount:", "")
            amount = parseDouble(amount)
            if amount <= 2147483647 then
                vRP.giveMoneyUSD(player_id, amount)
            else
                vRPclient._notify(player, "Valor acima do Permitido")
            end
        else
            vRPclient._notify(platyer, "JOGADOR N EXISTE")
        end

    end
end

local function ch_givemoney_EUR(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local amount = vRP.prompt(player, "Amount:", "")
        amount = parseDouble(amount)
        if amount <= 2147483647 then
            vRP.giveMoneyEUR(user_id, amount)
        else
            vRPclient._notify(player, "Valor acima do Permitido")
        end
    end
end

local function ch_player_givemoney_EUR(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, "admin.give.money") then
        local player_id = vRP.prompt(player,"ID","")
        if player_id then
            local amount = vRP.prompt(player, "Amount:", "")
            amount = parseDouble(amount)
            if amount <= 2147483647 then
                vRP.giveMoneyEUR(player_id, amount)
            else
                vRPclient._notify(player, "Valor acima do Permitido")
            end
        else
            vRPclient._notify(platyer, "JOGADOR N EXISTE")
        end

    end
end

local function ch_givemoney_BTC(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local amount = vRP.prompt(player, "Amount:", "")
        amount = parseDouble(amount)
        if amount <= 2147483647 then
            vRP.giveMoneyBTC(user_id, amount)
        else
            vRPclient._notify(player, "Valor acima do Permitido")
        end
    end
end

local function ch_player_givemoney_BTC(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, "admin.give.money") then
        local player_id = vRP.prompt(player,"ID","")
        if player_id then
            local amount = vRP.prompt(player, "Amount:", "")
            amount = parseDouble(amount)
            if amount <= 2147483647 then
                vRP.giveMoneyBTC(player_id, amount)
            else
                vRPclient._notify(player, "Valor acima do Permitido")
            end
        else
            vRPclient._notify(platyer, "JOGADOR N EXISTE")
        end

    end
end

local function ch_report(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local playerok = vRP.request(player, "Deseja realmente fazer um ticket de admin? o uso deliberado acarretara punicoes", 60)
        if playerok then
            local desc = vRP.prompt(player,"Diga seu Report","")
            local date = os.date("%H:%M:%S %d/%m/%Y")
            local playerReport = vRP.request(player," Trata de um report contra um usuario", 60)
            if playerReport then
                local player_id = vRP.prompt(player,"Diga o ID","")
                if vRP.hasIDExist(player_id) then
                    local was_online = vRP.playerIsOnline(player_id)
                    print(type(was_online))
                    vRP.execute("vRP/create_srv_report_player", { user_id = player_id, report = desc, report_player = user_id, was_online = was_online, date = date})
                    vRPclient._notify(player, "Report contra ID: " ..player_id.." Criado com sucesso")
                else
                    vRPclient._notify(player,"Jogador n existe")
                end
            else
                vRP.execute("vRP/create_srv_report", { user_id = user_id, report = desc, date = date })
                vRPclient._notify(player, "Report Criado com sucesso")
            end
        end
    end
end
-----------------------------------------------------------------------------

vRP.registerMenuBuilder("main", function(add, data)
    local user_id = vRP.getUserId(data.player)
    if user_id then
        local choices = {}

        -- build admin menu
        choices["Admin"] = { function(player, choice)
            local menu = vRP.buildMenu("admin", { player = player })
            menu.name = "Admin"
            menu.css = { top = "75px", header_color = "rgba(200,0,0,0.75)" }
            menu.onclose = function(player)
                vRP.openMainMenu(player)
            end -- nest menu

            if vRP.hasPermission(user_id, perm.admin.menu.player_list()) then
                menu[lang.admin.menu.user_list.menu_name()] = { ch_list, lang.admin.menu.user_list.menu_desc() }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.whitelist()) then
                menu[lang.admin.menu.whitelist.menu_name()] = { ch_whitelist }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.addgroup()) then
                menu[lang.admin.menu.addgroup.menu_name()] = { ch_addgroup }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.removegroup()) then
                menu[lang.admin.menu.removegroup.menu_name()] = { ch_removegroup }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.unwhitelist()) then
                menu[lang.admin.menu.kick.menu_name()] = { ch_unwhitelist }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.kick()) then
                menu[lang.admin.menu.kick.menu_name()] = { ch_kick }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.ban()) then
                menu[lang.admin.menu.ban.menu_name()] = { ch_ban }
            end
            if vRP.hasPermission(user_id,perm.admin.menu.unban() ) then
                menu[lang.admin.menu.unban.menu_name()] = { ch_unban }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.noclip()) then
                menu[lang.admin.menu.noclip.menu_name()] = { ch_noclip }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.emote()) then
                menu[lang.admin.menu.emote.menu_name()] = { ch_emote }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.custom_sound()) then
                menu[lang.admin.menu.sound.menu_name()] = { ch_sound }
            end
            if vRP.hasPermission(user_id,perm.admin.menu.custom_audiosource() ) then
                menu[lang.admin.menu.audiosource.menu_name()] = { ch_audiosource }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.coords()) then
                menu[lang.admin.menu.coords.menu_name()] = { ch_coords }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.tptome()) then
                menu[lang.admin.menu.tptome.menu_name()] = { ch_tptome }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.tpto()) then
                menu[lang.admin.menu.tpto.menu_name()] = { ch_tpto }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.tpto()) then
                menu[lang.admin.menu.tptocoords.menu_name()] = { ch_tptocoords }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.givemoney()) then
                menu[lang.admin.menu.givemoney.menu_name()] = { ch_givemoney }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.giveitem()) then
                menu[lang.admin.menu.giveitem.menu_name()] = { ch_giveitem }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.display_custom()) then
                menu[lang.admin.menu.displaycustom.menu_name()] = { ch_display_custom }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.calladmin()) then
                menu[lang.admin.menu.calladmin.menu_name()] = { ch_calladmin }
            end

            vRP.openMenu(player, menu)
        end }

        add(choices)
    end
end)

-- admin god mode
function task_god()
    SetTimeout(10000, task_god)

    for k, v in pairs(vRP.getUsersByPermission(perm.admin.menu.god())) do
        vRP.setHunger(v, 0)
        vRP.setThirst(v, 0)

        local player = vRP.getUserSource(v)
        if player ~= nil then
            vRPclient._setHealth(player, 200)
        end
    end
end

task_god()
