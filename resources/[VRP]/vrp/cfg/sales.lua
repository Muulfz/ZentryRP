local economy = module("modules/utils/economy")
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, money_type,permissions (optional, only users with the permission will have access to the market)
-- money_type : options -default,USD,EUR,


cfg.sale_types = {
  ["Teste"] = {
    _config = {blipid=52, blipcolor=2, money_type = "USD"},

    -- list itemid => price
    -- Drinks
    ["milk"] = 2,
    ["water"] = 2,
    ["coffee"] = 4,
    ["tea"] = 4,
    ["icetea"] = 8,
    ["orangejuice"] = 8,
    ["gocagola"] = 12,
    ["redgull"] = 12,
    ["lemonlimonad"] = 14,
    ["vodka"] = 15,

    --Food
    ["bread"] = 2,
    ["donut"] = 2,
    ["tacos"] = 8,
    ["sandwich"] = 20,
    ["kebab"] = 20,
    ["pdonut"] = 65,
  },
  ["drugstore"] = {
    _config = {blipid=51, blipcolor=2},
    ["medkit"] = 75,
    ["pills"] = 10
  },
  ["tools"] = {
    _config = {blipid=51, blipcolor=47},
    ["repairkit"] = 50
  },
  ["TCG"] = { -- need vRP-TCG extension
    _config = {blipid=408, blipcolor=2},
    ["tcgbooster|0|5"] = 10,
    ["tcgbooster|1|5"] = 100,
    ["tcgbooster|2|5"] = 1000,
    ["tcgbooster|3|5"] = 10000,
    ["tcgbooster|4|5"] = 100000
  }
}

-- list of saless {type,x,y,z}

cfg.sales = {
  {"Teste",1966.3658447266,3703.4638671875,32.262638092041}
}

return cfg
