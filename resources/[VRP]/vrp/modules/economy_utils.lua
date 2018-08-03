local config = module("cfg/base")
local lang = vRP.lang
local serverLang = module("cfg/serverlang/" .. config.permlang)

function vRP.decimalRound(decimal, valor)
    local mult = 10^(decimal or 0)
    return math.floor(valor * mult --[[ + 0.5--]]) /mult
end

function vRP.getCurrency()
    vRP.getCurrencyEspecialTable()
    vRP.getCurrencyTable()
end

function vRP.getCurrencyTable()
    local data = vRP.getSCurrency("vRP:currency")
    vRP.currency = json.decode(data) or {}
    end

function vRP.getCurrencyEspecialTable()
    local data = vRP.getSCurrency("vRP:currencyspecial")
    print(data)
    vRP.currencySpecial = json.decode(data) or {}
end

----- CURRENCY INFOS

function vRP.getTableCurrency()
    return vRP.currency
end

function vRP.getTableCurrencySpecial()
    return vRP.currencySpecial
end

function vRP.getUSDtoBRL()
    local cur = vRP.currency.usd.inverseRate
    return vRP.decimalRound(2,cur)
end

function vRP.getBRLtoUSD()
    local cur = vRP.currency.usd.rate
    return vRP.decimalRound(2,cur)
end

function vRP.getEURtoBRL()
    local cur = vRP.currency.eur.inverseRate
    return  vRP.decimalRound(2,cur)
end

function vRP.getBRLtoEUR()
    local cur = vRP.currency.eur.rate
    return vRP.decimalRound(2,cur)
end

function vRP.getGBPtoBRL()
    local cur = vRP.currency.gbp.inverseRate
    return vRP.decimalRound(2,cur)
end

function vRP.getBRLtoGBP()
    local cur = vRP.currency.gbp.rate
    return vRP.decimalRound(2,cur)
end

function vRP.getEURtoUSD()
    local cur = vRP.currencySpecial.rates.USD
    return vRP.decimalRound(2,cur)
end

function vRP.getUSDtoEUR()
    local cur = (1/vRP.currencySpecial.rates.USD)
    return vRP.decimalRound(2,cur)
end

function vRP.getXAUGramstoEUR()
    local cur = (vRP.currencySpecial.rates.XAU/28.3495)*1000000
    return vRP.decimalRound(2,cur)
end

function vRP.getXAUGramstoBR()
    local cur = ((vRP.currencySpecial.rates.XAU/28.3495)*1000000)*vRP.currency.eur.inverseRate
    return vRP.decimalRound(2,cur)
end

function vRP.getXAUGramstoUSD()
    local cur = ((vRP.currencySpecial.rates.XAU/28.3495)*1000000)*vRP.currencySpecial.rates.USD
    return vRP.decimalRound(2,cur)
end

function vRP.getXAGGramstoEUR()
    local cur = (vRP.currencySpecial.rates.XAG/28.3495)*1000000
    return vRP.decimalRound(2,cur)
end

function vRP.getXAGGramstoBR()
    local cur = ((vRP.currencySpecial.rates.XAG/28.3495)*1000000)*vRP.currency.eur.inverseRate
    return vRP.decimalRound(2,cur)
end

function vRP.getXAGGramstoUSD()
    local cur = ((vRP.currencySpecial.rates.XAG/28.3495)*1000000)*vRP.currencySpecial.rates.USD
    return vRP.decimalRound(2,cur)
end

function vRP.getBTCtoEUR()
    local cur = (1/vRP.currencySpecial.rates.BTC)
    return vRP.decimalRound(2,cur)
end

function vRP.getBTCtoBR()
    local cur = (1/vRP.currencySpecial.rates.BTC)*vRP.currency.eur.inverseRate
    return vRP.decimalRound(2,cur)
end

function vRP.getBTCtoUSD()
    local cur = (1/vRP.currencySpecial.rates.BTC)*(1/vRP.currencySpecial.rates.USD)
    return vRP.decimalRound(2,cur)
end

function vRP.getXDRtoEUR()
    local cur = (1/vRP.currencySpecial.rates.XDR)
    return vRP.decimalRound(2,cur)
end

function vRP.getXDRtoBR()
    local cur = (1/vRP.currencySpecial.rates.XDR)*vRP.currency.eur.inverseRate
    return vRP.decimalRound(2,cur)
end

function vRP.getXDRtoUSD()
    local cur = (1/vRP.currencySpecial.rates.XDR)*(1/vRP.currencySpecial.rates.USD)
    return vRP.decimalRound(2,cur)
end


