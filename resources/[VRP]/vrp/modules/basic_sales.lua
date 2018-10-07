-- a basic market implementation

local lang = vRP.lang
local money = module("modules/currency/money")
local currency = module("modules/currency/manager")
local cfg = module("cfg/sales")
local sale_types = cfg.sale_types
local sales = cfg.sales
local sale_menus = {}


-- build sale menus
local function build_sale_menus()
  local config = module("cfg/sales")
  local sale_types_ = config.sale_types
--[[  local icms = vRP.getICMS()
  local tax = vRP.getIPI()
  local dolar = vRP.getUSDtoBRL()]]
  for gtype,mitems in pairs(sale_types_) do
    local sale_menu = {
      name=lang.sale.title({gtype}),
      css={top = "75px", header_color="rgba(0,255,125,0.75)"}
    }

    -- build sale items
    local kitems = {}

    -- item choice
    local sale_choice = function(player,choice)
      local idname = kitems[choice][1]
      local item_name, item_desc, item_weight = vRP.getItemDefinition(idname)
      local price = kitems[choice][2]
      --price = price * dolar
      --price = (price * tax)*icms
      --price = format_num(price,2)

      if item_name then
        -- prompt amount
        local user_id = vRP.getUserId(player)
        if user_id then
          local amount = vRP.prompt(player,lang.sale.prompt({item_name}),"")
          local amount = parseInt(amount)
          if amount > 0 then
            -- weight check
            local new_weight = vRP.getInventoryWeight(user_id)+item_weight*amount
            if new_weight <= vRP.getInventoryMaxWeight(user_id) then
              -- payment
              print(sale_types_[gtype]._config.money_type)
                local moneyType = sale_types_[gtype]._config.money_type
                if moneyType == "default" or moneyType == nil then
                    if vRP.tryGetInventoryItem(user_id,idname,amount,true) then
                        vRP.giveMoney(user_id,amount*price)
                        vRPclient._notify(player,lang.money.paid({amount*price}))
                    else
                        vRPclient._notify(player,lang.money.not_enough())
                    end
                elseif moneyType == "USD" then
                    if vRP.tryGetInventoryItem(user_id,idname,amount,true) then
                        vRP.giveMoneyUSD(user_id,amount*price)
                        vRPclient._notify(player,lang.money.paid({amount*price}))
                    else
                        vRPclient._notify(player,lang.money.not_enough())
                    end
                elseif moneyType == "EUR" then
                    if vRP.tryGetInventoryItem(user_id,idname,amount,true) then
                        vRP.giveMoneyEUR(user_id,amount*price)
                        vRPclient._notify(player,lang.money.paid({amount*price}))
                    else
                        vRPclient._notify(player,lang.money.not_enough())
                    end
                elseif moneyType == "BTC" then
                    if vRP.tryGetInventoryItem(user_id,idname,amount,true) then
                        vRP.giveMoneyBitcoin(user_id,amount*price)
                        vRPclient._notify(player,lang.money.paid({amount*price}))
                    else
                        vRPclient._notify(player,lang.money.not_enough())
                    end
                end
            else
              vRPclient._notify(player,lang.inventory.full())
            end
          else
            vRPclient._notify(player,lang.common.invalid_value())
          end
        end
      end
    end

    -- add item options
    for k,v in pairs(mitems) do
      local item_name, item_desc, item_weight = vRP.getItemDefinition(k)
      if item_name then
        kitems[item_name] = {k,math.max(v,0)} -- idname/price
        --v =  ((v * dolar)* tax) * icms
        v = format_num(v,2)
        sale_menu[item_name] = {sale_choice,lang.sale.info({v,item_desc})}
      end
    end

    sale_menus[gtype] = sale_menu
  end
end

local first_build = true

local function build_client_sales(source)
  -- prebuild the sale menu once (all items should be defined now)
  if first_build then
    build_sale_menus()
    first_build = false
  end

  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(sales) do
      local gtype,x,y,z = table.unpack(v)
      local group = sale_types[gtype]
      local menu = sale_menus[gtype]

      if group and menu then -- check sale type
        local gcfg = group._config

        local function sale_enter(source)
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and vRP.hasPermissions(user_id,gcfg.permissions or {}) then
            vRP.openMenu(source,menu) 
          end
        end

        local function sale_leave(source)
          vRP.closeMenu(source)
        end

        vRPclient._addBlip(source,x,y,z,gcfg.blipid,gcfg.blipcolor,lang.sale.title({gtype}))
        vRPclient._addMarker(source,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150)

        vRP.setArea(source,"vRP:sale"..k,x,y,z,1,1.5,sale_enter,sale_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_sales(source)
  end
end)
