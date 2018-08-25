local lang = vRP.lang

-- Money module, wallet/bank API
-- The money is managed with direct SQL requests to prevent most potential value corruptions
-- the wallet empty itself when respawning (after death)

vRP.prepare("vRP/money_tables", [[
CREATE TABLE IF NOT EXISTS vrp_user_moneys(
  user_id INTEGER,
  wallet DECIMAL(19 , 2) NOT NULL,
  bank DECIMAL(19 , 2) NOT NULL,
  wallet_usd DECIMAL(19 , 2) NOT NULL,
  bank_usd DECIMAL(19 , 2) NOT NULL,
  wallet_eur DECIMAL(19 , 2) NOT NULL,
  bank_eur DECIMAL(19 , 2) NOT NULL,
  bitcoin DECIMAL(19 , 8) NOT NULL,
  CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
  CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);
]])

vRP.prepare("vRP/money_init_user","INSERT IGNORE INTO vrp_user_moneys(user_id,wallet,bank,wallet_usd,bank_usd,wallet_eur,bank_eur,bitcoin) VALUES(@user_id,@wallet,@bank,@wallet_usd,@bank_usd,@wallet_eur,@bank_eur,@bitcoin)")
vRP.prepare("vRP/get_money","SELECT wallet,bank,wallet_usd,bank_usd,wallet_eur,bank_eur,bitcoin FROM vrp_user_moneys WHERE user_id = @user_id")
vRP.prepare("vRP/set_money","UPDATE vrp_user_moneys SET wallet = @wallet, bank = @bank, wallet_usd = @wallet_usd, bank_usd = @bank_usd, wallet_eur = @wallet_eur, bank_eur = @bank_eur, bitcoin = @bitcoin WHERE user_id = @user_id")

-- init tables
async(function()
  vRP.execute("vRP/money_tables")
end)

-- load config
local cfg = module("cfg/money")

-- API

-- get money
-- cbreturn nil if error
function vRP.getMoney(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet or 0
  else
    return 0
  end
end

-- get money usd
-- cbreturn nil if error
function vRP.getMoneyUSD(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet_usd or 0
  else
    return 0
  end
end

-- get money eur
-- cbreturn nil if error
function vRP.getMoneyEUR(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.wallet_eur or 0
  else
    return 0
  end
end

-- get bitcoin
-- cbreturn nil if error
function vRP.getBitcoin(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.bitcoin or 0
  else
    return 0
  end
end

-- set money
function vRP.setMoney(user_id,value)
  amount = decimalRound(2,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet = value
  end

  -- update client display
  local source = vRP.getUserSource(user_id)
  if source then
    vRPclient._setDivContent(source,"money",lang.money.display({value}))
  end
end

-- set money usd
function vRP.setMoneyUSD(user_id,value)
  amount = decimalRound(2,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet_usd = value
  end
end

-- set money eur
function vRP.setMoneyEUR(user_id,value)
  amount = decimalRound(2,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.wallet_eur = value
  end
end

-- set money eur
function vRP.setBitcoin(user_id,value)
  amount = decimalRound(8,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.bitcoin = value
  end
end

-- try a payment
-- return true or false (debited if true)
function vRP.tryPayment(user_id,amount)
  amount = decimalRound(2,amount)
  local money = vRP.getMoney(user_id)
  if amount >= 0 and money >= amount then
    vRP.setMoney(user_id,money-amount)
    return true
  else
    return false
  end
end

-- try a payment
-- return true or false (debited if true)
function vRP.tryPaymentUSD(user_id,amount)
  amount = decimalRound(2,amount)
  local money = vRP.getMoneyUSD(user_id)
  if amount >= 0 and money >= amount then
    vRP.setMoneyUSD(user_id,money-amount)
    return true
  else
    return false
  end
end

-- try a payment
-- return true or false (debited if true)
function vRP.tryPaymentEUR(user_id,amount)
  amount = decimalRound(2,amount)
  local money = vRP.getMoneyEUR(user_id)
  if amount >= 0 and money >= amount then
    vRP.setMoneyEUR(user_id,money-amount)
    return true
  else
    return false
  end
end

-- try a payment
-- return true or false (debited if true)
function vRP.tryPaymentBitcoin(user_id,amount)
  amount = decimalRound(8,amount)
  local money = vRP.getBitcoin(user_id)
  if amount >= 0 and money >= amount then
    vRP.setBitcoin(user_id,money-amount)
    return true
  else
    return false
  end
end

-- give money
function vRP.giveMoney(user_id,amount)
  amount = decimalRound(3,amount)
  if amount > 0 then
    local money = vRP.getMoney(user_id)
    vRP.setMoney(user_id,money+amount)
  end
end

-- give money
function vRP.giveMoneyUSD(user_id,amount)
  amount = decimalRound(2,amount)
  if amount > 0 then
    local money = vRP.getMoneyUSD(user_id)
    vRP.setMoneyUSD(user_id,money+amount)
  end
end
-- give money
function vRP.giveMoneyEUR(user_id,amount)
  amount = decimalRound(2,amount)
  if amount > 0 then
    local money = vRP.getMoneyEUR(user_id)
    vRP.setMoneyEUR(user_id,money+amount)
  end
end
-- give money
function vRP.giveBitcoin(user_id,amount)
  amount = decimalRound(8,amount)
  if amount > 0 then
    local money = vRP.getBitcoin(user_id)
    vRP.setBitcoin(user_id,money+amount)
  end
end
-- get bank money
function vRP.getBankMoney(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank or 0
  else
    return 0
  end
end

-- get bank money usd
function vRP.getBankMoneyUSD(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank_usd or 0
  else
    return 0
  end
end

-- get bank money eur
function vRP.getBankMoneyEUR(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.bank_eur or 0
  else
    return 0
  end
end

-- set bank money
function vRP.setBankMoney(user_id,value)
  amount = decimalRound(2,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.bank = value
  end
end

-- set bank money
function vRP.setBankMoneyUSD(user_id,value)
  amount = decimalRound(2,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.bank_usd = value
  end
end

-- set bank money
function vRP.setBankMoneyEUR(user_id,value)
  amount = decimalRound(2,value)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.bank_eur = value
  end
end

-- give bank money
function vRP.giveBankMoney(user_id,amount)
  amount = decimalRound(2,amount)
  if amount > 0 then
    local money = vRP.getBankMoney(user_id)
    vRP.setBankMoney(user_id,money+amount)
  end
end

-- give bank money
function vRP.giveBankMoneyUSD(user_id,amount)
  amount = decimalRound(2,amount)
  if amount > 0 then
    local money = vRP.getBankMoneyUSD(user_id)
    vRP.setBankMoneyUSD(user_id,money+amount)
  end
end

-- give bank money
function vRP.giveBankMoneyEUR(user_id,amount)
  amount = decimalRound(2,amount)
  if amount > 0 then
    local money = vRP.getBankMoneyEUR(user_id)
    vRP.setBankMoneyEUR(user_id,money+amount)
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function vRP.tryWithdraw(user_id,amount)
  amount = decimalRound(2,amount)
  local money = vRP.getBankMoney(user_id)
  if amount >= 0 and money >= amount then
    vRP.setBankMoney(user_id,money-amount)
    vRP.giveMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try a withdraw
-- return true or false (withdrawn if true)
function vRP.tryWithdrawUSD(user_id,amount)
  amount = decimalRound(2,amount)
  local money = vRP.getBankMoneyUSD(user_id)
  if amount >= 0 and money >= amount then
    vRP.setBankMoneyUSD(user_id,money-amount)
    vRP.giveMoneyUSD(user_id,amount)
    return true
  else
    return false
  end
end

-- try a deposit
-- return true or false (deposited if true)
function vRP.tryDeposit(user_id,amount)
  amount = decimalRound(2,amount)
  if amount >= 0 and vRP.tryPayment(user_id,amount) then
    vRP.giveBankMoney(user_id,amount)
    return true
  else
    return false
  end
end

-- try full payment (wallet + bank to complete payment)
-- return true or false (debited if true)
function vRP.tryFullPayment(user_id,amount)
  amount = decimalRound(2,amount)
  local money = vRP.getMoney(user_id)
  if money >= amount then -- enough, simple payment
    return vRP.tryPayment(user_id, amount)
  else  -- not enough, withdraw -> payment
    if vRP.tryWithdraw(user_id, amount-money) then -- withdraw to complete amount
      return vRP.tryPayment(user_id, amount)
    end
  end

  return false
end

-- events, init user account if doesn't exist at connection
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
  vRP.execute("vRP/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank,wallet_usd = cfg.open_usd, bank_usd = cfg.open_usd_bank, wallet_eur = cfg.open_eur, bank_eur = cfg.open_eur_bank, bitcoin = cfg.open_bitcoin})
  -- load money (wallet,bank)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    local rows = vRP.query("vRP/get_money", {user_id = user_id})
    if #rows > 0 then
      tmp.bank = rows[1].bank
      tmp.wallet = rows[1].wallet
      tmp.wallet_usd = rows[1].wallet_usd
      tmp.bank_usd = rows[1].bank_usd
      tmp.wallet_eur = rows[1].wallet_eur
      tmp.bank_eur = rows[1].bank_eur
      tmp.bitcoin = rows[1].bitcoin
    end
  end
end)

-- save money on leave
AddEventHandler("vRP:playerLeave",function(user_id,source)
  -- (wallet,bank)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp and tmp.wallet and tmp.bank and tmp.wallet_usd and tmp.wallet_eur and tmp.bitcoin and tmp.bank_usd and tmp.bank_eur then
    vRP.execute("vRP/set_money", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, wallet_usd = tmp.wallet_usd, bank_usd = tmp.bank_usd, wallet_eur = tmp.wallet_eur, bank_eur = tmp.bank_eur, bitcoin = tmp.bitcoin})
  end
end)

-- save money (at same time that save datatables)
AddEventHandler("vRP:save", function()
  for k,v in pairs(vRP.user_tmp_tables) do
    if v.wallet and v.bank and v.wallet_usd and v.bank_usd and v.wallet_eur and v.bank_eur and v.bitcoin then
      vRP.execute("vRP/set_money", {user_id = k, wallet = v.wallet, bank = v.bank, wallet_usd = v.wallet_usd, bank_usd = v.bank_usd, wallet_eur = v.wallet_eur,bank_eur = v.bank_eur, bitcoin = v.bitcoin})
    end
  end
end)

-- money hud
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    -- add money display
    vRPclient._setDiv(source,"money",cfg.display_css,lang.money.display({vRP.getMoney(user_id)}))
  end
end)

local function ch_give(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId(player)
  if user_id then
    local nplayer = vRPclient.getNearestPlayer(player,10)
    if nplayer then
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id then
        -- prompt number
        local amount = vRP.prompt(player,lang.give.prompt(),"")
        local amount = parseInt(amount)
        if amount > 0 and vRP.tryPayment(user_id,amount) then
          vRP.giveMoney(nuser_id,amount)
          vRPclient._notify(player,lang.money.given({amount}))
          vRPclient._notify(nplayer,lang.money.received({amount}))
        else
          vRPclient._notify(player,lang.money.not_enough())
        end
      else
        vRPclient._notify(player,lang.common.no_player_near())
      end
    else
      vRPclient._notify(player,lang.common.no_player_near())
    end
  end
end

-- add player give money to main menu
vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id then
    local choices = {}
    choices[lang.money.give.title()] = {ch_give, lang.money.give.description()}

    add(choices)
  end
end)
