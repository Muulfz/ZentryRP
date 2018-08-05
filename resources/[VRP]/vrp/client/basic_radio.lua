local lang = tvRP.lang
local rplayers = {} -- radio players that can be accepted

function tvRP.setupRadio(players)
  rplayers = players
end

function tvRP.disconnectRadio()
  rplayers = {}
  tvRP.disconnectVoice("radio", nil)
end

-- radio channel behavior
tvRP.registerVoiceCallbacks("radio", function(player)
  print(lang.radio.callback..player)
  return (rplayers[player] ~= nil)
end,
function(player, is_origin)
  print(lang.radio.connected..player)
end,
function(player)
  print(lang.radio.disconnected..player)
end)

AddEventHandler("vRP:NUIready", function()
  -- radio channel config
  tvRP.configureVoice("radio", cfg.radio_voice_config)
end)

-- radio push-to-talk
local talking = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    local old_talking = talking
    talking = IsControlPressed(table.unpack(cfg.controls.radio))

    if old_talking ~= talking then
      tvRP.setVoiceState("world", nil, talking)
      tvRP.setVoiceState("radio", nil, talking)
    end
  end
end)
