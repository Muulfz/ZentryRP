--Created by Marmota#2533

local lang = vRP.lang
local cfg = module("cfg/temp")

vRP.prepare("vRP/srv_tmp_data",[[
CREATE TABLE IF NOT EXISTS vrp_srv_tmp_data(
  user_id INTEGER,
  dkey VARCHAR(100),
  dvalue TEXT,
  time INTEGER NOT NULL,
  CONSTRAINT pk_srv_tmp_data PRIMARY KEY(user_id,dkey),
  CONSTRAINT fk_srv_tmp_data FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);
]])

vRP.prepare("vRP/temp_init_user","INSERT IGNORE INTO vrp_srv_tmp_data(user_id,dkey,dvalue,time) VALUES(@user_id,@key,@value,@time)")
vRP.prepare("vRP/get_user_tmp_extras_data","SELECT dvalue FROM vrp_srv_tmp_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("vRP/set_user_tmp_extras_data", "UPDATE vrp_srv_tmp_data SET dvalue = @value WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("vRP/get_user_tmp_extras_timer", "SELECT time FROM vrp_srv_tmp_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("vRP/set_user_tmp_extras_timer", "UPDATE vrp_srv_tmp_data SET time = @time WHERE user_id = @user_id AND dkey = @key")

function vRP.getUserTmpExtrasTable(user_id)
    return vRP.user_tmp_extras[user_id]
end

function vRP.setUTmpExtrasData(user_id, key, value)
    vRP.execute("vRP/set_user_tmp_extras_data", {value = value, user_id = user_id, key = key})
end

function vRP.getUTmpExtrasData(user_id, key, cbr)
    local rows = vRP.query("vRP/get_user_tmp_extras_data", { user_id = user_id, key = key })
    if #rows > 0 then
        return rows[1].dvalue
    else
        return ""
    end
end

function vRP.setTmpExtraTimer(user_id, key, value)
    vRP.execute("vRP/set_user_tmp_extras_timer", {user_id = user_id, key = key, time = value})
end

function vRP.userTmpExtrasSave(user_id, data)
    local key = "vRP:tempData"
    local rows = vRP.query("vRP/get_user_tmp_extras_timer", {user_id = user_id, key = key })
    if #rows > 0  then
        local time = rows[1].time
        if time == 0 then
            vRP.setTmpExtraTimer(user_id, key, os.time())
        elseif os.time() >= time + cfg.resetTimer*60*60 then
            vRP.setUTmpExtrasData(user_id, key, json.encode({}))
            vRP.setTmpExtraTimer(user_id, key, os.time())
        else
            vRP.setUTmpExtrasData(user_id, key, json.encode(data))
        end
    else
        vRP.execute("vRP/temp_init_user", {user_id = user_id, key = key, value = json.encode(data), time = os.time()})
    end

end

function vRP.getAlcohol(user_id)
    local data = vRP.getUserTmpExtrasTable(user_id)
    if data then
        return data.alcohol
    end
    return 0
end

function vRP.setAlcohol(user_id, value)
    local data = vRP.getUserTmpExtrasTable(user_id)
    if data then
        data.alcohol = value
        if value < 0 then
            data.alcohol = 0
        elseif value > 100 then
            data.alcohol = 100
        end
    end
end


AddEventHandler("vRP:save", function()
    for k, v in pairs(vRP.user_tmp_extras) do
        vRP.userTmpExtrasSave(k, v)
    end
end)

AddEventHandler("vRP:playerLeave",function(user_id,source)
    local data = vRP.getUserTmpExtrasTable(user_id)
    if data then
        vRP.userTmpExtrasSave(user_id, data)
    end
end)