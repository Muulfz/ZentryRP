local cfg = module("cfg/survival")
local lang = vRP.lang
local perm = vRP.permlang
local utils = module("modules/utils/survival")

-- api

function vRP.getHunger(user_id)
    local data = vRP.getUserDataTable(user_id)
    if data then
        return data.hunger
    end

    return 0
end

function vRP.getThirst(user_id)
    local data = vRP.getUserDataTable(user_id)
    if data then
        return data.thirst
    end

    return 0
end

function vRP.setHunger(user_id, value)
    local data = vRP.getUserDataTable(user_id)
    if data then
        data.hunger = value
        if data.hunger < 0 then
            data.hunger = 0
        elseif data.hunger > 100 then
            data.hunger = 100
        end

        -- update bar
        local source = vRP.getUserSource(user_id)
        vRPclient._setProgressBarValue(source, "vRP:hunger", data.hunger)
        if data.hunger >= 100 then
            vRPclient._setProgressBarText(source, "vRP:hunger", lang.survival.starving())
        else
            vRPclient._setProgressBarText(source, "vRP:hunger", "")
        end
    end
end

function vRP.setThirst(user_id, value)
    local data = vRP.getUserDataTable(user_id)
    if data then
        data.thirst = value
        if data.thirst < 0 then
            data.thirst = 0
        elseif data.thirst > 100 then
            data.thirst = 100
        end

        -- update bar
        local source = vRP.getUserSource(user_id)
        vRPclient._setProgressBarValue(source, "vRP:thirst", data.thirst)
        if data.thirst >= 100 then
            vRPclient._setProgressBarText(source, "vRP:thirst", lang.survival.thirsty())
        else
            vRPclient._setProgressBarText(source, "vRP:thirst", "")
        end
    end
end

function vRP.varyHunger(user_id, variation)
    local data = vRP.getUserDataTable(user_id)
    if data then
        local was_starving = data.hunger >= 100
        data.hunger = data.hunger + variation
        local is_starving = data.hunger >= 100
        print("FOME " .. data.hunger)
        -- apply overflow as damage
        local overflow = data.hunger - 100
        if overflow > 0 then
            vRP.varyHealthScale(user_id, -overflow * cfg.overflow_damage_factor)
        end

        if data.hunger < 0 then
            data.hunger = 0
        elseif data.hunger > 100 then
            data.hunger = 100
        end

        -- set progress bar data
        local source = vRP.getUserSource(user_id)
        vRPclient._setProgressBarValue(source, "vRP:hunger", data.hunger)
        if was_starving and not is_starving then
            vRPclient._setProgressBarText(source, "vRP:hunger", "")
        elseif not was_starving and is_starving then
            vRPclient._setProgressBarText(source, "vRP:hunger", lang.survival.starving())
        end
    end
end

function vRP.varyThirst(user_id, variation)
    local data = vRP.getUserDataTable(user_id)
    if data then
        local was_thirsty = data.thirst >= 100
        data.thirst = data.thirst + variation
        local is_thirsty = data.thirst >= 100
        print("SEDE " .. data.thirst)
        -- apply overflow as damage
        local overflow = data.thirst - 100
        if overflow > 0 then
            vRP.varyHealthScale(user_id, -overflow * cfg.overflow_damage_factor)
        end

        if data.thirst < 0 then
            data.thirst = 0
        elseif data.thirst > 100 then
            data.thirst = 100
        end

        -- set progress bar data
        local source = vRP.getUserSource(user_id)
        vRPclient._setProgressBarValue(source, "vRP:thirst", data.thirst)
        if was_thirsty and not is_thirsty then
            vRPclient._setProgressBarText(source, "vRP:thirst", "")
        elseif not was_thirsty and is_thirsty then
            vRPclient._setProgressBarText(source, "vRP:thirst", lang.survival.thirsty())
        end
    end
end

-- tunnel api (expose some functions to clients)

function tvRP.varyHunger(variation)
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.varyHunger(user_id, variation)
    end
end

function tvRP.varyThirst(variation)
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.varyThirst(user_id, variation)
    end
end

-- tasks

-- hunger/thirst increase
function task_update()
    for k, v in pairs(vRP.users) do
        vRP.varyHunger(v, cfg.hunger_per_minute)
        vRP.varyThirst(v, cfg.thirst_per_minute)
        vRP.varyPee(v, cfg.pee_per_minute)
        vRP.varySleep(v, cfg.sleep_per_minute)
        vRP.varyHappiness(v,-cfg.happiness_per_minute)
        vRP.happinesHealthScale(v)
    end

    SetTimeout(60000, task_update)
end

async(function()
    task_update()
end)

-- handlers

-- init values
AddEventHandler("vRP:playerJoin", function(user_id, source, name, last_login)
    local data = vRP.getUserDataTable(user_id)
    local tempData = vRP.getUserTmpExtrasTable(user_id)
    local sleeping = {
        is = false,
        time  = 0,
    }
    local peeing = {
        is = false,
        time  = 0,
    }
    if data.hunger == nil then
        data.hunger = 0
        data.thirst = 0
        data.sleep = 0
        data.pee = 0
        data.happiness = 100
        data.health_scale = 200
        data.sleeping = sleeping
        data.peeing = peeing
        tempData.alcohol = 0
    end
end)

-- add survival progress bars on spawn
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local data = vRP.getUserDataTable(user_id)

    -- disable police
    vRPclient._setPolice(source, cfg.police)
    -- set friendly fire
    vRPclient._setFriendlyFire(source, cfg.pvp)

    vRPclient._setProgressBar(source, "vRP:hunger", "minimap", htxt, 255, 153, 0, 0)
    vRPclient._setProgressBar(source, "vRP:thirst", "minimap", ttxt, 0, 125, 255, 0)
    vRPclient._setProgressBar(source, "vRP:pee", "minimap", ptxt, 255, 153, 0, 0)
    vRPclient._setProgressBar(source, "vRP:sleep", "minimap", stxt, 0, 125, 255, 0)
    vRP.setHunger(user_id, data.hunger)
    vRP.setThirst(user_id, data.thirst)
    vRP.setPee(user_id, data.pee)
    vRP.setSleep(user_id, data.sleep)
    vRP.setHealthScale(user_id, data.health_scale)
    vRP.setHappiness(user_id, data.happiness)
end)

-- EMERGENCY

---- revive
local revive_seq = {
    { "amb@medic@standing@kneel@enter", "enter", 1 },
    { "amb@medic@standing@kneel@idle_a", "idle_a", 1 },
    { "amb@medic@standing@kneel@exit", "exit", 1 }
}

local choice_revive = { function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id then
        local nplayer = vRPclient.getNearestPlayer(player, 10)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id then
            if vRPclient.isInComa(nplayer) then
                if vRP.tryGetInventoryItem(user_id, "medkit", 1, true) then
                    vRPclient._playAnim(player, false, revive_seq, false) -- anim
                    SetTimeout(15000, function()
                        vRPclient._varyHealth(nplayer, 50) -- heal 50
                    end)
                end
            else
                vRPclient._notify(player, lang.emergency.menu.revive.not_in_coma())
            end
        else
            vRPclient._notify(player, lang.common.no_player_near())
        end
    end
end, lang.emergency.menu.revive.description() }

-- add choices to the main menu (emergency)
vRP.registerMenuBuilder("main", function(add, data)
    local user_id = vRP.getUserId(data.player)
    if user_id then
        local choices = {}
        if vRP.hasPermission(user_id, perm.emergency.revive()) then
            choices[lang.emergency.menu.revive.title()] = choice_revive
        end

        add(choices)
    end
end)
