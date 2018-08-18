local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")
--TODO transofrmar em local tbm
local lang = vRP.lang
local perm = vRP.permlang
-- this module define some admin menu functions

local player_lists = {}

local function ch_list(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, "player.list") then
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
    --- DONE
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.whitelist()) then
        local id = vRP.prompt(player, lang.admin.menu.whitelist.prompt(), "")
        id = parseInt(id)
        if vRP.isIDValid(id) then
            if not vRP.isWhitelisted(id) then
                vRP.setWhitelisted(id, true)
                vRPclient._notify(player, lang.admin.menu.whitelist.notify({ id }))
            else
                vRPclient._notify(player, lang.admin.menu.already({ id }))
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())

        end
    end
end

local function ch_unwhitelist(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.whitelist()) then
        local id = vRP.prompt(player, lang.admin.menu.unwhitelist.prompt(), "")
        id = parseInt(id)
        if vRP.isWhitelisted(id) then
            vRP.setWhitelisted(id, false)
            vRPclient._notify(player, lang.admin.menu.unwhitelist.notify({ id }))
        else
            vRPclient._notify(player, lang.admin.menu.unwhitelist.already({ id }))
        end
    end
end

local function ch_addgroup(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id, perm.admin.menu.addgroup()) then
        local id = vRP.prompt(player, lang.admin.menu.addgroup.prompt_id(), "")
        id = parseInt(id)
        if vRP.isIDValid(id) then
            local group = vRP.prompt(player, lang.admin.menu.addgroup.prompt(), "")
            if group and vRP.isGroupValid(group) then
                if not vRP.hasGroup(id, group) then
                    vRP.addUserGroup(id, group)
                    vRPclient._notify(player, lang.admin.menu.addgroup.notify({ group, id }))
                else
                    vRPclient._notify(player, lang.admin.menu.addgroup.already())  --- ISSO PODE DAR PROBLEMA
                end
            else
                vRPclient._notify(player, lang.common.invalid_group()) --- ESSE AQUI TALVEZ É O QUE DA MERDA
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_removegroup(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.menu.removegroup()) then
        local id = vRP.prompt(player, lang.admin.menu.removegroup.prompt_id(), "")
        id = parseInt(id)
        if vRP.isIDValid(id) then
            local group = vRP.prompt(player, lang.admin.menu.removegroup.prompt(), "")
            if group and vRP.isGroupValid(group) then
                if vRP.hasGroup(id, group) then
                    vRP.removeUserGroup(id, group)
                    vRPclient._notify(player, lang.admin.menu.removegroup.notify({ group, id }))
                else
                    vRPclient._notify(player, lang.admin.menu.removegroup.not_found({ group }))
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
    if user_id and vRP.hasPermission(user_id, perm.admin.menu.kick()) then
        local id = vRP.prompt(player, lang.admin.menu.kick.prompt_id(), "")
        id = parseInt(id)
        if vRP.isIDValid(id) then
            if vRP.playerIsOnline(id) then
                local reason = vRP.prompt(player, lang.admin.menu.kick.prompt(), "")
                local source = vRP.getUserSource(id)
                if source then
                    vRP.kick(source, reason)
                    vRPclient._notify(player, lang.admin.menu.kick.notify({ id }))
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
    if user_id and vRP.hasPermission(user_id, perm.admin.menu.ban()) then
        local id = vRP.prompt(player, lang.admin.menu.ban.prompt_id(), "")
        id = parseInt(id)
        if vRP.isIDValid(id) then
            if not vRP.isBanned(id) then
                local reason = vRP.prompt(player, lang.admin.menu.ban.prompt(), "")
                local source = vRP.getUserSource(id)
                if source then
                    vRP.ban(source, reason)
                    vRPclient._notify(player, lang.admin.menu.ban.notify({ id }))
                end
            else
                vRPclient._notify(player, lang.admin.menu.ban.already())
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_ban_adv(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.adv_ban()) then
        local id = vRP.prompt(player, lang.admin.menu.ban.prompt_id(), "")
        id = parseInt(id)
        if vRP.isIDValid(id) then
            if not vRP.isBanned(id) then
                local reason = vRP.prompt(player, lang.admin.menu.ban.prompt(), "")
                ---local source = vRP.getUserSource(id)
                if reason and reason ~= "" then
                    local time = vRP.prompt(player, lang.admin.menu.ban.time(), "")
                    if time then
                        time = tonumber(time)
                        if time > 30 then
                            if time == 3600 then
                                time = 3600
                            else
                                time = 30
                            end
                        end
                        --[[                        if time < 1 then
                                                    time = 1
                                                end]]
                        vRP.advBan(user_id, id, reason, time)
                        vRPclient._notify(player, lang.admin.menu.ban.notify({ id }))
                    end
                else
                    vRPclient._notify(player, common.invalid_value())
                end
            else
                vRPclient._notify(player, lang.admin.menu.ban.already())
            end
        else
            vRPclient._notify(player, lang.common.invalid_id())
        end
    end
end

local function ch_appeal(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.appeal()) then
        local UUID = vRP.prompt(player, lang.admin.menu.appeal.ban_UUID_prompt(), "")
        if UUID and vRP.isBanUUIDValid(UUID) then
            if vRP.isAlreadyAppeal(UUID) == nil then
                local accept = vRP.request(player, lang.admin.menu.appeal.request(), 180)
                local reason = vRP.prompt(player, lang.admin.menu.appeal.reason(), "")
                if reason then
                    vRP.setBanAppeald(UUID, accept, reason, user_id)
                    vRPclient._notify(player, lang.admin.menu.appeal.notify())
                end
            else
                vRPclient._notify(player, lang.admin.menu.appeal.already())
            end
        else
            vRPclient._notify(player, lang.common.invalid_UUID())
        end
    else
        vRPclient._notify(player, lang.common.not_perm())
    end
end

local function ch_ban_check(player, choice)
    local UUID = vRP.prompt(player, lang.admin.ban_system.bancheck.prompt_uuid(), "")
    local user_id = vRP.getUserId(player)
    if user_id then
        if vRP.isBanUUIDValid(UUID) then
            local rows = vRP.query("vRP/get_ban_reg", { UUID = UUID })
            -- display identity and business
            local UUID = UUID
            local banned_user = rows[1].user_id
            local admin_ban = rows[1].admin_id
            local reason = rows[1].reason
            local ban_date = os.date(lang.admin.ban_system.bancheck.date_format(), rows[1].ban_date)
            local ban_expire = os.date(lang.admin.ban_system.bancheck.date_format(), rows[1].ban_expire_date)
            local appeal = ""
            local appeal_reason = ""
            local appeal_admin_id = ""
            if rows[1].appeal then
                appeal = lang.admin.ban_system.bancheck.appeal_true()
            else
                appeal = lang.admin.ban_system.bancheck.appeal_false()
            end
            if rows[1].appeal_reason ~= nil then
                appeal_reason = rows[1].appeal_reason
            end
            if rows[1].appeal_admin_id ~= nil then
                appeal_admin_id = rows[1].appeal_admin_id
            end

            local content = lang.admin.ban_system.bancheck.info({ UUID, banned_user, admin_ban, reason, ban_date, ban_expire, appeal, appeal_reason, appeal_admin_id })
            vRPclient._setDiv(player, "ban_check", ".div_ban_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }", content)
            -- request to hide div
            vRP.request(player, lang.admin.ban_system.bancheck.request_hide(), 1000)
            vRPclient._removeDiv(player, "ban_check")
        else
            vRPclient._notify(player, lang.common.not_found())
        end
    else
        vRPclient._notify(player, lang.common.not_found())
    end
end

local function ch_unban(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.unban()) then
        local id = vRP.prompt(player, lang.admin.menu.unban.prompt(), "")
        id = parseInt(id)
        vRP.setBanned(id, false)
        vRPclient._notify(player, lang.admin.menu.unban.notify({ id }))
    end
end

local function ch_emote(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id and vRP.hasPermission(user_id, perm.admin.menu.custom_emote()) then
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
    if user_id and vRP.hasPermission(user_id, perm.admin.menu.custom_sound()) then
        local content = vRP.prompt(player, lang.admim.menu.sound.prompt(), "")
        local args = {}
        for arg in string.gmatch(content, "[^%s]+") do
            table.insert(args, arg)
        end
        vRPclient._playSound(player, args[1] or "", args[2] or "")
    end
end

local function ch_coords(player, choice)
    local x, y, z = vRPclient.getPosition(player)
    vRP.prompt(player, lang.admin.menu.coords(), x .. "," .. y .. "," .. z)
end

local function ch_tptome(player, choice)
    local x, y, z = vRPclient.getPosition(player)
    local user_id = vRP.prompt(player, lang.admim.menu.tptome.prompt(), "")
    local tplayer = vRP.getUserSource(tonumber(user_id))
    if tplayer then
        vRPclient._teleport(tplayer, x, y, z)
    end
end

local function ch_tpto(player, choice)
    local user_id = vRP.prompt(player, lang.admim.menu.tpto.prompt(), "")
    local tplayer = vRP.getUserSource(tonumber(user_id))
    if tplayer then
        vRPclient._teleport(player, vRPclient.getPosition(tplayer))
    end
end

local function ch_tptocoords(player, choice)
    local fcoords = vRP.prompt(player, lang.admim.menu.tptocoords.prompt(), "")
    local coords = {}
    for coord in string.gmatch(fcoords or "0,0,0", "[^,]+") do
        table.insert(coords, tonumber(coord))
    end

    vRPclient._teleport(player, coords[1] or 0, coords[2] or 0, coords[3] or 0)
end

local function ch_givemoney(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local amount = vRP.prompt(player, lang.admim.menu.givemoney.prompt(), "")
        amount = parseInt(amount)
        vRP.giveMoney(user_id, amount)
    end
end

local function ch_giveitem(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local idname = vRP.prompt(player, lang.admim.menu.giveitem.prompt_name(), "")
        idname = idname or ""
        local amount = vRP.prompt(player, lang.admim.menu.giveitem.prompt_amount(), "")
        amount = parseInt(amount)
        vRP.giveInventoryItem(user_id, idname, amount, true)
    end
end

local function ch_calladmin(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local playerok = vRP.request(player, lang.admin.menu.calladmin.playeok(), 60)
        if playerok then
            local desc = vRP.prompt(player, "Describe your problem:", "") or ""
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
                vRP.createServerTicket(user_id, desc)
                print("FIM")
            else
                -- send notify and alert to all listening players
                for k, v in pairs(players) do
                    async(function()
                        local ok = vRP.request(v, lang.admin.menu.calladmin.admin_msg(user_id ).. htmlEntities.encode(desc), 60)
                        if not ok then
                            vRP.createServerTicket(user_id, desc, answered)
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
    local infos = splitString(vRP.prompt(player, "Audio source: name=url, omit url to delete the named source.", ""), "=")
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
                menu["@User list"] = { ch_list, "Show/hide user list." }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.whitelist()) then
                menu["@Whitelist user"] = { ch_whitelist }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.addgroup()) then
                menu["@Add group"] = { ch_addgroup }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.removegroup()) then
                menu["@Remove group"] = { ch_removegroup }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.unwhitelist()) then
                menu["@Un-whitelist user"] = { ch_unwhitelist }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.kick()) then
                menu["@Kick"] = { ch_kick }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.ban()) then
                menu["@Ban"] = { ch_ban }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.adv_ban()) then
                menu["@Ban Advanced"] = { ch_ban_adv }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.ban_check()) then
                menu["@BanCHECK"] = { ch_ban_check }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.appeal()) then
                menu["@Appeal"] = { ch_appeal }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.unban()) then
                menu["@Unban"] = { ch_unban }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.noclip()) then
                menu["@Noclip"] = { ch_noclip }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.custom_sound()) then
                menu["@Custom emote"] = { ch_emote }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.custom_sound()) then
                menu["@Custom sound"] = { ch_sound }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.custom_audiosource()) then
                menu["@Custom audiosource"] = { ch_audiosource }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.coords()) then
                menu["@Coords"] = { ch_coords }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.tptome()) then
                menu["@TpToMe"] = { ch_tptome }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.tpto()) then
                menu["@TpTo"] = { ch_tpto }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.tptocoords()) then
                menu["@TpToCoords"] = { ch_tptocoords }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.givemoney()) then
                menu["@Give money"] = { ch_givemoney }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.giveitem()) then
                menu["@Give item"] = { ch_giveitem }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.display_custom()) then
                menu["@Display customization"] = { ch_display_custom }
            end
            if vRP.hasPermission(user_id, perm.admin.menu.calladmin()) then
                menu["@Call admin"] = { ch_calladmin }
            end

            vRP.openMenu(player, menu)
        end }

        add(choices)
    end
end)

-- admin god mode
function task_god()
    SetTimeout(10000, task_god)

    for k, v in pairs(vRP.getUsersByPermission(perm.admin.god())) do
        vRP.setHunger(v, 0)
        vRP.setThirst(v, 0)

        local player = vRP.getUserSource(v)
        if player ~= nil then
            vRPclient._setHealth(player, 200)
        end
    end
end

task_god()
