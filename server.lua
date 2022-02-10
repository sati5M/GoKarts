
local playerQueue = {}
local existingKarts = {}
local winnersTable = {}
local timer = cfg.gameSettings.queueTimer
local index = 1
local players = 1
local countdownOnGoing = false
local gameOnGoing = false

RegisterNetEvent("GoKart:updateTable")
AddEventHandler("GoKart:updateTable", function()
    local source = source
    local playersQueued = tablelength(playerQueue)

    if gameOnGoing then
        TriggerClientEvent("GoKart:GameOngoing", source)
        return
    end
    
    if playersQueued > 0 then
        for k, v in pairs(playerQueue) do
            if v.tempid == source then
                TriggerClientEvent("GoKart:alreadyInQueue", source)
                return false
            end
        end

        if playersQueued >= cfg.gameSettings.maxPlayers then
            TriggerClientEvent("GoKart:SlotsFilled", source)
            return false
        else
            
        TriggerClientEvent("GoKart:JoinedQueue", source, timer)
        playerQueue[index] = {tempid = source}
        index = index + 1
        if not countdownOnGoing then
            countdownOnGoing = true
            Wait(timer / 1000)
            startCountdown()
            countdownOnGoing = false
            
        end
        end
    else
        TriggerClientEvent("GoKart:JoinedQueue", source, timer)
        playerQueue[index] = {tempid = source}
        index = index + 1
        if not countdownOnGoing then
            countdownOnGoing = true
            Wait(timer / 1000)
            startCountdown()
            countdownOnGoing = false
        end
        return
    end
end)

RegisterNetEvent("GoKart:LeaveCreateVehicle")
AddEventHandler("GoKart:LeaveCreateVehicle", function(coords)
    local source = source
    local goKart = Citizen.InvokeNative(`CREATE_AUTOMOBILE` & 0xFFFFFFFF, cfg.gameSettings.vehicleModel, coords.x, coords.y, coords.z + 1, 60.19)
    Wait(200)
    local kartId = NetworkGetNetworkIdFromEntity(goKart)
    for k, v in pairs(existingKarts) do
        if v.tempid == source then
           
            if DoesEntityExist(NetworkGetEntityFromNetworkId(v.kartId)) then
                DeleteEntity(NetworkGetEntityFromNetworkId(v.kartId))
                v.kartId = kartId
            else
                v.kartId = kartId
            end
            break
        end
    end

    SetPedIntoVehicle(GetPlayerPed(source), goKart, -1)
end)

RegisterNetEvent("GoKart:GoKartStart")
AddEventHandler("GoKart:GoKartStart", function()
    if not gameOnGoing then
        gameOnGoing = true
        startGame()
    end
end)

function startGame()
    for k, v in pairs(playerQueue) do 
        if tablelength(existingKarts) == tablelength(playerQueue) then
            break
        else
            if k > tablelength(playerQueue) then
                
            else
                
            local goKart = Citizen.InvokeNative(`CREATE_AUTOMOBILE` & 0xFFFFFFFF, cfg.gameSettings.vehicleModel, cfg.locations.spawnpoints[k], 60.19)
            Wait(50)
            local kartId = NetworkGetNetworkIdFromEntity(goKart)
            existingKarts[k] = {kartId = kartId, tempid = v.tempid}
            TriggerClientEvent("GoKart:startCountdown", v.tempid, kartId)
            end
            
        end
    end
playerQueue = {}
end

RegisterCommand(cfg.gameSettings.resetCommand, function(source, args, raw)
    if IsPlayerAceAllowed(source, cfg.gameSettings.acePerm) then
        playerQueue = {}
        existingKarts = {}
        winnersTable = {}
        gameOnGoing = false
        countdownOnGoing = false 
        timer = cfg.gameSettings.queueTimer
        players = 1    
        index = 1
    else
        print(source .. " tried to reset gokart")
    end
end)

RegisterNetEvent("GoKart:UpdateWinnerTable")
AddEventHandler("GoKart:UpdateWinnerTable", function()
    local source = source
        for k, v in pairs(existingKarts) do
            if v.tempid == source then
                DeleteEntity(NetworkGetEntityFromNetworkId(v.kartId))
                table.insert(winnersTable, source)
                if tablelength(winnersTable) == tablelength(existingKarts) then
                    for k2, v2 in pairs(winnersTable) do

                        TriggerClientEvent("GoKart:NotifyEndPosition", v2, k2)
                        playerQueue = {}
                        existingKarts = {}
                        winnersTable = {}
                        gameOnGoing = false
                        countdownOnGoing = false 
                        timer = cfg.gameSettings.queueTimer
                        players = 1    
                        index = 1
                    end
                end
                
                break
            end
        end  
 
end)

RegisterNetEvent("GoKart:RemoveFromTable")
AddEventHandler("GoKart:RemoveFromTable", function()
    local source = source

    for k, v in pairs(existingKarts) do
        if v.tempid == source then
            existingKarts[k] = nil
        end
    end
end)


function startCountdown()
    while timer > 0 do
        timer = timer - 1
        Wait(1000)
    end
    local playersQueued = tablelength(playerQueue)
    if playersQueued >= cfg.gameSettings.minPlayers then
        for i = 1, #playerQueue do
            if players > i then
                players = 1
                break
            else
                players = players + 1
                TriggerClientEvent("GoKart:GoKartStarted", playerQueue[i].tempid)
            end
        end        
    else
        for k, v in pairs(playerQueue) do
            TriggerClientEvent("GoKart:NotEnoughPlayers", playerQueue[k].tempid)
            timer = 5
            end
        end
end



function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

