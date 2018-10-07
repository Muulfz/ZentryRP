
description "RP module/framework"

ui_page "gui/index.html"

-- server scripts
server_scripts{ 
  "lib/utils.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/business.lua",
  "modules/item_transformer.lua",
  "modules/emotes.lua",
  "modules/police.lua",
  "modules/home.lua",
  "modules/home_components.lua",
  "modules/mission.lua",
  "modules/aptitude.lua",
  "modules/gps.lua",
  "modules/temp.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/basic_atm.lua",
  "modules/basic_market.lua",
  "modules/basic_sales.lua",
  "modules/basic_gunshop.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/cloakroom.lua",
  "modules/basic_radio.lua",
  "modules/base_checks.lua",
  "modules/menus/ActionMenus/PoliceMenu.lua",

  -- basic menu
  --BUTTONS
  "modules/buttons/admin.lua",
  "modules/buttons/phone.lua",
  "modules/buttons/player.lua",
  "modules/buttons/police.lua",
  "modules/buttons/static",

  -- ITEMS
  "modules/item/items.lua",
  --MENUS
  "modules/menus/admin.lua",
  "modules/menus/main.lua",
  "modules/menus/phone.lua",
  "modules/menus/player.lua",
  "modules/menus/police.lua",
  "modules/menus/static.lua",
  --MISSIONS
  "modules/missions/robbery.lua",
  "modules/missions/basic.lua",
  --STORE,
 -- "modules/stores/market_usd.lua",
  "modules/stores/barbershop.lua",
  "modules/stores/tattoos.lua",
  --VEHICLE
  "modules/vehicle/carwash.lua",
  --UTILS
  "modules/utils/admin.lua",
  "modules/utils/commands.lua",
  "modules/utils/dev.lua",
  "modules/utils/drugs.lua",
  "modules/utils/group_display.lua",
  "modules/utils/home_spawn.lua",
  "modules/utils/loadfreeze.lua",
  "modules/utils/logger.lua",
  "modules/utils/moneydrop.lua",
  "modules/utils/mysql.lua",
  "modules/utils/nocarjack.lua",
  "modules/utils/paycheck.lua",
  "modules/utils/phone.lua",
  "modules/utils/police.lua",
  "modules/utils/uuid.lua",
  "modules/currency/manager.lua",
  "modules/utils/economy.lua",
  "modules/currency/manager.lua",
  "modules/currency/money.lua"


}

-- client scripts
client_scripts{
  "lib/utils.lua",
  "lib/Clientluang.lua",
  "client/base.lua",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/police.lua",
  "client/admin.lua",
  "client/basic_phone.lua",
  "client/basic_radio.lua",
  "client/utils/admin.lua",
  "client/utils/player.lua",
  "client/utils/police.lua",
  "client/text.lua",
  "client/missions/basic.lua",
  "client/stores/barbershop.lua",
  "client/utils/moviment.lua",
  "client/utils/loadfreeze.lua",
  "client/utils/nocarjack.lua",
  "client/missions/robbery.lua",
  "client/utils/moneydrop.lua",
  "client/stores/tattoos.lua",
  "client/utils/voice_display.lua",
  "client/player/show_weapons.lua",
 -- "client/vehicle/speedometer.lua",
  "client/utils/npc_control.lua",
  "client/vehicle/carwash.lua",
  "client/utils/commands.lua"

}

-- client files
files{

    -- LIBARYS
  "lib/Tunnel.lua",
  "lib/Proxy.lua",
  "lib/Debug.lua",
  "lib/Luaseq.lua",
  "lib/Tools.lua",
  --GUI
  "gui/index.html",
  "gui/design.css",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/AudioEngine.js",
  "gui/lib/libopus.wasm.js",
  "gui/images/voice_active.png",
  "gui/sounds/phone_dialing.ogg",
  "gui/sounds/phone_ringing.ogg",
  "gui/sounds/phone_sms.ogg",
  "gui/sounds/radio_on.ogg",
  "gui/sounds/radio_off.ogg",
    -- CFGS
   ---DEFAULT
  "cfg/client.lua",
  -- Client
  "cfg/client/text.lua",
  ---LANG

  "cfg/lang/client/en.lua",
  "cfg/lang/missions/robbery/en.lua",
  ---STORES
  "cfg/stores/barbershop.lua",
  ---UTILS
  "cfg/utils/moneydrop.lua",
  "cfg/utils/nocarjack.lua",
  "cfg/utils/voice_display.lua",
  "cfg/utils/npc_control.lua",
  ---MISSIONS
  "cfg/missions/robbery.lua",
  ---PLAYER
  "cfg/player/show_weapons.lua",
}
