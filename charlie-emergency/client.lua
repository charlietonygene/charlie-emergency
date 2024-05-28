playerDestination = { -- a table of destinations that the player can be teleported to.
    {x = 3001.54, y = 1384.26, z = 43.91}, -- Annesburg docks
    {x = -3737.26, y = -2619.7, z = -13.22}, -- Armadillo trainstation
    {x = -735.13, y = -1227.07, z = 44.78}, -- Blackwater docks
    -- {x = -1355.94, y = 2400.12, z = 306.84}, -- Colter
    {x = 1221.49, y = -1297.34, z = 76.95}, -- Rhodes trainstation
    {x = 2680.82, y = -1456.32, z = 46.33}, -- St. Denis trainstation
    {x = -5559.92, y = -2869.81, z = -3.06}, -- Tumbleweed
    {x = -171.69, y = 628.1, z = 114.08} -- Valentine trainstation
}


RegisterNetEvent("emergency:teleport")
AddEventHandler("emergency:teleport", function(selectedDest)
    DoScreenFadeOut(3000)
    Citizen.Wait(3000)

    SetEntityCoords(PlayerPedId(), selectedDest.x, selectedDest.y, selectedDest.z)

    Citizen.Wait(4000)
    DoScreenFadeIn(4000)

end)

RegisterNetEvent("emergency:getDistance")
AddEventHandler("emergency:getDistance", function()
    -- player --
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local x, y, z = coords.x, coords.y, coords.z
    -- closest towns --
    local distance = {}

    for _, dest in ipairs(playerDestination) do
        local dist = Vdist(x, y, z, dest.x, dest.y, dest.z)
        table.insert(distance, dist)
    end
    table.sort(distance)

    local nearestDest = {}
    for i = 1, 3 do
        for _, dest in ipairs(playerDestination) do
        local dist = Vdist(x, y, z, dest.x, dest.y, dest.z)
            if dist == distance[i] then
                table.insert(nearestDest, dest)
                
                break
            end
        end
    end
    local selectedDest = nearestDest[math.random(#nearestDest)]
        TriggerServerEvent("emergency:getNearestTown", selectedDest, x, y, z)
        print("nearestDest " .. selectedDest.x .. ", " .. selectedDest.y .. ", " .. selectedDest.z)
end)
