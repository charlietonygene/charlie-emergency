local VORPcore = exports.vorp_core:GetCore()

local webhookUrl = "" -- insert discord webhook URL here

function Log(message)
  local data = {
    content = message
  }

  PerformHttpRequest(webhookUrl, function(statusCode, response, headers)
  if statusCode == 200 then
  print ("Message Sent")
  else
  print("No. Status Code: " .. statusCode)
  end
end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json'})
end


local destinations = {
    {x = 3001.54, y = 1384.26, z = 43.91}, -- Annesburg docks
    {x = -3737.26, y = -2619.7, z = -13.22}, -- Armadillo trainstation
    {x = -735.13, y = -1227.07, z = 44.78}, -- Blackwater docks
    {x = -1355.94, y = 2400.12, z = 306.84}, -- Colter
    {x = 1221.49, y = -1297.34, z = 76.95}, -- Rhodes trainstation
    {x = 2680.82, y = -1456.32, z = 46.33}, -- St. Denis trainstation
    {x = -5559.92, y = -2869.81, z = -3.06}, -- Tumbleweed
    {x = -171.69, y = 628.1, z = 114.08} -- Valentine trainstation
}
    
local commandTimer = {}

RegisterCommand("emergency", function(source, args, rawCommand)
  local User = VORPcore.getUser(source)
  local Char = User.getUsedCharacter
  local playerName = Char.firstname .. " " .. Char.lastname
  print(playerName)
  local reason = table.concat(args, " ")
  local minLength = 10
  local message = string.format("%s triggered an emergency because %s", playerName, reason)

  local charId = Char.charIdentifier
      if reason and #reason >= minLength then
        Log(message)
        print(message)
      else
        VORPcore.NotifyTip(source, "[ERROR] Usage of '/emergency' requires a valid reason!                      /emergency [reason]", 7000)
        return
      end
      local currentTime = os.time()
      local destination = destinations[math.random(#destinations)]
       if commandTimer[charId] then
        local timer = os.difftime(currentTime, commandTimer[charId])
          if timer < 900 then
            VORPcore.NotifyFail(source, "You must wait 15 minutes between each use", "Please try again later!", 6000)
            return
          end
        end

    commandTimer[charId] = currentTime

    TriggerClientEvent("teleport", source, destination)

end)
