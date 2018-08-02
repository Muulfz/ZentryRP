local config = module("cfg/base")
local lang = vRP.lang
local serverLang = module("cfg/serverlang/" .. config.permlang)

function vRP.decimalRound(decimal, valor)
    local mult = 10^(decimal or 0)
    return math.floor(valor * mult --[[ + 0.5--]]) /mult
end

function vRP.getCurrency()
    vRP.getCurrencyTable()
    vRP.getCurrencyEspecialTable()
end

function vRP.getCurrencyTable()
    local data = vRP.getSCurrency("vRP:currency")
    vRP.currency = json.decode(data) or {}
end

function vRP.getCurrencyEspecialTable()
    local data = vRP.getSCurrency("vRP:currency_especial")
    vRP.currency_special = json.decode(data) or {}
end