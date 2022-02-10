local timeLeft = 30
local lastCheckpoint = 1
local laps = 1
local checkpointsPassed = 0
local createCooldown = false
local inRace = false
local checkpoints = { -- ALWAYS SET PASSED TO FALSE, map for these checkpoints is: https://www.gta5-mods.com/maps/kart-race-airport-ymap, credit to Patoche
    {coords = vector3(-1040.3065185547,-3478.8151855469,13.31156539917), passed = false},
    {coords = vector3(-1046.7602539063,-3486.8466796875,13.313842773438),passed = false},
    {coords = vector3(-1043.6724853516,-3498.6240234375,13.311761856079),passed = false},
    {coords = vector3(-1069.521484375,-3475.3002929688,13.30966091156),passed = false},
    {coords = vector3(-1089.6821289063,-3451.72265625,13.11278629303),passed = false},
    {coords = vector3(-1107.4678955078,-3481.2976074219,13.161387443542),passed = false},
    {coords = vector3(-1100.4595947266,-3510.47265625,13.311024665833),passed = false},
    {coords = vector3(-1087.7504882813,-3515.5727539063,13.31242275238),passed = false},
    {coords = vector3(-1058.2717285156,-3535.0148925781,13.307384490967),passed = false},
    {coords = vector3(-1047.5717773438,-3525.8728027344,15.769262313843),passed = false},
    {coords = vector3(-1059.0695800781,-3531.5087890625,18.83674621582),passed = false},
    {coords = vector3(-1037.3520507813,-3542.2487792969,18.831212997437),passed = false},
    {coords = vector3(-1019.1055908203,-3529.318359375,15.996699333191),passed = false},
    {coords = vector3(-1027.9384765625,-3489.0173339844,13.323768615723),passed = false}
}

Citizen.CreateThread(function()   
    local sleep = 1000
    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        if #(pedCoords - cfg.locations.startLocation) < 10 then
            sleep = 0
            DrawMarker(27, cfg.locations.startLocation, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 251, 0, 1.0, false, true, 2, false, nil, nil, false)
            if #(pedCoords - cfg.locations.startLocation) < 2 then
                alert("Press ~INPUT_CONTEXT~ to queue for GoKarting!")
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("GoKart:updateTable")

                end
            end
        else
            sleep = 0
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        ClearAreaOfVehicles(cfg.locations.startLocation, 100.0, false, false, false, false, false)
        ClearAreaOfPeds(cfg.locations.startLocation, 100.0, 1);
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    timeLeft = 0
    while true do
        while timeLeft > 0 do
            timeLeft = timeLeft - 1
            Citizen.Wait(1000)
        end
        Wait(1000)
    end
    
end)

RegisterNetEvent("GoKart:GoKartStarted")
AddEventHandler("GoKart:GoKartStarted", function()
    TriggerServerEvent("GoKart:GoKartStart")
    while not HasModelLoaded(cfg.gameSettings.vehicleModel) do 
        RequestModel(cfg.gameSettings.vehicleModel)
        Wait(0) 
    end
end)

RegisterNetEvent("GoKart:NotifyEndPosition")
AddEventHandler("GoKart:NotifyEndPosition", function(position)
    if position == 1 then
        notify("~g~You finished 1st place!")
    elseif position == 2 then
        notify("~g~You finished in " .. position .. "nd place")
    elseif position == 3 then
        notify("~g~You finished in " .. position .. "rd place")
    else
        notify("~r~You finished in " .. position .. "th place")
    end
end)

function disp_time(time)
    local minutes = math.floor((time % 3600) /60)
    local seconds = math.floor(time % 60)
    return string.format("%02d:%02d",minutes,seconds)
  end

RegisterNetEvent("GoKart:startCountdown")
AddEventHandler("GoKart:startCountdown", function(kartId)
    local goKart = NetworkGetEntityFromNetworkId(kartId)
    Citizen.Wait(500)
    SetPedIntoVehicle(PlayerPedId(), goKart, -1)
    FreezeEntityPosition(goKart, true)
    showCountdown2(255, 0, 0, 3, true)
    Citizen.Wait(3000)
    FreezeEntityPosition(goKart, false)
    
    inRace = true
    while true do
        if inRace then
            DisablePlayerFiring(PlayerPedId(),true)
            DisableControlAction(2, 75, true)
            DisableControlAction(2, 37, true)
            DisableControlAction(2, 68, true)
            DisableControlAction(2, 261, true)
            DisableControlAction(2, 262, true)
        else
            break
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    local sleep = 1000
    while true do
        if inRace then
            sleep = 0
            DrawRect(0.944, 0.886, 0.081, 0.032, 0, 0, 0, 150)
            DrawAdvancedNativeText(1.013, 0.892, 0.005, 0.0028, 0.29, "LAP:", 255, 255, 255, 255, 0, 0)
            DrawAdvancedNativeText(1.05, 0.885, 0.005, 0.0028, 0.464, tostring(laps) .. "/" .. tostring(cfg.gameSettings.lapsInRace), 255, 255, 255, 255, 0, 0)
        else
            sleep = 1000
        end
        Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local sleep = 1000
    while true do
        if inRace then
            sleep = 0
            for k, v in pairs(checkpoints) do
                v.passed = false
                if isLastCheckpoint(k, checkpoints, laps) then
                    checkpoint = CreateCheckpoint(16, v.coords.x, v.coords.y, v.coords.z + 2, checkpoints[1].coords, 6.0, cfg.gameSettings.checkPointColour.r, cfg.gameSettings.checkPointColour.g, cfg.gameSettings.checkPointColour.b, cfg.gameSettings.checkPointColour.a, 0)
                elseif isLastCheckpoint(k, checkpoints, laps) == nil then
                    checkpoint = CreateCheckpoint(47, v.coords, checkpoints[1].coords, 6.0, cfg.gameSettings.checkPointColour.r, cfg.gameSettings.checkPointColour.g, cfg.gameSettings.checkPointColour.b, cfg.gameSettings.checkPointColour.a, 0)
                elseif isLastCheckpoint(k, checkpoints, laps) == false then
                    checkpoint = CreateCheckpoint(47, v.coords, checkpoints[k].coords, 6.0, cfg.gameSettings.checkPointColour.r, cfg.gameSettings.checkPointColour.g, cfg.gameSettings.checkPointColour.b, cfg.gameSettings.checkPointColour.a, 0)
                end
                local ped = PlayerPedId()
                while not v.passed do
                    if #(GetEntityCoords(ped) - cfg.locations.locToRadiusCheckFrom) > cfg.gameSettings.radiusToCheck then
                        if IsPedInAnyVehicle(ped, false) then
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            local vehModel = GetEntityModel(vehicle)
                            if cfg.gameSettings.vehicleModel == vehModel then
                                SetEntityCoords(vehicle, checkpoints[lastCheckpoint].coords, true, true, false, false)
                                notify("~r~You tried to leave the GoKart track!")
                            elseif not cfg.gameSettings.vehicleModel == vehModel and createCooldown == false then
                                createCooldown = true
                                TriggerServerEvent("GoKart:LeaveCreateVehicle", checkpoints[lastCheckpoint].coords)    
                                Citizen.SetTimeout(10000, function()
                                    createCooldown = false
                                end)  
                            end
                        
                        elseif not createCooldown then

                            createCooldown = true
                            TriggerServerEvent("GoKart:LeaveCreateVehicle", checkpoints[lastCheckpoint].coords) 
                            Citizen.SetTimeout(10000, function()
                                createCooldown = false
                            end)
                        end
                    else    
                        
                        if #(GetEntityCoords(ped) - v.coords) < 6 then
                            v.passed = true
                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                            SetVehicleEngineHealth(vehicle, 9999)
		                    SetVehiclePetrolTankHealth(vehicle, 9999)
		                    SetVehicleFixed(vehicle)
                            lastCheckpoint = k
                            PlaySoundFrontend(-1, "Checkpoint", "DLC_AW_Frontend_Sounds", true)
                            DeleteCheckpoint(checkpoint)
                            checkpointsPassed = checkpointsPassed + 1
                            if k == tablelength(checkpoints) then
                                if laps == cfg.gameSettings.lapsInRace then
                                    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 0.0, 0.0, 0.0, 0, 0, 0, 90)
                                    SetCamActive(cam, true)
                                    RenderScriptCams(true, false, 0, true, false)
                                    SetCamAffectsAiming(cam, false)
                                    SetFocusEntity(GetVehiclePedIsIn(ped))
                                    SetTimecycleModifier("MP_race_finish")
                                    TaskVehicleDriveToCoordLongrange(ped, GetVehiclePedIsIn(ped, false), checkpoints[2].coords, 5.0, 33, 3.0)
                                    inRace = false
                                    Citizen.Wait(1000)
                                    ClearTimecycleModifier("MP_race_finish")
                                    RenderScriptCams(0, 0, 1, 1, 1)
                                    DestroyCam(cam, false)
                                    SetFocusEntity(ped)
                                    TriggerServerEvent("GoKart:UpdateWinnerTable")
                                    SetEntityCoords(ped, cfg.locations.spawnLocAfterGame, true, true, false, false)
                                    FreezeEntityPosition(ped, false)
                                    checkpointsPassed = 0
                                    laps = 1
                                    lastCheckpoint = 1
                                    break
                                end
                                laps = laps + 1
                            end
                            
                        end
                    end
                    
                    Wait(sleep)
                end
            end
        else
            sleep = 1000
        end
        Wait(sleep)
    end
    
end)


RegisterNetEvent("GoKart:JoinedQueue")
AddEventHandler("GoKart:JoinedQueue", function(timer)
    notify("~g~You have joined the queue.")
    timeLeft = timer
    while true do
        local timeLeftDisplay = disp_time(timeLeft)
            DrawRect(0.944, 0.886, 0.081, 0.032, 0, 0, 0, 150)
            DrawAdvancedNativeText(1.013, 0.892, 0.005, 0.0028, 0.29, "TIME:", 255, 255, 255, 255, 0, 0)
            DrawAdvancedNativeText(1.05, 0.885, 0.005, 0.0028, 0.464, tostring(timeLeftDisplay), 255, 255, 255, 255, 0, 0)
        if timeLeft == 0 then
            break
        end
    Wait(0)
    end
end)

RegisterNetEvent("GoKart:InQueue")
AddEventHandler("GoKart:InQueue", function()
    notify("~g~You have joined the queue.")
end)

RegisterNetEvent("GoKart:SlotsFilled")
AddEventHandler("GoKart:SlotsFilled", function()
    notify("~r~The queue for GoKarting is full.")
end)
