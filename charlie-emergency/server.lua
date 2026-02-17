local VORPcore = exports.vorp_core:GetCore()
local selectedDest
local oldPosX
local oldPosY
local oldPosZ
local town

local webhookUrl = ""

function Log(message)
  local data = {
    content = message
  }

  PerformHttpRequest(webhookUrl, function(statusCode, response, headers)
  if statusCode == 200 then
  print ("Message Sent")
  else
  print("Status Code: " .. statusCode)
  end
end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json'})
end

RegisterNetEvent("emergency:getNearestTown")
AddEventHandler("emergency:getNearestTown", function(dest, x, y, z)
  print("dest: " .. json.encode(dest) .. "x: " .. x .. "y:" .. y .. "z: " .. z)
  selectedDest = dest
  oldPosX = x
  oldPosY = y
  oldPosZ = z
  if selectedDest.x == 3001.54 then
    town = "Annesburg"
  elseif selectedDest.x == -3737.26 then
    town = "Armadillo"
  elseif selectedDest.x == -735.13 then
    town = "Blackwater"
  elseif selectedDest.x == 1221.49 then
    town = "Rhodes"
  elseif selectedDest.x == 2680.82 then
    town = "St. Denis"
  elseif selectedDest.x == -5559.92 then
    town = "Tumbleweed"
  elseif selectedDest.x == -171.69 then
    town = "Valentine"
  end
end)
    
local commandTimer = {}

RegisterCommand("emergency", function(source, args, rawCommand)
  local User = VORPcore.getUser(source)
  local Char = User.getUsedCharacter
  local playerName = Char.firstname .. " " .. Char.lastname
  local reason = table.concat(args, " ")
  local minLength = 10
  TriggerClientEvent("emergency:getDistance", source)
  Wait(500)

  local message = string.format("%s triggered an emergency because %s. Teleported to %s (%f, %f, %f) from (%f, %f, %f) ", playerName, reason, town, selectedDest.x, selectedDest.y, selectedDest.z, oldPosX, oldPosY, oldPosZ)

  local charId = Char.charIdentifier
      if reason and #reason >= minLength then
        Log(message)
        -- print(message)
      else
        VORPcore.NotifyTip(source, "[ERROR] Usage of '/emergency' requires a valid reason!                      /emergency [reason]", 7000)
        return
      end
      local currentTime = os.time()

       if commandTimer[charId] then
        local timer = os.difftime(currentTime, commandTimer[charId])
          if timer < 900 then
            VORPcore.NotifyFail(source, "You must wait 15 minutes between each use", "Please try again later!", 6000)
            return
          end
        end

    commandTimer[charId] = currentTime
    print("Destination Selected: " .. selectedDest.x .. ", " .. selectedDest.y .. ", " .. selectedDest.z .. ", " .. town)
    TriggerClientEvent("emergency:teleport", source, selectedDest)

end)
