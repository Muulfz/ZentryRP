---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/11/2018 22:40
---

function vRP.isIDValid(user_id)
    local rows = vRP.query("vRP/user_id_exist", { id = user_id })
    if #rows > 0 then
        return true
    else
        return false
    end
end

function vRP.getLastLogin(user_id, cbr)
    local rows = vRP.query("vRP/get_last_login", { user_id = user_id })
    if #rows > 0 then
        return rows[1].last_login
    else
        return ""
    end
end
--- get all online users -  Steam ID --- ID
function vRP.getUsersOnline()
    local users = {}
    for k, v in pairs(vRP.users) do
        users[v] = k
    end
    return users
end
--- return true = plauer is online -- return false player ofline
function vRP.playerIsOnline(user_id)
    for _, v in pairs(vRP.users) do
        if v == user_id then
            return true
        end
    end
    return false
end

-- get all online users -  Steam ID --- ID
function vRP.getUsersOnline()
    local users = {}
    for k, v in pairs(vRP.users) do
        users[v] = k
    end
    return users
end
-- return true = plauer is online -- return false player ofline
function vRP.playerIsOnline(user_id)
    for _, v in pairs(vRP.users) do
        if v == user_id then
            return true
        end
    end
    return false
end

function vRP.isGroupValid(group)
    local groups = vRP.getGroups()
    if groups[group] then
        return true
    end
    return false
end

