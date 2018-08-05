---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Muulfz.
--- DateTime: 8/4/2018 18:44
---
local lang = vRP.lang

-----------------------------------------------------------------------------------
-----------------------------------CURRENCY----------------------------------------

vRP.prepare("vRP/currency_tables",[[
CREATE TABLE IF NOT EXISTS vrp_srv_currency(
  dkey VARCHAR(100),
  dvalue TEXT,
  last_time_update INTEGER,
  CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
);
]])
vRP.prepare("vRP/set_srvcurrency", "REPLACE INTO vrp_srv_currency(dkey,dvalue,last_time_update) VALUES(@key,@value,@last_time_update)")
vRP.prepare("vRP/get_srvcurrency", "SELECT dvalue FROM vrp_srv_currency WHERE dkey = @key")
vRP.prepare("vRP/get_srvcurrency_time", "SELECT last_time_update FROM vrp_srv_currency WHERE dkey = @key")

--[[print(lang.start.mysql.currency())
async(function ()
    vRP.getCurrency()
end)]]

-------------------------------------------------------------------------------------
-----------------------------------ADMINISTRATION------------------------------------

--                                 REPORT AND TICKET                               --

vRP.prepare("vRP/srv_ticket_tables",[[

CREATE TABLE IF NOT EXISTS vrp_srv_ticket
(
    ticket_id integer AUTO_INCREMENT,
    user_id integer,
    ticket varchar(255),
    date varchar(255),
    ingame_accept boolean,
    solved boolean,
    CONSTRAINT pk_srv_ticket PRIMARY KEY (ticket_id, user_id),
    CONSTRAINT vrp_srv_ticket_vrp_users_id_fk FOREIGN KEY (user_id) REFERENCES vrp_users (id) ON DELETE CASCADE
);
 ]])
vRP.prepare("vRP/srv_report_tables",[[

CREATE TABLE IF NOT EXISTS vrp_srv_report
(
    report_id integer AUTO_INCREMENT,
    user_id integer,
    report varchar(255),
    date varchar(255),
    close boolean,
    CONSTRAINT pk_srv_report PRIMARY KEY (report_id, user_id),
    CONSTRAINT vrp_srv_report_vrp_users_id_fk FOREIGN KEY (user_id) REFERENCES vrp_users (id) ON DELETE CASCADE
);
 ]])
vRP.prepare("vRP/srv_report_player_tables",[[
CREATE TABLE IF NOT EXISTS vrp_srv_report_player
(
    report_id integer AUTO_INCREMENT,
    user_id INTEGER,
    report varchar(255),
    date varchar(255),
    report_player integer,
    was_online BOOLEAN,
    close boolean,
    CONSTRAINT vrp_srv_report_player_pk PRIMARY KEY (report_id, user_id),
    CONSTRAINT vrp_srv_report_player_vrp_users_id_fk FOREIGN KEY (user_id) REFERENCES vrp_users (id) ON DELETE CASCADE

);
 ]])
vRP.prepare("vRP/create_srv_ticket", "INSERT INTO vrp_srv_ticket(user_id,ticket,date,ingame_accept,solved) VALUES(@user_id,@ticket,@date,@ingame_accept,@solved)")
-- vRP.prepare("vRP/get_srv_ticket", "SELECT t.* FROM vrp.vrp_srv_ticket t WHERE ticket_id = 1 ") --TODO Fazer isso ter sentido!
vRP.prepare("vRP/create_srv_report_player", "INSERT INTO vrp_srv_report_player(user_id,report,report_player,was_online,date,close) VALUE(@user_id,@report,@report_player,@was_online,@date,false)")
vRP.prepare("vRP/create_srv_report", "INSERT INTO vrp_srv_report(user_id,report,date,close) VALUES(@user_id,@report,@date,false)")

--------------------------------------------------------------------------------------
-------------------------------------SERVER DATA -------------------------------------
--
