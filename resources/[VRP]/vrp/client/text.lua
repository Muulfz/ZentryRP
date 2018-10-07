-- Credits: Marmota#2533
local config = module("cfg/client/text")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(config.text3D) do
            tvRP.draw3DText(v[1],v[2],v[3],v[4],v[5])
        end
    end
end)

function tvRP.draw3DText(x,y,z, text, maxDist)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*1
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen and GetDistanceBetweenCoords(px,py,pz, x,y,z) < maxDist then
        SetTextScale(0.7*scale, 1.2*scale)
        SetTextFont(2)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        World3dToScreen2d(x,y,z, 0)
        DrawText(_x,_y)
    end
end
