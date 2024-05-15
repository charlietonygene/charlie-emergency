RegisterNetEvent("teleport")
AddEventHandler("teleport", function(destination)
    DoScreenFadeOut(3000)
    Citizen.Wait(3000)

    SetEntityCoords(PlayerPedId(), destination.x, destination.y, destination.z)

    Citizen.Wait(4000)
    DoScreenFadeIn(4000)

end)
